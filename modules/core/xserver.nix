{ pkgs, username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
