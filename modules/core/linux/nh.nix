{ config, ... }:
{
  programs.nh = {
    enable = true;
    flake = "${config.machine.homeDirectory}/nixos-config";
  };
}
