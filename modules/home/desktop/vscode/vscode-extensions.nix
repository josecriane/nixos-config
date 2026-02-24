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
    name = "qt-qml";
    publisher = "theqtcompany";
    version = "1.8.0";
    sha256 = "x8D1jbCpQsVkGGCvnNWfAbbA+8Sn8oPQ/St9HTq1PVg=";
  }
  {
    name = "qt-core";
    publisher = "theqtcompany";
    version = "1.8.0";
    sha256 = "qgtDiSHHZ7k8H55W5Or01UxAW3UaQRVSuOpAj/l021I=";
  }
  {
    name = "elixir-ls";
    publisher = "jakebecker";
    version = "0.26.4";
    sha256 = "ipnKJRnRYDVadyfSAisYDc2fyZeWrzlRQ0ZpCX1hVl0=";
  }
  {
    name = "erlang-language-platform";
    publisher = "erlang-language-platform";
    version = "0.42.0";
    sha256 = "tmwOrZnfgMfEVeV4vgYe1VJDtR+MeM/4bXiQuCcoH38=";
  }
  {
    name = "vscode-openapi";
    publisher = "42Crunch";
    version = "5.2.0";
    sha256 = "fw7E8S03XqaqsEryuWEWL/EynxNPHQTzZGPMSAQODBQ=";
  }
]
