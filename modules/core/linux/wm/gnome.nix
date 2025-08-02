{
  pkgs,
  lib,
  machineOptions,
  ...
}:
{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
