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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell-config = {
      url = "path:./pkgs/quickshell-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    secrets = {
      url = "git+ssh://git@github.com/josecriane/nix-secrets.git";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      self,
      darwin,
      plasma-manager,
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
