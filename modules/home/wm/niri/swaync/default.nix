{ pkgs, config, ... }:
let
  stylixCss = import ../niri-utils/stylix-css.nix { inherit config; };
in
{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile."swaync/style.css".text = stylixCss.replaceStylixColors (
    builtins.readFile ./style.css
  );

  xdg.configFile."swaync/config.json".source = ./config.json;
}
