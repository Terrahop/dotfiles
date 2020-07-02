# ~/.config/fish/config.fish

## Load extra
source $HOME/.config/fish/extra.fish

#########################
# Env
#########################

## Defaults
set -gx EDITOR "nvim"
set -gx BROWSER "firefox"
set -gx FILEMANAGER "ranger"
set -gx TERMINAL "kitty"
set -gx XDG_CONFIG_HOME "$HOME/.config"

## Remove greeting
set fish_greeting

## w3m
set -gx WWW_HOME "$HOME/.config/w3m"

## Emacs doom
set -gx DOOMDIR "$HOME/.config/doom.d"

## Rust
set -gx CARGO_HOME "$HOME/.config/cargo/"
set -gx RUSTUP_HOME "$HOME/.config/rustup/"
set -gx PATH "$HOME/.config/cargo/bin:$PATH"
set -gx RUSTC_WRAPPER "$HOME/.config/cargo/bin/sccache"

## NodeJs, Nvm
set -gx npm_config_cache "$HOME/.cache/npm"
set -gx npm_config_devdir "/$HOME/.cache/npm-gyp"
set -gx nvm_prefix "$HOME/.config/nvm-pfx"
set -gx NVM_DIR "$HOME/.config/nvm"

## Fzf
set -gx FZF_COMPLETE 3
set -gx FZF_COMPLETION_TRIGGER "**"
set -gx FZF_DEFAULT_COMMAND "fd . -H -L -p -a"
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border "

## Starship Prompt
set -gx STARSHIP_CONFIG "$HOME/.config/fish/starship.toml"

## Fisher
# Set custom fisher path
set -g fisher_path $HOME/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

# Install fisher if it doesn't exist
if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher

  # Install each package in the fish file
  for package in $HOME/.config/fish/fishfile
    fisher add package
  end
end

# Load fisher files
for file in $fisher_path/conf.d/*.fish
    source $file 2> /dev/null
end

## Prompt
starship init fish | source

# Run fish ssh agent
fish_ssh_agent

#########################
# Aliases
#########################

alias fishc "nvim ~/.config/fish"
alias la "exa -ahl --group-directories-first"
alias mkx "chmod u+x"
alias v nvim
alias sv "sudo -E nvim"
alias perms "stat -c '%a - %n'"
alias dux "du -d 1 -h | sort -h"
alias x clear

alias setclip "xclip -selection c"
alias getclip "xclip -selection c -o"

alias copy "rsync --update -rh --info=progress2"
alias move "rsync --update -rh --info=progress2 --remove-sent-files"

# Quit ranger into navigated folder
alias ranger "ranger --choosedir=$HOME/.cache/rangerdir; cd (cat $HOME/.cache/rangerdir)"

