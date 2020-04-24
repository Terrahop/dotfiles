#!/bin/sh
xrandr --output HDMI-1-1 --off --output $MONITOR_EDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --rate 60.08 --dpi 100 --output DP-1 --off --output HDMI-0 --off --output DP-1-1 --off --output DP-0 --off
sleep 1
# Xrandr sometimes doesn't set refresh to 144hz correctly so need to enforce it
xrandr --output $MONITOR_EDP --mode 1920x1080 --rate 144.03 --dpi 100
