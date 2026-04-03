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

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    # Remove deprecated Electron flags
    ELECTRON_OZONE_PLATFORM_HINT = "";
  };

  # Paquetes del sistema necesarios
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    xwayland-satellite
  ];

  # Políticas de seguridad
  security.polkit.enable = true;

  # Polkit policy para tailscale (pkexec desde quickshell)
  environment.etc."polkit-1/actions/org.tailscale.cli.policy".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE policyconfig PUBLIC
     "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
    <policyconfig>
      <action id="org.tailscale.cli">
        <description>Run Tailscale CLI</description>
        <message>Authentication is required to control Tailscale</message>
        <defaults>
          <allow_any>auth_admin</allow_any>
          <allow_inactive>auth_admin</allow_inactive>
          <allow_active>auth_admin_keep</allow_active>
        </defaults>
        <annotate key="org.freedesktop.policykit.exec.path">/run/current-system/sw/bin/tailscale</annotate>
        <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
      </action>
    </policyconfig>
  '';
}
