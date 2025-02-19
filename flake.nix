{
  description = "josecriane nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    lanzaboote.url = "github:nix-community/lanzaboote";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  
  outputs =
    { nixpkgs, self, plasma-manager, home-manager, lanzaboote, ... }@inputs:
    let
      username = "sito";
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
            inherit self inputs username;
            machineOptions = loadMachineOptions "imre";
          };
        };
      };
    };
}

