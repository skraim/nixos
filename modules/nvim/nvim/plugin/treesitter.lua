vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
})

require('treesitter-context').setup({
  multiline_threshold = 1,
  max_lines = 15
});

