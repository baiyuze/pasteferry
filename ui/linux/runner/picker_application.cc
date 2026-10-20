#include "picker_application.h"

#include <flutter_linux/flutter_linux.h>
#include <string.h>

#ifdef GDK_WINDOWING_X11
#include <X11/XKBlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/extensions/XTest.h>
#include <gdk/gdkx.h>
#endif
#ifdef GDK_WINDOWING_WAYLAND
#include <gdk/gdkwayland.h>
#endif

// 快捷粘贴窗口的原生外壳（Linux）。列表与按键都在 Dart 里（lib/picker/），这里只做：
//   - 全局快捷键：X11 上在根窗口 XGrabKey；Wayland 上经 xdg-desktop-portal 的 GlobalShortcuts，
//     桌面不支持时由用户在系统设置里添加一条运行 `pasteferry --picker --toggle` 的自定义快捷键
//   - 窗口：无边框、不进任务栏、置顶，失去焦点就收起
//   - 粘贴：X11 上把焦点交还原来的窗口，再用 XTest 发 Ctrl+V（终端发 Ctrl+Shift+V）；
//     Wayland 不允许程序模拟按键，只放进剪贴板，由用户按 Ctrl+V
// 与 Mac、Windows 的外壳用同一个通道 pasteferry/picker，方法见 lib/picker/picker_host.dart。

static const int kWidth = 560;
static const int kHeight = 460;

struct _PickerApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  gboolean toggle_on_ready;  // 本进程就是被 --toggle 拉起的：Dart 准备好后显示

  GtkWindow* window;
  FlView* view;
  FlMethodChannel* channel;
  gboolean dart_ready;
  gboolean pending_show;
  gboolean suspended;

  // 快捷键
  gchar* hotkey;  // 设置里的写法，如 "alt+v"
  gboolean portal;
  gchar* portal_session;
  gchar* portal_trigger;  // 门户里实际生效的组合，显示给用户看
  guint portal_activated_sub;
  guint portal_changed_sub;
#ifdef GDK_WINDOWING_X11
  unsigned int grab_keycode;
  unsigned int grab_modifiers;
  gboolean grabbed;
  Window previous;  // 呼出时的前台窗口
  guint32 last_time;
#endif
};

G_DEFINE_TYPE(PickerApplication, picker_application, GTK_TYPE_APPLICATION)

static gboolean is_x11() {
#ifdef GDK_WINDOWING_X11
  return GDK_IS_X11_DISPLAY(gdk_display_get_default());
#else
  return FALSE;
#endif
}

static gboolean is_wayland() {
#ifdef GDK_WINDOWING_WAYLAND
  return GDK_IS_WAYLAND_DISPLAY(gdk_display_get_default());
#else
  return FALSE;
#endif
}

static void invoke(PickerApplication* self, const gchar* method) {
  if (self->channel != nullptr) {
    fl_method_channel_invoke_method(self->channel, method, nullptr, nullptr, nullptr, nullptr);
  }
}

// ─────────────────────────── X11：前台窗口、粘贴、快捷键 ───────────────────────────

#ifdef GDK_WINDOWING_X11
static Display* xdisplay() { return GDK_DISPLAY_XDISPLAY(gdk_display_get_default()); }

static Window active_window() {
  Display* d = xdisplay();
  Atom prop = XInternAtom(d, "_NET_ACTIVE_WINDOW", False);
  Atom type;
  int format;
  unsigned long n, after;
  unsigned char* data = nullptr;
  Window w = 0;
  if (XGetWindowProperty(d, DefaultRootWindow(d), prop, 0, 1, False, XA_WINDOW, &type, &format, &n, &after,
                         &data) == Success &&
      data != nullptr && n > 0) {
    w = *reinterpret_cast<Window*>(data);
  }
  if (data != nullptr) XFree(data);
  return w;
}

static void activate_window(Window w, guint32 time) {
  Display* d = xdisplay();
  XEvent e = {};
  e.xclient.type = ClientMessage;
  e.xclient.window = w;
  e.xclient.message_type = XInternAtom(d, "_NET_ACTIVE_WINDOW", False);
  e.xclient.format = 32;
  e.xclient.data.l[0] = 2;  // 来源：工具（pager），窗口管理器照办，不当成抢焦点
  e.xclient.data.l[1] = time;
  XSendEvent(d, DefaultRootWindow(d), False, SubstructureRedirectMask | SubstructureNotifyMask, &e);
  XFlush(d);
}

