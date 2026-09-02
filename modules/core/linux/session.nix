{ lib, machineOptions, ... }:
{
  imports = [ ] ++ (lib.optionals (machineOptions.wm != null) [ ./wm ]);

  services = {
    xserver.enable = false;

    libinput.enable = true;

    # STIG V-268172: Prevent unattended/automatic console login
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268172
    # Automatic login bypasses authentication controls
    # No autoLogin configured - verified compliant (autoLogin.enable defaults to false)

    # STIG V-268084: DOD banner for graphical logins (INTENTIONALLY NOT FOLLOWED)
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268084
    # NOTE: DOD banner not configured - not a U.S. Government system
    # Risk accepted: This is not a DOD/government system, displaying USG legal warnings would be inappropriate
    # DOD banners are specifically for U.S. Government Information Systems with legal monitoring requirements
    # displayManager.gdm.banner = "..."; # Commented out - not applicable
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
