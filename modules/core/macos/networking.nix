{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    computerName = "${host}";
  };

  system.defaults.smb.NetBIOSName = "${host}";
}