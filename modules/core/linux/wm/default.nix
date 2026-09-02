{
  lib,
  machineOptions,
  ...
}:
{
  imports = [
  ]
  ++ (lib.optionals (machineOptions.wm == "niri") [ ./niri.nix ]);
}
