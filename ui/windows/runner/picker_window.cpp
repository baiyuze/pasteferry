#include "picker_window.h"

#include <dwmapi.h>
#include <flutter/standard_method_codec.h>
#include <flutter_windows.h>

#include <algorithm>
#include <cctype>
#include <map>
#include <vector>

namespace {

constexpr wchar_t kWindowClass[] = L"PASTEFERRY_PICKER_WINDOW";
// 不能叫「PasteFerry」：主程序再次打开时按这个标题找已有的主窗口（见 main.cpp）
constexpr wchar_t kWindowTitle[] = L"PasteFerry Quick Paste";
constexpr int kWidth = 560;
constexpr int kHeight = 460;
constexpr int kHotkeyId = 1;

#ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#define DWMWA_WINDOW_CORNER_PREFERENCE 33
#endif
constexpr int kDwmRound = 2;  // DWMWCP_ROUND

using flutter::EncodableMap;
using flutter::EncodableValue;

EncodableValue Str(const char* s) { return EncodableValue(std::string(s)); }

const EncodableValue* Arg(const flutter::MethodCall<EncodableValue>& call, const char* key) {
  const auto* map = std::get_if<EncodableMap>(call.arguments());
  if (!map) return nullptr;
  auto it = map->find(Str(key));
  return it == map->end() ? nullptr : &it->second;
}

bool BoolArg(const flutter::MethodCall<EncodableValue>& call, const char* key) {
  const auto* v = Arg(call, key);
  const auto* b = v ? std::get_if<bool>(v) : nullptr;
  return b && *b;
}

std::string StringArg(const flutter::MethodCall<EncodableValue>& call, const char* key) {
  const auto* v = Arg(call, key);
  const auto* s = v ? std::get_if<std::string>(v) : nullptr;
  return s ? *s : std::string();
}

// 设置里的写法（如 "alt+v"，见 lib/hotkey.dart）→ RegisterHotKey 的修饰键与虚拟键码。
bool ParseHotkey(const std::string& name, UINT* modifiers, UINT* vk) {
  std::vector<std::string> parts;
  size_t start = 0;
  while (true) {
    size_t plus = name.find('+', start);
    parts.push_back(name.substr(start, plus == std::string::npos ? std::string::npos : plus - start));
    if (plus == std::string::npos) break;
    start = plus + 1;
  }
  if (parts.empty()) return false;
  const std::string key = parts.back();
  parts.pop_back();
  UINT mods = MOD_NOREPEAT;
  for (const auto& p : parts) {
    if (p == "ctrl") mods |= MOD_CONTROL;
    else if (p == "alt") mods |= MOD_ALT;
    else if (p == "shift") mods |= MOD_SHIFT;
    else if (p == "meta") mods |= MOD_WIN;
    else return false;
  }
  static const std::map<std::string, UINT> named = {
      {"space", VK_SPACE}, {"tab", VK_TAB}, {"enter", VK_RETURN}, {"backspace", VK_BACK},
      {"delete", VK_DELETE}, {"insert", VK_INSERT}, {"home", VK_HOME}, {"end", VK_END},
      {"pageup", VK_PRIOR}, {"pagedown", VK_NEXT}, {"up", VK_UP}, {"down", VK_DOWN},
      {"left", VK_LEFT}, {"right", VK_RIGHT},
  };
  static const std::map<std::string, wchar_t> punctuation = {
      {"comma", L','}, {"period", L'.'}, {"slash", L'/'}, {"semicolon", L';'}, {"quote", L'\''},
      {"bracketleft", L'['}, {"bracketright", L']'}, {"backslash", L'\\'}, {"minus", L'-'},
      {"equal", L'='}, {"backquote", L'`'},
  };
  UINT code = 0;
  if (key.size() == 1 && key[0] >= 'a' && key[0] <= 'z') {
    code = 'A' + (key[0] - 'a');
  } else if (key.size() == 1 && key[0] >= '0' && key[0] <= '9') {
    code = key[0];
  } else if (key.size() >= 2 && key.size() <= 3 && key[0] == 'f' &&
             std::all_of(key.begin() + 1, key.end(), [](char c) { return std::isdigit(static_cast<unsigned char>(c)) != 0; })) {
    int n = std::stoi(key.substr(1));
    if (n < 1 || n > 24) return false;
    code = VK_F1 + n - 1;
  } else if (auto it = named.find(key); it != named.end()) {
    code = it->second;
  } else if (auto pit = punctuation.find(key); pit != punctuation.end()) {
    // 标点在不同键盘布局上的位置不同，按当前布局查
    SHORT scan = ::VkKeyScanW(pit->second);
    if (scan == -1) return false;
    code = LOBYTE(scan);
  } else {
    return false;
  }
  *modifiers = mods;
  *vk = code;
  return true;
}

// 目标窗口所在的进程是否以管理员身份运行。普通权限的程序发不了按键给它（UIPI），而且 SendInput 不报错。
bool IsElevatedWindow(HWND hwnd) {
  DWORD pid = 0;
  ::GetWindowThreadProcessId(hwnd, &pid);
  if (!pid) return false;
  HANDLE process = ::OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid);
  if (!process) return ::GetLastError() == ERROR_ACCESS_DENIED;
  bool elevated = false;
  HANDLE token = nullptr;
  if (::OpenProcessToken(process, TOKEN_QUERY, &token)) {
    TOKEN_ELEVATION info{};
    DWORD size = 0;
    if (::GetTokenInformation(token, TokenElevation, &info, sizeof(info), &size)) {
      elevated = info.TokenIsElevated != 0;
    }
    ::CloseHandle(token);
  } else {
    elevated = ::GetLastError() == ERROR_ACCESS_DENIED;
  }
  ::CloseHandle(process);
  return elevated;
}

