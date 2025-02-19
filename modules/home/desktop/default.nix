{inputs, username, host, ...}: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}

