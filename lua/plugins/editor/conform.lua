return {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" }, -- ensure it actually loads
    opts = function()
        local has_biome = vim.fs.root(0, { "biome.json", "biome.jsonc", "biome.json5" }) ~= nil
        local has_oxfmt_config = vim.fs.root(0, { ".oxfmtrc.json", ".oxfmtrc.jsonc", ".editorconfig" }) ~= nil
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
                html = { "biome", "djlint" },
                json = has_biome and { "biome" } or { "oxfmt" },
                yaml = has_biome and { "biome" } or { "yamlfmt" },
                markdown = { "prettier" },
                makefile = { "bake" },
                graphql = { "biome" },
                terraform = { "terraform_fmt" },
                rust = { "rustfmt" },
                c = { "clang-format" },
                toml = { "oxfmt", "tombi" },
                php = { "mago_format" },
                zig = { "zigfmt" },
                scss = { "stylelint" },
                go = { "gofmt" },
            },
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--print-width", "100" },
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
                    prepend_args = not has_oxfmt_config
                            and { "--config", vim.fn.expand "~/.config/oxfmt/.oxfmtrc.json" }
                        or {},
                },
            },
        }
        return opts
    end,
}
