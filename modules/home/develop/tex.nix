{ pkgs, ... }:
{
  home.packages = [
    (pkgs.texlive.withPackages (
      ps: with ps; [
        scheme-small
        latexmk
        biber
        preprint
        enumitem
        keycommand
        tcolorbox
        titlesec
        tikzfill
        pdfcol
        listingsutf8
        needspace
        changepage
        marginfix
        tex-gyre
      ]
    ))
    pkgs.poppler-utils
  ];
}
