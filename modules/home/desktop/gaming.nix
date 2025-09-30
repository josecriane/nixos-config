{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # Steam and gaming essentials
    steam
    steam-run # Run non-Steam games in Steam runtime

    # Gaming utilities
    gamemode # Optimize system performance for games
    gamescope # Wayland game compositor

    # Compatibility layers
    protonup-qt # Manage Proton versions

    # Controller support
    jstest-gtk # Joystick testing
  ];

  # Enable gamemode for performance optimization
  systemd.user.services.gamemoded = {
    Unit.Description = "GameMode daemon";
    Service = {
      ExecStart = "${pkgs.gamemode}/bin/gamemoded";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Steam environment variables for better compatibility
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
  };

  # Create necessary directories
  home.file.".steam/root/compatibilitytools.d/.keep".text = "";
}
