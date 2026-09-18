{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  quickshellConfig = {
    commandsPath = ./commands.json;
    sessionCommandsPath = ./session-commands.json;
    interactiveCommandsPath = ./interactive-commands.json;
    excludedAppsPath = ./excluded-apps.json;
    keepassPath = pkgs.writeText "keepass.json" (
      builtins.toJSON {
        encryptedPasswordPath = "${config.machine.homeDirectory}/nixos-config/secrets/kp.age";
        ageIdentityPath = "/etc/agenix/agenix-key.age";
        databasePath = "${config.home.homeDirectory}/keepass/passwords.kdbx";
      }
    );
    stylix = config.lib.stylix.colors.withHashtag // {
      monoFont = config.stylix.fonts.monospace.name;
      sansFont = config.stylix.fonts.sansSerif.name;
    };
  };

  quickshellPackage = inputs.quickshell-config.lib.${system}.mkQuickshellConfig quickshellConfig;

in
{
  imports = [
    ./commands.nix
  ];

  home.packages = [
    inputs.quickshell.packages.${system}.default
    quickshellPackage
    pkgs.cliphist
    pkgs.wl-clipboard
  ];

  # Not redundant with the wrapper's XDG_CONFIG_DIRS: instances are keyed by
  # the resolved shell.qml path, and the store one moves on every rebuild.
  xdg.configFile."quickshell/qsc".source = "${quickshellPackage}/etc/xdg/quickshell/qsc";

  systemd.user.services.quickshell = {
    Unit = {
      Description = "QuickShell desktop shell";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${quickshellPackage}/bin/quickshell-config";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history store";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Enable QML language server support
  home.sessionVariables = {
    QML2_IMPORT_PATH = "${inputs.quickshell.packages.${system}.default}/lib/qt-6/qml";
  };
}
