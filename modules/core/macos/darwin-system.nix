{
  config,
  ...
}:
let
  username = config.machine.username;
in
{
  system = {
    primaryUser = "${username}";
    stateVersion = 5;
    activationScripts.activateSettings.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    activationScripts.setWallpaper.text = ''
      # Set wallpaper for all desktops
      wallpaper_path="$HOME/.config/wallpapers/default.png"
      if [ -f "$wallpaper_path" ]; then
        /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper_path\""
      fi
    '';

    defaults = {
      menuExtraClock.Show24Hour = false;

      dock = {
        autohide = true;
        show-recents = false;
        largesize = 44;
        magnification = true;
        orientation = "left";

        persistent-apps = [
          {
            app = "/Applications/Alacritty.app";
          }
          {
            app = "/Applications/Firefox.app";
          }
          {
            app = "/Applications/Microsoft Teams.app";
          }
        ];

        tilesize = 31;

        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleLanguages = [
            "en-US"
            "es-ES"
          ];
          AppleLocale = "en_US";
        };
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
