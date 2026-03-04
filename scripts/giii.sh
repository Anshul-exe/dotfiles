#!/usr/bin/env bash
set -euo pipefail

### ================== Styling ==================
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

die() {
  echo -e "${RED}${BOLD}✖ $1${RESET}"
  exit 1
}

info() {
  echo -e "${BLUE}${BOLD}➜${RESET} $1"
}

ok() {
  echo -e "${GREEN}${BOLD}✔${RESET} $1"
}

### ================== Sanity ==================
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  die "Not inside a git repository"

### ================== File Selection ==================
info "Select EXACTLY one file per commit day"

mapfile -t FILES < <(
  git status --short |
    sed 's/^.. //' |
    fzf --multi --height=60% --border --prompt="files > "
)

FILE_COUNT=${#FILES[@]}
((FILE_COUNT == 0)) && die "No files selected"

ok "$FILE_COUNT file(s) selected"

### ================== Date Helpers ==================
parse_date() {
  date -d "$1" "+%Y-%m-%d" 2>/dev/null ||
    die "Invalid date: '$1'"
}

### ================== Date Range ==================
info "Define commit date range (must match file count)"

read -rp "Start date (e.g. 22 jan): " START_RAW
read -rp "End date   (e.g. 28 jan): " END_RAW

START=$(parse_date "$START_RAW")
END=$(parse_date "$END_RAW")

[[ "$START" > "$END" ]] && die "Start date is after end date"

DATES=()
current="$START"
while [[ "$current" < ="$END" ]]; do
  DATES+=("$current")
  current=$(date -I -d "$current + 1 day")
done

DAY_COUNT=${#DATES[@]}

### ================== STRICT POLICY CHECK ==================
if ((FILE_COUNT != DAY_COUNT)); then
  die "Strict mode violation: $FILE_COUNT file(s) but $DAY_COUNT day(s). Must match exactly."
fi

ok "$DAY_COUNT commit day(s) validated"

### ================== Commit Messages ==================
info "Commit message per file/day (ENTER = reuse previous)"

MESSAGES=()
LAST_MSG=""

for i in "${!FILES[@]}"; do
  file="${FILES[$i]}"
  date="${DATES[$i]}"

  prompt="[$date] message for ${file}: "
  read -rp "$prompt" msg

  if [[ -z "$msg" ]]; then
    [[ -z "$LAST_MSG" ]] && die "First commit message cannot be empty"
    msg="$LAST_MSG"
  fi

  MESSAGES+=("$msg")
  LAST_MSG="$msg"
done

### ================== Commit Loop ==================
info "Creating commits (1 file → 1 day)"

for i in "${!FILES[@]}"; do
  file="${FILES[$i]}"
  date="${DATES[$i]}"
  msg="${MESSAGES[$i]}"

  git reset >/dev/null
  git add "$file"

  export GIT_AUTHOR_DATE="$date 12:00:00"
  export GIT_COMMITTER_DATE="$date 12:00:00"

  git diff --cached --quiet && die "No changes staged for $file"

  git commit -m "$msg" >/dev/null
  ok "Committed $file on $date"
done

### ================== Push ==================
read -rp "Push commits now? [y/N]: " PUSH
if [[ "$PUSH" =~ ^[Yy]$ ]]; then
  git push
  ok "Pushed successfully"
else
  info "Push skipped"
fi

echo -e "${DIM}History written with constraints. Integrity preserved.${RESET}"