// 终端里粘贴是 Ctrl+Shift+V。按窗口的 WM_CLASS 认常见的终端。
static gboolean is_terminal(Window w) {
  static const char* kTerminals[] = {"gnome-terminal", "org.gnome.terminal", "org.gnome.console", "kgx",
                                     "konsole", "xfce4-terminal", "tilix", "kitty", "alacritty", "wezterm",
                                     "terminator", "xterm", "urxvt", "st-256color", "foot", "ptyxis",
                                     "mate-terminal", "lxterminal", "qterminal", "terminology", "guake",
                                     "tilda", "blackbox", nullptr};
  XClassHint hint = {};
  if (w == 0 || !XGetClassHint(xdisplay(), w, &hint)) return FALSE;
  gboolean found = FALSE;
  for (const char* const* t = kTerminals; *t != nullptr && !found; t++) {
    found = (hint.res_class != nullptr && g_ascii_strcasecmp(hint.res_class, *t) == 0) ||
            (hint.res_name != nullptr && g_ascii_strcasecmp(hint.res_name, *t) == 0);
  }
  if (hint.res_class != nullptr) XFree(hint.res_class);
  if (hint.res_name != nullptr) XFree(hint.res_name);
  return found;
}

static void fake_key(KeySym sym, Bool down) {
  Display* d = xdisplay();
  KeyCode code = XKeysymToKeycode(d, sym);
  if (code != 0) XTestFakeKeyEvent(d, code, down, CurrentTime);
}

// 发 Ctrl+V（终端 Ctrl+Shift+V）。用户还按着 Alt、Super（用 Alt+数字选的）时先松开，免得变成别的组合。
static void send_paste(gboolean terminal) {
  Display* d = xdisplay();
  char keys[32];
  XQueryKeymap(d, keys);
  const KeySym held[] = {XK_Alt_L, XK_Alt_R, XK_Super_L, XK_Super_R, XK_Meta_L, XK_Meta_R, XK_Shift_L, XK_Shift_R};
  for (KeySym s : held) {
    KeyCode c = XKeysymToKeycode(d, s);
    if (c != 0 && (keys[c / 8] & (1 << (c % 8)))) XTestFakeKeyEvent(d, c, False, CurrentTime);
  }
  fake_key(XK_Control_L, True);
  if (terminal) fake_key(XK_Shift_L, True);
  fake_key(XK_v, True);
  fake_key(XK_v, False);
  if (terminal) fake_key(XK_Shift_L, False);
  fake_key(XK_Control_L, False);
  XFlush(d);
}

// 设置里的写法 → X11 的键码与修饰键。
static gboolean parse_hotkey(const gchar* name, unsigned int* keycode, unsigned int* modifiers) {
  g_auto(GStrv) parts = g_strsplit(name, "+", -1);
  guint n = g_strv_length(parts);
  if (n == 0) return FALSE;
  unsigned int mods = 0;
  for (guint i = 0; i + 1 < n; i++) {
    if (g_strcmp0(parts[i], "ctrl") == 0) mods |= ControlMask;
    else if (g_strcmp0(parts[i], "alt") == 0) mods |= Mod1Mask;
    else if (g_strcmp0(parts[i], "shift") == 0) mods |= ShiftMask;
    else if (g_strcmp0(parts[i], "meta") == 0) mods |= Mod4Mask;
    else return FALSE;
  }
  static const struct { const char* name; const char* sym; } kNames[] = {
      {"enter", "Return"}, {"backspace", "BackSpace"}, {"delete", "Delete"}, {"insert", "Insert"},
      {"home", "Home"}, {"end", "End"}, {"pageup", "Prior"}, {"pagedown", "Next"}, {"up", "Up"},
      {"down", "Down"}, {"left", "Left"}, {"right", "Right"}, {"tab", "Tab"}, {"quote", "apostrophe"},
      {"backquote", "grave"}, {nullptr, nullptr}};
  const gchar* key = parts[n - 1];
  g_autofree gchar* upper = nullptr;
  const char* sym = key;
  for (int i = 0; kNames[i].name != nullptr; i++) {
    if (g_strcmp0(key, kNames[i].name) == 0) sym = kNames[i].sym;
  }
  if (key[0] == 'f' && g_ascii_isdigit(key[1])) {
    upper = g_ascii_strup(key, -1);  // f9 → F9
    sym = upper;
  }
  KeySym ks = XStringToKeysym(sym);
  if (ks == NoSymbol) return FALSE;
  KeyCode code = XKeysymToKeycode(xdisplay(), ks);
  if (code == 0) return FALSE;
  *keycode = code;
  *modifiers = mods;
  return TRUE;
}

