{
  description = "QuickShell Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      quickshell,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
        }
      );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          quickshellPkg = quickshell.packages.${system}.default;

          # Function to create quickshell config with optional commands files
          mkQuickshellConfig =
            {
              commandsPath ? null,
              sessionCommandsPath ? null,
            }:
            pkgs.stdenv.mkDerivation rec {
              pname = "quickshell-config";
              version = "0.1.0";

              src = ./.;

              nativeBuildInputs = [ pkgs.makeWrapper ];
              buildInputs = [ quickshellPkg ];

              installPhase = ''
                # Copy all configuration files
                mkdir -p $out/share/quickshell-config
                cp -r ds modules services shell $out/share/quickshell-config/ 2>/dev/null || true
                cp shell.qml $out/share/quickshell-config/

                # Copy commands.json if provided
                ${pkgs.lib.optionalString (commandsPath != null) ''
                  cp ${commandsPath} $out/share/quickshell-config/commands.json
                ''}

                # Copy session-commands.json if provided
                ${pkgs.lib.optionalString (sessionCommandsPath != null) ''
                  cp ${sessionCommandsPath} $out/share/quickshell-config/session-commands.json
                ''}

                # Create wrapper script
                mkdir -p $out/bin
                makeWrapper ${quickshellPkg}/bin/quickshell $out/bin/quickshell-config \
                  --prefix QML2_IMPORT_PATH : "${quickshellPkg}/lib/qt-6/qml"
              '';

              meta = with pkgs.lib; {
                description = "Personal QuickShell configuration";
                platforms = platforms.linux;
              };
            };
        in
        {
          default = self.packages.${system}.quickshell-config;

          quickshell-config = mkQuickshellConfig { };

          # Function to create config with custom commands
          withCommands = commandsPath: mkQuickshellConfig { inherit commandsPath; };

          # Function to create config with both commands and session commands
          withAllCommands =
            {
              commandsPath ? null,
              sessionCommandsPath ? null,
            }:
            mkQuickshellConfig { inherit commandsPath sessionCommandsPath; };
        }
      );

      # Home Manager module
      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.programs.quickshell-config = {
            enable = lib.mkEnableOption "quickshell-config";
          };

          config = lib.mkIf config.programs.quickshell-config.enable {
            home.packages = [ self.packages.${pkgs.system}.quickshell-config ];
          };
        };

      # Overlay for easier integration
      overlays.default = final: prev: {
        quickshell-config = self.packages.${final.system}.quickshell-config;
      };
    };
}
