{ lib, machineOptions, ... }:
{
  imports = [ ] ++ (lib.optionals (machineOptions.wm != null) [ ./wm ]);

  services = {
    xserver.enable = false;

    libinput.enable = true;
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";
}
