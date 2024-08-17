#!/bin/bash

# Path to the state file
STATE_FILE="$HOME/.config/i3/split_state"

# Check if the state file exists, create it if not
if [ ! -f "$STATE_FILE" ]; then
  echo "v" >"$STATE_FILE"
fi

# Read the current split direction
current_split=$(cat "$STATE_FILE")

if [ "$current_split" = "v" ]; then
  i3-msg split h
  echo "h" >"$STATE_FILE"
else
  i3-msg split v
  echo "v" >"$STATE_FILE"
fi

# Open Alacritty
alacritty &
