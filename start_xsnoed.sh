#!/usr/bin/bash

DISPLAY_NUM=":1"
SCREEN_RES="1920x1080x16"
VNC_PORT=5900
NOVNC_PORT=8080
XSNOED_DIR="$HOME/xsnoed_snoplus"
XSNOED_CMD="./xsnoed monag2.sp.snolab.ca"

# # Clean up stale locks/sockets
# sudo rm -f /tmp/.X*-lock
# sudo rm -rf /tmp/.X11-unix/*
# sudo mkdir -p /tmp/.X11-unix
# sudo chmod 1777 /tmp/.X11-unix

# Start virtual framebuffer
Xvfb $DISPLAY_NUM -screen 0 $SCREEN_RES &
export DISPLAY=$DISPLAY_NUM
sleep 2

# Start window manager
openbox-session &

# Launch XSNOED
cd "$XSNOED_DIR"
while true; do
  echo "Starting XSNOED..."
  $XSNOED_CMD "$@" 
  echo "XSNOED exited. Restarting in 5 seconds..."
  sleep 5
done 

# Expose framebuffer via VNC
x11vnc -display $DISPLAY_NUM -forever -nopw -rfbport $VNC_PORT &
sleep 2

# Bridge VNC to browser
websockify --web /usr/share/novnc/ 0.0.0.0:$NOVNC_PORT localhost:$VNC_PORT &

# Detect WSL IP
WSL_IP=$(hostname -I | awk '{print $1}')

echo "XSNOED environment ready."
echo "Open your browser at: http://$WSL_IP:$NOVNC_PORT/vnc.html"
