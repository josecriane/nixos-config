{inputs, username, host, ...}: {
  imports = [
    ./vscode.nix
    ./firefox.nix
    ./telegram.nix
  ];
}