// 数字锁定、大写锁定开着时，按下的修饰键里会多出它们，要一起抓
static const unsigned int kLockVariants[] = {0, LockMask, Mod2Mask, LockMask | Mod2Mask};

static void ungrab(PickerApplication* self) {
  if (!self->grabbed) return;
  Display* d = xdisplay();
  for (unsigned int extra : kLockVariants) {
    XUngrabKey(d, self->grab_keycode, self->grab_modifiers | extra, DefaultRootWindow(d));
  }
  XFlush(d);
  self->grabbed = FALSE;
}

// 返回 0 表示成功；被别的程序抓了是 BadAccess
static int grab(PickerApplication* self) {
  ungrab(self);
  if (self->suspended || self->grab_keycode == 0) return 0;
  GdkDisplay* gd = gdk_display_get_default();
  Display* d = xdisplay();
  gdk_x11_display_error_trap_push(gd);
  for (unsigned int extra : kLockVariants) {
    XGrabKey(d, self->grab_keycode, self->grab_modifiers | extra, DefaultRootWindow(d), False, GrabModeAsync,
             GrabModeAsync);
  }
  XSync(d, False);
  int error = gdk_x11_display_error_trap_pop(gd);
  if (error == 0) {
    self->grabbed = TRUE;
  } else {
    for (unsigned int extra : kLockVariants) {
      XUngrabKey(d, self->grab_keycode, self->grab_modifiers | extra, DefaultRootWindow(d));
    }
  }
  return error;
}

static void toggle(PickerApplication* self, guint32 time);

static GdkFilterReturn key_filter(GdkXEvent* xevent, GdkEvent* event, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  XEvent* e = static_cast<XEvent*>(xevent);
  if (e->type == KeyPress && self->grabbed && e->xkey.keycode == self->grab_keycode &&
      (e->xkey.state & ~(LockMask | Mod2Mask)) == self->grab_modifiers) {
    toggle(self, e->xkey.time);
    return GDK_FILTER_REMOVE;
  }
  return GDK_FILTER_CONTINUE;
}
#endif

// ─────────────────────────── Wayland：全局快捷键门户 ───────────────────────────

static const gchar* kPortalBus = "org.freedesktop.portal.Desktop";
static const gchar* kPortalPath = "/org/freedesktop/portal/desktop";
static const gchar* kShortcutsIface = "org.freedesktop.portal.GlobalShortcuts";

// 设置里的写法 → 门户的写法（XDG shortcuts 规范）：CTRL+ALT+v、LOGO+v
static gchar* portal_trigger(const gchar* name) {
  g_auto(GStrv) parts = g_strsplit(name, "+", -1);
  GString* out = g_string_new(nullptr);
  guint n = g_strv_length(parts);
  for (guint i = 0; i < n; i++) {
    if (out->len > 0) g_string_append_c(out, '+');
    const gchar* p = parts[i];
    if (i + 1 < n) {
      g_string_append(out, g_strcmp0(p, "meta") == 0 ? "LOGO" : g_strcmp0(p, "ctrl") == 0 ? "CTRL"
                                                         : g_strcmp0(p, "alt") == 0    ? "ALT"
                                                                                       : "SHIFT");
    } else if (p[0] == 'f' && g_ascii_isdigit(p[1])) {
      g_autofree gchar* up = g_ascii_strup(p, -1);
      g_string_append(out, up);
    } else {
      g_string_append(out, p);
    }
  }
  return g_string_free(out, FALSE);
}

static gchar* request_path(GDBusConnection* bus, const gchar* token) {
  g_autofree gchar* sender = g_strdup(g_dbus_connection_get_unique_name(bus) + 1);
  for (gchar* c = sender; *c != '\0'; c++) {
    if (*c == '.') *c = '_';
  }
  return g_strdup_printf("/org/freedesktop/portal/desktop/request/%s/%s", sender, token);
}

typedef void (*PortalResponse)(PickerApplication* self, guint32 code, GVariant* results);

struct PortalRequest {
  PickerApplication* self;
  PortalResponse done;
  guint sub;
};

static void portal_response(GDBusConnection* bus, const gchar*, const gchar*, const gchar*, const gchar*,
                            GVariant* params, gpointer data) {
  auto* req = static_cast<PortalRequest*>(data);
  guint32 code = 0;
  g_autoptr(GVariant) results = nullptr;
  g_variant_get(params, "(u@a{sv})", &code, &results);
  g_dbus_connection_signal_unsubscribe(bus, req->sub);
  req->done(req->self, code, results);
  g_free(req);
}

