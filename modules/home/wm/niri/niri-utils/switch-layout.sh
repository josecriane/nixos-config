niri msg action switch-layout next

sleep 0.1

new_layout_info=$(niri msg keyboard-layouts)
if echo "$new_layout_info" | grep -q "^\s*\*.*Spanish"; then
    new_layout="Español"
else
    new_layout="English (US)"
fi

if [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
    notify-send "Keyboard Layout" "Switched to $new_layout" -t 1500
fi
