return {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" }, -- ensure it actually loads
    opts = function()
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
                json = { "biome" },
                yaml = { "yamlfmt" },
                markdown = { "prettier" },
                makefile = { "bake" },
                graphql = { "biome" },
                terraform = { "terraform_fmt" },
                rust = { "rustfmt" },
                c = { "clang-format" },
                toml = { "taplo" },
                php = { "php_cs_fixer" },
                zig = { "zigfmt" },
                scss = { "stylelint" },
            },
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--print-width", "100" },
                },
                taplo = {
                    args = { "format", "--option", "indent_string=    ", "-" },
                    -- The 4 spaces are between the quotes after indent_string=
                },
                bake = {
                    command = "uvx",
                    args = { "mbake", "format", "$FILENAME" },
                    stdin = false,
                },
                yamlfmt = {
                    prepend_args = { "-in" },
                    append_args = { "-formatter", "indent=4" },
                },
            },
        }
        return opts
    end,
}
