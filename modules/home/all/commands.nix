{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    imagemagick
    jq
    libqalculate
    nixfmt
    nixfmt-tree
    p7zip
    pandoc
    yq
  ];
}
