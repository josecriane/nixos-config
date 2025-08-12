{ pkgs, machineOptions, ... }:
{
  networking = {
    hostName = "${machineOptions.hostname}";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
