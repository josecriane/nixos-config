{ pkgs, machineOptions, ... }:
{
  networking = {
    hostName = "${machineOptions.hostname}";
    computerName = "${machineOptions.hostname}";
  };

  system.defaults.smb.NetBIOSName = "${machineOptions.hostname}";
}
