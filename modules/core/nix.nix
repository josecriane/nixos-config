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

      # STIG V-268154: verify digital signatures on anything entering the store.
      require-sigs = true;
    }
    // lib.optionalAttrs isLinux {
      # STIG V-268152: restrict software installation to authorized users.
      allowed-users = [ username ];
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
