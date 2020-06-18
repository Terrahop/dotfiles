#!/bin/bash

# Rofi File Search
#
# Search home directory for files and folders
#
# Requirements
# Search: fd

THEME=$HOME/.config/rofi/themes/flat-purple.rasi
target_path="$(fd . $HOME -H -d 6 -j 4 \
  | rofi -dmenu -p "locate:" \
  -theme $THEME -i )"

if [ ! "$target_path" == "" ]; then
  exec kitty -e xdg-open "$target_path"
fi
