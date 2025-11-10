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
    };
  };

  imports = [ ] ++ (lib.optionals (machineOptions.wm != null)) [ ./wm ];

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
