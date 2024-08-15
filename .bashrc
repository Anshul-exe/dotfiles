#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias vidr='ls -a'
alias dir='ls'
# alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -a'
alias l='ls -CF'
# alias perm="ls -l"
PS1='[\u@\h \W]\$ '

################## ALL ALIASES ##################
# powermenu shitz
alias x="exit"
alias xx='sudo shutdown -h now'
alias xr="sudo reboot"
alias xl="i3-msg exit"

# access from anywhere
alias bb="nvim ~/.bashrc"
alias sb="source ~/.bashrc"
alias bi="nvim ~/.config/i3/config"
alias cpc="~/.scripts/copyShitz.sh"

# listing shitz
alias ls="exa"
alias perm="exa --long --header --git --icons"
alias perma="exa --long --header --git --icons -a"
alias eza="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=1"
alias fv="fd --type f --hidden --exclude .git '' | fzf-tmux --height 65% --preview 'bat --color=always {}' --reverse | xargs -o nvim"
alias tfv="fd --type f --hidden --exclude .git | fzf-tmux --preview 'bat --color=always {}' -p --reverse| xargs nvim"

# pacman aliases
alias evolve="sudo pacman -Syu"
alias sweep="sudo pacman -Sc"
alias hatao="sudo pacman -Rns"
alias hataodd="sudo pacman -Qdt"
alias search="pacman -Ss"
alias kyakyahai="pacman -Q"
alias kitnehai="pacman -Qqe | wc -l && echo TOTAL INSTALLED USER PACKAGES"
alias kitnepkg="pacman -Q | wc -l && echo ITNE PACKAGES HAI WITH THEIR DEPENDENCIES"
alias yehai?="pacman -Q | grep "
alias useof="pacman -Qi "

# random alias that I need
alias nv="nvim"
alias vn="unalias nv"
alias 192="ip a| grep 192"
alias pip="ip a | grep -E '192|10\.'"
alias check="ping arch.org"
alias lz="lazygit"
alias tkill="tmux kill-session"
alias rnr="ranger"
alias findf="find . -type f -name"
alias findd="find . -type d -name"
alias mkdir="mkdir -pv "
################## END OF ALL ALIASES ######################

################## CUSTOM FUNCTIONS ########################
# To get the description of the provided package
desc() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Description/{for (i=3; i<=NF; i++) desc = desc $i " "; print name ": " desc; desc=""}'
}

# For going up (changing directory cd..) as much dir I want
up() {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i = 1; i <= limit; i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs."
  fi
}
################## END OF CUSTOM FUNCTIONS ##################

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
