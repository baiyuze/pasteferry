// Classic Explorer command: collect the entire selection once, atomically queue
// a private request, and open the existing GUI. Never scan or transfer in Explorer.
#include <windows.h>
#include <shlobj.h>
#include <shlwapi.h>

#include <atomic>
#include <chrono>
#include <string>

namespace {
constexpr CLSID kShareClass = {0x9c2e791a, 0x28cb, 0x4d10, {0x9e, 0x63, 0x83, 0x2b, 0xa7, 0xb4, 0x31, 0xd2}};
HMODULE module = nullptr;
std::atomic<long> objects{0};
std::atomic<long> locks{0};

std::wstring Application() {
  wchar_t path[32768];
  const DWORD size = GetModuleFileNameW(module, path, ARRAYSIZE(path));
  if (size == 0 || size >= ARRAYSIZE(path)) return {};
  std::wstring value(path, size);
  return value.substr(0, value.find_last_of(L"\\")) + L"\\PasteFerry.exe";
}

const wchar_t* Title() {
  const LANGID language = GetUserDefaultUILanguage();
  switch (PRIMARYLANGID(language)) {
    case LANG_CHINESE: return language == 0x0404 || language == 0x0c04 || language == 0x1404
      ? L"透過 PasteFerry 傳送" : L"通过 PasteFerry 发送";
    case LANG_JAPANESE: return L"PasteFerry で送信";
    case LANG_KOREAN: return L"PasteFerry로 보내기";
    case LANG_GERMAN: return L"Mit PasteFerry senden";
    case LANG_FRENCH: return L"Envoyer avec PasteFerry";
    case LANG_SPANISH: return L"Enviar con PasteFerry";
    case LANG_PORTUGUESE: return L"Enviar com PasteFerry";
    case LANG_ITALIAN: return L"Invia con PasteFerry";
    case LANG_RUSSIAN: return L"Отправить через PasteFerry";
    case LANG_UKRAINIAN: return L"Надіслати через PasteFerry";
    case LANG_POLISH: return L"Wyślij przez PasteFerry";
    case LANG_TURKISH: return L"PasteFerry ile gönder";
    case LANG_VIETNAMESE: return L"Gửi bằng PasteFerry";
    case LANG_INDONESIAN: return L"Kirim dengan PasteFerry";
    case LANG_ARABIC: return L"إرسال عبر PasteFerry";
    default: return L"Send with PasteFerry";
  }
}

bool AppendPath(std::string& json, const wchar_t* path) {
  const int length = static_cast<int>(wcslen(path));
  const int bytes = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, path, length, nullptr, 0, nullptr, nullptr);
  if (bytes == 0) return false;
  std::string utf8(static_cast<size_t>(bytes), '\0');
  if (!WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, path, length, utf8.data(), bytes, nullptr, nullptr)) return false;
  json += '"';
  constexpr char hex[] = "0123456789abcdef";
  for (const unsigned char c : utf8) {
    if (c == '"' || c == '\\') { json += '\\'; json += static_cast<char>(c); }
    else if (c < 32) { json += "\\u00"; json += hex[c >> 4]; json += hex[c & 15]; }
    else json += static_cast<char>(c);
  }
  json += '"';
  return true;
}

HRESULT Queue(IShellItemArray* items) {
  if (!items) return E_INVALIDARG;
  DWORD count = 0;
  HRESULT result = items->GetCount(&count);
  if (FAILED(result) || count == 0 || count > 10000) return E_INVALIDARG;
  GUID guid;
  if (FAILED(CoCreateGuid(&guid))) return E_FAIL;
  wchar_t wide_id[39];
  StringFromGUID2(guid, wide_id, ARRAYSIZE(wide_id));
  const std::wstring id(wide_id + 1, 36);
  std::string json = "{\"id\":\"" + std::string(id.begin(), id.end()) + "\",\"paths\":[";
  for (DWORD i = 0; i < count; ++i) {
    IShellItem* item = nullptr;
    result = items->GetItemAt(i, &item);
    if (FAILED(result)) return result;
    PWSTR path = nullptr;
    result = item->GetDisplayName(SIGDN_FILESYSPATH, &path);
    item->Release();
    if (FAILED(result)) return result;
    if (i != 0) json += ',';
    const bool valid = AppendPath(json, path);
    CoTaskMemFree(path);
    if (!valid) return E_INVALIDARG;
    if (json.size() > 2 * 1024 * 1024) return HRESULT_FROM_WIN32(ERROR_BUFFER_OVERFLOW);
  }
  const auto now = std::chrono::duration_cast<std::chrono::milliseconds>(
    std::chrono::system_clock::now().time_since_epoch()).count();
  json += "],\"createdAt\":" + std::to_string(now) + "}";
  PWSTR local = nullptr;
  result = SHGetKnownFolderPath(FOLDERID_LocalAppData, 0, nullptr, &local);
  if (FAILED(result)) return result;
  std::wstring directory = std::wstring(local) + L"\\PasteFerry";
  CoTaskMemFree(local);
  if (!CreateDirectoryW(directory.c_str(), nullptr) && GetLastError() != ERROR_ALREADY_EXISTS)
    return HRESULT_FROM_WIN32(GetLastError());
  directory += L"\\share-inbox";
  if (!CreateDirectoryW(directory.c_str(), nullptr) && GetLastError() != ERROR_ALREADY_EXISTS)
    return HRESULT_FROM_WIN32(GetLastError());
  const std::wstring temporary = directory + L"\\" + id + L".tmp";
  const std::wstring target = directory + L"\\" + id + L".json";
  HANDLE file = CreateFileW(temporary.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file == INVALID_HANDLE_VALUE) return HRESULT_FROM_WIN32(GetLastError());
  DWORD written = 0;
  const bool saved = WriteFile(file, json.data(), static_cast<DWORD>(json.size()), &written, nullptr)
    && written == json.size() && FlushFileBuffers(file);
  const DWORD write_error = saved ? ERROR_SUCCESS : GetLastError();
  CloseHandle(file);
  if (!saved || !MoveFileExW(temporary.c_str(), target.c_str(), MOVEFILE_WRITE_THROUGH)) {
    const DWORD failure = saved ? GetLastError() : write_error;
    DeleteFileW(temporary.c_str());
    return HRESULT_FROM_WIN32(failure == ERROR_SUCCESS ? ERROR_WRITE_FAULT : failure);
  }
  const std::wstring app = Application();
  SHELLEXECUTEINFOW launch{sizeof(launch)};
  launch.fMask = SEE_MASK_FLAG_NO_UI | SEE_MASK_NOASYNC;
  launch.lpFile = app.c_str();
  launch.nShow = SW_SHOWNORMAL;
  return ShellExecuteExW(&launch) ? S_OK : HRESULT_FROM_WIN32(GetLastError());
}

