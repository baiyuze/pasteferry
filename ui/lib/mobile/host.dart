import 'package:flutter/services.dart';

/// Android 宿主（Kotlin，`android/app/src/main/kotlin/com/pasteferry/app/MainActivity.kt`）提供的几件事。
/// 记录、发送、配对、设置都经 gRPC 直接和 Go 核心说，这里只有 Go 核心做不了的：
/// 启停核心、后台保持连接、保存到相册与「下载」、系统分享、通知与电池优化的权限。
abstract final class Host {
  static const _channel = MethodChannel('pasteferry/host');

  /// 启动 Go 核心（已在运行时什么也不做），返回它的数据目录：daemon.json 就在里面
  static Future<String> start() async {
    final got = await _channel.invokeMapMethod<String, Object?>('start');
    return got!['dataDir']! as String;
  }

  static Future<bool> keepAlive() async => await _channel.invokeMethod<bool>('keepAlive') ?? true;

  static Future<void> setKeepAlive(bool on) => _channel.invokeMethod('setKeepAlive', on);

  /// 图片存进相册，其他文件存进「下载/PasteFerry」。返回存下的文件数
  static Future<int> save(List<String> paths) async =>
      await _channel.invokeMethod<int>('save', {'paths': paths}) ?? 0;

  static Future<void> share(List<String> paths) => _channel.invokeMethod('share', {'paths': paths});

  /// granted、denied（还能请求）或 blocked（只能去系统设置里打开）
  static Future<String> notifications() async =>
      await _channel.invokeMethod<String>('notifications') ?? 'denied';

  static Future<String> requestNotifications() async =>
      await _channel.invokeMethod<String>('requestNotifications') ?? 'denied';

  /// 不受电池优化限制
  static Future<bool> batteryUnrestricted() async =>
      await _channel.invokeMethod<bool>('batteryUnrestricted') ?? false;

  static Future<void> requestBatteryUnrestricted() => _channel.invokeMethod('requestBatteryUnrestricted');

  /// 当前网络是 Wi-Fi 或有线网
  static Future<bool> onLan() async => await _channel.invokeMethod<bool>('onLan') ?? true;
}
