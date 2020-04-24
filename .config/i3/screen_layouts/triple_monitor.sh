#!/bin/sh
xrandr --output $MONITOR_EDP --primary --mode 1920x1080 --pos 1920x0 --rotate normal --rate 60.08 --dpi 100 --output $MONITOR_DP --mode 1920x1080 --pos 3840x0 --rotate normal --output $MONITOR_HDMI --mode 1920x1080 --pos 0x0 --rotate normal --dpi 100

sleep 1

# Re-apply 144hz
xrandr --output $MONITOR_EDP --mode 1920x1080 --rate 144.03 --dpi 100
