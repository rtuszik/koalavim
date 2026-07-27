return {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" }, -- ensure it actually loads
    opts = function()
        local has_biome = vim.fs.root(0, { "biome.json", "biome.jsonc", "biome.json5", ".biome.jsonc", ".biome.json" })
            ~= nil
        local has_oxfmt = vim.fs.root(0, { ".oxfmtrc.json", ".oxfmtrc.jsonc" }) ~= nil
        local has_prettier = vim.fs.root(0, { ".prettierrc.json", ".prettierrc", ".prettierrc.yaml" }) ~= nil
        local opts = {
            format_on_save = function(buf)
                -- Skip if autoformat is disabled
                if not vim.g.autoformat then
                    return nil
                end
                -- Skip format for large files (>500kb) to avoid stalls
                local max_size = 500 * 1024
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_size then
                    return nil
                end
                return { timeout_ms = 2000, lsp_format = "fallback" }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                javascript = { "biome" },
                typescript = { "biome" },
                javascriptreact = { "biome" },
                typescriptreact = { "biome" },
                css = { "biome" },
                html = has_oxfmt and { "oxfmt" } or { "biome", "djlint" },
                json = has_biome and { "biome" } or { "oxfmt" },
                jsonc = has_biome and { "biome" } or { "oxfmt" },
                yaml = has_prettier and { "prettier" } or { "yamlfmt" },
                markdown = has_oxfmt and { "oxfmt" } or has_prettier and { "prettier" } or nil,
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
            },
            formatters = {
                prettier = {
                    -- prepend_args = { "--tab-width", "4", "--print-width", "100" },
                },
                bake = {
                    command = "uvx",
                    args = { "mbake", "format", "$FILENAME" },
                    stdin = false,
                },
                yamlfmt = {
                    prepend_args = {
                        "-formatter",
                        "indent=4",
                        "-formatter",
                        "include_document_start=true",
                        "-formatter",
                        "retain_line_breaks_single=true",
                        -- "-formatter",
                        -- "indentless_arrays=true",
                    },
                },
                biome = {
                    -- append_args = { "--json-formatter-expand", "always" },
                },
                oxfmt = {
                    prepend_args = not has_oxfmt and { "--config", vim.fn.expand "~/.config/oxfmt/.oxfmtrc.json" }
                        or {},
                },
            },
        }
        return opts
    end,
}
