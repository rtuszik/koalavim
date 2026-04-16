-- Diagnostic icons
local diagnostic_icons = {
    Warn = " ",
    Error = " ",
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
                    source = "true",
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
                enabled = true,
            },
            -- Server configurations
            servers = {
                ruff = {},
                bashls = {},
                biome = {},

                yamlls = {
                    capabilities = {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    },
                    settings = {
                        redhat = { telemetry = { enabled = false } },
                        yaml = {
                            schemaStore = {
                                enable = false,
                                url = "https://www.schemastore.org/api/json/catalog.json",
                            },
                            format = { enabled = false },
                            -- enabling this conflicts between Kubernetes resources, kustomization.yaml, and Helmreleases
                            validate = false,
                            schemas = {
                                kubernetes = "*.yaml",
                                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "roles/tasks/*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
                                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*compose*.{yml,yaml}",
                            },
                        },
                    },
                },

                jsonls = {
                    on_new_config = function(config)
                        config.settings.json.schemas = require("schemastore").json.schemas()
                    end,
                    settings = {
                        json = {
                            validate = { enable = true },
                            format = { enable = false }, -- biome handles formatting
                        },
                    },
                },

                ansiblels = {},
                docker_compose_language_service = {},
                dockerls = {},
                postgres_lsp = {},
                ty = {},
                helm_ls = {
                    settings = {
                        ["helm-ls"] = {
                            yamlls = {
                                path = "yaml-language-server",
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                globals = { "vim", "Snacks" },
                            },
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
                        vim.lsp.codelens.enable(true, { bufnr = buffer })
                    end
                end,
            })
            local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics
            opts.servers.bashls = vim.tbl_deep_extend("force", opts.servers.bashls or {}, {
                handlers = {
                    ["textDocument/publishDiagnostics"] = function(err, res, ...)
                        local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ":t")
                        if string.match(file_name, "^%.env") == nil then
                            return on_publish_diagnostics(err, res, ...)
                        end
                    end,
                },
            })
        end,
    },

    { "b0o/schemastore.nvim", lazy = true },

    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            automatic_enable = true,
            ensure_installed = {
                "ruff",
                "bashls",
                "biome",
                -- "oxfmt",
                -- "oxlint",
                "dockerls",
                "postgres_lsp",
                "bashls",
                "ty",
                "lua_ls",
                "clangd",
                "rust_analyzer",
                "yamlls",
                "jsonls",
                "ansiblels",
                "cmake",
                "golangci_lint_ls",
                "tombi",
                "helm_ls",
                "zls",
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
                "oxfmt",
                "oxlint",
            },
        },
    },
    {
        "qvalentin/helm-ls.nvim",
        ft = "helm",
        opts = {
            conceal_templates = {
                enabled = false, -- this might change to false in the future
            },
            indent_hints = {
                -- enable hints for indent and nindent functions
                enabled = true,
                -- show the hints only for the line the cursor is on
                only_for_current_line = true,
            },
            action_highlight = {
                -- enable highlighting of the current block
                enabled = true,
            },
        },
    },
}
