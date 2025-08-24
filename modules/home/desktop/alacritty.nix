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

      font = pkgs.lib.mkForce {
        size = 10;
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS NF";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS NF";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS NF";
          style = "Bold Italic";
        };
      };

      general.import = [ "${pkgs.alacritty-theme}/alacritty_0_12.toml" ];
    };
  };
}
