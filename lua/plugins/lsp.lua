return {
    {
        "neovim/nvim-lspconfig",
        lazy = false, -- configure early so :checkhealth sees servers
        config = function()
            local caps = require("blink.cmp").get_lsp_capabilities()
            local function cfg(name, opts)
                vim.lsp.config(name, vim.tbl_deep_extend("force", { capabilities = caps }, opts or {}))
            end

            cfg("pyright", { autostart = false })
            cfg("ruff", {})
            cfg("bashls", {})
            cfg("biome", {})
            cfg("yamlls", {})
            cfg("ansiblels", {})
            cfg("docker_language_server", {})
            cfg("docker_compose_language_service", {})
            cfg("dockerls", {})
            cfg("postgres_lsp", {})
            cfg("ty", {})
            cfg("lua_ls", {})
            cfg("clangd", {})
            cfg("cmake", {})
            cfg("rust_analyzer", {})

            vim.lsp.enable {
                "pyright",
                "ruff",
                "bashls",
                "biome",
                "yamlls",
                "ansiblels",
                "docker_language_server",
                "docker_compose_language_service",
                "dockerls",
                "postgres_lsp",
                "ty",
                "lua_ls",
                "clangd",
                "cmake",
                "rust_analyzer",
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Goto Definition")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
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
                "pyright",
                "ruff",
                "bashls",
                "biome",
                "yamlls",
                "ansiblels",
                "docker_language_server",
                "docker_compose_language_service",
                "dockerls",
                "postgres_lsp",
                "ty",
                "lua_ls",
                "clangd",
                "cmake",
                "rust_analyzer",
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
                "flake8",
                "prettier",
                "biome",
                "ruff",
                "djlint",
                "terraform",
                "rustfmt",
                "rust-analyzer",
                "clangd",
                "clang-format",
                "ty",
                "php-cs-fixer",
                "phpcs",
                "postgres-language-server",
                "gitleaks",
                "semgrep",
                "gh",
                "bandit",
                "kube-linter",
                "ansible-language-server",
                "ansible-lint",
                "cmake-language-server",
                "dockerfile-language-server",
                "docker-compose-language-service",
                "yaml-language-server",
                "bash-language-server",
            },
        },
    },
}
