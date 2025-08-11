{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.activation = {
    userPaths = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "=== Ejecutando Scripts para $USER ==="
      if [ -x $HOME/nixos-config/setup/paths.sh ]; then
         ${pkgs.bash}/bin/bash $HOME/nixos-config/setup/paths.sh
      fi
      echo "=== Ejecución completada ==="
    '';
  };

  home.file."docs/wallpapers" = {
    source = ../../../assets/wallpapers;
    recursive = true;
  };

  home.file."scripts" = {
    source = ../../../assets/scripts;
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/scripts"
  ];
}