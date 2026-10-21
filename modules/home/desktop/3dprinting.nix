{
  config,
  lib,
  pkgs,
  ...
}:

let
  sharedDir = "${config.xdg.configHome}/3dprinting";

  orca-slicer = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1
    '';
  };

  bcn3d-stratos = pkgs.symlinkJoin {
    name = "bcn3d-stratos";
    paths = [ pkgs.bcn3d-stratos ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bcn3d-stratos \
        --set XDG_CONFIG_HOME ${sharedDir}/stratos/config \
        --set XDG_DATA_HOME ${sharedDir}/stratos/data
    '';
  };

  rayforge = pkgs.symlinkJoin {
    name = "rayforge";
    paths = [ pkgs.rayforge ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rayforge \
        --set RAYFORGE_CONFIG_DIR ${sharedDir}/rayforge
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

  home.activation.sharedPrintingDirs = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    mkdir -p ${sharedDir}/orcaslicer ${sharedDir}/stratos ${sharedDir}/rayforge
  '';

  xdg.configFile."OrcaSlicer/user".source =
    config.lib.file.mkOutOfStoreSymlink "${sharedDir}/orcaslicer";
}
