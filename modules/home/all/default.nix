{inputs, host, self, ...}: {
  imports = [
    ./commands.nix
    ./docker.nix
    ./git.nix
    ./paths.nix
    ./zsh
  ];
}
