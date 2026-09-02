{ pkgs, lib, ... }:
{
  home.packages = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.vlc;
}
