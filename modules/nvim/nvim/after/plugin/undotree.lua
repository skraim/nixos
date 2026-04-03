local g = vim.g

local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = '[U]ndotree: ' .. desc })
end

map("<leader>ut", vim.cmd.UndotreeToggle, "[T]oggle")

g.Undotree_CustomMap = function()
  vim.keymap.set("n", "H", "<Plug>UndotreePreviousSavedState", { buffer = true, desc = "Previous saved state" })
  vim.keymap.set("n", "A", "<Plug>UndotreeNextSavedState", { buffer = true, desc = "Next saved state" })
end

g.undotree_ShortIndicators = 1
g.undotree_SetFocusWhenToggle = 1
g.undotree_WindowLayout = 3
g.undotree_SplitWidth = 40
