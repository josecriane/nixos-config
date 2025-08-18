#!/usr/bin/env bash

# Reload niri configuration
niri msg reload-config

# Restart tray applications
~/.config/niri/start-tray-apps

# Optionally restart waybar to ensure it reconnects to the tray apps
pkill waybar
sleep 0.2
waybar &