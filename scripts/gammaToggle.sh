#!/bin/bash

PIDFILE="$HOME/.cache/gammastep.pid"

if pgrep -x gammastep >/dev/null; then
  pkill -x gammastep
  notify-send "🧊 Night Light Disabled"
else
  nohup gammastep -c ~/.config/gammastep/config.ini >/dev/null 2>&1 &
  echo $! >"$PIDFILE"
  notify-send "🔥 Night Light Enabled"
fi
