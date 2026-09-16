local started = vim.uv.hrtime()
local result = { phases = {} }
local function snapshot(label)
    local stats = require "lazy.stats"
    local plugins, loaded = {}, 0
    for name, p in pairs(require("lazy.core.config").plugins) do
        local reason = p._.loaded
        if reason then
            loaded = loaded + 1
        end
        plugins[name] = {
            loaded = reason ~= nil,
            lazy = p.lazy,
            time_ms = reason and reason.time and reason.time / 1e6 or nil,
            reason = reason,
        }
    end
    result.phases[label] = {
        wall_ms = (vim.uv.hrtime() - started) / 1e6,
        cpu_ms = stats.cputime(),
        loaded = loaded,
        plugins = plugins,
    }
end
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        snapshot "ui_enter"
        vim.defer_fn(function()
            snapshot "after_2s"
            result.lazy_stats = require("lazy.stats").stats()
            result.errmsg = vim.v.errmsg
            result.messages = vim.api.nvim_exec2("messages", { output = true }).output
            result.filetype = vim.bo.filetype
            result.colorscheme = vim.g.colors_name
            result.clients = vim.tbl_map(function(c)
                return c.name
            end, vim.lsp.get_clients())
            vim.fn.writefile({ vim.json.encode(result) }, vim.env.KOALA_BENCH_OUTPUT)
            vim.cmd "qa!"
        end, 2000)
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
        vim.schedule(function()
            snapshot "very_lazy_done"
        end)
    end,
})
