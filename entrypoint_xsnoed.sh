#!/usr/bin/bash

# Start virtual X server
Xvfb :1 -screen 0 1920x1080x16 &
export DISPLAY=:1
sleep 2

# Start Openbox
openbox-session &

# Call the original entrypoint wrapper with XSNOED’s script
/usr/local/bin/entrypoint.sh /xsnoed/xsnoed_entry.sh "$@" &

# Expose via VNC
x11vnc -display :1 -forever -nopw -rfbport 5900 &
sleep 2

websockify --web /usr/share/novnc/ 8080 localhost:5900
