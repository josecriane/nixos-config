{ pkgs, ... }:
{
  stylix = {
    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita";
      light = "Adwaita";
    };
  };
}
