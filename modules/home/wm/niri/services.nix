{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Servicios esenciales para niri
  services = {
    # Control de inactividad
    # STIG V-268086: Session lock after 10 minutes of inactivity
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268086
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600; # 10 minutes - STIG requirement (was 5 minutes)
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
        }
        {
          timeout = 900; # 15 minutes - suspend after lock
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
      };
    };
  };

  # Systemd user services
  systemd.user.targets.niri-session = {
    Unit = {
      Description = "niri compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
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
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
