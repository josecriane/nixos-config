{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Enable Syncthing on all machines by default
  config = {
    services.syncthing = {
      enable = true;
      user = config.machine.username;
      group = "users";
      dataDir = "${config.machine.homeDirectory}";
      configDir = "${config.machine.homeDirectory}/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        gui = {
          enabled = true;
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
            path = "${config.machine.homeDirectory}/docs";
            devices = lib.filter (d: d != config.machine.hostname) [
              "DN2103"
              "imre"
              "newarre"
            ];
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };

          "keepass" = {
            path = "${config.machine.homeDirectory}/keepass";
            devices = lib.filter (d: d != config.machine.hostname) [
              "DN2103"
              "imre"
              "newarre"
            ];
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "2592000";
              };
            };
          };
        };

        # Only include other devices, not ourselves
        devices = lib.filterAttrs (name: _: name != config.machine.hostname) {
          "DN2103" = {
            id = "NHWIMFF-JTD744F-3H36QCL-GSL4JQO-WNGXYTF-EHQYZ75-YDAD4DL-KQ4E7AP";
          };
          "imre" = {
            id = "7XLB2OQ-VZIA3MI-RWBHE42-3Z37WO3-ZGI73HE-6UJQW4L-3MSF3VS-COPTVAL";
          };
          "newarre" = {
            id = "ZCV2MT5-DAU4RWF-VITKVT6-O5AN4KR-QUEMJPE-7XJFUVV-Z6PYLZP-PP2BTQD";
          };
        };
      };
    };
  };
}
