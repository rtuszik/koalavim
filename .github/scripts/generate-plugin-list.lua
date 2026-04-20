local PLUGINS_DIR = "lua/plugins"
local README_FILE = "README.md"
local MARKER_START = "<!-- PLUGINS:START -->"
local MARKER_END = "<!-- PLUGINS:END -->"

local function is_valid_plugin(s)
    local owner, repo = s:match "^([%w%-_%.]+)/([%w%-_%.]+)$"
    if not owner or not repo then
        return false
    end

    if s:match "^%." then
        return false
    end

    if not repo:match "%w%w" then
        return false
    end

    local bad = {
        textDocument = true,
        diagnostics = true,
        workspace = true,
        file = true,
        quit = true,
        window = true,
        client = true,
        anthropic = true,
    }
    if bad[owner] then
        return false
    end

    if s:match "%.json$" or s:match "%.txt$" then
        return false
    end

    return true
end

local function extract_plugins(source)
    local plugins = {}
    local seen = {}

    for line in source:gmatch "[^\n]+" do
        if line:match "^%s*%-%-" then
            goto continue
        end

        local repo = line:match "^%s*[\"']([%w%-_%.]+/[%w%-_%.]+)[\"']%s*,"
            or line:match "^%s*{%s*[\"']([%w%-_%.]+/[%w%-_%.]+)[\"']"

        if repo and is_valid_plugin(repo) and not seen[repo] then
            seen[repo] = true
            plugins[#plugins + 1] = { repo = repo, url = "https://github.com/" .. repo }
        end

        ::continue::
    end

    return plugins
end

local function lua_files(dir)
    local files = {}
    local handle = io.popen('find "' .. dir .. '" -name "*.lua" -type f | sort')
    if not handle then
        return files
    end
    for line in handle:lines() do
        files[#files + 1] = line
    end
    handle:close()
    return files
end

local f = io.open(README_FILE, "r")
if not f then
    io.stderr:write("ERROR: " .. README_FILE .. " not found\n")
    os.exit(1)
end
local readme = f:read "*a"
f:close()

local start_pos = readme:find(MARKER_START, 1, true)
local end_pos = readme:find(MARKER_END, 1, true)
if not start_pos or not end_pos then
    io.stderr:write(
        "ERROR: Could not find " .. MARKER_START .. " and/or " .. MARKER_END .. " in " .. README_FILE .. "\n"
    )
    os.exit(1)
end

local files = lua_files(PLUGINS_DIR)
if #files == 0 then
    io.stderr:write("No .lua files found in " .. PLUGINS_DIR .. "\n")
    os.exit(1)
end

local all_plugins = {}
local seen = {}
for _, filepath in ipairs(files) do
    local fh = io.open(filepath, "r")
    if fh then
        local source = fh:read "*a"
        fh:close()
        for _, p in ipairs(extract_plugins(source)) do
            if not seen[p.repo] then
                seen[p.repo] = true
                all_plugins[#all_plugins + 1] = p
            end
        end
    end
end

table.sort(all_plugins, function(a, b)
    return a.repo:lower() < b.repo:lower()
end)

local lines = {}
lines[#lines + 1] = MARKER_START
lines[#lines + 1] = ""
lines[#lines + 1] = ("Total: **%d** plugins"):format(#all_plugins)
lines[#lines + 1] = ""
lines[#lines + 1] = "| Plugin | Link |"
lines[#lines + 1] = "|--------|------|"
for _, p in ipairs(all_plugins) do
    lines[#lines + 1] = ("| `%s` | [GitHub](%s) |"):format(p.repo, p.url)
end
lines[#lines + 1] = ""
lines[#lines + 1] = MARKER_END

local section = table.concat(lines, "\n")

local before = readme:sub(1, start_pos - 1)
local after = readme:sub(end_pos + #MARKER_END)
local new_readme = before .. section .. after

if new_readme == readme then
    print "Plugin list is already up to date"
    os.exit(0)
end

local out = io.open(README_FILE, "w")
if not out then
    io.stderr:write("Could not open " .. README_FILE .. " for writing\n")
    os.exit(1)
end
out:write(new_readme)
out:close()
print(("Updated %s with %d plugins"):format(README_FILE, #all_plugins))
