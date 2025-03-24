{
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tree
    curl
    sshpass
  ];

  environment.variables.EDITOR = "vim";

  time.timeZone = "Europe/Madrid";
  
  # system.stateVersion = 5;
}
