set -l commands i r
complete -c pak -f

complete -fc pak -n "not __fish_seen_subcommand_from $commands" -a i -d "Install package"
complete -fc pak -n "not __fish_seen_subcommand_from $commands" -a r -d "Uninstall package"

complete -fc pak -n "__fish_seen_subcommand_from i" -a aur -d "From Aur repo"
complete -fc pak -n "__fish_seen_subcommand_from i" -a arch -d "From offical arch repo"

complete -fc pak -n "__fish_seen_subcommand_from r" -a aur -d "Externally installed packages"
complete -fc pak -n "__fish_seen_subcommand_from r" -a arch -d "Offically installed packages"
