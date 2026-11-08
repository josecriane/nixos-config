{ config, ... }:
{
  networking = {
    hostName = config.machine.hostname;
    networkmanager.enable = true;
    hosts."10.11.99.1" = [ "usb.remarkable" ];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
