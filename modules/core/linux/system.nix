{
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # STIG V-268151: Time synchronization enabled
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268151
  # Ensures accurate timestamps for forensic analysis and event correlation
  services.timesyncd = {
    enable = true;

    # STIG V-268150: Clock synchronization poll interval
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268150
    # Sync when time difference exceeds one second
    extraConfig = ''
      PollIntervalMaxSec=60
    '';
  };

  # STIG V-268149: Authorized time servers (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268149
  # NOTE: DoD time servers not applicable - using system defaults
  # Risk accepted: System uses appropriate NTP servers for non-DoD infrastructure
  # networking.timeServers = [
  #   "tick.usnogps.navy.mil"
  #   "tock.usnogps.navy.mil"
  # ];

  services.printing.enable = true;

  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;

  programs.nix-ld.enable = true;

  # STIG V-268154: Verify digital signatures on patches/drivers/OS components
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268154
  # Prevents installation of tampered or malicious software
  nix.settings.require-sigs = true;

  # STIG V-268082: DOD banner for local logins/getty (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268082
  # NOTE: DOD banner not configured - not a U.S. Government system
  # Risk accepted: This is not a DOD/government system, displaying USG legal warnings would be inappropriate
  # DOD banners are specifically for U.S. Government Information Systems with legal monitoring requirements
  # services.getty.helpLine = "..."; # Commented out - not applicable

  # STIG V-268162: System security updates (INTENTIONALLY NOT AUTOMATED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268162
  # NOTE: Automatic updates not configured - system is updated manually on a weekly basis
  # Risk accepted: Manual updates provide better control and testing for flake-based configurations
  # Update procedure followed weekly:
  #   1. cd ~/nixos-config && nix flake update
  #   2. sudo nixos-rebuild switch --flake ~/nixos-config
  #   3. Reboot if kernel/critical updates
  # This approach ensures outdated packages are removed while maintaining system stability
  # Automatic updates could be enabled with system.autoUpgrade but are not recommended for flake configs
  # system.autoUpgrade.enable = false;

  # STIG V-268087: Session lock package for TTY consoles
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268087
  # vlock allows manual session lock for text console (TTY) sessions
  # Note: Graphical sessions use swaylock (configured in modules/home/wm/niri/)
  environment.systemPackages = with pkgs; [
    fwupd
    vlock # Session lock for TTY consoles
  ];
}
