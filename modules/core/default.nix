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
    ./alias.nix
    ./android.nix
    ./paths.nix
    ./system.nix
    ./zsh.nix
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [ ./linux ])
  ++ (lib.optionals (machineOptions.os == "macos") [ ./macos ]);
}
