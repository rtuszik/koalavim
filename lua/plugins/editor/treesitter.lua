local parsers = {
    "bash",
    "c",
    "comment",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gotmpl",
    "hcl",
    "helm",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    "mermaid",
    "php",
    "python",
    "query",
    "regex",
    "ruby",
    "rust",
    "sql",
    "ssh_config",
    "swift",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
    "zsh",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter-features", {}),
                callback = function(ev)
                    if pcall(vim.treesitter.start, ev.buf) then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {},
    },
}
