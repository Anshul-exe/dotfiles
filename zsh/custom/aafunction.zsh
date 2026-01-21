# for keybinds
timeTable() {
  # cd ~/clear_space/codeLore
  # ls -l
  # zle reset-prompt  # Update the prompt
  # # zle -R
  sh ~/.scripts/bhaiya.sh
}
zle -N timeTable  # Register the widget

#### To get the description of provided package
desc() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Description/{for (i=3; i<=NF; i++) desc = desc $i " "; print name ": " desc; desc=""}'
}

#### To get the size of given package
sizeof() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Installed Size/{size=$4 " " $5; print name " --> " size}'
}

#### For going up (changing directory cd..) as much dir I want
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

#### countdown with figlet and lolcat
cdown() {
  N=$1
  while [[ $((--N)) -gt 0 ]]; do
    echo "$N" | figlet -c | lolcat && sleep 1
  done
echo "TIME 'S UP ! !" | figlet -c | lolcat
}

#### Who the fuck uses nano
sudo() {
if [ "$1" = "pacman" ] && [ "$2" = "-S" ] && [ "$3" = "nano" ]; then
  echo "Shut  the  Fuck  Up, Hmare  PC  me  nano  nahi  padega... Bhk.  Mard  bano  aur  nvim  use  kro" | figlet | lolcat
else 
  command sudo "$@"
fi
}
yay() {
if [ "$1" = "-S" ] && [ "$2" = "nano" ]; then
  echo "Are  Bhadwe... abhi  bhi  nahi  mane  tum??" | figlet | lolcat
else 
  command yay "$@"
fi
}

aryan(){
 echo "Aaj, Thursday April-10 03:09:13 AM IST 2025, ke 5 Saal baad Aryan Rastogi, Jhanvi Yadav ko contact krke gaand jalaega uski apni kamiyabi ko dikha ke" | figlet | lolcat
}

# killing processes with fzf
# prokill() {
# kill -9 $(ps -ef | fzf --multi | awk '{print $2}')
# }

# search function for yay
yays() {
  yay -Slq | fzf \
    --multi \
    --height 80% \
    --border rounded \
    --margin 1 \
    --padding 1 \
    --prompt "📦 Select packages to install: " \
    --header "TAB: select | CTRL-A: toggle all | CTRL-/: preview | ENTER: install | ESC: cancel" \
    --preview 'yay -Si {1}' \
    --preview-window=right:60%:wrap \
    --bind 'ctrl-/:toggle-preview' \
    --bind 'ctrl-a:toggle-all' \
    --color='fg:#d0d0d0,hl:#5f87af' \
    --color='fg+:#ffffff,hl+:#5fd7ff' \
    --color='info:#afaf87,prompt:#d7005f,pointer:#af5fff' \
    --color='marker:#87ff00,spinner:#af5fff,header:#87afaf' \
    | xargs -ro yay -S
}

# navigating through used directories
cdf () {
  dirs -v | fzf --height 40% | awk '{print $2}' | xargs -r cd
}

# copying file path
fpclip () {
  realpath "$(find . -type f | fzf --height 40%)" | xclip -selection clipboard
}

# Most disk space consumer
biggest () {
  du -ah . | sort -rh | head -n 50 | fzf --height 40% --preview 'echo {}'
}

## get weather
weather () {
  curl -s "wttr.in/${1:-Delhi}?format=3" | lolcat
}

## cd yazi and ranger to last viewing dir
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
function ranger() {
	local tempfile
	tempfile="$(mktemp -t ranger_cd.XXXXXX)" || return

	command ranger --cmd="map q chain shell echo %d > '$tempfile'; quitall" "$@"

	if [[ -f "$tempfile" ]]; then
		local newdir
		newdir="$(<"$tempfile")"
		if [[ "$newdir" != "$PWD" ]]; then
			cd -- "$newdir" || return
		fi
	fi

	rm -f -- "$tempfile" 2>/dev/null
}

## cd spf to last viewing dir
spf() {
  export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"

  command spf "$@"

  [ ! -f "$SPF_LAST_DIR" ] || {
    . "$SPF_LAST_DIR"
      rm -f -- "$SPF_LAST_DIR" > /dev/null
    }
}

# bt - browse Chrome history in terminal using fzf
bt() {
  local cols sep db
  cols=$(( COLUMNS / 3 ))
  sep='{::}'
  db="$HOME/.config/google-chrome/Default/History"

  cp -f "$db" /tmp/h

  sqlite3 -separator "$sep" /tmp/h "
    SELECT 
      substr(title, 1, $cols), 
      datetime(last_visit_time/1000000 - 11644473600, 'unixepoch'), 
      url 
    FROM urls 
    ORDER BY last_visit_time DESC
  " |
  awk -F "$sep" '{printf "%-'$cols's  \x1b[33m%-20s\x1b[m  \x1b[36m%s\x1b[m\n", $1, $2, $3}' |
  fzf --ansi --multi |
  sed -n 's#.*\(https*://\)#\1#p' |
  xargs -r xdg-open
}

# git clone then cd
gclc() {
  git clone "$1" || return 1
  dir="$(basename "$1" .git)"
  echo "\ncd into $dir"
  cd "$dir" || return 1
}

# spotify cli control
play() { spotify_player playback start track --id "$(spotify_player search "$1" | jq -r '.tracks[0].id')"; }

# welcome back script
hi() {
  echo "🔆 Setting brightness to 50%"
  brightnessctl set 50% > /dev/null

  if amixer set Master toggle > /dev/null 2>&1; then
    echo "🔊 Audio path restored."
  else
    echo "❌ Audio restore failed."
  fi

  systemctl is-active --quiet bluetooth || systemctl start bluetooth
  bluetoothctl power on > /dev/null

  for i in {1..5}; do
    if bluetoothctl show | grep -q "Powered: yes"; then
      echo "📡 Bluetooth powered on."
      break
    fi
    sleep 1
  done

  # if ! bluetoothctl info E8:EE:CC:BC:08:81 | grep -q "Connected: yes"; then
    if ! bluetoothctl info F8:5C:7E:ED:9F:57 | grep -q "Connected: yes"; then
    echo "🔊 Connecting to ISHpeaker..."
    # bluetoothctl connect E8:EE:CC:BC:08:81 > /dev/null
    bluetoothctl connect F8:5C:7E:ED:9F:57 > /dev/null
    echo "✅ ISHpeaker connected."
    mpv --really-quiet /usr/share/sounds/freedesktop/stereo/service-login.oga >/dev/null 2>&1
  else
    echo "✅ ISHpeaker already connected."
  fi
}
