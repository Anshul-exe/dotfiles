#!/bin/sh

# punchReminder.sh — remind me to punch Time In / Time Out on the HR portal.
# Work hours are 18:30–03:30 IST, so each reminder fires twice: a nudge 5 min
# before, then a critical one 1 min before that stays on screen until dismissed.
# Driven by cron — the schedule lives in system/crontab.user in this repo.
#
# Usage: punchReminder.sh {timein|timeout} [urgent]

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

ICON_DIR="$HOME/clear_space/Media/idharUdhar"

case "$1" in
timein)
  ICON="$ICON_DIR/money.png"
  TITLE="Time In"
  BODY="Punch in — 6:30 PM"
  URGENT_TITLE="TIME IN NOW"
  URGENT_BODY="Punch in!"
  ;;
timeout)
  ICON="$ICON_DIR/LessGooBaby.png"
  TITLE="Time Out"
  BODY="Punch out — 3:30 AM"
  URGENT_TITLE="TIME OUT NOW"
  URGENT_BODY="Punch out!"
  ;;
*)
  echo "usage: ${0##*/} {timein|timeout} [urgent]" >&2
  exit 1
  ;;
esac

# -r reuses one notification id, so the 6:29 alert replaces the 6:25 one
# instead of stacking a second popup on top of it.
if [ "$2" = "urgent" ]; then
  notify-send "$URGENT_TITLE" "$URGENT_BODY" -u critical -i "$ICON" -a punchReminder -r 9992
else
  notify-send "$TITLE" "$BODY" -u normal -i "$ICON" -a punchReminder -r 9992
fi
