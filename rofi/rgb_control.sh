#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Red\nYellow\nGreen\nBlue\nPurple\nPink\nCyan\nPinkish\nSkin\nGold\nWhite\nBreathe\nCycle\nWave\nPulse" | rofi -dmenu -i -p "Konsa Rang Chahiye??:" -theme "$HOME/.config/rofi/topRight.rasi")

case "$CHOSEN" in
"Red")
  asusctl aura effect static -c ff0000
  ;;
"Yellow")
  asusctl aura effect static -c FFFF00
  ;;
"Green")
  asusctl aura effect static -c 008000
  ;;
"Blue")
  asusctl aura effect static -c 0000FF
  ;;
"Purple")
  asusctl aura effect static -c 800080
  ;;
"Pink")
  asusctl aura effect static -c FF1493
  ;;
"Cyan")
  asusctl aura effect static -c 00FFFF
  ;;
"Pinkish")
  asusctl aura effect static -c DC143C
  ;;
"Skin")
  asusctl aura effect static -c FF6347
  ;;
"Gold")
  asusctl aura effect static -c FFD700
  ;;
"White")
  asusctl aura effect static -c FFFACD
  ;;
"Breathe")
  asusctl aura breathe
  ;;
"Cycle")
  asusctl aura effect rainbow-cycle --speed med
  ;;
"Wave")
  asusctl aura effect rainbow-wave --direction right --speed med
  ;;
"Pulse")
  asusctl aura effect pulse -c ffffff
  ;;
*)
  exit 1
  ;;
esac

# -z flag can be used to specify the zone of the keyboard and in place of static we can specify the modes like rainbow, breathing, etc.
