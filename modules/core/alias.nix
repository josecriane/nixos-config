{ config, pkgs, ... }:
{
  environment.shellAliases = {
    cdev = "cd ~/dev";
    cdocs = "cd ~/docs";
    cder = "cd ~/dev/erlang";
    cdl = "cd ~/libs";
    cdtmp = "cd ~/tmp";
    cp="cp -r";
    cdnix = "cd ~/nixos-config";
    nixgc="sudo nix-env --delete-generations old; sudo nix-store --gc; sudo nix-collect-garbage -d";
  };
}