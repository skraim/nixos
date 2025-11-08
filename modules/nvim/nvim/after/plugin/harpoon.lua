local harpoon = require("harpoon")

local function read_state_file()
    local file = io.open(os.getenv("HOME") .. "/states", "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()

    local kb_layout = content:match('KB_LAYOUT="(.-)"')
    return kb_layout
end

local kb_layout = read_state_file()

if not kb_layout then
    kb_layout = 'qwerty'
end

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

if kb_layout == 'qwerty' then
    vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-m>", function() harpoon:list():select(4) end)
end

if kb_layout == 'graphite' then
    vim.keymap.set("n", "<C-y>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-a>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-e>", function() harpoon:list():select(3) end)
end
