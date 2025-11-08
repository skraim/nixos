vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle focus=true<cr>")

require("trouble").setup {
    keys = {
        ["<c-x>"] = "jump_split"
    }
}
