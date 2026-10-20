// PasteFerryPicker：快捷粘贴窗口在 Mac 上的原生外壳。
//
// 它是 PasteFerry.app/Contents/Helpers/ 下单独的辅助程序（LSUIElement，不在程序坞出现），
// 由界面登记的 LaunchAgent（com.pasteferry.picker）拉起。界面代码与主 App 是同一份：
// Flutter 引擎与编译好的 Dart 代码直接用主 App 的 Contents/Frameworks/，Dart 收到 --picker 参数
// 就运行快捷窗口。这里只做 Dart 做不了的事：
//   - 全局快捷键（Carbon 的 RegisterEventHotKey，不需要任何权限）
//   - 不抢焦点的窗口（NSPanel + nonactivatingPanel：能接收键盘，原来的 App 一直在前台）
//   - 模拟 ⌘V（CGEvent，需要「辅助功能」权限）
// 见 design/quick-paste-and-favorites.md 第 6.1、7.1 节。由 scripts/build.sh 用 swiftc 编译。

import ApplicationServices
import Carbon.HIToolbox
import Cocoa
import FlutterMacOS

// ─────────────────────────── 快捷键 ───────────────────────────

/// 把设置里的写法（如 "alt+v"，见 ui/lib/hotkey.dart）换成 Carbon 的键码与修饰键。
enum HotkeySpec {
    static func parse(_ s: String) -> (key: UInt32, modifiers: UInt32)? {
        var parts = s.lowercased().split(separator: "+").map(String.init)
        guard let key = parts.popLast(), let code = keyCode(key) else { return nil }
        var mods: UInt32 = 0
        for p in parts {
            switch p {
            case "ctrl": mods |= UInt32(controlKey)
            case "alt": mods |= UInt32(optionKey)
            case "shift": mods |= UInt32(shiftKey)
            case "meta": mods |= UInt32(cmdKey)
            default: return nil
            }
        }
        return (code, mods)
    }

    static let named: [String: Int] = [
        "space": kVK_Space, "tab": kVK_Tab, "enter": kVK_Return, "backspace": kVK_Delete,
        "delete": kVK_ForwardDelete, "home": kVK_Home, "end": kVK_End, "pageup": kVK_PageUp,
        "pagedown": kVK_PageDown, "up": kVK_UpArrow, "down": kVK_DownArrow, "left": kVK_LeftArrow,
        "right": kVK_RightArrow,
        "f1": kVK_F1, "f2": kVK_F2, "f3": kVK_F3, "f4": kVK_F4, "f5": kVK_F5, "f6": kVK_F6,
        "f7": kVK_F7, "f8": kVK_F8, "f9": kVK_F9, "f10": kVK_F10, "f11": kVK_F11, "f12": kVK_F12,
        "f13": kVK_F13, "f14": kVK_F14, "f15": kVK_F15, "f16": kVK_F16, "f17": kVK_F17,
        "f18": kVK_F18, "f19": kVK_F19, "f20": kVK_F20,
    ]

    static let punctuation: [String: String] = [
        "comma": ",", "period": ".", "slash": "/", "semicolon": ";", "quote": "'",
        "bracketleft": "[", "bracketright": "]", "backslash": "\\", "minus": "-", "equal": "=",
        "backquote": "`",
    ]

    static func keyCode(_ key: String) -> UInt32? {
        if let n = named[key] { return UInt32(n) }
        let ch = punctuation[key] ?? key
        guard ch.count == 1 else { return nil }
        return layoutKeyCode(for: ch)
    }

    /// 按当前键盘布局找到打出 ch 的那个键：Dvorak 等布局下字母的位置与 QWERTY 不同。
    /// 中文输入法打开时，这里拿到的是它底下的键盘布局（如 ABC）。
    static func layoutKeyCode(for ch: String) -> UInt32? {
        guard let source = TISCopyCurrentKeyboardLayoutInputSource()?.takeRetainedValue(),
              let raw = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
        else { return ansi[ch] }
        let data = Unmanaged<CFData>.fromOpaque(raw).takeUnretainedValue() as Data
        let found: UInt32? = data.withUnsafeBytes { buf in
            guard let layout = buf.bindMemory(to: UCKeyboardLayout.self).baseAddress else { return nil }
            for code in 0..<128 {
                var dead: UInt32 = 0
                var length = 0
                var chars = [UniChar](repeating: 0, count: 4)
                let status = UCKeyTranslate(layout, UInt16(code), UInt16(kUCKeyActionDisplay), 0,
                                            UInt32(LMGetKbdType()), OptionBits(kUCKeyTranslateNoDeadKeysBit),
                                            &dead, chars.count, &length, &chars)
                if status == noErr, length > 0,
                   String(utf16CodeUnits: chars, count: length).lowercased() == ch {
                    return UInt32(code)
                }
            }
            return nil
        }
        return found ?? ansi[ch]
    }

