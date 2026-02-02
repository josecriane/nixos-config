{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
      ];
    };
  };

  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "default" ];
  };
}
