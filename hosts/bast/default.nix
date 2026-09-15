{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-custom.nix
  ];

  system.stateVersion = "25.11";
}
