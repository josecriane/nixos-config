{ pkgs, username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";

      # displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
