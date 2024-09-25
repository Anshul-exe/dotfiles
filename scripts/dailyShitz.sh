#!/bin/bash

# Open terminal in workspace 1
i3-msg "workspace 1"
sleep 0.3
i3-msg "exec alacritty"
sleep 0.7 # Shorter delay to ensure Alacritty launches

# Open Chrome in workspace 2
i3-msg "workspace 2"
sleep 0.3
i3-msg "exec google-chrome-stable"
sleep 0.7 # Shorter delay to allow Chrome to launch

# Open Spotify in workspace 3
i3-msg "workspace 3"
sleep 0.3
i3-msg "exec spotify"
