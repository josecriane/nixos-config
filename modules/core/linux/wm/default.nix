
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
  ]
  ++ (lib.optionals (machineOptions.wm == "plasma") [ ./plasma.nix ])
  ++ (lib.optionals (machineOptions.wm == "gnome") [ ./gnome.nix ])
  ++ (lib.optionals (machineOptions.wm == "niri") [ ./niri.nix ]);
}
