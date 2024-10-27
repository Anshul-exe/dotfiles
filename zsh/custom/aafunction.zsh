# for keybinds
cd_codeLore() {
  cd ~/clear_space/codeLore
  ls -l
  zle reset-prompt  # Update the prompt
  # zle -R
}
zle -N cd_codeLore  # Register the widget

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
    figlet "Shut  the  Fuck  Up, Hmare  PC  me  nano  nahi  padega... Bhk.  Mard  bano  aur  nvim  use  kro"
  else 
    command sudo "$@"
  fi
}
yay() {
  if [ "$1" = "-S" ] && [ "$2" = "nano" ]; then
    figlet "Are  Bhadwe... abhi  bhi  nahi  mane  tum??"
  else 
    command yay "$@"
  fi
}

# killing processes with fzf
prokill() {
  kill -9 $(ps -ef | fzf | awk '{print $2}')
}

# search function for yay
search () {
    yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S
}
