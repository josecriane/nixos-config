{ config, pkgs, ... }:
{
  programs.zsh.shellAliases = {
    codenix = "code ~/nixos-config";
  };
}
