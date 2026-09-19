{
  config,
  pkgs,
  ...
}:
{
  services = {
    # STIG V-268086: Session lock after 10 minutes of inactivity
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
