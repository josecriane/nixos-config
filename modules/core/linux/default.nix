{
  inputs,
  lib,
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
    ./devices.nix
    ./gaming.nix
    ./gvfs.nix
    ./home-manager.nix
    ./i18n.nix
    ./localsend.nix
    ./networking.nix
    ./nh.nix
    ./openvpn.nix
    ./policies.nix
    ./pipewire.nix
    ./secrets.nix
    ./security.nix
    ./ssh-agent.nix
    ./syncthing.nix
    ./system.nix
    ./virtualization.nix
    ./session.nix
  ]
  ++ (lib.optionals machineOptions.develop [
    ./android.nix
    ./it-tools.nix
  ])
  ++ (lib.optionals machineOptions.server [ ./openssh.nix ]);

}
