{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = import ./vscode-extensions.nix { inherit pkgs; };
      userSettings = {
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
        "[xml]" = {
          "editor.defaultFormatter" = "DotJoshJohnson.xml";
        };

        "dart.debugExternalPackageLibraries" = true;
        "dart.debugSdkLibraries" = true;

        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.renderSideBySide" = true;
        "editor.accessibilitySupport" = "off";
        "editor.detectIndentation" = true;

        "editor.guides.bracketPairs" = true;

        "editor.minimap.enabled" = true;
        "editor.renderWhitespace" = "all";
        "elpClient.serverPath" = "${config.home.profileDirectory}/bin/elp";
        "erlangDap.erlangInstallationPath" = "${config.home.profileDirectory}/bin/";
        "erlangFormatter.formatter" = "erlfmt";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmPasteNative" = false;
        "extensions.ignoreRecommendations" = true;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.formatterPath" = "nixfmt";
        "qt-qml.qmlls.customExePath" = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
        "qt-qml.qmlls.enabled" = true;
        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
        "redhat.telemetry.enabled" = false;

        "search.exclude" = {
          "**/.direnv" = true;
          "**/.git" = true;
          "**/_build" = true;
          "**/node_modules" = true;
          "**/target" = true;
        };
        "security.workspace.trust.untrustedFiles" = "open";

        # Wayland configuration
        "window.commandCenter" = false;
        "window.titleBarStyle" = "custom";
        "window.zoomLevel" = 0;
        "workbench.colorCustomizations" = {
          "sideBar.background" = "#${colors.base00}";
        };
        "workbench.startupEditor" = "none";

        "workbench.editorAssociations" = {
          "*.qrc" = "qt-core.qrcEditor";
          "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.qrc" =
            "default";
        };
        "qt-qml.doNotAskForQmllsDownload" = true;
      };
    };
  };

  stylix.targets.vscode.enable = true;
}
