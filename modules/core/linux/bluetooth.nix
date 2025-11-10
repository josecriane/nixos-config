{ pkgs, ... }:
{
  # STIG V-268147: Disable Bluetooth adapters (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268147
  # NOTE: Bluetooth is required for operational needs and is consciously enabled despite STIG recommendation.
  # Risk accepted: Bluetooth functionality is necessary for peripheral device connectivity.
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

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
