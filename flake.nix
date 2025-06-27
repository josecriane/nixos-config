{
  description = "josecriane nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
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
  };
  
  outputs =
    { 
      nixpkgs, 
      self, 
      darwin, 
      plasma-manager, 
      home-manager, 
      lanzaboote,
      ... 
    }@inputs:
    let
      loadMachineOptions = host: import (./hosts + "/${host}/options.nix");
    in
    {
      nixosConfigurations = {
        imre = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/imre
            ./modules/core
            lanzaboote.nixosModules.lanzaboote
          ];
          specialArgs = {
            host = "imre";
            inherit self inputs;
            machineOptions = loadMachineOptions "imre";
          };
        };
      };

      darwinConfigurations = {
        MacBookAir10-1-jose-cribeiro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          # inherit system specialArgs;
          modules = [
            ./hosts/MacBookAir10-1-jose-cribeiro
            ./modules/core
          ];
          specialArgs = {
            host = "MacBookAir10-1-jose-cribeiro";
            inherit self inputs;
            machineOptions = loadMachineOptions "MacBookAir10-1-jose-cribeiro";
          };
        };
      };

    };
}
