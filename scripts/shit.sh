#!/bin/bash

# Function to display a color swatch with text
show_color() {
  local code=$1
  printf "\e[%sm%-10s\e[0m " "$code" "$code"
  if (($2 == 1)); then
    echo # Move to the next line after bright colors
  fi
}

# Display basic 16 colors
echo "Basic Colors:"
for color in {0..7}; do
  show_color "3${color}m" 0
  show_color "9${color}m" 1 # Bright variant
done

# Display background colors
echo -e "\nBackground Colors:"
for color in {0..7}; do
  show_color "4${color}m" 0
  show_color "10${color}m" 1 # Bright background variant
done

# Display 256 colors (if supported by the terminal)
echo -e "\n256 Colors (Foreground):"
for color in {0..255}; do
  printf "\e[38;5;%sm%3d\e[0m " "$color" "$color"
  if (((color + 1) % 16 == 0)); then
    echo
  fi

done

# Display 256 background colors
echo -e "\n256 Colors (Background):"
for color in {0..255}; do
  printf "\e[48;5;%sm%3d\e[0m " "$color" "$color"
  if (((color + 1) % 16 == 0)); then
    echo
  fi
done

# Reset terminal formatting
echo -e "\n\e[0mAll colors displayed!"
