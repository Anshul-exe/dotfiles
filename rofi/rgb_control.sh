#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Red\nYellow\nGreen\nBlue\nPurple\nPink\nCyan\nPinkish\nSkin\nGold\nWhite\nBreathe\nCycle\nWave\nPulse" | rofi -dmenu -i -p "Konsa Rang Chahiye??:" -theme "$HOME/.config/rofi/topRight.rasi")

case "$CHOSEN" in
"Red")
  asusctl aura static -c ff0000
  ;;
"Yellow")
  asusctl aura static -c FFFF00
  ;;
"Green")
  asusctl aura static -c 008000
  ;;
"Blue")
  asusctl aura static -c 0000FF
  ;;
"Purple")
  asusctl aura static -c 800080
  ;;
"Pink")
  asusctl aura static -c FF1493
  ;;
"Cyan")
  asusctl aura static -c 00FFFF
  ;;
"Pinkish")
  asusctl aura static -c DC143C
  ;;
"Skin")
  asusctl aura static -c FF6347
  ;;
"Gold")
  asusctl aura static -c FFD700
  ;;
"White")
  asusctl aura static -c FFFACD
  ;;
"Breathe")
  asusctl aura breathe
  ;;
"Cycle")
  asusctl aura rainbow-cycle
  ;;
"Wave")
  asusctl aura rainbow-wave
  ;;
"Pulse")
  asusctl aura pulse
  ;;
*)
  exit 1
  ;;
esac

# -z flag can be used to specify the zone of the keyboard and in place of static we can specify the modes like rainbow, breathing, etc.
