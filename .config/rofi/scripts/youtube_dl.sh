#!/bin/bash
# Youtube format selection downloader
# Requires: youtube-dl

THEME=$HOME/.config/rofi/themes/flat-purple.rasi

URL=$(rofi -theme $THEME -threads 0 -lines 10 -width 50 -location 0 -dmenu -i -p "Url:")

RAW_RES=$(youtube-dl -F $URL)

FORMATS=$(echo "$RAW_RES" | tail -n +4)

HEADERS=$(echo "$RAW_RES" | sed '3q;d')

FORMAT=$(echo "$FORMATS" | \
  rofi -dmenu -p " Format:" \
  -theme "$THEME" -width "60%" \
  -i -mesg "$HEADERS")

FORMAT_CODE=$(echo $FORMAT | awk '{print $1}')

youtube-dl -f $FORMAT_CODE -o "$HOME/Media/Videos/Youtube/%(title)s.%(ext)s" $URL
