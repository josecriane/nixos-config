{
  lib,
  machineOptions,
  ...
}:
{
  imports = [
    ./beam.nix
    ./claude
    ./essentials.nix
    ./postman.nix
    ./rust.nix
    ./tex.nix
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [
    ./android.nix
    ./linux_custom
  ])
  ++ (lib.optionals (machineOptions.os == "macos") [ ./macos_custom ]);
}
