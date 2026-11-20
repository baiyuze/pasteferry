#include "flutter_window.h"

#include <flutter_windows.h>
#include <flutter/standard_method_codec.h>

#include <algorithm>
#include <optional>

#include "flutter/generated_plugin_registrant.h"

namespace {

// 窗口的位置与大小存在这里，下次打开时恢复，相当于 Mac 上的 setFrameAutosaveName
constexpr wchar_t kSettingsKey[] = L"Software\\PasteFerry";
constexpr wchar_t kPlacementValue[] = L"WindowPlacement";

// 窗口最小尺寸（逻辑像素），与 Mac 版一致
constexpr int kMinWidth = 760;
constexpr int kMinHeight = 520;

void SavePlacement(HWND hwnd) {
  WINDOWPLACEMENT placement{sizeof(WINDOWPLACEMENT)};
  if (::GetWindowPlacement(hwnd, &placement)) {
    ::RegSetKeyValueW(HKEY_CURRENT_USER, kSettingsKey, kPlacementValue,
                      REG_BINARY, &placement, sizeof(placement));
  }
}

// 恢复上次的位置与大小。返回上次是否最大化；记录无效（比如那块屏幕已经拔掉了）时不恢复。
bool RestorePlacement(HWND hwnd) {
  WINDOWPLACEMENT placement{};
  DWORD size = sizeof(placement);
  if (::RegGetValueW(HKEY_CURRENT_USER, kSettingsKey, kPlacementValue,
                     RRF_RT_REG_BINARY, nullptr, &placement, &size) != ERROR_SUCCESS ||
      size != sizeof(placement) || placement.length != sizeof(placement)) {
    return false;
  }
  if (!::MonitorFromRect(&placement.rcNormalPosition, MONITOR_DEFAULTTONULL)) {
    return false;
  }
  const bool maximized = placement.showCmd == SW_SHOWMAXIMIZED;
  // 只放好位置，先不显示：窗口等 Flutter 画好第一帧再显示（见 OnCreate）
  placement.showCmd = SW_HIDE;
  ::SetWindowPlacement(hwnd, &placement);
  return maximized;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }
  const bool maximized = RestorePlacement(GetHandle());

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  lifecycle_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(), "com.pasteferry.app/lifecycle",
      &flutter::StandardMethodCodec::GetInstance());
  lifecycle_channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    if (call.method_name() == "hideWindow") {
      ::ShowWindow(GetHandle(), SW_HIDE);
      result->Success();
    } else if (call.method_name() == "setUiScale") {
      double scale = 1.0;
      if (const auto* args = std::get_if<flutter::EncodableMap>(call.arguments())) {
        const auto it = args->find(flutter::EncodableValue("scale"));
        if (it != args->end()) {
          if (const auto* v = std::get_if<double>(&it->second)) scale = *v;
        }
      }
      ApplyUiScale(scale);
      result->Success();
    } else {
      result->NotImplemented();
    }
  });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([this, maximized]() {
    this->Show();
    if (maximized) {
      ::ShowWindow(this->GetHandle(), SW_MAXIMIZE);
    }
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  lifecycle_channel_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (lifecycle_channel_ && (message == WM_CLOSE || message == WM_APP + 87)) {
    SavePlacement(hwnd);
    if (message == WM_APP + 87) {
      ::ShowWindow(hwnd, SW_SHOW);
      ::SetForegroundWindow(hwnd);
    }
    lifecycle_channel_->InvokeMethod(message == WM_CLOSE ? "closeRequested" : "quitRequested", nullptr);
    return 0;
  }
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
    case WM_GETMINMAXINFO: {
      const SIZE min = MinTrackSize(hwnd);
      auto* info = reinterpret_cast<MINMAXINFO*>(lparam);
      info->ptMinTrackSize.x = min.cx;
      info->ptMinTrackSize.y = min.cy;
      return 0;
    }
    case WM_CLOSE:
      SavePlacement(hwnd);
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

SIZE FlutterWindow::MinTrackSize(HWND hwnd) const {
  HMONITOR monitor = ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
  const double scale = FlutterDesktopGetDpiForMonitor(monitor) / 96.0 * ui_scale_;
  LONG w = static_cast<LONG>(kMinWidth * scale);
  LONG h = static_cast<LONG>(kMinHeight * scale);
  // 屏幕放不下时以工作区为准，Flutter 那边自己降倍数
  MONITORINFO info{sizeof(info)};
  if (::GetMonitorInfo(monitor, &info)) {
    w = std::min<LONG>(w, info.rcWork.right - info.rcWork.left);
    h = std::min<LONG>(h, info.rcWork.bottom - info.rcWork.top);
  }
  return {w, h};
}

void FlutterWindow::ApplyUiScale(double scale) {
  ui_scale_ = scale > 0 ? scale : 1.0;
  HWND hwnd = GetHandle();
  // 最大化、最小化时不动：还原以后系统按 WM_GETMINMAXINFO 的新最小尺寸来
  if (!hwnd || ::IsZoomed(hwnd) || ::IsIconic(hwnd)) return;
  RECT rect;
  if (!::GetWindowRect(hwnd, &rect)) return;
  const SIZE min = MinTrackSize(hwnd);
  int w = rect.right - rect.left;
  int h = rect.bottom - rect.top;
  if (w >= min.cx && h >= min.cy) return;
  w = std::max<int>(w, min.cx);
  h = std::max<int>(h, min.cy);
  // 左上角不动；放大以后超出工作区的话往回挪
  int x = rect.left;
  int y = rect.top;
  MONITORINFO info{sizeof(info)};
  if (::GetMonitorInfo(::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST), &info)) {
    const RECT& work = info.rcWork;
    x = std::max<int>(std::min<int>(x, work.right - w), work.left);
    y = std::max<int>(std::min<int>(y, work.bottom - h), work.top);
  }
  ::SetWindowPos(hwnd, nullptr, x, y, w, h, SWP_NOZORDER | SWP_NOACTIVATE);
}
