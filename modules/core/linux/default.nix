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
    ./audit.nix
    ./bluetooth.nix
    ./boot.nix
    ./gaming.nix
    ./gvfs.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./openvpn.nix
    ./pipewire.nix
    ./secrets.nix
    ./security.nix
    ./ssh-agent.nix
    ./syncthing.nix
    ./system.nix
    ./virtualization.nix
    ./xserver.nix
  ]
  ++ (lib.optionals machineOptions.develop [ ./android.nix ])
  ++ (lib.optionals (machineOptions.server or false) [ ./openssh.nix ]);

  system.stateVersion = "25.05";
}
