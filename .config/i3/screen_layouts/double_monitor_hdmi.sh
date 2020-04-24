#!/bin/sh

OFFSET="${1%x*}"

if [ "$2" == "1" ]; then
  log "HDMI set to left"
  HDMI_POS="0x0"
  LAPTOP_POS="${OFFSET}x0"
else
  log "HDMI set to right"
  HDMI_POS="1920x0"
  LAPTOP_POS="0x0"
fi

xrandr --output $MONITOR_EDP --primary --mode 1920x1080 --dpi 100 --pos $LAPTOP_POS --rotate normal --rate 60.08 --output $MONITOR_HDMI --mode ${1%%+*} --dpi 100 --pos $HDMI_POS --rotate normal --output DP-0 --off --output DP-1 --off

sleep 1

# Apply 144hz
xrandr --output $MONITOR_EDP --mode 1920x1080 --rate 144.03 --dpi 100
