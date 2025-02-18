{ config, pkgs, ... }:
{
  environment.shellAliases = {
    cdd = "cd ~/docs";
    cde = "cd ~/erlang";
    cp="cp -r";
    cdnix = "cd ~/nixos-config";
    nixgc="sudo nix-env --delete-generations old; sudo nix-store --gc; sudo nix-collect-garbage -d";
    nixrebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    nixupdate = "sudo nixos-rebuild switch --upgrade";
  };
}