{inputs, username, host, ...}: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./meld.nix
    ./plasma.nix
    ./telegram.nix
    ./vscode.nix
  ];
}

