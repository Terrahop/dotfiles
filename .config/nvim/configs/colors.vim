"===========================================
"===== Colors and Themes

" Enable theme
colorscheme space-vim-dark

" Set terminal gui colors(truecolor support)
set termguicolors

" Enable italics in comments
hi Comment cterm=italic

" Set custom colors
hi Normal       ctermbg=NONE guibg=NONE
hi LineNr       ctermbg=NONE guibg=NONE
hi SignColumn   ctermbg=NONE guibg=NONE
hi ColorColumn  ctermbg=NONE guibg=#2e2e2e

" Tabline colors
hi TablineSel   guifg=#ffffff guibg=#825BA8
hi PmenuSel     guifg=#ffffff guibg=#825BA8
hi Tabline      guifg=#ffffff guibg=#211F26
hi TablineFill  guibg=#000000

" Conceal color for showing leading spaces
hi Conceal guibg=NONE ctermbg=NONE ctermfg=darkgrey guifg=#363636

"===========================================
"===== Whitespaces

" Color to highlight unwanted spaces
highlight ExtraWhitespace ctermbg=lightgrey guibg=#7c0006

" Highlight all unwanted spaces
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

