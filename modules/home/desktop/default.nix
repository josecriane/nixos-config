{ inputs, host, ... }:
{
  imports = [
    ./alacritty.nix
    ./discord.nix
    ./firefox.nix
    ./gaming.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}
