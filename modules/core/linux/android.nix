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
    programs.adb.enable = true;

    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
