"===========================================
"====== Neovim Config

" Configurations to load
let configs = [
  \  "general",
  \  "ui",
  \  "mappings",
  \  "plugins",
  \  "colors",
  \  "statusline",
  \  "plugins-settings",
  \ ]

for file in configs
  let x = expand("~/.config/nvim/configs/".file.".vim")
  if filereadable(x)
    execute 'source' x
  endif
endfor

