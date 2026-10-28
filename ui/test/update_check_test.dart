import 'package:flutter_test/flutter_test.dart';
import 'package:pasteferry_ui/mobile/update_check.dart';

void main() {
  test('版本比较按数字段进行', () {
    expect(UpdateCheck.isNewer('2.7.1', '2.7.0'), isTrue);
    expect(UpdateCheck.isNewer('2.7.0', '2.7.0'), isFalse);
    expect(UpdateCheck.isNewer('2.7.0', '2.7.1'), isFalse);
    // 两位数不能按字符串比
    expect(UpdateCheck.isNewer('2.7.10', '2.7.9'), isTrue);
    expect(UpdateCheck.isNewer('2.10.0', '2.9.9'), isTrue);
    expect(UpdateCheck.isNewer('3.0.0', '2.99.99'), isTrue);
  });

  test('缺段位按 0 算，dev 后缀不影响', () {
    expect(UpdateCheck.isNewer('2.8', '2.7.9'), isTrue);
    expect(UpdateCheck.isNewer('2.7', '2.7.0'), isFalse);
    expect(UpdateCheck.isNewer('2.7.1-dev', '2.7.0'), isTrue);
    expect(UpdateCheck.isNewer('0.1.0-dev', '2.7.0'), isFalse);
  });

  test('下载地址不带版本号，永远指向最新版', () {
    expect(UpdateCheck.apkUrl, endsWith('/releases/latest/download/PasteFerry-android-arm64.apk'));
    expect(UpdateCheck.manifestUrls.first, 'https://pasteferry.cc/updates/latest.json');
  });
}
