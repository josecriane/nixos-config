{ config, pkgs, ... }:
{
  environment.shellAliases = {
    nixrebuild = "sudo darwin-rebuild switch --flake ~/nixos-config";
    nixupdate = "sudo darwin-rebuild switch --upgrade";
  };
}