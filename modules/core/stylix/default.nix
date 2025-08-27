{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./colors.nix
    ./cursor.nix
    ./iconTheme.nix
    ./fonts.nix
  ];

  stylix = {
    enable = true;

    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
