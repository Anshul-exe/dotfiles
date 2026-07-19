#!/bin/bash

# Colors
bold=$(tput bold)
normal=$(tput sgr0)
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
red="\e[31m"
reset="\e[0m"

# Headers
echo -e "${bold}${blue}🔍 Checking for updates...${reset}"

# Official repo updates
pacman_updates=$(checkupdates 2>/dev/null)
pacman_count=$(echo "$pacman_updates" | wc -l)

# AUR updates (yay)
aur_updates=$(yay -Qua 2>/dev/null)
aur_count=$(echo "$aur_updates" | wc -l)

# Total updates
total=$((pacman_count + aur_count))

# Output Summary
echo -e "\n${bold}${green}📦 Pacman updates: $pacman_count${reset}"
if [ "$pacman_count" -gt 0 ]; then
  echo -e "${yellow}----------------------------------------"
  echo -e "🧾 Packages from official repos:${reset}"
  echo "$pacman_updates" | while read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    from=$(echo "$line" | awk '{print $2}')
    to=$(echo "$line" | awk -F ' -> ' '{print $2}')

    if [[ -n "$name" && -n "$from" && -n "$to" ]]; then
      echo -e "    - $name → $to"
    else
      echo -e "    - $line"
    fi
  done
fi

echo -e "\n${bold}${yellow}🎯 AUR updates: $aur_count${reset}"
if [ "$aur_count" -gt 0 ]; then
  echo -e "${yellow}----------------------------------------"
  echo -e "🛠️  Packages from AUR:${reset}"
  echo "$aur_updates" | awk '{print "    - " $1 " → " $2}'
fi

# Total
echo -e "\n${bold}${red}==============================${reset}"
echo -e "${bold}${red}🔄 Total updates available: $total${reset}"
echo -e "${bold}${red}==============================${reset}\n"

# Optional pro tip
if [ "$total" -gt 0 ]; then
  echo -e "${bold}${blue}✨ Tip:${reset} Run ${bold}${green}yay -Syu${reset} to update all packages."
else
  echo -e "${bold}${green}✅ System is fully up to date!${reset}"
fi
