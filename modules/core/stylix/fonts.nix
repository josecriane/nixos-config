{
  pkgs,
  lib,
  config,
  ...
}:
{
  stylix.fonts = {
    # Monospace font (terminal, code editors)
    monospace = {
      package = pkgs.nerd-fonts.meslo-lg;
      name = "MesloLGS Nerd Font";
    };

    # Sans serif font (UI elements, applications)
    sansSerif = {
      package = pkgs.nerd-fonts.noto;
      name = "NotoSans Nerd Font";
    };

    # Emoji font
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    # Font sizes
    sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 11;
    };
  };
}
