##### Set history file parameters #####

## Set zsh history file location ##
export HISTFILE=$HOME/.shell/.zsh_history

HIST_STAMPS="DD/MM/YYYY"
HISTSIZE=50000
SAVEHIST=15000
HISTORY_IGNORE="(ls|ll|cd|la|lal|pwd|exit|l|c|x|dux|lad|perms|zshrestart|zshconfig|cd ..)"

HOSTNAME=`hostname -s || na`

setopt BANG_HIST                 # Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_FIND_NO_DUPS         # Don't display duplicates of previous lines when searching history
