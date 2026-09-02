{
  inputs,
  lib,
  machineOptions,
  ...
}:
{
  imports = [
    ../options.nix
    ./stylix
    ./alias.nix
    ./essentials.nix
    ./nix.nix
    ./secrets.nix
    ./system.nix
    ./zsh.nix
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [
    inputs.stylix.nixosModules.stylix
    ./linux
  ])
  ++ (lib.optionals (machineOptions.os == "macos") [
    inputs.stylix.darwinModules.stylix
    ./macos
  ]);
}
