{
  config,
  pkgs,
  lib,
  ...
}:
{
  android-sdk.enable = true;
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages =
    sdk: with sdk; [
      build-tools-36-0-0
      cmdline-tools-latest
      emulator
      platform-tools
      platforms-android-36
      system-images-android-36-google-apis-playstore-x86-64
    ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
  };

  home.packages = with pkgs; [
    openjdk17
    gradle
  ];
}
