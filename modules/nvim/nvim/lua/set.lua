vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.laststatus = 3

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"
vim.opt.timeoutlen = 300

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.o.winborder = 'rounded'

vim.g.mapleader = " "

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local window_binding_group = vim.api.nvim_create_augroup("disable-window-bindings", { clear = true })

local function disable_window_bindings()
  vim.opt_local.scrollbind = false
  vim.opt_local.cursorbind = false
end

vim.api.nvim_create_autocmd({ "VimEnter", "WinNew", "WinEnter", "BufWinEnter" }, {
  desc = "Prevent splits from inheriting synchronized scrolling",
  group = window_binding_group,
  callback = disable_window_bindings,
})

vim.api.nvim_create_autocmd("OptionSet", {
  desc = "Keep synchronized scrolling disabled",
  group = window_binding_group,
  pattern = { "scrollbind", "cursorbind" },
  callback = function()
    if vim.v.option_new == "1" then
      vim.schedule(disable_window_bindings)
    end
  end,
})
