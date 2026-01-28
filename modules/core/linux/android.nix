{
  config,
  pkgs,
  lib,
  machineOptions,
  ...
}:
{
  config = {
    environment.systemPackages = [ pkgs.android-tools ];
  };
}
