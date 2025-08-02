{
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
    services.printing.enable = true;
    
    services.fwupd.enable = true;
    
    environment.systemPackages = with pkgs; [
        fwupd
    ];
}