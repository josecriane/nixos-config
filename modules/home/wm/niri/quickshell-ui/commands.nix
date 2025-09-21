{ config, ... }:
{
  # Custom system command entries for wofi
  xdg.desktopEntries = {
    "zellij" = {
      name = "Zellij";
      comment = "Terminal multiplexer";
      icon = "utilities-terminal";
      exec = "alacritty -e zellij attach -c default";
      terminal = false;
      categories = [
        "System"
        "TerminalEmulator"
      ];
    };
  };
}
