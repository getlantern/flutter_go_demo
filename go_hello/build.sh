#!/bin/bash
set -e

echo "Building Go static library for arm64..."
CGO_ENABLED=1 GOARCH=arm64 go build -buildmode=c-archive -o libhello_arm64.a main.go

echo "Building Go static library for amd64..."
CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-archive -o libhello_amd64.a main.go

echo "Creating universal binary..."
lipo -create -output libhello.a libhello_arm64.a libhello_amd64.a

echo "Cleaning up..."
rm libhello_arm64.a libhello_amd64.a libhello_arm64.h libhello_amd64.h

echo "Build complete!"
echo "Generated files:"
ls -la libhello.*
file libhello.a
