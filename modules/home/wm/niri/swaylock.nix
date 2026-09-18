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
      color = "${colors.base00}00";
      bs-hl-color = "${colors.base08}ff";
      caps-lock-bs-hl-color = "${colors.base08}ff";
      caps-lock-key-hl-color = "${colors.base0A}ff";
      inside-color = "${colors.base00}33";
      inside-clear-color = "${colors.base0B}00";
      inside-caps-lock-color = "${colors.base0A}00";
      inside-ver-color = "${colors.base0D}00";
      inside-wrong-color = "${colors.base08}00";
      key-hl-color = "${colors.base0B}ff";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "${colors.base05}60";
      line-color = "00000000";
      line-clear-color = "${colors.base0B}ff";
      line-caps-lock-color = "${colors.base0A}ff";
      line-ver-color = "${colors.base0D}ff";
      line-wrong-color = "${colors.base08}ff";
      ring-color = "${colors.base03}66";
      ring-clear-color = "${colors.base0B}40";
      ring-caps-lock-color = "${colors.base0A}40";
      ring-ver-color = "${colors.base0D}40";
      ring-wrong-color = "${colors.base08}40";
      separator-color = "00000000";
      text-color = "${colors.base05}c8";
      text-clear-color = "${colors.base05}60";
      text-caps-lock-color = "${colors.base0A}60";
      text-ver-color = "${colors.base0D}60";
      text-wrong-color = "${colors.base08}60";

      # Effects from swaylock-effects
      # screenshots = false;  # Commented out so the image below is used instead
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      # effect-blur = "7x5";  # Only works with screenshots enabled
      # effect-vignette = "0.5:0.5";  # Only works with screenshots enabled
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
      image = "${config.home.homeDirectory}/.config/wallpapers/lock.jpeg";
    };
  };
}
