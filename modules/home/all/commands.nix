{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    imagemagick
    jq
    libqalculate
    nixfmt
    nixfmt-tree
    p7zip
    pandoc
    ripgrep
    yq
  ];
}
