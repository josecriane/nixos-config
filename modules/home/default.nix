{ config, lib, pkgs, machineOptions, ... }:
{
  imports = [
    ./all
  ]
  ++ (lib.optionals machineOptions.desktop [ ./desktop ])
  ++ (lib.optionals machineOptions.develop [ ./develop ]);
}
