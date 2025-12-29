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
                "cyberdream",
                "mellow",
                "oxocarbon",
                "onedark",
                "onedark_vivid",
                "onedark_dark",
                "moonfly",
                "nightfox",
                "duskfox",
                "nordfox",
                "terafox",
                "carbonfox",
                "oh-lucy",
                "oh-lucy-evening",
                "dracula",
                "eezzy",
                "kaimandres",
                "kawaii",
                "stoics",
                "angelic",
            },
            livePreview = true,
        },
        config = function(_, opts)
            require("themery").setup(opts)
            -- Load persisted theme or fallback to tokyonight
            local theme_file = vim.fn.stdpath "data" .. "/themery.json"
            if vim.fn.filereadable(theme_file) == 1 then
                local data = vim.fn.json_decode(vim.fn.readfile(theme_file))
                if data and data.theme then
                    pcall(vim.cmd.colorscheme, data.theme)
                    return
                end
            end
            vim.cmd.colorscheme "tokyonight-night"
        end,
        keys = {
            { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme Switcher" },
        },
    },
    { "scottmckendry/cyberdream.nvim", opts = {
        transparent = true,
    } },
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
        "mellow-theme/mellow.nvim",
        config = function()
            vim.g.mellow_transparent = true
        end,
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        -- oxocarbon doesn't support transparency natively
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
    { "ashish2508/Eezzy.nvim", opts = {
        transparent = true,
    } },
    {
        "mtendekuyokwa19/stoics.nvim",
        -- Check theme docs for transparency support
    },
    {
        "Sonya-sama/kawaii.nvim",
        -- Check theme docs for transparency support
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
        priority = 1000, -- Ensure it loads first
    },
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.moonflyTransparent = true
        end,
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
        "EdenEast/nightfox.nvim",
        opts = {
            options = {
                transparent = true,
            },
        },
    },
    {
        "yazeed1s/oh-lucy.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.oh_lucy_transparent = true
        end,
    },

    {
        "sponkurtus2/angelic.nvim",
        lazy = false,
        priority = 1000,
        -- config = function()
        --     require("angelic").setup({ transparent = true })
        --     -- vim.cmd.colorscheme("angelic")
        -- end,
    },
    {
        "Mofiqul/dracula.nvim",
        config = function()
            require("dracula").setup {
                transparent_bg = true,
            }
        end,
    },
    -- plugins/kaimandres.nvim
    {
        "MartelleV/kaimandres.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kaimandres").setup {
                transparent = true,
                colors = {
                    palette = {
                        gitChange = "#f087bd",
                        -- Enhanced foreground colors for better contrast
                        white = "#ffffff", -- was #e4e4eb
                        offWhite = "#f8fafc", -- was #d7d7de
                        oldWhite = "#f1f5f9", -- was #d0d0d7
                        dimWhite = "#e2e8f0", -- was #bdbdc4

                        -- Much more vibrant grays
                        stoneGray = "#94a3b8", -- was #767c9d
                        ashGray = "#64748b", -- was #6b7089
                        commentGray = "#6b7280", -- was #7a7f98
                        mutedGray = "#d1d5db", -- was #a8adc8

                        -- Highly vibrant accent colors
                        pink = "#ec4899", -- was #d0679d
                        rose = "#f43f5e", -- was #ea9bba
                        teal = "#14b8a6", -- was #5de4c7
                        aqua = "#06b6d4", -- was #7ae9cc
                        green = "#22c55e", -- was #91d7a3
                        paleGreen = "#86efac", -- was #a8e6b8
                        yellow = "#facc15", -- was #fffac2
                        gold = "#f59e0b", -- was #e7d66d

                        -- More saturated blues
                        blue = "#3b82f6", -- was #78a9ff
                        skyBlue = "#0ea5e9", -- was #add7ff
                        deepBlue = "#2563eb", -- was #6394e6
                        violet = "#8b5cf6", -- was #a0a0ff

                        -- Brighter magentas/purples
                        magenta = "#d946ef", -- was #f087bd
                        purple = "#a855f7", -- was #b8a4de
                        lavender = "#c084fc", -- was #d0c9ff

                        -- More vibrant cyans
                        cyan = "#06b6d4", -- was #89ddff
                        brightCyan = "#22d3ee", -- was #a3e5ff
                        paleCyan = "#67e8f9", -- was #b8eeff

                        -- Enhanced syntax colors
                        propertyBlue = "#60a5fa", -- was #8ab8ff
                        fieldCyan = "#22d3ee", -- was #7dd0ed
                        methodBlue = "#3b82f6", -- was #6fa8ea
                        exceptionMagenta = "#ec4899", -- was #e087bd
                        namespaceViolet = "#a78bfa", -- was #a89fd9
                        booleanOrange = "#fb923c", -- was #ffb454
                        keywordPurple = "#a855f7", -- was #bda6ed

                        -- Brighter specialized colors
                        parameterPurple = "#c084fc", -- was #c5b5e8
                        staticGold = "#fbbf24", -- was #f0d98d
                        readonlyTeal = "#14b8a6", -- was #6de8cb
                    },
                },
            }
            -- Some tweaks
            -- vim.api.nvim_create_autocmd("ColorScheme", {
            --     pattern = "kaimandres",
            --     callback = function()
            --         -- Remove annoying darker blocks in Lualine (if this happens to you)
            --         vim.api.nvim_set_hl(0, "StatusLine", { bg = "#16161e" })
            --     end,
            -- })
        end,
    },
}
