{
  inputs,
  nixpkgs,
  lib,
  self,
  host,
  machineOptions,
  ...
}:
{
  imports = [
    ./alias.nix
    ./android.nix
    ./system.nix
    ./zsh.nix
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [ ./linux ])
  ++ (lib.optionals (machineOptions.os == "macos") [ ./macos ]);
}
