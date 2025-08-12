{ inputs, host, ... }:
{
  imports = [
    ./alacritty.nix
    ./discord.nix
    ./firefox.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}