class ShareCommand final : public IExplorerCommand {
 public:
  ShareCommand() { ++objects; }
  ~ShareCommand() { --objects; }
  IFACEMETHODIMP QueryInterface(REFIID iid, void** value) override {
    if (!value) return E_POINTER;
    *value = nullptr;
    if (iid == IID_IUnknown || iid == IID_IExplorerCommand) { *value = static_cast<IExplorerCommand*>(this); AddRef(); return S_OK; }
    return E_NOINTERFACE;
  }
  IFACEMETHODIMP_(ULONG) AddRef() override { return ++references_; }
  IFACEMETHODIMP_(ULONG) Release() override { const ULONG n = --references_; if (!n) delete this; return n; }
  IFACEMETHODIMP GetTitle(IShellItemArray*, PWSTR* title) override { return SHStrDupW(Title(), title); }
  IFACEMETHODIMP GetIcon(IShellItemArray*, PWSTR* icon) override { return SHStrDupW((Application()+L",0").c_str(), icon); }
  IFACEMETHODIMP GetToolTip(IShellItemArray*, PWSTR* tip) override { if (tip) *tip = nullptr; return E_NOTIMPL; }
  IFACEMETHODIMP GetCanonicalName(GUID* name) override { if (!name) return E_POINTER; *name = kShareClass; return S_OK; }
  IFACEMETHODIMP GetState(IShellItemArray* items, BOOL, EXPCMDSTATE* state) override {
    if (!state) return E_POINTER;
    DWORD count = 0;
    *state = items && SUCCEEDED(items->GetCount(&count)) && count > 0 && count <= 10000 ? ECS_ENABLED : ECS_HIDDEN;
    return S_OK;
  }
  IFACEMETHODIMP Invoke(IShellItemArray* items, IBindCtx*) override { return Queue(items); }
  IFACEMETHODIMP GetFlags(EXPCMDFLAGS* flags) override { if (!flags) return E_POINTER; *flags = ECF_DEFAULT; return S_OK; }
  IFACEMETHODIMP EnumSubCommands(IEnumExplorerCommand** commands) override { if (commands) *commands = nullptr; return E_NOTIMPL; }
 private:
  std::atomic<ULONG> references_{1};
};

class ShareFactory final : public IClassFactory {
 public:
  ShareFactory() { ++objects; }
  ~ShareFactory() { --objects; }
  IFACEMETHODIMP QueryInterface(REFIID iid, void** value) override {
    if (!value) return E_POINTER;
    *value = nullptr;
    if (iid == IID_IUnknown || iid == IID_IClassFactory) { *value = static_cast<IClassFactory*>(this); AddRef(); return S_OK; }
    return E_NOINTERFACE;
  }
  IFACEMETHODIMP_(ULONG) AddRef() override { return ++references_; }
  IFACEMETHODIMP_(ULONG) Release() override { const ULONG n = --references_; if (!n) delete this; return n; }
  IFACEMETHODIMP CreateInstance(IUnknown* outer, REFIID iid, void** value) override {
    if (outer) return CLASS_E_NOAGGREGATION;
    auto* command = new ShareCommand();
    const HRESULT result = command->QueryInterface(iid, value);
    command->Release();
    return result;
  }
  IFACEMETHODIMP LockServer(BOOL lock) override { if (lock) ++locks; else --locks; return S_OK; }
 private:
  std::atomic<ULONG> references_{1};
};
}  // namespace

extern "C" BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID) {
  if (reason == DLL_PROCESS_ATTACH) { module = instance; DisableThreadLibraryCalls(instance); }
  return TRUE;
}
extern "C" __declspec(dllexport) HRESULT WINAPI DllCanUnloadNow() {
  return objects == 0 && locks == 0 ? S_OK : S_FALSE;
}
extern "C" __declspec(dllexport) HRESULT WINAPI DllGetClassObject(REFCLSID clsid, REFIID iid, void** value) {
  if (clsid != kShareClass) return CLASS_E_CLASSNOTAVAILABLE;
  auto* factory = new ShareFactory();
  const HRESULT result = factory->QueryInterface(iid, value);
  factory->Release();
  return result;
}
