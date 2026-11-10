// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'السجل';

  @override
  String get navDevices => 'الأجهزة';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get linkConnecting => 'جارٍ الاتصال…';

  @override
  String get linkServiceNotRunning => 'خدمة الخلفية لا تعمل';

  @override
  String get linkLanMode => 'جارٍ البحث عن أجهزة على هذه الشبكة';

  @override
  String get linkServerUnreachable =>
      'تعذر الوصول إلى الخادم؛ المزامنة مستمرة على هذه الشبكة';

  @override
  String get linkNothingOn => 'اكتشاف الشبكة المحلية متوقف، ولم يتم تعيين خادم';

  @override
  String get linkLanBlocked => 'يحظر macOS الوصول إلى الشبكة المحلية';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهاز متصل',
      many: '$count جهازًا متصلًا',
      few: '$count أجهزة متصلة',
      two: 'جهازان متصلان',
      one: 'جهاز واحد متصل',
      zero: 'لا أجهزة متصلة',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'متصل بالخادم';

  @override
  String linkConnectionLost(String detail) {
    return 'انقطع الاتصال: $detail';
  }

  @override
  String get linkServiceDisconnected => 'انقطع الاتصال بخدمة الخلفية';

  @override
  String get linkServiceDisabled => 'المزامنة في الخلفية متوقفة';

  @override
  String get errServiceNotConnected => 'غير متصل بخدمة الخلفية';

  @override
  String get errUnimplemented => 'هذه الميزة غير متاحة بعد';

  @override
  String get errUnavailable => 'تعذر الوصول إلى خدمة الخلفية';

  @override
  String errServiceStart(String detail) {
    return 'تعذر تشغيل خدمة الخلفية: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'تعذرت إعادة تشغيل خدمة الخلفية: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'تعذر ضبط PasteFerry ليبدأ عند تسجيل الدخول: $detail';
  }

  @override
  String get thisMacTitle => 'جهاز Mac هذا';

  @override
  String get thisPcTitle => 'هذا الكمبيوتر';

  @override
  String get thisMacInText => 'جهاز Mac هذا';

  @override
  String get thisPcInText => 'هذا الكمبيوتر';

  @override
  String get bothMacs => 'كلا جهازي Mac';

  @override
  String get bothDevices => 'كلا الجهازين';

  @override
  String get thisDeviceShort => 'هذا الجهاز';

  @override
  String fromDevice(String name) {
    return 'من $name';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get save => 'حفظ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get continueAction => 'متابعة';

  @override
  String get justNow => 'الآن';

  @override
  String secondsAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'منذ $n ثانية',
      many: 'منذ $n ثانية',
      few: 'منذ $n ثوانٍ',
      two: 'منذ ثانيتين',
      one: 'منذ ثانية',
      zero: 'الآن',
    );
    return '$_temp0';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'منذ $n دقيقة',
      many: 'منذ $n دقيقة',
      few: 'منذ $n دقائق',
      two: 'منذ دقيقتين',
      one: 'منذ دقيقة',
      zero: 'الآن',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'منذ $n ساعة',
      many: 'منذ $n ساعة',
      few: 'منذ $n ساعات',
      two: 'منذ ساعتين',
      one: 'منذ ساعة',
      zero: 'منذ أقل من ساعة',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'منذ $n يوم',
      many: 'منذ $n يومًا',
      few: 'منذ $n أيام',
      two: 'منذ يومين',
      one: 'أمس',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String durationHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ساعة',
      many: '$n ساعة',
      few: '$n ساعات',
      two: 'ساعتان',
      one: 'ساعة واحدة',
      zero: '$n ساعة',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n يوم',
      many: '$n يومًا',
      few: '$n أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: '$n يوم',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle => 'انسخ على أي من أجهزتك وسيظهر هنا';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0، مدة الحفظ: $ttl';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get filterText => 'نص';

  @override
  String get filterImage => 'صور';

  @override
  String get filterFile => 'ملفات';

  @override
  String get filterLink => 'روابط';

  @override
  String get historyClearTooltip => 'مسح السجل';

  @override
  String get historyEmptyTitle => 'لا شيء هنا بعد';

  @override
  String get historyEmptyFilteredTitle => 'لا عناصر من هذا النوع';

  @override
  String get historyEmptyBody =>
      'انسخ نصًا أو صورة أو ملفًا على أي جهاز مقترن وسيظهر هنا.';

  @override
  String get clearConfirmTitle => 'هل تريد مسح السجل بالكامل؟';

  @override
  String clearConfirmBody(String device) {
    return 'سيتم حذف كل ما تمت مزامنته من أجهزتك والملفات المخزنة مؤقتًا من $device. لن تتأثر الملفات الأصلية.';
  }

  @override
  String get clear => 'مسح';

  @override
  String get historyCleared => 'تم مسح السجل';

  @override
  String get permDeniedTitle => 'يتعذر على PasteFerry قراءة الحافظة';

  @override
  String get permAskTitle => 'اسمح لـ PasteFerry بقراءة الحافظة';

  @override
  String get permDeniedBody =>
      'لن تتم مزامنة ما تنسخه على جهاز Mac هذا. في إعدادات النظام، اضبط PasteFerry Daemon على «السماح».';

  @override
  String get permAskBody =>
      'وإلا فسيسألك macOS في كل مرة. في إعدادات النظام، اضبط PasteFerry Daemon على «السماح».';

  @override
  String get openSystemSettings => 'فتح إعدادات النظام';

  @override
  String get fetch => 'استلام';

  @override
  String get fetchStarted => 'جارٍ الاستلام… تابع التقدم في السجل';

  @override
  String get transferFailed => 'فشل النقل';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get putOnClipboard => 'نسخ إلى الحافظة';

  @override
  String get putOnClipboardDone => 'في الحافظة';

  @override
  String get deleteRecord => 'حذف هذا العنصر';

  @override
  String get deleted => 'تم الحذف';

  @override
  String get emptyRecord => '(فارغ)';

  @override
  String get imageRecord => 'صورة';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others عنصر آخر',
      many: '$others عنصرًا آخر',
      few: '$others عناصر أخرى',
      two: 'عنصران آخران',
      one: 'عنصر آخر',
      zero: 'لا شيء آخر',
    );
    return '$name و$_temp0';
  }

  @override
  String get searchHint => 'البحث في النصوص وأسماء الملفات';

  @override
  String get searchClear => 'مسح البحث';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      many: '$count نتيجة',
      few: '$count نتائج',
      two: 'نتيجتان',
      one: 'نتيجة واحدة',
      zero: 'لا نتائج',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'لا نتائج مطابقة لـ «$query»';
  }

  @override
  String get searchEmptyBody =>
      'يبحث في النصوص المنسوخة وأسماء الملفات المنسوخة.';

  @override
  String get favoriteAction => 'إضافة إلى المفضلة';

  @override
  String get unfavoriteAction => 'إزالة من المفضلة';

  @override
  String get favoritedToast => 'تمت الإضافة إلى المفضلة';

  @override
  String get unfavoritedToast => 'تمت الإعادة إلى السجل';

  @override
  String get undo => 'تراجع';

  @override
  String get favoriteSaving => 'جارٍ الحفظ…';

  @override
  String favoritedAt(String date) {
    return 'محفوظ في $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0 · بلا مسح تلقائي · حتى $size';
  }

  @override
  String get favoritesEmptyTitle => 'لا توجد عناصر مفضلة بعد';

  @override
  String get favoritesEmptyBody =>
      'ضع نجمة على عنصر في السجل للاحتفاظ بنسخة منه هنا. لا يتم مسح المفضلة تلقائيًا أبدًا.';

  @override
  String get favoritesSearchHint => 'البحث في المفضلة';

  @override
  String favoriteLargeTitle(String size) {
    return 'هل تريد حفظ نسخة حجمها $size؟';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'تحتفظ المفضلة بنسخة خاصة بها، لذا لن يؤثر عليها تغيير الملفات الأصلية أو حذفها. سيشغل ذلك $size على $device.';
  }

  @override
  String get saveCopy => 'حفظ نسخة';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سيبقى $count عنصر مفضل.',
      many: 'سيبقى $count عنصرًا مفضلًا.',
      few: 'ستبقى $count عناصر مفضلة.',
      two: 'سيبقى عنصران مفضلان.',
      one: 'سيبقى عنصر مفضل واحد.',
      zero: 'لا توجد عناصر مفضلة.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'المفضلة';

  @override
  String get favoritesUsageDesc =>
      'لا يتم مسح المفضلة تلقائيًا أبدًا، بصرف النظر عن الإعدادات أعلاه';

  @override
  String upToSize(String size) {
    return 'حتى $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حرف',
      many: '$count حرفًا',
      few: '$count أحرف',
      two: 'حرفان',
      one: 'حرف واحد',
      zero: 'لا أحرف',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… $count حرف إجمالًا',
      many: '… $count حرفًا إجمالًا',
      few: '… $count أحرف إجمالًا',
      two: '… حرفان إجمالًا',
      one: '… حرف واحد إجمالًا',
      zero: '… لا أحرف',
    );
    return '$_temp0';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'و$count عنصر آخر',
      many: 'و$count عنصرًا آخر',
      few: 'و$count عناصر أخرى',
      two: 'وعنصران آخران',
      one: 'وعنصر آخر',
      zero: 'ولا شيء آخر',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'اختره لتنزيله أولًا';

  @override
  String detailTotalSize(String size) {
    return 'الإجمالي $size';
  }

  @override
  String get quickPaste => 'اللصق السريع';

  @override
  String get quickPasteWindow => 'نافذة اللصق السريع';

  @override
  String get quickPasteWindowDesc =>
      'اضغط الاختصار في أي تطبيق لإظهار السجل؛ اختر عنصرًا ليتم لصقه';

  @override
  String get quickPasteShortcut => 'الاختصار';

  @override
  String get quickPasteRecord => 'انقر للتغيير';

  @override
  String get quickPasteRecording => 'اضغط الاختصار الجديد…';

  @override
  String get quickPasteUseDefault => 'استخدام الافتراضي';

  @override
  String get quickPasteNeedsModifier =>
      'يجب أن يتضمن ⌃ أو ⌥ أو ⇧ أو ⌘، أو استخدم مفتاح وظائف';

  @override
  String get quickPasteNeedsModifierPc =>
      'يجب أن يتضمن Ctrl أو Alt أو Shift أو مفتاح Windows، أو استخدم مفتاح وظائف';

  @override
  String get quickPasteAfterPick => 'بعد اختيار عنصر';

  @override
  String get quickPastePasteIt => 'لصقه';

  @override
  String get quickPasteCopyIt => 'نسخه فقط';

  @override
  String get quickPasteIndexKey => 'اختيار أحد أول 9 عناصر';

  @override
  String get quickPasteIndexKeyDesc =>
      'في نافذة اللصق السريع، اضغط مع الاستمرار على هذا المفتاح ثم اضغط 1–9';

  @override
  String get quickPasteAccessibility => 'تسهيلات الاستخدام';

  @override
  String get quickPasteAccessibilityDesc =>
      'مطلوبة للصق نيابة عنك. بدونها، يتم نسخ العناصر وعليك الضغط على ⌘V.';

  @override
  String get quickPasteAllowed => 'مسموح';

  @override
  String get quickPasteAllow => 'السماح…';

  @override
  String get quickPasteNotRunning => 'نافذة اللصق السريع لا تعمل';

  @override
  String quickPasteInUse(String key) {
    return 'يستخدم تطبيق آخر $key. اختر اختصارًا آخر.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'تعذر تعيين $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'اضبطه في إعدادات اختصارات النظام';

  @override
  String get quickPasteWaylandDesc =>
      'في Wayland، أضف الاختصار من إعدادات لوحة المفاتيح في سطح المكتب. يتم نسخ العناصر المختارة؛ اضغط Ctrl+V للصق.';

  @override
  String get quickPasteAddShortcut => 'إضافة اختصار للنظام';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'تمت الإضافة. اضغط $key لتجربته.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'أضف اختصارًا مخصصًا في إعدادات لوحة المفاتيح في سطح المكتب يشغل الأمر: $command';
  }

  @override
  String get pickerSearch => 'بحث';

  @override
  String get pickerPaste => 'لصق';

  @override
  String get pickerPlainText => 'نص عادي';

  @override
  String get pickerCopyOnly => 'نسخ فقط';

  @override
  String get pickerUnfavoriteHint => 'إزالة (إعادة إلى السجل)';

  @override
  String pickerPasteManually(String key) {
    return 'يتم نسخ العناصر المختارة — اضغط $key للصق';
  }

  @override
  String get pickerGrantHint => 'اسمح بتسهيلات الاستخدام للصق مباشرة';

  @override
  String pickerElevated(String key) {
    return 'تعمل هذه النافذة كمسؤول — اضغط $key للصق بعد الاختيار';
  }

  @override
  String get pickerDownloading => 'جارٍ التنزيل — سيتم اللصق عند الانتهاء';

  @override
  String get imagePreviewTitle => 'معاينة الصورة';

  @override
  String get closePreview => 'إغلاق المعاينة';

  @override
  String get previousImage => 'الصورة السابقة';

  @override
  String get nextImage => 'الصورة التالية';

  @override
  String get previewHint => 'مرر أو اقرص للتكبير، واسحب للتنقل';

  @override
  String get fitWindow => 'ملاءمة النافذة';

  @override
  String get previewDeleted => 'تم حذف هذه الصورة من السجل';

  @override
  String get previewExpired => 'انتهت صلاحية هذه الصورة ولا يمكن معاينتها';

  @override
  String get previewDownloading => 'جارٍ تنزيل الصورة…';

  @override
  String get previewDownloadFailed => 'فشل التنزيل. حاول مرة أخرى.';

  @override
  String get previewNotDownloaded => 'هذه الصورة ليست على هذا الكمبيوتر بعد';

  @override
  String get downloadAndPreview => 'تنزيل ومعاينة';

  @override
  String get previewUnavailable => 'لا يمكن معاينة هذه الصورة الآن';

  @override
  String get imageSemantic => 'صورة من السجل';

  @override
  String get previewUnreadable =>
      'تعذرت قراءة الصورة. ربما تم مسح الملف أو أنه تالف.';

  @override
  String get devicesSubtitleEmpty => 'بعد الإقران، تتشارك أجهزتك حافظة واحدة';

  @override
  String devicesSubtitle(int paired, int online) {
    return 'المقترنة: $paired، المتصلة: $online';
  }

  @override
  String get addDevice => 'إضافة جهاز';

  @override
  String thisDeviceFootnote(String both) {
    return 'عند الإقران، يعرض $both السطرين نفسيهما من بصمات الأمان، سطرًا لكل جهاز. لا تؤكد إلا إذا تطابقا حرفًا بحرف.';
  }

  @override
  String get noDevicesTitle => 'لا توجد أجهزة مقترنة بعد';

  @override
  String get noDevicesBody =>
      'افتح PasteFerry على الكمبيوتر الآخر واربط الجهازين برمز إقران من 6 أحرف. على الشبكة نفسها، يمكنك أيضًا فتح «البحث عن أجهزة قريبة» على كليهما والنقر على الجهاز الآخر.';

  @override
  String get pairedDevices => 'الأجهزة المقترنة';

  @override
  String get pairedFootnote =>
      'مباشر: تنتقل البيانات مباشرة بين الجهازين. ترحيل: عندما تمنع الشبكة المسار المباشر، تمر البيانات عبر خادمك وتبقى مشفرة من طرف إلى طرف.';

  @override
  String get offline => 'غير متصل';

  @override
  String get direct => 'مباشر';

  @override
  String get relay => 'ترحيل';

  @override
  String get online => 'متصل';

  @override
  String get moreActions => 'المزيد';

  @override
  String get copyFingerprint => 'نسخ البصمة';

  @override
  String get unpairEllipsis => 'إلغاء الإقران…';

  @override
  String get fingerprintCopied => 'تم نسخ البصمة';

  @override
  String unpairTitle(String name) {
    return 'هل تريد إلغاء الإقران مع «$name»؟';
  }

  @override
  String get unpairBody =>
      'سيتوقف الجهازان عن المزامنة. للمزامنة مجددًا، يجب إقرانهما والتحقق من البصمات مرة أخرى.';

  @override
  String get unpair => 'إلغاء الإقران';

  @override
  String get unpaired => 'تم إلغاء الإقران';

  @override
  String get enterAddressEllipsis => 'إدخال عنوانه…';

  @override
  String setAddressTitle(String name) {
    return 'عنوان «$name»';
  }

  @override
  String setAddressBody(String name) {
    return 'استخدم هذا عندما يكون الجهازان على شبكتين فرعيتين مختلفتين، أو عندما يتغير عنوانا كليهما. أدخل العنوان الظاهر على «$name» ضمن «إضافة جهاز ← عرض رمز».';
  }

  @override
  String get addressSaved => 'جارٍ البحث عنه على ذلك العنوان';

  @override
  String get lanBlockedTitle => 'يحظر macOS الوصول إلى الشبكة المحلية';

  @override
  String lanBlockedBody(String device) {
    return 'قم بتشغيل PasteFerry Daemon في «إعدادات النظام ← الخصوصية والأمن ← الشبكة المحلية». حتى ذلك الحين، لن يتمكن $device من الاتصال بالأجهزة على هذه الشبكة.';
  }

  @override
  String get searchNearby => 'البحث عن أجهزة قريبة';

  @override
  String get nearbyTitle => 'الأجهزة القريبة';

  @override
  String get nearbySearching => 'جارٍ البحث عن أجهزة قريبة…';

  @override
  String get nearbyHint =>
      'افتح «البحث عن أجهزة قريبة» على الكمبيوتر الآخر أيضًا وسيظهر هنا. انقر عليه للإقران.';

  @override
  String nearbyVisible(String device) {
    return 'ما دامت هذه النافذة مفتوحة، يمكن للأجهزة على هذه الشبكة رؤية اسم $device.';
  }

  @override
  String get nearbyPaired => 'مقترن';

  @override
  String nearbyRequesting(String name) {
    return 'جارٍ التواصل مع «$name»…';
  }

  @override
  String nearbyNoReply(String name) {
    return 'لم يستجب «$name». تأكد من أن «البحث عن أجهزة قريبة» لا يزال مفتوحًا عليه.';
  }

  @override
  String get nearbyLanOffTitle => 'اكتشاف الشبكة المحلية متوقف';

  @override
  String get nearbyLanOffBody =>
      'قم بتشغيل «البحث عن أجهزة على هذه الشبكة» في «الإعدادات ← الاتصال» لرؤية الأجهزة القريبة، أو استخدم رمز إقران بدلًا من ذلك.';

  @override
  String get generateCode => 'عرض رمز';

  @override
  String get enterCode => 'إدخال رمز';

  @override
  String get codeFailedTitle => 'تعذر إنشاء رمز إقران';

  @override
  String get enterOnOther => 'أدخل هذا الرمز على جهازك الآخر';

  @override
  String get codeCopied => 'تم نسخ الرمز';

  @override
  String get codeHint => 'انقر للنسخ. صالح لمدة 5 دقائق.';

  @override
  String afterEnterFootnote(String both) {
    return 'بعد إدخاله، يعرض $both السطرين نفسيهما من بصمات الأمان. لا تؤكد إلا إذا تطابقا.';
  }

  @override
  String get codeInvalid => 'يتكون رمز الإقران من 6 أحرف أو أرقام';

  @override
  String get localAddress => 'العنوان';

  @override
  String get addressHint =>
      'على شبكة فرعية مختلفة؟ أدخل هذا العنوان على الجهاز الآخر أيضًا.';

  @override
  String get addressCopied => 'تم نسخ العنوان';

  @override
  String get differentSubnet => 'على شبكة فرعية مختلفة؟';

  @override
  String get peerAddress => 'العنوان الظاهر أسفل الرمز';

  @override
  String get pairNotFound =>
      'تعذر العثور على ذلك الجهاز. إذا كان على شبكة فرعية مختلفة، فأدخل العنوان الظاهر أسفل رمزه.';

  @override
  String get pairNotFoundAddress =>
      'لم يستجب أي جهاز على ذلك العنوان. تحقق من العنوان ومن أن الجهاز الآخر لا يزال يعرض رمزه. قد يكون جدار الحماية على ذلك الجهاز يحظر الاتصال أيضًا.';

  @override
  String get codeWrong => 'الرمز غير صحيح أو انتهت صلاحيته';

  @override
  String get codeExpired =>
      'انتهت صلاحية هذا الرمز. اعرض رمزًا جديدًا على الجهاز الآخر.';

  @override
  String get addressInvalid =>
      'هذا العنوان غير صالح. أدخل عنوانًا مثل 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'قم أولًا بتشغيل اكتشاف الشبكة المحلية أو بتعيين خادم في «الإعدادات ← الاتصال».';

  @override
  String get enterCodeShown => 'أدخل الرمز الظاهر على جهازك الآخر';

  @override
  String get pairingDone => 'تم الإقران';

  @override
  String get pairingRejected => 'تم رفض الإقران';

  @override
  String get verifyTitle => 'تحقق من بصمات الأمان';

  @override
  String pairingWith(String name) {
    return 'جارٍ الإقران مع «$name»';
  }

  @override
  String verifyBody(String both) {
    return 'يجب أن يكون السطران على $both متطابقين. إذا اختلف ولو حرف واحد، فقد يكون هناك من يعبث بالاتصال، لذا ارفض.';
  }

  @override
  String get rejectMismatch => 'غير متطابقة، رفض';

  @override
  String get confirmMatch => 'متطابقة، إقران';

  @override
  String get server => 'الخادم (اختياري)';

  @override
  String get signalingUrl => 'خادم الإشارات';

  @override
  String get signalingUrlDesc => 'اتركه فارغًا للمزامنة المحلية فقط';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'تحسين الاتصالات المباشرة';

  @override
  String get publicStunDesc => 'يمكن للخوادم العامة رؤية عنوان IP العام لديك';

  @override
  String get connectionStatus => 'الاتصال';

  @override
  String get disconnectedDesc => 'تحقق من عنوان الخادم ومن توفره';

  @override
  String get connected => 'متصل';

  @override
  String get notConnected => 'غير متصل';

  @override
  String get notSet => 'غير محدد';

  @override
  String get serverCleared => 'تمت إزالة الخادم. المزامنة على هذه الشبكة فقط.';

  @override
  String get localNetwork => 'الشبكة المحلية';

  @override
  String get lanDiscovery => 'البحث عن أجهزة على هذه الشبكة';

  @override
  String get lanDiscoveryDesc =>
      'اكتشاف مجهول الهوية؛ لا تظهر الأسماء إلا أثناء البحث عن أجهزة قريبة';

  @override
  String get macLocalNetwork => 'الوصول إلى الشبكة المحلية';

  @override
  String get macLocalNetworkDesc =>
      'اسمح لـ PasteFerry Daemon في إعدادات النظام';

  @override
  String get allowLan => 'جدار حماية Windows';

  @override
  String get allowLanDesc => 'السماح بالاتصالات المحظورة؛ يتطلب موافقة المسؤول';

  @override
  String get allow => 'سماح';

  @override
  String get allowLanDone =>
      'تم السماح. يمكن للأجهزة الأخرى الآن الوصول إلى هذا الجهاز.';

  @override
  String get deviceName => 'اسم الجهاز';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة النظام';

  @override
  String get sync => 'المزامنة';

  @override
  String get autoSyncLimit => 'حد المزامنة التلقائية';

  @override
  String get autoSyncLimitDesc => 'استلم العناصر الأكبر يدويًا من السجل';

  @override
  String get autoApply => 'وضع العناصر المستلمة في الحافظة';

  @override
  String get whatToSync => 'المحتوى المراد مزامنته';

  @override
  String get syncFiles => 'الملفات والمجلدات';

  @override
  String get syncText => 'نص عادي';

  @override
  String get syncRich => 'نص منسق';

  @override
  String get syncImages => 'الصور ولقطات الشاشة';

  @override
  String get storage => 'التخزين';

  @override
  String get storageFootnote =>
      'يتم حذف السجل المنتهي والملفات المؤقتة تلقائيًا.';

  @override
  String get keepHistory => 'الاحتفاظ بالسجل لمدة';

  @override
  String get keepCache => 'الاحتفاظ بالملفات المؤقتة لمدة';

  @override
  String get keepCacheDesc => 'لا تتجاوز مدة الاحتفاظ بالسجل';

  @override
  String get cacheUsage => 'حجم الملفات المؤقتة';

  @override
  String get backgroundSync => 'المزامنة في الخلفية';

  @override
  String get backgroundService => 'خدمة الخلفية';

  @override
  String get backgroundServiceDesc =>
      'تبدأ عند تسجيل الدخول، وتواصل المزامنة والنافذة مغلقة';

  @override
  String get restart => 'إعادة التشغيل';

  @override
  String get restarted => 'تمت إعادة تشغيل خدمة الخلفية';

  @override
  String get disableEllipsis => 'إيقاف…';

  @override
  String get about => 'حول';

  @override
  String get aboutDesc => 'مفتوح المصدر بترخيص AGPL-3.0';

  @override
  String get homepage => 'الموقع الإلكتروني';

  @override
  String get feedback => 'الإبلاغ عن مشكلة';

  @override
  String get disableTitle => 'هل تريد إيقاف المزامنة في الخلفية؟';

  @override
  String disableBody(String device) {
    return 'سيتوقف PasteFerry على $device عن المزامنة ولن يبدأ عند تسجيل الدخول. سيتم الاحتفاظ بالسجل وعمليات الإقران.';
  }

  @override
  String get disable => 'إيقاف';

  @override
  String get disabled => 'المزامنة في الخلفية متوقفة';

  @override
  String get urlMustBeWs => 'يجب أن يبدأ العنوان بـ ws:// أو wss://';

  @override
  String get serverUpdated => 'تم تحديث الخادم. جارٍ إعادة الاتصال…';

  @override
  String get deviceNameUpdated => 'تم تحديث اسم الجهاز';

  @override
  String get diagIntro =>
      'يتضمن هذا التقرير إصدار التطبيق ونظامك والإعدادات والأجهزة وسجلات التشغيل الأخيرة. يتم استبدال أسماء الأجهزة وعنوان الخادم وعناوين IP العامة ومجلد المستخدم وأسماء الملفات، ولا تتم كتابة ما تنسخه في سجلات التشغيل أبدًا. المشكلات على GitHub عامة، لذا راجع التقرير قبل نشره.';

  @override
  String get diagVerboseTitle => 'التسجيل المفصل';

  @override
  String get diagVerboseDesc =>
      'لمشكلات الاتصال: قم بتشغيله، ثم أعد إحداث المشكلة، ثم ارجع لإنشاء التقرير. يتوقف تلقائيًا بعد 30 دقيقة.';

  @override
  String get diagVerboseOn => 'تشغيل لمدة 30 دقيقة';

  @override
  String diagVerboseUntil(String time) {
    return 'يعمل حتى $time';
  }

  @override
  String get diagVerboseOff => 'إيقاف';

  @override
  String get diagRefresh => 'إعادة الإنشاء';

  @override
  String get diagSave => 'حفظ كملف';

  @override
  String diagSaved(String name) {
    return 'تم الحفظ في مجلد التنزيلات: $name';
  }

  @override
  String get diagCopy => 'نسخ التقرير';

  @override
  String get diagCopied => 'تم نسخ التقرير';

  @override
  String get diagNewIssue => 'إنشاء مشكلة على GitHub';

  @override
  String get diagIssueHint =>
      'تم نسخ التقرير. الصقه في خانة «Diagnostics report» في المشكلة.';

  @override
  String diagFailed(String detail) {
    return 'تعذر إنشاء التقرير: $detail';
  }

  @override
  String get svcExtractTitle => 'قم بتثبيت PasteFerry أو استخراجه أولًا';

  @override
  String get svcExtractBody =>
      'يعمل PasteFerry مباشرة من ملف zip، ويختفي مجلده المؤقت عند إغلاقه. لتفعيل المزامنة في الخلفية، قم بتشغيل المثبت، أو استخرج المجلد بالكامل وافتحه من هناك.';

  @override
  String get svcMoveTitle => 'انقل PasteFerry إلى «التطبيقات» أولًا';

  @override
  String get svcMoveBody =>
      'يعمل PasteFerry مباشرة من صورة القرص. لتفعيل المزامنة في الخلفية، اسحبه إلى «التطبيقات»، وأخرج صورة القرص، ثم افتحه من «التطبيقات».';

  @override
  String get svcStartTitle => 'ابدأ استخدام PasteFerry';

  @override
  String get svcStartBody =>
      'يشغل PasteFerry عملية صغيرة في الخلفية لمزامنة الحافظة. إغلاق النافذة لا يوقفها. التشغيل عند تسجيل الدخول إعداد منفصل، وهو متوقف في عمليات التثبيت الجديدة.';

  @override
  String get svcEnable => 'تفعيل المزامنة في الخلفية';

  @override
  String get svcStaleTitle => 'أعد تفعيل المزامنة في الخلفية';

  @override
  String get svcStaleBodyWin =>
      'تم نقل PasteFerry، لكن التشغيل عند تسجيل الدخول لا يزال يشير إلى المكان القديم. أعد تفعيلها لتستخدم عملية الخلفية هذه النسخة. سيتم الاحتفاظ بالسجل وعمليات الإقران.';

  @override
  String get svcStaleBodyMac =>
      'تم نقل PasteFerry، أو تم تثبيته بسكربت قديم. أعد تفعيلها لتستخدم عملية الخلفية هذا التطبيق. سيتم الاحتفاظ بالسجل وعمليات الإقران.';

  @override
  String get svcReenable => 'إعادة التفعيل';

  @override
  String get svcStoppedTitle => 'خدمة الخلفية لا تعمل';

  @override
  String get svcStoppedBody =>
      'خدمة الخلفية متوقفة. شغّلها بالزر أدناه؛ ويُضبط التشغيل عند تسجيل الدخول بشكل منفصل في الإعدادات.';

  @override
  String get svcDevBodyWin =>
      'هذا إصدار تطويري لا يوجد بجانبه pasteferryd.exe. قم بتشغيل scripts\\build-windows.ps1 في مجلد المصدر لبناء إصدار كامل.';

  @override
  String get svcDevBodyLinux =>
      'هذا إصدار تطويري لا يوجد بجانبه pasteferryd. قم بتشغيل ./scripts/package-linux.sh في مجلد المصدر لبناء إصدار كامل.';

  @override
  String get svcDevBodyMac =>
      'هذا إصدار تطويري بدون خدمة الخلفية. قم بتشغيل ./scripts/install-macos.sh في مجلد المصدر لتثبيتها.';

  @override
  String svcLogPath(String path) {
    return 'سجل التشغيل: $path';
  }

  @override
  String get svcCanDisable =>
      'يمكنك إيقاف المزامنة في الخلفية في أي وقت من الإعدادات.';

  @override
  String get officialService => 'الخدمة';

  @override
  String get useOfficialService => 'استخدام الخدمة';

  @override
  String get officialServiceDesc =>
      'مزامنة عبر الشبكات، مع تفضيل الاتصال المباشر';

  @override
  String get officialPrivacy =>
      'لا يتصل بالخدمة إلا عند تفعيلها، ويسجل معلومات الاتصال الضرورية فقط. تتم تجربة الاتصال المباشر أولًا، ولا يتم طلب الترحيل إلا عند فشله. لا يتم رفع المحتوى ولا أسماء الأجهزة الحقيقية ولا معرفات النظام الأصلية.';

  @override
  String get officialEnableTitle => 'هل تريد تفعيل الخدمة؟';

  @override
  String get officialSwitchConfirm =>
      'سيؤدي هذا إلى التبديل من خادمك المخصص. سيتم الاحتفاظ بعنوانه المحفوظ.';

  @override
  String get customServer => 'خادم مخصص';

  @override
  String get saveAndConnect => 'حفظ واتصال';

  @override
  String get officialLoading => 'جارٍ التحقق من الحصة…';

  @override
  String get officialFetchFailed =>
      'يتعذر الحصول على الحصة الآن. ستتم إعادة المحاولة تلقائيًا.';

  @override
  String get officialUnavailable =>
      'بيانات الاستخدام غير متاحة؛ قد تكون البيانات الحالية قديمة';

  @override
  String get officialQuotaTitle => 'نفدت حصة الترحيل اليومية';

  @override
  String get officialQuotaBody =>
      'تم إيقاف ترحيل الخدمة مؤقتًا حتى إعادة التعيين اليومية عند منتصف الليل بتوقيت بكين. تبقى اتصالات الشبكة المحلية والاتصالات المباشرة عبر الإنترنت متاحة. يمكن إعادة محاولة عمليات النقل الفاشلة لاحقًا.';

  @override
  String get officialPeerQuota =>
      'لم تعد لدى الجهاز الآخر حصة ترحيل. تبقى الاتصالات المباشرة متاحة.';

  @override
  String get officialPaused =>
      'ترحيل الخدمة غير متاح. تبقى الاتصالات المباشرة متاحة.';

  @override
  String get officialViewUsage => 'عرض الاستخدام';

  @override
  String get officialAcknowledge => 'حسنًا';

  @override
  String get officialToday => 'حصة الترحيل اليوم';

  @override
  String get officialUsed => 'المستخدم';

  @override
  String get officialRemaining => 'المتبقي';

  @override
  String get officialDailyLimit => 'الحصة اليومية';

  @override
  String get officialUpload => 'الرفع';

  @override
  String get officialDownload => 'التنزيل';

  @override
  String get officialReset => 'وقت إعادة التعيين (بكين)';

  @override
  String get officialUpdated => 'آخر تحديث';

  @override
  String get officialRoutes => 'طريقة اتصال الأجهزة';

  @override
  String get officialRoutesFootnote =>
      'لا تمر الاتصالات المباشرة عبر ترحيل الخدمة ولا تستهلك الحصة.';

  @override
  String get officialDeviceID => 'معرف الجهاز';

  @override
  String get officialWarning =>
      'تم استخدام 90% من حصة الترحيل اليومية. لا تستهلكها الاتصالات المباشرة.';

  @override
  String get updateCheck => 'البحث عن تحديثات';

  @override
  String get updateCheckEllipsis => 'البحث عن تحديثات…';

  @override
  String get updateAuto => 'البحث عن تحديثات تلقائيًا';

  @override
  String get updateChecking => 'جارٍ البحث عن تحديثات…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version هو أحدث إصدار.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'يتوفر PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'الإصدار الحالي $current. حجم التنزيل $size.';
  }

  @override
  String get updateNew => 'جديد';

  @override
  String get updateFixed => 'إصلاحات';

  @override
  String get updateSkip => 'تخطي هذا الإصدار';

  @override
  String get updateLater => 'لاحقًا';

  @override
  String get updateInstall => 'تنزيل وتثبيت';

  @override
  String updateDownloading(String done, String total) {
    return 'جارٍ تنزيل $done من $total';
  }

  @override
  String get updateVerifying => 'جارٍ التحقق من التنزيل…';

  @override
  String get updateInstalling =>
      'جارٍ التثبيت. سيعيد PasteFerry فتح نفسه تلقائيًا.';

  @override
  String get updateInstallingPassword =>
      'جارٍ التثبيت. سيطلب نظامك كلمة السر لأن /opt يتطلب صلاحيات المسؤول؛ ثم يعيد PasteFerry فتح نفسه تلقائيًا.';

  @override
  String get updateCheckFailed =>
      'تعذر الوصول إلى GitHub أو Gitee. حاول مرة أخرى لاحقًا.';

  @override
  String get updateDownloadFailed =>
      'لم يكتمل التنزيل. حاول مرة أخرى، أو قم بتنزيل الإصدار الجديد من الموقع الإلكتروني.';

  @override
  String updateInstallFailed(String error) {
    return 'تعذر بدء التثبيت: $error';
  }

  @override
  String get updateUnsupportedBuild => 'لا يمكن لهذا الإصدار البحث عن تحديثات.';

  @override
  String get updateBlockedDev => 'هذا إصدار تطويري، لذا لا يمكنه تحديث نفسه.';

  @override
  String get updateBlockedMustMove =>
      'يعمل PasteFerry من صورة القرص. اسحبه إلى «التطبيقات» وافتحه من هناك ليتم التحديث تلقائيًا.';

  @override
  String get updateBlockedReadOnly =>
      'لا يمكن لـ PasteFerry الكتابة في المجلد المثبت فيه. قم بتنزيل الإصدار الجديد من الموقع الإلكتروني بدلًا من ذلك.';

  @override
  String get updateBlockedUnsupported =>
      'لا يتوفر تحديث تلقائي لهذا الكمبيوتر. قم بتنزيل الإصدار الجديد من الموقع الإلكتروني.';

  @override
  String get updateOpenDownload => 'فتح صفحة التنزيل';

  @override
  String updateSidebar(String version) {
    return 'يتوفر الإصدار $version';
  }

  @override
  String updatedTo(String version) {
    return 'تم التحديث إلى $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'لم يكتمل التحديث. لا يزال لديك الإصدار $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'لم يكتمل التحديث. لا يزال لديك الإصدار $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'الواجهة $uiVersion · الخدمة $serviceVersion · البناء $build';
  }

  @override
  String get notReceived => 'لم يتم استلامه بعد — استلمه قبل اللصق';

  @override
  String get receivedPreserved =>
      'تم الاستلام؛ استخدم «نسخ إلى الحافظة» عندما تكون جاهزًا';

  @override
  String get clipboardWriteFailed => 'تم الاستلام، لكن تعذر تحديث الحافظة';

  @override
  String get receivingStatus => 'جارٍ الاستلام…';

  @override
  String get largeFileNotifications => 'تذكيرات الملفات الكبيرة';

  @override
  String get notificationsAllowed => 'الإشعارات مفعلة. يظهر التقدم في السجل.';

  @override
  String get notificationsNotRequested =>
      'قم بتفعيل الإشعارات حتى لا تنتظر الملفات الكبيرة دون تنبيه. يمكنك دائمًا استلامها من السجل.';

  @override
  String get notificationsDenied =>
      'الإشعارات محظورة في إعدادات النظام. استلم العناصر المعلقة من السجل.';

  @override
  String get notificationsUnknown =>
      'يتحكم سطح المكتب في عرض الإشعارات ووضع «عدم الإزعاج». استلم العناصر من السجل إذا لم يظهر أي تذكير.';

  @override
  String get notificationsUnavailable =>
      'إشعارات النظام غير متاحة. استلم الملفات الكبيرة من السجل.';

  @override
  String get enableNotifications => 'تفعيل التذكيرات';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notifyPendingTitle => 'استلمه لتتمكن من اللصق';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nاستلم هذا العنصر قبل اللصق. يمكنك أيضًا استلامه من السجل.';
  }

  @override
  String get notifyReceivingTitle => 'جارٍ الاستلام…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nتابع التقدم في السجل.';
  }

  @override
  String get notifyReadyTitle => 'جاهز للصق';

  @override
  String notifyReadyBody(String name) {
    return '$name\nتم استلامه ووضعه في الحافظة.';
  }

  @override
  String get notifyReceivedTitle => 'تم الاستلام';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nلم تتغير حافظتك. استخدم «نسخ إلى الحافظة» عندما تكون جاهزًا؛ هذا متاح أيضًا في السجل.';
  }

  @override
  String get notifyFailedTitle => 'تعذر الاستلام';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nأعد المحاولة من هذا الإشعار أو من السجل.';
  }

  @override
  String get notifyClipboardFailedTitle => 'تم الاستلام؛ لم يتم تحديث الحافظة';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nاستخدم «نسخ إلى الحافظة» لإعادة المحاولة، هنا أو في السجل.';
  }

  @override
  String get reconnect => 'إعادة الاتصال';

  @override
  String get reconnecting => 'جارٍ الاتصال…';

  @override
  String get reconnectDirect => 'تم الاتصال مباشرة';

  @override
  String get reconnectRelay =>
      'تعذر الاتصال المباشر، ولا يزال الترحيل مستخدمًا';

  @override
  String reconnectOffline(String name) {
    return '«$name» غير متصل. تأكد من أن PasteFerry مفتوح عليه.';
  }

  @override
  String get reconnectPending => 'لا يزال الاتصال جاريًا، تحقق بعد قليل';

  @override
  String get renameAction => 'إعادة تسمية';

  @override
  String get renameFavoriteTitle => 'إعادة تسمية العنصر المفضل';

  @override
  String get renameFavoriteHint =>
      'يظهر في المفضلة واللصق السريع، ويمكنك البحث عنه. اتركه فارغًا لعرض المحتوى مجددًا.';

  @override
  String get renamedToast => 'تمت إعادة التسمية';

  @override
  String get aliasClearedToast => 'يتم عرض المحتوى مجددًا';

  @override
  String get navSend => 'إرسال الملفات';

  @override
  String get sendSubtitle => 'اسحب الملفات إلى جهاز لإرسالها إليه مباشرة';

  @override
  String get sendNoDevicesTitle => 'لا توجد أجهزة مقترنة بعد';

  @override
  String get sendNoDevicesBody =>
      'اقرن كمبيوترًا آخر أولًا، ثم أرسل إليه الملفات من هنا.';

  @override
  String get sendDropHint => 'أفلت على جهاز للإرسال';

  @override
  String sendReleaseTo(String name) {
    return 'أفلت للإرسال إلى $name';
  }

  @override
  String get sendLan => 'الشبكة المحلية';

  @override
  String sendRelayLeft(String left) {
    return 'ترحيل · المتبقي اليوم $left';
  }

  @override
  String get sendNeedsUpdate => 'يحتاج إلى تحديث';

  @override
  String sendNeedsUpdateTip(String name) {
    return 'يمكن لـ $name استلام الملفات بعد التحديث إلى PasteFerry 2.5 أو أحدث.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'جارٍ الاتصال بـ $name. يمكنك الإرسال بعد الاتصال.';
  }

  @override
  String get sendNotReceiving => 'لا يستلم الملفات';

  @override
  String get sendDelivered => 'تم التسليم';

  @override
  String sendToTitle(String name) {
    return 'إرسال إلى $name';
  }

  @override
  String get sendDropHere => 'اسحب الملفات أو المجلدات إلى هنا';

  @override
  String get sendDropStarts => 'يبدأ الإرسال بمجرد إفلاتها';

  @override
  String get sendChooseFiles => 'اختيار ملفات…';

  @override
  String get sendChooseFolder => 'اختيار مجلد…';

  @override
  String get sendDropMore => 'أفلت المزيد من الملفات لإرسالها بعد ذلك';

  @override
  String sendSavedWhere(String name) {
    return 'تُحفظ الملفات في الموقع الذي يختاره $name، وهو مجلد التنزيلات افتراضيًا.';
  }

  @override
  String get sendCloseKeeps => 'إغلاق هذه النافذة لا يوقف الإرسال';

  @override
  String get sendRemoveQueued => 'إزالة';

  @override
  String get sendCannotDrop =>
      'لا يمكن إرسال هذا العنصر بالسحب. احفظه كملف أولًا، أو استخدم «اختيار ملفات…».';

  @override
  String sendErrOffline(String name) {
    return '$name غير متصل.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name لا يستلم الملفات.';
  }

  @override
  String get sendErrMissing => 'بعض هذه الملفات لم يعد موجودًا.';

  @override
  String get relayConfirmTitle => 'هل تريد الإرسال عبر ترحيل الخدمة؟';

  @override
  String relayConfirmBody(String name, String left) {
    return 'لا يوجد اتصال مباشر بين $name وهذا الكمبيوتر الآن، لذا ستمر الملفات عبر ترحيل الخدمة بسرعة تقارب 0.25 ميغابايت/ث. المتبقي من حصة الترحيل اليوم: $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'هذه الملفات ($size) أكبر من الحصة المتبقية. يتوقف الإرسال مؤقتًا عند نفادها، ويستمر عندما يتصل الكمبيوتران مباشرة أو عند إعادة تعيين الحصة غدًا.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'سيستهلك هذا نحو $size من حصة اليوم.';
  }

  @override
  String get relayExhausted =>
      'نفدت حصة الترحيل اليوم. تتم إعادة تعيينها عند منتصف الليل بتوقيت بكين. لا يوجد حد للكمبيوترات المتصلة مباشرة.';

  @override
  String get relayDontAskToday => 'عدم السؤال مجددًا اليوم لهذا الجهاز';

  @override
  String get relaySendAnyway => 'إرسال على أي حال';

  @override
  String get relayOwnServer => 'عبر الترحيل — تعتمد السرعة على خادمك';

  @override
  String get transfersReceived => 'المستلمة';

  @override
  String get transfersSent => 'المرسلة';

  @override
  String get transfersClearAll => 'مسح الكل';

  @override
  String get transfersClearTitle => 'هل تريد مسح هذه القائمة؟';

  @override
  String get transfersClearBody =>
      'يتم مسح القائمة فقط. تبقى الملفات في مكانها.';

  @override
  String get transfersEmptyReceived =>
      'تظهر هنا الملفات التي ترسلها إليك الأجهزة الأخرى';

  @override
  String get transfersEmptySent => 'تظهر هنا الملفات التي ترسلها';

  @override
  String transferFrom(String name) {
    return 'من $name';
  }

  @override
  String transferTo(String name) {
    return 'إلى $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others عنصر آخر',
      many: '$others عنصرًا آخر',
      few: '$others عناصر أخرى',
      two: 'عنصران آخران',
      one: 'عنصر آخر',
      zero: 'لا شيء آخر',
    );
    return '$name و$_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملف',
      many: '$count ملفًا',
      few: '$count ملفات',
      two: 'ملفان',
      one: 'ملف واحد',
      zero: 'لا ملفات',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'في قائمة الانتظار';

  @override
  String transferScanning(String count) {
    return 'جارٍ العد… عدد الملفات حتى الآن: $count';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'في انتظار $name…';
  }

  @override
  String get transferSending => 'جارٍ الإرسال';

  @override
  String get transferReceiving => 'جارٍ الاستلام';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'الآن: $file ($index من $total)';
  }

  @override
  String transferLeft(String time) {
    return 'المتبقي $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ثانية',
      many: '$n ثانية',
      few: '$n ثوانٍ',
      two: 'ثانيتان',
      one: 'ثانية واحدة',
      zero: 'أقل من ثانية',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n دقيقة',
      many: '$n دقيقة',
      few: '$n دقائق',
      two: 'دقيقتان',
      one: 'دقيقة واحدة',
      zero: 'أقل من دقيقة',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h س $m د';
  }

  @override
  String get transferPaused => 'متوقف مؤقتًا: نفدت حصة الترحيل اليوم';

  @override
  String get transferInterrupted => 'انقطع — يستمر عند إعادة الاتصال';

  @override
  String transferInterruptedIncoming(String name) {
    return 'انقطع — في انتظار $name للمتابعة';
  }

  @override
  String get transferCancelled => 'تم الإلغاء';

  @override
  String transferPeerCancelled(String name) {
    return 'ألغاه $name';
  }

  @override
  String get transferExpired => 'منتهي الصلاحية';

  @override
  String get transferMissing => 'تم نقله أو حذفه';

  @override
  String transferNotSent(String reason) {
    return 'لم يتم الإرسال: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'لم يتم الاستلام: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return 'لا توجد مساحة كافية على قرص $name (ينقص $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'لا توجد مساحة كافية على القرص (ينقص $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'موقع الحفظ لدى $name غير متاح';
  }

  @override
  String get reasonDestUnavailable =>
      'موقع الحفظ غير متاح — تحقق منه في الإعدادات';

  @override
  String get reasonFileTooLarge =>
      'موقع الحفظ على قرص FAT32، وهو لا يستوعب ملفات أكبر من 4 غيغابايت';

  @override
  String reasonDisabledPeer(String name) {
    return '$name لا يستلم الملفات';
  }

  @override
  String get reasonSourceChanged => 'تغيّر أحد الملفات أثناء إرساله';

  @override
  String get reasonSourceMissing => 'أحد الملفات لم يعد موجودًا';

  @override
  String get reasonReadError => 'تعذرت قراءة أحد الملفات';

  @override
  String get reasonWriteFailed => 'تعذرت كتابة الملفات';

  @override
  String get reasonHashMismatch => 'تلف أحد الملفات أثناء النقل';

  @override
  String reasonUnsupported(String name) {
    return 'يجب تحديث $name لاستلام الملفات';
  }

  @override
  String get reasonOther => 'حدث خطأ ما';

  @override
  String get revealInFinder => 'إظهار في Finder';

  @override
  String get revealInFolder => 'إظهار في المجلد';

  @override
  String get revealOpenFolder => 'فتح المجلد';

  @override
  String get transferResend => 'إرسال مجددًا';

  @override
  String get transferRemove => 'إزالة من القائمة';

  @override
  String get transferCopyPath => 'نسخ المسار';

  @override
  String get transferPathCopied => 'تم نسخ المسار';

  @override
  String sendingTo(String name, String percent) {
    return 'جارٍ الإرسال إلى $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'جارٍ الاستلام من $name · $percent';
  }

  @override
  String get receiveFiles => 'استلام الملفات من الأجهزة الأخرى';

  @override
  String get saveTo => 'الحفظ في';

  @override
  String get saveToChange => 'تغيير…';

  @override
  String get saveToDefault => 'التنزيلات (افتراضي)';

  @override
  String get saveToUseDefault => 'استخدام التنزيلات';

  @override
  String get receiveNotify => 'الإشعار عند وصول الملفات';

  @override
  String receiveFootnote(String device) {
    return 'يمكن للأجهزة المقترنة فقط إرسال الملفات إلى $device. أثناء نقل الملفات، لن يدخل $device في وضع السكون تلقائيًا.';
  }

  @override
  String get saveDirNotFound => 'هذا المجلد غير موجود.';

  @override
  String get saveDirNotWritable =>
      'لا يمكن لـ PasteFerry حفظ الملفات في هذا المجلد.';

  @override
  String get saveDirPermission =>
      'لا يُسمح لـ PasteFerry باستخدام هذا المجلد. اسمح بذلك في «إعدادات النظام ← الخصوصية والأمن ← الملفات والمجلدات».';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'احتوت أسماء $count ملف على أحرف لا يسمح بها Windows، فاستُبدلت بأحرف كاملة العرض مشابهة',
      many:
          'احتوت أسماء $count ملفًا على أحرف لا يسمح بها Windows، فاستُبدلت بأحرف كاملة العرض مشابهة',
      few:
          'احتوت أسماء $count ملفات على أحرف لا يسمح بها Windows، فاستُبدلت بأحرف كاملة العرض مشابهة',
      two:
          'احتوى اسما ملفين على أحرف لا يسمح بها Windows، فاستُبدلت بأحرف كاملة العرض مشابهة',
      one:
          'احتوى اسم ملف واحد على أحرف لا يسمح بها Windows، فاستُبدلت بأحرف كاملة العرض مشابهة',
      zero: 'لا توجد أسماء ملفات تحتوي على أحرف لا يسمح بها Windows',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'الشبكة نفسها';

  @override
  String get sendRingOther => 'شبكات أخرى';

  @override
  String sendOfflineList(String names) {
    return 'غير متصل: $names';
  }

  @override
  String get listSeparator => '، ';

  @override
  String get sendLayout => 'قائمة النقل';

  @override
  String get sendLayoutSide => 'بجانب الرادار';

  @override
  String get sendLayoutBelow => 'أسفل الرادار';

  @override
  String get general => 'عام';

  @override
  String get launchAtLogin => 'التشغيل عند تسجيل الدخول';

  @override
  String get launchAtLoginDesc =>
      'يبدأ في الخلفية عند تسجيل الدخول. تغيير هذا الإعداد لا يوقف الجلسة الحالية.';

  @override
  String get realtimeSync => 'مزامنة الحافظة لحظيًا';

  @override
  String get realtimeSyncDesc =>
      'مشاركة ما تنسخه تلقائيًا مع الأجهزة المقترنة. عند الإيقاف، يبقى السجل المحلي و«إرسال الملفات» متاحين.';

  @override
  String get syncBacklog => 'استدراك ما فات بعد إعادة الاتصال';

  @override
  String get syncBacklogDesc =>
      'متوقف افتراضيًا: يتم تخطي ما نُسخ أثناء الانقطاع. عند التفعيل، تدخل حتى 20 نسخة من آخر 24 ساعة إلى السجل دون استبدال الحافظة.';

  @override
  String get peerRealtimeSync => 'المزامنة مع هذا الكمبيوتر';

  @override
  String get syncPaused => 'مزامنة الحافظة متوقفة مؤقتًا';

  @override
  String get quitApp => 'إنهاء PasteFerry';

  @override
  String get quitAppDesc =>
      'إيقاف جميع عمليات PasteFerry. يتم الاحتفاظ بإعداد التشغيل عند تسجيل الدخول.';

  @override
  String get quitTransfersWarning =>
      'لا يزال نقل الملفات جاريًا. هل تريد الإنهاء ومقاطعة عمليات النقل هذه؟';

  @override
  String get backgroundRunningTitle => 'سيستمر PasteFerry في العمل';

  @override
  String get backgroundRunningBody =>
      'إغلاق النافذة يُبقي المزامنة واللصق السريع قيد التشغيل. لإيقاف كل شيء، اختر «إنهاء PasteFerry» من الإعدادات أو من قائمة التطبيق.';

  @override
  String get displayAs => 'يظهر باسم';

  @override
  String get editName => 'تغيير الاسم';

  @override
  String get nameHint => 'الاسم الذي تراه جهات اتصالك';

  @override
  String get nameDefaultHint => 'اتركه فارغًا لاستخدام اسم حسابك.';

  @override
  String get avatarTitle => 'صورة الملف الشخصي';

  @override
  String get avatarChoose => 'اختيار صورة…';

  @override
  String get avatarPaste => 'لصق صورة';

  @override
  String get avatarReset => 'استخدام الصورة الافتراضية';

  @override
  String get avatarZoom => 'تكبير';

  @override
  String get avatarDragHint => 'اسحب لتحريك الصورة.';

  @override
  String get avatarNoImage => 'لا توجد صورة في الحافظة.';

  @override
  String get avatarBad =>
      'لا يمكن استخدام هذه الصورة. اختر صورة PNG أو JPEG أو GIF.';

  @override
  String get done => 'تم';

  @override
  String get friendsTitle => 'جهات الاتصال';

  @override
  String get addFriend => 'إضافة جهة اتصال';

  @override
  String get friendsEmpty => 'لا توجد جهات اتصال بعد';

  @override
  String get friendsEmptyBody =>
      'أضف شخصًا يستخدم PasteFerry أيضًا لتتبادلا الملفات دون إقران. يمكن لجهات الاتصال إرسال الملفات فقط، ولا ترى حافظتك أبدًا.';

  @override
  String get friendSendAction => 'إرسال…';

  @override
  String get friendHistory => 'عمليات النقل';

  @override
  String friendHistoryTitle(String name) {
    return 'عمليات النقل مع $name';
  }

  @override
  String get friendHistoryEmpty => 'لا توجد عمليات نقل بعد.';

  @override
  String get friendAutoAccept => 'قبول الملفات تلقائيًا';

  @override
  String get friendRemove => 'إزالة جهة الاتصال';

  @override
  String friendRemoveTitle(String name) {
    return 'هل تريد إزالة $name؟';
  }

  @override
  String get friendRemoveBody =>
      'ستتم إزالة كل منكما من جهات اتصال الآخر، ولن تتمكنا من تبادل الملفات بعد ذلك. تبقى عمليات النقل السابقة على هذا الكمبيوتر.';

  @override
  String friendLastActivity(String time) {
    return 'آخر نقل $time';
  }

  @override
  String get friendNoActivity => 'لا توجد عمليات نقل بعد';

  @override
  String get friendCodeShare =>
      'أرسل هذا الرمز إلى جهة اتصالك. عندما يدخله في PasteFerry، ستُضافان إلى جهات اتصال بعضكما.';

  @override
  String friendCodeExpires(String time) {
    return 'تنتهي صلاحيته خلال $time';
  }

  @override
  String get friendCodeOr => 'أو';

  @override
  String get friendCodeEnter => 'أدخل رمز جهة الاتصال الخاص به';

  @override
  String get friendCodeAdd => 'إضافة';

  @override
  String get friendCodeWaiting => 'في انتظار إدخاله للرمز…';

  @override
  String friendConfirmBody(String name) {
    return 'هل تريد إضافة $name إلى جهات اتصالك؟';
  }

  @override
  String get friendSafetyCode => 'التحقق من رمز الأمان (اختياري)';

  @override
  String get friendSafetyHint =>
      'عندما تكونان معًا، قارنا هذين السطرين. إذا تطابقا على الكمبيوترين، فلم يتدخل أحد.';

  @override
  String get friendWaitingPeer => 'في انتظار أن يضيفك…';

  @override
  String friendAdded(String name) {
    return 'تمت إضافة $name إلى جهات اتصالك';
  }

  @override
  String friendPeerCancelled(String name) {
    return 'ألغى $name';
  }

  @override
  String get friendErrFriendCode =>
      'هذا رمز جهة اتصال. أدخله في «إضافة جهة اتصال» بصفحة «إرسال الملفات».';

  @override
  String get friendErrDeviceCode =>
      'هذا رمز إقران. أدخله في «الأجهزة ← إضافة جهاز».';

  @override
  String get friendErrOutdated => 'يحتاج إلى PasteFerry 2.6.0 أو أحدث.';

  @override
  String get friendErrAlreadyPaired => 'هذا الكمبيوتر من أجهزتك بالفعل.';

  @override
  String get friendErrNoChannel =>
      'لستما على الشبكة نفسها. فعّلا «الخدمة» على الكمبيوترين لإضافة بعضكما.';

  @override
  String get openService => 'تفعيل الخدمة…';

  @override
  String get noteLabel => 'ملاحظة (اختياري)';

  @override
  String get noteHintEmpty => 'اختر الملفات أولًا';

  @override
  String get noteHint => 'مثال: يرجى توقيع الصفحة 3';

  @override
  String noteLine(String note) {
    return 'ملاحظة: $note';
  }

  @override
  String get sendAction => 'إرسال';

  @override
  String sendItemsSummary(String count, String size) {
    return 'العناصر: $count · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'أفلت الملفات أو الصور هنا، أو الصقها ($key)';
  }

  @override
  String get sendDropMorePaste => 'أفلت أو الصق المزيد';

  @override
  String get sendPasteNothing =>
      'لا يوجد ما يمكن لصقه. انسخ ملفات أو صورة أولًا.';

  @override
  String get sendRemoveItem => 'إزالة';

  @override
  String sendFriendSaved(String name) {
    return 'يقبل $name كل دفعة قبل إرسالها.';
  }

  @override
  String transferAskingOut(String name) {
    return 'في انتظار قبول $name…';
  }

  @override
  String get transferAskingIn => 'في انتظار قبولك';

  @override
  String reasonDeclined(String name) {
    return 'رفض $name';
  }

  @override
  String reasonTimeout(String name) {
    return 'لم يستجب $name';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name لا يقبل الملفات';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name لا يقبل ملفاتك حاليًا';
  }

  @override
  String get reasonYouDeclined => 'تم الرفض';

  @override
  String get reasonYouIgnored => 'تم التجاهل';

  @override
  String get sendAgain => 'إرسال مجددًا';

  @override
  String incomingTitle(String name) {
    return 'يريد $name إرسال ملفات إليك';
  }

  @override
  String get incomingAlways => 'قبول الملفات من جهة الاتصال هذه دائمًا';

  @override
  String get incomingDecline => 'رفض';

  @override
  String get incomingAccept => 'قبول';

  @override
  String incomingCountdown(String seconds) {
    return 'يُرفض تلقائيًا خلال $seconds ث';
  }

  @override
  String get incomingStranger => 'قريب';

  @override
  String get friendsStrip => 'جهات الاتصال';

  @override
  String get strangersStrip => 'أجهزة قريبة فعّلت «الجميع»';

  @override
  String get strangerNearby => 'قريب';

  @override
  String get friendNeedService => 'فعّل الخدمة';

  @override
  String get friendCantReach => 'يتعذر الاتصال';

  @override
  String reachSelfNoService(String name) {
    return 'لست على الشبكة نفسها مع $name. فعّل الخدمة لإرسال الملفات؛ وإذا تعذر الاتصال المباشر، فستمر عبر ترحيل الخدمة.';
  }

  @override
  String reachPeerNoService(String name) {
    return 'لم يفعّل $name الخدمة، لذا يمكنك إرسال الملفات على الشبكة نفسها فقط. اطلب منه تفعيل الخدمة في PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'لا تستخدمان الخادم نفسه. فعّلا الخدمة على الكمبيوترين، أو استخدما الخادم نفسه، لإرسال الملفات.';

  @override
  String get receiveFromLabel => 'السماح لهؤلاء بإرسال الملفات إليّ:';

  @override
  String get receiveFromOff => 'لا أحد';

  @override
  String get receiveFromFriends => 'جهات الاتصال فقط';

  @override
  String get receiveFromEveryone => 'الجميع';

  @override
  String everyoneLeft(String minutes) {
    return 'الجميع · متبقٍ $minutes د';
  }

  @override
  String get receiveFromOffDesc =>
      'يمكن لأجهزة الكمبيوتر المقترنة بك فقط إرسال الملفات إليك.';

  @override
  String get receiveFromFriendsDesc =>
      'يمكن لجهات اتصالك إرسال الملفات إليك. وأنت تقبل كل دفعة.';

  @override
  String get receiveFromEveryoneDesc =>
      'يمكن لأي شخص على الشبكة نفسها إرسال الملفات إليك لمدة 10 دقائق. وأنت تقبل كل دفعة.';

  @override
  String get everyoneEnded =>
      'انتهى «الجميع»؛ تمت العودة إلى «جهات الاتصال فقط».';

  @override
  String get friendsCountTooltip => 'جهات الاتصال';

  @override
  String get waitingAccept => 'في الانتظار…';

  @override
  String get settingsConnection => 'الاتصال';

  @override
  String get settingsGeneralSummary =>
      'التشغيل عند تسجيل الدخول، واسم الجهاز، واللغة';

  @override
  String get settingsConnectionSummary =>
      'الخدمة، وخادمك الخاص، والشبكة المحلية';

  @override
  String get settingsSyncSummary =>
      'المزامنة اللحظية، وحد الحجم، والمحتوى المراد مزامنته';

  @override
  String get settingsQuickPasteSummary => 'الاختصار وما يحدث بعد الاختيار';

  @override
  String get settingsSendSummary => 'استلام الملفات، وموقع الحفظ';

  @override
  String get settingsStorageSummary =>
      'مدة الاحتفاظ بالسجل، والمساحة المستخدمة';

  @override
  String get settingsAboutSummary => 'الإصدار، والتحديثات، والملاحظات';

  @override
  String get friendsSubtitle =>
      'أرسل الملفات إلى أجهزة كمبيوتر الآخرين دون إقران';

  @override
  String get friendsSearch => 'البحث في جهات الاتصال';

  @override
  String get friendsNoMatch => 'لا توجد جهات اتصال مطابقة';

  @override
  String get friendsPick => 'اختر جهة اتصال لعرض عمليات النقل أو إرسال الملفات';

  @override
  String friendDropHint(String name) {
    return 'أفلت الملفات هنا لإرسالها إلى $name';
  }

  @override
  String get webShareTitle => 'النقل عبر متصفح الهاتف';

  @override
  String get webShareFootnote =>
      'امسح رمز QR بهاتف لتبادل النصوص والصور والملفات مع هذا الكمبيوتر عبر المتصفح، دون الحاجة إلى تطبيق. يجب أن يكون الهاتف والكمبيوتر على الشبكة نفسها.';

  @override
  String get webShareSwitch => 'السماح للهواتف بالاتصال عبر المتصفح';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مفعّل، $count هاتف',
      many: 'مفعّل، $count هاتفًا',
      few: 'مفعّل، $count هواتف',
      two: 'مفعّل، هاتفان',
      one: 'مفعّل، هاتف واحد',
      zero: 'مفعّل، لا هواتف',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'متوقف';

  @override
  String get webShareShowQr => 'عرض رمز QR';

  @override
  String get webShareDialogTitle => 'امسح باستخدام هاتفك';

  @override
  String get webShareDialogBody =>
      'امسح الرمز بكاميرا الهاتف أو بمتصفحه وافتحه في المتصفح. يسجّل كل رمز QR هاتفًا واحدًا، ويُستبدل بعد استخدامه.';

  @override
  String get webShareAddress => 'العنوان';

  @override
  String get webShareSecurity =>
      'المحتوى مشفر داخل الصفحة، لذا لا يستطيع الآخرون على الشبكة قراءته. لكن الصفحة نفسها تعمل عبر http ولا يمكنها منع من يتعمد التلاعب بها. استخدمها في المنزل أو على شبكة عمل موثوقة، وليس على شبكة Wi-Fi عامة.';

  @override
  String get webSharePhones => 'الهواتف المسجلة';

  @override
  String get webShareNoPhones => 'لا توجد هواتف بعد';

  @override
  String webShareLastUsed(String time) {
    return 'آخر استخدام $time';
  }

  @override
  String get webShareRemove => 'إزالة';

  @override
  String webShareRemoved(String name) {
    return 'تمت إزالة «$name»';
  }

  @override
  String webShareNewPhone(String name) {
    return 'تم تسجيل «$name»';
  }

  @override
  String webShareNotListening(String error) {
    return 'تعذر بدء الاستماع: $error';
  }

  @override
  String get webSharePortFallback =>
      'المنفذ المعتاد مستخدم، لذا يُستخدم منفذ مؤقت. لن تفتح العناوين المحفوظة حتى تمسح الهواتف الرمز مجددًا.';

  @override
  String get webShareNoAddress =>
      'لا يوجد عنوان على الشبكة المحلية. اتصل بشبكة Wi-Fi أو بشبكة سلكية أولًا.';

  @override
  String get webShareCantOpen =>
      'إذا لم تفتح الصفحة على الهاتف، فتأكد من أن الجهازين على الشبكة نفسها (شبكات الضيوف لا تعمل عادةً). على Windows، يجب أيضًا السماح لـ PasteFerry عبر جدار الحماية.';

  @override
  String get mTabRecords => 'السجل';

  @override
  String get mTabSend => 'إرسال';

  @override
  String get mThisPhone => 'هذا الهاتف';

  @override
  String get mThisPhoneInText => 'هذا الهاتف';

  @override
  String mThisPhoneName(String name) {
    return 'هذا الهاتف: $name';
  }

  @override
  String get mSendTitle => 'إرسال إلى الكمبيوتر';

  @override
  String get mSendHint => 'اكتب نصًا أو الصقه';

  @override
  String get mPaste => 'لصق';

  @override
  String get mPhotosFiles => 'صور أو ملفات';

  @override
  String mSendConfirmTitle(Object n) {
    return 'هل تريد إرسال الملفات ($n)؟';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'تم إرسال $n ملف إلى الكمبيوتر',
      many: 'تم إرسال $n ملفًا إلى الكمبيوتر',
      few: 'تم إرسال $n ملفات إلى الكمبيوتر',
      two: 'تم إرسال ملفين إلى الكمبيوتر',
      one: 'تم إرسال ملف واحد إلى الكمبيوتر',
      zero: 'لم يتم إرسال أي ملف إلى الكمبيوتر',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'لا يوجد نص في الحافظة';

  @override
  String get mSendAction => 'إرسال';

  @override
  String mSendTo(String names) {
    return 'يُرسل إلى $names';
  }

  @override
  String get mNoOnlineDevices => 'لا توجد أجهزة متصلة قريبة';

  @override
  String get mNoPairedDevices => 'اقرن هذا الهاتف بكمبيوتر أولًا';

  @override
  String get mSent => 'تم الإرسال';

  @override
  String get mSendFootnote =>
      'تدخل النصوص والملفات إلى سجل الكمبيوتر، وإلى حافظته حسب إعداده. ما تنسخه على الهاتف لا يُرسل تلقائيًا.';

  @override
  String get mSentRecords => 'المرسلة';

  @override
  String get mSentRetention => 'الاحتفاظ بالعناصر المرسلة';

  @override
  String mSentRetentionDesc(Object d) {
    return 'تعرض «المرسلة» ما أرسله هذا الهاتف مؤخرًا (عدد الأيام: $d)';
  }

  @override
  String mSentRetentionDays(Object d) {
    return 'عدد الأيام: $d';
  }

  @override
  String get mViewAll => 'عرض الكل';

  @override
  String get mClearCache => 'مسح';

  @override
  String get mCheckUpdate => 'البحث عن تحديثات';

  @override
  String get mUpdateFailed => 'تعذر البحث عن تحديثات';

  @override
  String get mUpToDate => 'لديك أحدث إصدار';

  @override
  String mNewVersion(Object v) {
    return 'يتوفر الإصدار $v';
  }

  @override
  String get mDownloadInstall => 'تنزيل الإصدار الجديد';

  @override
  String mSendFailed(String detail) {
    return 'تعذر الإرسال: $detail';
  }

  @override
  String get mCopy => 'نسخ';

  @override
  String get mCopied => 'تم النسخ إلى حافظة هذا الهاتف';

  @override
  String get mShare => 'مشاركة';

  @override
  String get mSaved => 'تم الحفظ في الصور أو Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'لم تنجح العملية: $detail';
  }

  @override
  String get mDownloading => 'جارٍ التنزيل…';

  @override
  String get mNotDownloaded => 'لم يتم تنزيله بعد';

  @override
  String get mDownloadHint =>
      'يتم تنزيله أولًا عند النقر على «نسخ» أو «حفظ» أو «مشاركة».';

  @override
  String get mFullTextLoading => 'جارٍ التحميل…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'عدد الأحرف المعروضة: $shown من $total. يتم نسخ النص كاملًا.';
  }

  @override
  String get mNotOnLanTitle => 'غير متصل بشبكة Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'حاليًا لا يزامن PasteFerry إلا على الشبكة المحلية. اتصل بشبكة Wi-Fi نفسها التي يتصل بها الكمبيوتر.';

  @override
  String mStartFailed(String detail) {
    return 'تعذر تشغيل PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'على الكمبيوتر، افتح PasteFerry ← الأجهزة ← إضافة جهاز، ثم أدخل هنا الرمز الذي يظهر. على شبكة Wi-Fi نفسها، يمكنك أيضًا فتح «البحث عن أجهزة قريبة» على كليهما.';

  @override
  String get mSectionSync => 'المزامنة';

  @override
  String get mSectionBackground => 'الخلفية';

  @override
  String get mAutoApplyDesc =>
      'يُوضع النص المنسوخ على الكمبيوتر مباشرة في حافظة هذا الهاتف. تنتظر الصور والملفات حتى تنقر على «نسخ».';

  @override
  String get mKeepAlive => 'البقاء متصلًا في الخلفية';

  @override
  String get mKeepAliveDesc =>
      'استلام النصوص حتى عندما يكون PasteFerry مغلقًا. يظهر إشعار دائم.';

  @override
  String get mNotifications => 'الإشعارات';

  @override
  String get mNotificationsDesc =>
      'مطلوبة للإشعار الدائم. يعمل PasteFerry بدونها.';

  @override
  String get mBattery => 'التشغيل في الخلفية';

  @override
  String get mBatteryDesc =>
      'أوقف تحسين البطارية حتى لا يوقف النظام PasteFerry عند قفل الشاشة. تحتاج بعض الهواتف أيضًا إلى إضافة PasteFerry إلى قائمة التشغيل التلقائي أو العمل في الخلفية في الإعدادات.';

  @override
  String get mAllowed => 'مسموح';

  @override
  String get mAllow => 'سماح';

  @override
  String mVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get mDeleteConfirm => 'هل تريد حذف هذا العنصر؟';

  @override
  String get mDelete => 'حذف';

  @override
  String get webShareFirewallPreparing =>
      'جارٍ التحقق من جدار حماية Windows. إذا طلب Windows موافقة المسؤول، فاختر «نعم» ليتمكن هاتفك من الاتصال.';

  @override
  String get webShareFirewallReady =>
      'قواعد جدار حماية Windows جاهزة. قم بتوصيل هاتفك بالشبكة نفسها وامسح رمز QR. إذا تعذر الاتصال، فتحقق من جدار الحماية مرة أخرى أدناه.';

  @override
  String get webShareFirewallFailed =>
      'لم يكتمل إعداد جدار الحماية. قد لا يتمكن هاتفك من فتح الصفحة. حاول مرة أخرى ووافق على طلب المسؤول في Windows.';

  @override
  String get webShareFirewallAllow => 'التحقق والسماح باتصالات الهاتف';

  @override
  String get mCopyMediaFailed =>
      'تعذر نسخ هذه الصورة أو الملف. حاول حفظه أولًا.';

  @override
  String get mShareMediaFailed =>
      'تعذر فتح المشاركة لهذه الصورة أو الملف. حاول حفظه أولًا.';

  @override
  String get mSaveMediaFailed =>
      'تعذر حفظ هذه الصورة أو الملف. تحقق من إذن الوصول إلى التخزين والمساحة المتاحة، ثم حاول مرة أخرى.';

  @override
  String get noticeFilesUnreadable =>
      'تعذرت قراءة الملفات التي نسختها للتو، لذا لم تتم مزامنة أي شيء';

  @override
  String get mAddMore => 'إضافة المزيد';

  @override
  String get mChoosePhotos => 'اختيار صور…';

  @override
  String get mMultiSelectHint =>
      'اختر عدة صور دفعة واحدة. في الملفات، المس عنصرًا مع الاستمرار لتحديد المزيد.';

  @override
  String get webSendFiles => 'إرسال الملفات';

  @override
  String get webFilesQueued =>
      'تمت الإضافة إلى النقل عبر المتصفح. افتح «إرسال الملفات» على هاتفك للتنزيل.';

  @override
  String get webFilesLimit =>
      'تدعم التنزيلات عبر المتصفح حتى 200 ميغابايت لكل ملف و64 ملفًا لكل دفعة.';

  @override
  String get appearance => 'المظهر';

  @override
  String get settingsAppearanceSummary => 'السمة، والوضع الفاتح والداكن';

  @override
  String get themeTitle => 'السمة';

  @override
  String get themeDefault => 'الافتراضية';

  @override
  String get themePixel => 'بكسل';

  @override
  String get themeMode => 'الفاتح والداكن';

  @override
  String get themeModeSystem => 'مطابقة النظام';

  @override
  String get themeModeLight => 'فاتح';

  @override
  String get themeModeDark => 'داكن';

  @override
  String get themeCustom => 'مخصصة';

  @override
  String get themeDelete => 'حذف السمة';

  @override
  String themeDeleteConfirm(String name) {
    return 'هل تريد حذف السمة «$name»؟';
  }

  @override
  String get themeLowContrast => 'قد تصعب قراءة بعض النصوص في هذه السمة';

  @override
  String get themeFootnote =>
      'تنطبق السمات على هذا الجهاز فقط، بما في ذلك اللصق السريع. ولا تتم مزامنتها مع الأجهزة الأخرى.';

  @override
  String get themeBuiltinGroup => 'مدمجة';

  @override
  String get themeCustomGroup => 'مخصصة';

  @override
  String get themeUse => 'استخدام';

  @override
  String get themeDuplicate => 'نسخ مكرر';

  @override
  String themeCopyName(String name) {
    return 'نسخة من $name';
  }

  @override
  String get themeExport => 'تصدير…';

  @override
  String get themeImport => 'استيراد سمة…';

  @override
  String themeImported(String name) {
    return 'تم استيراد «$name»';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم استيراد «$name». قد تصعب قراءة $count لون للنصوص.',
      many: 'تم استيراد «$name». قد تصعب قراءة $count لونًا للنصوص.',
      few: 'تم استيراد «$name». قد تصعب قراءة $count ألوان نصوص.',
      two: 'تم استيراد «$name». قد تصعب قراءة لوني نص.',
      one: 'تم استيراد «$name». قد تصعب قراءة لون نص واحد.',
      zero: 'تم استيراد «$name».',
    );
    return '$_temp0';
  }

  @override
  String get themeExported => 'تم تصدير السمة';

  @override
  String get themeCustomEmpty =>
      'لا توجد سمات مخصصة بعد. انسخ سمة مدمجة، أو استورد سمة، أو اطلب من الذكاء الاصطناعي إنشاء واحدة.';

  @override
  String get themeAskAi => 'اطلب من الذكاء الاصطناعي إنشاء سمة';

  @override
  String get themeAskAiBody =>
      'أضف خادم MCP هذا إلى تطبيق ذكاء اصطناعي مثل Claude أو Cursor، ثم اطلب سمة، مثل «أنشئ لي سمة سايبربانك». يقرأ الذكاء الاصطناعي تنسيق السمة، ويختار الألوان، ويتحقق من التباين، ثم يطبّق السمة.';

  @override
  String get themeAskAiCopy => 'نسخ الإعدادات';

  @override
  String get themeAskAiCopied => 'تم نسخ الإعدادات';

  @override
  String get themeScanlines => 'خطوط المسح';

  @override
  String get themeScanlinesDesc =>
      'إضافة خطوط مسح CRT خافتة فوق النافذة. لسمات البكسل فقط.';

  @override
  String get themeBackground => 'صورة الخلفية';

  @override
  String get themeBackgroundDesc =>
      'تملأ النافذة خلف الشريط الجانبي والصفحات. وتحافظ طبقة تعتيم فوقها على وضوح النص.';

  @override
  String get themeBackgroundChoose => 'اختيار صورة…';

  @override
  String get themeBackgroundChange => 'تغيير…';

  @override
  String get themeBackgroundRemove => 'إزالة';

  @override
  String get themeBlur => 'التمويه';

  @override
  String get themeBlurNone => 'بلا';

  @override
  String get themeBlurLight => 'خفيف';

  @override
  String get themeBlurStrong => 'قوي';

  @override
  String get themeScrim => 'طبقة التعتيم';

  @override
  String get themeScrimDesc =>
      'لون يوضع فوق الصورة ليبقى النص واضحًا. ولا يكون أخف مما تحتاجه الصورة.';

  @override
  String get themeScrimAuto => 'تلقائي';

  @override
  String get themeScrimMore => 'أكثف';

  @override
  String get themeScrimMost => 'الأكثف';

  @override
  String get themePanels => 'اللوحات';

  @override
  String get themePanelsDesc =>
      'مقدار ما يظهر من الصورة عبر الشريط الجانبي والقوائم.';

  @override
  String get themePanelsClear => 'شفافة';

  @override
  String get themePanelsMedium => 'متوسطة';

  @override
  String get themePanelsSolid => 'معتمة';

  @override
  String get themeAccentFromImage => 'استخدام ألوان الصورة';

  @override
  String get themeAccentFromImageDesc => 'أخذ لون التمييز من الصورة.';

  @override
  String get themeBackgroundPicker => 'العرض في اللصق السريع أيضًا';

  @override
  String get themeScenery => 'عرض المناظر';

  @override
  String get themeSceneryDesc => 'الصور أعلى الصفحات وأسفل الشريط الجانبي.';

  @override
  String themeCopiedForEdit(String name) {
    return 'لا يمكن تغيير السمات المدمجة، لذا تم إنشاء نسخة باسم «$name» وتطبيقها';
  }

  @override
  String get themeBackgroundFootnote =>
      'الخلفية جزء من السمة الحالية. لا يمكن تغيير السمات المدمجة: أول تغيير يُنشئ نسخة. تبقى الصور على هذا الجهاز؛ والتنسيقات المدعومة هي JPEG وPNG وGIF.';

  @override
  String get themeSceneGroup => 'المناظر';

  @override
  String get themeSceneHeader => 'رأس الصفحة';

  @override
  String get themeSceneHeaderDesc =>
      'صورة عريضة خلف عناوين الصفحات، يتلاشى أسفلها في الصفحة. وترسم سمة البكسل هنا منظرًا طبيعيًا بالبكسل.';

  @override
  String get themeSceneSidebar => 'أسفل الشريط الجانبي';

  @override
  String get themeSceneSidebarDesc =>
      'صورة صغيرة أسفل الشريط الجانبي. وترسم سمة البكسل هنا مخيمًا صغيرًا.';

  @override
  String get themeSceneReset => 'إعادة التعيين';

  @override
  String get themeSceneFootnote =>
      'يمكن لأي سمة عرض صورك الخاصة هنا. وتحافظ طبقة تعتيم على وضوح عنوان الصفحة. تختفي المناظر عندما تملأ صورة خلفية النافذة.';

  @override
  String get starTitle => 'ما رأيك في PasteFerry؟';

  @override
  String get starBody =>
      'إذا أعجبك، فإن منحه نجمة على GitHub سيعني لنا الكثير.';

  @override
  String get starAction => 'منح نجمة على GitHub';

  @override
  String get starLater => 'لاحقًا';

  @override
  String get starDismiss => 'عدم الإظهار مجددًا';
}
