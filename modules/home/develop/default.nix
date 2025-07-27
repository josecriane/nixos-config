{inputs, lib, machineOptions, host, ...}: {
  imports = [
    ./android.nix
    ./beam.nix
    ./claude.nix
    ./rust.nix
    ./tex.nix
  ] 
  ++ (lib.optionals (machineOptions.os == "linux") [./linux_custom])
  ++ (lib.optionals (machineOptions.os == "macos") [./macos_custom]);
}
