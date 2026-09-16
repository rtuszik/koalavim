local function fail(message)
    error(message, 0)
end

local function read_json(path)
    local file, open_error = io.open(path, "rb")
    if not file then
        fail(string.format("Unable to read %s: %s", path, open_error))
    end
    local value = vim.json.decode(file:read "*a")
    file:close()
    return value
end

local positional = {}
local markdown = false
for _, value in ipairs(arg or {}) do
    if value == "--" then
    elseif value == "--markdown" then
        markdown = true
    elseif value:sub(1, 2) == "--" then
        fail("Unknown option: " .. value)
    else
        table.insert(positional, value)
    end
end

if #positional ~= 2 then
    fail "Usage: nvim --clean --headless -l benchmarks/startup/compare.lua -- BASE NEW [--markdown]"
end

local base = read_json(vim.fs.joinpath(positional[1], "summary.json"))
local new = read_json(vim.fs.joinpath(positional[2], "summary.json"))
local base_metadata = read_json(vim.fs.joinpath(positional[1], "metadata.json"))
local new_metadata = read_json(vim.fs.joinpath(positional[2], "metadata.json"))
local metrics = {
    "first_screen.wall_ms",
    "ui_enter.wall_ms",
    "ui_enter.cpu_ms",
    "very_lazy_done.wall_ms",
    "very_lazy_done.cpu_ms",
    "after_2s.cpu_ms",
    "after_2s.loaded",
}

local function change(before, after)
    if before == 0 then
        return after == 0 and 0 or math.huge
    end
    return (after / before - 1) * 100
end

if markdown then
    local lines = {
        "## Neovim startup profile",
        "",
        string.format(
            "Base `%s` to head `%s` using `%s`; %d measured runs after %d warmups.",
            base_metadata.git_head:sub(1, 12),
            new_metadata.git_head:sub(1, 12),
            new_metadata.nvim:match "[^\r\n]+",
            new_metadata.runs,
            new_metadata.warmups
        ),
        "",
        "Positive deltas mean slower startup or more loaded plugins. Values are medians.",
        "",
        "| Scenario | Metric | Base | Head | Delta | Change |",
        "|---|---|---:|---:|---:|---:|",
    }
    for _, scenario in ipairs { "empty", "lua_file" } do
        for _, metric in ipairs(metrics) do
            local before = base[scenario][metric].median
            local after = new[scenario][metric].median
            local percent = change(before, after)
            local percent_text = percent == math.huge and "n/a" or string.format("%+.1f%%", percent)
            table.insert(
                lines,
                string.format(
                    "| `%s` | `%s` | %.2f | %.2f | %+.2f | %s |",
                    scenario,
                    metric,
                    before,
                    after,
                    after - before,
                    percent_text
                )
            )
        end
    end
    io.write(table.concat(lines, "\n"), "\n")
else
    for _, scenario in ipairs { "empty", "lua_file" } do
        print(scenario)
        for _, metric in ipairs(metrics) do
            local before = base[scenario][metric].median
            local after = new[scenario][metric].median
            local percent = change(before, after)
            local percent_text = percent == math.huge and "n/a" or string.format("%+.1f%%", percent)
            print(
                string.format(
                    "  %-28s %8.2f -> %8.2f  %+8.2f (%s)",
                    metric,
                    before,
                    after,
                    after - before,
                    percent_text
                )
            )
        end
    end
end
