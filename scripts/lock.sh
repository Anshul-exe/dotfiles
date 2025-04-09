#!/bin/bash

LOCKED_DIR="$HOME/Videos/"
PASSWORD="ahah"

echo -n "Enter password to access $LOCKED_DIR: "
read -s entered
echo

if [[ "$entered" == "$PASSWORD" ]]; then
  echo "Access granted."
  exec ranger "$LOCKED_DIR" || exec nvim "$LOCKED_DIR" || cd "$LOCKED_DIR"
else
  echo "Access denied."
  exit 1
fi
