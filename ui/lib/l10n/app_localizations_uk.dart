// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Історія';

  @override
  String get navDevices => 'Пристрої';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get navFavorites => 'Вибране';

  @override
  String get linkConnecting => 'Підключення…';

  @override
  String get linkServiceNotRunning => 'Фонова служба не працює';

  @override
  String get linkLanMode => 'Пошук пристроїв у цій мережі';

  @override
  String get linkServerUnreachable =>
      'Сервер недоступний; синхронізація в цій мережі';

  @override
  String get linkNothingOn =>
      'Пошук у локальній мережі вимкнено, і сервер не вказано';

  @override
  String get linkLanBlocked => 'macOS блокує доступ до локальної мережі';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пристрою в мережі',
      many: '$count пристроїв у мережі',
      few: '$count пристрої в мережі',
      one: '$count пристрій у мережі',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Підключено до сервера';

  @override
  String linkConnectionLost(String detail) {
    return 'З’єднання втрачено: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Фонову службу від’єднано';

  @override
  String get linkServiceDisabled => 'Фонову синхронізацію вимкнено';

  @override
  String get errServiceNotConnected => 'Немає з’єднання з фоновою службою';

  @override
  String get errUnimplemented => 'Це поки що недоступно';

  @override
  String get errUnavailable => 'Не вдається зв’язатися з фоновою службою';

  @override
  String errServiceStart(String detail) {
    return 'Не вдалося запустити фонову службу: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Не вдалося перезапустити фонову службу: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Не вдалося налаштувати запуск PasteFerry під час входу: $detail';
  }

  @override
  String get thisMacTitle => 'Цей Mac';

  @override
  String get thisPcTitle => 'Цей комп’ютер';

  @override
  String get thisMacInText => 'цей Mac';

  @override
  String get thisPcInText => 'цей комп’ютер';

  @override
  String get bothMacs => 'обидва Mac';

  @override
  String get bothDevices => 'обидва пристрої';

  @override
  String get thisDeviceShort => 'Цей пристрій';

  @override
  String fromDevice(String name) {
    return 'Від $name';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get close => 'Закрити';

  @override
  String get save => 'Зберегти';

  @override
  String get retry => 'Повторити';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get justNow => 'Щойно';

  @override
  String secondsAgo(int n) {
    return '$n с тому';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n хвилини тому',
      many: '$n хвилин тому',
      few: '$n хвилини тому',
      one: '$n хвилину тому',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n години тому',
      many: '$n годин тому',
      few: '$n години тому',
      one: '$n годину тому',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дня тому',
      many: '$n днів тому',
      few: '$n дні тому',
      one: '$n день тому',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$day.$month';
  }

  @override
  String durationHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n години',
      many: '$n годин',
      few: '$n години',
      one: '$n година',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дня',
      many: '$n днів',
      few: '$n дні',
      one: '$n день',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Скопіюйте щось на будь-якому своєму пристрої, і воно з’явиться тут';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису',
      many: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису',
      many: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0, термін зберігання: $ttl';
  }

  @override
  String get filterAll => 'Усе';

  @override
  String get filterText => 'Текст';

  @override
  String get filterImage => 'Зображення';

  @override
  String get filterFile => 'Файли';

  @override
  String get filterLink => 'Посилання';

  @override
  String get historyClearTooltip => 'Очистити історію';

  @override
  String get historyEmptyTitle => 'Тут поки порожньо';

  @override
  String get historyEmptyFilteredTitle => 'Нічого такого типу';

  @override
  String get historyEmptyBody =>
      'Скопіюйте текст, зображення чи файл на будь-якому пристрої в парі, і він з’явиться тут.';

  @override
  String get clearConfirmTitle => 'Очистити всю історію?';

  @override
  String clearConfirmBody(String device) {
    return 'Усе, що синхронізовано з ваших пристроїв, і кешовані файли, які зберігає $device, буде видалено. Оригінальні файли не зміняться.';
  }

  @override
  String get clear => 'Очистити';

  @override
  String get historyCleared => 'Історію очищено';

  @override
  String get permDeniedTitle => 'PasteFerry не може читати буфер обміну';

  @override
  String get permAskTitle => 'Дозвольте PasteFerry читати буфер обміну';

  @override
  String get permDeniedBody =>
      'Те, що ви копіюєте на цьому Mac, не синхронізуватиметься. У Системних параметрах установіть для PasteFerry Daemon значення «Дозволити».';

  @override
  String get permAskBody =>
      'Інакше macOS питатиме щоразу. У Системних параметрах установіть для PasteFerry Daemon значення «Дозволити».';

  @override
  String get openSystemSettings => 'Відкрити Системні параметри';

  @override
  String get fetch => 'Отримати';

  @override
  String get fetchStarted => 'Отримання… Прогрес показано в Історії';

  @override
  String get transferFailed => 'Не вдалося передати';

  @override
  String get expired => 'Термін минув';

  @override
  String get putOnClipboard => 'Копіювати';

  @override
  String get putOnClipboardDone => 'У буфері обміну';

  @override
  String get deleteRecord => 'Видалити цей запис';

  @override
  String get deleted => 'Видалено';

  @override
  String get emptyRecord => '(порожньо)';

  @override
  String get imageRecord => 'Зображення';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name і ще $others';
  }

  @override
  String get searchHint => 'Пошук у тексті та назвах файлів';

  @override
  String get searchClear => 'Очистити пошук';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count збігу',
      many: '$count збігів',
      few: '$count збіги',
      one: '$count збіг',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Немає збігів для «$query»';
  }

  @override
  String get searchEmptyBody =>
      'Пошук охоплює скопійований текст і назви скопійованих файлів.';

  @override
  String get favoriteAction => 'Додати у вибране';

  @override
  String get unfavoriteAction => 'Вилучити з вибраного';

  @override
  String get favoritedToast => 'Додано у вибране';

  @override
  String get unfavoritedToast => 'Повернуто в Історію';

  @override
  String get undo => 'Відмінити';

  @override
  String get favoriteSaving => 'Збереження…';

  @override
  String favoritedAt(String date) {
    return 'Збережено $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису',
      many: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0 · без автоочищення · до $size';
  }

  @override
  String get favoritesEmptyTitle => 'Вибраного ще немає';

  @override
  String get favoritesEmptyBody =>
      'Позначте запис зірочкою в Історії, щоб зберегти тут його копію. Вибране ніколи не очищується автоматично.';

  @override
  String get favoritesSearchHint => 'Пошук у вибраному';

  @override
  String favoriteLargeTitle(String size) {
    return 'Зберегти копію розміром $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Вибране зберігає власну копію, тож зміна чи видалення оригінальних файлів на неї не вплине. Копію збереже $device, вона займе $size.';
  }

  @override
  String get saveCopy => 'Зберегти копію';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису у вибраному залишаться.',
      many: '$count записів у вибраному залишаться.',
      few: '$count записи у вибраному залишаться.',
      one: '$count запис у вибраному залишиться.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Вибране';

  @override
  String get favoritesUsageDesc =>
      'Вибране ніколи не очищується, незалежно від параметрів вище';

  @override
  String upToSize(String size) {
    return 'До $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count символу',
      many: '$count символів',
      few: '$count символи',
      one: '$count символ',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… усього символів: $count';
  }

  @override
  String detailMoreFiles(int count) {
    return 'ще $count';
  }

  @override
  String get detailReceiveFirst => 'Виберіть, щоб спершу завантажити';

  @override
  String detailTotalSize(String size) {
    return 'Усього $size';
  }

  @override
  String get quickPaste => 'Швидка вставка';

  @override
  String get quickPasteWindow => 'Вікно швидкої вставки';

  @override
  String get quickPasteWindowDesc =>
      'Натисніть сполучення клавіш у будь-якій програмі, щоб відкрити історію; виберіть запис, і його буде вставлено';

  @override
  String get quickPasteShortcut => 'Сполучення клавіш';

  @override
  String get quickPasteRecord => 'Натисніть, щоб змінити';

  @override
  String get quickPasteRecording => 'Натисніть нове сполучення…';

  @override
  String get quickPasteUseDefault => 'Типове';

  @override
  String get quickPasteNeedsModifier =>
      'Додайте ⌃, ⌥, ⇧ або ⌘ чи використайте функціональну клавішу';

  @override
  String get quickPasteNeedsModifierPc =>
      'Додайте Ctrl, Alt, Shift або клавішу Windows чи використайте функціональну клавішу';

  @override
  String get quickPasteAfterPick => 'Після вибору запису';

  @override
  String get quickPastePasteIt => 'Вставити';

  @override
  String get quickPasteCopyIt => 'Лише скопіювати';

  @override
  String get quickPasteIndexKey => 'Вибір одного з перших 9';

  @override
  String get quickPasteIndexKeyDesc =>
      'У вікні швидкої вставки утримуйте цю клавішу й натисніть 1–9';

  @override
  String get quickPasteAccessibility => 'Універсальний доступ';

  @override
  String get quickPasteAccessibilityDesc =>
      'Потрібен, щоб вставляти за вас. Без нього запис лише копіюється, а ви натискаєте ⌘V.';

  @override
  String get quickPasteAllowed => 'Дозволено';

  @override
  String get quickPasteAllow => 'Дозволити…';

  @override
  String get quickPasteNotRunning => 'Вікно швидкої вставки не запущено';

  @override
  String quickPasteInUse(String key) {
    return '$key використовує інша програма. Виберіть інше сполучення.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Не вдалося встановити $key: $detail';
  }

  @override
  String get quickPastePortalKey =>
      'Задається в системних налаштуваннях сполучень клавіш';

  @override
  String get quickPasteWaylandDesc =>
      'У Wayland додайте сполучення клавіш у налаштуваннях клавіатури робочого середовища. Вибраний запис копіюється; натисніть Ctrl+V, щоб вставити.';

  @override
  String get quickPasteAddShortcut => 'Додати системне сполучення';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Додано. Натисніть $key, щоб спробувати.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Додайте в налаштуваннях клавіатури робочого середовища власне сполучення клавіш, яке виконує: $command';
  }

  @override
  String get pickerSearch => 'Пошук';

  @override
  String get pickerPaste => 'Вставити';

  @override
  String get pickerPlainText => 'Простий текст';

  @override
  String get pickerCopyOnly => 'Лише скопіювати';

  @override
  String get pickerUnfavoriteHint => 'Вилучити (назад в Історію)';

  @override
  String pickerPasteManually(String key) {
    return 'Вибраний запис копіюється — натисніть $key, щоб вставити';
  }

  @override
  String get pickerGrantHint =>
      'Дозвольте Універсальний доступ, щоб вставляти напряму';

  @override
  String pickerElevated(String key) {
    return 'Це вікно запущено від імені адміністратора — після вибору натисніть $key, щоб вставити';
  }

  @override
  String get pickerDownloading => 'Завантаження — вставиться після завершення';

  @override
  String get imagePreviewTitle => 'Перегляд зображення';

  @override
  String get closePreview => 'Закрити перегляд';

  @override
  String get previousImage => 'Попереднє зображення';

  @override
  String get nextImage => 'Наступне зображення';

  @override
  String get previewHint =>
      'Прокрутіть або зведіть пальці, щоб змінити масштаб; перетягніть, щоб переміщатися';

  @override
  String get fitWindow => 'За розміром вікна';

  @override
  String get previewDeleted => 'Це зображення видалено з історії';

  @override
  String get previewExpired =>
      'Термін дії зображення минув, переглянути його не можна';

  @override
  String get previewDownloading => 'Завантаження зображення…';

  @override
  String get previewDownloadFailed =>
      'Не вдалося завантажити. Спробуйте ще раз.';

  @override
  String get previewNotDownloaded =>
      'Цього зображення ще немає на цьому комп’ютері';

  @override
  String get downloadAndPreview => 'Завантажити й переглянути';

  @override
  String get previewUnavailable => 'Зараз це зображення не можна переглянути';

  @override
  String get imageSemantic => 'Зображення з історії';

  @override
  String get previewUnreadable =>
      'Не вдається прочитати зображення. Можливо, файл очищено або пошкоджено.';

  @override
  String get devicesSubtitleEmpty =>
      'Після створення пари ваші пристрої матимуть спільний буфер обміну';

  @override
  String devicesSubtitle(int paired, int online) {
    return 'У парі: $paired, у мережі: $online';
  }

  @override
  String get addDevice => 'Додати пристрій';

  @override
  String thisDeviceFootnote(String both) {
    return 'Під час створення пари $both показують однакові два рядки відбитків безпеки — по одному для кожного пристрою. Підтверджуйте, лише якщо вони збігаються до символу.';
  }

  @override
  String get noDevicesTitle => 'Пристроїв у парі ще немає';

  @override
  String get noDevicesBody =>
      'Відкрийте PasteFerry на іншому комп’ютері та з’єднайте їх 6-символьним кодом пари. Якщо вони в одній мережі, можна також відкрити «Пошук поблизу» на обох і натиснути на інший.';

  @override
  String get pairedDevices => 'Пристрої в парі';

  @override
  String get pairedFootnote =>
      'Напряму: дані передаються безпосередньо між двома пристроями. Ретрансляція: якщо мережа блокує пряме з’єднання, дані йдуть через ваш сервер і залишаються наскрізно зашифрованими.';

  @override
  String get offline => 'Не в мережі';

  @override
  String get direct => 'Напряму';

  @override
  String get relay => 'Ретрансляція';

  @override
  String get online => 'У мережі';

  @override
  String get moreActions => 'Більше';

  @override
  String get copyFingerprint => 'Копіювати відбиток';

  @override
  String get unpairEllipsis => 'Розірвати пару…';

  @override
  String get fingerprintCopied => 'Відбиток скопійовано';

  @override
  String unpairTitle(String name) {
    return 'Розірвати пару з «$name»?';
  }

  @override
  String get unpairBody =>
      'Пристрої перестануть синхронізуватися. Щоб відновити синхронізацію, доведеться знову створити пару й перевірити відбитки.';

  @override
  String get unpair => 'Розірвати пару';

  @override
  String get unpaired => 'Пару розірвано';

  @override
  String get enterAddressEllipsis => 'Ввести його адресу…';

  @override
  String setAddressTitle(String name) {
    return 'Адреса «$name»';
  }

  @override
  String setAddressBody(String name) {
    return 'Використовуйте, коли пристрої в різних підмережах або обидва змінили адреси. Введіть адресу, яку показує «$name» у розділі «Додати пристрій → Показати код».';
  }

  @override
  String get addressSaved => 'Шукаємо пристрій за цією адресою';

  @override
  String get lanBlockedTitle => 'macOS блокує доступ до локальної мережі';

  @override
  String lanBlockedBody(String device) {
    return 'Увімкніть PasteFerry Daemon у розділі «Системні параметри → Приватність і безпека → Локальна мережа». Доти $device не зможе підключатися до пристроїв у цій мережі.';
  }

  @override
  String get searchNearby => 'Пошук поблизу';

  @override
  String get nearbyTitle => 'Пристрої поблизу';

  @override
  String get nearbySearching => 'Пошук пристроїв поблизу…';

  @override
  String get nearbyHint =>
      'Відкрийте «Пошук поблизу» й на іншому комп’ютері, і він з’явиться тут. Натисніть на нього, щоб створити пару.';

  @override
  String nearbyVisible(String device) {
    return 'Поки це вікно відкрите, $device показує свою назву пристроям у цій мережі.';
  }

  @override
  String get nearbyPaired => 'У парі';

  @override
  String nearbyRequesting(String name) {
    return 'Зв’язок із «$name»…';
  }

  @override
  String nearbyNoReply(String name) {
    return '«$name» не відповідає. Переконайтеся, що на ньому досі відкрито «Пошук поблизу».';
  }

  @override
  String get nearbyLanOffTitle => 'Пошук у локальній мережі вимкнено';

  @override
  String get nearbyLanOffBody =>
      'Увімкніть «Шукати пристрої в цій мережі» в розділі «Налаштування → З’єднання», щоб бачити пристрої поблизу, або створіть пару за кодом.';

  @override
  String get generateCode => 'Показати код';

  @override
  String get enterCode => 'Ввести код';

  @override
  String get codeFailedTitle => 'Не вдалося створити код пари';

  @override
  String get enterOnOther => 'Введіть цей код на іншому пристрої';

  @override
  String get codeCopied => 'Код скопійовано';

  @override
  String get codeHint => 'Натисніть, щоб скопіювати. Дійсний 5 хвилин.';

  @override
  String afterEnterFootnote(String both) {
    return 'Після введення коду $both покажуть однакові два рядки відбитків безпеки. Підтверджуйте, лише якщо вони збігаються.';
  }

  @override
  String get codeInvalid => 'Код пари — це 6 літер або цифр';

  @override
  String get localAddress => 'Адреса';

  @override
  String get addressHint =>
      'Інша підмережа? Введіть цю адресу ще й на іншому пристрої.';

  @override
  String get addressCopied => 'Адресу скопійовано';

  @override
  String get differentSubnet => 'Інша підмережа?';

  @override
  String get peerAddress => 'Адреса під кодом';

  @override
  String get pairNotFound =>
      'Не вдалося знайти пристрій. Якщо він в іншій підмережі, введіть адресу, показану під його кодом.';

  @override
  String get pairNotFoundAddress =>
      'За цією адресою ніхто не відповідає. Перевірте адресу й те, що інший пристрій досі показує код. Також з’єднання може блокувати брандмауер на тому пристрої.';

  @override
  String get codeWrong => 'Код неправильний або його термін дії минув';

  @override
  String get codeExpired =>
      'Термін дії коду минув. Покажіть новий код на іншому пристрої.';

  @override
  String get addressInvalid =>
      'Неправильна адреса. Введіть щось на зразок 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Спершу увімкніть пошук у локальній мережі або вкажіть сервер у розділі «Налаштування → З’єднання».';

  @override
  String get enterCodeShown => 'Введіть код, показаний на іншому пристрої';

  @override
  String get pairingDone => 'Пару створено';

  @override
  String get pairingRejected => 'Створення пари відхилено';

  @override
  String get verifyTitle => 'Перевірте відбитки безпеки';

  @override
  String pairingWith(String name) {
    return 'Створення пари з «$name»';
  }

  @override
  String verifyBody(String both) {
    return 'Два рядки, які показують $both, мають бути однаковими. Якщо відрізняється хоч один символ, хтось може втручатися в з’єднання, тож відхиліть.';
  }

  @override
  String get rejectMismatch => 'Не збігаються, відхилити';

  @override
  String get confirmMatch => 'Збігаються, створити пару';

  @override
  String get server => 'Сервер (необов’язково)';

  @override
  String get signalingUrl => 'Сигнальний сервер';

  @override
  String get signalingUrlDesc =>
      'Залиште порожнім лише для локальної синхронізації';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'Покращити прямі з’єднання';

  @override
  String get publicStunDesc =>
      'Публічні сервери бачать вашу публічну IP-адресу';

  @override
  String get connectionStatus => 'З’єднання';

  @override
  String get disconnectedDesc => 'Перевірте адресу сервера та його доступність';

  @override
  String get connected => 'Підключено';

  @override
  String get notConnected => 'Не підключено';

  @override
  String get notSet => 'Не задано';

  @override
  String get serverCleared =>
      'Сервер вилучено. Синхронізація лише в цій мережі.';

  @override
  String get localNetwork => 'Локальна мережа';

  @override
  String get lanDiscovery => 'Шукати пристрої в цій мережі';

  @override
  String get lanDiscoveryDesc =>
      'Анонімний пошук; назви видно лише під час «Пошуку поблизу»';

  @override
  String get macLocalNetwork => 'Доступ до локальної мережі';

  @override
  String get macLocalNetworkDesc =>
      'Дозвольте PasteFerry Daemon у Системних параметрах';

  @override
  String get allowLan => 'Брандмауер Windows';

  @override
  String get allowLanDesc =>
      'Дозволити заблоковані з’єднання; потрібне схвалення адміністратора';

  @override
  String get allow => 'Дозволити';

  @override
  String get allowLanDone =>
      'Дозволено. Тепер інші пристрої можуть підключатися до цього.';

  @override
  String get deviceName => 'Назва пристрою';

  @override
  String get language => 'Мова';

  @override
  String get languageSystem => 'Системна';

  @override
  String get sync => 'Синхронізація';

  @override
  String get autoSyncLimit => 'Ліміт автосинхронізації';

  @override
  String get autoSyncLimitDesc => 'Більші записи отримуйте вручну з Історії';

  @override
  String get autoApply => 'Копіювати отримане в буфер обміну';

  @override
  String get whatToSync => 'Що синхронізувати';

  @override
  String get syncFiles => 'Файли й папки';

  @override
  String get syncText => 'Простий текст';

  @override
  String get syncRich => 'Форматований текст';

  @override
  String get syncImages => 'Зображення та знімки екрана';

  @override
  String get storage => 'Сховище';

  @override
  String get storageFootnote =>
      'Застарілі записи історії та кешовані файли видаляються автоматично.';

  @override
  String get keepHistory => 'Зберігати історію';

  @override
  String get keepCache => 'Зберігати кешовані файли';

  @override
  String get keepCacheDesc => 'Не довше, ніж історію';

  @override
  String get cacheUsage => 'Розмір кешу';

  @override
  String get backgroundSync => 'Фонова синхронізація';

  @override
  String get backgroundService => 'Фонова служба';

  @override
  String get backgroundServiceDesc =>
      'Запускається під час входу; синхронізує й із закритим вікном';

  @override
  String get restart => 'Перезапустити';

  @override
  String get restarted => 'Фонову службу перезапущено';

  @override
  String get disableEllipsis => 'Вимкнути…';

  @override
  String get about => 'Про програму';

  @override
  String get aboutDesc => 'Відкритий код за ліцензією AGPL-3.0';

  @override
  String get homepage => 'Вебсайт';

  @override
  String get feedback => 'Повідомити про проблему';

  @override
  String get disableTitle => 'Вимкнути фонову синхронізацію?';

  @override
  String disableBody(String device) {
    return 'PasteFerry перестане синхронізувати, і $device більше не запускатиме його під час входу. Історія та пари збережуться.';
  }

  @override
  String get disable => 'Вимкнути';

  @override
  String get disabled => 'Фонову синхронізацію вимкнено';

  @override
  String get urlMustBeWs => 'Адреса має починатися з ws:// або wss://';

  @override
  String get serverUpdated => 'Сервер оновлено. Повторне підключення…';

  @override
  String get deviceNameUpdated => 'Назву пристрою оновлено';

  @override
  String get diagIntro =>
      'Цей звіт містить версію програми, дані про систему, налаштування, пристрої та останні журнали. Назви пристроїв, адресу сервера, публічні IP-адреси, папку користувача й назви файлів замінено, а скопійований вміст ніколи не записується в журнали. Звернення на GitHub публічні, тож перегляньте звіт перед публікацією.';

  @override
  String get diagVerboseTitle => 'Докладний журнал';

  @override
  String get diagVerboseDesc =>
      'Для проблем зі з’єднанням: увімкніть, відтворіть проблему, а тоді поверніться й створіть звіт. Вимкнеться автоматично через 30 хвилин.';

  @override
  String get diagVerboseOn => 'Увімкнути на 30 хвилин';

  @override
  String diagVerboseUntil(String time) {
    return 'Увімкнено до $time';
  }

  @override
  String get diagVerboseOff => 'Вимкнути';

  @override
  String get diagRefresh => 'Створити заново';

  @override
  String get diagSave => 'Зберегти у файл';

  @override
  String diagSaved(String name) {
    return 'Збережено в папку «Завантаження»: $name';
  }

  @override
  String get diagCopy => 'Копіювати звіт';

  @override
  String get diagCopied => 'Звіт скопійовано';

  @override
  String get diagNewIssue => 'Нове звернення на GitHub';

  @override
  String get diagIssueHint =>
      'Звіт скопійовано. Вставте його в поле «Diagnostics report» звернення.';

  @override
  String diagFailed(String detail) {
    return 'Не вдалося створити звіт: $detail';
  }

  @override
  String get svcExtractTitle => 'Спершу встановіть або розпакуйте PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry запущено просто з ZIP-архіву, і його тимчасова папка зникне, коли ви його закриєте. Щоб увімкнути фонову синхронізацію, запустіть інсталятор або розпакуйте всю папку й відкрийте програму звідти.';

  @override
  String get svcMoveTitle => 'Спершу перемістіть PasteFerry у «Програми»';

  @override
  String get svcMoveBody =>
      'PasteFerry запущено просто з образу диска. Перетягніть його в «Програми», вийміть образ диска й відкрийте PasteFerry з «Програм», щоб увімкнути фонову синхронізацію.';

  @override
  String get svcStartTitle => 'Початок роботи з PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry синхронізує буфер обміну через невеликий фоновий процес. Він працює й після закриття вікна. Запуск під час входу — окремий параметр, у нових установленнях його вимкнено.';

  @override
  String get svcEnable => 'Увімкнути фонову синхронізацію';

  @override
  String get svcStaleTitle => 'Знову ввімкніть фонову синхронізацію';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry переміщено, але запуск під час входу досі вказує на старе місце. Увімкніть синхронізацію знову, щоб фоновий процес використовував цю копію. Історія та пари збережуться.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry переміщено або встановлено старим скриптом. Увімкніть синхронізацію знову, щоб фоновий процес використовував цю програму. Історія та пари збережуться.';

  @override
  String get svcReenable => 'Увімкнути знову';

  @override
  String get svcStoppedTitle => 'Фонова служба не працює';

  @override
  String get svcStoppedBody =>
      'Фонову службу зупинено. Запустіть її кнопкою нижче; запуск під час входу налаштовується окремо в Налаштуваннях.';

  @override
  String get svcDevBodyWin =>
      'Це збірка для розробки, поруч із нею немає pasteferryd.exe. Щоб зібрати повну версію, виконайте scripts\\build-windows.ps1 у папці з вихідним кодом.';

  @override
  String get svcDevBodyLinux =>
      'Це збірка для розробки, поруч із нею немає pasteferryd. Щоб зібрати повну версію, виконайте ./scripts/package-linux.sh у папці з вихідним кодом.';

  @override
  String get svcDevBodyMac =>
      'Це збірка для розробки без фонової служби. Щоб установити її, виконайте ./scripts/install-macos.sh у папці з вихідним кодом.';

  @override
  String svcLogPath(String path) {
    return 'Журнал: $path';
  }

  @override
  String get svcCanDisable =>
      'Фонову синхронізацію можна будь-коли вимкнути в Налаштуваннях.';

  @override
  String get officialService => 'Сервіс';

  @override
  String get useOfficialService => 'Використовувати сервіс';

  @override
  String get officialServiceDesc =>
      'Синхронізація між мережами, спершу — прямі з’єднання';

  @override
  String get officialPrivacy =>
      'Підключається до сервісу, лише якщо його ввімкнено, і записує тільки необхідні дані про з’єднання. Спершу пробуються прямі з’єднання; доступ до ретрансляції запитується, лише якщо вони не вдаються. Вміст, справжні назви пристроїв і необроблені системні ідентифікатори не передаються.';

  @override
  String get officialEnableTitle => 'Увімкнути сервіс?';

  @override
  String get officialSwitchConfirm =>
      'Це замінить ваш власний сервер. Його збережена адреса залишиться.';

  @override
  String get customServer => 'Власний сервер';

  @override
  String get saveAndConnect => 'Зберегти й підключитися';

  @override
  String get officialLoading => 'Перевірка ліміту…';

  @override
  String get officialFetchFailed =>
      'Зараз не вдається отримати ліміт. Спроба повториться автоматично.';

  @override
  String get officialUnavailable =>
      'Дані про використання недоступні; наявні дані можуть бути застарілими';

  @override
  String get officialQuotaTitle => 'Денний ліміт ретрансляції вичерпано';

  @override
  String get officialQuotaBody =>
      'Ретрансляцію сервісу призупинено до щоденного скидання опівночі за пекінським часом. Локальна мережа й прямі інтернет-з’єднання доступні. Невдалі передавання можна повторити пізніше.';

  @override
  String get officialPeerQuota =>
      'В іншого пристрою вичерпано ліміт ретрансляції. Прямі з’єднання доступні.';

  @override
  String get officialPaused =>
      'Ретрансляція сервісу недоступна. Прямі з’єднання доступні.';

  @override
  String get officialViewUsage => 'Переглянути використання';

  @override
  String get officialAcknowledge => 'Зрозуміло';

  @override
  String get officialToday => 'Ліміт ретрансляції на сьогодні';

  @override
  String get officialUsed => 'Використано';

  @override
  String get officialRemaining => 'Залишилося';

  @override
  String get officialDailyLimit => 'Денний ліміт';

  @override
  String get officialUpload => 'Вивантаження';

  @override
  String get officialDownload => 'Завантаження';

  @override
  String get officialReset => 'Час скидання (Пекін)';

  @override
  String get officialUpdated => 'Оновлено';

  @override
  String get officialRoutes => 'Як підключаються пристрої';

  @override
  String get officialRoutesFootnote =>
      'Прямі з’єднання не проходять через ретрансляцію сервісу й не витрачають ліміт.';

  @override
  String get officialDeviceID => 'ID пристрою';

  @override
  String get officialWarning =>
      'Використано 90% денного ліміту ретрансляції. Прямі з’єднання його не витрачають.';

  @override
  String get updateCheck => 'Перевірити оновлення';

  @override
  String get updateCheckEllipsis => 'Перевірити оновлення…';

  @override
  String get updateAuto => 'Автоматично перевіряти оновлення';

  @override
  String get updateChecking => 'Перевірка оновлень…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version — найновіша версія.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'Доступна версія PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'У вас версія $current. Розмір завантаження: $size.';
  }

  @override
  String get updateNew => 'Нове';

  @override
  String get updateFixed => 'Виправлено';

  @override
  String get updateSkip => 'Пропустити цю версію';

  @override
  String get updateLater => 'Пізніше';

  @override
  String get updateInstall => 'Завантажити й установити';

  @override
  String updateDownloading(String done, String total) {
    return 'Завантажено $done з $total';
  }

  @override
  String get updateVerifying => 'Перевірка завантаженого…';

  @override
  String get updateInstalling =>
      'Встановлення. PasteFerry відкриється знову автоматично.';

  @override
  String get updateInstallingPassword =>
      'Встановлення. Система попросить ваш пароль, бо для /opt потрібні права адміністратора; потім PasteFerry відкриється знову автоматично.';

  @override
  String get updateCheckFailed =>
      'Не вдалося зв’язатися з GitHub або Gitee. Спробуйте пізніше.';

  @override
  String get updateDownloadFailed =>
      'Завантаження не завершилося. Спробуйте ще раз або завантажте нову версію з вебсайту.';

  @override
  String updateInstallFailed(String error) {
    return 'Не вдалося почати встановлення: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Ця збірка не може перевіряти оновлення.';

  @override
  String get updateBlockedDev =>
      'Це збірка для розробки, тому вона не може оновлюватися сама.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry запущено з образу диска. Перетягніть його в «Програми» й відкрийте звідти, щоб оновлюватися автоматично.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry не може записувати в папку, де його встановлено. Завантажте нову версію з вебсайту.';

  @override
  String get updateBlockedUnsupported =>
      'Для цього комп’ютера немає автоматичного оновлення. Завантажте нову версію з вебсайту.';

  @override
  String get updateOpenDownload => 'Відкрити сторінку завантаження';

  @override
  String updateSidebar(String version) {
    return 'Доступна версія $version';
  }

  @override
  String updatedTo(String version) {
    return 'Оновлено до $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Оновлення не завершилося. У вас досі версія $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Оновлення не завершилося. У вас досі версія $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Інтерфейс $uiVersion · Служба $serviceVersion · Збірка $build';
  }

  @override
  String get notReceived => 'Не отримано — отримайте перед вставленням';

  @override
  String get receivedPreserved =>
      'Отримано; скористайтеся «Копіювати в буфер обміну», коли будете готові';

  @override
  String get clipboardWriteFailed =>
      'Отримано, але не вдалося оновити буфер обміну';

  @override
  String get receivingStatus => 'Отримання…';

  @override
  String get largeFileNotifications => 'Нагадування про великі файли';

  @override
  String get notificationsAllowed =>
      'Сповіщення ввімкнено. Прогрес показано в Історії.';

  @override
  String get notificationsNotRequested =>
      'Увімкніть сповіщення, щоб великі файли не чекали непомітно. Їх завжди можна отримати з Історії.';

  @override
  String get notificationsDenied =>
      'Сповіщення заблоковано в системних налаштуваннях. Отримуйте записи, що очікують, з Історії.';

  @override
  String get notificationsUnknown =>
      'Показом сповіщень і режимом «Не турбувати» керує ваше робоче середовище. Якщо нагадування не з’являється, отримуйте записи з Історії.';

  @override
  String get notificationsUnavailable =>
      'Системні сповіщення недоступні. Отримуйте великі файли з Історії.';

  @override
  String get enableNotifications => 'Увімкнути нагадування';

  @override
  String get notificationSettings => 'Налаштування сповіщень';

  @override
  String get notifyPendingTitle => 'Отримайте, щоб вставити';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nОтримайте цей запис перед вставленням. Також його можна отримати з Історії.';
  }

  @override
  String get notifyReceivingTitle => 'Отримання…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nПрогрес показано в Історії.';
  }

  @override
  String get notifyReadyTitle => 'Готово до вставлення';

  @override
  String notifyReadyBody(String name) {
    return '$name\nОтримано й скопійовано в буфер обміну.';
  }

  @override
  String get notifyReceivedTitle => 'Отримано';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nВміст буфера обміну збережено. Скористайтеся «Копіювати в буфер обміну», коли будете готові; це можна зробити й в Історії.';
  }

  @override
  String get notifyFailedTitle => 'Не вдалося отримати';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nСпробуйте ще раз із цього сповіщення або з Історії.';
  }

  @override
  String get notifyClipboardFailedTitle => 'Отримано; буфер обміну не оновлено';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nЩоб повторити, скористайтеся «Копіювати в буфер обміну» тут або в Історії.';
  }

  @override
  String get reconnect => 'Перепідключити';

  @override
  String get reconnecting => 'Підключення…';

  @override
  String get reconnectDirect => 'Підключено напряму';

  @override
  String get reconnectRelay =>
      'Не вдалося підключитися напряму, далі через ретрансляцію';

  @override
  String reconnectOffline(String name) {
    return '«$name» не в мережі. Переконайтеся, що на ньому відкрито PasteFerry.';
  }

  @override
  String get reconnectPending =>
      'Підключення ще триває, перевірте трохи згодом';

  @override
  String get renameAction => 'Перейменувати';

  @override
  String get renameFavoriteTitle => 'Перейменувати запис у вибраному';

  @override
  String get renameFavoriteHint =>
      'Ця назва показується у Вибраному та у швидкій вставці, і за нею можна шукати. Залиште порожнім, щоб знову показувати вміст.';

  @override
  String get renamedToast => 'Перейменовано';

  @override
  String get aliasClearedToast => 'Знову показується вміст';

  @override
  String get navSend => 'Надсилання файлів';

  @override
  String get sendSubtitle =>
      'Перетягніть файли на пристрій, щоб надіслати їх напряму';

  @override
  String get sendNoDevicesTitle => 'Пристроїв у парі ще немає';

  @override
  String get sendNoDevicesBody =>
      'Спершу створіть пару з іншим комп’ютером, а тоді надсилайте йому файли тут.';

  @override
  String get sendDropHint => 'Перетягніть на пристрій, щоб надіслати';

  @override
  String sendReleaseTo(String name) {
    return 'Відпустіть, щоб надіслати на $name';
  }

  @override
  String get sendLan => 'Локальна мережа';

  @override
  String sendRelayLeft(String left) {
    return 'Ретрансляція · сьогодні залишилося $left';
  }

  @override
  String get sendNeedsUpdate => 'Потрібне оновлення';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name зможе отримувати файли після оновлення до PasteFerry 2.5 або новішої версії.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Підключення до $name. Надсилати можна буде після підключення.';
  }

  @override
  String get sendNotReceiving => 'Не приймає файли';

  @override
  String get sendDelivered => 'Доставлено';

  @override
  String sendToTitle(String name) {
    return 'Надіслати на $name';
  }

  @override
  String get sendDropHere => 'Перетягніть сюди файли або папки';

  @override
  String get sendDropStarts => 'Надсилання почнеться, щойно ви їх відпустите';

  @override
  String get sendChooseFiles => 'Вибрати файли…';

  @override
  String get sendChooseFolder => 'Вибрати папку…';

  @override
  String get sendDropMore =>
      'Перетягніть ще файли, щоб надіслати їх наступними';

  @override
  String sendSavedWhere(String name) {
    return 'Файли зберігаються там, де вибрано на $name, — типово в папці «Завантаження».';
  }

  @override
  String get sendCloseKeeps => 'Закриття вікна не зупиняє надсилання';

  @override
  String get sendRemoveQueued => 'Вилучити';

  @override
  String get sendCannotDrop =>
      'Цей елемент не можна надіслати перетягуванням. Спершу збережіть його як файл або скористайтеся «Вибрати файли…».';

  @override
  String sendErrOffline(String name) {
    return '$name не в мережі.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name не приймає файли.';
  }

  @override
  String get sendErrMissing => 'Деяких із цих файлів більше немає.';

  @override
  String get relayConfirmTitle => 'Надіслати через ретрансляцію сервісу?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name зараз не має прямого з’єднання з цим комп’ютером, тож файли підуть через ретрансляцію сервісу зі швидкістю близько 0,25 МБ/с. Сьогоднішнього ліміту ретрансляції залишилося $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Ці файли ($size) перевищують залишок ліміту. Коли ліміт вичерпається, надсилання призупиниться й продовжиться, щойно комп’ютери з’єднаються напряму або завтра ліміт скинеться.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Це використає приблизно $size сьогоднішнього ліміту.';
  }

  @override
  String get relayExhausted =>
      'Сьогоднішній ліміт ретрансляції вичерпано. Він скидається опівночі за пекінським часом. Для комп’ютерів, з’єднаних напряму, обмежень немає.';

  @override
  String get relayDontAskToday =>
      'Сьогодні більше не питати для цього пристрою';

  @override
  String get relaySendAnyway => 'Усе одно надіслати';

  @override
  String get relayOwnServer =>
      'Ретрансляція — швидкість залежить від вашого сервера';

  @override
  String get transfersReceived => 'Отримані';

  @override
  String get transfersSent => 'Надіслані';

  @override
  String get transfersClearAll => 'Очистити все';

  @override
  String get transfersClearTitle => 'Очистити цей список?';

  @override
  String get transfersClearBody =>
      'Очищується лише список. Файли залишаються на місці.';

  @override
  String get transfersEmptyReceived =>
      'Тут з’являтимуться файли, які вам надсилають інші пристрої';

  @override
  String get transfersEmptySent =>
      'Тут з’являтимуться файли, які надсилаєте ви';

  @override
  String transferFrom(String name) {
    return 'Від $name';
  }

  @override
  String transferTo(String name) {
    return 'Для $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name і ще $others';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файлу',
      many: '$count файлів',
      few: '$count файли',
      one: '$count файл',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'У черзі';

  @override
  String transferScanning(String count) {
    return 'Підрахунок… знайдено файлів: $count';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Очікування $name…';
  }

  @override
  String get transferSending => 'Надсилання';

  @override
  String get transferReceiving => 'Отримання';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Зараз: $file ($index з $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Залишилося $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n секунди',
      many: '$n секунд',
      few: '$n секунди',
      one: '$n секунда',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n хвилини',
      many: '$n хвилин',
      few: '$n хвилини',
      one: '$n хвилина',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h год $m хв';
  }

  @override
  String get transferPaused =>
      'Призупинено: сьогоднішній ліміт ретрансляції вичерпано';

  @override
  String get transferInterrupted =>
      'Перервано — продовжиться після повторного підключення';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Перервано — очікування, поки $name продовжить';
  }

  @override
  String get transferCancelled => 'Скасовано';

  @override
  String transferPeerCancelled(String name) {
    return 'Скасовано: $name';
  }

  @override
  String get transferExpired => 'Термін минув';

  @override
  String get transferMissing => 'Переміщено або видалено';

  @override
  String transferNotSent(String reason) {
    return 'Не надіслано: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Не отримано: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return 'на $name не вистачає місця на диску (бракує $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'недостатньо місця на диску (бракує $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'місце збереження на $name недоступне';
  }

  @override
  String get reasonDestUnavailable =>
      'місце збереження недоступне — перевірте його в Налаштуваннях';

  @override
  String get reasonFileTooLarge =>
      'місце збереження розташоване на диску FAT32, який не вміщує файли понад 4 ГБ';

  @override
  String reasonDisabledPeer(String name) {
    return '$name не приймає файли';
  }

  @override
  String get reasonSourceChanged => 'файл змінився під час надсилання';

  @override
  String get reasonSourceMissing => 'файлу більше немає';

  @override
  String get reasonReadError => 'не вдалося прочитати файл';

  @override
  String get reasonWriteFailed => 'не вдалося записати файли';

  @override
  String get reasonHashMismatch => 'файл пошкоджено під час передавання';

  @override
  String reasonUnsupported(String name) {
    return '$name потрібно оновити, щоб отримувати файли';
  }

  @override
  String get reasonOther => 'щось пішло не так';

  @override
  String get revealInFinder => 'Показати у Finder';

  @override
  String get revealInFolder => 'Показати в папці';

  @override
  String get revealOpenFolder => 'Відкрити папку';

  @override
  String get transferResend => 'Надіслати знову';

  @override
  String get transferRemove => 'Вилучити зі списку';

  @override
  String get transferCopyPath => 'Копіювати шлях';

  @override
  String get transferPathCopied => 'Шлях скопійовано';

  @override
  String sendingTo(String name, String percent) {
    return 'Надсилання на $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Отримання від $name · $percent';
  }

  @override
  String get receiveFiles => 'Приймати файли з інших пристроїв';

  @override
  String get saveTo => 'Зберігати в';

  @override
  String get saveToChange => 'Змінити…';

  @override
  String get saveToDefault => 'Завантаження (типово)';

  @override
  String get saveToUseDefault => 'Використовувати «Завантаження»';

  @override
  String get receiveNotify => 'Сповіщати про отримання файлів';

  @override
  String receiveFootnote(String device) {
    return 'Надсилати файли на $device можуть лише пристрої в парі. Поки файли передаються, $device не переходитиме в режим сну сам.';
  }

  @override
  String get saveDirNotFound => 'Цієї папки не існує.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry не може зберігати файли в цій папці.';

  @override
  String get saveDirPermission =>
      'PasteFerry не має дозволу на використання цієї папки. Дозвольте його в розділі «Системні параметри → Приватність і безпека → Файли й папки».';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count назви файлів містили символи, недопустимі у Windows; їх замінено схожими повноширинними символами',
      many:
          '$count назв файлів містили символи, недопустимі у Windows; їх замінено схожими повноширинними символами',
      few:
          '$count назви файлів містили символи, недопустимі у Windows; їх замінено схожими повноширинними символами',
      one:
          '$count назва файлу містила символи, недопустимі у Windows; їх замінено схожими повноширинними символами',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Та сама мережа';

  @override
  String get sendRingOther => 'Інші мережі';

  @override
  String sendOfflineList(String names) {
    return 'Не в мережі: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Список передавань';

  @override
  String get sendLayoutSide => 'Праворуч від радара';

  @override
  String get sendLayoutBelow => 'Під радаром';

  @override
  String get general => 'Загальні';

  @override
  String get launchAtLogin => 'Запускати під час входу';

  @override
  String get launchAtLoginDesc =>
      'Запускатися у фоні, коли ви входите в систему. Зміна цього параметра не зупиняє поточний сеанс.';

  @override
  String get realtimeSync => 'Синхронізація буфера обміну в реальному часі';

  @override
  String get realtimeSyncDesc =>
      'Автоматично передавати нові копіювання пристроям у парі. Якщо вимкнено, локальна історія та надсилання файлів залишаються доступними.';

  @override
  String get syncBacklog => 'Надолужувати після повторного підключення';

  @override
  String get syncBacklogDesc =>
      'Типово вимкнено: пропущені копіювання не надсилаються. Якщо ввімкнено, до 20 копіювань за останні 24 години потрапляють в історію, не замінюючи вміст буфера обміну.';

  @override
  String get peerRealtimeSync => 'Синхронізувати з цим комп’ютером';

  @override
  String get syncPaused => 'Синхронізацію буфера обміну призупинено';

  @override
  String get quitApp => 'Вийти з PasteFerry';

  @override
  String get quitAppDesc =>
      'Зупинити всі процеси PasteFerry. Параметр запуску під час входу збережеться.';

  @override
  String get quitTransfersWarning =>
      'Файли ще передаються. Вийти й перервати ці передавання?';

  @override
  String get backgroundRunningTitle => 'PasteFerry продовжить працювати';

  @override
  String get backgroundRunningBody =>
      'Після закриття вікна синхронізація та швидка вставка працюють далі. Щоб зупинити все, виберіть «Вийти з PasteFerry» в Налаштуваннях або в меню програми.';

  @override
  String get displayAs => 'Відображається як';

  @override
  String get editName => 'Змінити ім’я';

  @override
  String get nameHint => 'Ім’я, яке бачать ваші контакти';

  @override
  String get nameDefaultHint =>
      'Залиште порожнім, щоб використовувати ім’я облікового запису.';

  @override
  String get avatarTitle => 'Фото профілю';

  @override
  String get avatarChoose => 'Вибрати зображення…';

  @override
  String get avatarPaste => 'Вставити зображення';

  @override
  String get avatarReset => 'Типове фото';

  @override
  String get avatarZoom => 'Масштаб';

  @override
  String get avatarDragHint => 'Перетягніть, щоб перемістити зображення.';

  @override
  String get avatarNoImage => 'У буфері обміну немає зображення.';

  @override
  String get avatarBad =>
      'Це зображення не підходить. Виберіть PNG, JPEG або GIF.';

  @override
  String get done => 'Готово';

  @override
  String get friendsTitle => 'Контакти';

  @override
  String get addFriend => 'Додати контакт';

  @override
  String get friendsEmpty => 'Контактів ще немає';

  @override
  String get friendsEmptyBody =>
      'Додайте когось, хто теж користується PasteFerry, щоб надсилати одне одному файли без створення пари. Контакти можуть лише надсилати файли; ваш буфер обміну вони не бачать.';

  @override
  String get friendSendAction => 'Надіслати…';

  @override
  String get friendHistory => 'Передавання';

  @override
  String friendHistoryTitle(String name) {
    return 'Передавання з $name';
  }

  @override
  String get friendHistoryEmpty => 'Передавань ще не було.';

  @override
  String get friendAutoAccept => 'Приймати файли автоматично';

  @override
  String get friendRemove => 'Вилучити контакт';

  @override
  String friendRemoveTitle(String name) {
    return 'Вилучити $name?';
  }

  @override
  String get friendRemoveBody =>
      'Вас буде вилучено з контактів одне одного, і ви більше не зможете надсилати одне одному файли. Попередні передавання залишаться на цьому комп’ютері.';

  @override
  String friendLastActivity(String time) {
    return 'Остання передача: $time';
  }

  @override
  String get friendNoActivity => 'Передавань ще не було';

  @override
  String get friendCodeShare =>
      'Надішліть цей код своєму контакту. Коли він введе його в PasteFerry, ви з’явитеся в контактах одне одного.';

  @override
  String friendCodeExpires(String time) {
    return 'Діє ще $time';
  }

  @override
  String get friendCodeOr => 'або';

  @override
  String get friendCodeEnter => 'Введіть код контакту';

  @override
  String get friendCodeAdd => 'Додати';

  @override
  String get friendCodeWaiting => 'Очікування, поки інша сторона введе код…';

  @override
  String friendConfirmBody(String name) {
    return 'Додати $name до контактів?';
  }

  @override
  String get friendSafetyCode => 'Перевірити код безпеки (необов’язково)';

  @override
  String get friendSafetyHint =>
      'Коли ви поруч, порівняйте ці два рядки. Якщо вони однакові на обох комп’ютерах, ніхто не втручався.';

  @override
  String get friendWaitingPeer => 'Очікування, поки вас додадуть…';

  @override
  String friendAdded(String name) {
    return '$name додано до контактів';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name скасовує';
  }

  @override
  String get friendErrFriendCode =>
      'Це код контакту. Введіть його в «Додати контакт» на сторінці «Надсилання файлів».';

  @override
  String get friendErrDeviceCode =>
      'Це код пари. Введіть його в розділі «Пристрої → Додати пристрій».';

  @override
  String get friendErrOutdated =>
      'Іншій стороні потрібен PasteFerry 2.6.0 або новіший.';

  @override
  String get friendErrAlreadyPaired =>
      'Цей комп’ютер уже є одним із ваших пристроїв.';

  @override
  String get friendErrNoChannel =>
      'Ви не в одній мережі. Щоб додати одне одного, увімкніть «Сервіс» на обох комп’ютерах.';

  @override
  String get openService => 'Увімкнути сервіс…';

  @override
  String get noteLabel => 'Примітка (необов’язково)';

  @override
  String get noteHintEmpty => 'Спершу виберіть файли';

  @override
  String get noteHint => 'Наприклад: підпишіть, будь ласка, сторінку 3';

  @override
  String noteLine(String note) {
    return 'Примітка: $note';
  }

  @override
  String get sendAction => 'Надіслати';

  @override
  String sendItemsSummary(String count, String size) {
    return 'Елементів: $count · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Перетягніть сюди файли чи зображення або вставте ($key)';
  }

  @override
  String get sendDropMorePaste => 'Перетягніть або вставте ще';

  @override
  String get sendPasteNothing =>
      'Нічого вставити. Спершу скопіюйте файли або зображення.';

  @override
  String get sendRemoveItem => 'Вилучити';

  @override
  String sendFriendSaved(String name) {
    return '$name підтверджує кожен пакет перед надсиланням.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Очікування, поки $name прийме…';
  }

  @override
  String get transferAskingIn => 'Очікує вашого підтвердження';

  @override
  String reasonDeclined(String name) {
    return '$name відхиляє запит';
  }

  @override
  String reasonTimeout(String name) {
    return '$name не відповідає';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name не приймає файли';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name зараз не приймає ваші файли';
  }

  @override
  String get reasonYouDeclined => 'Відхилено';

  @override
  String get reasonYouIgnored => 'Проігноровано';

  @override
  String get sendAgain => 'Надіслати знову';

  @override
  String incomingTitle(String name) {
    return '$name хоче надіслати вам файли';
  }

  @override
  String get incomingAlways => 'Завжди приймати файли від цього контакту';

  @override
  String get incomingDecline => 'Відхилити';

  @override
  String get incomingAccept => 'Прийняти';

  @override
  String incomingCountdown(String seconds) {
    return 'Автоматичне відхилення через $seconds с';
  }

  @override
  String get incomingStranger => 'Поблизу';

  @override
  String get friendsStrip => 'Контакти';

  @override
  String get strangersStrip => 'Поблизу з увімкненим «Усі»';

  @override
  String get strangerNearby => 'Поблизу';

  @override
  String get friendNeedService => 'Увімкніть сервіс';

  @override
  String get friendCantReach => 'Не вдається підключитися';

  @override
  String reachSelfNoService(String name) {
    return 'Ви і $name не в одній мережі. Увімкніть «Сервіс», щоб надсилати файли; якщо прямого з’єднання немає, вони підуть через ретрансляцію сервісу.';
  }

  @override
  String reachPeerNoService(String name) {
    return 'У $name не ввімкнено «Сервіс», тому надсилати файли можна лише в одній мережі. Попросіть увімкнути «Сервіс» у PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Ви використовуєте різні сервери. Щоб надсилати файли, увімкніть «Сервіс» на обох комп’ютерах або використовуйте той самий сервер.';

  @override
  String get receiveFromLabel => 'Хто може надсилати мені файли:';

  @override
  String get receiveFromOff => 'Ніхто';

  @override
  String get receiveFromFriends => 'Лише контакти';

  @override
  String get receiveFromEveryone => 'Усі';

  @override
  String everyoneLeft(String minutes) {
    return 'Усі · залишилося $minutes хв';
  }

  @override
  String get receiveFromOffDesc =>
      'Надсилати вам файли можуть лише ваші комп’ютери в парі.';

  @override
  String get receiveFromFriendsDesc =>
      'Ваші контакти можуть надсилати вам файли. Кожен пакет ви приймаєте самі.';

  @override
  String get receiveFromEveryoneDesc =>
      'Протягом 10 хвилин будь-хто в тій самій мережі може надсилати вам файли. Кожен пакет ви приймаєте самі.';

  @override
  String get everyoneEnded =>
      'Режим «Усі» вимкнено; повернуто «Лише контакти».';

  @override
  String get friendsCountTooltip => 'Контакти';

  @override
  String get waitingAccept => 'Очікування…';

  @override
  String get settingsConnection => 'З’єднання';

  @override
  String get settingsGeneralSummary =>
      'Запуск під час входу, назва пристрою, мова';

  @override
  String get settingsConnectionSummary =>
      'Сервіс, власний сервер, локальна мережа';

  @override
  String get settingsSyncSummary =>
      'Синхронізація в реальному часі, ліміт розміру, що синхронізувати';

  @override
  String get settingsQuickPasteSummary =>
      'Сполучення клавіш і дія після вибору';

  @override
  String get settingsSendSummary => 'Отримання файлів, місце збереження';

  @override
  String get settingsStorageSummary =>
      'Скільки зберігати історію, зайняте місце';

  @override
  String get settingsAboutSummary => 'Версія, оновлення, відгуки';

  @override
  String get friendsSubtitle =>
      'Надсилайте файли на комп’ютери інших людей без створення пари';

  @override
  String get friendsSearch => 'Пошук контактів';

  @override
  String get friendsNoMatch => 'Немає відповідних контактів';

  @override
  String get friendsPick =>
      'Виберіть контакт, щоб переглянути передавання або надіслати файли';

  @override
  String friendDropHint(String name) {
    return 'Перетягніть сюди файли для $name';
  }

  @override
  String get webShareTitle => 'Передавання з телефона через браузер';

  @override
  String get webShareFootnote =>
      'Відскануйте QR-код телефоном, щоб обмінюватися текстом, фото й файлами з цим комп’ютером у браузері без програми. Телефон і комп’ютер мають бути в одній мережі.';

  @override
  String get webShareSwitch => 'Дозволити телефонам підключатися через браузер';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Увімкнено, $count телефону',
      many: 'Увімкнено, $count телефонів',
      few: 'Увімкнено, $count телефони',
      one: 'Увімкнено, $count телефон',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'Вимкнено';

  @override
  String get webShareShowQr => 'Показати QR-код';

  @override
  String get webShareDialogTitle => 'Відскануйте телефоном';

  @override
  String get webShareDialogBody =>
      'Відскануйте камерою телефона або браузером і відкрийте в браузері. Кожен QR-код реєструє один телефон і після використання замінюється.';

  @override
  String get webShareAddress => 'Адреса';

  @override
  String get webShareSecurity =>
      'Вміст шифрується на сторінці, тож інші в мережі не можуть його прочитати. Але сама сторінка працює через http і не захищає від навмисного втручання. Користуйтеся вдома або в надійній офісній мережі, а не в публічній Wi‑Fi.';

  @override
  String get webSharePhones => 'Зареєстровані телефони';

  @override
  String get webShareNoPhones => 'Телефонів ще немає';

  @override
  String webShareLastUsed(String time) {
    return 'Востаннє: $time';
  }

  @override
  String get webShareRemove => 'Вилучити';

  @override
  String webShareRemoved(String name) {
    return '«$name» вилучено';
  }

  @override
  String webShareNewPhone(String name) {
    return '«$name» зареєстровано';
  }

  @override
  String webShareNotListening(String error) {
    return 'Не вдалося почати прослуховування: $error';
  }

  @override
  String get webSharePortFallback =>
      'Звичайний порт зайнятий, тому використовується тимчасовий. Збережені адреси не відкриватимуться, доки телефони не відсканують код знову.';

  @override
  String get webShareNoAddress =>
      'Немає адреси в локальній мережі. Спершу підключіться до Wi‑Fi або дротової мережі.';

  @override
  String get webShareCantOpen =>
      'Якщо сторінка не відкривається на телефоні, переконайтеся, що обидва пристрої в одній мережі (гостьові мережі зазвичай не підходять). У Windows також потрібно дозволити PasteFerry в брандмауері.';

  @override
  String get mTabRecords => 'Історія';

  @override
  String get mTabSend => 'Надіслати';

  @override
  String get mThisPhone => 'Цей телефон';

  @override
  String get mThisPhoneInText => 'цей телефон';

  @override
  String mThisPhoneName(String name) {
    return 'Цей телефон: $name';
  }

  @override
  String get mSendTitle => 'Надіслати на комп’ютер';

  @override
  String get mSendHint => 'Введіть або вставте текст';

  @override
  String get mPaste => 'Вставити';

  @override
  String get mPhotosFiles => 'Фото або файли';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Надіслати файли ($n)?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n файлу надіслано на комп’ютер',
      many: '$n файлів надіслано на комп’ютер',
      few: '$n файли надіслано на комп’ютер',
      one: '$n файл надіслано на комп’ютер',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'У буфері обміну немає тексту';

  @override
  String get mSendAction => 'Надіслати';

  @override
  String mSendTo(String names) {
    return 'Отримувачі: $names';
  }

  @override
  String get mNoOnlineDevices => 'Поблизу немає пристроїв у мережі';

  @override
  String get mNoPairedDevices => 'Спершу створіть пару з комп’ютером';

  @override
  String get mSent => 'Надіслано';

  @override
  String get mSendFootnote =>
      'Текст і файли потрапляють в історію на комп’ютері та, залежно від його налаштувань, у його буфер обміну. Те, що ви копіюєте на телефоні, саме не надсилається.';

  @override
  String get mSentRecords => 'Надіслане';

  @override
  String get mSentRetention => 'Зберігати надіслане';

  @override
  String mSentRetentionDesc(Object d) {
    return '«Надіслане» показує, що цей телефон надіслав за останні $d дн.';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d дн.';
  }

  @override
  String get mViewAll => 'Переглянути все';

  @override
  String get mClearCache => 'Очистити';

  @override
  String get mCheckUpdate => 'Перевірити оновлення';

  @override
  String get mUpdateFailed => 'Не вдалося перевірити оновлення';

  @override
  String get mUpToDate => 'У вас найновіша версія';

  @override
  String mNewVersion(Object v) {
    return 'Доступна версія $v';
  }

  @override
  String get mDownloadInstall => 'Завантажити нову версію';

  @override
  String mSendFailed(String detail) {
    return 'Не вдалося надіслати: $detail';
  }

  @override
  String get mCopy => 'Копіювати';

  @override
  String get mCopied => 'Скопійовано в буфер обміну телефона';

  @override
  String get mShare => 'Поділитися';

  @override
  String get mSaved => 'Збережено у Фото або в Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Не вдалося: $detail';
  }

  @override
  String get mDownloading => 'Завантаження…';

  @override
  String get mNotDownloaded => 'Ще не завантажено';

  @override
  String get mDownloadHint =>
      'Спершу завантажиться, коли ви натиснете «Копіювати», «Зберегти» або «Поділитися».';

  @override
  String get mFullTextLoading => 'Завантаження…';

  @override
  String mTextTruncated(int shown, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total символу',
      many: '$total символів',
      few: '$total символів',
      one: '$total символу',
    );
    return 'Показано перші $shown з $_temp0. Копіюється весь текст.';
  }

  @override
  String get mNotOnLanTitle => 'Немає Wi‑Fi';

  @override
  String get mNotOnLanBody =>
      'Поки що PasteFerry синхронізує лише в локальній мережі. Підключіться до тієї самої Wi‑Fi, що й комп’ютер.';

  @override
  String mStartFailed(String detail) {
    return 'Не вдалося запустити PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'На комп’ютері відкрийте PasteFerry → «Пристрої» → «Додати пристрій» і введіть тут показаний код. В одній Wi‑Fi можна також відкрити «Пошук поблизу» на обох пристроях.';

  @override
  String get mSectionSync => 'Синхронізація';

  @override
  String get mSectionBackground => 'Фонова робота';

  @override
  String get mAutoApplyDesc =>
      'Текст, скопійований на комп’ютері, одразу потрапляє в буфер обміну телефона. Зображення й файли чекають, доки ви натиснете «Копіювати».';

  @override
  String get mKeepAlive => 'Залишатися на зв’язку у фоні';

  @override
  String get mKeepAliveDesc =>
      'Отримувати текст, навіть коли PasteFerry не відкрито. Показується постійне сповіщення.';

  @override
  String get mNotifications => 'Сповіщення';

  @override
  String get mNotificationsDesc =>
      'Потрібні для постійного сповіщення. PasteFerry працює й без них.';

  @override
  String get mBattery => 'Робота у фоні';

  @override
  String get mBatteryDesc =>
      'Вимкніть оптимізацію батареї, щоб система не зупиняла PasteFerry, коли екран заблоковано. На деяких телефонах також треба додати PasteFerry до списку автозапуску або фонової роботи в Налаштуваннях.';

  @override
  String get mAllowed => 'Дозволено';

  @override
  String get mAllow => 'Дозволити';

  @override
  String mVersion(String version) {
    return 'Версія $version';
  }

  @override
  String get mDeleteConfirm => 'Видалити цей запис?';

  @override
  String get mDelete => 'Видалити';

  @override
  String get webShareFirewallPreparing =>
      'Перевірка брандмауера Windows. Якщо Windows попросить схвалення адміністратора, виберіть «Так», щоб телефон міг підключитися.';

  @override
  String get webShareFirewallReady =>
      'Правила брандмауера Windows готові. Підключіть телефон до тієї самої мережі й відскануйте QR-код. Якщо підключитися досі не вдається, перевірте брандмауер ще раз нижче.';

  @override
  String get webShareFirewallFailed =>
      'Налаштування брандмауера не завершено. Телефон може не відкрити сторінку. Спробуйте ще раз і підтвердьте запит адміністратора Windows.';

  @override
  String get webShareFirewallAllow =>
      'Перевірити й дозволити підключення телефону';

  @override
  String get mCopyMediaFailed =>
      'Не вдалося скопіювати це зображення або файл. Спершу спробуйте зберегти.';

  @override
  String get mShareMediaFailed =>
      'Не вдалося відкрити меню «Поділитися» для цього зображення або файлу. Спершу спробуйте зберегти.';

  @override
  String get mSaveMediaFailed =>
      'Не вдалося зберегти це зображення або файл. Перевірте доступ до пам’яті й вільне місце, а тоді повторіть спробу.';

  @override
  String get noticeFilesUnreadable =>
      'Щойно скопійовані файли не вдалося прочитати, тож нічого не синхронізовано';

  @override
  String get mAddMore => 'Додати ще';

  @override
  String get mChoosePhotos => 'Вибрати фото…';

  @override
  String get mMultiSelectHint =>
      'Можна вибрати кілька фото одразу. У «Файлах» торкніться елемента й утримуйте, щоб вибрати ще.';

  @override
  String get webSendFiles => 'Надіслати файли';

  @override
  String get webFilesQueued =>
      'Додано до передавань через браузер. Відкрийте «Надсилання файлів» на телефоні, щоб завантажити.';

  @override
  String get webFilesLimit =>
      'Завантаження через браузер підтримує файли до 200 МБ і до 64 файлів за раз.';

  @override
  String get appearance => 'Оформлення';

  @override
  String get settingsAppearanceSummary => 'Тема, світла й темна';

  @override
  String get themeTitle => 'Тема';

  @override
  String get themeDefault => 'Типова';

  @override
  String get themePixel => 'Піксельна';

  @override
  String get themeMode => 'Світла й темна';

  @override
  String get themeModeSystem => 'Як у системі';

  @override
  String get themeModeLight => 'Світла';

  @override
  String get themeModeDark => 'Темна';

  @override
  String get themeCustom => 'Власна';

  @override
  String get themeDelete => 'Видалити тему';

  @override
  String themeDeleteConfirm(String name) {
    return 'Видалити тему «$name»?';
  }

  @override
  String get themeLowContrast =>
      'Частину тексту в цій темі може бути важко читати';

  @override
  String get themeFootnote =>
      'Теми застосовуються лише до цього пристрою, зокрема до швидкої вставки. На інші пристрої вони не синхронізуються.';

  @override
  String get themeBuiltinGroup => 'Вбудовані';

  @override
  String get themeCustomGroup => 'Власні';

  @override
  String get themeUse => 'Застосувати';

  @override
  String get themeDuplicate => 'Дублювати';

  @override
  String themeCopyName(String name) {
    return '$name (копія)';
  }

  @override
  String get themeExport => 'Експортувати…';

  @override
  String get themeImport => 'Імпортувати тему…';

  @override
  String themeImported(String name) {
    return '«$name» імпортовано';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кольору тексту можуть погано читатися.',
      many: '$count кольорів тексту можуть погано читатися.',
      few: '$count кольори тексту можуть погано читатися.',
      one: '$count колір тексту може погано читатися.',
    );
    return '«$name» імпортовано. $_temp0';
  }

  @override
  String get themeExported => 'Тему експортовано';

  @override
  String get themeCustomEmpty =>
      'Власних тем ще немає. Дублюйте вбудовану тему, імпортуйте тему або попросіть ШІ створити її.';

  @override
  String get themeAskAi => 'Попросити ШІ створити тему';

  @override
  String get themeAskAiBody =>
      'Додайте цей MCP-сервер до програми зі ШІ, як-от Claude чи Cursor, і попросіть тему, наприклад: «Зроби мені тему в стилі кіберпанк». ШІ прочитає формат теми, підбере кольори, перевірить контраст і застосує тему.';

  @override
  String get themeAskAiCopy => 'Копіювати конфігурацію';

  @override
  String get themeAskAiCopied => 'Конфігурацію скопійовано';

  @override
  String get themeScanlines => 'Лінії розгортки';

  @override
  String get themeScanlinesDesc =>
      'Накласти на вікно ледь помітні лінії розгортки CRT. Лише для піксельних тем.';

  @override
  String get themeBackground => 'Фонове зображення';

  @override
  String get themeBackgroundDesc =>
      'Заповнює вікно за бічною панеллю та сторінками. Затемнення згори зберігає текст читабельним.';

  @override
  String get themeBackgroundChoose => 'Вибрати зображення…';

  @override
  String get themeBackgroundChange => 'Змінити…';

  @override
  String get themeBackgroundRemove => 'Вилучити';

  @override
  String get themeBlur => 'Розмиття';

  @override
  String get themeBlurNone => 'Немає';

  @override
  String get themeBlurLight => 'Легке';

  @override
  String get themeBlurStrong => 'Сильне';

  @override
  String get themeScrim => 'Затемнення';

  @override
  String get themeScrimDesc =>
      'Колір, накладений на зображення, щоб текст залишався читабельним. Він ніколи не світліший, ніж потрібно для зображення.';

  @override
  String get themeScrimAuto => 'Авто';

  @override
  String get themeScrimMore => 'Щільніше';

  @override
  String get themeScrimMost => 'Найщільніше';

  @override
  String get themePanels => 'Панелі';

  @override
  String get themePanelsDesc =>
      'Наскільки зображення просвічує крізь бічну панель і списки.';

  @override
  String get themePanelsClear => 'Прозорі';

  @override
  String get themePanelsMedium => 'Середні';

  @override
  String get themePanelsSolid => 'Суцільні';

  @override
  String get themeAccentFromImage => 'Кольори зображення';

  @override
  String get themeAccentFromImageDesc => 'Брати колір акценту із зображення.';

  @override
  String get themeBackgroundPicker => 'Показувати й у швидкій вставці';

  @override
  String get themeScenery => 'Показувати пейзажі';

  @override
  String get themeSceneryDesc =>
      'Малюнки вгорі сторінок і внизу бічної панелі.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Вбудовані теми не можна змінювати, тому створено й застосовано копію «$name»';
  }

  @override
  String get themeBackgroundFootnote =>
      'Фон належить до поточної теми. Вбудовані теми не можна змінювати: перша зміна створює копію. Зображення залишаються на цьому пристрої; підтримуються JPEG, PNG і GIF.';

  @override
  String get themeSceneGroup => 'Пейзажі';

  @override
  String get themeSceneHeader => 'Заголовок сторінки';

  @override
  String get themeSceneHeaderDesc =>
      'Широкий малюнок за заголовками сторінок; його низ плавно переходить у сторінку. Піксельна тема малює тут піксельний пейзаж.';

  @override
  String get themeSceneSidebar => 'Низ бічної панелі';

  @override
  String get themeSceneSidebarDesc =>
      'Невеликий малюнок унизу бічної панелі. Піксельна тема малює тут маленький табір.';

  @override
  String get themeSceneReset => 'Скинути';

  @override
  String get themeSceneFootnote =>
      'Будь-яка тема може показувати тут ваші власні малюнки. Затемнення зберігає заголовок сторінки читабельним. Пейзажі приховуються, коли вікно заповнює фонове зображення.';

  @override
  String get starTitle => 'Як вам PasteFerry?';

  @override
  String get starBody =>
      'Якщо він вам подобається, зірочка на GitHub дуже допоможе.';

  @override
  String get starAction => 'Поставити зірочку на GitHub';

  @override
  String get starLater => 'Пізніше';

  @override
  String get starDismiss => 'Більше не показувати';
}
