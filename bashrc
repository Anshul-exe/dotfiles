#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias ls="eza --icons=always"
alias cd="z"
alias x="exit"
alias clr="clear"
alias nv="nvim"
alias rnr="ranger"
. "$HOME/.cargo/env"
