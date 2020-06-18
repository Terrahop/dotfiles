"============================================================
" Neovim Config
"

let configs = [
  \  "general",
  \  "ui",
  \  "functions",
  \  "mappings",
  \  "plugins",
  \  "colors",
  \  "plugins-settings",
  \ ]

for file in configs
  let x = expand("~/.config/nvim/configs/".file.".vim")
  if filereadable(x)
    execute 'source' x
  endif
endfor

