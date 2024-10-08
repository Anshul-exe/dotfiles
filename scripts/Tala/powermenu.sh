#!/bin/sh

CHOSEN=$(printf "Shutdown\nLog Out\nReboot\nLock\nSuspend" | rofi -dmenu -i -p "Power Menu:" -theme "$HOME/.config/rofi/topRight.rasi")

case "$CHOSEN" in
"Lock")
  ~/.scripts/Tala/lockscreen.sh
  ;;
"Suspend")
  # systemctl suspend-then-hibernate
  systemctl suspend
  ;;
"Reboot")
  sudo reboot
  ;;
"Shutdown")
  poweroff
  ;;
"Log Out")
  i3-msg exit
  ;;
*)
  exit 1
  ;;
esac
