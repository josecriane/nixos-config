region=$(slurp -p) || exit 0

hex=$(grim -g "$region" -t ppm - | tail -c 3 | od -An -tu1 | awk '{printf "#%02X%02X%02X", $1, $2, $3}')

printf '%s' "$hex" | wl-copy
notify-send "Color picker" "$hex copied to the clipboard" -t 2000
