{ pkgs, ffiLib, moduleSrc, appSrc }:

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

  postBuild = ''
    cmake -S ${appSrc} -B build-app \
      -DHELLO_FFI_LIB=${ffiLib}/lib/libhello_ffi.so \
      -DHELLO_FFI_INCLUDE=${ffiLib}/include \
      -DMODULE_SRC=${moduleSrc}/src
    cmake --build build-app
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/qml/LezHelloWorld $out/include $out/bin $out/share

    # Install built module libraries
    find . -name '*.so' -exec cp {} $out/lib/ \;

    # Install QML files and module definition
    cp ${moduleSrc}/qml/*.qml $out/qml/LezHelloWorld/
    cp ${moduleSrc}/qml/qmldir $out/qml/LezHelloWorld/

    # Install FFI shared library alongside module
    cp ${ffiLib}/lib/libhello_ffi.so $out/lib/

    # Install headers
    cp ${ffiLib}/include/hello_program.h $out/include/

    # Install standalone app binary
    install -m755 build-app/lez-hello-world-app $out/bin/

    # Install app QML entry point
    cp ${appSrc}/main.qml $out/share/

    runHook postInstall
  '';
}
