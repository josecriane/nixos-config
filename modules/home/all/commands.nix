{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    home-manager
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
