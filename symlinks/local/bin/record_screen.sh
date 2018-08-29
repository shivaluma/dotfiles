#!/bin/bash
#
# Records the entire screen, run second time to stop recording

# strict mode
set -euo pipefail
IFS=$'\n\t'

# Acts as `stdin` for `ffmpeg` process
SCREEN_CAP_INPUT_FILE=/tmp/i3-screencap-input
if [ -f "$SCREEN_CAP_INPUT_FILE" ]; then
  # Quit if already running
  echo 'q' > "$SCREEN_CAP_INPUT_FILE"
  rm "$SCREEN_CAP_INPUT_FILE"
  notify 'Screen recording saved!'
  exit
fi

SCREEN_DIMENSIONS=$(xdotool getdisplaygeometry | tr ' ' x)
FILENAME="$HOME/Downloads/screencast-$(date +%F-%T).mkv"

touch "$SCREEN_CAP_INPUT_FILE"
< "$SCREEN_CAP_INPUT_FILE" ffmpeg -framerate 25 \
  -f x11grab \
  -video_size "$SCREEN_DIMENSIONS" \
  -i ":0.0" \
  "$FILENAME" \
  > /dev/null 2> /tmp/i3-screencap.log
