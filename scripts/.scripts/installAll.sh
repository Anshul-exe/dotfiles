#!/bin/bash

# Arch Linux System Reinstall Automation Script
# This script installs all specified packages with error handling and fallback options

set -e # Exit on any error initially, but we'll handle errors manually for package installations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Arrays to track installation results
failed_packages=()
installed_packages=()

# Function to install a single package with error handling
install_package() {
  local package="$1"
  local manager="$2" # 'pacman' or 'yay'

  log_info "Installing $package with $manager..."

  if [ "$manager" = "pacman" ]; then
    if sudo pacman -S --noconfirm --needed "$package" 2>/dev/null; then
      log_success "$package installed successfully"
      installed_packages+=("$package")
      return 0
    else
      log_error "Failed to install $package with pacman"
      failed_packages+=("$package")
      return 1
    fi
  elif [ "$manager" = "yay" ]; then
    if yay -S --noconfirm --needed "$package" 2>/dev/null; then
      log_success "$package installed successfully"
      installed_packages+=("$package")
      return 0
    else
      log_error "Failed to install $package with yay"
      failed_packages+=("$package")
      return 1
    fi
  fi
}

# Function to check if package exists in official repos
package_in_official_repos() {
  pacman -Ss "^$1$" &>/dev/null
}

# Function to install yay if not present
install_yay() {
  if command -v yay &>/dev/null; then
    log_success "yay is already installed"
    return 0
  fi

  log_info "Installing yay AUR helper..."

  # Create temporary directory
  temp_dir=$(mktemp -d)
  cd "$temp_dir"

  # Clone yay repository
  if git clone https://aur.archlinux.org/yay.git; then
    cd yay
    if makepkg -si --noconfirm; then
      log_success "yay installed successfully"
      cd /
      rm -rf "$temp_dir"
      return 0
    else
      log_error "Failed to build yay"
      cd /
      rm -rf "$temp_dir"
      return 1
    fi
  else
    log_error "Failed to clone yay repository"
    cd /
    rm -rf "$temp_dir"
    return 1
  fi
}

# Function to install Google Chrome
install_google_chrome() {
  if pacman -Qq google-chrome &>/dev/null; then
    log_success "Google Chrome is already installed"
    return 0
  fi

  log_info "Installing Google Chrome..."

  # Create temporary directory
  temp_dir=$(mktemp -d)
  cd "$temp_dir"

  # Download Google Chrome PKGBUILD
  if git clone https://aur.archlinux.org/google-chrome.git; then
    cd google-chrome
    if makepkg -si --noconfirm; then
      log_success "Google Chrome installed successfully"
      installed_packages+=("google-chrome")
      cd /
      rm -rf "$temp_dir"
      return 0
    else
      log_error "Failed to build Google Chrome"
      failed_packages+=("google-chrome")
      cd /
      rm -rf "$temp_dir"
      return 1
    fi
  else
    log_error "Failed to clone Google Chrome repository"
    failed_packages+=("google-chrome")
    cd /
    rm -rf "$temp_dir"
    return 1
  fi
}

