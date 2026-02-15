{
  config,
  lib,
  pkgs,
  machineOptions,
  ...
}:

{
  home.activation = {
    userPaths = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "=== Ejecutando Scripts para $USER ==="
      if [ -x $HOME/nixos-config/build-utils/paths.sh ]; then
         ${pkgs.bash}/bin/bash $HOME/nixos-config/build-utils/paths.sh
      fi
      echo "=== Ejecución completada ==="
    '';
  }
  // lib.optionalAttrs (machineOptions.os == "macos") {
    macScripts = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      echo "=== Copiando scripts de macOS ==="
      if [ -d $HOME/nixos-config/assets/scripts-mac ]; then
        for script in $HOME/nixos-config/assets/scripts-mac/*; do
          if [ -f "$script" ]; then
            script_name=$(basename "$script")
            target_path="$HOME/scripts/$script_name"
            
            # Remove existing file/symlink if it exists
            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
              rm -f "$target_path"
              echo "Eliminado existente: $script_name"
            fi
            
            cp -f "$script" "$target_path"
            chmod +x "$target_path"
            echo "Copiado: $script_name"
          fi
        done
      fi
      echo "=== Scripts de macOS copiados ==="
    '';
  };

  home.file.".config/wallpapers" = {
    source = ../../../assets/wallpapers;
    recursive = true;
  };

  home.file.".config/icons" = {
    source = ../../../assets/icons;
    recursive = true;
  };

  home.file."scripts" = {
    source = ../../../assets/scripts;
    recursive = true;
  };

  # VM directory for VirtualBox
  home.file."docs/vm/.keep".text = "";

  home.sessionPath = [
    "$HOME/scripts"
  ];
}
