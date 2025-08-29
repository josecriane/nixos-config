{ pkgs }:

with pkgs.vscode-extensions;
[
  bbenoist.nix
  dart-code.dart-code
  dotjoshjohnson.xml
  foxundermoon.shell-format
  hediet.vscode-drawio
  ms-azuretools.vscode-docker
  redhat.vscode-yaml
  rust-lang.rust-analyzer
  ryu1kn.partial-diff
]
++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "elixir-ls";
    publisher = "jakebecker";
    version = "0.26.4";
    sha256 = "ipnKJRnRYDVadyfSAisYDc2fyZeWrzlRQ0ZpCX1hVl0=";
  }
  {
    name = "erlang-ls";
    publisher = "erlang-ls";
    version = "0.0.46";
    sha256 = "HvQ0qv1wA+qSN1+8r9Z4iTq7DtpsCvOZ73bACeHZ9+o=";
  }
]
