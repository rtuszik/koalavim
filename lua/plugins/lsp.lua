-- Diagnostic icons
local diagnostic_icons = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

return {
    {
        "neovim/nvim-lspconfig",
        lazy = false, -- configure early so :checkhealth sees servers
        opts = {
            -- Diagnostic configuration
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
                        [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
                        [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
                        [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
                    },
                },
            },
            -- Inlay hints
            inlay_hints = {
                enabled = true,
                exclude = { "vue" },
            },
            -- Code lens
            codelens = {
                enabled = false,
            },
            -- Server configurations
            servers = {
                ruff = {},
                bashls = {},
                biome = {},
                yamlls = {
                    format = { enabled = false },
                },
                ansiblels = {},
                docker_compose_language_service = {},
                dockerls = {},
                postgres_lsp = {},
                ty = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            codeLens = {
                                enable = true,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            doc = {
                                privateName = { "^_" },
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                        },
                    },
                },
                clangd = {},
                cmake = {},
                rust_analyzer = {},
            },
        },
        config = function(_, opts)
            -- Apply diagnostic configuration
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- Setup capabilities with blink.cmp
            local caps = require("blink.cmp").get_lsp_capabilities()

            -- Add workspace file operations capability
            caps = vim.tbl_deep_extend("force", caps, {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            })

            -- Configure and enable all servers
            for server, server_opts in pairs(opts.servers) do
                local config = vim.tbl_deep_extend("force", { capabilities = caps }, server_opts or {})
                vim.lsp.config(server, config)
            end

            vim.lsp.enable(vim.tbl_keys(opts.servers))

            -- LSP attach autocmd for keymaps and features
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local buffer = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    local map = function(lhs, rhs, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = "LSP: " .. desc })
                    end

                    -- Your existing keymaps
                    map("gd", vim.lsp.buf.definition, "Goto Definition")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

                    -- Additional useful keymaps from LazyVim
                    map("gr", vim.lsp.buf.references, "References")
                    map("gI", vim.lsp.buf.implementation, "Goto Implementation")
                    map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("gK", vim.lsp.buf.signature_help, "Signature Help")
                    map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
                    map("<leader>cr", vim.lsp.buf.rename, "Rename")

                    -- Codelens keymaps
                    map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
                    map("<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")

                    -- Snacks word navigation (if available)
                    if package.loaded["snacks"] and Snacks.words and Snacks.words.is_enabled() then
                        map("]]", function()
                            Snacks.words.jump(vim.v.count1)
                        end, "Next Reference")
                        map("[[", function()
                            Snacks.words.jump(-vim.v.count1)
                        end, "Prev Reference")
                    end

                    -- Inlay hints toggle
                    if opts.inlay_hints.enabled and client and client:supports_method "textDocument/inlayHint" then
                        if
                            vim.api.nvim_buf_is_valid(buffer)
                            and vim.bo[buffer].buftype == ""
                            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                        end
                    end

                    -- Code lens auto-refresh
                    if opts.codelens.enabled and client and client:supports_method "textDocument/codeLens" then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end
                end,
            })
        end,
    },

    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            automatic_enable = true,
            ensure_installed = {
                "ruff",
                "bashls",
                "biome",
                "dockerls",
                "postgres_lsp",
                "bashls",
                "ty",
                "lua_ls",
                "clangd",
                "rust_analyzer",
                "yamlls",
                "ansiblels",
                "cmake",
                "golangci_lint_ls",
                "harper_ls",
                "tombi",
            },
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            run_on_start = true,
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "djlint",
                "terraform",
                "rustfmt",
                "clang-format",
                "php-cs-fixer",
                "phpcs",
                "gitleaks",
                "semgrep",
                "gh",
                "bandit",
                "ansible-lint",
                "yamlfmt",
                "yamllint",
                "trivy",
                "tflint",
                "kube-linter",
            },
        },
    },
}
