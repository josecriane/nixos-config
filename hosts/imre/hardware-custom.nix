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
}
