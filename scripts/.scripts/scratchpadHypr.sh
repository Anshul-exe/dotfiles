#!/bin/bash

# Get the currently focused window
focused_window=$(hyprctl activewindow)

# Check if the window is already in the scratchpad
if hyprctl activewindow | grep -q "scratchpad"; then
  # If it's in the scratchpad, bring it back to its original size
  hyprctl dispatch windowrule "$focused_window" resize set 100 100
  hyprctl dispatch magic "scratchpad"
else
  # If it's not in the scratchpad, send it there and resize it
  hyprctl dispatch windowrule "$focused_window" resize set 50 50
  hyprctl dispatch magic "scratchpad"
fi
