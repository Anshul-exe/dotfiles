#!/bin/bash

CONFIG="$HOME/.config/picom/picom.conf"

if grep -q "^active-opacity = 1" "$CONFIG"; then
  sed -i '/^active-opacity = /s/1/0.75/' "$CONFIG"
  notify-send -u normal "Back to Asthetics ha??" "Lo, laga di Transparency"
else
  sed -i '/^active-opacity = /s/[0-9.]\+/1/' "$CONFIG"
  notify-send -u normal "Dikh nahi rha kya?" "Krdiye proper Opaque"
fi

pkill picom
picom
