"===========================================
"====== Mappings

" Set Map leader
let mapleader = " "

" Allow pressing <esc> in terminal mode
tnoremap <C-w> <C-\><C-n><C-w>

"Shift + Left/Right to switch buffers
map <S-LEFT> :bp<cr>
map <S-RIGHT> :bn<cr>
map <S-h> :bp<cr>
map <S-l> :bn<cr>

"Ctrl + UP/Down to skip lines
noremap <C-UP> 5k
noremap <C-Down> 5j
noremap <C-k> 5k
noremap <C-j> 5j

"Ctrl + Left/Right to skip characters
noremap <C-h> 5h
noremap <C-l> 5l

" Bind undo and redo
nnoremap <C-Z> u
nnoremap <S-u> <C-r>

" Enable mouse support
set mouse=a

" zz to save current buffer
map zz :w! <CR>

" Leader + q to close current buffer without closing window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Bind copying and pasting to and from clipboard
vnoremap  <leader>y  "+y
nnoremap <leader>p "+p

" Replace highlighted text with default register
" without yanking it
" map <leader>t "_dP

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

