{
  config,
  pkgs,
  ...
}:
{
  services = {
    printing.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraSetFlags = [ "--operator=${config.machine.username}" ];
    };

    fwupd.enable = true;

    upower.enable = true;
  };

  systemd.coredump.settings.Coredump = {
    ProcessSizeMax = "4G";
    ExternalSizeMax = "4G";
  };

  systemd.services."systemd-coredump@" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      RuntimeMaxSec = 60;
      MemoryMax = "2G";
      IOSchedulingClass = "idle";
    };
  };

  hardware.enableRedistributableFirmware = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    age
    fwupd
    ddcutil
    lm_sensors
    upower
  ];
}
