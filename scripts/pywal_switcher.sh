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
  "Black Hole|black_hole.png"
  "Cyberpunk|cyberpunk.png"
  "Hypr Kath Vid|hyprland_kath.mp4"
  "Hypr kath|hyprland_kath.png"
  "Jake Vid|jake_the_dog.mp4"
  "Jake|jake_the_dog.png"
  "Japanese Asthetic|japanese_aesthetic.png"
  "Sakura Vid|pixel_sakura.gif"
  "Sakura |pixel_sakura_static.png"
  "Hacker|post-apocalyptic_hacker.png"
  "Leaves|purple_leaves.png"
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
