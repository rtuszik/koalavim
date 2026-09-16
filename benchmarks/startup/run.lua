local uv = vim.uv

local script_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p")
local here = vim.fs.dirname(vim.fs.normalize(script_path))
local default_root = vim.fs.dirname(vim.fs.dirname(here))

local function fail(message)
    error(message, 0)
end

local function parse_args(values)
    local options = {
        root = default_root,
        output_root = vim.fs.joinpath(here, "results"),
        runs = 10,
        warmups = 2,
    }
    local index = 1

    while index <= #values do
        local value = values[index]
        if value == "--" then
            index = index + 1
        elseif value == "--root" or value == "--output-root" or value == "--runs" or value == "--warmups" then
            local next_value = values[index + 1]
            if not next_value then
                fail("Missing value for " .. value)
            end
            if value == "--root" then
                options.root = next_value
            elseif value == "--output-root" then
                options.output_root = next_value
            elseif value == "--runs" then
                options.runs = tonumber(next_value)
            else
                options.warmups = tonumber(next_value)
            end
            index = index + 2
        elseif value:sub(1, 2) == "--" then
            fail("Unknown option: " .. value)
        elseif not options.label then
            options.label = value
            index = index + 1
        else
            fail("Unexpected argument: " .. value)
        end
    end

    if not options.label then
        fail "Usage: nvim --clean --headless -l benchmarks/startup/run.lua -- LABEL [--runs N] [--warmups N]"
    end
    if not options.runs or options.runs < 1 or options.runs % 1 ~= 0 then
        fail "--runs must be a positive integer"
    end
    if not options.warmups or options.warmups < 0 or options.warmups % 1 ~= 0 then
        fail "--warmups must be a non-negative integer"
    end

    options.root = vim.fs.normalize(vim.fn.fnamemodify(options.root, ":p"))
    options.output_root = vim.fs.normalize(vim.fn.fnamemodify(options.output_root, ":p"))
    return options
end

local options = parse_args(arg or {})
local output = vim.fs.joinpath(options.output_root, options.label)
if uv.fs_stat(output) then
    fail("Refusing to overwrite existing results: " .. output)
end
vim.fn.mkdir(output, "p")

local function read_file(path)
    local file, open_error = io.open(path, "rb")
    if not file then
        fail(string.format("Unable to read %s: %s", path, open_error))
    end
    local contents = file:read "*a"
    file:close()
    return contents
end

local function write_file(path, contents)
    local file, open_error = io.open(path, "wb")
    if not file then
        fail(string.format("Unable to write %s: %s", path, open_error))
    end
    file:write(contents)
    file:close()
end

local function write_json(path, value)
    write_file(path, vim.json.encode(value) .. "\n")
end

local function command(command_args, cwd)
    local result = vim.system(command_args, { cwd = cwd or options.root, text = true }):wait()
    if result.code ~= 0 then
        fail(
            string.format(
                "Command failed (%d): %s\n%s",
                result.code,
                table.concat(command_args, " "),
                result.stderr or ""
            )
        )
    end
    return vim.trim(result.stdout or "")
end

local config_files = vim.fn.globpath(vim.fs.joinpath(options.root, "lua"), "**/*.lua", false, true)
for _, name in ipairs { "init.lua", "lazy-lock.json" } do
    local path = vim.fs.joinpath(options.root, name)
    if uv.fs_stat(path) then
        table.insert(config_files, path)
    end
end
table.sort(config_files)

