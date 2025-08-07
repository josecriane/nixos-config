{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    imagemagick
    jq
    nixfmt-rfc-style
    p7zip
    pandoc
    yq
    nixfmt-tree
  ];
}
