.PHONY: all build-go deps run clean

all: build-go deps

# Build the Go shared library (universal dylib)
build-go:
	cd go_hello && ./build.sh

# Install Flutter dependencies
deps:
	flutter pub get

# Run the macOS app
run: all
	flutter run -d macos

# Clean build artifacts
clean:
	rm -f go_hello/libhello.dylib go_hello/libhello.h
	rm -rf build/
	flutter clean
