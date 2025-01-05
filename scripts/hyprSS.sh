#!/bin/bash

# Define the screenshot directory
screenshot_dir=~/clear_space/Media/screenshots

# Create the directory if it doesn't exist
mkdir -p "$screenshot_dir"

# Generate a default name based on the current timestamp
default_name=$(date '+%Y-%m-%d_%H-%M-%S').png

# Take the screenshot using grimblast and save to the default location
grimblast save area "$screenshot_dir/$default_name"

# Use Rofi to prompt for a new name for the screenshot
new_name=$(rofi -dmenu -p "Enter new name for screenshot:" -theme "$HOME/.config/rofi/todo.rasi" -no-fixed-num-lines <<<"$default_name")

# If the user provided a name, rename the screenshot
if [ ! -z "$new_name" ]; then
  # Add the .png extension if it's not provided
  if [[ "$new_name" != *.png ]]; then
    new_name="$new_name.png"
  fi
  mv "$screenshot_dir/$default_name" "$screenshot_dir/$new_name"
fi

# Copy the screenshot to clipboard
wl-copy <"$screenshot_dir/$new_name"

# Notify the user
notify-send "Screenshot saved as $screenshot_dir/$new_name and copied to clipboard."
