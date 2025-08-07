{
  config,
  machineOptions,
  pkgs,
  ...
}:
{
  # https://nixos.wiki/wiki/Virt-manager
  home.packages = with pkgs; [
    virt-manager
  ];
}
