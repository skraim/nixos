vim.pack.add({
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/mfussenegger/nvim-jdtls",
  "https://github.com/williamboman/mason-lspconfig.nvim",
});

require("mason").setup {
  -- ui = {
  --   icons = {
  --     package_installed = "✓",
  --     package_pending = "➜",
  --     package_uninstalled = "✗"
  --   }
  -- }
}
require("mason-tool-installer").setup({
  ensure_installed = {
    "tree-sitter-cli"
  },
})

require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "ts_ls", "jdtls", "qmlls", "hyprls", "qmlls", "cssls", "jsonls" },
  automatic_enable = {
    exclude = {
      "jdtls"
    }
  },
}

