{ pkgs, config, ... }:
let
  stylixCss = import ../niri-utils/stylix-css.nix { inherit config; };
in
{
  imports = [
    ./commands.nix
  ];

  programs.wofi = {
    enable = true;
    style = stylixCss.replaceStylixColors (builtins.readFile ./style.css);
    settings = {
      mode = "drun";
      height = 540;
      width = 960;
      allow_images = true;
      allow_markup = true;
      parse_search = true;
      no_actions = true;
      gtk_dark = true;
      insensitive = true;
    };
  };

  home.packages = with pkgs; [
    wofi-emoji
  ];

  stylix.targets.wofi.enable = true;
}
