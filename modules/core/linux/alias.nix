{ config, ... }:
let
  inherit (config.programs.nh) flake;
in
{
  environment.shellAliases = {
    nixrebuild = "nh os switch ${flake}";
    nixupdate = "nix flake update --flake ${flake} && nh os switch ${flake}";
    open = "xdg-open";
  };
}
