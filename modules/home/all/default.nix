{
  lib,
  machineOptions,
  ...
}:
{
  imports = [
    ./alias.nix
    ./commands.nix
    ./direnv.nix
    ./docker.nix
    ./fzf.nix
    ./git.nix
    ./gnugp.nix
    ./paths.nix
    ./zellij.nix
    ./zsh
  ]
  ++ (lib.optionals (machineOptions.os == "linux") [ ./xdg.nix ]);
}
