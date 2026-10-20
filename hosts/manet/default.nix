{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-custom.nix
  ];

  users.users.${config.machine.username}.extraGroups = [ "dialout" ];

  system.stateVersion = "26.11";
}
