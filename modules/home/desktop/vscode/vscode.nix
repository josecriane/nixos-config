{ config, pkgs, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = import ./vscode-extensions.nix { pkgs = pkgs; };
      userSettings = {
        "[nix]" = {
          "editor.defaultFormatter" = "bbenoist.nix";
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
        "elpClient.serverPath" = "/etc/profiles/per-user/sito/bin/elp";
        "erlangDap.erlangInstallationPath" = "/etc/profiles/per-user/sito/bin/";
        "erlangFormatter.formatter" = "erlfmt";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmPasteNative" = false;
        "extensions.ignoreRecommendations" = true;

        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "nixfmt";
        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
        "redhat.telemetry.enabled" = false;

        # Excluir directorios de búsqueda
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
        "qt-qml.doNotAskForQmllsDownload" = true;
      };
    };
  };

  # Variables de entorno para VS Code en Wayland
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  stylix.targets.vscode.enable = true;
}
