{ craneLib, pkgs, src }:

let
  vendorDir = craneLib.vendorCargoDeps {
    inherit src;
    outputHashes = {
      "nssa_core-0.1.0" = "sha256-GCByTWaLbDObTirW73Sx8cK+mWIIsUjVRime8uTjjMo=";
    };
  };

  commonArgs = {
    inherit src;
    cargoVendorDir = vendorDir;
    pname = "hello_ffi";
    version = "0.1.0";
    strictDeps = true;
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

in craneLib.buildPackage (commonArgs // {
  inherit cargoArtifacts;
  cargoExtraArgs = "-p hello_ffi";

  installPhaseCommand = ''
    mkdir -p $out/lib $out/include
    cp target/release/libhello_ffi.so $out/lib/ 2>/dev/null || \
    cp target/release/libhello_ffi.dylib $out/lib/ 2>/dev/null || true
    cp hello_ffi/include/hello_program.h $out/include/
  '';

  doCheck = false;
})
