#!/bin/bash

# Screenshots
#
# Screenshots uisng scrot
#
# Requirements
# scrot
#

#########################
# Vars
#########################

DATE=$(date +%F)

##########################
# functions
#########################


notify() {
  notify-send -t $1 -u low -a "Screenshot" "$2" --hint=int:transient:1
}

#########################
# Finalize
#########################

mkdir -p $HOME/Media/Screenshots/$DATE

notify "1000" "Select area or window to capture in 1 second"
sleep 1.5

scrot -s -f -c -b -q 30 -e 'xclip -selection c -t image/png < $f' \
  "$HOME/Media/Screenshots/$DATE/area-$(date +%H:%M:%S).png"


if [ "$?" == "0" ];
  then
    notify "Successfully Saved!"
  else
    notify "Something went wrong with the capture"
fi

