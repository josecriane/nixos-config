{
  config,
  lib,
  pkgs,
  inputs,
  machineOptions,
  ...
}:

let
  # QuickShell configuration parameters (reused 3 times)
  quickshellConfig = {
    commandsPath = ./commands.json;
    sessionCommandsPath = ./session-commands.json;
    interactiveCommandsPath = ./interactive-commands.json;
    excludedAppsPath = ./excluded-apps.json;
    stylix = config.lib.stylix.colors.withHashtag // {
      # Fonts from Stylix
      monoFont = config.stylix.fonts.monospace.name;
      sansFont = config.stylix.fonts.sansSerif.name;
    };
  };

  # Build the quickshell package with our configuration
  quickshellPackage =
    inputs.quickshell-config.packages.${pkgs.stdenv.hostPlatform.system}.withAllCommands
      quickshellConfig;

in
{
  imports = [
    ./commands.nix
  ];
  # Use the custom quickshell configuration package with both commands and Stylix colors
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshellPackage
  ];

  # Create symlink to quickshell configuration
  xdg.configFile."quickshell".source = "${quickshellPackage}/share/quickshell-config";

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
      exec ${quickshellPackage}/bin/quickshell-config
    '';
  };

  # Enable QML language server support
  home.sessionVariables = {
    QML2_IMPORT_PATH = "${inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default}/lib/qt-6/qml";
  };
}
