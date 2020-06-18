##### Quality of Life Aliases #####

## Zsh  ##
alias zshconfig="vim ~/.zshrc"
alias zshrestart="exec zsh"

## Fixes ##
alias sudo='sudo ' # allow sudo to be used with alias's

## Directory Listing ##
alias ls="exa"
alias la="ls -ahlL --color=auto --group-directories-first"
alias lal="ls -ahl --color=auto"
#alias ls="ls --color=auto"
alias perms="stat -c '%a - %n'" # List permissions of speicified file(s)
alias dux="du -d 1 -h | sort -h"
alias law='LS_COLORS="ow=01;36;40" ls -ahl' # Windows files listing with better colors

## File/Folder Manipulation ##
alias svim="sudo -E nvim"
alias vim="nvim"
alias mkx="chmod u+x"

## When quitting ranger, cd into last accessed directory in ranger
alias ranger='ranger --choosedir=$HOME/.cache/rangerdir; LASTDIR=`cat $HOME/.cache/rangerdir`; cd "$LASTDIR"'

## Terminal Shortcuts ##
alias x='clear'

## Moving/Copying ##
alias copy="rsync --partial --progress --append --rsh=ssh -r -h "
alias move="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

## systemctl Commands ##
which systemctl &>/dev/null
if [[ $? -eq 0 ]]; then
  which start &>/dev/null
  if [[ $? -eq 1 ]]; then
    alias start='sudo systemctl start'
  fi
  which stop &>/dev/null
  if [[ $? -eq 1 ]]; then
    alias stop='sudo systemctl stop'
  fi
  which restart &>/dev/null
  if [[ $? -eq 1 ]]; then
    alias restart='sudo systemctl restart'
  fi
  which status &>/dev/null
  if [[ $? -eq 1 ]]; then
    alias status='sudo systemctl status'
  fi
  #which enable &>/dev/null
  #if [[ $? -eq 1 ]]; then
  #  alias enable='sudo systemctl enable'
  #fi
fi

## Nvidia Driver toggling ##
nvidia-disable () {
  sudo touch /etc/modprobe.d/nvidia.conf
  cat << EOT | sudo tee /etc/modprobe.d/nvidia.conf
blacklist nouveau
blacklist nvidia
blacklist nvidia-drm
blacklist nvidia-modeset
EOT
}

nvidia-enable () {
  sudo rm /etc/modprobe.d/nvidia.conf
}

nvidia-on () {
  if lsmod | grep -q acpi_call; then
    echo '\\_SB.PCI0.PEG0.PEGP._ON' | sudo tee /proc/acpi/call
  fi
}

nvidia-off () {
  if [ -f /etc/modprobe.d/nvidia.conf ]; then
    if lsmod | grep -q acpi_call; then
      echo '\\_SB.PCI0.PEG0.PEGP._OFF' | sudo tee /proc/acpi/call
    fi
  else
    echo "Nvidia drivers need to be disabled for this work, run 'nvidia-disable' and restart with drivers blacklisted"
  fi
}

## Use fzf to for pacman
export pacinstall() {
  pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -rp sudo pacman -S --noconfirm
}
export pacremove() {
  pacman -Qqe | fzf -m --preview 'pacman -Si {1}' | xargs -rp sudo pacman -Rns --noconfirm
}

## Use sudoedit when opening a non user writable file
export v(){
  [ -w $1 ] && nvim $1 || sudoedit $1
}

