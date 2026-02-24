{
  description = "LEZ Hello World - A Logos Core module example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, crane, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        craneLib = (crane.mkLib pkgs).overrideToolchain pkgs.rust-bin.stable.latest.default;

        # Include Cargo sources + C headers for FFI
        src = pkgs.lib.cleanSourceWith {
          src = ./.;
          filter = path: type:
            (craneLib.filterCargoSources path type) ||
            (builtins.match ".*\\.h$" path != null);
        };

        ffiLib = import ./nix/ffi.nix { inherit craneLib pkgs src; };
        app = import ./nix/app.nix { inherit pkgs ffiLib; src = pkgs.lib.cleanSource ./.; };
      in
      {
        packages = {
          lib = ffiLib;
          app = app;
          default = app;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (rust-bin.stable.latest.default)
            pkg-config
            openssl
          ];
        };
      }
    );
}
