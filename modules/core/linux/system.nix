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

  # STIG V-268154: Verify digital signatures on patches/drivers/OS components
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268154
  # Prevents installation of tampered or malicious software
  nix.settings.require-sigs = true;

  environment.systemPackages = with pkgs; [
    fwupd
  ];
}
