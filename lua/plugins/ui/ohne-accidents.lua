return {
    "blumaa/ohne-accidents.nvim",
    event = "UIEnter",
    ---@type OhneAccidentsConfig
    opts = {},
    keys = {
        {
            "<leader>oh",
            ":OhneAccidents<CR>",
            desc = "Time since last config change",
        },
    },
}
