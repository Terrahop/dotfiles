#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Bar on Primary monitor
#MONITOR=$MONITOR1 polybar -r main &
polybar -r main &
# polybar -r tray &

#Bar on multiple monitors
#if type "xrandr"; then
#  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#    MONITOR=$m polybar --reload main &
#  done
#else
#  polybar --reload main &
#fi


#polybar main &
