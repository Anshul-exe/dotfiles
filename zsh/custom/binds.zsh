# unbind shitz
bindkey -r "^[[A"
bindkey -r "^[[B"

# binding shitz
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

#edit-command-line
bindkey '^e' edit-command-line

#navigation
# bindkey '^j' `cd ~/clear_space/codeLore/
