#!/bin/bash

SESSION_NAME="WebD_ka_Natak"

# Session bana rhe
tmux new-session -d -s $SESSION_NAME

# Splitting window upar bada
tmux split-window -v -l 26%
# Splitting window neeche patla aur first pane
tmux split-window -h -l 66%
# Splitting window neeche first ke bagal second jisse third apne aap agaya
tmux split-window -h -l 50%

# sb cheeze khol rhe
tmux send-keys -t $SESSION_NAME:0.0 'cd mid && nvim' C-m
tmux send-keys -t $SESSION_NAME:0.1 'cd mid && nodemon solution4.js' C-m
tmux send-keys -t $SESSION_NAME:0.2 'cava' C-m
tmux send-keys -t $SESSION_NAME:0.3 'cd mid && ls' C-m

# Attach to the session
tmux attach-session -t $SESSION_NAME