// 门户的调用都是异步的：先订阅 Request 对象的 Response 信号，再发起调用
static void portal_call(PickerApplication* self, const gchar* method, GVariant* params, const gchar* token,
                        PortalResponse done) {
  GDBusConnection* bus = g_application_get_dbus_connection(G_APPLICATION(self));
  g_autofree gchar* path = request_path(bus, token);
  auto* req = g_new0(PortalRequest, 1);
  req->self = self;
  req->done = done;
  req->sub = g_dbus_connection_signal_subscribe(bus, kPortalBus, "org.freedesktop.portal.Request", "Response", path,
                                                nullptr, G_DBUS_SIGNAL_FLAGS_NO_MATCH_RULE, portal_response, req,
                                                nullptr);
  g_dbus_connection_call(bus, kPortalBus, kPortalPath, kShortcutsIface, method, params, nullptr,
                         G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr, nullptr);
}

static void report_portal_hotkey(PickerApplication* self, GVariant* shortcuts) {
  GVariantIter iter;
  const gchar* id = nullptr;
  GVariant* props = nullptr;
  g_variant_iter_init(&iter, shortcuts);
  while (g_variant_iter_next(&iter, "(&s@a{sv})", &id, &props)) {
    const gchar* trigger = nullptr;
    if (g_variant_lookup(props, "trigger_description", "&s", &trigger)) {
      g_free(self->portal_trigger);
      self->portal_trigger = g_strdup(trigger);
    }
    g_variant_unref(props);
  }
  if (self->channel != nullptr && self->portal_trigger != nullptr) {
    g_autoptr(FlValue) args = fl_value_new_map();
    fl_value_set_string_take(args, "hotkey", fl_value_new_string(self->portal_trigger));
    fl_method_channel_invoke_method(self->channel, "onHotkeyChanged", args, nullptr, nullptr, nullptr);
  }
}

static void toggle_from_portal(PickerApplication* self, const gchar* token);

static void portal_activated(GDBusConnection*, const gchar*, const gchar*, const gchar*, const gchar*,
                             GVariant* params, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  const gchar* session = nullptr;
  const gchar* id = nullptr;
  guint64 timestamp = 0;
  g_autoptr(GVariant) options = nullptr;
  g_variant_get(params, "(&o&st@a{sv})", &session, &id, &timestamp, &options);
  if (g_strcmp0(session, self->portal_session) != 0) return;
  const gchar* token = nullptr;
  g_variant_lookup(options, "activation_token", "&s", &token);
  toggle_from_portal(self, token);
}

static void portal_shortcuts_changed(GDBusConnection*, const gchar*, const gchar*, const gchar*, const gchar*,
                                     GVariant* params, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  const gchar* session = nullptr;
  g_autoptr(GVariant) shortcuts = nullptr;
  g_variant_get(params, "(&o@a(sa{sv}))", &session, &shortcuts);
  if (g_strcmp0(session, self->portal_session) == 0) report_portal_hotkey(self, shortcuts);
}

static void portal_bound(PickerApplication* self, guint32 code, GVariant* results) {
  if (code != 0) {
    g_warning("全局快捷键门户：用户没有同意绑定快捷键（%u）", code);
    return;
  }
  g_autoptr(GVariant) shortcuts = g_variant_lookup_value(results, "shortcuts", G_VARIANT_TYPE("a(sa{sv})"));
  if (shortcuts != nullptr) report_portal_hotkey(self, shortcuts);
}