    static let ansi: [String: UInt32] = {
        let pairs: [(String, Int)] = [
            ("a", kVK_ANSI_A), ("b", kVK_ANSI_B), ("c", kVK_ANSI_C), ("d", kVK_ANSI_D), ("e", kVK_ANSI_E),
            ("f", kVK_ANSI_F), ("g", kVK_ANSI_G), ("h", kVK_ANSI_H), ("i", kVK_ANSI_I), ("j", kVK_ANSI_J),
            ("k", kVK_ANSI_K), ("l", kVK_ANSI_L), ("m", kVK_ANSI_M), ("n", kVK_ANSI_N), ("o", kVK_ANSI_O),
            ("p", kVK_ANSI_P), ("q", kVK_ANSI_Q), ("r", kVK_ANSI_R), ("s", kVK_ANSI_S), ("t", kVK_ANSI_T),
            ("u", kVK_ANSI_U), ("v", kVK_ANSI_V), ("w", kVK_ANSI_W), ("x", kVK_ANSI_X), ("y", kVK_ANSI_Y),
            ("z", kVK_ANSI_Z), ("0", kVK_ANSI_0), ("1", kVK_ANSI_1), ("2", kVK_ANSI_2), ("3", kVK_ANSI_3),
            ("4", kVK_ANSI_4), ("5", kVK_ANSI_5), ("6", kVK_ANSI_6), ("7", kVK_ANSI_7), ("8", kVK_ANSI_8),
            ("9", kVK_ANSI_9), (",", kVK_ANSI_Comma), (".", kVK_ANSI_Period), ("/", kVK_ANSI_Slash),
            (";", kVK_ANSI_Semicolon), ("'", kVK_ANSI_Quote), ("[", kVK_ANSI_LeftBracket),
            ("]", kVK_ANSI_RightBracket), ("\\", kVK_ANSI_Backslash), ("-", kVK_ANSI_Minus),
            ("=", kVK_ANSI_Equal), ("`", kVK_ANSI_Grave),
        ]
        return Dictionary(uniqueKeysWithValues: pairs.map { ($0.0, UInt32($0.1)) })
    }()
}

/// 一个全局快捷键。Carbon 的回调是 C 函数，按下时转到 onPress。
final class GlobalHotkey {
    static let shared = GlobalHotkey()
    var onPress: (() -> Void)?
    private var ref: EventHotKeyRef?
    private var installed = false

    func register(key: UInt32, modifiers: UInt32) -> OSStatus {
        unregister()
        if !installed {
            var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
            let status = InstallEventHandler(GetApplicationEventTarget(), { _, _, _ in
                DispatchQueue.main.async { GlobalHotkey.shared.onPress?() }
                return noErr
            }, 1, &spec, nil, nil)
            if status != noErr { NSLog("安装快捷键回调失败：%d", status) }
            installed = true
        }
        let id = EventHotKeyID(signature: OSType(0x5046_5153), id: 1) // 'PFQS'
        return RegisterEventHotKey(key, modifiers, id, GetApplicationEventTarget(), 0, &ref)
    }

    func unregister() {
        if let ref { UnregisterEventHotKey(ref) }
        ref = nil
    }
}

// ─────────────────────────── 窗口 ───────────────────────────

/// 无边框、不抢焦点的面板：能成为接收键盘的窗口，但不会把隔空贴激活到前台。
final class PickerPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

final class PickerController: NSObject, NSWindowDelegate {
    static let size = NSSize(width: 560, height: 460)

    let engine: FlutterEngine
    let flutter: FlutterViewController
    let panel: PickerPanel
    let channel: FlutterMethodChannel

