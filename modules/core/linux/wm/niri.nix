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
  programs.niri.enable = true;

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # Disabled to avoid clashing with programs.ssh.startAgent.
    gnome.gcr-ssh-agent.enable = lib.mkForce false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.systemPackages = [
    pkgs.xwayland
    xwayland-satellite
  ];

  security.polkit.enable = true;
}
