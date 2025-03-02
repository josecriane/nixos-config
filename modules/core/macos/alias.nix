{ config, pkgs, ... }:
{
  environment.shellAliases = {
    nixrebuild = "nix-mac.sh -bs";
    nixupdate = "sudo darwin-rebuild switch --upgrade";
  };
}