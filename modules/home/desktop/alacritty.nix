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

      font = {
        size = 10;
      };

      general.import = [ "${pkgs.alacritty-theme}/alacritty_0_12.toml" ];
    };
  };
}