{
  config,
  lib,
  pkgs,
  machineOptions,
  ...
}:
let
  # Obtener la primera configuración de teclado o valores por defecto
  keyboard = lib.head (
    machineOptions.keyboards or [
      {
        layout = "us";
        variant = "intl";
      }
    ]
  );
in
{
  home.packages = with pkgs; [
    # Core de niri
    niri
    swaybg
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl
    pamixer
    libnotify
    xdg-utils
    wayland
    xwayland
    networkmanagerapplet

    # Herramientas gráficas Qt esenciales
    kdePackages.polkit-kde-agent-1 # Agente de autenticación
    kdePackages.plasma-nm # Gestor WiFi/Red
    kdePackages.bluedevil # Gestor Bluetooth
    kdePackages.plasma-pa # Control de audio
    kdePackages.kmix # Mezclador de audio KDE
    kdePackages.powerdevil # Gestor de energía y brillo
    kdePackages.kscreen # Gestor de pantallas
    wdisplays # Gestor de pantallas para Wayland
    kdePackages.dolphin # Gestor de archivos
    kdePackages.ark # Archivos comprimidos
    kdePackages.gwenview # Visor de imágenes
    kdePackages.okular # Visor de PDFs

    # Tema Breeze Dark
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.breeze-gtk

    # Compatibilidad Qt/Wayland
    kdePackages.qtwayland
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
  ];

  # Configuración principal de niri
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "${keyboard.layout}"
                ${lib.optionalString (
                  keyboard.variant != null && keyboard.variant != ""
                ) ''variant "${keyboard.variant}"''}
            }
            repeat-delay 200
            repeat-rate 80
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

    output "DP-1" {
        position x=0 y=0
    }

    output "eDP-1" {
        mode "2880x1800"
        scale 1.0
        position x=0 y=1080
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
    spawn-at-startup "/run/current-system/sw/libexec/polkit-kde-authentication-agent-1"
    spawn-at-startup "nm-applet --indicator"
    spawn-at-startup "bluedevil-applet"
    spawn-at-startup "kmix" "--keepvisibility"
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
        QT_STYLE_OVERRIDE "breeze"
        QT_QPA_PLATFORMTHEME "kde"
    }

    binds {
        Mod+Return { spawn "alacritty"; }
        Mod+Escape { spawn "sh" "-c" "~/.local/bin/wofi_csv power"; }
        Mod+Space { spawn "wofi"; }
        Mod+P { spawn "sh" "-c" "wofi-pass -s"; }
        Mod+E { spawn "wofi-emoji"; }
        Mod+Alt+L { spawn "swaylock"; }
        Mod+C { spawn "sh" "-c" "~/.local/bin/wofi_calc"; }
        
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Q { close-window; }
        Mod+Ctrl+Q { quit skip-confirmation=true; }
        Mod+Ctrl+R { spawn "sh" "-c" "systemctl --user restart niri"; }
        
        Mod+Shift+C { screenshot; }
        Mod+Alt+C { screenshot-screen; }
        Mod+Ctrl+C { screenshot-window; }
        
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }
        
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }
        
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }
        
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }
        
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        
        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }
        
        Mod+Ctrl+H { focus-workspace-down; }
        Mod+Ctrl+L { focus-workspace-up; }
        Mod+Ctrl+Left { focus-workspace-down; }
        Mod+Ctrl+Right { focus-workspace-up; }
        
        Mod+Ctrl+K { focus-monitor-left; }
        Mod+Ctrl+J { focus-monitor-right; }
        Mod+Ctrl+Up { focus-monitor-left; }
        Mod+Ctrl+Down { focus-monitor-right; }
        
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        
        Mod+Alt+K { set-window-height "-10%"; }
        Mod+Alt+J { set-window-height "+10%"; }
        Mod+Alt+Left { set-window-height "-10%"; }
        Mod+Alt+Right { set-window-height "+10%"; }
        
        Mod+W { switch-layout "next"; }
        Mod+Shift+W { switch-layout "prev"; }
        
        XF86AudioMute { spawn "pamixer" "-t"; }
        XF86AudioRaiseVolume { spawn "pamixer" "-i" "5"; }
        XF86AudioLowerVolume { spawn "pamixer" "-d" "5"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "+10%"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "play-pause"; }
    }
  '';

  # Configuración del tema Qt
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze;
    };
  };

  # Configuración GTK para coherencia
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
  };

  # Scripts auxiliares
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
}
