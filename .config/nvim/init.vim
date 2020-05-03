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

" Set update time
set updatetime=300

" Always show signcolumns
set signcolumn=yes

" Highlight all searches
set hlsearch

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"===========================================
"====== Functions

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

" Bind undo
nnoremap <C-Z> u
inoremap <C-Z> <C-O>u

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

"Auto indent
set ai
"Smart indent
"set si
"Wrap lines
set wrap


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

" Git Support
Plug 'tpope/vim-fugitive'

" Rust Support
Plug 'rust-lang/rust.vim'

" Coc - Use release branch (Recommended)
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

" Enable Rainbow Parenthesis
let g:rainbow_active = 1

" Column ruler
set colorcolumn=80,120


"===========================================
"===== Tagbar plguin
nmap <F8> :TagbarToggle<CR>


"===========================================
"===== Language Support - Using Coc

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" Give more space for displaying messages.
set cmdheight=2

"" Functions

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

""

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> to confirm completion
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>f  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use Shift+F to format current buffer
nmap F :call CocAction('format')<CR>

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

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

" Coc Extension: coc-yank
" Map yank list open
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>


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

