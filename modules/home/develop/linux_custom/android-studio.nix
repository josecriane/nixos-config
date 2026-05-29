{
  config,
  pkgs,
  lib,
  ...
}:

let
  gpuLibPath = "${lib.makeLibraryPath [ pkgs.libglvnd ]}:/run/opengl-driver/lib";

  vkIcdSetup = ''export VK_ICD_FILENAMES="$(${pkgs.coreutils}/bin/ls /run/opengl-driver/share/vulkan/icd.d/*.json 2>/dev/null | ${pkgs.gnugrep}/bin/grep -vE 'lvp|gfxstream' | ${pkgs.coreutils}/bin/tr '\n' ':')"'';

  android-studio-gpu = pkgs.symlinkJoin {
    name = "android-studio-gpu";
    paths = [ pkgs.android-studio ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm -f $out/bin/android-studio
      makeWrapper ${pkgs.android-studio}/bin/android-studio $out/bin/android-studio \
        --prefix LD_LIBRARY_PATH : "${gpuLibPath}" \
        --set STUDIO_JDK "${pkgs.jetbrains.jdk-21}/lib/openjdk" \
        --set QT_QPA_PLATFORM xcb \
        --run ${lib.escapeShellArg vkIcdSetup}
    '';
  };

  emulator-gpu = pkgs.writeShellScriptBin "emulator" ''
    export LD_LIBRARY_PATH="${gpuLibPath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export QT_QPA_PLATFORM=xcb
    ${vkIcdSetup}
    exec "${config.home.homeDirectory}/.android/sdk/emulator/emulator" "$@"
  '';
in
{
  home.packages = [
    android-studio-gpu
    (lib.hiPrio emulator-gpu)
    pkgs.android-tools
    pkgs.flutter
  ];

  home.sessionVariables = {
    FLUTTER_ROOT = "${pkgs.flutter}";
    DART_SDK = "${pkgs.flutter}/bin/cache/dart-sdk";
  };
}
