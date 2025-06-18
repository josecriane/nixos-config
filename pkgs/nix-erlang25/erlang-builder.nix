{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, gawk
, gnum4
, gnused
, libxml2
, libxslt
, ncurses
, openssl
, perl
, runtimeShell
, openjdk11 ? null
, unixODBC ? null
, libGL ? null
, libGLU ? null
, wxGTK ? null
, xorg ? null
, systemd ? null
, wrapGAppsHook3 ? null
, zlib
, parallelBuild ? false
}:

let
  version = "25.3.2.20";
in stdenv.mkDerivation {
  pname = "erlang";
  inherit version;
  
  src = fetchFromGitHub {
    owner = "erlang";
    repo = "otp";
    rev = "OTP-${version}";
    sha256 = "sha256-fd2YxFx/Skst+jRXAm4nLVxEIriu34lPRuBWvj+qaIk=";
  };

  LANG = "C.UTF-8";

  nativeBuildInputs = [
    makeWrapper
    perl
    gnum4
    libxslt
    libxml2
  ] ++ lib.optional (wxGTK != null) wrapGAppsHook3;

  buildInputs = [
    ncurses
    openssl
    zlib
  ] ++ lib.optionals (wxGTK != null) [
    wxGTK
    libGL
    libGLU
  ] ++ lib.optionals (xorg != null) [
    xorg.libX11
  ] ++ lib.optional (unixODBC != null) unixODBC
     ++ lib.optional (openjdk11 != null) openjdk11
     ++ lib.optional (systemd != null && stdenv.isLinux) systemd;

  configureFlags = [
    "--with-ssl=${lib.getOutput "out" openssl}"
    "--with-ssl-incl=${lib.getDev openssl}"
    "--enable-threads"
    "--enable-smp-support"
    "--enable-kernel-poll"
  ] ++ lib.optional (wxGTK != null) "--enable-wx"
    ++ lib.optional (systemd != null && stdenv.isLinux) "--enable-systemd"
    ++ lib.optional stdenv.hostPlatform.isDarwin "--enable-darwin-64bit"
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "--disable-jit";

  # On some machines, parallel build reliably crashes on `GEN asn1ct_eval_ext.erl` step
  enableParallelBuilding = parallelBuild;

  env = {
    # Only build shell/IDE docs and man pages
    DOC_TARGETS = "chunks man";
  };
  
  postPatch = ''
    patchShebangs make
  '';

  # install-docs will generate and install manpages and html docs
  installTargets = [ "install" "install-docs" ];

  postInstall = ''
    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call
  '';

  # Some erlang bin/ scripts run sed and awk
  postFixup = ''
    wrapProgram $out/lib/erlang/bin/erl --prefix PATH ":" "${gnused}/bin/"
    wrapProgram $out/lib/erlang/bin/start_erl --prefix PATH ":" "${lib.makeBinPath [ gnused gawk ]}"
  '';

  meta = with lib; {
    homepage = "https://www.erlang.org/";
    description = "Programming language used for massively scalable soft real-time systems";
    longDescription = ''
      Erlang is a programming language used to build massively scalable
      soft real-time systems with requirements on high availability.
      Some of its uses are in telecoms, banking, e-commerce, computer
      telephony and instant messaging. Erlang's runtime system has
      built-in support for concurrency, distribution and fault
      tolerance.
    '';
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
