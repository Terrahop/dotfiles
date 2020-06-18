#!/bin/bash

# Screenshots
#
# Screenshots uisng scrot
#
# Requirements
# scrot

#########################
# Vars
#########################

DATE=$(date +%F)
SCREENSHOT_DIR="$HOME/Media/Screenshots/$DATE"

##########################
# Functions
#########################

# Helper: Test if a command exists
# $1: command
# $2: friendly command name
check() {
  command -v $1 > /dev/null 2>&1 ||
    { echo "'$2' not found, Please install it."; exit 1;  }
}

# Do setup and checks
setup() {
  check scrot "Scrot"
  echo "idir: $SCREENSHOT_DIR"
  mkdir -p $SCREENSHOT_DIR
}

notify() {
  notify-send -t $1 -u low -a "Screenshot" "$2" --hint=int:transient:1
}

# Take an area screenshot that copies it to clipboard and saves it to the
# screenshot directory
area_shot() {
  notify "1000" "Select area or window to capture in 1 second"
  sleep 1.2
  scrot -s -f -c -b -q 30 -e 'xclip -selection c -t image/png < $f' \
    "$SCREENSHOT_DIR/area-$(date +%H:%M:%S).png"


  if [ "$?" == "0" ];
  then
    notify "Successfully Saved!"
  else
    notify "Something went wrong with the capture"
  fi
}

#########################
# Finalize
#########################

setup
area_shot

