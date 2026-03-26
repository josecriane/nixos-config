{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.bcn3d-stratos.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
