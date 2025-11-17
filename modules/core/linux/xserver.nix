{
  pkgs,
  lib,
  machineOptions,
  ...
}:
let
  keyboards =
    machineOptions.keyboards or [
      {
        layout = "us";
        variant = "intl";
      }
    ];
  layouts = lib.concatMapStringsSep "," (kb: kb.layout) keyboards;
  variants = lib.concatMapStringsSep "," (kb: kb.variant or "") keyboards;
in
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = layouts;
        variant = variants;
        model = "pc105";
      };

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
  };

  imports = [ ] ++ (lib.optionals (machineOptions.wm != null)) [ ./wm ];

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
