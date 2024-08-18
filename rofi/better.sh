#!/bin/bash

if [ -n "$(xdotool search --onlyvisible --class rofi getwindowname)" ]; then
  killall rofi
else
  rofi -show drun -show-icons -theme "~/.config/rofi/rofidmenu.rasi"
fi
