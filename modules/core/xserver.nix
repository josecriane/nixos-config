{ pkgs, lib, machineOptions, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };

  imports = []
  ++ (lib.optionals (machineOptions.wm == "plasma") [./wm/plasma.nix])
  ++ (lib.optionals (machineOptions.wm == "gnome") [./wm/gnome.nix]);

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
