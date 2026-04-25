{ config, pkgs, ... }:
let
  nautilusExtensions = pkgs.symlinkJoin {
    name = "nautilus-extensions";
    paths = [ pkgs.nautilus-python ];
  };

  copyPathExtension = pkgs.writeText "copy_path.py" ''
    import subprocess
    from urllib.parse import unquote
    from gi.repository import Nautilus, GObject


    def _uri_to_path(uri):
        if uri.startswith("file://"):
            return unquote(uri[7:])
        return uri


    class CopyPathExtension(GObject.GObject, Nautilus.MenuProvider):
        def _menu_item(self, paths, source):
            item = Nautilus.MenuItem(
                name=f"CopyPathExtension::CopyPath::{source}",
                label="Copy path",
            )
            item.connect("activate", self._copy, paths)
            return [item]

        def get_file_items(self, *args):
            files = args[-1]
            if not files:
                return []
            paths = [_uri_to_path(f.get_uri()) for f in files]
            return self._menu_item(paths, "file")

        def get_background_items(self, *args):
            folder = args[-1]
            return self._menu_item([_uri_to_path(folder.get_uri())], "background")

        def _copy(self, _menu, paths):
            subprocess.run(
                ["${pkgs.wl-clipboard}/bin/wl-copy"],
                input="\n".join(paths).encode(),
                check=False,
            )
  '';
in
{
  home.packages = with pkgs; [
    nautilus # GNOME file manager
    nautilus-python
    wl-clipboard
  ];

  home.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${nautilusExtensions}/lib/nautilus/extensions-4";

  home.file.".config/environment.d/nautilus.conf".text = ''
    NAUTILUS_4_EXTENSION_DIR=${nautilusExtensions}/lib/nautilus/extensions-4
  '';

  home.file.".local/share/nautilus-python/extensions/copy_path.py".source = copyPathExtension;

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
