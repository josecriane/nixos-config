{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "block";
      cursor-style-blink = true;
      window-decoration = true;
    };
  };

  stylix.targets.ghostty.enable = true;
}
