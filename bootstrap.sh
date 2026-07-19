#!/usr/bin/env bash
#
# bootstrap.sh — one-shot machine setup for this dotfiles repo.
#
#   git clone https://github.com/Anshul-exe/dotfiles ~/dotfiles
#   cd ~/dotfiles && ./bootstrap.sh
#
# What it does, in order:
#   1. Installs packages (pacman first, yay fallback for AUR) — optional
#   2. Clones oh-my-zsh + powerlevel10k + zsh plugins, and tmux TPM
#   3. Symlinks every config package into $HOME with GNU stow
#   4. Creates the ~/clear_space media paths the configs reference
#   5. Deploys system files (keyd, touchpad, sddm theme) with sudo — optional
#   6. Prints a report of everything that failed or needs manual action
#
# Flags:
#   --skip-packages   don't install anything, only link configs
#   --skip-system     don't touch /etc or /usr/share (no sudo needed)
#   --yes             assume yes to every prompt (unattended)
#
# Safe to re-run: packages are skipped if present, stow is idempotent
# (--restow), and existing real files are backed up, never overwritten.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/dotfiles-bootstrap-$TS.log"
BACKUP_DIR="$HOME/dotfiles-backup-$TS"

# Stow packages = every dir here that mirrors $HOME. Data dirs
# (wallpapers, media, sddm, system, random) are deliberately NOT stowed.
STOW_PACKAGES=(
  alacritty bash bin bottom dunst fastfetch gammastep git hypr hyprpanel
  i3 kitty libinput-gestures neofetch nvim picom polybar ranger rofi
  scripts spicetify starship tmux waybar waypaper zsh
)

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $1"    | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"   | tee -a "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"  | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[FAIL]${NC} $1"     | tee -a "$LOG_FILE"; }

failed_packages=()
installed_packages=()
skipped_packages=()
manual_notes=()

SKIP_PACKAGES=0
SKIP_SYSTEM=0
ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    --skip-packages) SKIP_PACKAGES=1 ;;
    --skip-system)   SKIP_SYSTEM=1 ;;
    --yes)           ASSUME_YES=1 ;;
    -h|--help) awk 'NR>1 && !/^#/{exit} NR>1' "$0"; exit 0 ;;
    *) echo "Unknown flag: $arg (see --help)"; exit 1 ;;
  esac
done

ask() { # ask "question" -> 0 yes / 1 no
  [ "$ASSUME_YES" -eq 1 ] && return 0
  read -rp "$(echo -e "${YELLOW}[ ?? ]${NC} $1 [y/N] ")" reply
  [[ "$reply" =~ ^[Yy] ]]
}

# ---------------------------------------------------------------- guards
[ "$EUID" -eq 0 ] && { error "Run as your user, not root."; exit 1; }
command -v pacman >/dev/null || { error "Not an Arch system (pacman missing)."; exit 1; }
[ "$REPO_DIR" != "$HOME/dotfiles" ] &&
  warn "Repo is at $REPO_DIR, not ~/dotfiles. Symlinks will point here — that's fine, but keep the repo in place."
info "Logging to $LOG_FILE"

