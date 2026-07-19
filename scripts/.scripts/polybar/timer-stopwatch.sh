#!/bin/bash

# Polybar Timer/Stopwatch Script with Toggle and Pause
# Save this as ~/.config/polybar/scripts/timer-stopwatch.sh
# Make it executable: chmod +x ~/.config/polybar/scripts/timer-stopwatch.sh

STATE_FILE="/tmp/polybar-timer-state"
TIMER_FILE="/tmp/polybar-timer-end"
STOPWATCH_FILE="/tmp/polybar-stopwatch-start"
MODE_FILE="/tmp/polybar-timer-mode"
PAUSE_FILE="/tmp/polybar-timer-paused"
PAUSE_DURATION_FILE="/tmp/polybar-pause-duration"
STOPWATCH_ACTIVE_FILE="/tmp/polybar-stopwatch-active"

# Initialize files if they don't exist
[ ! -f "$STATE_FILE" ] && echo "stopwatch" >"$STATE_FILE"
[ ! -f "$MODE_FILE" ] && echo "date" >"$MODE_FILE"
[ ! -f "$PAUSE_FILE" ] && echo "0" >"$PAUSE_FILE"
[ ! -f "$PAUSE_DURATION_FILE" ] && echo "0" >"$PAUSE_DURATION_FILE"
[ ! -f "$STOPWATCH_ACTIVE_FILE" ] && echo "0" >"$STOPWATCH_ACTIVE_FILE"

format_time() {
  local total_seconds=$1
  local hours=$((total_seconds / 3600))
  local minutes=$(((total_seconds % 3600) / 60))
  local seconds=$((total_seconds % 60))

  if [ $hours -gt 0 ]; then
    printf "%02d:%02d:%02d" $hours $minutes $seconds
  else
    printf "%02d:%02d" $minutes $seconds
  fi
}

get_mode() {
  cat "$MODE_FILE"
}

display() {
  local state=$(cat "$STATE_FILE")
  local is_paused=$(cat "$PAUSE_FILE")
  local pause_duration=$(cat "$PAUSE_DURATION_FILE")
  local stopwatch_active=$(cat "$STOPWATCH_ACTIVE_FILE")

  # Ensure stopwatch is running in background
  if [ "$stopwatch_active" = "0" ]; then
    date +%s >"$STOPWATCH_FILE"
    echo "1" >"$STOPWATCH_ACTIVE_FILE"
  fi

  if [ "$state" = "timer" ] && [ -f "$TIMER_FILE" ]; then
    local end_time=$(cat "$TIMER_FILE")
    local current_time=$(date +%s)

    if [ "$is_paused" = "1" ]; then
      # Paused - show static time
      local remaining=$(cat /tmp/polybar-timer-remaining 2>/dev/null || echo "0")
      local stopwatch_elapsed=$(cat /tmp/polybar-stopwatch-elapsed 2>/dev/null || echo "0")
      local timer_formatted=$(format_time $remaining)
      local stopwatch_formatted=$(format_time $stopwatch_elapsed)
      echo "⏸ ${timer_formatted} | ${stopwatch_formatted}"
    else
      local remaining=$((end_time - current_time + pause_duration))

      if [ $remaining -le 0 ]; then
        # Timer finished
        echo "stopwatch" >"$STATE_FILE"
        rm -f "$TIMER_FILE"
        notify-send "Timer" "Time's up!" -u critical
        display
      else
        local stopwatch_start=$(cat "$STOPWATCH_FILE")
        local stopwatch_elapsed=$((current_time - stopwatch_start - pause_duration))
        local timer_formatted=$(format_time $remaining)
        local stopwatch_formatted=$(format_time $stopwatch_elapsed)
        echo "${timer_formatted} | ${stopwatch_formatted}"
      fi
    fi
  else
    # Only stopwatch
    if [ -f "$STOPWATCH_FILE" ]; then
      local start_time=$(cat "$STOPWATCH_FILE")
      local current_time=$(date +%s)

      if [ "$is_paused" = "1" ]; then
        local elapsed=$(cat /tmp/polybar-stopwatch-elapsed 2>/dev/null || echo "0")
        local formatted=$(format_time $elapsed)
        echo "⏸ ${formatted}"
      else
        local elapsed=$((current_time - start_time - pause_duration))
        local formatted=$(format_time $elapsed)
        echo "${formatted}"
      fi
    else
      echo "00:00"
    fi
  fi
}

toggle_mode() {
  local current_mode=$(cat "$MODE_FILE")

  if [ "$current_mode" = "date" ]; then
    echo "timer" >"$MODE_FILE"
    # Start stopwatch if not already active
    local stopwatch_active=$(cat "$STOPWATCH_ACTIVE_FILE")
    if [ "$stopwatch_active" = "0" ]; then
      date +%s >"$STOPWATCH_FILE"
      echo "1" >"$STOPWATCH_ACTIVE_FILE"
      echo "stopwatch" >"$STATE_FILE"
      echo "0" >"$PAUSE_DURATION_FILE"
      echo "0" >"$PAUSE_FILE"
    fi
    # Hide date module, show timer module
    polybar-msg action "#date-12.module_hide" 2>/dev/null
    polybar-msg action "#timer-display.module_show" 2>/dev/null
  else
    echo "date" >"$MODE_FILE"
    # Show date module, hide timer module
    polybar-msg action "#date-12.module_show" 2>/dev/null
    polybar-msg action "#timer-display.module_hide" 2>/dev/null
  fi
}

