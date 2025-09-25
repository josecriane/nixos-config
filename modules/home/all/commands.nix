{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    imagemagick
    jq
    libqalculate
    nixfmt-rfc-style
    nixfmt-tree
    p7zip
    pandoc
    yq
  ];
}
