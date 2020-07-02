"===========================================
"====== Status Line

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return '  '.fugitive#head().' '
  else
    return ''
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

function! BufferNumb()
  let l:buffernum = len(getbufinfo({'buflisted':1}))
  if (l:buffernum > 1)
    return '  '.bufnr(). ' '
  else
    return ' '
  endif
endfunction

function! CocGetErrors()
  let info = get(b:, 'coc_diagnostic_info', {})

  if empty(get(info, 'error', 0)) | return '' | endif

  return '  E'.info['error'].' '

endfunction

function! CocGetWarnings()
  let info = get(b:, 'coc_diagnostic_info', {})

  if empty(get(info, 'warning', 0)) | return '' | endif

  return ' W'.info['warning'].' '

endfunction

function ModeColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusMode guifg=#ffffff guibg=#825BA8'
  elseif (mode() =~# '\v(v|V)' || mode() ==# "\<C-V>" )
    exe 'hi! StatusMode guifg=#ffffff guibg=#4e4ed4'
  elseif (mode() ==# 'R')
    exe 'hi! StatusMode guifg=#ffffff guibg=#a30e5d'
  elseif (mode() ==# 'i')
    exe 'hi! StatusMode guifg=#ffffff guibg=#df4bc2'
  else
    exe 'hi! StatusMode guifg=#ffffff guibg=#521BA8'
  endif

  return ''
endfunction

let g:currentmode={
    \ 'n'      : 'NORMAL',
    \ 'no'     : 'NORMAL·OP',
    \ 'v'      : 'VISUAL',
    \ 'V'      : 'VISUAL Line',
    \ "\<C-V>" : 'VISUAL Block',
    \ 's'      : 'SELECT CHAR',
    \ 'S'      : 'SELECT LINE',
    \ "\<C-S>" : 'SELECT BLOCK',
    \ 'i'      : 'INSERT',
    \ 'R'      : 'REPLACE',
    \ 'Rv'     : 'REPLACE VIRT',
    \ 'c'      : 'Command-line',
    \ 'cv'     : 'Vim Ex ',
    \ 'ce'     : 'Normal Ex ',
    \ 'r'      : 'Prompt ',
    \ 'rm'     : 'More ',
    \ 'r?'     : 'Confirm ',
    \ '!'      : 'Shell ',
    \ 't'      : 'Terminal '
    \ }

set statusline=
set statusline+=%{ModeColor()}                                  " Toggle color with mode
set statusline+=%#StatusMode#\ %{g:currentmode[mode()]}\        " Show current mode
set statusline+=%#StatusBGGrey#%{GitInfo()}                     " Extension: Fugitive git branch
set statusline+=%#StatusBuffer#%{BufferNumb()}                  " Buffer number
set statusline+=%#StatusTextGrey#%f                             " File name
set statusline+=%#StatusRO#%2{ReadOnly()}                       " Readonly flag
set statusline+=%#StatusBGPink#\ %m                             " Modified Flag
set statusline+=%=                                              " Switch to right side
set statusline+=%#StatusBGGrey#\ %y                             " File Type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}      " File Encoding
set statusline+=\[%{&fileformat}\]\                             " File Format
set statusline+=%#StatusMode#\ %p%%\ %l:%c\                     " Show cursor line:col
set statusline+=%#StatusWarning#%{CocGetWarnings()}             " Extensions: Coc Warnings
set statusline+=%#StatusError#%{CocGetErrors()}                 " Extensions: Coc Errors

" Always show statusline
set laststatus=2

" Statusline Colors
hi StatusBGPink     guifg=#ff66ff guibg=#000000
hi StatusBGGrey     guifg=#b4b2b9 guibg=#211F26
hi StatusTextGrey   guifg=#7f7f7f guibg=#000000
hi StatusRO         guifg=#c9146f guibg=#000000
hi StatusBuffer     guifg=#825BA8 guibg=#000000
hi StatusWarning    guifg=#ffffff guibg=#d66820
hi StatusError      guifg=#ffffff guibg=#d81111
hi StatusPurple     guifg=#ffffff guibg=#825BA8

