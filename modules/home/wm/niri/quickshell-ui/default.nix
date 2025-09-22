{
  config,
  lib,
  pkgs,
  inputs,
  machineOptions,
  ...
}:
{
  imports = [
    ./commands.nix
  ];
  # Use the custom quickshell configuration package with both commands
  home.packages = [ 
    inputs.quickshell.packages.${pkgs.system}.default
    (inputs.quickshell-config.packages.${pkgs.system}.withAllCommands {
      commandsPath = ./commands.json;
      sessionCommandsPath = ./session-commands.json;
    })
  ];

  # Create symlink to quickshell configuration (now includes both commands files)
  xdg.configFile."quickshell".source = "${inputs.quickshell-config.packages.${pkgs.system}.withAllCommands {
    commandsPath = ./commands.json;
    sessionCommandsPath = ./session-commands.json;
  }}/share/quickshell-config";

  # Put the start script in a different location to avoid conflicts
  xdg.configFile."niri/start-quickshell" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Kill existing quickshell processes
      pgrep -f "/bin/quickshell" | xargs -r kill 2>/dev/null || true

      # Wait a moment for process to terminate
      sleep 0.5

      # Start quickshell with custom config
      exec ${inputs.quickshell-config.packages.${pkgs.system}.withAllCommands {
        commandsPath = ./commands.json;
        sessionCommandsPath = ./session-commands.json;
      }}/bin/quickshell-config
    '';
  };

  # Enable QML language server support
  home.sessionVariables = {
    QML2_IMPORT_PATH = "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml";
  };
}
