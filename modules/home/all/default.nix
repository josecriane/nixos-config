{inputs, host, self, ...}: {
  imports = [
    ./commands.nix
    ./docker.nix
    ./git.nix
    ./gnugp.nix
    ./paths.nix
    ./zsh
  ];
}
