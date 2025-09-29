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
  ++ (lib.optionals (machineOptions.wm == "niri") [ ./niri.nix ]);
}
