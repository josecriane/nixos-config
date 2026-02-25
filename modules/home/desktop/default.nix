{ inputs, host, ... }:
{
  imports = [
    ./alacritty.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./gaming.nix
    ./keepassxc.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}