bool SelfElevated() {
  HANDLE token = nullptr;
  if (!::OpenProcessToken(::GetCurrentProcess(), TOKEN_QUERY, &token)) return false;
  TOKEN_ELEVATION info{};
  DWORD size = 0;
  bool elevated = ::GetTokenInformation(token, TokenElevation, &info, sizeof(info), &size) &&
                  info.TokenIsElevated != 0;
  ::CloseHandle(token);
  return elevated;
}

INPUT Key(WORD vk, bool up) {
  INPUT in{};
  in.type = INPUT_KEYBOARD;
  in.ki.wVk = vk;
  in.ki.dwFlags = up ? KEYEVENTF_KEYUP : 0;
  return in;
}

// 发一次 Ctrl+V。用户还按着修饰键（比如用 Alt+数字 选的）时先松开：
// 单独松开 Alt 或 Win 会让目标程序打开菜单或开始菜单，所以先插一个没有作用的按键（AutoHotkey 的做法）。
void SendPaste() {
  std::vector<INPUT> inputs;
  const bool alt = ::GetAsyncKeyState(VK_MENU) & 0x8000;
  const bool win = (::GetAsyncKeyState(VK_LWIN) & 0x8000) || (::GetAsyncKeyState(VK_RWIN) & 0x8000);
  if (alt || win) {
    constexpr WORD kMask = 0xE8;  // 未分配的虚拟键码
    inputs.push_back(Key(kMask, false));
    inputs.push_back(Key(kMask, true));
  }
  if (alt) inputs.push_back(Key(VK_MENU, true));
  if (::GetAsyncKeyState(VK_LWIN) & 0x8000) inputs.push_back(Key(VK_LWIN, true));
  if (::GetAsyncKeyState(VK_RWIN) & 0x8000) inputs.push_back(Key(VK_RWIN, true));
  if (::GetAsyncKeyState(VK_SHIFT) & 0x8000) inputs.push_back(Key(VK_SHIFT, true));
  inputs.push_back(Key(VK_CONTROL, false));
  inputs.push_back(Key('V', false));
  inputs.push_back(Key('V', true));
  inputs.push_back(Key(VK_CONTROL, true));
  ::SendInput(static_cast<UINT>(inputs.size()), inputs.data(), sizeof(INPUT));
}

// 把窗口切到前台。刚收到快捷键的进程本来就有这个权限；从命令（设置页的按钮）呼出时没有，
// 借前台窗口的输入队列一用。
void BringToFront(HWND hwnd) {
  if (::SetForegroundWindow(hwnd)) return;
  HWND fg = ::GetForegroundWindow();
  DWORD fg_thread = fg ? ::GetWindowThreadProcessId(fg, nullptr) : 0;
  DWORD me = ::GetCurrentThreadId();
  if (fg_thread && fg_thread != me) ::AttachThreadInput(me, fg_thread, TRUE);
  ::BringWindowToTop(hwnd);
  ::SetForegroundWindow(hwnd);
  if (fg_thread && fg_thread != me) ::AttachThreadInput(me, fg_thread, FALSE);
}

}  // namespace

PickerWindow::PickerWindow(const flutter::DartProject& project) : project_(project) {}

PickerWindow::~PickerWindow() {
  if (registered_) ::UnregisterHotKey(hwnd_, kHotkeyId);
  channel_ = nullptr;
  controller_ = nullptr;
  if (hwnd_) ::DestroyWindow(hwnd_);
}

