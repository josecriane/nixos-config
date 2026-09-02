{
  lib,
  machineOptions,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./discord.nix
    ./keepassxc.nix
    ./media.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [
    ./3dprinting.nix
    ./gaming.nix
    ./ghostty.nix
  ]);
}
