{
  lib,
  machineOptions,
  ...
}:
let
  inherit (lib) mkOption types;

  keyboard = types.submodule {
    options = {
      layout = mkOption { type = types.str; };
      variant = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  monitor = types.submodule {
    options = {
      name = mkOption { type = types.str; };

      mode = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      scale = mkOption {
        type = types.nullOr types.float;
        default = null;
      };

      position = mkOption {
        default = null;
        type = types.nullOr (
          types.submodule {
            options = {
              x = mkOption { type = types.int; };
              y = mkOption { type = types.int; };
            };
          }
        );
      };

      transform = mkOption {
        type = types.nullOr (
          types.enum [
            "90"
            "180"
            "270"
            "flipped"
          ]
        );
        default = null;
      };

      variableRefreshRate = mkOption {
        type = types.bool;
        default = false;
      };

      focusAtStartup = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
in
{
  options.machine = {
    os = mkOption {
      type = types.enum [
        "linux"
        "macos"
      ];
    };
    hostname = mkOption { type = types.str; };
    username = mkOption { type = types.str; };

    desktop = mkOption { type = types.bool; };
    develop = mkOption { type = types.bool; };
    server = mkOption {
      type = types.bool;
      default = false;
    };

    wm = mkOption {
      type = types.nullOr (types.enum [ "niri" ]);
      default = null;
    };

    fprint = mkOption {
      type = types.bool;
      default = false;
    };

    keyboards = mkOption {
      type = types.listOf keyboard;
      default = [
        {
          layout = "us";
          variant = "intl";
        }
      ];
    };

    monitors = mkOption {
      type = types.listOf monitor;
      default = [ ];
    };

    homeDirectory = mkOption {
      type = types.str;
      readOnly = true;
    };

    userGroup = mkOption {
      type = types.str;
      readOnly = true;
    };
  };

  config.machine = machineOptions // {
    homeDirectory =
      if machineOptions.os == "linux" then
        "/home/${machineOptions.username}"
      else
        "/Users/${machineOptions.username}";

    userGroup = if machineOptions.os == "linux" then "users" else "staff";
  };
}
