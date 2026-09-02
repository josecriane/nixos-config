{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bcn3d-stratos
    freecad
  ];
}
