{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = ''
      window#waybar {
          border:        2px solid #efefef;
          border-radius: 12px;
          font-family:   "NotoSans Nerd Font";
          font-size:     18px;
          box-shadow:    none;
          text-shadow:   none;
          transition-duration: 0s;
          color:      rgba(216, 216, 216, 1);
          background: rgba(0, 0, 0, 0.67);
      }

      window#waybar.solo {
          background: rgba(35, 31, 32, 0.67);
          border-radius: 12px;
      }

      #workspaces {
          margin: 0 5px;
          padding: 0 5px;
      }

      #workspaces button {
          padding:    0 5px;
          color:      rgba(216, 216, 216, 0.4);
      }

      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          padding: 5px 5px;
          margin: 5px 5px;
      }

      #workspaces button.active {
          padding:    0 5px;
          color:      rgba(216, 216, 216, 0.8);
      }

      #workspaces button.visible {
          color:      rgba(216, 216, 216, 1);
      }

      #workspaces button.urgent {
          color:      rgba(238, 46, 36, 1);
      }

      #tray,
      #clock,
      #mode,
      #battery,
      #temperature,
      #cpu,
      #memory,
      #idle_inhibitor,
      #backlight,
      #custom-notification,
      #disk {
          margin:     0px 8px 0px 8px;
          padding: 0 4px;
      }

      #battery.warning {
         color:       rgba(255, 210, 4, 1);
      }

      #battery.critical {
          color:      rgba(238, 46, 36, 1);
      }

      #battery.charging {
          color:      rgba(216, 216, 216, 1);
      }
    '';

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
            "(.*) — Mozilla Firefox" = " $1";
            "(.*) - Google Chrome" = " $1";
            "(.*) - Visual Studio Code" = "󰨞 $1";
            "Alacritty" = " Terminal";
            "neovide" = " Neovide";
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
            activated = "";
            deactivated = "";
          };
          tooltip = false;
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
          on-click = "niri msg action spawn -- alacritty --class floating -e btop";
        };

        memory = {
          format = "{}% ";
          on-click = "niri msg action spawn -- alacritty --class floating -e btop";
        };

        disk = {
          format = "{}% ";
          on-click = "niri msg action spawn -- alacritty --class floating --hold -e dust ~/";
        };

        battery = {
          format = "{icon} {capacity}% - {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = " {icon} {capacity}% - {time}";
          format-full = " {icon} {capacity}% - Charged";
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
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      }
    ];
  };
}
