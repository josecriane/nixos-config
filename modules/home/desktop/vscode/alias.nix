{ config, pkgs, ... }:
{
  programs.zsh.shellAliases = {
    codedocs = "code ~/docs";
    codenix = "code ~/nixos-config";
    codescritps = "code ~/scripts";
  };
}
