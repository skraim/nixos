vim.g.nightflyCursorColor = true
vim.g.nightflyTransparent = true
vim.g.nightflyWinSeparator = 2
vim.cmd [[
    colorscheme nightfly
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NormalFloat ctermbg=NONE guibg=NONE
    highlight FloatTitle ctermbg=NONE guibg=NONE
    highlight TroubleNormal ctermbg=NONE guibg=NONE
    highlight TroubleNormalNC ctermbg=NONE guibg=NONE
    highlight TroubleCount ctermbg=NONE guibg=NONE
    highlight LineNr ctermbg=NONE guibg=NONE
    highlight TroubleIndentWs ctermbg=NONE guibg=NONE
    highlight Comment ctermbg=NONE guibg=NONE
    highlight FloatBorder ctermbg=NONE guibg=NONE guifg=#82AAFF
    highlight SnacksPickerBorder ctermbg=NONE guibg=NONE guifg=#82AAFF
    highlight SnacksPickerPreviewTitle ctermbg=NONE guibg=NONE guifg=#C3CCDC
    highlight BlinkCmpDocBorder guibg=NONE guifg=#82AAFF
    highlight BlinkCmpDocSeparator guibg=NONE guifg=#82AAFF
    highlight BlinkCmpSignatureHelpBorder guibg=NONE guifg=#82AAFF
    highlight LspInlayHint ctermfg=NONE guifg=#7C8F8F gui=italic
    highlight DapBreakpoint guifg=#e06c75
    highlight DapBreakpointCondition guifg=#e5c07b
    highlight DapBreakpointRejected guifg=#e06c75
    highlight DapStopped guifg=#61afef guibg=#1f2d1f
    highlight DapStoppedLine guibg=#1f2d1f
]]
