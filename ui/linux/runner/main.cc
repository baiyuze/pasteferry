#include <string.h>

#include "my_application.h"
#include "picker_application.h"

int main(int argc, char** argv) {
  // pasteferry --picker：快捷粘贴窗口，与主界面是两个应用 ID，互不激活。见 picker_application.h
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--picker") == 0) {
      g_autoptr(PickerApplication) picker = picker_application_new();
      return g_application_run(G_APPLICATION(picker), argc, argv);
    }
  }
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
