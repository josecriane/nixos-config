{inputs, username, host, ...}: {
  imports = [
    ./commands.nix
    ./docker.nix
    ./git.nix
    ./zsh.nix
  ];
}
