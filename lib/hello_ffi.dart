import 'dart:ffi';
import 'package:ffi/ffi.dart';

class HelloFFI {
  static DynamicLibrary? _lib;

  static DynamicLibrary get lib {
    _lib ??= DynamicLibrary.process();
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