static void portal_session_created(PickerApplication* self, guint32 code, GVariant* results) {
  const gchar* handle = nullptr;
  if (code != 0 || !g_variant_lookup(results, "session_handle", "&s", &handle)) {
    g_warning("全局快捷键门户：建立会话失败（%u）", code);
    return;
  }
  self->portal_session = g_strdup(handle);
  GDBusConnection* bus = g_application_get_dbus_connection(G_APPLICATION(self));
  self->portal_activated_sub = g_dbus_connection_signal_subscribe(
      bus, kPortalBus, kShortcutsIface, "Activated", kPortalPath, nullptr, G_DBUS_SIGNAL_FLAGS_NONE,
      portal_activated, self, nullptr);
  self->portal_changed_sub = g_dbus_connection_signal_subscribe(
      bus, kPortalBus, kShortcutsIface, "ShortcutsChanged", kPortalPath, nullptr, G_DBUS_SIGNAL_FLAGS_NONE,
      portal_shortcuts_changed, self, nullptr);

  g_autofree gchar* trigger = portal_trigger(self->hotkey != nullptr ? self->hotkey : "alt+v");
  GVariantBuilder props;
  g_variant_builder_init(&props, G_VARIANT_TYPE("a{sv}"));
  g_variant_builder_add(&props, "{sv}", "description", g_variant_new_string("PasteFerry quick paste"));
  g_variant_builder_add(&props, "{sv}", "preferred_trigger", g_variant_new_string(trigger));
  GVariantBuilder shortcuts;
  g_variant_builder_init(&shortcuts, G_VARIANT_TYPE("a(sa{sv})"));
  g_variant_builder_add(&shortcuts, "(sa{sv})", "toggle", &props);
  GVariantBuilder options;
  g_variant_builder_init(&options, G_VARIANT_TYPE("a{sv}"));
  g_variant_builder_add(&options, "{sv}", "handle_token", g_variant_new_string("pasteferry_bind"));
  portal_call(self, "BindShortcuts",
              g_variant_new("(oa(sa{sv})sa{sv})", self->portal_session, &shortcuts, "", &options),
              "pasteferry_bind", portal_bound);
}

// 桌面支持全局快捷键门户吗（GNOME 48 起、KDE Plasma 5.27 起）？Ubuntu 24.04 的 GNOME 46 不支持。
static gboolean portal_available(PickerApplication* self) {
  GDBusConnection* bus = g_application_get_dbus_connection(G_APPLICATION(self));
  if (bus == nullptr) return FALSE;
  g_autoptr(GError) error = nullptr;
  g_autoptr(GVariant) v = g_dbus_connection_call_sync(
      bus, kPortalBus, kPortalPath, "org.freedesktop.DBus.Properties", "Get",
      g_variant_new("(ss)", kShortcutsIface, "version"), G_VARIANT_TYPE("(v)"), G_DBUS_CALL_FLAGS_NONE, 2000,
      nullptr, &error);
  return v != nullptr;
}

static void portal_start(PickerApplication* self) {
  GVariantBuilder options;
  g_variant_builder_init(&options, G_VARIANT_TYPE("a{sv}"));
  g_variant_builder_add(&options, "{sv}", "handle_token", g_variant_new_string("pasteferry_session"));
  g_variant_builder_add(&options, "{sv}", "session_handle_token", g_variant_new_string("pasteferry"));
  portal_call(self, "CreateSession", g_variant_new("(a{sv})", &options), "pasteferry_session",
              portal_session_created);
}

// ─────────────────────────── 窗口 ───────────────────────────

static void place(PickerApplication* self) {
  if (!is_x11()) return;  // Wayland 上窗口位置由系统决定
  GdkDisplay* display = gdk_display_get_default();
  GdkSeat* seat = gdk_display_get_default_seat(display);
  int x = 0, y = 0;
  gdk_device_get_position(gdk_seat_get_pointer(seat), nullptr, &x, &y);
  GdkMonitor* monitor = gdk_display_get_monitor_at_point(display, x, y);
  GdkRectangle area;
  gdk_monitor_get_workarea(monitor, &area);
  gtk_window_move(self->window, area.x + (area.width - kWidth) / 2, area.y + area.height * 22 / 100);
}

static void show(PickerApplication* self, guint32 time) {
  if (!self->dart_ready) {
    self->pending_show = TRUE;
    return;
  }
#ifdef GDK_WINDOWING_X11
  if (is_x11()) {
    Window w = active_window();
    GdkWindow* mine = gtk_widget_get_window(GTK_WIDGET(self->window));
    if (w != 0 && (mine == nullptr || w != GDK_WINDOW_XID(mine))) self->previous = w;
    self->last_time = time;
  }
#endif
  place(self);
  invoke(self, "onShow");
  gtk_widget_show(GTK_WIDGET(self->window));
  if (time != GDK_CURRENT_TIME) {
    gtk_window_present_with_time(self->window, time);
  } else {
    gtk_window_present(self->window);
  }
  gtk_widget_grab_focus(GTK_WIDGET(self->view));
}

static void hide(PickerApplication* self, gboolean notify) {
  if (!gtk_widget_get_visible(GTK_WIDGET(self->window))) return;
  gtk_widget_hide(GTK_WIDGET(self->window));
  if (notify) invoke(self, "onHide");
}

static void toggle(PickerApplication* self, guint32 time) {
  if (gtk_widget_get_visible(GTK_WIDGET(self->window))) {
    hide(self, TRUE);
  } else {
    show(self, time);
  }
}

