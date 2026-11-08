{
  config,
  lib,
  ...
}:
let
  isLinux = config.machine.os == "linux";
  inherit (config.machine) username;
in
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      require-sigs = true;
    }
    // lib.optionalAttrs (!isLinux) {
      trusted-users = [ username ];

      auto-optimise-store = false;
    };

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };

    optimise.automatic = lib.mkDefault true;
  };
}
