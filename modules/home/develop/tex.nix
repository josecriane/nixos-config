{ pkgs, ... }:
{
  home.packages = [
    (pkgs.texlive.withPackages (
      ps: with ps; [
        scheme-small
        latexmk
        biber
      ]
    ))
  ];
}
