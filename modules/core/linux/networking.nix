{ pkgs, machineOptions, ... }:
{
  networking = {
    hostName = "${machineOptions.hostname}";
    networkmanager.enable = true;
  };
}
