{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tree
    curl
    sshpass
    gawk
    btop
  ];
}
