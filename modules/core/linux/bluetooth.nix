{ pkgs, ... }:
{
  # STIG V-268147: Disable Bluetooth adapters (not followed)
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
