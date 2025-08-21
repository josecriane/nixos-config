{ pkgs, ... }:
{
  imports = [
    ./nautilus.nix # file manager
  ];

  home.packages = with pkgs; [
    # Essential GUI tools
    polkit_gnome # GNOME authentication agent
    gnome-bluetooth # GNOME Bluetooth manager
    pavucontrol # Volume control that works on Wayland
    pasystray # Audio system tray applet
    gnome-power-manager # GNOME power and brightness manager
    wdisplays # Display manager for Wayland
    file-roller # GNOME archive manager
    eog # GNOME image viewer
    evince # GNOME PDF viewer

    # System utilities
    brightnessctl
    playerctl
    pamixer
    libnotify
    xdg-utils
    networkmanagerapplet

    # Qt/Wayland compatibility
    qt6.qtwayland
  ];
}
