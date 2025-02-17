{inputs, username, host, ...}: {
  imports = [
    ./commands.nix
    ./git.nix
    ./zsh.nix
  ];
}
