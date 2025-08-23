#!/usr/bin/env bash

# Simple approach: if wofi is running, kill it. Otherwise start it.
if pgrep wofi > /dev/null; then
    # Wofi is running, kill it
    pkill wofi
    wofi &
else
    # Wofi is not running, start it
    wofi &
fi