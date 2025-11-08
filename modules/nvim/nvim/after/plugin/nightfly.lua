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
    highlight BlinkCmpDocBorder guibg=NONE guifg=#82AAFF
    highlight BlinkCmpDocSeparator guibg=NONE guifg=#82AAFF
    highlight BlinkCmpSignatureHelpBorder guibg=NONE guifg=#82AAFF
    highlight LspInlayHint ctermfg=NONE guifg=#7C8F8F gui=italic
]]

