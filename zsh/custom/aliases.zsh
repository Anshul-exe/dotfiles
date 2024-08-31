# powermenu shitz
alias x="exit"
alias xx='sudo shutdown -h now'
alias xr="sudo reboot && thisshit"
alias xl="i3-msg exit"

# access from anywhere
alias zz="source ~/.zshrc"
alias zb="nvim ~/.zshrc"
alias na="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias naa="source ~/.oh-my-zsh/custom/aliases.zsh"
alias nb="nvim ~/.oh-my-zsh/custom/binds.zsh"
alias nbb="source ~/.oh-my-zsh/custom/binds.zsh"
alias nf="nvim ~/.oh-my-zsh/custom/functions.zsh"
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
alias nef="fastfetch"
alias mirror="sudo reflector --country 'India' --age 12 --sort rate --save /etc/pacman.d/mirrorlist"
alias nana="ncmpcpp"
alias mod="chmod +x"
alias rmd="rm -rf"
alias sl="sl -e"
alias code="codium"
alias gg="google"

# TMUX
alias tt="tmux"
alias tta="tmux a"
alias ttas="tmux attach-session -t"
alias ttl="tmux ls"
alias ttn="tmux new -s"
alias ttk="tmux kill-session"

# Asus ctl controls
alias asusp="asusctl profile -p"
alias battib="asusctl -n"
alias battik="asusctl -p"
