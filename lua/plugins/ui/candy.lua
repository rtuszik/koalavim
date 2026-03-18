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
                "kanagawa-wave",
                "kanagawa-dragon",
                "obscure",
                "oasis",
                "oasis-night",
                "oasis-midnight",
                "oasis-abyss",
                "oasis-starlight",
                "oasis-desert",
                "oasis-sol",
                "oasis-canyon",
                "oasis-dune",
                "oasis-cactus",
                "oasis-mirage",
                "oasis-lagoon",
                "oasis-twilight",
                "oasis-rose",
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
            vim.cmd.colorscheme "onedark_vivid"
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
                    },
                },
            }
        end,
    },
    { "rebelot/kanagawa.nvim", lazy = false },
    {
        "mslvx/obscure.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "uhs-robert/oasis.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("oasis").setup() -- (see Configuration below for all customization options)
        end,
    },
    -- just for fun :)
    {
        "axsaucedo/neovim-power-mode",
        config = function()
            require("power-mode").setup {
                particles = { preset = "emoji" },
                shake = { mode = "none" },
                fire_wall = {
                    enabled = false,
                    bottom_offset = 2, -- rows to skip at bottom (statusline/cmdline)
                    max_rows = 5, -- maximum fire height in rows
                },
                engine = {
                    fps = 60, -- Frames per second (10-60)
                    stop_delay = 2000, -- ms after leaving insert to stop engine
                },
                combo = {
                    enabled = true, -- Show combo counter
                    position = "top-right", -- "top-right"|"top-left"|"bottom-right"|"bottom-left"
                    width = 20, -- Window width
                    height = 7, -- Window height
                    timeout = 6000, -- ms before combo resets
                    thresholds = { 10, 25, 50, 100, 200 }, -- Level escalation thresholds
                    shake = true, -- Shake combo window on keystroke
                    shake_intensity = nil, -- Override: { min, max } (nil = auto)
                    exclamations = { -- Random phrases at milestones
                        "UNSTOPPABLE!",
                        "GODLIKE!",
                        "RAMPAGE!",
                        "MEGA KILL!",
                        "DOMINATING!",
                        "WICKED SICK!",
                        "LEGENDARY!",
                    },
                    exclamation_interval = 10, -- Show phrase every N keystrokes
                    exclamation_duration = 1500, -- ms to display phrase
                },
            }
        end,
    },
}
