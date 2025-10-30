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
    adbusers = { };

    users.users.${username} = {
      extraGroups = [ "adbusers" ];
    };
  };
}
