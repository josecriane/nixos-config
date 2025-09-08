{
  inputs,
  nixpkgs,
  lib,
  self,
  machineOptions,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./stylix
    ./alias.nix
    ./essentials.nix
    ./system.nix
    ./zsh.nix
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [ ./linux ])
  ++ (lib.optionals (machineOptions.os == "macos") [ ./macos ]);
}
