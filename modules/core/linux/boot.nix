{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  boot = {
    bootspec.enable = true;

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # STIG Kernel Hardening
    kernel.sysctl = {
      # STIG V-268161: Address Space Layout Randomization (ASLR)
      # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268161
      # Randomizes memory addresses to prevent buffer overflow exploits
      "kernel.randomize_va_space" = 2;

      # STIG V-268160: Kernel pointer restriction
      # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268160
      # Prevents kernel pointer leakage to non-privileged users
      "kernel.kptr_restrict" = 1;

      # STIG V-268141: TCP syncookies for DoS protection
      # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268141
      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];
}
