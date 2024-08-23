#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Shutdown\nLog Out\nReboot\nLock\nSuspend" | rofi -dmenu -i -p "Power Menu:" -theme "$HOME/.config/rofi/topRight.rasi")

case "$CHOSEN" in
"Lock")
  lockscreen # Replace with your lock command
  ;;
"Suspend")
  systemctl suspend-then-hibernate
  ;;
"Reboot")
  sudo reboot
  ;;
"Shutdown")
  poweroff
  ;;
"Log Out")
  i3-msg exit # Replace with your logout command
  ;;
*)
  exit 1
  ;;
esac
