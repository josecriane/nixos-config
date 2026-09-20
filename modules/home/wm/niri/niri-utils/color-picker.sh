region=$(slurp -p) || exit 0

swatches="${XDG_RUNTIME_DIR:-/tmp}/color-picker"
mkdir -p "$swatches"
swatch="$swatches/$(date +%s%N).ppm"

grim -g "$region" -t ppm - > "$swatch"
hex=$(tail -c 3 "$swatch" | od -An -tu1 | awk '{printf "#%02X%02X%02X", $1, $2, $3}')

printf '%s' "$hex" | wl-copy
notify-send -h "string:image-path:file://$swatch" "Color picker" "$hex copied to the clipboard" -t 2000
