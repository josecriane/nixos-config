{ inputs, host, ... }:
{
  imports = [
    ./3dprinting.nix
    ./alacritty.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./gaming.nix
    ./keepassxc.nix
    ./media.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}
