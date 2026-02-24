{
  description = "josecriane nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote.url = "github:nix-community/lanzaboote";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
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

    secrets = {
      url = "git+file:./secrets";
      flake = false;
    };

    elp-from-source = {
      url = "path:./pkgs/elp-from-source";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      self,
      darwin,
      home-manager,
      lanzaboote,
      agenix,
      quickshell,
      quickshell-config,
      secrets,
      ...
    }@inputs:
    let
      mkLinuxSystem =
        host:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (./hosts + "/${host}")
            ./modules/core
            {
              nixpkgs.overlays = [
                inputs.android-nixpkgs.overlays.default
                inputs.nur.overlays.default
              ];
            }
          ];
          specialArgs = {
            inherit self inputs;
            machineOptions = import (./hosts + "/${host}/options.nix");
          };
        };

      mkDarwinSystem =
        host:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            (./hosts + "/${host}")
            ./modules/core
          ];
          specialArgs = {
            inherit self inputs;
            machineOptions = import (./hosts + "/${host}/options.nix");
          };
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

    };
}
