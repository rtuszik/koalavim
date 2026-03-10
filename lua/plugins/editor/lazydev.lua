return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            "lazy.nvim",
            "blink.cmp",
            "snacks.nvim",
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
