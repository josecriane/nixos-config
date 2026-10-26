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

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    kernel.sysctl = {
      # STIG V-268161: Address Space Layout Randomization (ASLR)
      "kernel.randomize_va_space" = 2;

      # STIG V-268160: Kernel pointer restriction
      "kernel.kptr_restrict" = 1;

      # STIG V-268141: TCP syncookies for DoS protection
      "net.ipv4.tcp_syncookies" = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];
}
