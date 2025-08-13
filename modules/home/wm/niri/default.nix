{ inputs, pkgs, config, lib, machineOptions, ... }:
let
  # Get all keyboard configurations
  keyboards = machineOptions.keyboards or [
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
    ./services.nix
    ./essential-gui.nix
    ./themes.nix
    ./waybar
    ./wofi
    ./swaync
  ];

  home.packages = with pkgs; [
    niri
    swaybg
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    wayland
    xwayland
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
        
        focus-follows-mouse
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
        xcursor-theme "breeze_cursors"
        xcursor-size 24
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
    spawn-at-startup "nm-applet --indicator"
    spawn-at-startup "bluetooth-applet"
    spawn-at-startup "pasystray"
    spawn-at-startup "swaybg" "-i" "${config.home.homeDirectory}/docs/wallpapers/circle-gruvbox-inspired.webp" "-m" "fill"

    environment {
        QT_QPA_PLATFORM "wayland"
        NIXOS_OZONE_WL "1"
        MOZ_ENABLE_WAYLAND "1"
        SDL_VIDEODRIVER "wayland"
        _JAVA_AWT_WM_NONREPARENTING "1"
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        QT_STYLE_OVERRIDE "adwaita-dark"
        QT_QPA_PLATFORMTHEME "gtk3"
    }

    binds {
        ${builtins.readFile ./keybinds.kdl}
    }
  '';

  # Helper scripts
  xdg.configFile."niri/monitor-setup" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      sleep 1

      if niri msg outputs | grep -q "DP-1"; then
          niri msg action focus-monitor-left
      fi
    '';
  };

  # Script to switch keyboard layout
  xdg.configFile."niri/switch-layout" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
  
      current_layout_info=$(niri msg keyboard-layouts)

      niri msg action switch-layout next
      
      sleep 0.1
      
      new_layout_info=$(niri msg keyboard-layouts)
      if echo "$new_layout_info" | grep -q "^\s*\*.*Spanish"; then
          new_layout="Español"
      else
          new_layout="English (US)"
      fi
      
      if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
          ${pkgs.libnotify}/bin/notify-send "Keyboard Layout" "Switched to $new_layout" -t 1500 2>/dev/null || true
      fi
    '';
  };
}
