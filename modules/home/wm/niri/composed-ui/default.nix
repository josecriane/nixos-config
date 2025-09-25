{
  config,
  lib,
  pkgs,
  machineOptions,
  self,
  ...
}:
{
  imports = [
    ./essential-gui.nix
    ./swaync
    ./waybar
    ./wofi
  ];

  xdg.configFile."niri/start-tray-apps" = {
    executable = true;
    source = ./utils/start-tray-apps.sh;
  };

  # Wofi utility scripts
  xdg.configFile."niri/toggle-wofi" = {
    executable = true;
    source = ./utils/toggle-wofi.sh;
  };
}
