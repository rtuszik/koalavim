return {
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble" },
        opts = {},
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next Todo Comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous Todo Comment",
            },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        },
    },
    {
        "kawre/neotab.nvim",
        event = "InsertEnter",
        opts = {},
    },
    {
        "nmac427/guess-indent.nvim",
        lazy = false,
    },
}
