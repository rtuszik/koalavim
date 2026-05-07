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
        "sindrets/diffview.nvim",
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged_enable = true,
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            current_line_blame = true,
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
