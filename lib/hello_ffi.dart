import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';

class HelloFFI {
  static DynamicLibrary? _lib;

  static DynamicLibrary get lib {
    if (_lib == null) {
      if (Platform.isMacOS) {
        // Load from Frameworks folder in app bundle
        // DynamicLibrary.open() searches LD_RUNPATH_SEARCH_PATHS which includes @executable_path/../Frameworks
        _lib = DynamicLibrary.open('libhello.dylib');
      } else if (Platform.isAndroid) {
        // On Android, .so files in jniLibs are automatically loaded from the app's native library directory
        _lib = DynamicLibrary.open('libhello.so');
      } else {
        _lib = DynamicLibrary.process();
      }
    }
    return _lib!;
  }

  static final Pointer<Utf8> Function() _helloWorld = lib
      .lookup<NativeFunction<Pointer<Utf8> Function()>>('HelloWorld')
      .asFunction();

  static final void Function(Pointer<Utf8>) _freeString = lib
      .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('FreeString')
      .asFunction();

  static String helloWorld() {
    final ptr = _helloWorld();
    final result = ptr.toDartString();
    _freeString(ptr);
    return result;
  }
}
