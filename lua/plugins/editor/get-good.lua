return {
    -- vim motion hints
    { "tris203/precognition.nvim", enabled = true, opts = {} },
    -- block bad practices
    {
        "antonk52/bad-practices.nvim",
        enabled = false,
        event = "VeryLazy",
        config = function()
            require("bad_practices").setup {
                most_splits = 3,
                most_tabs = 3,
                max_hjkl = 10,
            }
        end,
    },
    -- games
    {
        "szymonwilczek/vim-be-better",
        config = function()
            vim.g.vim_be_better_log_file = 1
        end,
    },
    {

        "ThePrimeagen/vim-be-good",
    },
}
