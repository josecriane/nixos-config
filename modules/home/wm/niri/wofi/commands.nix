{ config, ... }:
{
  # Custom system command entries for wofi
  xdg.desktopEntries = {
    "system-logout" = {
      name = "Logout";
      comment = "End current session";
      icon = "application-exit-symbolic";
      exec = "niri msg action quit --skip-confirmation";
      terminal = false;
      categories = [ "System" ];
    };

    "system-lock" = {
      name = "Lock Screen";
      comment = "Lock the screen";
      icon = "changes-prevent-symbolic";
      exec = "swaylock";
      terminal = false;
      categories = [ "System" ];
    };

    "system-reboot" = {
      name = "Reboot";
      comment = "Restart the computer";
      icon = "view-refresh-symbolic";
      exec = "systemctl reboot";
      terminal = false;
      categories = [ "System" ];
    };

    "system-shutdown" = {
      name = "Shutdown";
      comment = "Power off the computer";
      icon = "system-shutdown-symbolic";
      exec = "systemctl poweroff";
      terminal = false;
      categories = [ "System" ];
    };

    "system-suspend" = {
      name = "Suspend";
      comment = "Suspend the computer";
      icon = "media-playback-pause-symbolic";
      exec = "systemctl suspend";
      terminal = false;
      categories = [ "System" ];
    };

    "niri-reload" = {
      name = "Reload Niri";
      comment = "Reload niri configuration and restart services";
      icon = "view-refresh-symbolic";
      exec = "bash ${config.home.homeDirectory}/.config/niri/reload-niri";
      terminal = false;
      categories = [ "System" ];
    };

    "zellij" = {
      name = "Zellij";
      comment = "Terminal multiplexer";
      icon = "utilities-terminal";
      exec = "alacritty -e zellij attach -c default";
      terminal = false;
      categories = [ "System" "TerminalEmulator" ];
    };
  };
}
