{ inputs, host, ... }:
{
  imports = [
    ./3dprinting.nix
    ./alacritty.nix
    ./browser.nix
    ./discord.nix
    ./gaming.nix
    ./ghostty.nix
    ./keepassxc.nix
    ./media.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}
