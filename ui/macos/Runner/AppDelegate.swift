import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var lifecycleChannel: FlutterMethodChannel?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // FlutterAppDelegate does not implement this optional Cocoa callback.
    // Sending it to super raises an Objective-C exception before registration.
    NSApp.servicesProvider = self
    NSUpdateDynamicServices()
  }

  /// Services can launch the app before Flutter is ready. An atomic local
  /// request is picked up by both the cold-start scan and the live watcher.
  @objc func sendWithPasteFerry(_ pasteboard: NSPasteboard, userData: String?,
                               error: AutoreleasingUnsafeMutablePointer<NSString?>) {
    let urls = (pasteboard.readObjects(forClasses: [NSURL.self], options:
      [.urlReadingFileURLsOnly: true]) as? [URL]) ?? []
    let legacy = pasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String] ?? []
    let paths = urls.isEmpty ? legacy : urls.filter { $0.isFileURL }.map { $0.path }
    guard !paths.isEmpty, paths.count <= 10000 else {
      error.pointee = Bundle.main.localizedString(forKey: "shareFilesOnly",
        value: "Share files, photos or videos. Text and links are not supported yet.",
        table: "ServicesMenu") as NSString
      return
    }
    do {
      let home = ProcessInfo.processInfo.environment["HOME"] ?? NSHomeDirectory()
      let root = URL(fileURLWithPath: home, isDirectory: true)
        .appendingPathComponent("Library/Application Support/PasteFerry/share-inbox", isDirectory: true)
      try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true,
        attributes: [.posixPermissions: 0o700])
      let id = UUID().uuidString.lowercased()
      let body = try JSONSerialization.data(withJSONObject: ["id": id, "paths": Array(Set(paths)),
        "createdAt": Int64(Date().timeIntervalSince1970 * 1000)])
      guard body.count <= 2 * 1024 * 1024 else { throw CocoaError(.fileWriteFileExists) }
      let temp = root.appendingPathComponent(id + ".tmp")
      try body.write(to: temp, options: .atomic)
      try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: temp.path)
      try FileManager.default.moveItem(at: temp, to: root.appendingPathComponent(id + ".json"))
      mainFlutterWindow?.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    } catch let failure {
      error.pointee = failure.localizedDescription as NSString
    }
  }

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
