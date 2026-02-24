{
  description = "LEZ Hello World - A Logos Core module example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustToolchain = pkgs.rust-bin.stable.latest.default;
      in
      {
        packages = {
          lib = pkgs.rustPlatform.buildRustPackage {
            pname = "hello_ffi";
            version = "0.1.0";
            src = ./.;
            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "nssa_core-0.1.0" = "sha256-GCByTWaLbDObTirW73Sx8cK+mWIIsUjVRime8uTjjMo=";
              };
            };
            buildPhase = ''
              cargo build --release -p hello_ffi
            '';
            installPhase = ''
              mkdir -p $out/lib $out/include
              cp target/release/libhello_ffi.so $out/lib/ 2>/dev/null || \
              cp target/release/libhello_ffi.dylib $out/lib/ 2>/dev/null || true
              cp hello_ffi/include/hello_program.h $out/include/
            '';
          };

          default = self.packages.${system}.lib;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            pkg-config
            openssl
          ];
        };
      }
    );
}
