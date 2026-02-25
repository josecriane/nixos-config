{ config, pkgs, ... }:
{
  environment.shellAliases = {
    nixrebuild = "sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK nixos-rebuild switch --flake ~/nixos-config";
    nixupdate = "sudo nixos-rebuild switch --upgrade";
    open = "xdg-open";
  };
}
