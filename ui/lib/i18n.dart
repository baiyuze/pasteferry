import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show Bidi;

import 'l10n/app_localizations.dart';

export 'l10n/app_localizations.dart';

/// 繁体中文分台湾与香港两种，用词不同（位址与地址、網路与網絡等）。
const zhHantTW = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
const zhHantHK = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK');

/// 中文与日文以外的语言：设置里存的写法（Config.language）与界面用的 Locale 同名，只有葡萄牙语例外，
/// 设置里写 pt-BR（巴西的写法），界面用 pt：葡萄牙的用户也用这一份。
/// 后台服务在 client-core/internal/lang 里有同一张表，两边要一起改。
const otherLanguages = ['ar', 'de', 'es', 'fr', 'id', 'it', 'ko', 'pl', 'pt-BR', 'ru', 'tr', 'uk', 'vi'];

/// 界面支持的语言。文案在 lib/l10n/app_*.arb 里，每种语言一个文件，改完运行 flutter gen-l10n。
const supportedLocales = [
  Locale('en'),
  Locale('zh'),
  zhHantTW,
  zhHantHK,
  Locale('ja'),
  Locale('ar'),
  Locale('de'),
  Locale('es'),
  Locale('fr'),
  Locale('id'),
  Locale('it'),
  Locale('ko'),
  Locale('pl'),
  Locale('pt'),
  Locale('ru'),
  Locale('tr'),
  Locale('uk'),
  Locale('vi'),
];

/// 设置里的语言选项：值是 Config.language 的写法，名字用各自的语言写，选错了语言的人也认得出自己的。
const languageNames = {
  'zh-Hans': '简体中文',
  'zh-Hant-TW': '繁體中文（台灣）',
  'zh-Hant-HK': '繁體中文（香港）',
  'en': 'English',
  'ja': '日本語',
  'ko': '한국어',
  'de': 'Deutsch',
  'es': 'Español',
  'fr': 'Français',
  'it': 'Italiano',
  'pt-BR': 'Português (Brasil)',
  'pl': 'Polski',
  'tr': 'Türkçe',
  'ru': 'Русский',
  'uk': 'Українська',
  'vi': 'Tiếng Việt',
  'id': 'Bahasa Indonesia',
  'ar': 'العربية',
};

/// 设置里存的语言（Config.language）→ 界面用的 Locale。空字符串表示跟随系统，返回 null。
Locale? localeFromSetting(String value) => switch (value) {
      'zh-Hans' => const Locale('zh'),
      'zh-Hant-TW' => zhHantTW,
      'zh-Hant-HK' => zhHantHK,
      'en' => const Locale('en'),
      'ja' => const Locale('ja'),
      'pt-BR' => const Locale('pt'),
      _ when otherLanguages.contains(value) => Locale(value),
      _ => null,
    };

/// 按系统的语言偏好顺序，取第一个支持的；都不支持时用英文。
Locale resolveLocale(List<Locale>? preferred) {
  for (final l in preferred ?? const <Locale>[]) {
    if (l.languageCode == 'zh') return _chinese(l);
    for (final s in supportedLocales) {
      if (s.languageCode == l.languageCode) return s;
    }
  }
  return const Locale('en');
}

/// 中文用简体还是哪种繁体。各系统报得不一样：macOS 是 zh-Hant-TW，Windows 是 zh-TW，
/// Linux 是 zh_TW，所以写了文字（Hant、Hans）看文字，没写时看地区。
/// 香港、澳门用香港的繁体，其他繁体用台湾的。
Locale _chinese(Locale l) {
  final region = l.countryCode?.toUpperCase();
  final hant = l.scriptCode == null ? const {'TW', 'HK', 'MO'}.contains(region) : l.scriptCode == 'Hant';
  if (!hant) return const Locale('zh');
  return region == 'HK' || region == 'MO' ? zhHantHK : zhHantTW;
}

/// 不在 widget 里的代码（AppState 的错误提示、相对时间等）用它取文案。
/// MaterialApp 每次构建时按当前语言更新；启动前先按系统语言给一个。
AppLocalizations appL10n = lookupAppLocalizations(resolveLocale(PlatformDispatcher.instance.locales));

/// 把一段按从左到右排的文字（快捷键 ⌃⌥⇧⌘V、⌥1）隔离出来：放进阿拉伯语这类从右到左的界面里，
/// ⌘、⇧ 这些没有方向的符号不会被排反。前后加的是 Unicode 的 LRI 与 PDI，看不见。
String ltr(String s) => '\u2066$s\u2069';

/// 当前界面语言是不是从右到左写（阿拉伯语）。跟着 [appL10n] 变
bool get rtlInterface => Bidi.isRtlLanguage(appL10n.localeName);

/// 只在从右到左的界面里用 [ltr] 隔离：「54 B」夹在两段阿拉伯文中间时，数字和单位会被排反成「B 54」
String ltrInRtl(String s) => rtlInterface ? ltr(s) : s;

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// 界面语言 → Config.language 的写法，也是更新日志的语言代码。
/// 最新日志覆盖全部界面语言；旧日志缺少当前语言时由后台服务回退英文。
String settingFromLocale(Locale l) {
  if (l.languageCode == 'zh') {
    if (l.countryCode == 'HK' || l.countryCode == 'MO') return 'zh-Hant-HK';
    if (l.scriptCode == 'Hant' || l.countryCode == 'TW') return 'zh-Hant-TW';
    return 'zh-Hans';
  }
  if (l.languageCode == 'pt') return 'pt-BR';
  if (l.languageCode == 'ja' || otherLanguages.contains(l.languageCode)) return l.languageCode;
  return 'en';
}

/// 官网下载页，按界面语言。中文页面上有 Gitee 国内镜像。官网只有这五种语言，其他语言用英文页。
String downloadPageUrl(Locale l) => switch (settingFromLocale(l)) {
      'zh-Hans' => 'https://pasteferry.cc/download/',
      'zh-Hant-TW' => 'https://pasteferry.cc/zh-tw/download/',
      'zh-Hant-HK' => 'https://pasteferry.cc/zh-hk/download/',
      'ja' => 'https://pasteferry.cc/ja/download/',
      _ => 'https://pasteferry.cc/en/download/',
    };
