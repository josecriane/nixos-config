final: _prev: {
  bcn3d-stratos = final.callPackage ./bcn3d-stratos.nix { };
  makeidcli = final.callPackage ./makeidcli.nix { };
}
