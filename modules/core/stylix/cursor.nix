{ pkgs, ... }:
{
  stylix = {
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 17;
    };
  };
}
