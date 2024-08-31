# # Lines configured by zsh-newuser-install
# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
# zstyle :compinstall filename '/home/mir/.zshrc'
########### End of lines added by compinstall ##############

### ALL ALIASES ###
# powermenu shitz
alias x="exit"
alias xx='sudo shutdown -h now'
alias xr="sudo reboot && thisshit"
alias xl="i3-msg exit"
# access from anywhere
alias zz="nvim ~/.zshrc"
alias zb="source ~/.zshrc"
alias bi="nvim ~/.config/i3/config"
alias cpc="~/.scripts/copyShitz.sh"
alias bc="nvim ~/.scripts/copyShitz.sh"
alias rnrc='cd ~/.config && ranger'
alias laygord="sudo nvim /etc/X11/xorg.conf.d/40-libinput.conf"
# listing shitz
alias vidr='ls -a'
alias dir='ls'
alias la='ls -a'
alias l='ls -CF'
alias ls="exa"
alias lg="ls | grep "
alias lag="la | grep "
alias perm="exa --long --header --git --icons"
alias perma="exa --long --header --git --icons -a"
alias eza="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=1"
alias fv="fd --type f --hidden --exclude .git '' | fzf-tmux --height 65% --preview 'bat --color=always {}' --reverse | xargs -o nvim"
alias fvt="fd --type f --hidden --exclude .git | fzf-tmux --preview 'bat --color=always {}' -p --reverse| xargs nvim"
alias grep='grep --color=auto'
# pacman aliases
alias evolve="sudo pacman -Syu"
alias sweep="sudo pacman -Sc"
alias hatao="sudo pacman -Rns"
alias hataodd="sudo pacman -Qdt"
alias search="pacman -Ss"
alias kyakyahai="pacman -Q"
alias kitnehai="pacman -Qqe | wc -l && echo TOTAL INSTALLED USER PACKAGES"
alias kitnepkg="pacman -Q | wc -l && echo ITNE PACKAGES HAI WITH THEIR DEPENDENCIES"
alias yehai='pacman -Q | grep '
alias useof="pacman -Qi "
# change my default USER shell
alias tobash="sudo chsh -s /usr/bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="sudo chsh -s /usr/bin/zsh && echo 'Log out and log back in for change to take effect.'"
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
alias process="ps aux | grep -v grep | grep -i -e VSZ -e"
alias nf="fastfetch"
alias mirror="sudo reflector --country 'India' --age 12 --sort rate --save /etc/pacman.d/mirrorlist"
alias nana="ncmpcpp"
alias mod="chmod +x"
alias rmd="rm -rf"
alias sl="sl -e"
# TMUX
alias tt="tmux"
alias tta="tmux a"
alias ttl="tmux ls"
alias ttk="tmux kill-session"
# Asus ctl controls
alias asusp="asusctl profile -p"
alias battib="asusctl -n"
alias battik="asusctl -p"

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


# CUSTOM FUNCTIONS
# To get the description of provided package
desc() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Description/{for (i=3; i<=NF; i++) desc = desc $i " "; print name ": " desc; desc=""}'
}
# To get the size of given package
size() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Installed Size/{size=$4 " " $5; print name " --> " size}'
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
# countdown with figlet and lolcat
cdown() {
  N=$1
  while [[ $((--N)) -gt 0 ]]; do
    echo "$N" | figlet -c | lolcat && sleep 1
  done
  echo "TIME 'S UP ! !" | figlet -c | lolcat
}

# SHOPT
setopt autocd       # cd into dir without using typing cd
setopt correct      # automatically corrects typos while cd-ing

# Sundarta
# eval "$(starship init zsh)"
(cat ~/.cache/wal/sequences &)

# IDK WTF DOES THESE THINGS DO
# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences
# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
# RANDOM ASS SHITZ
if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi

# WELCOME TEXT
pokeget random --hide-name -s

# DEFAULT SHITZ
export EDITOR=nvim

# PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/home/mir/.spicetify
export PATH=$PATH:/usr/bin/spicetify
. "$HOME/.cargo/env"

# things that should be at last
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# edit line in vim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
# bindkey '*e' edit-command-line
bindkey '^Xe' edit-command-line

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
