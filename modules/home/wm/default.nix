{
  config,
  lib,
  pkgs,
  machineOptions,
  self,
  ...
}:
{
  imports =
    [ ]
    ++ (lib.optionals (machineOptions.wm == "plasma") [ ./plasma.nix ])
    ++ (lib.optionals (machineOptions.wm == "niri") [
      ./niri
      ./quickshell
    ]);
}
