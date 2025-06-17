{ config, pkgs, lib, ... }:

{
  nixpkgs.config.android_sdk.accept_license = true;
  
  home.packages = with pkgs; [
    # android-studio
    flutter327
    android-tools
    openjdk17
    gradle
    cocoapods
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
    
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";

    DART_SDK = "${pkgs.dart}";
    FLUTTER_ROOT = "${pkgs.flutter}";

    PATH = "$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin";
  };

  home.file = {
    "Library/Android/.keep".text = "";
  };
}

# KDE/GNOME:
# services.udev.extraRules = ''
#   # Reglas para dispositivos Android
#   SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="adbusers", TAG+="uaccess"
# '';
