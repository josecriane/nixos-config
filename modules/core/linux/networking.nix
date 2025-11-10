{ pkgs, machineOptions, ... }:
{
  networking = {
    hostName = "${machineOptions.hostname}";
    networkmanager.enable = true;
    # STIG V-268078: Enable built-in firewall
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268078
    firewall.enable = true;

    # STIG V-268146: Encrypt wireless access to/from system (INTENTIONALLY NOT FOLLOWED)
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268146
    # NOTE: Wireless/WiFi connectivity is required for operational needs and is consciously enabled despite STIG recommendation.
    # Risk accepted: WiFi functionality is necessary for network connectivity on mobile devices.
    # wireless.enable = false;  # STIG recommends disabling, but we need WiFi via NetworkManager
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
