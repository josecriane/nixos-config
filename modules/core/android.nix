{ config,
  pkgs, 
  machineOptions,
  ... 
}:
let
  username = machineOptions.username;
in
{
#   services.udev.packages = [ pkgs.android-udev-rules ];

#   users.users.${username} = {
#     extraGroups = [
#       "adbusers"
#     ];
#   };
}
