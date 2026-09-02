{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  libGL,
  libGLU,
  libglvnd,
  mesa,
  egl-wayland,
  qt5,
  libx11,
  libxext,
  libxrender,
  libxi,
  libxrandr,
  libxcursor,
  libxfixes,
  libxcb,
  libxcb-util,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  glib,
  fontconfig,
  freetype,
  zlib,
  dbus,
  libxkbcommon,
  libdrm,
  nss,
  nspr,
  expat,
}:
let
  pname = "bcn3d-stratos";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/BCN3D/Stratos/releases/download/v${version}/BCN3D_Stratos_${version}.AppImage";
    sha256 = "a4712b1183860dadada4eafbb534541e2f6ebbbd83afcd8e42d9cdf909193525";
  };

  glLibs = lib.makeLibraryPath [
    libGL
    libglvnd
    mesa
  ];

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/${pname} \
      --set QT_QPA_PLATFORM xcb \
      --prefix LD_LIBRARY_PATH : "${glLibs}"

    install -Dm444 ${appimageContents}/cura.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail "Exec=UltiMaker-Cura" "Exec=${pname}"

    cp -r ${appimageContents}/usr/share/icons $out/share/icons
  '';

  extraPkgs = _: [
    libGL
    libGLU
    mesa
    egl-wayland
    libglvnd

    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    qt5.qtxmlpatterns

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

  meta = {
    description = "BCN3D Stratos slicer (AppImage wrapper)";
    homepage = "https://github.com/BCN3D/Stratos";
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
