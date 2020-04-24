#!/bin/sh

OFFSET="${1%x*}"

if [ "$2" == "1" ]; then
  log "DP set to left"
  DP_POS="0x0"
  LAPTOP_POS="${OFFSET}x0"
else
  log "DP set to right"
  DP_POS="1920x0"
  LAPTOP_POS="0x0"
fi
xrandr --output $MONITOR_EDP --primary --mode 1920x1080 --dpi 100 --pos $LAPTOP_POS --rotate normal --rate 60.08 --output $MONITOR_DP --mode ${1%%+*} --dpi 100 --pos $DP_POS --rotate normal --output DP-0 --off --output DP-1 --off

sleep 1

# Re-apply 144hz
xrandr --output $MONITOR_EDP --mode 1920x1080 --rate 144.03 --dpi 100
