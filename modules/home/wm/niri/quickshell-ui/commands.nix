{ config, ... }:
{
  # Custom system command entries for wofi
  xdg.desktopEntries = {
    "zellij" = {
      name = "Zellij";
      comment = "Terminal multiplexer";
      icon = "${config.home.homeDirectory}/.config/icons/zellij.png";
      exec = "alacritty -e zellij-start";
      terminal = false;
      categories = [
        "System"
        "TerminalEmulator"
      ];
    };

    "codenix" = {
      name = "CodeNix";
      comment = "Open NixOS configuration in VSCode";
      icon = "vscode";
      exec = "code ${config.home.homeDirectory}/nixos-config";
      terminal = false;
      categories = [ "Development" ];
    };

    "codedocs" = {
      name = "CodeDocs";
      comment = "Open documentation folder in VSCode";
      icon = "vscode";
      exec = "code ${config.home.homeDirectory}/docs";
      terminal = false;
      categories = [ "Development" ];
    };

    "claude-web" = {
      name = "Claude";
      comment = "Claude AI web interface";
      icon = "${config.home.homeDirectory}/.config/icons/claude.svg";
      exec = "chromium --app=https://claude.ai";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
    };

    "gmail" = {
      name = "Gmail";
      comment = "Gmail web client";
      icon = "${config.home.homeDirectory}/.config/icons/gmail.svg";
      exec = "chromium --app=https://mail.google.com";
      terminal = false;
      categories = [
        "Network"
        "Email"
      ];
    };

    "gchat" = {
      name = "Google Chat";
      comment = "Google Chat web client";
      icon = "${config.home.homeDirectory}/.config/icons/gchat.svg";
      exec = "chromium --app=https://chat.google.com";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
    };

    "outlook" = {
      name = "Outlook";
      comment = "Outlook web client";
      icon = "${config.home.homeDirectory}/.config/icons/outlook.svg";
      exec = "chromium --app=https://outlook.office.com";
      terminal = false;
      categories = [
        "Network"
        "Email"
      ];
    };
  };
}
