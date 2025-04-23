#!/bin/bash
# ANSI Color codes
RED=$'\033[0;31m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

ROOT_DIR="$PWD"

mapfile -t repos < <(find "$ROOT_DIR" -type d -name ".git" -prune 2>/dev/null | sed 's|/.git||')

declare -a dirty_repos
declare -A repo_lookup

for repo in "${repos[@]}"; do
  cd "$repo" || continue
  # Skip corrupted repos
  git rev-parse HEAD &>/dev/null || continue

  status_output=$(git status --porcelain 2>/dev/null)
  [[ $? -ne 0 ]] && continue

  status=""
  # Untracked
  echo "$status_output" | grep -q "^??" && status+="${YELLOW}?${NC}"
  # Modified/Staged
  echo "$status_output" | grep -q -E "^[ MDAURC]" && status+="${RED}!${NC}"

  # Unpushed
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    git rev-list "$upstream"..HEAD &>/dev/null
    [[ $? -eq 0 ]] && [[ -n $(git rev-list "$upstream"..HEAD 2>/dev/null) ]] && status+="${BLUE}↑${NC}"
  fi

  if [[ -n "$status" ]]; then
    rel_path="${repo#$ROOT_DIR/}"
    dirty_repos+=("${rel_path} | [${status}]")
    repo_lookup["$rel_path"]="$repo"
  fi
done

# Back to root
cd "$ROOT_DIR" || exit

if [[ ${#dirty_repos[@]} -eq 0 ]]; then
  echo "✅ No dirty repositories found in '$ROOT_DIR'."
  exit 0
fi

selected=$(printf "%s\n" "${dirty_repos[@]}" | fzf --ansi --prompt="Dirty Git Repos > " \
  --preview="repo=\$(echo {} | cut -d '|' -f1 | xargs); cd \"$ROOT_DIR/\$repo\" && echo -e \"\\n:: Git Status ::\" && git status -s && echo -e \"\\n:: Unpushed Commits ::\" && git log --oneline @{u}..HEAD 2>/dev/null" \
  --preview-window=right:60%:wrap)

[[ -z "$selected" ]] && exit 0

repo_path=$(echo "$selected" | cut -d '|' -f1 | xargs)
absolute_path="${repo_lookup["$repo_path"]}"

if [[ ! -d "$absolute_path" ]]; then
  echo "❌ Directory not found: $absolute_path"
  exit 1
fi

echo -e "\n📂 Selected: $repo_path"
read -rp "Open with [n]vim or [l]azygit? " choice

case "$choice" in
n | N) nvim "$absolute_path" ;;
l | L) cd "$absolute_path" && lazygit ;;
*) echo "❌ Invalid choice. Aborted." ;;
esac
