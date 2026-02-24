{ pkgs, ffiLib, moduleSrc }:

pkgs.stdenv.mkDerivation {
  pname = "lez-hello-world-module";
  version = "0.1.0";

  src = moduleSrc;

  nativeBuildInputs = with pkgs; [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    "-DHELLO_FFI_LIB=${ffiLib}/lib/libhello_ffi.so"
    "-DHELLO_FFI_INCLUDE=${ffiLib}/include"
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/qml/LezHelloWorld $out/include

    # Install built module libraries
    find . -name '*.so' -exec cp {} $out/lib/ \;

    # Install QML files
    cp ${moduleSrc}/qml/*.qml $out/qml/LezHelloWorld/

    # Install FFI shared library alongside module
    cp ${ffiLib}/lib/libhello_ffi.so $out/lib/

    # Install headers
    cp ${ffiLib}/include/hello_program.h $out/include/

    runHook postInstall
  '';
}
