#!/bin/bash
# #!/usr/bin/env bash
#
# # Terminate already running bar instances
# # killall -q polybar
#
# sleep 0.1
# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     export MONITOR=$m
#     polybar -q main -c "$HOME"/.config/polybar/polybar.ini &
#   done
# else
#   polybar -q main -c "$HOME"/.config/polybar/polybar.ini &
# fi

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini

# Launch Polybar with the specified configuration file
polybar -c ~/.config/polybar/polybar.ini &
# polybar -c ~/.config/polybar/polybar.ini main &

polybar mybar 2>&1 | tee -a /tmp/polybar.log &
disown

echo "Polybar launched..."
