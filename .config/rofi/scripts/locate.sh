# Simple file location script
# Requires: fd
target_path="$(fd . $HOME -H -d 6 -j 4| rofi -theme ~/.config/rofi/scripts/scripts-theme.rasi -no-config -threads 0 -lines 24 -width 60 -location 0 -dmenu -i -p "locate:")"

if [ ! "$target_path" == "" ]; then
  exec kitty -e xdg-open "$target_path"
fi
