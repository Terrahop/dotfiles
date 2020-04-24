# Rofi Calculator script
# Requires libqcalc installed
rofi -theme ~/.config/rofi/scripts/scripts-theme.rasi -no-config -show calc -modi calc -no-show-match -no-sort -calc-command "echo '{result}' | xclip -selection c"
