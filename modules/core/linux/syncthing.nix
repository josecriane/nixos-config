{
  config,
  lib,
  ...
}:
let
  inherit (config.machine) hostname;

  peers = lib.filterAttrs (name: _: name != hostname) {
    "DN2103" = {
      id = "NHWIMFF-JTD744F-3H36QCL-GSL4JQO-WNGXYTF-EHQYZ75-YDAD4DL-KQ4E7AP";
    };
    "imre" = {
      id = "7XLB2OQ-VZIA3MI-RWBHE42-3Z37WO3-ZGI73HE-6UJQW4L-3MSF3VS-COPTVAL";
    };
    "newarre" = {
      id = "ZCV2MT5-DAU4RWF-VITKVT6-O5AN4KR-QUEMJPE-7XJFUVV-Z6PYLZP-PP2BTQD";
    };
    "bast" = {
      id = "TICMXNT-CTEBSYC-BUEZTPB-OUDQ6XT-3MYOPTG-HBZBYEF-6CD3HOK-Z2RQPAZ";
    };
    "manet" = {
      id = "7UWZ5F3-W3CHW7O-7ACNSMZ-HKEH2PX-IKMS7GH-GIVTYXH-YU3WYME-E23J7QS";
    };
  };

  allPeers = lib.attrNames peers;

  peersAmong = names: lib.intersectLists names allPeers;
in
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
            devices = allPeers;
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };

          "keepass" = {
            path = "${config.machine.homeDirectory}/keepass";
            devices = allPeers;
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "2592000";
              };
            };
          };

          "3dprinting" = {
            path = "${config.machine.homeDirectory}/.config/3dprinting";
            devices = peersAmong [
              "newarre"
              "bast"
              "manet"
            ];
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };
        };

        # Only include other devices, not ourselves
        devices = peers;
      };
    };
  };
}
