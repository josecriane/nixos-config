{ pkgs }:

let
  mkScript =
    name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile (./niri-utils + "/${name}.sh");
    };
in
[
  (mkScript "monitor-setup" [ pkgs.niri ])
  (mkScript "reload-niri" [ pkgs.systemd ])
  (mkScript "switch-layout" [
    pkgs.niri
    pkgs.libnotify
  ])
  (mkScript "screenshot-annotate" [
    pkgs.slurp
    pkgs.grim
    pkgs.swappy
  ])
  (mkScript "color-picker" [
    pkgs.slurp
    pkgs.grim
    pkgs.wl-clipboard
    pkgs.libnotify
    pkgs.coreutils
    pkgs.gawk
  ])
]
