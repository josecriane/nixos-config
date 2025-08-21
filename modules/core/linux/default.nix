{
  inputs,
  nixpkgs,
  lib,
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
    ./gvfs.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./openvpn.nix
    ./pipewire.nix
    ./secrets.nix
    ./security.nix
    ./ssh-agent.nix
    ./system.nix
    ./virtualization.nix
    ./xserver.nix
  ]
  ++ (lib.optionals machineOptions.develop [ ./android.nix ]);

  system.stateVersion = "25.05";
}
