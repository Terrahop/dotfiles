function pak -a cmd -d "Package listing for offical and AUR repos with fzf"

  set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME ~/.cache
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

  set -g fish_path $XDG_CONFIG_HOME/fish

  set -l pak_completion_file $fish_path/completions/pak.fish

  if test ! -e $pak_completion_file
    touch $pak_completion_file
    echo "pak complete" >$fish_path/completions/pak.fish
    _pak_complete
  end


  switch $argv[2]
    case aur
      if test $argv[1] = "i"
        yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S
      else if test $argv[1] = "r"
        yay -Qm | fzf -m --preview 'yay -Qi {1}' | xargs -ro yay -Rns
      end
    case arch
      if test $argv[1] = "i"
        pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
      else if test $argv[1] = "r"
        pacman -Q | fzf -m --preview 'pacman -Qi {1}' | xargs -ro yay -Rns
      end
    end
end

