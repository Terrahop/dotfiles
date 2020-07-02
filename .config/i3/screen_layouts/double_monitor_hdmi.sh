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

xrandr --output $MONITOR_EDP --primary --refresh 144 --mode 1920x1080 \
  --pos $LAPTOP_POS \
  --output $MONITOR_HDMI --mode ${1%%+*} --pos $HDMI_POS --auto

