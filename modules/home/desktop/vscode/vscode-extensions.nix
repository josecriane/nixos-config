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
  james-yu.latex-workshop
  rust-lang.rust-analyzer
  ryu1kn.partial-diff
]
++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "qt-qml";
    publisher = "theqtcompany";
    version = "1.17.0";
    sha256 = "4P0v3r1pHgLKR7Jt3Je3kBHSwVZ2djWlxQOmAbTsM/0=";
  }
  {
    name = "qt-core";
    publisher = "theqtcompany";
    version = "1.17.0";
    sha256 = "knBG17lcrr3NP5sxMtbgG6coiEM//caEeei2NWKfJVk=";
  }
  {
    name = "elixir-ls";
    publisher = "jakebecker";
    version = "0.31.1";
    sha256 = "eF0OGWpiu5aDiFp8MFP7j2r2+3QCPb1q93gWg7L/Xzc=";
  }
  {
    name = "erlang-language-platform";
    publisher = "erlang-language-platform";
    version = "0.52.0";
    sha256 = "gjqa47cCmVhavouvXrPx4dEuIgKIv2AKVMX+HRuJ0UE=";
  }
  {
    name = "vscode-openapi";
    publisher = "42Crunch";
    version = "5.9.0";
    sha256 = "sUfug0F0OaoMmKEmcHyXQIXcun35MAFVSGAHbx7xK/8=";
  }
]
