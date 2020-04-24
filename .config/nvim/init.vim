"============================================================
" Neovim Config
"

"===========================================
"====== General

" Sets how many lines of history VIM has to remember
set history=500

" Set to auto read when a file is changed from the outside
set autoread

" A buffer becomes hidden when it is abandoned
set hidden

" Set lines viewable before and after cursor position
set so=4

" Have numbered lines enabled by default
set nu

" Always show current position
set ruler

" Wildmenu config
set wildmenu
set wildmode=longest:full,full

" Enable mouse support
set mouse=a

" Turn backup off
set nobackup
set nowb
set noswapfile

" Open new split windows to the bottom and right
set splitbelow
set splitright

" Auto change current working directory on file buffer changes
" set autochdir
autocmd BufEnter * silent! lcd %:p:h

" Prevent split windows resizing automatically
set noequalalways

" Better display for messages
set cmdheight=1

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"===========================================
"====== Functions

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
  if win_gotoid(g:term_win)
    hide
  else
    botright new
    exec "resize " . a:height
    try
      exec "buffer " . g:term_buf
    catch
      call termopen($SHELL, {"detach": 0})
      let g:term_buf = bufnr("")
      set nonumber
      set norelativenumber
      set signcolumn=no
    endtry
    startinsert!
    let g:term_win = win_getid()
  endif
endfunction

" Coc show documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


"===========================================
"====== Shortcuts, Keybinds, Keyboard, Mouse

" Set Map leader
let mapleader = ","

" Allow pressing <esc> in terminal mode
tnoremap <C-w> <C-\><C-n><C-w>

" Toggle terminal on/off (neovim)
"nnoremap <S-t> :call TermToggle(12)<CR>
"inoremap <S-t> <Esc>:call TermToggle(12)<CR>
"tnoremap <S-t> <C-\><C-n>:call TermToggle(12)<CR>

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
noremap <C-h> 10goN<space>
noremap <C-l> 1goN<space>

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Bind undo and redo
nnoremap <C-Z> u
" nnoremap <C-X> <C-R>

inoremap <C-Z> <C-O>u
"inoremap <C-X> <C-O><C-R>

" Enable mouse support
set mouse=a

" zz to save current buffer
map zz :w! <CR>

" Leader + , to close current buffer without closing window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Bind copying and pasting to and from clipboard
vnoremap  <leader>y  "+y
nnoremap <leader>p "+p

"" Use black hole register line deletion
"nnoremap dr "_d
"vnoremap dr "_d

" Replace highlighted text with default register
" without yanking it
map <leader>t "_dP

"===========================================
"====== Indentations, Filetypes, Syntax

" filetype indentation detection
filetype plugin indent on

" 1 tab is 2 spaces
set tabstop=2
set shiftwidth=2

" Use spaces instead of tabs
set expandtab

" Smart tabs
set smarttab

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Enable Syntax highlighting
syntax on

set ai "Auto indent
" set si "Smart indent
set wrap "Wrap lines


"===========================================
"===== Searching
" Highlight all searches
set hlsearch

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch


"===========================================
"===== Vim Plug

" check if vim-plug is installed, if it isn't, install it
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install VimPlug plugins
call plug#begin('~/.config/nvim/plugged')

" Multi Cursor
Plug 'terryma/vim-multiple-cursors'

" Themes
Plug 'liuchengxu/space-vim-dark'

" Text allignment on delimiters
Plug 'godlygeek/tabular'

" Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Visualize indentation levels and leading spaces
Plug 'yggdroot/indentline'

" Whitespace display
Plug 'ntpeters/vim-better-whitespace'

" Git for status bar or airline
Plug 'airblade/vim-gitgutter'

" File Browser
Plug 'scrooloose/nerdtree'
Plug 'terrahop/nerdtree-git-plugin'

" Toml Support
Plug 'cespare/vim-toml'

" Git Support
Plug 'tpope/vim-fugitive'

" Rust Support
Plug 'rust-lang/rust.vim'

" LanguageClient
"Plug 'autozimu/LanguageClient-neovim', {
"      \ 'branch': 'next',
"      \ 'do': 'bash install.sh',
"      \ }

" Language server suggestions
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Multi-entry selection UI.
" Requires: fzf
Plug 'junegunn/fzf'

" Rainbow Parenthesis Improved
Plug 'luochen1990/rainbow'

" Tagbar
" Requires: ctags
Plug 'majutsushi/tagbar'

" Rust Crate version disply in toml
Plug 'mhinz/vim-crates'

" Syntax Highlighting Language Packs
Plug 'sheerun/vim-polyglot'

call plug#end()


"===========================================
"===== Tagbar plguin
nmap <F8> :TagbarToggle<CR>


"===========================================
"===== Colors and Themes
" Enable theme
colorscheme space-vim-dark

" Set terminal gui colors
set termguicolors

" Custom theme stuff
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

" Enable italics in comments
hi Comment cterm=italic

" Rainbow Parenthesis
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" Column ruler
set colorcolumn=80,120


"===========================================
"===== Language Support - Using Coc

" Set update time
set updatetime=300

" Always show signcolumns
set signcolumn=yes

" Suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>af  <Plug>(coc-fix-current)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use Shift+F to format current buffer
nmap F :call CocAction('format')<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Coc Extension: coc-actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Vim Crates for rust toml format
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif


"===========================================
"===== Better Whitespace Plugin

" Enable trailing white space highlighting
highlight ExtraWhitespace ctermbg=lightgrey guibg=#4d1582

" Enable white space highlighting
let g:better_whitespace_enabled=1

" Auto trim white spaces on save
let g:strip_whitespace_on_save=1

" Don't highlight current lines white spaces
let g:current_line_whitespace_disabled_hard=1

" Don't ask to delete whitespaces on save
let g:strip_whitespace_confirm=0


"===========================================
"===== Indent Line Plugin

" Vim
let g:indentLine_setColors = 1
let g:indentLine_color_term = 239

" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

" Show leading spcaes
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'

" Quotes are concealed in Json and it messes with plugins
" To get quotes back in a json file in neovim:
" 1. Enter NeoVim
" 2. :e $VIMRUNTIME/syntax/json.vim
" 3. :g/if has('conceal')/s//& \&\& 0/
" 4. :wq
"
" https://github.com/Yggdroot/indentLine/issues/140#issuecomment-357620391
" let g:indentLine_concealcursor='nc'


"===========================================
"===== NERDTree Plugin

" Open NERDTree automatically when vim starts up
" autocmd vimenter * NERDTree

" Open NERDTree automatically when vim starts with no files
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close NERDTree with vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open Bookmarks automatically on launch
let NERDTreeShowBookmarks=1

" Show hidden files by default
let NERDTreeShowHidden=1

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

let g:NERDTreeShowIgnoredStatus = 1

" From nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : "☒",
    \ "Unknown"   : "?"
    \ }


"===========================================
"===== Git Support

" Don't use floating preview
let g:gitgutter_preview_win_floating = 0

" Set Priority
let g:gitgutter_sign_allow_clobber = 1


"===========================================
"===== Airline Plugin

" Show buffers in tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Format of file names in buffer tabs
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Use powerline fonts
let g:airline_powerline_fonts = 1

" Don't show empty sections
let g:airline_skip_empty_sections = 1

