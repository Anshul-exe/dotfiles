#!/usr/bin/env bash

WALL_1="$HOME/clear_space/Media/wallpapers/Junior.jpg"
WALL_2="$HOME/clear_space/Media/wallpapers/hill_house.jpg"

FEHBG="$HOME/.fehbg"

# If feh hasn't set a wallpaper yet, default to WALL_1
if [[ ! -f "$FEHBG" ]]; then
  feh --bg-scale "$WALL_1"
  exit 0
fi

if grep -qF "$WALL_1" "$FEHBG"; then
  feh --bg-scale "$WALL_2"
else
  feh --bg-scale "$WALL_1"
fi
