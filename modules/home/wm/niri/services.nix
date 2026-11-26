{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 900;
          command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
          resumeCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
        }
      ];
      events = {
        before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
      };
    };
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.home.homeDirectory}/.config/wallpapers/default.jpeg -m fill";
      Restart = "always";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Polkit authentication agent
  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "Polkit GNOME Authentication Agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
