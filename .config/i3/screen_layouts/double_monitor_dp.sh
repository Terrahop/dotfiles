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

xrandr --output $MONITOR_EDP --primary --refresh 144 --mode 1920x1080  \
  --pos $LAPTOP_POS \
  --output $MONITOR_DP --mode ${1%%+*} --pos $DP_POS --auto

