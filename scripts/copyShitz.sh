#!/bin/bash

# polybar
cp -r ~/.config/polybar/* ~/dotsi/polybar/

#rofi
cp -r ~/.config/rofi/{*,.*} ~/dotsi/rofi/

# alacritty
cp ~/.config/alacritty/alacritty.toml ~/dotsi/alacritty/alacritty.toml

# i3
cp ~/.config/i3/config ~/dotsi/i3/config

# neofetch
cp ~/.config/neofetch/config.conf ~/dotsi/neofetch/config.conf

# nvim
cp -r ~/.config/nvim/* ~/dotsi/nvim/.config/
# cp -r ~/.local/share/nvim/* ~/dotsi/nvim/.local/share/

# picom
cp ~/.config/picom/picom.conf ~/dotsi/picom/picom.conf

# ranger
cp -r ~/.config/ranger/* ~/dotsi/ranger/

# sddm
# cp -r /usr/share/sddm/themes/* ~/dotsi/sddm/usr/share/sddm/themes/
# cp -r /etc/sddm.conf ~/dotsi/sddm/etc/sddm.conf

# starship
cp ~/.config/starship.toml ~/dotsi/starship.toml

# bashrc
cp ~/.bashrc ~/dotsi/.bashrc

# tmux
cp ~/.tmux.conf ~/dotsi/tmux.conf

# Wallpapers
cp -r ~/Pictures/wallpapers/* ~/dotsi/wallpapers/

# scripts
cp -r ~/.scripts/* ~/dotsi/scripts/
