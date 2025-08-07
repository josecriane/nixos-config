{
  config,
  lib,
  pkgs,
  machineOptions,
  ...
}:
let
  username = machineOptions.username;
in
{
  # https://nixos.wiki/wiki/Virt-manager
  users.groups.libvirtd.members = [ username ];

  virtualisation = {
    libvirtd.enable = true;

    spiceUSBRedirection.enable = true;
  };

  # Enable dconf for virt-manager settings persistence
  programs.dconf.enable = true;
}
