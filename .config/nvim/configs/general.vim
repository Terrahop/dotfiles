"===========================================
"====== General

" Sets how many lines of history VIM has to remember
set history=500

" Set to auto read when a file is changed from the outside
set autoread

" A buffer becomes hidden when it is abandoned
set hidden

" Set lines viewable before and after cursor position
set so=3

" Wildmenu config
set wildmenu
set wildmode=longest:full,full

" Enable mouse support
set mouse=a

" Turn backup off
set nobackup
set nowb
set noswapfile

" Prevent split windows resizing automatically
set noequalalways

" Set update time
set updatetime=300

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search into subfolders
set path+=**

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Auto change current working directory on file buffer changes
" set autochdir
autocmd BufEnter * silent! lcd %:p:h

