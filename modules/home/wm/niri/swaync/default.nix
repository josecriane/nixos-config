{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile."swaync/style.css".text = let
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
      base08 = "191, 97, 106";    # bf616a - rojo
      base0A = "235, 203, 139";   # ebcb8b - amarillo
      base0B = "163, 190, 140";   # a3be8c - verde
    };
  in builtins.replaceStrings 
    [
      "@base00@" "@base01@" "@base02@" "@base03@" 
      "@base04@" "@base05@" "@base06@" "@base08@" "@base0A@" "@base0B@"
      "@base00-rgba@" "@base01-rgba@" "@base02-rgba@" 
      "@base04-rgba@" "@base05-rgba@" "@base08-rgba@"
    ]
    [
      colors.base00 colors.base01 colors.base02 colors.base03
      colors.base04 colors.base05 colors.base06 colors.base08 colors.base0A colors.base0B
      rgba.base00 rgba.base01 rgba.base02
      rgba.base04 rgba.base05 rgba.base08
    ]
    (builtins.readFile ./style.css);
  
  xdg.configFile."swaync/config.json".source = ./config.json;
}
