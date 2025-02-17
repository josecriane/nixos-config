{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "Full";
      };

      cursor = {
        unfocused_hollow = false;
        style = {
          blinking = "On";
          shape = "Block";
        };
      };

      general.import = [ "${pkgs.alacritty-theme}/alacritty_0_12.toml" ];
    };
  };
}