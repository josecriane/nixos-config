{
  config,
  pkgs,
  lib,
  machineOptions,
  ...
}:
let
  username = machineOptions.username;
in
{
  config = {
    services.udev.packages = [ pkgs.android-udev-rules ];

    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
