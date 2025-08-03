{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file."docs/wallpapers" = {
    source = ../../../assets/wallpapers;
    recursive = true;
  };
}
