#!/usr/bin/env bash
#
# syncSystem.sh — pull the handful of things stow CAN'T symlink back into the repo.
#
# Everything under ~/.config and ~/.scripts is symlinked straight into
# ~/dotfiles, so editing those files already updates the repo — nothing to do.
# This script covers only the leftovers:
#
#   * root-owned files in /etc (stow links $HOME, not /etc)
#   * the user crontab (lives in /var/spool/cron, not a file you edit)
#   * the explicit package list used by bootstrap.sh on a fresh install
#
# Run it before committing if you've touched any of those. Read-only on the
# system: it copies /etc -> repo, never the other way. Deploying repo -> /etc
# is bootstrap.sh's job.

set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; N='\033[0m'
changed=0

pull() { # pull <source> <dest-relative-to-repo>
  local src="$1" dst="$REPO/$2"
  if [ ! -r "$src" ]; then
    printf "  ${Y}skip${N}   %s (missing or unreadable)\n" "$src"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    printf "  same   %s\n" "$src"
  else
    cp "$src" "$dst" && { printf "  ${G}pulled${N} %s\n" "$src"; changed=$((changed+1)); }
  fi
}

echo -e "${B}==> /etc files${N}"
pull /etc/keyd/default.conf                  system/etc/keyd/default.conf
pull /etc/X11/xorg.conf.d/40-libinput.conf   system/etc/X11/xorg.conf.d/40-libinput.conf
pull /etc/sddm.conf                          sddm/etc/sddm.conf
pull /etc/sddm.conf.d/virtualkbd.conf        system/etc/sddm.conf.d/virtualkbd.conf

echo -e "${B}==> user crontab${N}"
if command -v crontab >/dev/null && crontab -l >/dev/null 2>&1; then
  tmp="$(mktemp)"
  # Keep the explanatory header in the repo file, refresh only the entries.
  sed -n '1,/^$/p' "$REPO/system/crontab.user" 2>/dev/null > "$tmp"
  crontab -l 2>/dev/null | grep -v '^#' | grep -v '^$' >> "$tmp"
  if cmp -s "$tmp" "$REPO/system/crontab.user"; then
    echo "  same   crontab"
  else
    cp "$tmp" "$REPO/system/crontab.user"
    echo -e "  ${G}pulled${N} crontab -> system/crontab.user"
    changed=$((changed+1))
  fi
  rm -f "$tmp"
else
  echo -e "  ${Y}skip${N}   no crontab installed"
fi

echo -e "${B}==> explicitly installed packages${N}"
# Written to its own file on purpose. random/installed is a HISTORICAL list
# carried over from the previous machine (it's doubled, and ~228 of its entries
# were never installed here) — it's a reinstall wishlist, not a snapshot, so
# this script must not overwrite it.
if command -v pacman >/dev/null; then
  tmp="$(mktemp)"
  pacman -Qqe > "$tmp"
  if cmp -s "$tmp" "$REPO/random/installed.snapshot" 2>/dev/null; then
    echo "  same   $(wc -l < "$tmp") packages"
  else
    cp "$tmp" "$REPO/random/installed.snapshot"
    echo -e "  ${G}pulled${N} $(wc -l < "$tmp") packages -> random/installed.snapshot"
    changed=$((changed+1))
  fi
  rm -f "$tmp"
fi

echo
if [ "$changed" -eq 0 ]; then
  echo -e "${G}Nothing changed — repo already matches the system.${N}"
else
  echo -e "${Y}$changed item(s) updated. Review and commit:${N}"
  echo "  cd $REPO && git diff && git add -A && git commit"
fi
