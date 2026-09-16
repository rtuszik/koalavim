return {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" }, -- ensure it actually loads
    opts = function()
        local project_formatters = require "config.formatters"
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
                -- Ruby has no conform formatter, so this falls through to the
                -- rubocop LSP (see lsp.lua). That process is already running by
                -- save time, but its first textDocument/formatting request loads
                -- the cop set lazily and measured ~3.1s; steady state is <1.2s
                -- even on a 2800-line file.
                local timeout_ms = vim.bo[buf].filetype == "ruby" and 5000 or 2000
                return { timeout_ms = timeout_ms, lsp_format = "fallback" }
            end,
            formatters_by_ft = {},
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
                    prepend_args = function(_, ctx)
                        if vim.fs.root(ctx.buf, { ".oxfmtrc.json", ".oxfmtrc.jsonc" }) then
                            return {}
                        end
                        return { "--config", vim.fn.expand "~/.config/oxfmt/.oxfmtrc.json" }
                    end,
                },
            },
        }
        for filetype in pairs(project_formatters.defaults(0)) do
            opts.formatters_by_ft[filetype] = function(buf)
                return project_formatters.resolve(buf, filetype)
            end
        end
        opts.formatters_by_ft._ = function(buf)
            return project_formatters.resolve(buf, vim.bo[buf].filetype)
        end
        return opts
    end,
}
