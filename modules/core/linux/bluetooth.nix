{ pkgs, ... }:
{
  # STIG V-268147: Disable Bluetooth adapters (INTENTIONALLY NOT FOLLOWED)
  # NOTE: Bluetooth is required for operational needs and is consciously enabled despite STIG recommendation.
  # Risk accepted: Bluetooth functionality is necessary for peripheral device connectivity.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluez-tools
  ];
}
