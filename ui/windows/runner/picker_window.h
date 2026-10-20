#ifndef RUNNER_PICKER_WINDOW_H_
#define RUNNER_PICKER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/encodable_value.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <windows.h>

#include <memory>
#include <string>

// 快捷粘贴窗口：PasteFerry.exe --picker 时运行的那个窗口，由后台服务拉起并照看。
//
// 无边框弹出窗口，不进任务栏也不进 Alt+Tab，平时隐藏。全局快捷键（RegisterHotKey）按下时
// 记下当前的前台窗口再显示出来；选中一条后隐藏、把焦点还给原来的窗口，再用 SendInput 发 Ctrl+V。
// 列表与按键都在 Dart 里（lib/picker/），这里只做 Dart 做不了的事。
// 与 Mac、Linux 的外壳用同一个通道 pasteferry/picker，方法见 lib/picker/picker_host.dart。
class PickerWindow {
 public:
  explicit PickerWindow(const flutter::DartProject& project);
  ~PickerWindow();

  PickerWindow(const PickerWindow&) = delete;
  PickerWindow& operator=(const PickerWindow&) = delete;

  bool Create();

 private:
  using Result = std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>;

  static LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);
  LRESULT HandleMessage(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);
  void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& call, Result result);

  void Show();
  // restore 为 true 时把焦点还给呼出前的窗口；点了窗口外面而收起时不还，用户已经选了别的窗口
  void Hide(bool notify, bool restore);
  void Toggle();
  void Place();
  void ResizeChild();

  flutter::EncodableMap SetHotkey(const std::string& name, bool enabled);
  bool ApplyHotkey();
  void Commit(bool paste, Result result);

  flutter::DartProject project_;
  std::unique_ptr<flutter::FlutterViewController> controller_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  HWND hwnd_ = nullptr;
  HWND previous_ = nullptr;

  bool dart_ready_ = false;
  bool pending_show_ = false;
  bool suspended_ = false;
  bool has_hotkey_ = false;
  bool registered_ = false;
  UINT modifiers_ = 0;
  UINT vk_ = 0;
  DWORD hotkey_error_ = 0;
};

#endif  // RUNNER_PICKER_WINDOW_H_
