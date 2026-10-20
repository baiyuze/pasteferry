#ifndef FLUTTER_PICKER_APPLICATION_H_
#define FLUTTER_PICKER_APPLICATION_H_

#include <gtk/gtk.h>

// 快捷粘贴窗口：pasteferry --picker 时运行，由后台服务拉起，平时隐藏，按快捷键时出现。
// 应用 ID 与主界面分开（com.pasteferry.picker），两者互不激活。
// 再次运行 pasteferry --picker --toggle（Wayland 上系统自定义快捷键用的命令）会交给已经在运行的那个，
// 由它显示或收起窗口。见 design/quick-paste-and-favorites.md 第 7.3、7.4 节。
G_DECLARE_FINAL_TYPE(PickerApplication, picker_application, PICKER, APPLICATION, GtkApplication)

PickerApplication* picker_application_new();

#endif  // FLUTTER_PICKER_APPLICATION_H_
