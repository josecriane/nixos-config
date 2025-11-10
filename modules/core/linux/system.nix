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
  services.timesyncd.enable = true;

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
