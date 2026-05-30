return {
    {
        "zaldih/themery.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            themes = {
                "tokyonight",
                "tokyonight-night",
                "tokyonight-storm",
                "tokyonight-moon",
                "catppuccin",
                "catppuccin-latte",
                "catppuccin-frappe",
                "catppuccin-macchiato",
                "catppuccin-mocha",
                "rose-pine",
                "rose-pine-main",
                "rose-pine-moon",
                "rose-pine-dawn",
                "onedark",
                "onedark_vivid",
                "onedark_dark",
                "oh-lucy",
                "oh-lucy-evening",
                "kanagawa-wave",
                "kanagawa-dragon",
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
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        opts = {
            transparent_background = true,
            integrations = {
                aerial = true,
                alpha = true,
                cmp = true,
                dashboard = true,
                flash = true,
                grug_far = true,
                gitsigns = true,
                headlines = true,
                illuminate = true,
                indent_blankline = { enabled = true },
                leap = true,
                lsp_trouble = true,
                mason = true,
                markdown = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                navic = { enabled = true, custom_bg = "lualine" },
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                semantic_tokens = true,
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
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
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup {
                variant = "moon", -- auto, main, moon, or dawn
                dark_variant = "moon", -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                styles = {
                    bold = true,
                    italic = true,
                    transparency = true,
                },
            }
        end,
    },
    {
        "yazeed1s/oh-lucy.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.oh_lucy_transparent = true
        end,
    },
    { "rebelot/kanagawa.nvim", lazy = false },
}
