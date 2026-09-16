local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

local specs = {
    { import = "plugins" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.tools" },
}

local local_plugins = vim.fn.stdpath "config" .. "/lua/local/plugins"
if uv.fs_stat(local_plugins) or uv.fs_stat(local_plugins .. ".lua") then
    table.insert(specs, { import = "local.plugins" })
end

require("lazy").setup(specs)

require "config.keymaps"
require "config.autocmd"
pcall(require, "local.config")
