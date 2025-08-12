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
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];

  users.extraGroups.libvirtd.members = [ machineOptions.username ];

}
