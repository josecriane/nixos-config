{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = import ./vscode-extensions.nix { pkgs = pkgs; };
      userSettings = {
        "workbench.colorTheme" = "Atom One Dark";
        "security.workspace.trust.untrustedFiles" = "open";
        "explorer.confirmDelete" = false;
        "redhat.telemetry.enabled" = false;
        "editor.accessibilitySupport" = "off";
        "editor.fontSize" = 12;
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
      };
    };
  };
}
