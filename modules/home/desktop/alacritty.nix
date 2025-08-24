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


      general.import = [ "${pkgs.alacritty-theme}/alacritty_0_12.toml" ];
    };
  };
}
