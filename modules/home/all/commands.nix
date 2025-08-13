{ pkgs, ... }:
{
  home.packages = with pkgs; [
    home-manager
    imagemagick
    jq
    nixfmt-rfc-style
    nixfmt-tree
    p7zip
    pandoc
    yq
  ];
}
