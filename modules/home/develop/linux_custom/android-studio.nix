{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    android-studio
    android-tools
    flutter
  ];

  home.sessionVariables = {
    FLUTTER_ROOT = "${pkgs.flutter}";
    DART_SDK = "${pkgs.flutter}/bin/cache/dart-sdk";
  };
}
