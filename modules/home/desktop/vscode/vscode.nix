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
        "workbench.colorCustomizations" = {
          "sideBar.background" = "#${colors.base00}";
        };

        "security.workspace.trust.untrustedFiles" = "open";
        "explorer.confirmDelete" = false;
        "redhat.telemetry.enabled" = false;
        "editor.accessibilitySupport" = "off";
        "explorer.confirmDragAndDrop" = false;
        "[xml]" = {
          "editor.defaultFormatter" = "DotJoshJohnson.xml";
        };
        "window.zoomLevel" = 0;
        "dart.debugExternalPackageLibraries" = true;
        "dart.debugSdkLibraries" = true;
        "explorer.confirmPasteNative" = false;

        "editor.detectIndentation" = true;
        "editor.guides.bracketPairs" = true;
        "editor.minimap.enabled" = true;

        "erlangFormatter.formatter" = "erlfmt";

        "extensions.ignoreRecommendations" = true;

        # Nix formatting
        "[nix]" = {
          "editor.defaultFormatter" = "bbenoist.nix";
          "editor.formatOnSave" = true;
        };
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "nixfmt";

        # Mostrar cambios de espacios en blanco en el diff
        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.renderSideBySide" = true;
        "editor.renderWhitespace" = "all";

        # Excluir directorios de búsqueda
        "search.exclude" = {
          "**/_build" = true;
          "**/.direnv" = true;
          "**/.git" = true;
          "**/node_modules" = true;
          "**/target" = true;
        };

        # Wayland configuration
        "window.titleBarStyle" = "custom";
        "window.commandCenter" = false;

        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
      };
    };
  };

  # Variables de entorno para VS Code en Wayland
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  stylix.targets.vscode.enable = true;
}
