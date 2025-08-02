{ config, pkgs, lib, ... }:

{ 
  home.packages = with pkgs; [
    android-studio
    android-tools
    flutter
  ];

  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    
    FLUTTER_ROOT = "${pkgs.flutter}";
    DART_SDK = "${pkgs.flutter}/bin/cache/dart-sdk";
    
    PATH = "$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/emulator";
  };

  home.file = {
    "Android/.keep".text = "";
  };
}

