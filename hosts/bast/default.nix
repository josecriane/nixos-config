{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-custom.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "25.11";
}
