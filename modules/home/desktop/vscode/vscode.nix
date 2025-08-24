{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = import ./vscode-extensions.nix { pkgs = pkgs; };
      userSettings = {
        # "workbench.colorTheme" = pkgs.lib.mkForce "Atom One Dark";
        "security.workspace.trust.untrustedFiles" = "open";
        "explorer.confirmDelete" = false;
        "redhat.telemetry.enabled" = false;
        "editor.accessibilitySupport" = "off";
        # "editor.fontSize" = pkgs.lib.mkForce 12;
        # "editor.fontFamily" = pkgs.lib.mkForce "'JetBrainsMono Nerd Font', 'MesloLGS NF', 'monospace'";
        # "terminal.integrated.fontFamily" = pkgs.lib.mkForce "'JetBrainsMono Nerd Font', 'MesloLGS NF', 'monospace'";
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
      };
    };
  };

  # Variables de entorno para VS Code en Wayland
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };
}
