import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var lifecycleChannel: FlutterMethodChannel?

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    guard let channel = lifecycleChannel else { return .terminateNow }
    channel.invokeMethod("quitRequested", arguments: nil) { _ in
      // A cancelled transfer prompt or a shutdown error keeps the app running.
      // Successful shutdown exits the process after both helpers have stopped.
      NSApp.reply(toApplicationShouldTerminate: false)
    }
    return .terminateLater
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
