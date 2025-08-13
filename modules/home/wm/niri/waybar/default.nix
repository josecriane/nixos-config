{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 50;
        margin-top = 12;
        margin-left = 16;
        margin-bottom = 0;
        margin-right = 16;
        modules-left = [
          "niri/workspaces"
          "niri/mode"
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "idle_inhibitor"
          "cpu"
          "memory"
          "disk"
          "battery"
          "clock"
          "custom/notification"
        ];

        "niri/workspaces" = {
          format = "{index}";
          disable-scroll = false;
          all-outputs = false;
        };

        "niri/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
          rewrite = {
            "(.*) — Mozilla Firefox" = " $1";
            "(.*) - Google Chrome" = " $1";
            "(.*) - Visual Studio Code" = "󰨞 $1";
            "alacritty" = " Terminal";
          };
        };

        tray = {
          icon-size = 18;
          spacing = 18;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-alt = "{icon} idle {status}";
          format-alt-click = "click-right";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = false;
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
          on-click = "niri msg action spawn -- alacritty --class floating -e btop";
        };
        
        memory = {
          format = "{}% ";
          on-click = "niri msg action spawn -- alacritty --class floating -e btop";
        };
        
        disk = {
          format = "{}% ";
          on-click = "niri msg action spawn -- alacritty --class floating --hold -e dust ~/";
        };

        battery = {
          format = "{icon} {capacity}% - {time}";
          format-icons = ["" "" "" "" ""];
          format-charging = " {icon} {capacity}% - {time}";
          format-full =  " {icon} {capacity}% - Charged";
          interval = 30;
          states = {
            warning = 25;
            critical = 10;
          };
          tooltip = false;
          on-click = "gnome-power-statistics";
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip = false;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon} ";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        backlight = {
          format = "{icon}";
          format-alt = "{percent}% {icon}";
          format-alt-click = "click-right";
          format-icons = ["󱠂" "󱠃"];
          on-scroll-down = "light -A 1";
          on-scroll-up = "light -U 1";
        };
        
        temperature = {
          format = "  {temperatureC:3}°C";
          hwmon-path = "/sys/class/thermal/thermal_zone10/temp";
          on-click = "psensor";
        };

        pulseaudio = {
          format = "{icon:2} {volume:2}%";
          format-alt = "{icon:2} {volume:2}%";
          format-alt-click = "click-right";
          format-muted = "";
          format-icons = {
            phone = [" " " " " " " "];
            default = ["" "" "" ""];
          };
          scroll-step = 2;
          on-click = "pavucontrol";
          tooltip = false;
        };
      }
    ];
  };
}
