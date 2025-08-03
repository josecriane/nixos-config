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