# ---------------------------------------------------------------- packages
# Needed by the configs themselves (i3 session, terminals, shells, tools).
PKGS_CORE=(
  # window manager session
  i3-wm i3status polybar picom dunst feh rofi rofi-calc rofi-emoji
  xss-lock i3lock-color xorg-xrdb xorg-xrandr xdotool xclip wmctrl
  brightnessctl playerctl acpi libnotify light keyd
  networkmanager network-manager-applet gammastep libinput-gestures
  maim slop flameshot imagemagick tesseract tesseract-data-eng
  # terminals / shells / multiplexer
  kitty alacritty zsh tmux starship stow
  # editor + file managers + fetch tools
  neovim ranger yazi w3m fastfetch neofetch bottom btop htop ncdu
  # CLI staples used by zshrc/aliases/scripts
  eza bat fzf fd ripgrep zoxide lazygit git-delta most jq curl wget
  unzip zip tldr glow onefetch figlet lolcat sl toipe sqlite
  # documents / media
  mpv zathura zathura-pdf-poppler mediainfo atool
  # audio
  pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol pamixer alsa-utils
  # bluetooth + networking helpers
  bluez bluez-utils blueman bluetui hostapd dnsmasq
  # pacman helpers
  pacman-contrib reflector
  # spotify stack (spicetify config is in this repo)
  spotify-launcher
)
PKGS_FONTS=(
  ttf-meslo-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols otf-font-awesome
  noto-fonts noto-fonts-emoji ttf-roboto ttf-dejavu ttf-firacode-nerd
  ttf-iosevka-nerd cantarell-fonts
  # AUR fonts / cursor referenced by configs
  ttf-material-icons-git bibata-cursor-theme
)
# AUR / extra tools referenced in aliases & scripts. Failures are non-fatal.
PKGS_EXTRA=(
  pokeget pywal-git spotify-player spicetify-cli superfile scrntime-git
  kmon procs gcalendar asciiquarium
  # ASUS-only — will fail harmlessly on non-ASUS hardware
  asusctl supergfxctl
)
# Heavier workflow tools referenced by aliases (docker, ollama, ...).
PKGS_WORKFLOW=(
  docker docker-compose lazydocker github-cli ollama
)

in_official_repos() { pacman -Si "$1" &>/dev/null; }

install_yay() {
  command -v yay >/dev/null && { success "yay already present"; return 0; }
  info "Installing yay (AUR helper)..."
  sudo pacman -S --noconfirm --needed base-devel git || { error "base-devel/git install failed"; return 1; }
  local tmp; tmp="$(mktemp -d)"
  if git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay" &&
     (cd "$tmp/yay" && makepkg -si --noconfirm); then
    success "yay installed"; rm -rf "$tmp"; return 0
  fi
  error "Could not build yay — AUR packages will be skipped"
  rm -rf "$tmp"; return 1
}

install_pkg() {
  local pkg="$1"
  if pacman -Qq "$pkg" &>/dev/null; then
    skipped_packages+=("$pkg"); return 0
  fi
  if in_official_repos "$pkg"; then
    if sudo pacman -S --noconfirm --needed "$pkg" >>"$LOG_FILE" 2>&1; then
      success "installed $pkg"; installed_packages+=("$pkg"); return 0
    fi
  elif command -v yay >/dev/null; then
    if yay -S --noconfirm --needed "$pkg" >>"$LOG_FILE" 2>&1; then
      success "installed $pkg (AUR)"; installed_packages+=("$pkg"); return 0
    fi
  fi
  error "failed to install $pkg"
  failed_packages+=("$pkg")
  return 1
}

install_packages() {
  info "Updating package databases..."
  sudo pacman -Sy >>"$LOG_FILE" 2>&1 || warn "pacman -Sy failed, trying to continue"
  install_yay || true
  info "Installing core packages (${#PKGS_CORE[@]})..."
  for p in "${PKGS_CORE[@]}"; do install_pkg "$p" || true; done
  info "Installing fonts (${#PKGS_FONTS[@]})..."
  for p in "${PKGS_FONTS[@]}"; do install_pkg "$p" || true; done
  info "Installing extra tools (${#PKGS_EXTRA[@]})..."
  for p in "${PKGS_EXTRA[@]}"; do install_pkg "$p" || true; done
  if ask "Install workflow tools too (docker, lazydocker, github-cli, ollama)?"; then
    for p in "${PKGS_WORKFLOW[@]}"; do install_pkg "$p" || true; done
  fi
}

if [ "$SKIP_PACKAGES" -eq 0 ]; then
  if ask "Install/check all required packages first? (choose n if you already installed them)"; then
    install_packages
  else
    info "Skipping package installation on request."
  fi
else
  info "--skip-packages: not installing anything."
fi

