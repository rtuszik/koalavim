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
        profiler = { enabled = true },
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

        -- Profiler: start/stop and toggle inline highlights
        Snacks.toggle.profiler():map "<leader>dpp"
        Snacks.toggle.profiler_highlights():map "<leader>dph"
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
            "<leader>dpe",
            function()
                -- Traces persist after stop (until the next start), so this works
                -- even after the on-stop picker has already opened and been closed.
                local traces = Snacks.profiler.find { group = "name", sort = "time" }
                if vim.tbl_isempty(traces) then
                    return vim.notify("No profiler traces captured yet", vim.log.levels.WARN)
                end
                -- Each grouped row keeps its member calls as array children and
                -- carries a live `fn` ref vim.json can't encode. Keep only the
                -- aggregate scalars; dropping the children avoids a huge file.
                local function clean(trace)
                    return {
                        name = trace.name,
                        time = trace.time, -- nanoseconds, summed over the group
                        count = trace.count,
                        loc = trace.loc and {
                            file = trace.loc.file,
                            line = trace.loc.line,
                            plugin = trace.loc.plugin,
                        } or nil,
                    }
                end
                local path = vim.fn.stdpath "state" .. "/snacks-profiler.json"
                vim.fn.writefile(vim.split(vim.json.encode(vim.tbl_map(clean, traces)), "\n"), path)
                vim.notify("Profiler traces → " .. path, vim.log.levels.INFO)
            end,
            desc = "Export Profiler Traces to JSON",
        },
        {
            "<leader>n",
            function()
                if Snacks.config.get("picker", {}).enabled then
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
