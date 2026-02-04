import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController

    let channel = FlutterMethodChannel(
      name: "hello_channel",
      binaryMessenger: controller.engine.binaryMessenger
    )

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "helloWorld" {
        if let msg = HelloWorld() {
          let str = String(cString: msg)
          FreeString(msg)
          result(str)
        } else {
          result(FlutterError(code: "ERROR", message: "HelloWorld returned nil", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