static void toggle_from_portal(PickerApplication* self, const gchar* token) {
  // 门户给了激活令牌时交给 GTK，Wayland 下窗口才能拿到焦点（否则 GNOME 只显示「已就绪」通知）
  if (token != nullptr) gtk_window_set_startup_id(self->window, token);
  toggle(self, GDK_CURRENT_TIME);
}

// 窗口拿到焦点时告诉 Dart，由它重新打开输入法（TextInput.show）。Flutter 只在 TextInput.show 时
// 调用 gtk_im_context_focus_in，不管窗口焦点；搜索框的焦点在窗口隐藏时就有了、之后不再变，
// X11 上 IBus 就一直不知道该把按键交给这个窗口，打不出中文。Wayland 上由合成器通知输入法，本来就没问题
static gboolean on_focus_in(GtkWidget*, GdkEvent*, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  if (gtk_widget_get_visible(GTK_WIDGET(self->window))) invoke(self, "onFocusIn");
  return FALSE;
}

static gboolean on_focus_out(GtkWidget*, GdkEvent*, gpointer data) {
  // 点了窗口外面、切到别的程序：收起，什么都不粘贴
  hide(PICKER_APPLICATION(data), TRUE);
  return FALSE;
}

static gboolean on_delete(GtkWidget*, GdkEvent*, gpointer data) {
  hide(PICKER_APPLICATION(data), TRUE);
  return TRUE;  // 只收起，进程留着等下一次快捷键
}

// ─────────────────────────── Dart → 原生 ───────────────────────────

static FlValue* hotkey_reply(gboolean ok, const gchar* error, const gchar* source, const gchar* hotkey) {
  FlValue* r = fl_value_new_map();
  fl_value_set_string_take(r, "ok", fl_value_new_bool(ok));
  fl_value_set_string_take(r, "error", fl_value_new_string(error));
  fl_value_set_string_take(r, "source", fl_value_new_string(source));
  fl_value_set_string_take(r, "hotkey", fl_value_new_string(hotkey != nullptr ? hotkey : ""));
  return r;
}

static FlValue* set_hotkey(PickerApplication* self, const gchar* name, gboolean enabled) {
  g_free(self->hotkey);
  self->hotkey = enabled ? g_strdup(name) : nullptr;
#ifdef GDK_WINDOWING_X11
  if (is_x11()) {
    if (!enabled) {
      self->grab_keycode = 0;
      ungrab(self);
      return hotkey_reply(TRUE, "", "native", "");
    }
    unsigned int code = 0, mods = 0;
    if (!parse_hotkey(name, &code, &mods)) return hotkey_reply(FALSE, "invalid", "native", name);
    self->grab_keycode = code;
    self->grab_modifiers = mods;
    int error = grab(self);
    if (error == 0) return hotkey_reply(TRUE, "", "native", name);
    return hotkey_reply(FALSE, error == BadAccess ? "in_use" : "grab failed", "native", name);
  }
#endif
  // Wayland：门户只绑一次，之后改键要去系统设置里改
  if (self->portal) {
    return hotkey_reply(TRUE, "", "portal", self->portal_trigger != nullptr ? self->portal_trigger : "");
  }
  if (enabled && portal_available(self)) {
    self->portal = TRUE;
    portal_start(self);
    return hotkey_reply(TRUE, "", "portal", "");
  }
  return hotkey_reply(TRUE, "", "system_shortcut", enabled ? name : "");
}

struct Commit {
  PickerApplication* self;
  FlMethodCall* call;
  int waited;
};

#ifdef GDK_WINDOWING_X11
// 等原来的窗口确实回到前台（最多 300 毫秒），再发粘贴键
static gboolean commit_tick(gpointer data) {
  auto* c = static_cast<Commit*>(data);
  PickerApplication* self = c->self;
  if (self->previous != 0 && active_window() != self->previous && c->waited < 300) {
    c->waited += 20;
    return G_SOURCE_CONTINUE;
  }
  send_paste(is_terminal(self->previous));
  g_autoptr(FlValue) r = fl_value_new_map();
  fl_value_set_string_take(r, "pasted", fl_value_new_bool(TRUE));
  fl_value_set_string_take(r, "reason", fl_value_new_string(""));
  fl_method_call_respond_success(c->call, r, nullptr);
  g_object_unref(c->call);
  g_free(c);
  return G_SOURCE_REMOVE;
}
#endif