toggle_pause() {
  local is_paused=$(cat "$PAUSE_FILE")
  local current_time=$(date +%s)

  if [ "$is_paused" = "0" ]; then
    # Pause
    echo "1" >"$PAUSE_FILE"
    echo "$current_time" >/tmp/polybar-pause-start

    # Save current values
    local state=$(cat "$STATE_FILE")
    if [ "$state" = "timer" ] && [ -f "$TIMER_FILE" ]; then
      local end_time=$(cat "$TIMER_FILE")
      local pause_duration=$(cat "$PAUSE_DURATION_FILE")
      local remaining=$((end_time - current_time + pause_duration))
      echo "$remaining" >/tmp/polybar-timer-remaining

      local stopwatch_start=$(cat "$STOPWATCH_FILE")
      local stopwatch_elapsed=$((current_time - stopwatch_start - pause_duration))
      echo "$stopwatch_elapsed" >/tmp/polybar-stopwatch-elapsed
    else
      if [ -f "$STOPWATCH_FILE" ]; then
        local start_time=$(cat "$STOPWATCH_FILE")
        local pause_duration=$(cat "$PAUSE_DURATION_FILE")
        local elapsed=$((current_time - start_time - pause_duration))
        echo "$elapsed" >/tmp/polybar-stopwatch-elapsed
      fi
    fi
    notify-send "Timer/Stopwatch" "Paused" -t 1000
  else
    # Resume
    echo "0" >"$PAUSE_FILE"
    local pause_start=$(cat /tmp/polybar-pause-start 2>/dev/null || echo "$current_time")
    local pause_duration=$(cat "$PAUSE_DURATION_FILE")
    local paused_for=$((current_time - pause_start))
    echo "$((pause_duration + paused_for))" >"$PAUSE_DURATION_FILE"
    notify-send "Timer/Stopwatch" "Resumed" -t 1000
  fi
}

set_timer() {
  # Use rofi or dmenu for input
  if command -v rofi &>/dev/null; then
    local input=$(echo -e "5m\n10m\n15m\n30m\n1h\nCustom" | rofi -dmenu -p "Set timer")
  else
    local input=$(echo -e "5m\n10m\n15m\n30m\n1h\nCustom" | dmenu -p "Set timer:")
  fi

  if [ -z "$input" ]; then
    return
  fi

  if [ "$input" = "Custom" ]; then
    if command -v rofi &>/dev/null; then
      input=$(rofi -dmenu -p "Enter time (e.g., 5m, 1h30m, 90s)")
    else
      input=$(dmenu -p "Enter time (e.g., 5m, 1h30m, 90s):" </dev/null)
    fi
  fi

  if [ -z "$input" ]; then
    return
  fi

  # Parse time input
  local seconds=0

  # Extract hours, minutes, seconds
  if [[ $input =~ ([0-9]+)h ]]; then
    seconds=$((seconds + ${BASH_REMATCH[1]} * 3600))
  fi
  if [[ $input =~ ([0-9]+)m ]]; then
    seconds=$((seconds + ${BASH_REMATCH[1]} * 60))
  fi
  if [[ $input =~ ([0-9]+)s ]]; then
    seconds=$((seconds + ${BASH_REMATCH[1]}))
  fi

  # If no unit specified, assume minutes
  if [[ $input =~ ^[0-9]+$ ]]; then
    seconds=$((input * 60))
  fi

  if [ $seconds -gt 0 ]; then
    local current_time=$(date +%s)
    local pause_duration=$(cat "$PAUSE_DURATION_FILE")
    local end_time=$((current_time + seconds - pause_duration))
    echo "$end_time" >"$TIMER_FILE"
    echo "timer" >"$STATE_FILE"
    # Ensure stopwatch is running
    if [ ! -f "$STOPWATCH_FILE" ]; then
      echo "$current_time" >"$STOPWATCH_FILE"
    fi
    notify-send "Timer" "Timer set for $(format_time $seconds)" -t 2000
  fi
}

reset() {
  echo "stopwatch" >"$STATE_FILE"
  local current_time=$(date +%s)
  echo "$current_time" >"$STOPWATCH_FILE"
  echo "0" >"$PAUSE_FILE"
  echo "0" >"$PAUSE_DURATION_FILE"
  rm -f "$TIMER_FILE"
  rm -f /tmp/polybar-timer-remaining
  rm -f /tmp/polybar-stopwatch-elapsed
  rm -f /tmp/polybar-pause-start
  notify-send "Timer/Stopwatch" "Reset" -t 1000
}

case "$1" in
display)
  display
  ;;
mode)
  get_mode
  ;;
toggle)
  toggle_mode
  ;;
menu)
  # Show menu for timer/stopwatch actions
  if command -v rofi &>/dev/null; then
    choice=$(echo -e "Set Timer\nReset All" | rofi -dmenu -p "Action")
  else
    choice=$(echo -e "Set Timer\nReset All" | dmenu -p "Action:")
  fi

  case "$choice" in
  "Set Timer")
    set_timer
    ;;
  "Reset All")
    reset
    ;;
  esac
  ;;
pause)
  toggle_pause
  ;;
*)
  echo "Usage: $0 {display|mode|toggle|menu|pause}"
  exit 1
  ;;
esac
