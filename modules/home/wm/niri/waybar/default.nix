{ pkgs, config, ... }:
{
  programs.waybar = {
    enable = true;
    style =
      let
        colors = config.lib.stylix.colors.withHashtag;
        # Valores RGB de los colores Nord para usar con rgba()
        rgba = {
          base00 = "46, 52, 64"; # 2e3440
          base01 = "59, 66, 82"; # 3b4252
          base02 = "67, 76, 94"; # 434c5e
          base03 = "76, 86, 106"; # 4c566a
          base04 = "216, 222, 233"; # d8dee9
          base05 = "229, 233, 240"; # e5e9f0
          base06 = "236, 239, 244"; # eceff4
          base07 = "143, 188, 187"; # 8fbcbb
          base08 = "191, 97, 106"; # bf616a
          base09 = "208, 135, 112"; # d08770
          base0A = "235, 203, 139"; # ebcb8b
          base0B = "163, 190, 140"; # a3be8c
          base0C = "136, 192, 208"; # 88c0d0
          base0D = "129, 161, 193"; # 81a1c1
          base0E = "180, 142, 173"; # b48ead
          base0F = "94, 129, 172"; # 5e81ac
        };
      in
      builtins.replaceStrings
        [
          "@base00@"
          "@base01@"
          "@base02@"
          "@base03@"
          "@base04@"
          "@base05@"
          "@base06@"
          "@base07@"
          "@base08@"
          "@base09@"
          "@base0A@"
          "@base0B@"
          "@base0C@"
          "@base0D@"
          "@base0E@"
          "@base0F@"
          "@base00-rgba@"
          "@base01-rgba@"
          "@base04-rgba@"
          "@base05-rgba@"
        ]
        [
          colors.base00
          colors.base01
          colors.base02
          colors.base03
          colors.base04
          colors.base05
          colors.base06
          colors.base07
          colors.base08
          colors.base09
          colors.base0A
          colors.base0B
          colors.base0C
          colors.base0D
          colors.base0E
          colors.base0F
          rgba.base00
          rgba.base01
          rgba.base04
          rgba.base05
        ]
        (builtins.readFile ./style.css);

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
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = " {icon} {capacity}% - {time}";
          format-full = " {icon} {capacity}% - Charged";
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
          format-icons = [
            "󱠂"
            "󱠃"
          ];
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
            phone = [
              " "
              " "
              " "
              " "
            ];
            default = [
              ""
              ""
              ""
              ""
            ];
          };
          scroll-step = 2;
          on-click = "pavucontrol";
          tooltip = false;
        };
      }
    ];
  };
}
