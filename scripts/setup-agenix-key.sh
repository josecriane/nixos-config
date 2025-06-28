#!/usr/bin/env bash

# Script to setup agenix master key on a machine
# This script must be run with sudo

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run with sudo"
   exit 1
fi

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    OWNER_GROUP="root:wheel"
    print_info "Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    OWNER_GROUP="root:root"
    print_info "Detected Linux"
else
    print_error "Unsupported OS: $OSTYPE"
    exit 1
fi

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
SOURCE_KEY="$REPO_ROOT/secrets/agenix-key.age"
TARGET_DIR="/etc/agenix"
TARGET_KEY="$TARGET_DIR/agenix-key.age"

# Check if source key exists
if [[ ! -f "$SOURCE_KEY" ]]; then
    print_error "Source key not found: $SOURCE_KEY"
    print_info "Make sure you're running this from the nixos-config repository"
    exit 1
fi

# Check if target already exists
if [[ -f "$TARGET_KEY" ]]; then
    print_warn "Target key already exists: $TARGET_KEY"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Aborting..."
        exit 0
    fi
fi

# Create target directory
print_info "Creating directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Copy the key
print_info "Copying agenix key..."
cp "$SOURCE_KEY" "$TARGET_KEY"

# Set permissions
print_info "Setting permissions..."
chmod 600 "$TARGET_KEY"
chown $OWNER_GROUP "$TARGET_KEY"

# Verify
if [[ -f "$TARGET_KEY" ]]; then
    print_info "✓ Key installed successfully at: $TARGET_KEY"
    print_info "✓ Permissions: $(ls -l "$TARGET_KEY" | awk '{print $1 " " $3 " " $4}')"
    
    echo
    print_info "Next steps:"
    if [[ "$OS" == "macos" ]]; then
        print_info "  1. Run: ./scripts/nix-mac.sh -s"
    else
        print_info "  1. Run: sudo nixos-rebuild switch --flake .#$(hostname)"
    fi
    print_info "  2. Your SSH keys will be automatically decrypted and placed in ~/.ssh/"
else
    print_error "Failed to install key"
    exit 1
fi
