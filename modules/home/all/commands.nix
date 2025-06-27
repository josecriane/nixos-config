{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    pandoc
    imagemagick
  ];
}
