{
  pkgs,
  lib,
  ...
}:
let
  xwayland-satellite = pkgs.xwayland-satellite.overrideAttrs (old: rec {
    version = "0.8.2-unstable-2026-09-09";
    src = pkgs.fetchFromGitHub {
      owner = "Supreeeme";
      repo = "xwayland-satellite";
      rev = "add2795134593faafce60e404a0a75df68e9ee0c";
      hash = "sha256-0TxfMgqW0/BLD4M942c5DCKYrtPvzsPJwvdcco4LQUM=";
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-s1gl9eR6Mt2QLrhfcowstPFjzwE/lz4PJhJzWYHoIHg=";
    };
  });
in
{
  # Habilitar niri como session
  programs.niri.enable = true;

  # Servicios esenciales para niri
  services = {
    # Display manager: greetd + tuigreet (ligero, ideal para WMs tipo niri)
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # Session niri
    displayManager.sessionPackages = [ pkgs.niri ];

    # Deshabilitar agente SSH de GNOME para evitar conflicto con programs.ssh.startAgent
    gnome.gcr-ssh-agent.enable = lib.mkForce false;
  };

  # Portales XDG para Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  # Paquetes del sistema necesarios
  environment.systemPackages = [
    pkgs.wayland
    pkgs.xwayland
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
