{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Habilitar niri como session
  programs.niri.enable = true;

  # Servicios esenciales para niri
  services = {
    # Display manager
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Session niri
    displayManager.sessionPackages = [ pkgs.niri ];

    # Deshabilitar agente SSH de GNOME para evitar conflicto
    gnome.gcr-ssh-agent.enable = lib.mkForce false;
  };

  # Portales XDG para Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Variables de entorno
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  # Paquetes del sistema necesarios
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
  ];

  # Políticas de seguridad
  security.polkit.enable = true;
}
