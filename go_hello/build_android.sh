#!/bin/bash
set -e

# Android NDK cross-compilation script for Go shared library

# Find Android NDK
if [ -n "$ANDROID_NDK_HOME" ]; then
    NDK_ROOT="$ANDROID_NDK_HOME"
elif [ -d "$HOME/Library/Android/sdk/ndk" ]; then
    # Find the latest NDK version in the default Flutter/Android SDK location
    NDK_ROOT=$(ls -d "$HOME/Library/Android/sdk/ndk"/*/ 2>/dev/null | sort -V | tail -1 | sed 's:/$::')
elif [ -d "$ANDROID_HOME/ndk" ]; then
    NDK_ROOT=$(ls -d "$ANDROID_HOME/ndk"/*/ 2>/dev/null | sort -V | tail -1 | sed 's:/$::')
else
    echo "Error: Cannot find Android NDK. Set ANDROID_NDK_HOME or install NDK via Android Studio."
    exit 1
fi

echo "Using Android NDK at: $NDK_ROOT"

# Detect host OS for NDK toolchain
case "$(uname -s)" in
    Darwin*)  HOST_TAG="darwin-x86_64" ;;
    Linux*)   HOST_TAG="linux-x86_64" ;;
    *)        echo "Unsupported host OS"; exit 1 ;;
esac

TOOLCHAIN="$NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG"
if [ ! -d "$TOOLCHAIN" ]; then
    echo "Error: NDK toolchain not found at $TOOLCHAIN"
    exit 1
fi

# Output directory for .so files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
JNILIBS_DIR="$PROJECT_ROOT/android/app/src/main/jniLibs"

# API level (21 is minimum for 64-bit support)
API_LEVEL=21

build_arch() {
    local GOARCH=$1
    local ANDROID_ARCH=$2
    local CC_PREFIX=$3

    echo "Building for $ANDROID_ARCH (GOARCH=$GOARCH)..."

    local OUTPUT_DIR="$JNILIBS_DIR/$ANDROID_ARCH"
    mkdir -p "$OUTPUT_DIR"

    CC="$TOOLCHAIN/bin/${CC_PREFIX}${API_LEVEL}-clang" \
    CGO_ENABLED=1 \
    GOOS=android \
    GOARCH=$GOARCH \
    go build -buildmode=c-shared -o "$OUTPUT_DIR/libhello.so" main.go

    # Remove the generated header (we only need it once)
    rm -f "$OUTPUT_DIR/libhello.h"

    echo "  -> $OUTPUT_DIR/libhello.so"
}

echo "Building Go shared libraries for Android..."
echo ""

# Build for arm64-v8a (modern Android devices)
build_arch "arm64" "arm64-v8a" "aarch64-linux-android"

# Build for x86_64 (Android emulators)
build_arch "amd64" "x86_64" "x86_64-linux-android"

echo ""
echo "Build complete! Generated files:"
find "$JNILIBS_DIR" -name "*.so" -exec ls -la {} \;
