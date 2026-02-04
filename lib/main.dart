import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hello_ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Go Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _channel = MethodChannel('hello_channel');

  String _ffiResult = 'Not called yet';
  String _channelResult = 'Not called yet';

  Future<void> _callViaFFI() async {
    try {
      final result = HelloFFI.helloWorld();
      setState(() {
        _ffiResult = result;
      });
    } catch (e) {
      setState(() {
        _ffiResult = 'Error: $e';
      });
    }
  }

  Future<void> _callViaMethodChannel() async {
    try {
      final result = await _channel.invokeMethod<String>('helloWorld');
      setState(() {
        _channelResult = result ?? 'null response';
      });
    } catch (e) {
      setState(() {
        _channelResult = 'Error: $e';
      });
    }
  }

  void _clearResults() {
    setState(() {
      _ffiResult = 'Not called yet';
      _channelResult = 'Not called yet';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter + Go Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Call Go function two ways:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // FFI Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Direct FFI (Dart → Go)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _callViaFFI,
                        child: const Text('Call via FFI'),
                      ),
                      const SizedBox(height: 8),
                      Text('Result: $_ffiResult'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Method Channel Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Method Channel (Dart → Swift → Go)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _callViaMethodChannel,
                        child: const Text('Call via Method Channel'),
                      ),
                      const SizedBox(height: 8),
                      Text('Result: $_channelResult'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Clear Button
              OutlinedButton(
                onPressed: _clearResults,
                child: const Text('Clear Results'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
