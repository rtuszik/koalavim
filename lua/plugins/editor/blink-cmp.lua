---@diagnostic disable: missing-fields
return {
    {
        "hrsh7th/nvim-cmp",
        optional = true,
        enabled = false,
    },

    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "giuxtaposition/blink-cmp-copilot",
            {
                "saghen/blink.compat",
                optional = true,
                opts = {},
                version = "*",
            },
        },
        event = "InsertEnter",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            fuzzy = {
                implementation = "rust",
            },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
                kind_icons = {
                    Copilot = "",
                    Text = "󰉿",
                    Method = "󰊕",
                    Function = "󰊕",
                    Constructor = "󰒓",
                    Field = "󰜢",
                    Variable = "󰆦",
                    Property = "󰖷",
                    Class = "󱡠",
                    Interface = "󱡠",
                    Struct = "󱡠",
                    Module = "󰅩",
                    Unit = "󰪚",
                    Value = "󰦨",
                    Enum = "󰦨",
                    EnumMember = "󰦨",
                    Keyword = "󰻾",
                    Constant = "󰏿",
                    Snippet = "󱄽",
                    Color = "󰏘",
                    File = "󰈔",
                    Reference = "󰬲",
                    Folder = "󰉋",
                    Event = "󱐋",
                    Operator = "󰪚",
                    TypeParameter = "󰬛",
                },
            },
            completion = {
                accept = {
                    auto_brackets = { enabled = true },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Copilot"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                    },
                },
            },
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },
        },
    },
}
