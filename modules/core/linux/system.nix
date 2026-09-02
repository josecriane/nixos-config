{
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # STIG V-268151: Time synchronization enabled
  # Ensures accurate timestamps for forensic analysis and event correlation
  services.timesyncd = {
    enable = true;

    # STIG V-268150: Clock synchronization poll interval
    # Sync when time difference exceeds one second
    settings.Time.PollIntervalMaxSec = 60;
  };

  # STIG V-268149: Authorized time servers (INTENTIONALLY NOT FOLLOWED)
  # NOTE: DoD time servers not applicable - using system defaults
  # Risk accepted: System uses appropriate NTP servers for non-DoD infrastructure
  # networking.timeServers = [
  #   "tick.usnogps.navy.mil"
  #   "tock.usnogps.navy.mil"
  # ];

  services.printing.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;

  programs.nix-ld.enable = true;

  # STIG V-268082: DOD banner for local logins/getty (INTENTIONALLY NOT FOLLOWED)
  # NOTE: DOD banner not configured - not a U.S. Government system
  # Risk accepted: This is not a DOD/government system, displaying USG legal warnings would be inappropriate
  # DOD banners are specifically for U.S. Government Information Systems with legal monitoring requirements
  # services.getty.helpLine = "..."; # Commented out - not applicable

  # STIG V-268162: System security updates (INTENTIONALLY NOT AUTOMATED)
  # NOTE: Automatic updates not configured - system is updated manually on a weekly basis
  # Risk accepted: Manual updates provide better control and testing for flake-based configurations
  # Update procedure followed weekly:
  #   1. cd ~/nixos-config && nix flake update
  #   2. sudo nixos-rebuild switch --flake ~/nixos-config
  #   3. Reboot if kernel/critical updates
  # This approach ensures outdated packages are removed while maintaining system stability
  # Automatic updates could be enabled with system.autoUpgrade but are not recommended for flake configs
  # system.autoUpgrade.enable = false;

  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    age
    fwupd
    ddcutil
    lm_sensors
    upower

    # STIG V-268087: session lock for TTY consoles. Graphical sessions use
    # swaylock instead (modules/home/wm/niri/swaylock.nix).
    vlock
  ];
}
