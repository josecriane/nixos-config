{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects; # Using swaylock-effects for better aesthetics

    settings = pkgs.lib.mkForce {
      # Colors using Stylix scheme
      color = "${colors.base00}00"; # Transparente
      bs-hl-color = "${colors.base08}ff"; # Rojo para backspace
      caps-lock-bs-hl-color = "${colors.base08}ff";
      caps-lock-key-hl-color = "${colors.base0A}ff"; # Amarillo para caps lock
      inside-color = "${colors.base00}33"; # Base con transparencia
      inside-clear-color = "${colors.base0B}00"; # Verde transparente
      inside-caps-lock-color = "${colors.base0A}00"; # Amarillo transparente
      inside-ver-color = "${colors.base0D}00"; # Azul transparente
      inside-wrong-color = "${colors.base08}00"; # Rojo transparente
      key-hl-color = "${colors.base0B}ff"; # Verde para tecla resaltada
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "${colors.base05}60";
      line-color = "00000000";
      line-clear-color = "${colors.base0B}ff"; # Verde
      line-caps-lock-color = "${colors.base0A}ff"; # Amarillo
      line-ver-color = "${colors.base0D}ff"; # Azul
      line-wrong-color = "${colors.base08}ff"; # Rojo
      ring-color = "${colors.base03}66"; # Gris con transparencia
      ring-clear-color = "${colors.base0B}40"; # Verde con transparencia
      ring-caps-lock-color = "${colors.base0A}40"; # Amarillo con transparencia
      ring-ver-color = "${colors.base0D}40"; # Azul con transparencia
      ring-wrong-color = "${colors.base08}40"; # Rojo con transparencia
      separator-color = "00000000";
      text-color = "${colors.base05}c8"; # Texto principal
      text-clear-color = "${colors.base05}60";
      text-caps-lock-color = "${colors.base0A}60";
      text-ver-color = "${colors.base0D}60";
      text-wrong-color = "${colors.base08}60";

      # Effects from swaylock-effects
      # screenshots = false;  # Comentado para usar imagen
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      # effect-blur = "7x5";  # Solo funciona con screenshots
      # effect-vignette = "0.5:0.5";  # Solo funciona con screenshots
      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;

      # Date and time format
      timestr = "%H:%M";
      datestr = "%A, %d %B";

      # Text strings
      text-clear = "Clear";
      text-caps-lock = "Caps Lock";
      text-ver = "Verifying";
      text-wrong = "Wrong";

      # Fade in
      fade-in = 0.2;

      # Ignore empty password
      ignore-empty-password = false;

      # Show failed attempts
      show-failed-attempts = true;

      # Hide keyboard layout
      hide-keyboard-layout = false;

      # Show indicator even if idle
      indicator-idle-visible = false;

      # Image (if you want to use a specific image instead of screenshot)
      image = "${config.home.homeDirectory}/docs/wallpapers/lock.jpeg";
    };
  };
}
