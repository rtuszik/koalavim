local M = {}

function M.defaults(buf)
    local has_biome = vim.fs.root(buf, { "biome.json", "biome.jsonc", "biome.json5", ".biome.jsonc", ".biome.json" })
        ~= nil
    local has_oxfmt = vim.fs.root(buf, { ".oxfmtrc.json", ".oxfmtrc.jsonc" }) ~= nil
    local has_prettier = vim.fs.root(buf, { ".prettierrc.json", ".prettierrc", ".prettierrc.yaml" }) ~= nil
    local has_rumdl = vim.fs.root(buf, { ".rumdl.toml", "rumdl.toml" }) ~= nil
    return {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        javascript = has_oxfmt and { "oxfmt" } or { "biome" },
        typescript = has_oxfmt and { "oxfmt" } or { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        css = { "biome" },
        html = has_oxfmt and { "oxfmt" } or { "biome", "djlint" },
        json = has_biome and { "biome" } or { "oxfmt" },
        jsonc = has_biome and { "biome" } or { "oxfmt" },
        yaml = has_prettier and { "prettier" } or has_oxfmt and { "oxfmt" } or { "yamlfmt" },
        markdown = has_rumdl and { "rumdl" } or has_oxfmt and { "oxfmt" } or has_prettier and { "prettier" } or {
            "rumdl",
        },
        makefile = { "bake" },
        graphql = { "biome" },
        terraform = { "tofu_fmt" } or { "terraform_fmt" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        toml = has_oxfmt and { "oxfmt" } or { "tombi" },
        php = { "mago_format" },
        zig = { "zigfmt" },
        scss = { "stylelint" },
        go = { "gofmt" },
        ruby = { "rubocop" },
    }
end

function M.resolve(buf, filetype)
    local root = vim.fs.root(buf, function(name)
        return name == ".conform.json" or name == ".git"
    end)
    local path = root and vim.fs.joinpath(root, ".conform.json")
    if path and vim.uv.fs_stat(path) then
        local ok, config = pcall(function()
            local contents = table.concat(vim.fn.readfile(path), "\n")
            local decoded = vim.json.decode(contents)
            assert(type(decoded) == "table" and contents:match "^%s*{", "expected a filetype-to-list object")
            for ft, names in pairs(decoded) do
                assert(
                    type(ft) == "string" and type(names) == "table" and vim.islist(names),
                    "each filetype must contain a list of formatter names"
                )
                for _, name in ipairs(names) do
                    assert(type(name) == "string" and name ~= "", "formatter names must be nonempty strings")
                end
            end
            return decoded
        end)
        if ok then
            if config[filetype] ~= nil then
                return config[filetype]
            end
        else
            vim.notify_once("Ignoring " .. path .. ": " .. tostring(config), vim.log.levels.WARN)
        end
    end
    return M.defaults(buf)[filetype] or {}
end

return M
