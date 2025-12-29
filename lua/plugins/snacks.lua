local function term_nav(dir)
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">"
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end

return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,

    opts = {
        bigfile = { enabled = true },
        terminal = {
            win = {
                keys = {
                    nav_h = { "<C-h>", term_nav "h", desc = "Go to Left Window", expr = true, mode = "t" },
                    nav_j = { "<C-j>", term_nav "j", desc = "Go to Lower Window", expr = true, mode = "t" },
                    nav_k = { "<C-k>", term_nav "k", desc = "Go to Upper Window", expr = true, mode = "t" },
                    nav_l = { "<C-l>", term_nav "l", desc = "Go to Right Window", expr = true, mode = "t" },
                },
            },
        },
        dashboard = {
            enabled = true,
            row = nil,
            col = nil,
            pane_gap = 8,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    {
                        icon = "󰒲 ",
                        key = "L",
                        desc = "Lazy",
                        action = ":Lazy",
                        enabled = package.loaded.lazy ~= nil,
                    },
                },
                header = [[
     ██ ▄█▀ ▒█████   ▄▄▄       ██▓    ▄▄▄    ██▒   █▓ ██▓ ███▄ ▄███▓
     ██▄█▒ ▒██▒  ██▒▒████▄    ▓██▒   ▒████▄ ▓██░   █▒▓██▒▓██▒▀█▀ ██▒
    ▓███▄░ ▒██░  ██▒▒██  ▀█▄  ▒██░   ▒██  ▀█▄▓██  █▒░▒██▒▓██    ▓██░
    ▓██ █▄ ▒██   ██░░██▄▄▄▄██ ▒██░   ░██▄▄▄▄██▒██ █░░░██░▒██    ▒██
    ▒██▒ █▄░ ████▓▒░ ▓█   ▓██▒░██████▒▓█   ▓██▒▒▀█░  ░██░▒██▒   ░██▒
    ▒ ▒▒ ▓▒░ ▒░▒░▒░  ▒▒   ▓▒█░░ ▒░▓  ░▒▒   ▓▒█░░ ▐░  ░▓  ░ ▒░   ░  ░
    ░ ░▒ ▒░  ░ ▒ ▒░   ▒   ▒▒ ░░ ░ ▒  ░ ▒   ▒▒ ░░ ░░   ▒ ░░  ░      ░
    ░ ░░ ░ ░ ░ ░ ▒    ░   ▒     ░ ░    ░   ▒     ░░   ▒ ░░      ░
    ░  ░       ░ ░        ░  ░    ░  ░  ░     ░  ░   ░   ░         ░
                                                 ░
      ]],
            },
            sections = {
                { section = "header", padding = { 1, 20 } },
                { section = "keys", gap = 1, padding = 1 },
            },
        },
        explorer = { enabled = false },
        image = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = {
            enabled = true,
            matcher = {
                frecency = true,
            },
        },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    config = function(_, opts)
        vim.g.autoformat = true -- Enable format on save by default

        local original_notify = vim.notify
        require("snacks").setup(opts)
        vim.ui.select = require("snacks").picker.select
        vim.ui.input = require("snacks").input.input
        if require("lazy.core.config").plugins["noice.nvim"] then
            vim.notify = original_notify
        end

        -- Format on save toggle
        Snacks.toggle
            .new({
                id = "format_on_save",
                name = "Format on Save",
                get = function()
                    return vim.g.autoformat
                end,
                set = function(_)
                    vim.g.autoformat = not vim.g.autoformat
                end,
            })
            :map "<leader>uf"
    end,
    keys = {
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>S",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select Scratch Buffer",
        },
        {
            "<leader>dps",
            function()
                Snacks.profiler.scratch()
            end,
            desc = "Profiler Scratch Buffer",
        },
        {
            "<leader>n",
            function()
                if Snacks.config.picker and Snacks.config.picker.enabled then
                    Snacks.picker.notifications()
                else
                    Snacks.notifier.show_history()
                end
            end,
            desc = "Notification History",
        },
        {
            "<leader>un",
            function()
                Snacks.notifier.hide()
            end,
            desc = "Dismiss All Notifications",
        },
    },
}
