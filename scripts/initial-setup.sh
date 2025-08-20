#!/bin/bash

# --------------------------
# -----   WIP   ------------
# --------------------------

# Prerequisites:
# In your firmware disable Secure Boot and enable db to enroll new keys

# copy agenix-key.age to /etc/agenix/agenix-key.age
# copy id_rsa.age and id_rsa_pub.age inside ~/.ssh/

# Update hardware configuration from /etc/nixos/hardware-configuration.nix
HOSTNAME=${1:-$(hostname)}
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/${HOSTNAME}/hardware-configuration.nix

# Enable SecureBoot
# Source: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde
sudo nix run nixpkgs#sbctl create-keys
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
bootctl status

# First rebuild
rm -Rf ~/.ssh/id_rsa ~/.ssh/id_rsa.pub

nix run nixpkgs#age -d -i /etc/agenix/agenix-key.age ~/.ssh/id_rsa.age > ~/.ssh/id_rsa
nix run nixpkgs#age -d -i /etc/agenix/agenix-key.age ~/.ssh/id_rsa_pub.age > ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id*
chmod 644 ~/.ssh/*.pub

eval $(ssh-agent -s)
ssh-add
ssh-add -l

sudo SSH_AUTH_SOCK="$SSH_AUTH_SOCK" nixos-rebuild switch --flake ~/nixos-config#newarre

# Enroll fprint if needed
fprintd-enroll

fprintd-verify