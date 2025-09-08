{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker-compose
    docker-buildx
  ];
}
