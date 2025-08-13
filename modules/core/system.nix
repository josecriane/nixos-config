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

  # Fuentes del sistema
  fonts.packages =
    with pkgs;
    [
      # Instalar todas las nerd fonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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
}
