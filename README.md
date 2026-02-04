# flutter_go_demo

A Flutter application demonstrating how to call Go code from Dart using **direct FFI** on macOS and Android.

## Overview

This project shows how to integrate Go with Flutter using FFI (Foreign Function Interface). Dart calls Go functions directly via the `ffi` package, without needing platform-specific bridge code.

Supported platforms:
- **macOS** - Uses `libhello.dylib` (universal binary for arm64 + x86_64)
- **Android** - Uses `libhello.so` (arm64-v8a for devices, x86_64 for emulators)

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10+)
- [Go](https://go.dev/dl/) (1.18+)
- Xcode (for macOS builds)
- Android SDK with NDK (for Android builds)

## Build Instructions

### Quick Start

```bash
make run
```

This auto-detects your OS, builds the appropriate Go library, and launches the app:
- On **macOS**: Builds dylib and runs on macOS
- On **Linux**: Builds Android .so files and runs on Android emulator/device

### Available Make Targets

| Target | Description |
|--------|-------------|
| `make` | Build Go library for current platform + install Flutter deps |
| `make build` | Build Go library (auto-detects platform) |
| `make run` | Build and run (auto-detects platform) |
| `make build-go-macos` | Build macOS dylib explicitly |
| `make build-go-android` | Build Android .so files explicitly |
| `make run-macos` | Build and run on macOS |
| `make run-android` | Build and run on Android |
| `make deps` | Install Flutter dependencies |
| `make clean` | Remove all build artifacts |

### Platform-Specific Builds

**macOS:**
```bash
make run-macos
# Or manually:
cd go_hello && ./build.sh
flutter run -d macos
```

**Android:**
```bash
make run-android
# Or manually:
cd go_hello && ./build_android.sh
flutter run -d android
```

## Project Structure

```
flutter_go_demo/
├── go_hello/
│   ├── main.go              # Go source with exported functions
│   ├── build.sh             # macOS build script (universal dylib)
│   ├── build_android.sh     # Android build script (arm64, x86_64)
│   ├── libhello.dylib       # Compiled macOS library
│   └── libhello.h           # Generated C header
├── lib/
│   ├── main.dart            # Flutter UI
│   └── hello_ffi.dart       # Dart FFI bindings (handles both platforms)
├── macos/Runner/
│   ├── AppDelegate.swift    # macOS app delegate
│   └── ...
├── android/app/
│   ├── build.gradle.kts     # Android build config (jniLibs)
│   └── src/main/jniLibs/    # Android native libraries
│       ├── arm64-v8a/libhello.so
│       └── x86_64/libhello.so
├── Makefile
└── pubspec.yaml
```

## How It Works

### FFI Path (both platforms)
```
main.dart → hello_ffi.dart → libhello.dylib/.so → Go HelloWorld()
```

The Dart FFI code (`hello_ffi.dart`) loads the appropriate library based on the platform:
- macOS: `DynamicLibrary.open('libhello.dylib')`
- Android: `DynamicLibrary.open('libhello.so')`

### Android NDK Setup

The Android build script automatically finds the NDK in these locations:
1. `$ANDROID_NDK_HOME` environment variable
2. `~/Library/Android/sdk/ndk/<version>/` (Flutter's default location)
3. `$ANDROID_HOME/ndk/<version>/`

If you have issues, set `ANDROID_NDK_HOME` explicitly:
```bash
export ANDROID_NDK_HOME=~/Library/Android/sdk/ndk/25.2.9519653
make build-go-android
```
