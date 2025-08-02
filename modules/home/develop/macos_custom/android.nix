{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    flutter332
    android-tools
    cocoapods
  ];

  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";

    FLUTTER_ROOT = "${pkgs.flutter332}";
    DART_SDK = "${pkgs.flutter332}/bin/cache/dart-sdk";
    
    PATH = "$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin";
  };

  home.file = {
    "Library/Android/.keep".text = "";
  };
}