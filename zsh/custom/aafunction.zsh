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
 echo "Aaj ke baad kisi bhi type ke nashe nahi krunga, kyoki me aaj, 14 dec ko ideal nashedi lag rha hu" | figlet | lolcat
}

# killing processes with fzf
prokill() {
kill -9 $(ps -ef | fzf --multi | awk '{print $2}')
}

# search function for yay
yays () {
  yay -Slq | fzf --multi --height 55% --preview 'yay -Si {1}' | xargs -ro yay -S
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

## cd yazi to last viewing dir
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
