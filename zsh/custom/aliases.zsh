# powermenu shitz
alias x="exit"
alias xx='sudo shutdown -h now'
alias xr="sudo reboot"
alias xl="i3-msg exit"
alias xs="systemctl suspend"

# access from anywhere
alias zz="source ~/.zshrc source && source ~/.oh-my-zsh/custom/aafunction.zsh && source ~/.oh-my-zsh/custom/binds.zsh"
alias zb="nvim ~/.zshrc"
alias na="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias nb="nvim ~/.oh-my-zsh/custom/binds.zsh"
alias nf="nvim ~/.oh-my-zsh/custom/aafunction.zsh"
alias bi="nvim ~/.config/i3/config"
alias cpc="~/.scripts/copyShitz.sh"
alias bc="nvim ~/.scripts/copyShitz.sh"
alias rnrc='cd ~/.config && ranger'
alias laygord="sudo nvim /etc/X11/xorg.conf.d/40-libinput.conf" # asusctl ke phle khudse keyboard lighting set krne ka scene
alias webd="~/.scripts/tmux1by3.sh"
alias ttc="nvim ~/.tmux.conf"
alias gv="~/.scripts/gitView.sh"
alias prokill="~/.scripts/proKill.sh"
alias lock="~/.scripts/lock.sh"
alias spt="~/.scripts/spotifySearch.sh"

# listing shitz
alias vidr='ls -a'
alias dir='ls'
alias la='ls -a'
alias l='ls -CF'
alias ls="exa --icons=always"
alias lg="ls | grep -i "
alias lag="la | grep -i "
alias perm="exa --long --header --git --icons"
alias perma="exa --long --header --git --icons -a"
alias tre="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=1 --tree"
alias tree="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=2 --tree"
alias treee="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=3 --tree"
alias treeee="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=4 --tree"
alias atre="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=1 --tree"
alias atree="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=2 --tree"
alias atreee="eza -a --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --level=3 --tree"
alias fv="fd --type f --hidden --exclude .git '' | fzf-tmux -m --height 75% --preview 'bat --color=always {}' --reverse | xargs -o nvim"
alias fvt="fd --type f --hidden --exclude .git | fzf-tmux -m --preview 'bat --color=always {}' -p --reverse| xargs nvim"
alias grep='grep -i --color=auto'

# pacman aliases
alias evolve="yay -Syu --noconfirm"
alias sweep="sudo pacman -Sc"
alias hatao="sudo pacman -Rns"
alias hataodd="sudo pacman -Qdt"
# alias search="pacman -Ss"
alias kitnehai="pacman -Qqe | wc -l && echo TOTAL INSTALLED USER PACKAGES"
alias kitnepkg="pacman -Q | wc -l && echo ITNE PACKAGES HAI WITH THEIR DEPENDENCIES"
alias yehai='pacman -Q | grep '
alias useof="pacman -Qi "

# Xrandr / second screen commands
# which screen run krke check kro ki HDMI-1-0 hai ya HDMI-1-1 me kuch connected hai ya nahi agr HDMI ke through connect kr rhe hai device
# phle connected device ka name dekho (HDMI-1-0) fir jaha set krna hai vaha ki
# command do aur fir "xrandr --auto" krke laga do
alias whichscreen="xrandr | grep connected"
alias upar="xrandr --output HDMI-1-0 --above eDP-2"
alias neeche="xrandr --output HDMI-1-0 --below eDP-2"
alias left="xrandr --output HDMI-1-0 --left-of eDP-2"
alias right="xrandr --output HDMI-1-0 --right-of eDP-2"
# alias mirror="xrandr --output HDMI-1-0 --same-as eDP-2 --auto"
alias dusriband="xrandr --output HDMI-1-0 --off"

# TMUX
alias tt="tmux"
# alias tta="tmux a"
alias tta="tmux attach-session -t"
alias ttl="tmux ls"
alias ttn="tmux new -s"
alias ttk="tmux kill-session"

# Asus ctl controls
alias asusp="asusctl profile -p"
alias bz="asusctl -n"
alias bk="asusctl -p"

# random alias that I need
alias nv="nvim"
alias 192="ip a| grep 192"
alias ipa="ip a | grep -E '172|192|100.86|10\.'"
alias check="ping archlinux.org"
alias lz="lazygit"
alias tkill="tmux kill-session"
alias rnr="ranger"
alias findf="find . -type f -name"
alias findd="find . -type d -name"
alias mkdir="mkdir -pv "
alias process="ps aux | grep -v grep | grep -i -e VSZ -e"
alias nef="fastfetch"
alias mirror="sudo reflector --country 'India' --age 12 --sort rate --save /etc/pacman.d/mirrorlist"
alias mod="chmod +x"
alias rmd="rm -rf"
alias sl="sl -e"
alias gg="google"
alias btm="btm --battery -T"
alias tp="toipe -n 25"
alias fiwi="sudo systemctl restart NetworkManager"
alias clr="clear"
alias machli="asciiquarium"
alias vid="mpv"
alias cd="z"
alias cdi="zi"
alias fileppt="libreoffice --impress "
alias filedoc="libreoffice --writer "
alias db="sudo mariadb -u root -p"
alias pp="python3"
alias spice="spicetify restore backup && spicetify apply"
alias scrntime="scrntime --with-idletime -d 10 --style 2 --max-length 50"
alias shu="ssh shashank@147.93.105.208" #somethingsomehow22
alias kmon="sudo kmon -a red -c white"
alias npd="npm run dev"
alias venmo="udisksctl mount -b /dev/sda1" #sda1 me hai themes and all toh use mount krne ke liye
alias llmchat="ollama run llama3.1:8b"
alias llmcode="ollama run deepseek-coder:6.7b"
alias prospec="procs --pager disable -w "
alias f1='gcalendar --calendar="Formula 1" --no-of-days=30'
alias server='ip=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}"); echo "🚀 Serving at: http://$ip:6789"; python3 -m http.server 6789 --bind 0.0.0.0' # run kro jaha se files share krni hai and access through http://<this-system's-ip>:6789 from another system on the same network
alias lsblk="lsblk | bat -l conf -p"
alias connected='bluetoothctl devices Connected | awk '\''{$1=$2=""; print substr($0,3)}'\'''
alias nyancat="nyancat -s"

# phone controls
alias jj="amixer set Master 5%-"
alias kk="amixer set Master 5%+"
alias plause="playerctl -p spotify play-pause"
