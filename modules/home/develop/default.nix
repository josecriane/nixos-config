{inputs, host, ...}: {
  imports = [
    ./android.nix
    ./beam.nix
    ./claude.nix
    ./tex.nix
  ];
}
