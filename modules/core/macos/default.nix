{
  inputs,
  nixpkgs,
  self,
  host,
  machineOptions,
  ...
}:
{
  imports = [
    ./alias.nix
    ./darwin-system.nix
    ./home-manager.nix
    ./networking.nix
  ];
}
