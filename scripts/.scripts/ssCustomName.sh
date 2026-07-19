#!/bin/bash

# Giving the path for saving screenshot
screenshot_dir=~/clear_space/Media/screenshots
# Taking Screenshot using flameshot and storing it with a default name
default_name=$(date '+%Y-%m-%d_%H-%M-%S').png
flameshot gui -p "$screenshot_dir/$default_name"
# Copy the screenshot to clipboard
xclip -selection clipboard -t image/png -i "$screenshot_dir/$default_name"
# Use zenity for GUI
# new_name=$(zenity --entry --title="Rename Screenshot" --text="Enter new name for the screenshot:" --entry-text="$default_name")
# Use Rofi for fast response
new_name=$(rofi -dmenu -p "Enter new name for screenshot:" -theme "$HOME/.config/rofi/todo.rasi" -no-fixed-num-lines <<<"$default_name")

# If the user provided a name, rename the screenshot and keep it
if [ ! -z "$new_name" ] && [ "$new_name" != "$default_name" ]; then
  # Add the .png extension if it's not provided
  if [[ "$new_name" != *.png ]]; then
    new_name="$new_name.png"
  fi
  mv "$screenshot_dir/$default_name" "$screenshot_dir/$new_name"
else
  # If no name provided or same as default, delete the file (it's already in clipboard)
  rm "$screenshot_dir/$default_name"
fi
