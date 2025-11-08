local g = vim.g

vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)

g.Undotree_CustomMap = function()
  vim.keymap.set("n", "H", "<Plug>UndotreePreviousSavedState", { buffer = true })
  vim.keymap.set("n", "A", "<Plug>UndotreeNextSavedState", { buffer = true })
end

g.undotree_ShortIndicators = 1
g.undotree_SetFocusWhenToggle = 1
g.undotree_WindowLayout = 3
g.undotree_SplitWidth = 40
