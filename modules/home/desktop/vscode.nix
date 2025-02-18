{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
    userSettings = {};
  };

  programs.zsh.shellAliases = {
    codenix = "code ~/nixos-config";
  };
}
