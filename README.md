# LEZ Hello World

A complete Logos Core module example: store your name in a PDA via transaction and read it back as "Hello \<name\>!".

## Architecture

```
hello_core/       — Shared types (HelloInstruction, HelloState, PDA seeds)
hello_program/    — On-chain instruction processing (StoreName)
hello_ffi/        — C FFI bindings (cdylib) for Qt integration
methods/guest/    — risc0 zkVM guest binary
module/           — Qt/QML plugin (Bridge, QML views, CMake)
```

## Build

### Rust (FFI library)

```bash
cargo build --release -p hello_ffi
```

### Tests

```bash
cargo test -p hello_program
```

### zkVM guest

```bash
cargo risczero build --manifest-path methods/guest/Cargo.toml
```

### Qt module

```bash
cd module
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/qt6
make
```

### Nix

```bash
nix build .#lib
```

## Usage

Submit a name via the GUI text field or FFI:

```json
{"name": "World"}
```

Read it back to get:

```json
{"greeting": "Hello World!", "name": "World"}
```
