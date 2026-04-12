return {
    -- edgy
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>ue",
                function()
                    require("edgy").toggle()
                end,
                desc = "Edgy Toggle",
            },
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
        },
        opts = function()
            local opts = {
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        ---@diagnostic disable-next-line: unused-local
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        ---@diagnostic disable-next-line: unused-local
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    "Trouble",
                    { ft = "qf", title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                left = {
                    { title = "Neotest Summary", ft = "neotest-summary" },
                    -- "neo-tree",
                },
                right = {
                    { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
                },
                keys = {
                    -- increase width
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }

            -- trouble
            for _, pos in ipairs { "top", "bottom", "left", "right" } do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "trouble",
                    ---@diagnostic disable-next-line: unused-local
                    filter = function(_buf, win)
                        return vim.w[win].trouble
                            and vim.w[win].trouble.position == pos
                            and vim.w[win].trouble.type == "split"
                            and vim.w[win].trouble.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end

            -- snacks terminal
            for _, pos in ipairs { "top", "bottom", "left", "right" } do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "snacks_terminal",
                    size = { height = 0.4 },
                    title = "%{b:snacks_terminal.id}: %{b:term_title}",
                    ---@diagnostic disable-next-line: unused-local
                    filter = function(_buf, win)
                        return vim.w[win].snacks_win
                            and vim.w[win].snacks_win.position == pos
                            and vim.w[win].snacks_win.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            return opts
        end,
    },

    -- prevent neo-tree from opening files in edgy windows
    {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = function(_, opts)
            opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
                or { "terminal", "Trouble", "qf", "Outline", "trouble" }
            table.insert(opts.open_files_do_not_replace_types, "edgy")
        end,
    },

    -- Fix bufferline offsets when edgy is loaded
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function()
            local Offset = require "bufferline.offset"
            if not Offset.edgy then
                local get = Offset.get
                ---@diagnostic disable-next-line: duplicate-set-field
                Offset.get = function()
                    if package.loaded.edgy then
                        local old_offset = get()
                        local layout = require("edgy.config").layout
                        local ret = { left = "", left_size = 0, right = "", right_size = 0 }
                        for _, pos in ipairs { "left", "right" } do
                            local sb = layout[pos]
                            if sb and #sb.wins > 0 then
                                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                                if pos == "left" then
                                    ret.left = old_offset.left_size > 0 and old_offset.left
                                        or ("%#Bold#" .. title .. "%*" .. "%#BufferLineOffsetSeparator#│%*")
                                    ret.left_size = old_offset.left_size > 0 and old_offset.left_size or sb.bounds.width
                                else
                                    ret.right = old_offset.right_size > 0 and old_offset.right
                                        or ("%#BufferLineOffsetSeparator#│%*" .. "%#Bold#" .. title .. "%*")
                                    ret.right_size = old_offset.right_size > 0 and old_offset.right_size
                                        or sb.bounds.width
                                end
                            end
                        end
                        ret.total_size = ret.left_size + ret.right_size
                        if ret.total_size > 0 then
                            return ret
                        end
                    end
                    return get()
                end
                Offset.edgy = true
            end
        end,
    },
}
