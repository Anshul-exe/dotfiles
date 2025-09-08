#!/usr/bin/env bash
set -euo pipefail

# fkill - fzf-based process killer with clean table layout

KILL_SIG=${KILL_SIG:--9}

# total memory in kB
total_mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)

# Header (displayed in fzf)
header=" PID     PPID    USER         CPU%   MEM%    RAM(GB|%)       ELAPSED    CMD"

# Build process list
process_lines=$(ps -eo pid,ppid,user,%cpu,%mem,rss,etime,args --sort=-%cpu,-%mem |
  awk -v total="$total_mem_kb" '
    NR>1 {
      pid=$1; ppid=$2; user=$3; cpu=$4; memperc=$5; rss=$6; etime=$7;
      cmd=""; for(i=8;i<=NF;i++){ cmd = cmd (i>8? " " : "") $i }
      mem_gb = rss/1024/1024;
      mempct = (rss/total)*100;
      memstr = sprintf("%.2fGB(%.1f%%)", mem_gb, mempct);

      # Bright colors for symmetry
      c_pid    = sprintf("\033[1;36m%-7s\033[0m", pid);       # cyan
      c_ppid   = sprintf("\033[1;35m%-7s\033[0m", ppid);      # magenta
      c_user   = sprintf("\033[1;37m%-10s\033[0m", user);     # white
      c_cpu    = sprintf("\033[1;31m%-5s\033[0m", cpu);       # red
      c_mem    = sprintf("\033[1;32m%-6s\033[0m", memperc);   # green
      c_ram    = sprintf("\033[1;34m%-13s\033[0m", memstr);   # blue
      c_etime  = sprintf("\033[1;33m%-9s\033[0m", etime);     # yellow
      c_cmd    = sprintf("\033[1;37m%s\033[0m", cmd);         # white

      printf "%s %s %s %s %s %s %s %s\n",
        c_pid, c_ppid, c_user, c_cpu, c_mem, c_ram, c_etime, c_cmd
    }')

# Run fzf
selected=$(printf "%b\n" "$process_lines" | fzf \
  --header="$header" \
  --layout=reverse \
  --height=70% \
  --info=inline \
  --border=rounded \
  --multi \
  --prompt='Kill PIDs > ' \
  --ansi \
  --color=fg:#ffffff,hl:#ff6bcb,prompt:#7a5cff,info:#00ffff,pointer:#00ffd5,marker:#00ff87,spinner:#7a5cff,header:#89f7fe)

# Extract PIDs (strip color codes → first field)
pids=$(echo -e "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | tr '\n' ' ' | sed 's/[[:space:]]*$//')

[[ -z "$pids" ]] && exit 0

# Kill instantly
kill $KILL_SIG $pids 2>/dev/null || true

echo "✅ Killed PIDs: $pids"
