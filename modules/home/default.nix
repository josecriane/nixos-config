{ config, lib, pkgs, machineOptions, ... }:
{
  imports = [
    ./all
  ]
  ++ (lib.optionals machineOptions.hasDesktop [ ./desktop ]);
}
