{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    newman
    postman
  ];
}
