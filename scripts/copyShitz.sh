#!/bin/bash

# polybar
cp -r ~/.config/polybar/* ~/dotfiles/polybar/

#rofi
cp -r ~/.config/rofi/{*,.*} ~/dotfiles/rofi/

# alacritty
cp ~/.config/alacritty/alacritty.toml ~/dotfiles/alacritty/alacritty.toml

# i3
# cp ~/.config/i3/config ~/dotfiles/i3/config
cp ~/.config/i3/* ~/dotfiles/i3/

# neofetch
cp ~/.config/neofetch/config.conf ~/dotfiles/neofetch/config.conf

# nvim
cp -r ~/.config/nvim/* ~/dotfiles/nvim/.config/
# cp -r ~/.local/share/nvim/* ~/dotfiles/nvim/.local/share/

# picom
cp ~/.config/picom/picom.conf ~/dotfiles/picom/picom.conf

# ranger
cp -r ~/.config/ranger/* ~/dotfiles/ranger/

# sddm
# cp -r /usr/share/sddm/themes/* ~/dotfiles/sddm/usr/share/sddm/themes/
# cp -r /etc/sddm.conf ~/dotfiles/sddm/etc/sddm.conf

# starship
cp ~/.config/starship.toml ~/dotfiles/starship.toml

# bashrc
cp ~/.bashrc ~/dotfiles/bashrc

# zshrc
cp ~/.zshrc ~/dotfiles/zshrc

# tmux
cp ~/.tmux.conf ~/dotfiles/tmux.conf

# Wallpapers
cp -r ~/Pictures/wallpapers/* ~/dotfiles/wallpapers/

# gestures
cp ~/.config/libinput-gestures.conf ~/dotfiles/libinput-gestures.conf

# scripts
cp -r ~/.scripts/* ~/dotfiles/scripts/
