{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imagemagick
    jq
    nixfmt-rfc-style
    p7zip
    pandoc
    yq
    nixfmt-tree
  ];
}
