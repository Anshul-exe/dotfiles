#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/clear_space/Media/wallpapers"

# List of wallpapers with custom names
# Format: Custom Name|Actual Filename
wallpapers=(
  "Junior|Junior.jpg"
  "Hill House|hill_house.jpg"
  "Astronaut|astronaut.jpg"
  "Hand|hand.png"
  "Purple|purple.jpg"
  "Woman|woman.png"
  "Camping|camping.jpg"
  "Wizard World|deez.jpg"
  "Rick|ricl.jpg"
  "Batman & Joker|google_bg.jpg"
  "Batman|batman_minimalistic_bg.png"
  "Justice League|desktop_bg.jpg"
  "Lock Screen|LockScreen.jpg"
  "GKMC|gkmc_bg.jpg"
  "Miles Prowler|miles_bg.jpg"
  "Miles Spiderman|miles_r&b_bg.jpg"
  "Typecraft|nice-blue-background.png"
  "Tux|a.jpg"
  "Rick and Morty|rickMorty.jpg"
  "Nuts|Nuts.jpg"
  "Night Night|FACE.png"
  "Black|black.png"
  "White|white.jpg"
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

# Check if the selected option is 'Change Wallpaper'
if [ "$selected" == "Change Wallpaper" ]; then
  rofi -dmenu -p "Select wallpaper to apply:" -theme "$HOME/.config/rofi/topRight.rasi" | while read -r wallpaper_name; do
    # Find the corresponding file for the selected wallpaper
    selected_file=""
    for entry in "${wallpapers[@]}"; do
      name=$(echo "$entry" | cut -d'|' -f1)
      file=$(echo "$entry" | cut -d'|' -f2)
      if [ "$wallpaper_name" == "$name" ]; then
        selected_file="$WALLPAPER_DIR/$file"
        break
      fi
    done

    # Apply the selected wallpaper
    if [ -n "$selected_file" ]; then
      feh --bg-fill "$selected_file"
    else
      echo "No valid selection."
    fi
  done
else
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
    feh --bg-fill "$selected_file"
  else
    echo "No valid selection."
  fi
fi
