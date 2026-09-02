{
  description = "josecriane nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell-config = {
      url = "github:josecriane/quickshell-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    self.submodules = true;

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      darwin,
      claude-code,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      forAllSystems = lib.genAttrs [
        linuxSystem
        darwinSystem
      ];

      pkgsFor = system: nixpkgs.legacyPackages.${system};

      overlaysModule = {
        nixpkgs.overlays = [
          (import ./pkgs)
          inputs.android-nixpkgs.overlays.default
          inputs.nur.overlays.default
          claude-code.overlays.default
        ];
      };

      mkModules = host: [
        (./hosts + "/${host}")
        ./modules/core
        overlaysModule
      ];

      mkSpecialArgs = host: os: {
        inherit self inputs;
        machineOptions = {
          inherit os;
        }
        // import (./hosts + "/${host}/options.nix");
      };

      mkLinuxSystem =
        host:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = mkModules host;
          specialArgs = mkSpecialArgs host "linux";
        };

      mkDarwinSystem =
        host:
        darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = mkModules host;
          specialArgs = mkSpecialArgs host "macos";
        };
    in
    {
      nixosConfigurations = {
        imre = mkLinuxSystem "imre";
        newarre = mkLinuxSystem "newarre";
      };

      darwinConfigurations = {
        MacBookAir10-1-jose-cribeiro = mkDarwinSystem "macbook-air";
      };

      formatter = forAllSystems (system: (pkgsFor system).nixfmt-tree);

      devShells = forAllSystems (system: {
        default = (pkgsFor system).mkShell {
          packages = [
            (pkgsFor system).nixfmt-rfc-style
            (pkgsFor system).nix-tree
            inputs.agenix.packages.${system}.default
          ]
          ++ lib.optionals (system == linuxSystem) [ (pkgsFor system).sbctl ];
        };
      });

      checks.${linuxSystem} = lib.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) self.nixosConfigurations;

      checks.${darwinSystem} = lib.mapAttrs (
        _: cfg: cfg.config.system.build.toplevel
      ) self.darwinConfigurations;
    };
}
