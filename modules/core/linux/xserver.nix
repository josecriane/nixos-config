{
  pkgs,
  lib,
  machineOptions,
  ...
}:
let
  keyboards =
    machineOptions.keyboards or [
      {
        layout = "us";
        variant = "intl";
      }
    ];
  layouts = lib.concatMapStringsSep "," (kb: kb.layout) keyboards;
  variants = lib.concatMapStringsSep "," (kb: kb.variant or "") keyboards;
in
{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = layouts;
        variant = variants;
        model = "pc105";
      };
    };
  };

  imports =
    [ ]
    ++ (lib.optionals (machineOptions.wm == "plasma") [ ./wm/plasma.nix ])
    ++ (lib.optionals (machineOptions.wm == "gnome") [ ./wm/gnome.nix ]);

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
