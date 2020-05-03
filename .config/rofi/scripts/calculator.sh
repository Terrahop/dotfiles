# Rofi Calculator script
# Requires libqcalc installed
THEME=$HOME/.config/rofi/themes/flat-purple.rasi
rofi -theme $THEME \
  -show calc -modi calc \
  -no-show-match -no-sort \
  -calc-command "echo '{result}' | xclip -selection c"
