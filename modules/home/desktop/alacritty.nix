{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "Full";
      };

      cursor = {
        style = {
          blinking = "On";
          shape = "Block";
        };
      };
    };
  };

  stylix.targets.alacritty.enable = true;
}
