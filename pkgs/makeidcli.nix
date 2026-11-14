{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  imagemagick,
}:
stdenv.mkDerivation {
  pname = "makeidcli";
  version = "0.1-unstable-2024-01-10";

  src = fetchFromGitLab {
    owner = "0xDRRB";
    repo = "makeidcli";
    rev = "6f32f14fb6a8d78841738b3c597119e8ac3882e8";
    hash = "sha256-ubRxIRGYsI3yj6tdXLOYwoxBouc+7hj27+YZulbBMoI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ imagemagick ];

  postPatch = ''
    substituteInPlace main.c \
      --replace-fail '#include <wand/magick_wand.h>' '#include <MagickWand/MagickWand.h>' \
      --replace-fail 'LanczosFilter,1)' 'LanczosFilter)'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 makeidcli $out/bin/makeidcli
    runHook postInstall
  '';

  meta = {
    description = "Print images on a MakeID L1-A label printer over USB";
    homepage = "https://gitlab.com/0xDRRB/makeidcli";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    mainProgram = "makeidcli";
  };
}
