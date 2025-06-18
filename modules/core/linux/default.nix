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
    ./boot.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./pipewire.nix
    ./security.nix
    ./xserver.nix
  ];

  system.stateVersion = "25.05";
}
