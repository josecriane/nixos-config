{ config, pkgs, lib, ... }:

{
  nixpkgs.config.android_sdk.accept_license = true;
  
  home.packages = with pkgs; [
    android-studio
  ];

# KDE/GNOME:
# services.udev.extraRules = ''
#   # Reglas para dispositivos Android
#   SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="adbusers", TAG+="uaccess"
# '';
