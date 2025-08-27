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
  nixpkgs.config.android_sdk.accept_license = true;

  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # System fonts - Stylix handles font configuration

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tree
    curl
    sshpass
    gawk
    gnumake
    btop
  ];

  environment.variables.EDITOR = "vim";

  time.timeZone = "Europe/Madrid";
}
