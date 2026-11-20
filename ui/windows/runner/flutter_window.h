#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/flutter_view_controller.h>

#include <memory>

#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // 界面缩放（设置 →「外观」）：最小尺寸跟着放大，窗口比它小时放大窗口
  void ApplyUiScale(double scale);
  // 窗口（含边框）的最小尺寸，物理像素：760×520 乘以屏幕缩放和界面缩放，不超出工作区
  SIZE MinTrackSize(HWND hwnd) const;

  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> lifecycle_channel_;
  double ui_scale_ = 1.0;

  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
