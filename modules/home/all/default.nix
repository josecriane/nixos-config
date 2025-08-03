{
  inputs,
  host,
  self,
  ...
}:
{
  imports = [
    ./commands.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./gnugp.nix
    ./wallpapers.nix
    ./zellij.nix
    ./zsh
  ];
}
