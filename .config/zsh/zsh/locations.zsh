##### Set some default locations #####

## Set node location ##
export npm_config_devdir=/tmp/.gyp
export npm_config_cache=$HOME/.cache/npm

## Byobu Source ##
#_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true

## Rust Location ##
#export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.config/cargo/bin:$PATH"
export CARGO_HOME="$HOME/.config/cargo/"
export RUSTUP_HOME="$HOME/.config/rustup/"

## fpath ##
fpath+=~/.config/.zfunc

## Try to change/delete the zcompdump and zshrc.zwc files ##
export ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump-zsh-$ZSH_VERSION
export zcompdump_file=$HOME/.cache/zsh/.zcompdump

## NVM stuff
export NVM_DIR="$HOME/.config/nvm";
NODE_VERSION=$(cat $NVM_DIR/alias/default);
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use;
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";  # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"
