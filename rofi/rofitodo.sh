#!/bin/bash
TODO_FILE=$HOME/.config/rofi/.rofi_todos

# if [[ ! -e "${TODO_FILE}" ]]; then
#   touch "${TODO_FILE}"
# fi
#
# function add_todo() {
#   echo -e "$*" >>"${TODO_FILE}"
# }
#
# function remove_todo() {
#   if [[ ! -z "$DONE_FILE" ]]; then
#     echo "${*}" >>"${DONE_FILE}"
#   fi
#   #echo "${*}" | xclip -selection clipboard
#   sed -i "/^${*}$/d" "${TODO_FILE}"
# }
#
# function get_todos() {
#   echo "$(cat "${TODO_FILE}")"
# }
#
# if [ -z "$@" ]; then
#   get_todos
# else
#   LINE=$(echo "${@}" | sed "s/\([^a-zA-Z0-9]\)/\\\\\\1/g")
#   LINE_UNESCAPED=${@}
#   if [[ $LINE_UNESCAPED == +* ]]; then
#     LINE_UNESCAPED=$(echo $LINE_UNESCAPED | sed s/^+//g | sed s/^\s+//g)
#     add_todo ${LINE_UNESCAPED}
#   else
#     MATCHING=$(grep "^${LINE_UNESCAPED}$" "${TODO_FILE}")
#     if [[ -n "${MATCHING}" ]]; then
#       remove_todo ${LINE_UNESCAPED}
#     fi
#   fi
#   get_todos
# fi

# Ensure the todo file exists
if [[ ! -e "${TODO_FILE}" ]]; then
  touch "${TODO_FILE}"
fi

# Function to add a todo
function add_todo() {
  echo -e "$*" >>"${TODO_FILE}"
  echo "Added todo: $*" >&2
}

# Function to remove a todo
function remove_todo() {
  if [[ ! -z "$DONE_FILE" ]]; then
    echo "${*}" >>"${DONE_FILE}"
  fi
  # echo "${*}" | xclip -selection clipboard
  sed -i "/^${*}$/d" "${TODO_FILE}"
  echo "Removed todo: $*" >&2
}

# Function to get todos
function get_todos() {
  cat "${TODO_FILE}"
}

# Main script logic
if [ -z "$@" ]; then
  get_todos
else
  LINE=$(echo "${@}" | sed "s/\([^a-zA-Z0-9]\)/\\\\\\1/g")
  LINE_UNESCAPED=${@}
  echo "Processing line: $LINE_UNESCAPED" >&2
  if [[ $LINE_UNESCAPED == +* ]]; then
    LINE_UNESCAPED=$(echo $LINE_UNESCAPED | sed s/^+//g | sed s/^\s+//g)
    add_todo "${LINE_UNESCAPED}"
  else
    MATCHING=$(grep "^${LINE_UNESCAPED}$" "${TODO_FILE}")
    if [[ -n "${MATCHING}" ]]; then
      remove_todo "${LINE_UNESCAPED}"
    else
      echo "No matching todo found for removal: $LINE_UNESCAPED" >&2
    fi
  fi
  get_todos
fi
