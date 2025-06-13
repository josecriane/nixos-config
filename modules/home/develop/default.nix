{inputs, host, ...}: {
  imports = [
    ./beam.nix
    ./claude.nix
    ./tex.nix
  ];
}
