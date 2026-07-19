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

## Morning Colour Scheme

![2024-08-25_03-57](https://github.com/user-attachments/assets/bc215169-3c26-4728-ae68-6787be1f614d)

## Night Colour Scheme

![2024-08-25_05-08](https://github.com/user-attachments/assets/49c5b689-3dfe-4b78-add4-5a7158c20548)

## bulbasaur's cute right??

![2024-08-25_05-06](https://github.com/user-attachments/assets/704fcc3f-1a78-4893-bb18-21211b7e695e)
