{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus # GNOME file manager
  ];

  home.file.".config/gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/Desktop
    file://${config.home.homeDirectory}/dev
    file://${config.home.homeDirectory}/docs
    file://${config.home.homeDirectory}/Downloads
    file://${config.home.homeDirectory}/nixos-config NixOS Config
    file://${config.home.homeDirectory}/scripts
    file://${config.home.homeDirectory}/tmp
  '';

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "grid-view";
      show-hidden-files = false;
      default-sort-order = "name";
      default-sort-in-reverse-order = false;
      always-use-location-entry = false;
      show-directory-item-counts = "on-this-computer";

      show-delete-permanently = true;
    };
  };
}
