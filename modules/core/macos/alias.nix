{ config, pkgs, ... }:
{
  environment.shellAliases = {
    nixrebuild = "nix-mac.sh -bs";
    nixupdate = "nix flake update";
  };
}