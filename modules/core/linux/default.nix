{
  inputs,
  nixpkgs,
  self,
  machineOptions,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./alias.nix
    ./bluetooth.nix
    ./boot.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./pipewire.nix
    ./security.nix
    ./system.nix
    ./xserver.nix
    ./secrets.nix
  ];

  system.stateVersion = "25.05";
}
