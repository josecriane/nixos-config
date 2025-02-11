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
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