bool PickerWindow::Create() {
  WNDCLASSEXW wc{sizeof(wc)};
  wc.lpfnWndProc = WndProc;
  wc.hInstance = ::GetModuleHandleW(nullptr);
  wc.hCursor = ::LoadCursor(nullptr, IDC_ARROW);
  wc.hIcon = ::LoadIcon(wc.hInstance, MAKEINTRESOURCE(101));
  wc.lpszClassName = kWindowClass;
  ::RegisterClassExW(&wc);

  const double scale = FlutterDesktopGetDpiForMonitor(::MonitorFromPoint({0, 0}, MONITOR_DEFAULTTOPRIMARY)) / 96.0;
  const int w = static_cast<int>(kWidth * scale);
  const int h = static_cast<int>(kHeight * scale);
  hwnd_ = ::CreateWindowExW(WS_EX_TOOLWINDOW | WS_EX_TOPMOST, kWindowClass, kWindowTitle,
                            WS_POPUP | WS_CLIPCHILDREN, 0, 0, w, h, nullptr, nullptr, wc.hInstance, this);
  if (!hwnd_) return false;
  // Windows 11 上让系统画圆角；Windows 10 上没有这个属性，保持直角
  int corner = kDwmRound;
  ::DwmSetWindowAttribute(hwnd_, DWMWA_WINDOW_CORNER_PREFERENCE, &corner, sizeof(corner));

  controller_ = std::make_unique<flutter::FlutterViewController>(w, h, project_);
  if (!controller_->engine() || !controller_->view()) return false;
  HWND view = controller_->view()->GetNativeWindow();
  ::SetParent(view, hwnd_);
  ResizeChild();

  channel_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      controller_->engine()->messenger(), "pasteferry/picker", &flutter::StandardMethodCodec::GetInstance());
  channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) { HandleMethodCall(call, std::move(result)); });
  return true;
}

LRESULT CALLBACK PickerWindow::WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  if (message == WM_NCCREATE) {
    auto* cs = reinterpret_cast<CREATESTRUCT*>(lparam);
    ::SetWindowLongPtr(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(cs->lpCreateParams));
  }
  auto* self = reinterpret_cast<PickerWindow*>(::GetWindowLongPtr(hwnd, GWLP_USERDATA));
  if (self) return self->HandleMessage(hwnd, message, wparam, lparam);
  return ::DefWindowProc(hwnd, message, wparam, lparam);
}

LRESULT PickerWindow::HandleMessage(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  if (controller_) {
    if (auto handled = controller_->HandleTopLevelWindowProc(hwnd, message, wparam, lparam)) return *handled;
  }
  switch (message) {
    case WM_HOTKEY:
      if (wparam == kHotkeyId) Toggle();
      return 0;
    case WM_ACTIVATE:
      // 点了窗口外面、切到别的程序：收起，什么都不粘贴
      if (LOWORD(wparam) == WA_INACTIVE && ::IsWindowVisible(hwnd)) Hide(true, false);
      return 0;
    case WM_SIZE:
      ResizeChild();
      return 0;
    case WM_DPICHANGED: {
      auto* r = reinterpret_cast<RECT*>(lparam);
      ::SetWindowPos(hwnd, nullptr, r->left, r->top, r->right - r->left, r->bottom - r->top,
                     SWP_NOZORDER | SWP_NOACTIVATE);
      return 0;
    }
    case WM_FONTCHANGE:
      if (controller_) controller_->engine()->ReloadSystemFonts();
      break;
    case WM_CLOSE:
      // Alt+F4 只是收起，进程留着等下一次快捷键
      Hide(true, true);
      return 0;
    case WM_DESTROY:
      hwnd_ = nullptr;
      ::PostQuitMessage(0);
      return 0;
  }
  return ::DefWindowProc(hwnd, message, wparam, lparam);
}

void PickerWindow::ResizeChild() {
  if (!controller_ || !hwnd_) return;
  RECT r;
  ::GetClientRect(hwnd_, &r);
  ::MoveWindow(controller_->view()->GetNativeWindow(), 0, 0, r.right - r.left, r.bottom - r.top, TRUE);
}

void PickerWindow::HandleMethodCall(const flutter::MethodCall<EncodableValue>& call, Result result) {
  const auto& m = call.method_name();
  if (m == "setHotkey") {
    result->Success(EncodableValue(SetHotkey(StringArg(call, "hotkey"), BoolArg(call, "enabled"))));
  } else if (m == "setSuspended") {
    suspended_ = BoolArg(call, "suspended");
    ApplyHotkey();
    result->Success();
  } else if (m == "pasteStatus") {
    // targetElevated：呼出前的窗口以管理员身份运行，这一次没法模拟粘贴（见 Commit）。
    // 只是这一次，不算「不能自动粘贴」，底栏据此提示用户自己按 Ctrl+V
    const bool elevated = previous_ && ::IsWindow(previous_) && IsElevatedWindow(previous_) && !SelfElevated();
    result->Success(EncodableValue(EncodableMap{{Str("available"), EncodableValue(true)},
                                                {Str("reason"), Str("")},
                                                {Str("targetElevated"), EncodableValue(elevated)}}));
  } else if (m == "requestPermission") {
    result->Success();  // Windows 不需要授权
  } else if (m == "show") {
    Show();
    result->Success();
  } else if (m == "hide") {
    Hide(false, true);
    result->Success();
  } else if (m == "commit") {
    Commit(BoolArg(call, "paste"), std::move(result));
  } else if (m == "ready") {
    dart_ready_ = true;
    if (pending_show_) {
      pending_show_ = false;
      Show();
    }
    result->Success();
  } else if (m == "quit") {
    // 关掉了快捷粘贴：结束消息循环，进程正常退出，后台服务不再拉起它
    result->Success();
    ::PostQuitMessage(0);
  } else {
    result->NotImplemented();
  }
}

