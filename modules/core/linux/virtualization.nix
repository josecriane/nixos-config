{
  config,
  pkgs,
  machineOptions,
  ...
}:
{
  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
  };

  # Fix virt-secret-init-encryption.service using /usr/bin/sh (doesn't exist on NixOS)
  systemd.services.virt-secret-init-encryption = {
    serviceConfig.ExecStart =
      let
        script = pkgs.writeShellScript "virt-secret-init-encryption" ''
          umask 0077
          dd if=/dev/random status=none bs=32 count=1 \
            | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key
        '';
      in
      [
        ""
        "${script}"
      ];
  };

  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];

  users.extraGroups.libvirtd.members = [ machineOptions.username ];

}
