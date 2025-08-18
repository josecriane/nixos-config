{ config, pkgs, ... }:
{
  environment.shellAliases = {
    nixrebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    nixupdate = "sudo nixos-rebuild switch --upgrade";
    open = "xdg-open";
  };
}
