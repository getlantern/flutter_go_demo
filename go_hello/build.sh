#!/bin/bash
set -e

echo "Building Go dynamic library for arm64..."
CGO_ENABLED=1 GOARCH=arm64 go build -buildmode=c-shared -o libhello_arm64.dylib main.go

echo "Building Go dynamic library for amd64..."
CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-shared -o libhello_amd64.dylib main.go

echo "Creating universal binary..."
lipo -create -output libhello.dylib libhello_arm64.dylib libhello_amd64.dylib

echo "Setting install name for runtime loading from Frameworks folder..."
install_name_tool -id "@executable_path/../Frameworks/libhello.dylib" libhello.dylib

echo "Cleaning up..."
mv libhello_arm64.h libhello.h
rm libhello_arm64.dylib libhello_amd64.dylib libhello_amd64.h

echo "Build complete!"
echo "Generated files:"
ls -la libhello.*
file libhello.dylib