    private var dartReady = false
    private var pendingShow = false
    private var suspended = false
    private var hotkey: (key: UInt32, modifiers: UInt32)?
    private var hotkeyName = ""
    /// 呼出时在前台的 App：粘贴时确认焦点回到了它
    private var previousApp: NSRunningApplication?

    init(project: FlutterDartProject) {
        engine = FlutterEngine(name: "picker", project: project)
        engine.run(withEntrypoint: nil)
        flutter = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        flutter.backgroundColor = .clear
        flutter.mouseTrackingMode = .always
        panel = PickerPanel(contentRect: NSRect(origin: .zero, size: Self.size),
                            styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
        channel = FlutterMethodChannel(name: "pasteferry/picker", binaryMessenger: engine.binaryMessenger)
        super.init()

        panel.contentViewController = flutter
        panel.setContentSize(Self.size)
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.level = .floating
        panel.hidesOnDeactivate = false
        panel.isMovableByWindowBackground = false
        // 每个桌面空间里都能呼出，全屏 App 上面也能出现
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        panel.delegate = self

        channel.setMethodCallHandler { [weak self] call, result in self?.handle(call, result) }
        GlobalHotkey.shared.onPress = { [weak self] in self?.toggle() }
    }

    // ── Dart → 原生 ──

    private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {
        case "setHotkey":
            result(setHotkey(args["hotkey"] as? String ?? "", enabled: args["enabled"] as? Bool ?? false))
        case "setSuspended":
            suspended = args["suspended"] as? Bool ?? false
            applyHotkey()
            result(nil)
        case "pasteStatus":
            let trusted = AXIsProcessTrusted()
            result(["available": trusted, "reason": trusted ? "" : "not_trusted"])
        case "requestPermission":
            requestAccessibility()
            result(nil)
        case "show":
            show()
            result(nil)
        case "hide":
            hide(notify: false)
            result(nil)
        case "commit":
            commit(paste: args["paste"] as? Bool ?? false, result)
        case "ready":
            dartReady = true
            NSLog("快捷粘贴窗口已就绪")
            if pendingShow { pendingShow = false; show() }
            result(nil)
        case "quit":
            GlobalHotkey.shared.unregister()
            result(nil)
            DispatchQueue.main.async { exit(0) }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setHotkey(_ name: String, enabled: Bool) -> [String: Any] {
        guard enabled else {
            hotkey = nil
            hotkeyName = ""
            GlobalHotkey.shared.unregister()
            return ["ok": true, "error": "", "source": "native", "hotkey": ""]
        }
        guard let spec = HotkeySpec.parse(name) else {
            return ["ok": false, "error": "invalid", "source": "native", "hotkey": name]
        }
        hotkey = spec
        hotkeyName = name
        let status = applyHotkey()
        if status == noErr {
            NSLog("快捷键 %@ 已注册", name)
            return ["ok": true, "error": "", "source": "native", "hotkey": name]
        }
        let error = status == OSStatus(eventHotKeyExistsErr) ? "in_use" : "\(status)"
        return ["ok": false, "error": error, "source": "native", "hotkey": name]
    }

    @discardableResult
    private func applyHotkey() -> OSStatus {
        guard let hotkey, !suspended else {
            GlobalHotkey.shared.unregister()
            return noErr
        }
        let status = GlobalHotkey.shared.register(key: hotkey.key, modifiers: hotkey.modifiers)
        if status != noErr { NSLog("注册快捷键 %@ 失败：%d", hotkeyName, status) }
        return status
    }

    /// 第一次请求时系统弹窗并把快捷窗口加进「辅助功能」列表；之后再请求只能打开系统设置让用户自己开。
    private func requestAccessibility() {
        let key = "accessibilityPrompted"
        if !UserDefaults.standard.bool(forKey: key) {
            UserDefaults.standard.set(true, forKey: key)
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
            _ = AXIsProcessTrustedWithOptions(options)
            return
        }
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    // ── 显示与隐藏 ──

    private func toggle() {
        if panel.isVisible { hide(notify: true) } else { show() }
    }

    private func show() {
        guard dartReady else { pendingShow = true; return }
        let front = NSWorkspace.shared.frontmostApplication
        if front?.processIdentifier != ProcessInfo.processInfo.processIdentifier { previousApp = front }
        place()
        channel.invokeMethod("onShow", arguments: nil)
        panel.makeKeyAndOrderFront(nil)
        panel.makeFirstResponder(flutter.view)
        panel.invalidateShadow()
        NSLog("呼出快捷窗口，原来在前台的是 %@，窗口 key=%d", previousApp?.localizedName ?? "-", panel.isKeyWindow ? 1 : 0)
    }

    /// 鼠标所在屏幕的中上方，与聚焦搜索的位置一样。
    private func place() {
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main
        guard let area = screen?.visibleFrame else { return }
        let x = area.midX - Self.size.width / 2
        let y = area.maxY - area.height * 0.22 - Self.size.height
        panel.setFrameOrigin(NSPoint(x: x.rounded(), y: max(area.minY, y).rounded()))
    }

    private func hide(notify: Bool) {
        guard panel.isVisible else { return }
        panel.orderOut(nil)
        if notify { channel.invokeMethod("onHide", arguments: nil) }
    }

    /// 点了窗口外面、切到别的 App：收起，什么都不粘贴。
    func windowDidResignKey(_ notification: Notification) {
        if panel.isVisible { NSLog("快捷窗口失去焦点，收起") }
        hide(notify: true)
    }

    // ── 粘贴 ──

    /// 收起窗口，焦点回到原来的 App（面板不抢焦点，原来的 App 本来就还在前台），再模拟 ⌘V。
    private func commit(paste: Bool, _ result: @escaping FlutterResult) {
        let target = previousApp
        hide(notify: false)
        guard paste else { result(["pasted": false, "reason": ""]); return }
        guard AXIsProcessTrusted() else { result(["pasted": false, "reason": "not_trusted"]); return }
        if let target, NSWorkspace.shared.frontmostApplication != target {
            target.activate()
        }
        waitFor(target, deadline: Date().addingTimeInterval(0.3)) {
            Self.postPaste()
            result(["pasted": true, "reason": ""])
        }
    }

    /// 等目标 App 确实回到前台，最多等到 deadline；面板收起后键盘焦点要一小会儿才交回去。
    private func waitFor(_ app: NSRunningApplication?, deadline: Date, then: @escaping () -> Void) {
        let ready = app == nil || NSWorkspace.shared.frontmostApplication == app
        if ready || Date() > deadline {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: then)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { self.waitFor(app, deadline: deadline, then: then) }
    }

    /// 发一次 ⌘V。标志位只设 ⌘：用户还按着 ⌥ 时也不带进去。键码按当前键盘布局找「v」。
    static func postPaste() {
        let v = CGKeyCode(HotkeySpec.layoutKeyCode(for: "v") ?? UInt32(kVK_ANSI_V))
        let source = CGEventSource(stateID: .combinedSessionState)
        for down in [true, false] {
            guard let e = CGEvent(keyboardEventSource: source, virtualKey: v, keyDown: down) else { continue }
            e.flags = .maskCommand
            e.post(tap: .cghidEventTap)
        }
    }
}

// ─────────────────────────── 启动 ───────────────────────────

final class PickerApp: NSObject, NSApplicationDelegate {
    var controller: PickerController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 只运行一个：LaunchAgent 之外又被拉起一次时，让先启动的那个继续
        let me = ProcessInfo.processInfo.processIdentifier
        let others = NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier ?? "")
        if others.contains(where: { $0.processIdentifier != me }) {
            NSLog("已有快捷粘贴窗口在运行，本进程退出")
            exit(0)
        }
        // …/PasteFerry.app/Contents/Helpers/PasteFerryPicker.app → …/PasteFerry.app
        let mainApp = Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let appFramework = mainApp.appendingPathComponent("Contents/Frameworks/App.framework")
        guard let dart = Bundle(url: appFramework) else {
            NSLog("找不到 %@，快捷粘贴窗口要放在 PasteFerry.app 里面运行", appFramework.path)
            exit(1)
        }
        let project = FlutterDartProject(precompiledDartBundle: dart)
        project.dartEntrypointArguments = ["--picker"]
        controller = PickerController(project: project)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = PickerApp()
app.delegate = delegate
app.run()
