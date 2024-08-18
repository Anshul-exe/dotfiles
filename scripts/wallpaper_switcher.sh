#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# List of wallpapers with custom names
# Format: Custom Name|Actual Filename
wallpapers=(
  "Astronaut|astronaut.jpg"
  "Wizard World|deez.jpg"
  "Batman & Joker|google_bg.jpg"
  "Batman|batman_minimalistic_bg.png"
  "Justice League|desktop_bg.jpg"
  "Lock Screen|LockScreen.jpg"
  "GKMC|gkmc_bg.jpg"
  "Miles Prowler|miles_bg.jpg"
  "Miles Spiderman|miles_r&b_bg.jpg"
  "Typecraft|nice-blue-background.png"
  "Rick|ricl.jpg"
  "Tux|a.jpg"
  "Rick and Morty|rickMorty.jpg"
)

# Generate rofi menu options
options=""
for entry in "${wallpapers[@]}"; do
  name=$(echo "$entry" | cut -d'|' -f1)
  file=$(echo "$entry" | cut -d'|' -f2)
  options+="$name\n"
done

# Show the rofi menu with the custom theme and get the selected option
selected=$(echo -e "$options" | rofi -dmenu -p "Select wallpaper:" -theme "$HOME/.config/rofi/topRight.rasi")

# Find the corresponding file for the selected wallpaper
selected_file=""
for entry in "${wallpapers[@]}"; do
  name=$(echo "$entry" | cut -d'|' -f1)
  file=$(echo "$entry" | cut -d'|' -f2)
  if [ "$selected" == "$name" ]; then
    selected_file="$WALLPAPER_DIR/$file"
    break
  fi
done

# Apply the selected wallpaper
if [ -n "$selected_file" ]; then
  wal -i "$selected_file"
else
  echo "No valid selection."
fi
