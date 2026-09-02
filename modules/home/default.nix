{
  lib,
  machineOptions,
  ...
}:
{
  imports = [
    ./all
  ]
  ++ (lib.optionals machineOptions.desktop [ ./desktop ])
  ++ (lib.optionals machineOptions.develop [ ./develop ])
  ++ (lib.optionals machineOptions.desktop [ ./wm ]);

  home.pointerCursor.enable = lib.mkIf (machineOptions.os == "linux") true;
}
