#!/bin/bash
# ANSI Color codes
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'

ROOT_DIR="$PWD"

# Create a temporary preview script
PREVIEW_SCRIPT=$(mktemp)
trap "rm -f $PREVIEW_SCRIPT" EXIT

# Write the preview script to the temporary file
cat >"$PREVIEW_SCRIPT" <<'EOF'
#!/bin/bash
# Get the repo path from the fzf selected line
repo_line="$1"
ROOT_DIR="$2"
repo_path=$(echo "$repo_line" | cut -d '|' -f1 | xargs)
full_path="$ROOT_DIR/$repo_path"

# Color codes
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'

cd "$full_path" || exit 1

# Repository name header with branch info
echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${PURPLE} Repository: ${GREEN}$repo_path${NC}"
echo -e "${BOLD}${PURPLE} Branch:     ${GREEN}$(git branch --show-current)${NC}"
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Git status with colored output
echo -e "${BOLD}${YELLOW}📋 GIT STATUS:${NC}"
git -c color.status=always status -s

# Show diff stats
echo -e "\n${BOLD}${YELLOW}📊 DIFF STATS:${NC}"
git diff --stat | sed "s/^ //"

# Show recent commits (last 5)
echo -e "\n${BOLD}${YELLOW}🕒 RECENT COMMITS:${NC}"
git log -n 5 --color --pretty=format:"%C(blue)%h%C(red)%d %C(cyan)(%cr) %C(yellow)%cn %C(reset)%s" 2>/dev/null

# Show unpushed commits
echo -e "\n${BOLD}${YELLOW}🚀 UNPUSHED COMMITS:${NC}"
git log --color --pretty=format:"%C(blue)%h%C(red)%d %C(cyan)(%cr) %C(yellow)%cn %C(reset)%s" @{u}..HEAD 2>/dev/null || echo -e "${CYAN}None or no upstream set${NC}"

# Show stashed changes
echo -e "\n${BOLD}${YELLOW}📦 STASHED CHANGES:${NC}"
git stash list --color --pretty=format:"%C(blue)%gd %C(cyan)(%cr) %C(yellow)%cn %C(reset)%s" || echo -e "${CYAN}No stashes found${NC}"

# Show repo info
echo -e "\n${BOLD}${YELLOW}📚 REPO INFO:${NC}"
remote_url=$(git remote get-url origin 2>/dev/null)
if [[ $? -eq 0 ]]; then
echo -e "${PURPLE}Remote URL: ${BLUE}$remote_url${NC}"
else
echo -e "${CYAN}No remote set${NC}"
fi

# Last activity
echo -e "${PURPLE}Last commit: ${BLUE}$(git log -1 --format="%cr by %cn" 2>/dev/null || echo "No commits")${NC}"
echo -e "${PURPLE}Total commits: ${BLUE}$(git rev-list --count HEAD 2>/dev/null || echo "Unknown")${NC}"
EOF

# Make the preview script executable
chmod +x "$PREVIEW_SCRIPT"

# Determine if we're inside a git repo already
if git rev-parse --is-inside-work-tree &>/dev/null; then
  # We're inside a git repo, so find the repo root
  REPO_ROOT=$(git rev-parse --show-toplevel)
  # Start from parent directory of the current repo
  START_DIR=$(dirname "$REPO_ROOT")
else
  # Not in a git repo, use current directory
  START_DIR="$ROOT_DIR"
fi

# Find git repositories
mapfile -t repos < <(find "$START_DIR" -type d -name ".git" -prune 2>/dev/null | sed 's|/.git||')

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
    rel_path="${repo#$START_DIR/}"
    dirty_repos+=("${rel_path} | [${status}]")
    repo_lookup["$rel_path"]="$repo"
  fi
done

# Back to root
cd "$ROOT_DIR" || exit

if [[ ${#dirty_repos[@]} -eq 0 ]]; then
  echo "✅ No dirty repositories found in '$START_DIR'."
  exit 0
fi

# Calculate a reasonable height for the preview window (75% of terminal height)
TERM_HEIGHT=$(tput lines)
PREVIEW_HEIGHT=$((TERM_HEIGHT * 75 / 100))

# Run fzf with the preview script
selected=$(printf "%s\n" "${dirty_repos[@]}" | fzf --ansi --prompt="Dirty Git Repos > " \
  --preview="$PREVIEW_SCRIPT {} \"$START_DIR\"" \
  --preview-window="right:60%:wrap:~$PREVIEW_HEIGHT")

[[ -z "$selected" ]] && exit 0

repo_path=$(echo "$selected" | cut -d '|' -f1 | xargs)
absolute_path="${repo_lookup["$repo_path"]}"

if [[ ! -d "$absolute_path" ]]; then
  echo "❌ Directory not found: $absolute_path"
  exit 1
fi

echo -e "\n📂 Selected: $repo_path"
read -rp "Open with [n]vim, [l]azygit, or [c]d to directory? " choice
# read -rp "Open with [n]vim, [l]azygit, [v]scode, or [c]d to directory? " choice ## Uncomment this to add VSCode option (I use NVIM as it's superior and how it should be, also uncomment the VSCode option from the choice case below )

case "$choice" in
n | N) nvim "$absolute_path" ;;
# v | V) code "$absolute_path" ;;
l | L) cd "$absolute_path" && lazygit ;;
c | C)
  cd "$absolute_path"
  echo "Changed directory to: $absolute_path"
  exec bash
  ;;
*) echo "❌ Invalid choice. Aborted." ;;
esac
