return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        local ls = require "luasnip"

        ls.setup {
            history = true,
            update_events = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        }

        -- Load native Lua snippets from ~/.config/nvim/snippets/<filetype>.lua
        require("luasnip.loaders.from_lua").lazy_load {
            paths = { vim.fn.stdpath "config" .. "/snippets" },
        }
    end,
}
