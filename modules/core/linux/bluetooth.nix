{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      bluez
      bluez-tools
      blueman
      openobex
      obexftp
    ]
    ++ (with pkgs.kdePackages; [
      bluez-qt
      bluedevil
    ]);
}
