#!/usr/bin/bash
set -euo pipefail

DISPLAY_NUM=":1"
SCREEN_RES="1920x1080x16"
VNC_PORT=5900
NOVNC_PORT=8080
XSNOED_DIR="$HOME/SNOPLUS/xsnoed_snoplus"
XSNOED_CMD="./xsnoed localhost"

# Ensure X socket directory exists
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start Xvfb if not already running
display_idx="${DISPLAY_NUM#:}"
if ! pgrep -f "Xvfb ${DISPLAY_NUM}" >/dev/null; then
  rm -f "/tmp/.X${display_idx}-lock" || true
  Xvfb "$DISPLAY_NUM" -screen 0 "$SCREEN_RES" &
  sleep 2
fi
export DISPLAY="$DISPLAY_NUM"

# Start openbox if not already running
if ! pgrep -x openbox >/dev/null; then
  openbox-session &
  sleep 1
fi

# Start x11vnc if not already running on this display
if ! pgrep -f "x11vnc.*${DISPLAY_NUM}" >/dev/null; then
  x11vnc -display "$DISPLAY_NUM" -forever -nopw -rfbport "$VNC_PORT" &
  sleep 2
fi

# Start websockify/noVNC if not already running
if ! pgrep -f "websockify.*${NOVNC_PORT}" >/dev/null; then
  if [ -d /usr/share/novnc ]; then
    websockify --web /usr/share/novnc/ 0.0.0.0:"$NOVNC_PORT" localhost:"$VNC_PORT" &
  else
    echo "Warning: noVNC not found at /usr/share/novnc"
  fi
  sleep 2
fi

HOST_IP=$(hostname -I | awk '{print $1}')
echo "XSNOED environment ready."
echo "Open your browser at: http://${HOST_IP}:${NOVNC_PORT}/vnc.html"

# Launch XSNOED with auto-restart (runs in foreground)
cd "$XSNOED_DIR"
while true; do
  echo "Starting XSNOED..."
  $XSNOED_CMD "$@" 
  echo "XSNOED exited. Restarting in 5 seconds..."
  sleep 5
done