# flutter_go_demo

A Flutter application demonstrating how to call Go code from Dart using both **direct FFI** and **Method Channels**.

## Overview

This project shows two approaches to integrate Go with Flutter on macOS:

1. **Direct FFI (Dart → Go)**: Dart calls Go functions directly via FFI using the `ffi` package
2. **Method Channel (Dart → Swift → Go)**: Dart calls Swift via a platform channel, which then calls Go

Both methods use the same Go shared library (`libhello.dylib`).

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10+)
- [Go](https://go.dev/dl/) (1.18+)
- Xcode (for macOS builds)

## Build Instructions

### Quick Start

```bash
make run
```

This builds everything and launches the app.

### Available Make Targets

| Target | Description |
|--------|-------------|
| `make` | Build Go library, copy header, install Flutter deps |
| `make build-go` | Build the Go shared library only |
| `make copy-header` | Copy header to macos/Runner/ |
| `make deps` | Install Flutter dependencies |
| `make run` | Build everything and run the macOS app |
| `make clean` | Remove all build artifacts |

### Manual Steps

If you prefer to build manually:

```bash
# 1. Build Go shared library
cd go_hello && go build -buildmode=c-shared -o libhello.dylib .

# 2. Copy header to macOS runner
cp go_hello/libhello.h macos/Runner/

# 3. Install Flutter dependencies
flutter pub get

# 4. Run the app
flutter run -d macos
```

## Project Structure

```
flutter_go_demo/
├── go_hello/
│   ├── main.go           # Go source with exported functions
│   ├── libhello.dylib    # Compiled shared library
│   └── libhello.h        # Generated C header
├── lib/
│   ├── main.dart         # Flutter UI
│   └── hello_ffi.dart    # Dart FFI bindings
├── macos/Runner/
│   ├── AppDelegate.swift # Method channel handler
│   ├── libhello.h        # Header copy for Swift
│   └── Runner-Bridging-Header.h
├── Makefile
└── pubspec.yaml
```

## How It Works

### FFI Path
`main.dart` → `hello_ffi.dart` → `libhello.dylib` → Go `HelloWorld()`

### Method Channel Path
`main.dart` → `MethodChannel` → `AppDelegate.swift` → `libhello.dylib` → Go `HelloWorld()`
