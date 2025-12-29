return {
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            "ibhagwan/fzf-lua", -- optional
        },
        cmd = "Neogit",
        keys = {
            { "<leader>ng", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
        },
    },
}
