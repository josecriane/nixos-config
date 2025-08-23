{
  inputs,
  pkgs,
  config,
  lib,
  machineOptions,
  ...
}:
let
  # Get all keyboard configurations
  keyboards =
    machineOptions.keyboards or [
      {
        layout = "us";
        variant = "intl";
      }
    ];
  layouts = lib.concatStringsSep "," (map (k: k.layout) keyboards);
  variants = lib.concatStringsSep "," (map (k: k.variant or "") keyboards);
in
{
  imports = [
    ./automount.nix
    ./services.nix
    ./essential-gui.nix
    ./themes.nix
    ./waybar
    ./wofi
    ./swaync
    ./swaylock.nix
  ];

  home.packages = with pkgs; [
    niri
    swaybg
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
  ];

  # Niri main configuration
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "${layouts}"
                ${lib.optionalString (variants != "") ''variant "${variants}"''}
                options "grp:alt_shift_toggle"
            }
            repeat-delay 200
            repeat-rate 40
        }
        
        mouse {
            natural-scroll
            accel-speed 0.0
        }
        
        touchpad {
            tap
            dwt
            natural-scroll
            scroll-method "two-finger"
            click-method "clickfinger"
        }
        
        focus-follows-mouse max-scroll-amount="0%"
    }

    output "DP-2" {
        position x=0 y=0
    }

    output "DP-3" {
        position x=0 y=0
    }

    output "eDP-1" {
        mode "2880x1800"
        scale 1.3
        position x=160 y=1440
    }

    layout {
        gaps 14
        
        border {
            width 2
            active-color "#efefef"
            inactive-color "#8F8F8F"
        }
        
        preset-column-widths {
            proportion 0.3333
            proportion 0.5
            proportion 0.6667
            proportion 1.0
        }
        
        default-column-width { proportion 0.5; }
        
        center-focused-column "never"
    }

    cursor {
        xcursor-theme "Adwaita"
        xcursor-size 18
    }

    gestures {
        hot-corners {
            off
        }
    }

    prefer-no-csd

    screenshot-path "~/Pictures/scrn-%Y%m%d%H%M%S.png"

    animations {
        slowdown 1.0
        
        window-open {
            curve "ease-out-quad"
            duration-ms 150
        }
        
        window-close {
            curve "ease-out-quad"
            duration-ms 150
        }
        
        workspace-switch {
            curve "ease-out-cubic"
            duration-ms 150
        }
    }

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id="^floating$"
        default-column-width { fixed 1680; }
        open-maximized false
        open-fullscreen false
        geometry-corner-radius 12
        clip-to-geometry true
    }

    spawn-at-startup "systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
    spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
    spawn-at-startup "waybar"
    spawn-at-startup "swaync"
    spawn-at-startup "sh" "-c" "~/.config/niri/monitor-setup"
    spawn-at-startup "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "sh" "-c" "~/.config/niri/start-tray-apps"
    spawn-at-startup "swaybg" "-i" "${config.home.homeDirectory}/docs/wallpapers/default.png" "-m" "fill"

    environment {
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        QT_STYLE_OVERRIDE "adwaita-dark"
        QT_QPA_PLATFORMTHEME "gtk3"
    }

    binds {
        ${builtins.readFile ./keybinds.kdl}
    }
  '';

  # Helper scripts - link to separate files
  xdg.configFile."niri/monitor-setup" = {
    executable = true;
    source = ./niri-utils/monitor-setup.sh;
  };

  xdg.configFile."niri/switch-layout" = {
    executable = true;
    source = pkgs.replaceVars ./niri-utils/switch-layout.sh {
      libnotify = "${pkgs.libnotify}/bin/notify-send";
    };
  };

  xdg.configFile."niri/start-tray-apps" = {
    executable = true;
    source = ./niri-utils/start-tray-apps.sh;
  };

  xdg.configFile."niri/reload-niri" = {
    executable = true;
    source = ./niri-utils/reload-niri.sh;
  };

  xdg.configFile."niri/toggle-wofi" = {
    executable = true;
    source = ./niri-utils/toggle-wofi.sh;
  };
}
