return {
    "prismatic-koi/nvim-sops",
    event = { "BufEnter" },
    opts = {
        debug = true,
    },
    config = function()
        vim.keymap.set("n", "<leader>oe", vim.cmd.SopsEncrypt, { desc = "[E]ncrypt [F]ile" })
        vim.keymap.set("n", "<leader>od", vim.cmd.SopsDecrypt, { desc = "[D]ecrypt [F]ile" })
    end,
}
