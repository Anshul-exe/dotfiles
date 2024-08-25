#!/bin/sh

# Power menu script using rofi

CHOSEN=$(printf "Red\nYellow\nGreen\nBlue\nPurple\nPink\nCyan\nPinkish\nSkin\nGold\nWhite" | rofi -dmenu -i -p "Konsa Rang Chahiye??:" -theme "$HOME/.config/rofi/topRight.rasi")

case "$CHOSEN" in
"Red")
  asusctl led-mode static -c ff0000
  ;;
"Yellow")
  asusctl led-mode static -c FFFF00
  ;;
"Green")
  asusctl led-mode static -c 008000
  ;;
"Blue")
  asusctl led-mode static -c 0000FF
  ;;
"Purple")
  asusctl led-mode static -c 800080
  ;;
"Pink")
  asusctl led-mode static -c FF1493
  ;;
"Cyan")
  asusctl led-mode static -c 00FFFF
  ;;
"Pinkish")
  asusctl led-mode static -c DC143C
  ;;
"Skin")
  asusctl led-mode static -c FF6347
  ;;
"Gold")
  asusctl led-mode static -c FFD700
  ;;
"White")
  asusctl led-mode static -c FFFACD
  ;;
*)
  exit 1
  ;;
esac
