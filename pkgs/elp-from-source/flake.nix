{
  description = "Erlang Language Platform (ELP) - patched binary version 2025-11-04";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Versión específica de ELP
        version = "2025-11-04";

        # Binario ELP sin patchear
        elp-binary = pkgs.stdenv.mkDerivation {
          pname = "erlang-language-platform-unwrapped";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/${version}/elp-linux-x86_64-unknown-linux-gnu-otp-28.tar.gz";
            hash = "sha256-UF4H3i3yu+Kv58QBYU8J/SX7x7hXWYhjmuLJecz7hCQ=";
          };

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
          ];

          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            zlib
            openssl
          ];

          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            cp elp $out/bin/elp
          '';
        };

        # Wrapper con FHS environment para que eqwalizer funcione
        elp-patched = pkgs.buildFHSEnv {
          name = "elp";
          targetPkgs =
            pkgs: with pkgs; [
              elp-binary
              stdenv.cc.cc.lib
              zlib
              openssl
              glibc
            ];
          runScript = "elp";

          meta = with pkgs.lib; {
            description = "An IDE for Erlang, powered by WhatsApp (FHS wrapper)";
            homepage = "https://whatsapp.github.io/erlang-language-platform/";
            license = with licenses; [
              asl20
              mit
            ];
            maintainers = [ ];
            platforms = [ "x86_64-linux" ];
            mainProgram = "elp";
          };
        };
      in
      {
        packages = {
          default = elp-patched;
          elp = elp-patched;
          elp-unwrapped = elp-binary;
        };

        apps.default = {
          type = "app";
          program = "${elp-patched}/bin/elp";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ elp-patched ];

          shellHook = ''
            echo "ELP development environment (FHS wrapped)"
            echo "ELP version: ${version}"
            elp version 2>/dev/null || echo "ELP installed at: $(which elp)"
          '';
        };
      }
    );
}
