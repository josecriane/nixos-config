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
  config = lib.mkIf (machineOptions.os == "linux" && machineOptions.develop) {
    services.udev.packages = [ pkgs.android-udev-rules ];

    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
