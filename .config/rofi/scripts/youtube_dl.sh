#!/bin/bash
# Youtube format selection downloader
# Requires: youtube-dl

THEME=$HOME/.config/rofi/themes/flat-purple.rasi

URL=$(rofi -theme $THEME -threads 0 -lines 10 -width 50 -location 0 -dmenu -i -p "Url:")

RAW_RES=$(youtube-dl -F $URL)

VIDEO_FORMATS=$(echo "$RAW_RES" | tail -n +4)

HEADERS=$(echo "$RAW_RES" | sed '3q;d')

echo "$VIDEO_FORMATS" | rofi -dmenu -p " Format:" -theme "$THEME" -width "60%" -i -mesg "$HEADERS"
