#/bin/bash

xcode-select --install

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

mkdir -p nixos-config
cd nixos-config
nix flake --extra-experimental-features 'nix-command flakes' init -t github:dustinlyons/nixos-config#starter-with-secrets

find apps/$(uname -m | sed 's/arm64/aarch64/')-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys -o -name rollback \) -exec chmod +x {} \;

nix --extra-experimental-features 'nix-command flakes' build ~/nixos-config#darwinConfigurations.MacBookAir10-1-jose-cribeiro.system
