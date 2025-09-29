{
  config,
  lib,
  pkgs,
  machineOptions,
  inputs,
  ...
}:
{
  # Enable Syncthing on all machines by default
  config = {
    services.syncthing = {
      enable = true;
      user = machineOptions.username;
      group = "users";
      dataDir = "/home/${machineOptions.username}";
      configDir = "/home/${machineOptions.username}/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        gui = {
          enabled = false;
        };

        options = {
          # Disable usage reporting
          urAccepted = -1;
          # Enable discovery mechanisms
          relaysEnabled = true;
          localAnnounceEnabled = true;
          globalAnnounceEnabled = true;
          # Disable default folder creation
          defaultFolderPath = "";
        };

        # Common folders synchronized across all machines
        folders = {
          "docs" = {
            path = "/home/${machineOptions.username}/docs";
            devices = lib.filter (d: d != machineOptions.hostname) [
              "imre"
              "newarre"
            ];
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };
          "firefox-profile" = {
            path = "/home/${machineOptions.username}/.mozilla/default";
            devices = lib.filter (d: d != machineOptions.hostname) [
              "imre"
              "newarre"
            ];
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };
        };

        # Only include other devices, not ourselves
        devices = lib.filterAttrs (name: _: name != machineOptions.hostname) {
          "imre" = {
            id = "CUATIOC-UAA7JFJ-QXCKMX6-54UICCE-JT7E5IL-Q2WNNUO-X3SCW4B-MWAIVQ3";
          };
          "newarre" = {
            id = "HCNKGIP-2N3DLFY-SP6UPU3-CCYR3LM-AUMU5TU-HASS4S2-Y2DIEA5-5HXJYQE";
          };
        };
      };
    };
  };
}