EncodableMap PickerWindow::SetHotkey(const std::string& name, bool enabled) {
  auto reply = [&](bool ok, const std::string& error) {
    return EncodableMap{{Str("ok"), EncodableValue(ok)},
                        {Str("error"), EncodableValue(error)},
                        {Str("source"), Str("native")},
                        {Str("hotkey"), EncodableValue(enabled ? name : std::string())}};
  };
  if (!enabled) {
    has_hotkey_ = false;
    ApplyHotkey();
    return reply(true, "");
  }
  UINT mods = 0, vk = 0;
  if (!ParseHotkey(name, &mods, &vk)) return reply(false, "invalid");
  has_hotkey_ = true;
  modifiers_ = mods;
  vk_ = vk;
  if (ApplyHotkey()) return reply(true, "");
  return reply(false, hotkey_error_ == ERROR_HOTKEY_ALREADY_REGISTERED ? "in_use" : std::to_string(hotkey_error_));
}

bool PickerWindow::ApplyHotkey() {
  if (registered_) {
    ::UnregisterHotKey(hwnd_, kHotkeyId);
    registered_ = false;
  }
  hotkey_error_ = 0;
  if (!has_hotkey_ || suspended_) return true;
  registered_ = ::RegisterHotKey(hwnd_, kHotkeyId, modifiers_, vk_) != 0;
  if (!registered_) hotkey_error_ = ::GetLastError();
  return registered_;
}

void PickerWindow::Toggle() {
  if (::IsWindowVisible(hwnd_)) {
    Hide(true, true);
  } else {
    Show();
  }
}

void PickerWindow::Show() {
  if (!dart_ready_) {
    pending_show_ = true;
    return;
  }
  HWND fg = ::GetForegroundWindow();
  if (fg && fg != hwnd_) previous_ = fg;
  Place();
  channel_->InvokeMethod("onShow", nullptr);
  ::ShowWindow(hwnd_, SW_SHOW);
  BringToFront(hwnd_);
  ::SetFocus(controller_->view()->GetNativeWindow());
}

// 鼠标所在屏幕的中上方。
void PickerWindow::Place() {
  POINT cursor;
  ::GetCursorPos(&cursor);
  HMONITOR monitor = ::MonitorFromPoint(cursor, MONITOR_DEFAULTTONEAREST);
  MONITORINFO info{sizeof(info)};
  ::GetMonitorInfo(monitor, &info);
  const double scale = FlutterDesktopGetDpiForMonitor(monitor) / 96.0;
  const int w = static_cast<int>(kWidth * scale);
  const int h = static_cast<int>(kHeight * scale);
  const RECT& work = info.rcWork;
  const int x = work.left + (work.right - work.left - w) / 2;
  const int y = work.top + static_cast<int>((work.bottom - work.top) * 0.22);
  ::SetWindowPos(hwnd_, HWND_TOPMOST, x, std::min<int>(y, work.bottom - h), w, h, SWP_NOACTIVATE);
}

void PickerWindow::Hide(bool notify, bool restore) {
  if (!::IsWindowVisible(hwnd_)) return;
  ::ShowWindow(hwnd_, SW_HIDE);
  if (restore && previous_ && ::IsWindow(previous_)) ::SetForegroundWindow(previous_);
  if (notify) channel_->InvokeMethod("onHide", nullptr);
}

void PickerWindow::Commit(bool paste, Result result) {
  HWND target = previous_;
  Hide(false, true);
  auto reply = [&](bool pasted, const char* reason) {
    result->Success(EncodableValue(EncodableMap{{Str("pasted"), EncodableValue(pasted)}, {Str("reason"), Str(reason)}}));
  };
  if (!paste) return reply(false, "");
  if (target && IsElevatedWindow(target) && !SelfElevated()) return reply(false, "elevated");
  // 等目标窗口确实回到前台，最多 300 毫秒
  for (int i = 0; i < 20 && target && ::GetForegroundWindow() != target; i++) ::Sleep(15);
  ::Sleep(30);
  SendPaste();
  reply(true, "");
}
