"===========================================
"===== Colors and Themes

" Enable theme
colorscheme space-vim-dark

" Set terminal gui colors(truecolor support)
set termguicolors

" Set custom colors
hi Normal       ctermbg=NONE guibg=NONE
hi LineNr       ctermbg=NONE guibg=NONE
hi SignColumn   ctermbg=NONE guibg=NONE
hi ColorColumn  ctermbg=NONE guibg=#2e2e2e

" Enable italics in comments
hi Comment cterm=italic

" Column ruler
set colorcolumn=80,120


"===========================================
"===== Whitespaces

" Show unwanted white spaces
highlight ExtraWhitespace ctermbg=lightgrey guibg=#4d1582

" Don't show whitespaces on the line currently being edited
match ExtraWhitespace /\s\+$/

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
