{
  pkgs,
  machineOptions,
  lib,
  ...
}:
{
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
