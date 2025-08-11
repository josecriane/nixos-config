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
  users.groups.docker.members = [ username ];

  # Allow unprivileged user namespaces for rootless containers
  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      # Enable the default NAT network
      onBoot = "start";
      onShutdown = "shutdown";
    };

    spiceUSBRedirection.enable = true;

    # Enable Docker
    docker.enable = true;
  };

  # Enable dconf for virt-manager settings persistence
  programs.dconf.enable = true;

  # Configure the default libvirt NAT network
  systemd.services.libvirtd-config-network = {
    description = "Libvirt default network configuration";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      # Check if default network exists and is active
      if ${pkgs.libvirt}/bin/virsh net-info default &>/dev/null; then
        # Start the network if it's not active
        if ! ${pkgs.libvirt}/bin/virsh net-info default | grep -q "Active:.*yes"; then
          ${pkgs.libvirt}/bin/virsh net-start default
        fi
        # Enable autostart
        ${pkgs.libvirt}/bin/virsh net-autostart default
      fi
    '';
  };
}
