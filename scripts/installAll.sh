#!/bin/bash

# Check if yay is installed, install it if it's not
if ! command -v yay &>/dev/null; then
  echo "yay not found, installing yay..."
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si
  cd ..
  rm -rf yay
else
  echo "yay is already installed."
fi

# List of packages to install
packages=(
  "yay"
  "fzf"
  "bat"
  "pywal" no
  "feh"
  "pokeget" no
  "zoxide"
  "bluez"
  "bluez-utils"
  "blueman"
  "nm-applet" no
  "picom"
  "dunst"
  "eza"
  "rofi"
  "gnome-settings-daemon"
  "gnome-control-center"
  "playerctl"
  "libinput-gestures"
  "flameshot"
  "brightnessctl"
  "xss-lock"
  "asusctl"
  "supergfxctl"
  "light"
  "fastfetch"
  "batfetch" no
  "rofi-calc" "rofi-emoji" no
  "xdotool"
  "papirus-icon-theme" no
  "acpi"
  "libnotify"
  "iptables"
  "dnsmasq"
  "hostapd"
  "slop"
  "tesseract" "tesseract-data-eng"
  "starship"
  "sddm" "qt6-svg"
  "kitty"
  "yazi"
  "vscodium"
  "lazygit"
  "w3m"
  "whatsapp-linux-app"
  "i3lock-color"
  "bottom"
  "cava"
  "espanso"
  "glow"
  "htop"
  "polybar"
  "postman"
  "rambox"
  "ranger"
  "impala"
  "atac"
  "ncdu"
  "sl"
  "zathura"
  "reflector"
)

# Update yay
echo "Updating yay..."
yay -Syu --noconfirm

# Install packages
echo "Installing packages..."
yay -S --needed --noconfirm "${packages[@]}"

echo "All packages installed successfully!"
