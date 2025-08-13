{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mode = "drun";
      height = 540;
      width = 960;
      allow_images = true;
      allow_markup = true;
      parse_search = true;
      no_actions = true;
    };
  };

  home.packages = with pkgs; [
    wofi-emoji
    wofi-pass
  ];
}
