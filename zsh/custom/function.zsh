#### To get the description of provided package
desc() {
  pacman -Qi "$1" | awk '/^Name/{name=$3}/^Description/{for (i=3; i<=NF; i++) desc = desc $i " "; print name ": " desc; desc=""}'
}

#### To get the size of given package
size() {
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

