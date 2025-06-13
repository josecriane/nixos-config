{inputs, host, ...}: {
  imports = [
    ./alacritty.nix
    ./android.nix
    ./discord.nix
    ./firefox.nix
    ./meld.nix
    ./telegram.nix
    ./vscode
  ];
}

