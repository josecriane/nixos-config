{
  config,
  lib,
  pkgs,
  machineOptions,
  self,
  ...
}:
{
  imports = [
    ./all
  ]
  ++ (lib.optionals machineOptions.desktop [ ./desktop ])
  ++ (lib.optionals machineOptions.develop [ ./develop ])
  ++ (lib.optionals machineOptions.desktop [ ./wm ]);
}
