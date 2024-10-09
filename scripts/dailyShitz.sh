#!/bin/bash

# Open Chrome in workspace 2
i3-msg "workspace 2"
sleep 0.3
i3-msg "exec google-chrome-stable"
sleep 0.7 # Shorter delay to allow Chrome to launch

# Open Spotify in workspace 3
i3-msg "workspace 3"
sleep 0.3
i3-msg "exec spotify"
sleep 0.7 # Shorter delay to allow Spotify to launch

# Return to workspace 1 and open Alacritty terminals
i3-msg "workspace 1"

# Open the first Alacritty terminal with a new tmux session (no name)
sleep 0.3
i3-msg "exec alacritty -e tmux"

# Open the second Alacritty terminal with a new tmux session named "Scratchpad"
sleep 0.7 # Shorter delay to ensure the first terminal is launched
i3-msg "exec alacritty -e tmux new-session -s Scratchpad"

# Wait a bit longer to ensure both terminals are ready
sleep 0.5

# Get the window ID of the last opened Alacritty window (second terminal)
SECOND_TERM_ID=$(xdotool search --onlyvisible --class Alacritty | tail -n 1)

# Move the second terminal to the scratchpad using its window ID
i3-msg "[id=$SECOND_TERM_ID] move scratchpad"

##!/bin/bash
#
## Open terminal in workspace 1
#i3-msg "workspace 1"
#sleep 0.3
#i3-msg "exec alacritty"
#sleep 0.7 # Shorter delay to ensure Alacritty launches
#
## Open Chrome in workspace 2
#i3-msg "workspace 2"
#sleep 0.3
#i3-msg "exec google-chrome-stable"
#sleep 0.7 # Shorter delay to allow Chrome to launch
#
## Open Spotify in workspace 3
#i3-msg "workspace 3"
#sleep 0.3
#i3-msg "exec spotify"
