#!/bin/bash
# Rofi Clipboard Manager
# A simple clipboard history manager using rofi

# Configuration
HISTORY_FILE="$HOME/.clipboard_history"
MAX_ENTRIES=16
ROFI_THEME="$HOME/.config/rofi/rofidmenu.rasi"

# Function to get current clipboard content
get_clipboard() {
  if command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -o 2>/dev/null
  elif command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --output 2>/dev/null
  elif command -v wl-paste >/dev/null 2>&1; then
    wl-paste 2>/dev/null
  else
    echo "Error: No clipboard tool found (xclip, xsel, or wl-paste required)" >&2
    exit 1
  fi
}

# Function to set clipboard content
set_clipboard() {
  local content="$1"
  if command -v xclip >/dev/null 2>&1; then
    echo -n "$content" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    echo -n "$content" | xsel --clipboard --input
  elif command -v wl-copy >/dev/null 2>&1; then
    echo -n "$content" | wl-copy
  fi
}

# Function to encode entry for storage (base64 to handle any content safely)
encode_entry() {
  echo -n "$1" | base64 -w 0
}

# Function to decode entry from storage
decode_entry() {
  echo -n "$1" | base64 -d 2>/dev/null
}

# Function to add entry to history
add_to_history() {
  local new_entry="$1"

  # Skip if entry is empty or only whitespace
  [[ -z "$new_entry" || "$new_entry" =~ ^[[:space:]]*$ ]] && return

  # Create history file if it doesn't exist
  touch "$HISTORY_FILE"

  # Encode the new entry
  local encoded_new=$(encode_entry "$new_entry")

  # Read existing history
  local history=()
  if [[ -s "$HISTORY_FILE" ]]; then
    while IFS= read -r encoded_line; do
      [[ -n "$encoded_line" ]] && history+=("$encoded_line")
    done <"$HISTORY_FILE"
  fi

  # Check if this entry already exists (compare encoded versions)
  for encoded_item in "${history[@]}"; do
    [[ "$encoded_item" == "$encoded_new" ]] && return
  done

  # Add new entry at the beginning
  history=("$encoded_new" "${history[@]}")

  # Keep only the last MAX_ENTRIES
  if [[ ${#history[@]} -gt $MAX_ENTRIES ]]; then
    history=("${history[@]:0:$MAX_ENTRIES}")
  fi

  # Write back to file
  printf '%s\n' "${history[@]}" >"$HISTORY_FILE"
}

# Function to display history with rofi
show_history() {
  # Check if history file exists and has content
  [[ ! -f "$HISTORY_FILE" || ! -s "$HISTORY_FILE" ]] && {
    echo "No clipboard history found"
    exit 1
  }

  # Read and decode history entries
  local history=()
  local display_items=()

  while IFS= read -r encoded_line; do
    if [[ -n "$encoded_line" ]]; then
      local decoded_entry
      decoded_entry=$(decode_entry "$encoded_line")
      if [[ -n "$decoded_entry" ]]; then
        history+=("$decoded_entry")

        # Create display version
        local display_line="$decoded_entry"

        # Replace actual newlines with ↵ symbol for display
        display_line="${display_line//$'\n'/ ↵ }"

        # Truncate long lines for display
        if [[ ${#display_line} -gt 80 ]]; then
          display_line="${display_line:0:77}..."
        fi

        # Use bullet point instead of numbers
        display_items+=("→ $display_line")
      fi
    fi
  done <"$HISTORY_FILE"

  [[ ${#display_items[@]} -eq 0 ]] && {
    echo "No clipboard history found"
    exit 1
  }

  # Show rofi menu
  local selected_item
  selected_item=$(printf '%s\n' "${display_items[@]}" |
    rofi -dmenu -i -p "Clipboard History" -theme "$ROFI_THEME")

  # If something was selected, copy it to clipboard
  if [[ -n "$selected_item" ]]; then
    # Find the index of selected item
    local index=0
    for item in "${display_items[@]}"; do
      if [[ "$item" == "$selected_item" ]]; then
        break
      fi
      ((index++))
    done

    # Get the actual content
    if [[ $index -lt ${#history[@]} ]]; then
      local selected_content="${history[$index]}"
      set_clipboard "$selected_content"

      # Show preview of what was copied
      local preview="$selected_content"
      preview="${preview//$'\n'/ ↵ }"
      if [[ ${#preview} -gt 50 ]]; then
        preview="${preview:0:47}..."
      fi
      echo "Copied to clipboard: $preview" >&2
    fi
  fi
}

# Function to monitor clipboard (manual call)
monitor_clipboard() {
  local current_content
  current_content=$(get_clipboard)
  add_to_history "$current_content"
}

# Check command line arguments
if [[ "$1" == "add" ]]; then
  # Only add to history, don't show GUI
  monitor_clipboard
else
  # Default behavior: add current clipboard and show history
  monitor_clipboard
  show_history
fi
