{
  config,
  lib,
  pkgs,
  machineOptions,
  ...
}:
let
  username = machineOptions.username;
in
{
  system.activationScripts.userPaths = {
    text = ''
      echo "=== Ejecutando Scripts para ${username} ==="
      if [ -x /home/${username}/nixos-config/setup/paths.sh ]; then
         ${pkgs.su}/bin/su - ${username} -c "${pkgs.bash}/bin/bash /home/${username}/nixos-config/setup/paths.sh"
      fi
      echo "=== Ejecución completada ==="
    '';
    deps = [ ];
  };
}
