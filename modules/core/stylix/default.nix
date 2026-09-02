{
  lib,
  machineOptions,
  ...
}:
let
  isLinux = machineOptions.os == "linux";
in
{
  imports = [
    ./colors.nix
    ./fonts.nix
  ]
  ++ (lib.optionals isLinux [
    ./cursor.nix
    ./iconTheme.nix
  ]);

  stylix = {
    enable = true;
  }
  // lib.optionalAttrs isLinux {
    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
