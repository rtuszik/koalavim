return {
    "aserowy/tmux.nvim",
    enabled = vim.env.TMUX ~= nil and vim.env.TMUX ~= "",
    config = function()
        return require("tmux").setup()
    end,
}
