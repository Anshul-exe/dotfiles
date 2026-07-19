#!/bin/bash

NOTES_FILE="$HOME/.rofi_notes"
ROFI_THEME="$HOME/.config/rofi/notes.rasi"
ROFI_IMAGES="$HOME/.config/rofi/images"

# Initialize kr rhe file agar nahi bani hai toh
[ -f "$NOTES_FILE" ] || touch "$NOTES_FILE"

# Main function jo theme toggle kr rha
toggle_theme() {
  CURRENT_IMAGE=$(grep 'background-image' "$ROFI_THEME" | grep -oE '[^/"]+\.(jpeg|jpg|png)')

  if [ "$CURRENT_IMAGE" = "notes.jpeg" ]; then
    # Switch to dark mode
    sed -i 's|background-image:.*|background-image: url("'$ROFI_IMAGES'/darkPaper.jpg", none);|' "$ROFI_THEME"

    # Change general text color
    sed -i '/text-color:[^;]*;/ s/black/white/g' "$ROFI_THEME"

    # Update normal elements (non-selected items)
    sed -i '/element normal.normal {/,/}/ s/text-color:[^;]*;/text-color:                #55acd1;/g' "$ROFI_THEME"

    # Update selected elements (active item)
    sed -i '/element selected.normal {/,/}/ s/text-color:[^;]*;/text-color:                #cf3131;/g' "$ROFI_THEME"

    # Update alternate elements
    sed -i '/element alternate.normal {/,/}/ s/text-color:[^;]*;/text-color:                #55acd1;/g' "$ROFI_THEME"

    # Update element-text
    sed -i '/element-text {/,/}/ s/text-color:[^;]*;/text-color:                #55acd1;/g' "$ROFI_THEME"

  else
    # Switch back to light mode
    sed -i 's|background-image:.*|background-image: url("'$ROFI_IMAGES'/notes.jpeg", none);|' "$ROFI_THEME"

    # Change general text color
    sed -i '/text-color:[^;]*;/ s/white/black/g' "$ROFI_THEME"

    # Update normal elements (non-selected items)
    sed -i '/element normal.normal {/,/}/ s/text-color:[^;]*;/text-color:                #000080;/g' "$ROFI_THEME"

    # Update selected elements (active item)
    sed -i '/element selected.normal {/,/}/ s/text-color:[^;]*;/text-color:                #D76A67;/g' "$ROFI_THEME"

    # Update alternate elements
    sed -i '/element alternate.normal {/,/}/ s/text-color:[^;]*;/text-color:                #000080;/g' "$ROFI_THEME"

    # Update element-text
    sed -i '/element-text {/,/}/ s/text-color:[^;]*;/text-color:                black;/g' "$ROFI_THEME"
  fi
}

NOTES=$(cat "$NOTES_FILE")
CHOSEN=$(echo "$NOTES" | rofi -dmenu -p "Importants " -theme "$ROFI_THEME" \
  -kb-accept-entry "Return" \
  -kb-custom-1 "Ctrl+x" \
  -kb-custom-2 "Ctrl+r") # toggle to different theme

ROFI_EXIT_CODE=$?

[ -z "$CHOSEN" ] && exit
echo -n "$CHOSEN" | wl-copy
# Ctrl+x => delete note
if [ "$ROFI_EXIT_CODE" -eq 10 ]; then
  ESCAPED_CHOSEN=$(printf '%s\n' "$CHOSEN" | sed 's/[\/&]/\\&/g')
  sed -i "/^$ESCAPED_CHOSEN$/d" "$NOTES_FILE"
# Ctrl+r => toggle theme and restart
elif [ "$ROFI_EXIT_CODE" -eq 11 ]; then
  toggle_theme
  exec "$0"
else
  # Add new note if not already present
  if ! grep -Fxq "$CHOSEN" "$NOTES_FILE"; then
    echo "$CHOSEN" >>"$NOTES_FILE"
  fi
fi
exec "$0"
