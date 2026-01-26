return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                yaml = { "kube_linter", "trivy" },
                -- ... your other filetypes
            },
            linters = {}, -- Leave empty to avoid overwrite issues
        },
        config = function(_, opts)
            local lint = require "lint"

            -- --- MANUALLY DEFINE KUBE_LINTER ---
            -- We define the full linter here to fix "Linter not found" and "parser nil"
            lint.linters.kube_linter = {
                cmd = "kube-linter",
                stdin = false, -- kube-linter runs against the file on disk
                args = { "lint", "--format", "plain" },
                stream = "stdout",
                ignore_exitcode = true, -- Capture warnings even if exit code is 1
                parser = require("lint.parser").from_pattern(
                    "[^:]+:(%d+): (.*)", -- Pattern to match "line: message"
                    { "lnum", "message" },
                    nil,
                    { ["source"] = "kube-linter" }
                ),
            }
            -- -----------------------------------

            -- Apply your custom condition specifically to the linter we just defined
            local kube = lint.linters.kube_linter
            kube.condition = function(ctx)
                return vim.fn.search("apiVersion:", "nw") > 0
            end

            -- Setup Trivy
            local trivy = lint.linters.trivy
            if trivy then
                trivy.ignore_exitcode = true
            end

            -- Standard setup loop
            for name, linter in pairs(opts.linters) do
                local default_linter = lint.linters[name]
                if type(linter) == "table" and type(default_linter) == "table" then
                    lint.linters[name] = vim.tbl_deep_extend("force", default_linter, linter)
                else
                    lint.linters[name] = linter
                end
            end

            lint.linters_by_ft = opts.linters_by_ft

            -- Debounce and Autocommands
            local function debounce(ms, fn)
                local timer = assert(vim.uv.new_timer())
                return function(...)
                    local argv = { ... }
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            local function do_lint()
                local names = lint._resolve_linter_by_ft(vim.bo.filetype)
                names = vim.list_extend({}, names)

                if #names == 0 then
                    vim.list_extend(names, lint.linters_by_ft["_"] or {})
                end

                vim.list_extend(names, lint.linters_by_ft["*"] or {})

                local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
                names = vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    if not linter then
                        vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
                        return false
                    end
                    ---@diagnostic disable-next-line: undefined-field
                    return not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
                end, names)

                if #names > 0 then
                    lint.try_lint(names)
                end
            end

            vim.api.nvim_create_autocmd(opts.events, {
                group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                callback = debounce(100, do_lint),
            })
        end,
    },
}
