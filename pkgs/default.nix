final: prev: {
  bcn3d-stratos = final.callPackage ./bcn3d-stratos.nix { };
  makeidcli = final.callPackage ./makeidcli.nix { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pyfinal: pyprev: {
      # Drop once https://github.com/NixOS/nixpkgs/pull/587278 lands.
      raygeo = pyprev.raygeo.overridePythonAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.pkg-config ];
        buildInputs = (old.buildInputs or [ ]) ++ [ final.zstd ];
      });
    })
  ];
}
