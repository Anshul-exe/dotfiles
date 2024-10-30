#!/bin/bash

# Chrome in workspace 2
i3-msg "workspace 2"
sleep 0.3
i3-msg "exec google-chrome-stable"
sleep 0.7

# Spotify in workspace 3
i3-msg "workspace 3"
sleep 0.3
i3-msg "exec spotify"
sleep 0.9

# Back to workspace 1 and open Alacritty
i3-msg "workspace 1"

# First terminal
sleep 0.3
i3-msg "exec alacritty -e tmux"

# Second terminal as a scratchpad
sleep 0.7
i3-msg "exec alacritty -e tmux new-session -s Scratchpad"
sleep 0.5

# Get the window ID of the second terminal
SECOND_TERM_ID=$(xdotool search --onlyvisible --class Alacritty | tail -n 1)

# Window ID se second terminal ko scratchpad me convert
i3-msg "[id=$SECOND_TERM_ID] move scratchpad"
