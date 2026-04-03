vim.lsp.config('qmlls', {
  cmd = { 'qmlls' },
  filetypes = { 'qml', 'qmljs' },
  root_markers = { '.git', '.qmlls.ini', 'CMakeLists.txt' },
})

vim.lsp.enable('qmlls')
