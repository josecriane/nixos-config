{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    lanzaboote.url = "github:nix-community/lanzaboote";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs =
    { nixpkgs, self, lanzaboote, ... }@inputs:
    let
      username = "sito";
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
          };
        };
      };
    };
}

