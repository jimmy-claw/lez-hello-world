{ pkgs, ffiLib, src }:

pkgs.stdenv.mkDerivation {
  pname = "lez-hello-world-app";
  version = "0.1.0";

  inherit src;

  nativeBuildInputs = with pkgs; [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  configurePhase = ''
    runHook preConfigure
    cmake -S app -B build-app \
      -DCMAKE_BUILD_TYPE=Release \
      -DHELLO_FFI_LIB=${ffiLib}/lib/libhello_ffi.so \
      -DHELLO_FFI_INCLUDE=${ffiLib}/include
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build build-app
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cmake --install build-app --prefix $out
    cp ${ffiLib}/lib/libhello_ffi.so $out/bin/
    runHook postInstall
  '';
}
