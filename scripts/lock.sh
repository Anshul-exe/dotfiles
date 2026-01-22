#!/usr/bin/env bash
set -Eeuo pipefail

USER_NAME=mir
USER_ID=$(id -u "$USER_NAME")

# Target the local X session (i3/Xorg). Works from SSH too.
export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-/home/$USER_NAME/.Xauthority}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USER_ID}"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

# Allow this user to connect to the local X server (harmless if already set)
# Needs the X socket reachable at $DISPLAY and a valid $XAUTHORITY cookie.
xhost +SI:localuser:"$USER_NAME" >/dev/null 2>&1 || true

# 1) Lock FIRST
/home/$USER_NAME/.scripts/Tala/lockscreen.sh || {
  echo "i3lock failed; is an X session on $DISPLAY and .Xauthority valid?"
  exit 1
}

# 2) Then dim and toggle radios
brightnessctl set 0 || true
bluetoothctl power off || true
amixer set Master toggle
