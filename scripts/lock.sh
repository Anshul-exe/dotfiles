#!/bin/bash
# Reduce screen brightness to 0
brightnessctl set 0

# Turn off Bluetooth
bluetoothctl power off

# Run your lockscreen script
/home/mir/.scripts/Tala/lockscreen.sh
