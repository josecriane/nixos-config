{ pkgs, ... }:

let
  orca-slicer = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1
    '';
  };
in
{
  home.packages = with pkgs; [
    bcn3d-stratos
    freecad
    lycheeslicer
    orca-slicer
    rayforge
  ];
}