static void commit(PickerApplication* self, FlMethodCall* call, gboolean paste) {
  hide(self, FALSE);
  const gchar* reason = "";
  if (paste && is_wayland()) reason = "wayland";
#ifdef GDK_WINDOWING_X11
  if (is_x11() && self->previous != 0) activate_window(self->previous, self->last_time);
  if (paste && is_x11()) {
    auto* c = g_new0(Commit, 1);
    c->self = self;
    c->call = FL_METHOD_CALL(g_object_ref(call));
    g_timeout_add(20, commit_tick, c);
    return;
  }
#endif
  g_autoptr(FlValue) r = fl_value_new_map();
  fl_value_set_string_take(r, "pasted", fl_value_new_bool(FALSE));
  fl_value_set_string_take(r, "reason", fl_value_new_string(reason));
  fl_method_call_respond_success(call, r, nullptr);
}

static gboolean lookup_bool(FlValue* args, const gchar* key) {
  FlValue* v = args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_MAP ? fl_value_lookup_string(args, key)
                                                                              : nullptr;
  return v != nullptr && fl_value_get_type(v) == FL_VALUE_TYPE_BOOL && fl_value_get_bool(v);
}

static const gchar* lookup_string(FlValue* args, const gchar* key) {
  FlValue* v = args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_MAP ? fl_value_lookup_string(args, key)
                                                                              : nullptr;
  return v != nullptr && fl_value_get_type(v) == FL_VALUE_TYPE_STRING ? fl_value_get_string(v) : "";
}

static void respond(FlMethodCall* call, FlValue* value) {
  fl_method_call_respond_success(call, value, nullptr);
  if (value != nullptr) fl_value_unref(value);
}

static void method_call_cb(FlMethodChannel*, FlMethodCall* call, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  const gchar* m = fl_method_call_get_name(call);
  FlValue* args = fl_method_call_get_args(call);
  if (g_strcmp0(m, "setHotkey") == 0) {
    respond(call, set_hotkey(self, lookup_string(args, "hotkey"), lookup_bool(args, "enabled")));
  } else if (g_strcmp0(m, "setSuspended") == 0) {
    self->suspended = lookup_bool(args, "suspended");
#ifdef GDK_WINDOWING_X11
    if (is_x11()) grab(self);
#endif
    respond(call, nullptr);
  } else if (g_strcmp0(m, "pasteStatus") == 0) {
    FlValue* r = fl_value_new_map();
    fl_value_set_string_take(r, "available", fl_value_new_bool(is_x11()));
    fl_value_set_string_take(r, "reason", fl_value_new_string(is_x11() ? "" : "wayland"));
    respond(call, r);
  } else if (g_strcmp0(m, "requestPermission") == 0) {
    respond(call, nullptr);
  } else if (g_strcmp0(m, "show") == 0) {
    show(self, GDK_CURRENT_TIME);
    respond(call, nullptr);
  } else if (g_strcmp0(m, "hide") == 0) {
    hide(self, FALSE);
#ifdef GDK_WINDOWING_X11
    if (is_x11() && self->previous != 0) activate_window(self->previous, self->last_time);
#endif
    respond(call, nullptr);
  } else if (g_strcmp0(m, "commit") == 0) {
    commit(self, call, lookup_bool(args, "paste"));
  } else if (g_strcmp0(m, "ready") == 0) {
    self->dart_ready = TRUE;
    if (self->pending_show || self->toggle_on_ready) {
      self->pending_show = FALSE;
      self->toggle_on_ready = FALSE;
      show(self, GDK_CURRENT_TIME);
    }
    respond(call, nullptr);
  } else if (g_strcmp0(m, "quit") == 0) {
    respond(call, nullptr);
    g_application_quit(G_APPLICATION(self));
  } else {
    fl_method_call_respond_not_implemented(call, nullptr);
  }
}

// ─────────────────────────── GApplication ───────────────────────────

static void create_window(PickerApplication* self) {
  GtkWindow* window = GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(self)));
  self->window = window;
  gtk_window_set_title(window, "PasteFerry");
  gtk_window_set_decorated(window, FALSE);
  gtk_window_set_resizable(window, FALSE);
  gtk_window_set_skip_taskbar_hint(window, TRUE);
  gtk_window_set_skip_pager_hint(window, TRUE);
  gtk_window_set_keep_above(window, TRUE);
  gtk_window_set_type_hint(window, GDK_WINDOW_TYPE_HINT_DIALOG);
  gtk_window_set_default_size(window, kWidth, kHeight);
  gtk_window_set_position(window, GTK_WIN_POS_CENTER);
  g_signal_connect(window, "focus-in-event", G_CALLBACK(on_focus_in), self);
  g_signal_connect(window, "focus-out-event", G_CALLBACK(on_focus_out), self);
  g_signal_connect(window, "delete-event", G_CALLBACK(on_delete), self);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);
  FlView* view = fl_view_new(project);
  self->view = view;
  gtk_widget_set_size_request(GTK_WIDGET(view), kWidth, kHeight);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));
  // 平时隐藏：先实现出来让 Flutter 开始渲染，等按快捷键时再显示
  gtk_widget_realize(GTK_WIDGET(view));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel = fl_method_channel_new(fl_engine_get_binary_messenger(fl_view_get_engine(view)),
                                        "pasteferry/picker", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb, self, nullptr);