command -v stow >/dev/null || {
  info "stow is required for linking; installing it..."
  sudo pacman -S --noconfirm --needed stow >>"$LOG_FILE" 2>&1 || { error "stow missing and could not be installed — aborting."; exit 1; }
}

# ------------------------------------------------- shell frameworks (clones)
clone_if_missing() { # clone_if_missing <url> <dest> <label>
  if [ -d "$2" ]; then success "$3 already present"; return 0; fi
  if git clone --depth 1 "$1" "$2" >>"$LOG_FILE" 2>&1; then
    success "cloned $3"
  else
    error "failed to clone $3 ($1)"; manual_notes+=("Clone manually: git clone $1 $2")
  fi
}

info "Setting up oh-my-zsh, powerlevel10k, zsh plugins, tmux TPM..."
clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" "oh-my-zsh"
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k" "powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" "zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"
clone_if_missing https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm" "tmux plugin manager (TPM)"

# ---------------------------------------------------------------- stow
# Move any real file that would collide with a package symlink into BACKUP_DIR.
backup_conflicts() {
  local pkg="$1" f target rel
  while IFS= read -r -d '' f; do
    rel="${f#"$REPO_DIR/$pkg/"}"
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ] && [ ! -d "$target" ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
      warn "backed up existing $target -> $BACKUP_DIR/$rel"
    fi
  done < <(find "$REPO_DIR/$pkg" -type f -print0)
}

info "Linking config packages with stow..."
stow_failed=()
for pkg in "${STOW_PACKAGES[@]}"; do
  [ -d "$REPO_DIR/$pkg" ] || { warn "package '$pkg' missing in repo, skipping"; continue; }
  backup_conflicts "$pkg"
  if stow --dir="$REPO_DIR" --target="$HOME" --restow "$pkg" >>"$LOG_FILE" 2>&1; then
    success "stowed $pkg"
  else
    error "stow failed for $pkg (see log)"
    stow_failed+=("$pkg")
  fi
done

# Make sure every script is executable (git preserves this, but be safe).
find "$REPO_DIR/scripts/.scripts" "$REPO_DIR/bin/.local/bin" -type f \
  \( -name '*.sh' -o -perm -u+x \) -exec chmod +x {} + 2>/dev/null

# ------------------------------------------- media paths configs reference
# i3/scripts/hyprpanel reference ~/clear_space/... — recreate that layout,
# pointing at the repo copies. Existing REAL dirs (restored from backup)
# are left untouched.
link_media() { # link_media <target> <source>
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    warn "$1 already exists (real file/dir) — leaving it alone"
  else
    mkdir -p "$(dirname "$1")"
    ln -sfn "$2" "$1" && success "linked $1 -> $2"
  fi
}
info "Creating media paths referenced by configs..."
link_media "$HOME/clear_space/Media/wallpapers"        "$REPO_DIR/wallpapers"
link_media "$HOME/clear_space/Media/idharUdhar"        "$REPO_DIR/media/idharUdhar"
link_media "$HOME/clear_space/Random_Photos/wallpapers" "$REPO_DIR/wallpapers"
link_media "$HOME/Pictures/wallpapers"                 "$REPO_DIR/wallpapers"
mkdir -p "$HOME/clear_space/Media/screenshots"
# Runtime data files scripts expect to exist:
touch "$HOME/.rofi_notes" "$HOME/.clipboard_history" "$HOME/.Xresources"

