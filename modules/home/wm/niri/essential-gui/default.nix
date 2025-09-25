{ pkgs, ... }:
{
  imports = [
    ./nautilus.nix # file manager
  ];

  home.packages = with pkgs; [
    # Essential GUI tools
    polkit_gnome # GNOME authentication agent
    pavucontrol # Volume control that works on Wayland
    gnome-power-manager # GNOME power and brightness manager
    wdisplays # Display manager for Wayland
    file-roller # GNOME archive manager
    eog # GNOME image viewer
    evince # GNOME PDF viewer

    # System utilities
    brightnessctl
    playerctl
    libnotify
    xdg-utils

    # Qt/Wayland compatibility
    qt6.qtwayland
  ];
}
