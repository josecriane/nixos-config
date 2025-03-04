#!/bin/bash

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

paths=(
    "$HOME/bin"
    "$HOME/dev"
    "$HOME/doc"
    "$HOME/docs/wallpapers"
    "$HOME/scripts"
    "$HOME/templates"
    "$HOME/tmp"
)

for path in "${paths[@]}"; do
    echo "Create path: $path"
    mkdir -p "$path"
done

echo "Done"