# ---------------------------------------------------------------- system files
deploy_system() {
  info "Deploying system files (needs sudo)..."
  # keyd (capslock -> esc) + touchpad settings
  sudo mkdir -p /etc/keyd /etc/X11/xorg.conf.d
  sudo cp "$REPO_DIR/system/etc/keyd/default.conf" /etc/keyd/ &&
    success "keyd config -> /etc/keyd/default.conf"
  sudo cp "$REPO_DIR/system/etc/X11/xorg.conf.d/40-libinput.conf" /etc/X11/xorg.conf.d/ &&
    success "touchpad config -> /etc/X11/xorg.conf.d/40-libinput.conf"
  if pacman -Qq keyd &>/dev/null; then
    sudo systemctl enable --now keyd >>"$LOG_FILE" 2>&1 && success "keyd service enabled"
  fi
  # sddm theme + config
  if ask "Install SDDM login themes (astronaut etc.) and enable sddm?"; then
    if install_pkg sddm; then :; fi
    sudo mkdir -p /usr/share/sddm/themes /etc/sddm.conf.d
    sudo cp -r "$REPO_DIR"/sddm/usr/share/sddm/themes/* /usr/share/sddm/themes/ &&
      success "sddm themes -> /usr/share/sddm/themes/"
    sudo cp "$REPO_DIR/sddm/etc/sddm.conf" /etc/sddm.conf &&
      success "sddm.conf -> /etc/sddm.conf"
    [ -f "$REPO_DIR/system/etc/sddm.conf.d/virtualkbd.conf" ] &&
      sudo cp "$REPO_DIR/system/etc/sddm.conf.d/virtualkbd.conf" /etc/sddm.conf.d/
    sudo systemctl enable sddm >>"$LOG_FILE" 2>&1 && success "sddm enabled"
  fi
  # services that the configs assume
  sudo systemctl enable --now NetworkManager >>"$LOG_FILE" 2>&1 || true
  sudo systemctl enable --now bluetooth >>"$LOG_FILE" 2>&1 || true
}
if [ "$SKIP_SYSTEM" -eq 0 ]; then
  if ask "Deploy system-level files (keyd, touchpad, sddm themes)?"; then
    deploy_system
  fi
else
  info "--skip-system: leaving /etc and /usr/share untouched."
fi

# ---------------------------------------------------------------- tmux plugins
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  info "Installing tmux plugins via TPM..."
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >>"$LOG_FILE" 2>&1 &&
    success "tmux plugins installed" || warn "TPM install had errors (run prefix+I inside tmux later)"
fi

# ---------------------------------------------------------------- default shell
if [ "$(basename "${SHELL:-}")" != "zsh" ] && command -v zsh >/dev/null; then
  if ask "Set zsh as your default shell?"; then
    chsh -s "$(command -v zsh)" && success "default shell -> zsh (takes effect on next login)"
  fi
fi

# ---------------------------------------------------------------- report
echo; info "================= BOOTSTRAP REPORT ================="
success "packages installed: ${#installed_packages[@]}, already present: ${#skipped_packages[@]}"
if [ ${#failed_packages[@]} -gt 0 ]; then
  error "packages that FAILED to install:"
  printf '  - %s\n' "${failed_packages[@]}" | tee -a "$LOG_FILE"
  info "retry manually with: yay -S <name>"
fi
if [ ${#stow_failed[@]} -gt 0 ]; then
  error "stow failed for: ${stow_failed[*]} — check $LOG_FILE"
fi
[ -d "$BACKUP_DIR" ] && warn "pre-existing files were backed up to $BACKUP_DIR"
for note in "${manual_notes[@]:-}"; do [ -n "$note" ] && warn "$note"; done
cat <<EOF | tee -a "$LOG_FILE"

Manual follow-ups (not automatable):
  * Restore your personal ~/clear_space data (projects, docs, photos) from backup;
    the wallpapers/idharUdhar symlinks above already cover what the configs need.
  * Restore secrets separately (NEVER into this repo): ~/.ssh, ~/.aws, ~/.kube,
    ~/.config/gh, ~/.git-credentials, ~/.wakatime.cfg.
  * 'Grape Nuts' font (rofi notes theme) has no Arch package - get it from Google Fonts
    if you use the notes popup theme.
  * Open nvim once - LazyVim will auto-install plugins from lazy-lock.json.
  * Log out/in (or reboot) so the i3 session, keyd and fonts fully apply.

Log: $LOG_FILE
Done.
EOF
