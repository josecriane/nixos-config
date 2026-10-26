{
  config,
  pkgs,
  ...
}:
{
  # STIG V-268151: Time synchronization enabled
  services.timesyncd = {
    enable = true;

    # STIG V-268150: Clock synchronization poll interval
    settings.Time.PollIntervalMaxSec = 60;
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

  services.printing.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [ "--operator=${config.machine.username}" ];
  };

  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;

  programs.nix-ld.enable = true;

  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    age
    fwupd
    ddcutil
    lm_sensors
    upower

    # STIG V-268087: Session lock for TTY consoles
    vlock
  ];
}
