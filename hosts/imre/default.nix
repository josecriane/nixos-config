{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-custom.nix
    ./../../modules/core
  ];
}
