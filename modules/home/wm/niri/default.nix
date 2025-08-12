{ inputs, pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./services.nix
    ./waybar.nix
    ./wofi.nix
    ./swaync.nix
  ];
}
