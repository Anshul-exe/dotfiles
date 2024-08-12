#!/bin/sh
#
# # Power menu script using tofi
#
# CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | rofi --config "$HOME"/.config/rofi/powermenu-config)
#
# case "$CHOSEN" in
# "Lock") lockscreen ;;
# "Suspend") systemctl suspend-then-hibernate ;;
# "Reboot") reboot ;;
# "Shutdown") poweroff ;;
# "Log Out") hyprctl dispatch exit ;;
# *) exit 1 ;;
# esac

#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Shutdown\nLog Out\nReboot\nLock\nSuspend" | rofi -dmenu -i -p "Power Menu:" -theme "$HOME/.config/rofi/rofidmenu.rasi")

case "$CHOSEN" in
"Lock")
  lockscreen # Replace with your lock command
  ;;
"Suspend")
  systemctl suspend-then-hibernate
  ;;
"Reboot")
  reboot
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
