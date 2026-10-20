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
    ./ghostty.nix
    ./teamspeak.nix
  ])
  ++ (lib.optionals machineOptions.gaming [ ./gaming.nix ]);
}
