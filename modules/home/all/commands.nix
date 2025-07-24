{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imagemagick
    jq
    p7zip
    pandoc
    yq
  ];
}
