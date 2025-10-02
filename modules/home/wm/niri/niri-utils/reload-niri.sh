#!/usr/bin/env bash

# Restart niri to reload configuration
# Note: niri doesn't have a reload-config command, need to restart the service
systemctl --user restart niri.service

# Optional: Restart tray applications if needed
#~/.config/niri/start-tray-apps
