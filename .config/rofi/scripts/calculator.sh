#!/bin/bash

# Rofi Calculator
#
# Rofi with libqcalc
#
# Requirements
# Plugin: rofi-calc
# Library: libqalculate


THEME=$HOME/.config/rofi/themes/flat-purple.rasi
rofi -theme $THEME \
  -show calc -modi calc \
  -no-show-match -no-sort \
  -calc-command "echo '{result}' | xclip -selection c"
