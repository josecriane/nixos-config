{ pkgs, ... }:
{
  imports = [
    ./nautilus.nix # file manager
  ];

  home.packages = with pkgs; [
    # Essential GUI tools
    gnome-bluetooth # GNOME Bluetooth manager
    networkmanagerapplet # Network applet
    pamixer # Audio
  ];
}
