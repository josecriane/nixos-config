{inputs, username, host, self, ...}: {
  imports = [
    ./commands.nix
    ./docker.nix
    ./git.nix
    ./zsh
  ];
}
