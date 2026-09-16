return {
    {
        "zaldih/themery.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            themes = {
                "onedark",
                "onedark_vivid",
                "onedark_dark",
            },

            livePreview = true,
        },
        config = function(_, opts)
            require("themery").setup(opts)
            -- Load persisted theme or fallback to onedark_vivid
            local theme_file = vim.fn.stdpath "data" .. "/themery.json"
            if vim.fn.filereadable(theme_file) == 1 then
                local data = vim.fn.json_decode(vim.fn.readfile(theme_file))
                if data and data.theme then
                    pcall(vim.cmd.colorscheme, data.theme)
                    return
                end
            end
            vim.cmd.colorscheme "onedark_vivid"
        end,
        keys = {
            { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme Switcher" },
        },
    },
    {
        "olimorris/onedarkpro.nvim",
        config = function()
            require("onedarkpro").setup {
                options = {
                    transparency = true,
                },
            }
        end,
        priority = 1000,
    },
}
