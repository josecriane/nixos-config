{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  boot.initrd.kernelModules = [
    "amdgpu"
    "kvm-amd"
    "tpm_crb"
  ];

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
    kdePackages.bluez-qt
    pkgs.openobex
    pkgs.obexftp
  ];
}
