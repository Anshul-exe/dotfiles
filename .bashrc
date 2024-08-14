#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias vidr='ls -a'
alias dir='ls'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -a'
alias l='ls -CF'
alias perm="ls -l"
PS1='[\u@\h \W]\$ '

# Custom Aliases
alias x="exit"
alias xx='sudo shutdown -h now'
alias xr="sudo reboot"
alias xl="i3-msg exit"
alias nv="nvim"
alias vn="unalias nv"
alias eza="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=1"
alias bb="nvim ~/.bashrc"
alias sb="source ~/.bashrc"
alias bi="nvim ~/.config/i3/config"
alias 192="ip a| grep 192"
alias pip="ip a | grep -E '192|10\.'"
alias check="ping arch.org"
alias cpc="~/.scripts/copyShitz"
alias lz="lazygit"

# Pacman Aliases
alias evolve="sudo pacman -Syu"
alias sweep="sudo pacman -Sc"
alias hatao="sudo pacman -Rns"
alias hataodd="sudo pacman -Qdt"
alias search="pacman -Ss"

# Sundarta
eval "$(starship init bash)"
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

# Random ass shitzz
if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi

# Welcome text
pokeget random --hide-name -s

# Default editor
export EDITOR=nvim

# path
export PATH=$PATH:/usr/local/bin
