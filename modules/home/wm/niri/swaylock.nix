{ pkgs, config, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects; # Using swaylock-effects for better aesthetics

    settings = pkgs.lib.mkForce {
      # Colors
      color = "00000000";
      bs-hl-color = "ee2e24ff";
      caps-lock-bs-hl-color = "ee2e24ff";
      caps-lock-key-hl-color = "ffd204ff";
      inside-color = "00000033";
      inside-clear-color = "ffffff00";
      inside-caps-lock-color = "ffffff00";
      inside-ver-color = "ffffff00";
      inside-wrong-color = "ffffff00";
      key-hl-color = "00ff00ff";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "ffffff60";
      line-color = "00000000";
      line-clear-color = "ffffffFF";
      line-caps-lock-color = "ffffffFF";
      line-ver-color = "ffffffFF";
      line-wrong-color = "ffffffFF";
      ring-color = "64727d66";
      ring-clear-color = "ffffff40";
      ring-caps-lock-color = "ffffff40";
      ring-ver-color = "ffffff40";
      ring-wrong-color = "ffffff40";
      separator-color = "00000000";
      text-color = "ffffffc8";
      text-clear-color = "ffffff60";
      text-caps-lock-color = "ffffff60";
      text-ver-color = "ffffff60";
      text-wrong-color = "ffffff60";

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