# Main installation function
main() {
  log_info "Starting Arch Linux system reinstall script..."

  # Update system first
  log_info "Updating system packages..."
  if sudo pacman -Syu --noconfirm; then
    log_success "System updated successfully"
  else
    log_error "Failed to update system, continuing anyway..."
  fi

  # Install base-devel and git if not present (required for AUR)
  log_info "Ensuring base-devel and git are installed..."
  sudo pacman -S --noconfirm --needed base-devel git

  # Install yay AUR helper
  install_yay

  # Define all packages
  packages="7zip
acpi
ags-hyprpanel-git
alacritty
alsa-utils
amd-ucode
arc-gtk-theme
asciinema
asusctl
atac
atool
base
base-devel
bat
batfetch
bc
bind
blueman
bluez
bluez-hid2hci
bluez-utils
bottom
brightnessctl
btop
btrfs-progs
bun-bin
catdoc
cava
chocolate-doom
cloudflare-warp-bin
color-scripts-git
dnsmasq
docker
docker-compose
dolphin
dosbox
dunst
efibootmgr
espeak
ethtool
evtest
exiftool-rs-git
eza
fastfetch
fd
feh
ffmpegthumbnailer
figlet
firefox
flameshot
fuse3-p7zip-git
fzf
ghostty
git
github-cli
glow
gnome-control-center
gnome-settings-daemon
gnumeric
gobuster-bin
gocryptfs
gparted
gpu-screen-recorder
gradle
graphicsmagick
grimblast-git
grub
gst-libav
gst-plugin-pipewire
gst-plugins-bad
gst-plugins-ugly
hostapd
htop
hydra
hypridle
hyprland
hyprpicker
hyprsunset
i3-wm
i3blocks
i3lock-color
i3status
imake
impala
inotify-tools
inxi
ipscan-bin
iwd
jdk17-openjdk
keyd
kitty
kmon
kvantum-qt5
lazygit
lib32-mesa
libinput-gestures
libnotify
libpulse
libqalculate
libreoffice-fresh
libva-nvidia-driver
libva-utils
libwnck3
light
linux
linux-firmware
linux-headers
lolcat
lowfi
lsof
lua51
luarocks
lxappearance
man-db
mariadb
materia-gtk-theme
matugen-bin
mediainfo
mpv
nautilus
ncdu
neofetch
neovim
net-tools
network-manager-applet
networkmanager
nmap
noto-fonts
noto-fonts-emoji
ntfs-3g
nvidia-dkms ---DDEMMMMMMMMMMMMMMMM
odt2txt
onefetch
oneko
openssh
otf-font-awesome
pacman-contrib
patchelf
perl-image-exiftool
picom
pipewire
pipewire-alsa
pipewire-jack
pipewire-pulse
plastic
pokeget
pokemon-colorscripts-git
polybar
postman-bin
python-dbus
python-gpustat
python-pip
python-pipx
python-pymysql
pywal-git
qt5-graphicaleffects
qt5-quickcontrols
qt5-tools
qt5-wayland
qt5ct
qt6-quick3d
qt6-tools
qt6-virtualkeyboard
qt6-wayland
rambox-bin
ranger
reflector
ripdrag-git
ripgrep
rofi
rofi-calc
rofi-emoji
rsync
scrntime-git
sddm
sesh-bin
sl
slop
smartmontools
smassh
sof-firmware
spotify
spotify-tui ------ FIRSE KRNA HAI
starship
stunnel
supergfxctl
swww
tesseract
tesseract-data-eng
tlp
tlp-rdw
tmux
toipe
traceroute
ttf-all-the-icons
ttf-dejavu
ttf-jetbrains-mono
ttf-maple-beta
ttf-meslo-nerd
ttf-roboto
ueberzugpp
undistract-me
usbutils
ventoy-bin
vim
vimiv
virtualbox
virtualbox-host-modules-arch
w3m
watchman-bin
waybar
waypaper
wezterm
wget
whatsapp-linux-desktop-bin
whois
wireless-regdb
wireless_tools
wireplumber
wkhtmltopdf-static
wmctrl
wordlists
xdg-desktop-portal-hyprland
xdg-utils
xdotool
xkb-switch
xorg-bdftopcf
xorg-iceauth
xorg-mkfontscale
xorg-server
xorg-sessreg
xorg-smproxy
xorg-x11perf
xorg-xauth
xorg-xbacklight
xorg-xcmsdb
xorg-xcursorgen
xorg-xdpyinfo
xorg-xdriinfo
xorg-xev
xorg-xgamma
xorg-xhost
xorg-xinit
xorg-xinput
xorg-xkbevd
xorg-xkbprint
xorg-xkbutils
xorg-xkill
xorg-xlsatoms
xorg-xlsclients
xorg-xmodmap
xorg-xpr
xorg-xrandr
xorg-xrdb
xorg-xrefresh
xorg-xsetroot
xorg-xvinfo
xorg-xwd
xorg-xwininfo
xorg-xwud
xss-lock
yazi
ydotool
zathura
zathura-pdf-poppler
zoxide
zram-generator
zsh"

  # Handle Google Chrome separately first
  install_google_chrome

  # Convert packages string to array
  IFS=$'\n' read -rd '' -a package_array <<<"$packages"

  # Remove yay and google-chrome from the list since we handle them separately
  filtered_packages=()
  for pkg in "${package_array[@]}"; do
    pkg=$(echo "$pkg" | xargs) # Trim whitespace
    if [[ -n "$pkg" && "$pkg" != "yay" && "$pkg" != "google-chrome" ]]; then
      filtered_packages+=("$pkg")
    fi
  done

  log_info "Starting installation of ${#filtered_packages[@]} packages..."

  # First pass: try to install with pacman
  log_info "=== FIRST PASS: Installing packages with pacman ==="
  for package in "${filtered_packages[@]}"; do
    if package_in_official_repos "$package"; then
      install_package "$package" "pacman"
    fi
  done

  # Second pass: install remaining packages with yay
  log_info "=== SECOND PASS: Installing remaining packages with yay ==="
  for package in "${filtered_packages[@]}"; do
    if ! package_in_official_repos "$package"; then
      # Check if package was already installed in first pass
      if ! pacman -Qq "$package" &>/dev/null; then
        install_package "$package" "yay"
      fi
    fi
  done

  # Third pass: retry failed packages with alternative manager
  if [ ${#failed_packages[@]} -gt 0 ]; then
    log_info "=== THIRD PASS: Retrying failed packages ==="
    retry_packages=("${failed_packages[@]}")
    failed_packages=() # Reset failed packages array

    for package in "${retry_packages[@]}"; do
      if package_in_official_repos "$package"; then
        log_info "Retrying $package with yay (fallback)..."
        install_package "$package" "yay"
      else
        log_info "Retrying $package with pacman (fallback, might fail)..."
        install_package "$package" "pacman"
      fi
    done
  fi

  # Final report
  echo
  log_info "=== INSTALLATION REPORT ==="
  log_success "Successfully installed packages: ${#installed_packages[@]}"

  if [ ${#failed_packages[@]} -gt 0 ]; then
    log_error "Failed to install packages: ${#failed_packages[@]}"
    log_error "Failed packages:"
    for pkg in "${failed_packages[@]}"; do
      echo "  - $pkg"
    done
    echo
    log_info "You can manually install failed packages later with:"
    log_info "yay -S <package_name>"
  else
    log_success "All packages installed successfully!"
  fi

  # Optional: Enable important services
  log_info "=== ENABLING IMPORTANT SERVICES ==="

  services_to_enable=(
    "NetworkManager"
    "bluetooth"
    "docker"
    "sddm"
    "tlp"
  )

  for service in "${services_to_enable[@]}"; do
    if systemctl list-unit-files | grep -q "^$service.service"; then
      if sudo systemctl enable "$service" 2>/dev/null; then
        log_success "Enabled $service service"
      else
        log_warning "Could not enable $service service"
      fi
    else
      log_warning "$service service not found, skipping"
    fi
  done

  log_success "Installation script completed!"
  log_info "You may need to reboot to ensure all services and drivers work correctly."
}

# Trap to handle script interruption
trap 'log_error "Script interrupted"; exit 1' INT TERM

# Check if running as root
if [[ $EUID -eq 0 ]]; then
  log_error "This script should not be run as root. Run as a regular user with sudo access."
  exit 1
fi

# Check if sudo is available
if ! command -v sudo &>/dev/null; then
  log_error "sudo is required but not installed. Please install sudo first."
  exit 1
fi

# Run main function
main "$@"
