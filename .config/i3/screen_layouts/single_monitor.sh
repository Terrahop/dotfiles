#!/bin/sh

# Disable all interfaces except laptop
xrandr --output $MONITOR_EDP --refresh 144 --mode 1920x1080 --pos 0x0 \
  --output HDMI-0 --off \
  --output HDMI-1-1 --off \
  --output DP-0 --off \
  --output DP-1-1 --off \
