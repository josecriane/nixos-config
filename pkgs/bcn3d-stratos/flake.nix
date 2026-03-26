{
  description = "BCN3D Stratos 2.2.1 AppImage wrapper";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pname = "bcn3d-stratos";
      version = "2.2.1";

      src = pkgs.fetchurl {
        url = "https://github.com/BCN3D/Stratos/releases/download/v${version}/BCN3D_Stratos_${version}.AppImage";
        sha256 = "a4712b1183860dadada4eafbb534541e2f6ebbbd83afcd8e42d9cdf909193525";
      };

      stratos = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands =
          let
            glLibs = pkgs.lib.makeLibraryPath [
              pkgs.libGL
              pkgs.libglvnd
              pkgs.mesa
            ];
          in
          ''
            source ${pkgs.makeWrapper}/nix-support/setup-hook
            wrapProgram $out/bin/${pname} \
              --set QT_QPA_PLATFORM xcb \
              --prefix LD_LIBRARY_PATH : "${glLibs}"
          '';

        extraPkgs =
          p: with p; [
            # OpenGL / EGL
            libGL
            libGLU
            mesa
            egl-wayland
            libglvnd

            # Qt5
            qt5.qtbase
            qt5.qtdeclarative
            qt5.qtsvg
            qt5.qtxmlpatterns

            # X11 / display
            libx11
            libxext
            libxrender
            libxi
            libxrandr
            libxcursor
            libxfixes
            libxcb
            libxcb-util
            libxcb-wm
            libxcb-image
            libxcb-keysyms
            libxcb-render-util

            # Common GUI / system libs
            glib
            fontconfig
            freetype
            zlib
            dbus
            libxkbcommon
            libdrm
            nss
            nspr
            expat
          ];
      };
    in
    {
      packages.${system} = {
        bcn3d-stratos = stratos;
        default = stratos;
      };

      apps.${system}.default = {
        type = "app";
        program = "${stratos}/bin/${pname}";
      };
    };
}
