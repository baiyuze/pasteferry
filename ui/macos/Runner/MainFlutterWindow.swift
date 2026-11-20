import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow, NSWindowDelegate {
  private var lifecycleChannel: FlutterMethodChannel?

  /// 100% 时的最小尺寸，界面缩放时乘以倍数（Dart 那边按 mainContentMinSize 判断装不装得下）
  private static let baseMinSize = NSSize(width: 760, height: 520)

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    lifecycleChannel?.invokeMethod("closeRequested", arguments: nil)
    return false
  }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // 标题栏透明、内容铺到窗口顶部：侧边栏一直延伸到红绿灯下面，
    // 与「系统设置」「备忘录」等自带应用的窗口形态一致
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.styleMask.insert(.fullSizeContentView)

    self.minSize = Self.baseMinSize
    self.setContentSize(NSSize(width: 960, height: 640))
    self.center()
    // 记住用户调整过的窗口大小与位置
    self.setFrameAutosaveName("PasteFerryMainWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(name: "com.pasteferry.app/lifecycle",
                                       binaryMessenger: flutterViewController.engine.binaryMessenger)
    lifecycleChannel = channel
    (NSApp.delegate as? AppDelegate)?.lifecycleChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "hideWindow" {
        self?.orderOut(nil)
        result(nil)
      } else if call.method == "setUiScale" {
        let scale = (call.arguments as? [String: Any])?["scale"] as? Double ?? 1
        self?.applyUiScale(CGFloat(scale))
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    super.awakeFromNib()
    self.delegate = self
  }

  /// 界面缩放（设置 →「外观」）：最小尺寸跟着放大，窗口比它小时放大窗口，左上角不动。
  /// 都不超出屏幕；屏幕放不下时 Flutter 那边自己降倍数
  private func applyUiScale(_ scale: CGFloat) {
    let area = (self.screen ?? NSScreen.main)?.visibleFrame ?? .infinite
    let min = NSSize(width: Swift.min((Self.baseMinSize.width * scale).rounded(), area.width),
                     height: Swift.min((Self.baseMinSize.height * scale).rounded(), area.height))
    self.minSize = min
    let size = self.frame.size
    guard size.width < min.width || size.height < min.height else { return }
    var f = NSRect(x: self.frame.minX, y: self.frame.maxY, width: Swift.max(size.width, min.width),
                   height: Swift.max(size.height, min.height))
    f.origin.y -= f.height
    // 放大以后超出屏幕的话往回挪
    if f.maxX > area.maxX { f.origin.x = area.maxX - f.width }
    if f.minY < area.minY { f.origin.y = area.minY }
    f.origin.x = Swift.max(f.origin.x, area.minX)
    if f.maxY > area.maxY { f.origin.y = area.maxY - f.height }
    self.setFrame(f, display: true, animate: true)
  }
}
