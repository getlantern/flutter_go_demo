.PHONY: all build-go copy-header deps run clean

all: build-go copy-header deps

# Build the Go shared library
build-go:
	cd go_hello && go build -buildmode=c-shared -o libhello.dylib .

# Copy the header file to macos/Runner for Swift bridging
copy-header: build-go
	cp go_hello/libhello.h macos/Runner/

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
