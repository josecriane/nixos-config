{ config, ... }:
let
  inherit (config.machine) hostname;
in
{
  networking = {
    hostName = hostname;
    computerName = hostname;
  };

  system.defaults.smb.NetBIOSName = hostname;
}
