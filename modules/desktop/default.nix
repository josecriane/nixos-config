{inputs, username, host, ...}: {
  imports = [
    ./firefox.nix
    ./meld.nix
    ./telegram.nix
    ./vscode.nix
  ];
}

