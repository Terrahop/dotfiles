"===========================================
"===== Vim Plug

" Install vim plug if it isn't
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.config/nvim/plugged')


" Multi Cursor
Plug 'terryma/vim-multiple-cursors'

" Color theme
Plug 'liuchengxu/space-vim-dark'

" Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Visualize indentation levels and leading spaces
Plug 'yggdroot/indentline'

" File Browser
Plug 'scrooloose/nerdtree'
Plug 'terrahop/nerdtree-git-plugin'

" Git Command Support
Plug 'tpope/vim-fugitive'

" Git for airline and gutter
Plug 'airblade/vim-gitgutter'

" Rust Lang support
Plug 'rust-lang/rust.vim'

" Rust Crate version disply in toml
Plug 'mhinz/vim-crates'

" clippy?
Plug 'wagnerf42/vim-clippy'

Plug 'dag/vim-fish'

" Coc - Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Tagbar
" Requires: ctags
Plug 'majutsushi/tagbar'

" Render markdown files in browser whilst editing
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

" Auto close (X)HTML tags
Plug 'alvan/vim-closetag'

" Vim Wiki
Plug 'vimwiki/vimwiki'

" Fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


call plug#end()

