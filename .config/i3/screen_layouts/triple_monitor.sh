#!/bin/sh

xrandr --output $MONITOR_EDP --primary --mode 1920x1080 --pos 1920x0 \
  --refresh 144 \
  --output $MONITOR_HDMI --mode $1 --pos 0x0 --auto \
  --output $MONITOR_DP --mode $2 --pos 3840x0 --auto

