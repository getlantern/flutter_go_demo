.PHONY: all build build-go build-go-macos build-go-android deps run run-macos run-android clean

# Detect OS
UNAME_S := $(shell uname -s)

# Default target
all: build deps

# OS-aware build target
ifeq ($(UNAME_S),Darwin)
build: build-go-macos
else
build: build-go-android
endif

# OS-aware run target
ifeq ($(UNAME_S),Darwin)
run: build deps
	flutter run -d macos
else
run: build deps
	flutter run -d android
endif

# Build the Go shared library (universal dylib for macOS)
build-go-macos:
	cd go_hello && ./build.sh

# Alias for backwards compatibility
build-go: build-go-macos

# Build the Go shared libraries for Android (arm64-v8a, x86_64)
build-go-android:
	cd go_hello && ./build_android.sh

# Install Flutter dependencies
deps:
	flutter pub get

# Run the macOS app explicitly
run-macos: build-go-macos deps
	flutter run -d macos

# Run the Android app explicitly
run-android: build-go-android deps
	flutter run -d android

# Clean build artifacts
clean:
	rm -f go_hello/libhello.dylib go_hello/libhello.h
	rm -rf android/app/src/main/jniLibs/
	rm -rf build/
	flutter clean
