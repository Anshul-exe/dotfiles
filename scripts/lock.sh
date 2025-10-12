#!/bin/bash

# Fix environment for SSH → local graphical session
export DISPLAY=:0
export XAUTHORITY=/home/mir/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Reduce screen brightness to 0
sudo brightnessctl set 0

# Turn off Bluetooth
bluetoothctl power off

# Run your lockscreen script
/home/mir/.scripts/Tala/lockscreen.sh
