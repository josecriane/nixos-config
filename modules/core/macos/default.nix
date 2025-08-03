{
  inputs,
  nixpkgs,
  self,
  machineOptions,
  ...
}:
{
  imports = [
    ./alias.nix
    ./darwin-system.nix
    ./home-manager.nix
    ./networking.nix
    ./secrets.nix
  ];
}
