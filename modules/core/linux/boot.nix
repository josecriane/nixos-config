{ pkgs, lib, inputs, ... }:
{
  boot = {
    bootspec.enable = true;
    
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
  
  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];
}

