#!/usr/bin/env bash

# Check dependencies
for cmd in spotify_player jq fzf; do
  if ! command -v $cmd &>/dev/null; then
    echo "$cmd is required but not installed. Aborting."
    exit 1
  fi
done

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Header
echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}${CYAN}        🎵  Spotify Track Search  🎵${RESET}"
echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Prompt for search query
echo -e "${CYAN}${BOLD}Enter search query:${RESET}"
read -r query

echo -e "\n${YELLOW}Searching for '${BOLD}$query${RESET}${YELLOW}'...${RESET}\n"

# Fetch top 20 tracks from Spotify
tracks=$(spotify_player search "$query" | jq -r '.tracks[] | [.id, .name, (.artists | map(.name) | join(", "))] | @tsv')

if [[ -z "$tracks" ]]; then
  echo -e "${YELLOW}No tracks found for '$query'${RESET}"
  exit 1
fi

# Format tracks for display (without IDs)
display_tracks=$(echo "$tracks" | awk -F'\t' '{printf "%s — %s\n", $2, $3}')

# Use fzf for interactive selection
selection=$(echo "$display_tracks" | fzf \
  --height 40% \
  --border rounded \
  --ansi \
  --prompt="🎵 Select track: " \
  --color="fg:#ffffff,fg+:#00ff00,bg:#000000,bg+:#1a1a1a" \
  --color="hl:#ff00ff,hl+:#ff00ff,info:#ffff00,marker:#00ff00" \
  --color="prompt:#00ffff,spinner:#ff00ff,pointer:#00ff00,header:#00ffff" \
  --header="Use ↑↓ to navigate, Enter to select, Esc to cancel")

if [[ -z "$selection" ]]; then
  echo -e "\n${YELLOW}No track selected. Exiting.${RESET}"
  exit 1
fi

# Extract name and artists from selection
name=$(echo "$selection" | awk -F' — ' '{print $1}')
artists=$(echo "$selection" | awk -F' — ' '{print $2}')

# Get track ID from original tracks data
id=$(echo "$tracks" | grep -F "$name	$artists" | head -1 | awk -F'\t' '{print $1}')

# Play the track
spotify_player playback start track --id "$id"

# Confirmation
echo ""
echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}${BOLD}✓ Now playing:${RESET}"
echo -e "${BLUE}${BOLD}Track:${RESET}  $name"
echo -e "${BLUE}${BOLD}Artist:${RESET} $artists"
echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
