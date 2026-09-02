{ config, ... }:
{
  networking = {
    hostName = config.machine.hostname;
    networkmanager.enable = true;
    # STIG V-268078: Enable built-in firewall
    firewall.enable = true;

    # STIG V-268146: Encrypt wireless access to/from system (INTENTIONALLY NOT FOLLOWED)
    # NOTE: Wireless/WiFi connectivity is required for operational needs and is consciously enabled despite STIG recommendation.
    # Risk accepted: WiFi functionality is necessary for network connectivity on mobile devices.
    # wireless.enable = false;  # STIG recommends disabling, but we need WiFi via NetworkManager
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
