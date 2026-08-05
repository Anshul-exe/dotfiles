# Arch Dotfiles

i3 + polybar + picom rice, managed with [GNU stow](https://www.gnu.org/software/stow/).
Every top-level directory is a stow package that mirrors `$HOME`
(e.g. `kitty/.config/kitty/kitty.conf` → `~/.config/kitty/kitty.conf`).

## Fresh install

```sh
git clone https://github.com/Anshul-exe/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` installs all required packages (pacman → yay fallback) and fonts,
clones oh-my-zsh / powerlevel10k / zsh plugins / TPM, symlinks every config with
stow, recreates the `~/clear_space` media paths the configs reference, and can
deploy system files (keyd, touchpad, SDDM themes) with sudo. Run
`./bootstrap.sh --help` for flags (`--skip-packages`, `--skip-system`, `--yes`).
Anything that fails to install is logged and listed at the end.

Non-stow data directories: `wallpapers/`, `media/`, `sddm/`, `system/`, `random/`.

## Day-to-day: how changes get tracked

`~/.config/*` and `~/.scripts` are **symlinks into this repo**, so there is no
sync step. Editing `~/.scripts/lock.sh` *is* editing
`scripts/.scripts/lock.sh` — it shows up in `git status` immediately.

```sh
dots                    # cd ~/dotfiles && git status --short
git add -A && git commit -m "..." && git push
```

Most config dirs are *folded* (`~/.config/i3` is one symlink to
`i3/.config/i3`), so brand-new files you drop in there are picked up
automatically too.

Four directories are **not** folded, because they hold things this repo doesn't
own and must not delete — `~/.local/bin` (pipx binaries), `~/.oh-my-zsh/custom`
(oh-my-zsh's own plugins/themes), `~/.config/alacritty/themes` (upstream git
clone), `~/.config/spicetify` (marketplace installs). Existing tracked files
there still sync fine; a *new* file must be created in the repo and re-linked:

```sh
stow --dir=~/dotfiles --target=$HOME --restow <package>
```

Machine-local or secret shell config goes in `~/.oh-my-zsh/custom/local.zsh`,
which oh-my-zsh auto-sources and this repo deliberately does not track.

### What stow can't own

`/etc` files, the crontab, and the package list aren't symlinkable. Pull them
into the repo with:

```sh
cpc                     # ~/.scripts/syncSystem.sh
```

It's read-only on the system (`/etc` → repo, never the reverse — deploying is
`bootstrap.sh`'s job). Note `random/installed` is a historical package list from
a previous machine; `syncSystem.sh` writes the current snapshot to
`random/installed.snapshot` instead of overwriting it.

## Morning Colour Scheme

![2024-08-25_03-57](https://github.com/user-attachments/assets/bc215169-3c26-4728-ae68-6787be1f614d)

## Night Colour Scheme

![2024-08-25_05-08](https://github.com/user-attachments/assets/49c5b689-3dfe-4b78-add4-5a7158c20548)

## bulbasaur's cute right??

![2024-08-25_05-06](https://github.com/user-attachments/assets/704fcc3f-1a78-4893-bb18-21211b7e695e)
