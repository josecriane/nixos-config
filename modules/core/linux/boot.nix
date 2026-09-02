{
  pkgs,
  lib,
  ...
}:
{
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    supportedFilesystems = [ "nfs" ];

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # STIG V-268168: NIST FIPS-validated cryptography (INTENTIONALLY NOT FOLLOWED)
    # NOTE: FIPS mode not enabled - not required for non-governmental systems
    # Risk accepted: System is not part of USG infrastructure or DoD contracts
    # FIPS mode would restrict cryptographic algorithms and impact compatibility
    # Current configuration already uses strong, validated cryptography (AES-256, SHA-512, etc.)
    # kernelParams = [ "fips=1" ];

    # STIG Kernel Hardening
    kernel.sysctl = {
      # STIG V-268161: Address Space Layout Randomization (ASLR)
      # Randomizes memory addresses to prevent buffer overflow exploits
      "kernel.randomize_va_space" = 2;

      # STIG V-268160: Kernel pointer restriction
      # Prevents kernel pointer leakage to non-privileged users
      "kernel.kptr_restrict" = 1;

      # STIG V-268141: TCP syncookies for DoS protection
      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];
}
