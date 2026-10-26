_: {
  environment.shellAliases = {
    nixrebuild = "nix-mac -s";
    nixupdate = "nix flake update";
    nixgc = "sudo nix-collect-garbage --delete-older-than 7d";
  };
}
