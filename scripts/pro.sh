#!/usr/bin/env bash
set -euo pipefail

# fkill - fzf-based process killer
# Bright colors, no confirmation, Enter kills (or multi-select + Enter kills).
# WARNING: default signal is -9. Use responsibly.
# Override default signal: KILL_SIG=-15 ./fkill

command -v fzf >/dev/null 2>&1 || {
  echo "fzf not found. Install fzf first."
  exit 1
}

KILL_SIG=${KILL_SIG:--9} # default is -9 (SIGKILL). Override via env var if you want SIGTERM: KILL_SIG=-15 ./fkill

# total memory in kB (from /proc/meminfo)
total_mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)

# This header is shown by fzf but NOT piped as selectable input (so single Enter works consistently)
header="PID   PPID  USER       CPU%  MEM%   RAM(GB|%)     ELAPSED   CMD"

# Build process list (no header, nicely formatted). Fields:
# PID PPID USER CPU% MEM% RSS(->GB|%) ELAPSED CMD...
process_lines=$(ps -eo pid,ppid,user,%cpu,%mem,rss,etime,args --sort=-%cpu,-%mem |
  awk -v total="$total_mem_kb" 'NR>1 {
      pid=$1; ppid=$2; user=$3; cpu=$4; memperc=$5; rss=$6; etime=$7;
      cmd=""; for(i=8;i<=NF;i++){ cmd = cmd (i>8? " " : "") $i }
      mem_gb = rss/1024/1024;
      mempct = (rss/total)*100;
      memstr = sprintf("%6.2fGB(%.1f%%)", mem_gb, mempct);
      printf "%-6s %-6s %-10s %5s %6s %14s %-9s %s\n", pid, ppid, user, cpu, memperc, memstr, etime, cmd
    }')

# sanity
if [[ -z "${process_lines//[[:space:]]/}" ]]; then
  echo "No processes found."
  exit 0
fi

# Bright palette (no background colors)
fzf_colors="fg:#ffffff,hl:#ff6bcb,prompt:#7a5cff,info:#00ffff,pointer:#00ffd5,marker:#00ff87,spinner:#7a5cff,header:#89f7fe"

# Launch fzf
selected=$(printf "%s\n" "$process_lines" | fzf \
  --header="$header" \
  --layout=reverse \
  --height=45% \
  --info=inline \
  --border=rounded \
  --multi \
  --preview-window=right:60%:wrap \
  --preview 'PID=$(echo {} | cut -d" " -f1); echo "=== ps -p $PID ==="; ps -p $PID -o pid,ppid,user,%cpu,%mem,rss,etime,cmd --no-headers 2>/dev/null || true; echo; echo "=== /proc/$PID/status (top lines) ==="; sed -n "1,40p" /proc/$PID/status 2>/dev/null || true; echo; echo "=== Open files (fd) sample ==="; ls -l /proc/$PID/fd 2>/dev/null | sed -n "1,20p" || true' \
  --prompt='Select PIDs > ' \
  --color="$fzf_colors")

# extract PIDs (first column of each selected line)
pids=$(echo "$selected" | awk '{print $1}' | tr '\n' ' ' | sed 's/[[:space:]]*$//')

# nothing selected
[[ -z "$pids" ]] && exit 0

# Kill immediately (no confirmation)
# You can change the default signal by exporting KILL_SIG before running the script.
kill $KILL_SIG $pids 2>/dev/null || true

echo "✅ Killed PIDs: $pids"
