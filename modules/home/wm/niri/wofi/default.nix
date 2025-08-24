{ pkgs, config, ... }:
{
  imports = [
    ./commands.nix
  ];

  programs.wofi = {
    enable = true;
    style = let
      colors = config.lib.stylix.colors.withHashtag;
      # Valores RGB de los colores Nord para usar con rgba()
      rgba = {
        base00 = "46, 52, 64";      # 2e3440
        base01 = "59, 66, 82";      # 3b4252
        base02 = "67, 76, 94";      # 434c5e
        base03 = "76, 86, 106";     # 4c566a
        base04 = "216, 222, 233";   # d8dee9
        base05 = "229, 233, 240";   # e5e9f0
        base06 = "236, 239, 244";   # eceff4
      };
    in builtins.replaceStrings 
      [
        "@base00@" "@base01@" "@base02@" "@base03@" 
        "@base04@" "@base05@" "@base06@"
        "@base00-rgba@" "@base01-rgba@" "@base02-rgba@" 
        "@base03-rgba@" "@base05-rgba@" "@base06-rgba@"
      ]
      [
        colors.base00 colors.base01 colors.base02 colors.base03
        colors.base04 colors.base05 colors.base06
        rgba.base00 rgba.base01 rgba.base02
        rgba.base03 rgba.base05 rgba.base06
      ]
      (builtins.readFile ./style.css);
    settings = {
      mode = "drun";
      height = 540;
      width = 960;
      allow_images = true;
      allow_markup = true;
      parse_search = true;
      no_actions = true;
      gtk_dark = true;
      insensitive = true;
    };
  };

  home.packages = with pkgs; [
    wofi-emoji
  ];
}