local config_hashes = {}
for _, path in ipairs(config_files) do
    local relative = path:sub(#options.root + 2)
    config_hashes[relative] = vim.fn.sha256(read_file(path))
end

local metadata = {
    date = os.date "!%Y-%m-%dT%H:%M:%SZ",
    cwd = options.root,
    nvim = command { vim.v.progpath, "--version" },
    executable = vim.v.progpath,
    git_head = command { "git", "rev-parse", "HEAD" },
    git_status = command { "git", "status", "--short" },
    config_sha256 = config_hashes,
    runs = options.runs,
    warmups = options.warmups,
    terminal = { TERM = "xterm-256color", rows = 40, cols = 120 },
    method = "PTY UI child processes controlled by headless Neovim; normal config/data, -i NONE, two-second observation after UIEnter; sequential alternating empty/Lua file runs; warm caches.",
    wall_origin = "First --cmd probe, before init.lua; --startuptime logs also retained.",
    config_path = vim.fn.stdpath "config",
    config_realpath = uv.fs_realpath(vim.fn.stdpath "config") or vim.fn.stdpath "config",
    probe_sha256 = vim.fn.sha256(read_file(vim.fs.joinpath(here, "probe.lua"))),
    steady_state_sha256 = vim.fn.sha256(read_file(vim.fs.joinpath(here, "steady_state.lua"))),
    installed_plugin_heads = {},
}

local plugin_root = vim.fs.joinpath(vim.fn.stdpath "data", "lazy")
local plugin_scan = uv.fs_scandir(plugin_root)
if plugin_scan then
    while true do
        local name, entry_type = uv.fs_scandir_next(plugin_scan)
        if not name then
            break
        end
        local path = vim.fs.joinpath(plugin_root, name)
        if entry_type == "directory" and uv.fs_stat(vim.fs.joinpath(path, ".git")) then
            metadata.installed_plugin_heads[name] = command { "git", "-C", path, "rev-parse", "HEAD" }
        end
    end
end
write_json(vim.fs.joinpath(output, "metadata.json"), metadata)

local function occurrence_count(text, needle)
    local count = 0
    local position = 1
    while true do
        local start_at, end_at = text:find(needle, position, true)
        if not start_at then
            return count
        end
        count = count + 1
        position = end_at + 1
    end
end

local terminal_queries = {
    { query = "\27[6n", response = "\27[1;1R" },
    { query = "\27[c", response = "\27[?1;2c" },
    { query = "\27[0c", response = "\27[?1;2c" },
    { query = "\27]10;?", response = "\27]10;rgb:eeee/eeee/eeee\27\\" },
    { query = "\27]11;?", response = "\27]11;rgb:1111/1111/1111\27\\" },
    { query = "\27[5n", response = "\27[0n" },
}

local function run_child(name, scenario, extra_args, warmup, run_number)
    local target = vim.fs.joinpath(output, name .. ".json")
    local startup_log = vim.fs.joinpath(output, name .. ".startup.log")
    local terminal_log = vim.fs.joinpath(output, name .. ".terminal.log")
    local child_args = {
        vim.v.progpath,
        "-i",
        "NONE",
        "--startuptime",
        startup_log,
        "--cmd",
        string.format("lua dofile(%q)", vim.fs.joinpath(here, "steady_state.lua")),
        "--cmd",
        string.format("lua dofile(%q)", vim.fs.joinpath(here, "probe.lua")),
    }
    vim.list_extend(child_args, extra_args)

    local terminal = ""
    local responses_sent = {}
    local job
    local function respond_to_queries()
        for index, query in ipairs(terminal_queries) do
            local found = occurrence_count(terminal, query.query)
            local sent = responses_sent[index] or 0
            for _ = sent + 1, found do
                vim.fn.chansend(job, query.response)
            end
            responses_sent[index] = found
        end
    end

    job = vim.fn.jobstart(child_args, {
        cwd = options.root,
        env = {
            KOALA_BENCH_OUTPUT = target,
            NVIM = "",
            NVIM_APPNAME = "",
            NVIM_LISTEN_ADDRESS = "",
            TERM = "xterm-256color",
        },
        height = 40,
        width = 120,
        pty = true,
        on_stdout = function(_, data)
            if data then
                terminal = terminal .. table.concat(data, "\n")
                respond_to_queries()
            end
        end,
    })
    if job <= 0 then
        fail("Unable to start child Neovim for " .. name)
    end

    local exit_code = vim.fn.jobwait({ job }, 25000)[1]
    if exit_code == -1 then
        vim.fn.jobstop(job)
        vim.fn.jobwait({ job }, 1000)
    end
    write_file(terminal_log, terminal)

    if exit_code == -1 then
        fail(string.format("Run timed out: %s; see %s", name, terminal_log))
    elseif exit_code ~= 0 then
        fail(string.format("Run exited with status %d: %s; see %s", exit_code, name, terminal_log))
    end
    if not uv.fs_stat(target) then
        fail(string.format("Run produced no snapshot: %s; see %s", name, terminal_log))
    end
    local data = vim.json.decode(read_file(target), { luanil = { object = true, array = true } })
    if data.messages and data.messages:find("E1568", 1, true) then
        fail("Terminal response failure: " .. name)
    end
    if data.errmsg and data.errmsg ~= "" then
        fail(string.format("Startup error in %s: %s", name, data.errmsg))
    end
    if not data.phases or not data.phases.very_lazy_done then
        fail("Missing VeryLazy measurement: " .. name .. "; inspect startup errors")
    end

    local first_screen
    for line in read_file(startup_log):gmatch "[^\r\n]+" do
        local value = line:match "^%s*([%d.]+).*%-%-%- NVIM STARTED %-%-%-"
        if value then
            first_screen = tonumber(value)
        end
    end
    if not first_screen then
        fail("Missing NVIM STARTED marker: " .. startup_log)
    end

    data.first_screen_ms = first_screen
    data.scenario = scenario
    data.warmup = warmup
    data.run = run_number
    data.exit_code = exit_code
    return data
end

local records = {}
for index = 0, options.warmups + options.runs - 1 do
    for _, scenario in ipairs {
        { name = "empty", args = {} },
        { name = "lua_file", args = { "init.lua" } },
    } do
        local warmup = index < options.warmups
        local name = string.format("%02d-%s", index, scenario.name)
        local data = run_child(name, scenario.name, scenario.args, warmup, index)
        table.insert(records, data)
        print(
            string.format(
                "%s %s: UI=%.1fms VeryLazy=%.1fms loaded=%d errors=%s",
                name,
                warmup and "warmup" or "measured",
                data.phases.ui_enter.wall_ms,
                data.phases.very_lazy_done.wall_ms,
                data.phases.after_2s.loaded,
                tostring(data.errmsg ~= nil and data.errmsg ~= "")
            )
        )
        write_json(vim.fs.joinpath(output, "runs.json"), records)
    end
end

local function summarize(values)
    local sorted = vim.deepcopy(values)
    table.sort(sorted)
    local total = 0
    for _, value in ipairs(sorted) do
        total = total + value
    end
    local mean = total / #sorted
    local median
    if #sorted % 2 == 0 then
        median = (sorted[#sorted / 2] + sorted[#sorted / 2 + 1]) / 2
    else
        median = sorted[math.ceil(#sorted / 2)]
    end
    local variance = 0
    if #sorted > 1 then
        for _, value in ipairs(sorted) do
            variance = variance + (value - mean) ^ 2
        end
        variance = variance / (#sorted - 1)
    end
    return {
        median = median,
        mean = mean,
        min = sorted[1],
        max = sorted[#sorted],
        stdev = math.sqrt(variance),
    }
end

local summary = {}
for _, scenario in ipairs { "empty", "lua_file" } do
    local scenario_runs = vim.tbl_filter(function(record)
        return record.scenario == scenario and not record.warmup
    end, records)
    local metrics = {}
    for _, phase in ipairs { "ui_enter", "very_lazy_done", "after_2s" } do
        for _, metric in ipairs { "wall_ms", "cpu_ms", "loaded" } do
            local values = vim.tbl_map(function(record)
                return record.phases[phase][metric]
            end, scenario_runs)
            metrics[phase .. "." .. metric] = summarize(values)
        end
    end
    metrics["first_screen.wall_ms"] = summarize(vim.tbl_map(function(record)
        return record.first_screen_ms
    end, scenario_runs))
    metrics.lazy_ui_cpu_ms = summarize(vim.tbl_map(function(record)
        return record.lazy_stats.startuptime
    end, scenario_runs)).median

    local plugins = {}
    for name in pairs(scenario_runs[1].phases.after_2s.plugins) do
        local timings = vim.tbl_map(function(record)
            return record.phases.after_2s.plugins[name].time_ms or 0
        end, scenario_runs)
        table.insert(plugins, { name = name, median_ms = summarize(timings).median })
    end
    table.sort(plugins, function(left, right)
        return left.median_ms > right.median_ms
    end)
    metrics.plugins = plugins
    summary[scenario] = metrics
end

write_json(vim.fs.joinpath(output, "summary.json"), summary)
print(output)
