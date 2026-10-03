{ lib, pkgs, ... }:
{
  home.packages = [
    (pkgs.vesktop.override { withSystemVencord = true; })
  ]
  ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.equibop;
}
