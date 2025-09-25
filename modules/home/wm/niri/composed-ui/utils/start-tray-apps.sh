#!/usr/bin/env bash

# Kill existing instances to prevent duplicates
pkill -f "nm-applet --indicator" 2>/dev/null
pkill -f "bluetooth-applet" 2>/dev/null
pkill -f "pasystray" 2>/dev/null

# Wait a moment for processes to fully terminate
sleep 0.5

# Start fresh instances
nm-applet --indicator &
blueman-applet &
pasystray &