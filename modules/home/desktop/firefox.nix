{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
  };

  stylix.targets.firefox = {
    enable = true;
    profileNames =  ["default"];
  };
}