#ifdef GDK_WINDOWING_X11
  if (is_x11()) gdk_window_add_filter(nullptr, key_filter, self);
#endif
}

static void toggle_action(GSimpleAction*, GVariant*, gpointer data) {
  auto* self = PICKER_APPLICATION(data);
  if (self->window == nullptr) {
    self->toggle_on_ready = TRUE;
    return;
  }
  toggle(self, GDK_CURRENT_TIME);
}

static void picker_application_activate(GApplication* application) {
  auto* self = PICKER_APPLICATION(application);
  if (self->window == nullptr) create_window(self);
}

static void picker_application_startup(GApplication* application) {
  G_APPLICATION_CLASS(picker_application_parent_class)->startup(application);
  // 再次运行 --toggle 时交给已经在运行的这个，见 local_command_line
  GSimpleAction* action = g_simple_action_new("toggle", nullptr);
  g_signal_connect(action, "activate", G_CALLBACK(toggle_action), application);
  g_action_map_add_action(G_ACTION_MAP(application), G_ACTION(action));
  g_object_unref(action);
  // 窗口全部隐藏时进程也要留着
  g_application_hold(application);
}

static gboolean picker_application_local_command_line(GApplication* application, gchar*** arguments,
                                                      int* exit_status) {
  auto* self = PICKER_APPLICATION(application);
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);
  gboolean toggle_requested = g_strv_contains(const_cast<const gchar* const*>(*arguments), "--toggle");

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }
  if (g_application_get_is_remote(application)) {
    // 已经有快捷窗口在运行（后台服务拉起的）：让它显示或收起，本进程退出
    if (toggle_requested) g_action_group_activate_action(G_ACTION_GROUP(application), "toggle", nullptr);
    *exit_status = 0;
    return TRUE;
  }
  self->toggle_on_ready = toggle_requested;
  g_application_activate(application);
  *exit_status = 0;
  // 命令行已经处理完；g_application_run 随后在应用被 hold 期间一直跑主循环（见 startup）
  return TRUE;
}

static void picker_application_dispose(GObject* object) {
  auto* self = PICKER_APPLICATION(object);
#ifdef GDK_WINDOWING_X11
  if (is_x11()) {
    ungrab(self);
    gdk_window_remove_filter(nullptr, key_filter, self);
  }
#endif
  // 只转发 --toggle 的那个进程退出时已经注销，不能再取连接（会报 GLib-GIO-CRITICAL）
  GDBusConnection* bus = g_application_get_is_registered(G_APPLICATION(self))
                             ? g_application_get_dbus_connection(G_APPLICATION(self))
                             : nullptr;
  if (bus != nullptr) {
    if (self->portal_activated_sub != 0) g_dbus_connection_signal_unsubscribe(bus, self->portal_activated_sub);
    if (self->portal_changed_sub != 0) g_dbus_connection_signal_unsubscribe(bus, self->portal_changed_sub);
  }
  self->portal_activated_sub = 0;
  self->portal_changed_sub = 0;
  g_clear_object(&self->channel);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_pointer(&self->hotkey, g_free);
  g_clear_pointer(&self->portal_session, g_free);
  g_clear_pointer(&self->portal_trigger, g_free);
  G_OBJECT_CLASS(picker_application_parent_class)->dispose(object);
}

static void picker_application_class_init(PickerApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = picker_application_activate;
  G_APPLICATION_CLASS(klass)->startup = picker_application_startup;
  G_APPLICATION_CLASS(klass)->local_command_line = picker_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = picker_application_dispose;
}

static void picker_application_init(PickerApplication* self) {}

PickerApplication* picker_application_new() {
  return PICKER_APPLICATION(g_object_new(picker_application_get_type(), "application-id", "com.pasteferry.picker",
                                         "flags", static_cast<GApplicationFlags>(0), nullptr));
}
