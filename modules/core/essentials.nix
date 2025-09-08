{
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tree
    curl
    sshpass
    gawk
    btop
    ddcutil
    lm_sensors
    upower
  ];
  services.upower.enable = true;
}
