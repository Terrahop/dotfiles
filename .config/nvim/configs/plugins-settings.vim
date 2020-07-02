"===========================================
"===== Language Support - Using Coc

"=== Functions
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
"===

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Give more space for displaying messages.
" set cmdheight=2

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" Use gk to show documentation in preview window.
nnoremap <silent> gk :call <SID>show_documentation()<CR>

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Apply AutoFix problem on the current line.
nmap <leader>f  <Plug>(coc-fix-current)

" Apply AutoFix for document with eslint
nmap <leader>F :call CocAction('runCommand', 'eslint.executeAutofix')<CR>

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use Shift+F to format current buffer
nmap F :call CocAction('format')<CR>

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CocList:
" Show all diagnostics.
nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Search workleader symbols.
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>cn  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>cp  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>

" Multiple Cursors support
" Requires: vim-multiple-cursors
"nmap <silent> <C-d> <Plug>(coc-cursors-word)

" Open a list of yanked text
" Coc Extension: coc-yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" Remap for do codeAction of selected region
" Coc Extension: coc-actions
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@


"===========================================
"===== Vim Crates

" Display rust crate versions in toml files
" Requires: vim-crates
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif


"===========================================
"===== Tagbar

" Toggle tab bar
nmap <leader>tt :TagbarToggle<CR>


"===========================================
"===== Buftabline

" Only show buffer tabs if there are at least 2 buffers
let g:buftabline_show = 1

" Show whether a buffer is modified
let g:buftabline_indicators = 1


"===========================================
"===== NERDTree + Git

" Close NERDTree with vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle NERDTree
nmap <silent> <leader>tr :NERDTreeToggle<CR>

" Open Bookmarks automatically on launch
let NERDTreeShowBookmarks=1

" Show hidden files by default
let NERDTreeShowHidden=1

" Remove '?' help
let NERDTreeMinimalUI = 1

" Show directory arrows
let NERDTreeDirArrows = 1

" Automatically delete buffer of deleted file
let NERDTreeAutoDeleteBuffer = 1

" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

" Show ignored(git) status
" Requires: nerdtree-git
let g:NERDTreeShowIgnoredStatus = 1

" Set custom git glyphs
" Requires: nerdtree-git
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
"===== Git Gutter

" Don't use floating preview
let g:gitgutter_preview_win_floating = 0

" Set Priority
let g:gitgutter_sign_allow_clobber = 1


"===========================================
"===== Vim Closetag

" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.js'

" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx, *.js'

" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ }


"===========================================
"===== Instant Markdown

" Don't automatically open a window preview
let g:instant_markdown_autostart = 0


"===========================================
"===== VimWiki

" Setup wiki options
let g:vimwiki_list = [{
  \ 'path': '~/Documents/wiki/',
  \ 'syntax': 'markdown', 'ext': '.md',
  \ 'auto_diary_index': 1
  \ }]

" Don't recognize non vim wiki markdown files as vimwiki filetype
let g:vimwiki_global_ext = 0

