{
  pkgs,
  machineOptions,
  lib,
  ...
}:
{
  # STIG V-268173: AppArmor must be enabled
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268173
  # Provides mandatory access control framework that restricts application permissions at kernel level
  security.apparmor.enable = true;

  # STIG V-268080: Enable audit daemon
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268080
  # Tracks account creation and system changes for security monitoring and forensics
  security.auditd.enable = true;
  security.audit.enable = true;

  # STIG V-268138: Prevent direct root login
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268138
  # Forces individual authentication before accessing privileged accounts
  # Ensures accountability and traceability of administrative actions
  # TODO: Implement this properly with SSH keys or hashed passwords configured declaratively
  # users.mutableUsers = false;

  security.rtkit.enable = true;

  # Habilitar fprintd para autenticación por huella dactilar
  services.fprintd = {
    enable = machineOptions.fprint or false;
  };

  # Habilitar autenticación por huella para GDM y swaylock si fprint está habilitado
  security.pam.services.gdm.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.gdm-password.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.swaylock.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.sudo.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
}
