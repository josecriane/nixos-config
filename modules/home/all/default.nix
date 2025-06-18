{inputs, host, self, ...}: {
  imports = [
    ./commands.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./gnugp.nix
    ./paths.nix
    ./zsh
  ];
}
