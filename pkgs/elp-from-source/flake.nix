{
  description = "Erlang Language Platform (ELP) built from source - version 2025-11-04";

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

        # Compilar eqwalizer.jar desde source usando Fixed-Output Derivation
        # Esto permite acceso a internet para descargar dependencias de sbt
        eqwalizer-jar = pkgs.stdenv.mkDerivation {
          pname = "eqwalizer-jar";
          version = "from-elp-${version}";

          src = pkgs.fetchFromGitHub {
            owner = "WhatsApp";
            repo = "erlang-language-platform";
            rev = version;
            hash = "sha256-djdVVg+TILRDpDaq3rVdEbSMDcXaF2FnriHm6ZOIu1Y=";
            fetchSubmodules = true;
          };

          nativeBuildInputs = with pkgs; [
            sbt
            jdk17
          ];

          buildPhase = ''
            export HOME=$TMPDIR
            cd eqwalizer/eqwalizer
            sbt assembly
          '';

          installPhase = ''
            mkdir -p $out
            find . -name "eqwalizer.jar" -exec cp {} $out/eqwalizer.jar \;
          '';

          # Fixed-output derivation para permitir acceso a internet
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = "sha256-EDze4y3Jd+EEKbtqO3hCPebnyYXyGeKYuQnjqY5taPo=";
        };

        elp-from-source = pkgs.stdenv.mkDerivation {
          pname = "erlang-language-platform";
          inherit version;

          src = pkgs.fetchFromGitHub {
            owner = "WhatsApp";
            repo = "erlang-language-platform";
            rev = version;
            hash = "sha256-djdVVg+TILRDpDaq3rVdEbSMDcXaF2FnriHm6ZOIu1Y=";
            fetchSubmodules = true;
          };

          nativeBuildInputs = with pkgs; [
            cargo
            rustc
            rustPlatform.cargoSetupHook
            git
            rebar3
            erlang
          ];

          buildInputs = with pkgs; [
            openssl
            pkg-config
          ];

          # Cargo necesita un hash del Cargo.lock
          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit (elp-from-source) src;
            name = "elp-vendor.tar.gz";
            hash = "sha256-MSOKClChA2uA+pkzPtA5gwtvwOAQgl4FD+hR5qkqVe4=";
          };

          preConfigure = ''
            # Copiar eqwalizer.jar compilado
            mkdir -p eqwalizer-bin
            cp ${eqwalizer-jar}/eqwalizer.jar eqwalizer-bin/

            # Configurar variables de entorno para el build de cargo
            # Usar rutas absolutas resueltas (sin ..)
            export ELP_EQWALIZER_PATH="$(realpath eqwalizer-bin/eqwalizer.jar)"
            export EQWALIZER_DIR="$(realpath eqwalizer/eqwalizer_support)"
            export EQWALIZER_SUPPORT_DIR="$(realpath eqwalizer/eqwalizer_support)"

            echo "ELP_EQWALIZER_PATH: $ELP_EQWALIZER_PATH"
            echo "EQWALIZER_DIR: $EQWALIZER_DIR"
            echo "EQWALIZER_SUPPORT_DIR: $EQWALIZER_SUPPORT_DIR"

            # Verificar que los directorios existen
            if [ ! -f "$ELP_EQWALIZER_PATH" ]; then
              echo "ERROR: eqwalizer.jar not found at $ELP_EQWALIZER_PATH"
              exit 1
            fi
            if [ ! -d "$EQWALIZER_DIR" ]; then
              echo "ERROR: eqwalizer_support directory not found at $EQWALIZER_DIR"
              ls -la eqwalizer/ || true
              exit 1
            fi
          '';

          buildPhase = ''
            export HOME=$TMPDIR

            # Re-exportar variables de entorno (necesario para cargo)
            export ELP_EQWALIZER_PATH="$(realpath eqwalizer-bin/eqwalizer.jar)"
            export EQWALIZER_DIR="$(realpath eqwalizer/eqwalizer_support)"
            export EQWALIZER_SUPPORT_DIR="$(realpath eqwalizer/eqwalizer_support)"

            # Compilar ELP
            echo "Building ELP..."
            cargo build --release
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp target/release/elp $out/bin/

            # Copiar eqwalizer.jar y eqwalizer_support para runtime
            mkdir -p $out/lib/eqwalizer
            cp eqwalizer-bin/eqwalizer.jar $out/lib/eqwalizer/
            cp -r eqwalizer/eqwalizer_support $out/lib/

            # Crear wrapper que configure las variables de entorno
            mv $out/bin/elp $out/bin/.elp-wrapped
            cat > $out/bin/elp <<EOF
#!/bin/sh
export ELP_EQWALIZER_PATH=$out/lib/eqwalizer/eqwalizer.jar
export EQWALIZER_DIR=$out/lib/eqwalizer_support
exec $out/bin/.elp-wrapped "\$@"
EOF
            chmod +x $out/bin/elp
          '';

          meta = with pkgs.lib; {
            description = "An IDE for Erlang, powered by WhatsApp";
            homepage = "https://whatsapp.github.io/erlang-language-platform/";
            license = with licenses; [
              asl20
              mit
            ];
            maintainers = [ ];
            platforms = platforms.unix;
          };
        };
      in
      {
        packages = {
          default = elp-from-source;
          elp = elp-from-source;
          eqwalizer = eqwalizer-jar;
        };

        apps.default = {
          type = "app";
          program = "${elp-from-source}/bin/elp";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ elp-from-source ];

          shellHook = ''
            echo "ELP development environment"
            echo "ELP version: ${version}"
            elp version 2>/dev/null || echo "ELP installed at: $(which elp)"
          '';
        };
      }
    );
}
