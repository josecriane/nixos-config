{
  config,
  lib,
  pkgs,
  machineOptions,
  self,
  ...
}:
{
  imports = [ ] ++ (lib.optionals (machineOptions.wm == "niri") [ ./niri ]);
}
