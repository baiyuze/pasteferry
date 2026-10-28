import 'dart:convert';
import 'dart:io';

/// 检查更新（手机上）。
///
/// 更新清单固定在 pasteferry.cc 与 Gitee 两个地址，里面只有「最新版本号」；
/// 安装包文件名不带版本号，所以下载地址也是固定的，直接打开浏览器下载即可。
/// 不依赖桌面端那套按平台解析安装包的逻辑。
class UpdateCheck {
  static const manifestUrls = [
    'https://pasteferry.cc/updates/latest.json',
    'https://gitee.com/baiyuze/pasteferry/raw/main/updates/latest.json',
  ];

  /// 安装包地址：文件名固定，永远指向最新版
  static const apkUrl =
      'https://github.com/baiyuze/pasteferry/releases/latest/download/PasteFerry-android-arm64.apk';

  /// 返回最新版本号；全都取不到时返回 null
  static Future<String?> latest() async {
    for (final url in manifestUrls) {
      final v = await _read(url);
      if (v != null) return v;
    }
    return null;
  }

  static Future<String?> _read(String url) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close().timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final body = await res.transform(utf8.decoder).join();
      final json = jsonDecode(body);
      final latest = json is Map ? json['latest'] : null;
      return latest is String && latest.isNotEmpty ? latest : null;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  /// a 是否比 b 新。只比较数字段，忽略 -dev 之类的后缀。
  static bool isNewer(String a, String b) {
    List<int> parts(String s) => s
        .split(RegExp(r'[^0-9]+'))
        .where((x) => x.isNotEmpty)
        .map((x) => int.tryParse(x) ?? 0)
        .toList();
    final x = parts(a), y = parts(b);
    for (var i = 0; i < 3; i++) {
      final xi = i < x.length ? x[i] : 0;
      final yi = i < y.length ? y[i] : 0;
      if (xi != yi) return xi > yi;
    }
    return false;
  }
}
