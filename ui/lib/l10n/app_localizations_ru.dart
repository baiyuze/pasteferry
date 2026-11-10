// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'История';

  @override
  String get navDevices => 'Устройства';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get linkConnecting => 'Подключение…';

  @override
  String get linkServiceNotRunning => 'Служба не запущена';

  @override
  String get linkLanMode => 'Поиск устройств в этой сети';

  @override
  String get linkServerUnreachable =>
      'Сервер недоступен; синхронизация в этой сети';

  @override
  String get linkNothingOn =>
      'Поиск в локальной сети выключен, сервер не задан';

  @override
  String get linkLanBlocked => 'macOS блокирует локальную сеть';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count устройства в сети',
      many: '$count устройств в сети',
      few: '$count устройства в сети',
      one: '$count устройство в сети',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Подключено к серверу';

  @override
  String linkConnectionLost(String detail) {
    return 'Соединение потеряно: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Служба отключена';

  @override
  String get linkServiceDisabled => 'Фоновая синхронизация выключена';

  @override
  String get errServiceNotConnected => 'Нет связи с фоновой службой';

  @override
  String get errUnimplemented => 'Пока недоступно';

  @override
  String get errUnavailable => 'Фоновая служба недоступна';

  @override
  String errServiceStart(String detail) {
    return 'Не удалось запустить фоновую службу: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Не удалось перезапустить фоновую службу: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Не удалось включить запуск PasteFerry при входе: $detail';
  }

  @override
  String get thisMacTitle => 'Этот Mac';

  @override
  String get thisPcTitle => 'Этот компьютер';

  @override
  String get thisMacInText => 'этот Mac';

  @override
  String get thisPcInText => 'этот компьютер';

  @override
  String get bothMacs => 'оба Mac';

  @override
  String get bothDevices => 'оба устройства';

  @override
  String get thisDeviceShort => 'Это устройство';

  @override
  String fromDevice(String name) {
    return 'С устройства $name';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get save => 'Сохранить';

  @override
  String get retry => 'Повторить';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get justNow => 'Только что';

  @override
  String secondsAgo(int n) {
    return '$n с назад';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n минуты назад',
      many: '$n минут назад',
      few: '$n минуты назад',
      one: '$n минуту назад',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n часа назад',
      many: '$n часов назад',
      few: '$n часа назад',
      one: '$n час назад',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дня назад',
      many: '$n дней назад',
      few: '$n дня назад',
      one: '$n день назад',
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
      other: '$n часа',
      many: '$n часов',
      few: '$n часа',
      one: '$n час',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дня',
      many: '$n дней',
      few: '$n дня',
      one: '$n день',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Скопируйте что-нибудь на любом устройстве — и оно появится здесь';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0, срок хранения: $ttl';
  }

  @override
  String get filterAll => 'Все';

  @override
  String get filterText => 'Текст';

  @override
  String get filterImage => 'Изображения';

  @override
  String get filterFile => 'Файлы';

  @override
  String get filterLink => 'Ссылки';

  @override
  String get historyClearTooltip => 'Очистить историю';

  @override
  String get historyEmptyTitle => 'Пока пусто';

  @override
  String get historyEmptyFilteredTitle => 'Записей этого типа нет';

  @override
  String get historyEmptyBody =>
      'Скопируйте текст, изображение или файл на любом сопряжённом устройстве — и запись появится здесь.';

  @override
  String get clearConfirmTitle => 'Очистить всю историю?';

  @override
  String clearConfirmBody(String device) {
    return 'История, синхронизированная с ваших устройств, и кэшированные файлы, которые хранит $device, будут удалены. Исходные файлы не затрагиваются.';
  }

  @override
  String get clear => 'Очистить';

  @override
  String get historyCleared => 'История очищена';

  @override
  String get permDeniedTitle => 'PasteFerry не может читать буфер обмена';

  @override
  String get permAskTitle => 'Разрешите PasteFerry читать буфер обмена';

  @override
  String get permDeniedBody =>
      'То, что вы копируете на этом Mac, не будет синхронизироваться. В Системных настройках выберите для PasteFerry Daemon значение «Разрешить».';

  @override
  String get permAskBody =>
      'Иначе macOS будет спрашивать каждый раз. В Системных настройках выберите для PasteFerry Daemon значение «Разрешить».';

  @override
  String get openSystemSettings => 'Открыть Системные настройки';

  @override
  String get fetch => 'Получить';

  @override
  String get fetchStarted => 'Получение… Ход — в разделе «История»';

  @override
  String get transferFailed => 'Ошибка передачи';

  @override
  String get expired => 'Срок истёк';

  @override
  String get putOnClipboard => 'Копировать';

  @override
  String get putOnClipboardDone => 'В буфере обмена';

  @override
  String get deleteRecord => 'Удалить запись';

  @override
  String get deleted => 'Удалено';

  @override
  String get emptyRecord => '(пусто)';

  @override
  String get imageRecord => 'Изображение';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name и ещё $others';
  }

  @override
  String get searchHint => 'Поиск по тексту и именам файлов';

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String searchResultCount(int count) {
    return 'Найдено: $count';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'По запросу «$query» ничего не найдено';
  }

  @override
  String get searchEmptyBody =>
      'Поиск идёт по скопированному тексту и именам скопированных файлов.';

  @override
  String get favoriteAction => 'Добавить в избранное';

  @override
  String get unfavoriteAction => 'Убрать из избранного';

  @override
  String get favoritedToast => 'Добавлено в избранное';

  @override
  String get unfavoritedToast => 'Возвращено в историю';

  @override
  String get undo => 'Отменить';

  @override
  String get favoriteSaving => 'Сохранение…';

  @override
  String favoritedAt(String date) {
    return 'Сохранено $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0 · без автоочистки · до $size';
  }

  @override
  String get favoritesEmptyTitle => 'В избранном пока пусто';

  @override
  String get favoritesEmptyBody =>
      'Отметьте запись в истории звёздочкой, чтобы сохранить здесь её копию. Избранное не очищается автоматически.';

  @override
  String get favoritesSearchHint => 'Поиск в избранном';

  @override
  String favoriteLargeTitle(String size) {
    return 'Сохранить копию размером $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'В избранном хранится отдельная копия, поэтому изменение или удаление исходных файлов на неё не повлияет. Копию сохранит $device, она займёт $size.';
  }

  @override
  String get saveCopy => 'Сохранить копию';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи в избранном сохранятся.',
      many: '$count записей в избранном сохранятся.',
      few: '$count записи в избранном сохранятся.',
      one: '$count запись в избранном сохранится.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Избранное';

  @override
  String get favoritesUsageDesc =>
      'Избранное не очищается автоматически, независимо от настроек выше';

  @override
  String upToSize(String size) {
    return 'До $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count символа',
      many: '$count символов',
      few: '$count символа',
      one: '$count символ',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count символа',
      many: '$count символов',
      few: '$count символа',
      one: '$count символ',
    );
    return '… всего $_temp0';
  }

  @override
  String detailMoreFiles(int count) {
    return 'Ещё $count';
  }

  @override
  String get detailReceiveFirst => 'Выберите, чтобы сначала загрузить';

  @override
  String detailTotalSize(String size) {
    return 'Всего $size';
  }

  @override
  String get quickPaste => 'Быстрая вставка';

  @override
  String get quickPasteWindow => 'Окно быстрой вставки';

  @override
  String get quickPasteWindowDesc =>
      'Нажмите сочетание клавиш в любой программе, чтобы открыть историю; выберите запись — и она вставится';

  @override
  String get quickPasteShortcut => 'Сочетание клавиш';

  @override
  String get quickPasteRecord => 'Нажмите, чтобы изменить';

  @override
  String get quickPasteRecording => 'Нажмите новое сочетание…';

  @override
  String get quickPasteUseDefault => 'По умолчанию';

  @override
  String get quickPasteNeedsModifier =>
      'Добавьте ⌃, ⌥, ⇧ или ⌘ либо используйте функциональную клавишу';

  @override
  String get quickPasteNeedsModifierPc =>
      'Добавьте Ctrl, Alt, Shift или клавишу Windows либо используйте функциональную клавишу';

  @override
  String get quickPasteAfterPick => 'После выбора записи';

  @override
  String get quickPastePasteIt => 'Вставить';

  @override
  String get quickPasteCopyIt => 'Только скопировать';

  @override
  String get quickPasteIndexKey => 'Выбор одной из первых 9';

  @override
  String get quickPasteIndexKeyDesc =>
      'В окне быстрой вставки удерживайте эту клавишу и нажмите 1–9';

  @override
  String get quickPasteAccessibility => 'Универсальный доступ';

  @override
  String get quickPasteAccessibilityDesc =>
      'Нужен, чтобы вставлять за вас. Без него записи только копируются, а вставлять нужно с помощью ⌘V.';

  @override
  String get quickPasteAllowed => 'Разрешено';

  @override
  String get quickPasteAllow => 'Разрешить…';

  @override
  String get quickPasteNotRunning => 'Окно быстрой вставки не запущено';

  @override
  String quickPasteInUse(String key) {
    return '$key уже используется другой программой. Выберите другое сочетание.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Не удалось назначить $key: $detail';
  }

  @override
  String get quickPastePortalKey =>
      'Задаётся в системных настройках сочетаний клавиш';

  @override
  String get quickPasteWaylandDesc =>
      'В Wayland добавьте сочетание в настройках клавиатуры вашей среды рабочего стола. Выбранные записи копируются; нажмите Ctrl+V, чтобы вставить.';

  @override
  String get quickPasteAddShortcut => 'Добавить системное сочетание';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Добавлено. Нажмите $key, чтобы проверить.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Добавьте в настройках клавиатуры вашей среды рабочего стола своё сочетание клавиш с командой: $command';
  }

  @override
  String get pickerSearch => 'Поиск';

  @override
  String get pickerPaste => 'Вставить';

  @override
  String get pickerPlainText => 'Простой текст';

  @override
  String get pickerCopyOnly => 'Только копировать';

  @override
  String get pickerUnfavoriteHint => 'Убрать (вернуть в историю)';

  @override
  String pickerPasteManually(String key) {
    return 'Выбранное копируется — нажмите $key, чтобы вставить';
  }

  @override
  String get pickerGrantHint =>
      'Разрешите универсальный доступ, чтобы вставлять сразу';

  @override
  String pickerElevated(String key) {
    return 'Окно запущено от имени администратора — после выбора нажмите $key, чтобы вставить';
  }

  @override
  String get pickerDownloading => 'Загрузка — вставится по завершении';

  @override
  String get imagePreviewTitle => 'Просмотр изображения';

  @override
  String get closePreview => 'Закрыть просмотр';

  @override
  String get previousImage => 'Предыдущее изображение';

  @override
  String get nextImage => 'Следующее изображение';

  @override
  String get previewHint =>
      'Прокрутка или щипок — масштаб, перетаскивание — перемещение';

  @override
  String get fitWindow => 'По размеру окна';

  @override
  String get previewDeleted => 'Это изображение удалено из истории';

  @override
  String get previewExpired =>
      'Срок хранения изображения истёк, просмотр недоступен';

  @override
  String get previewDownloading => 'Загрузка изображения…';

  @override
  String get previewDownloadFailed =>
      'Не удалось загрузить. Повторите попытку.';

  @override
  String get previewNotDownloaded =>
      'Изображение ещё не загружено на этот компьютер';

  @override
  String get downloadAndPreview => 'Загрузить и посмотреть';

  @override
  String get previewUnavailable => 'Сейчас просмотр изображения недоступен';

  @override
  String get imageSemantic => 'Изображение из истории';

  @override
  String get previewUnreadable =>
      'Не удалось прочитать изображение. Возможно, файл удалён при очистке или повреждён.';

  @override
  String get devicesSubtitleEmpty =>
      'После сопряжения у ваших устройств будет общий буфер обмена';

  @override
  String devicesSubtitle(int paired, int online) {
    return 'Сопряжено: $paired, в сети: $online';
  }

  @override
  String get addDevice => 'Добавить устройство';

  @override
  String thisDeviceFootnote(String both) {
    return 'При сопряжении $both показывают одни и те же две строки отпечатков безопасности — по одной на каждое устройство. Подтверждайте, только если они совпадают до последнего символа.';
  }

  @override
  String get noDevicesTitle => 'Нет сопряжённых устройств';

  @override
  String get noDevicesBody =>
      'Откройте PasteFerry на другом компьютере и свяжите их кодом сопряжения из 6 символов. Если компьютеры в одной сети, можно также открыть «Поиск рядом» на обоих и нажать на другой.';

  @override
  String get pairedDevices => 'Сопряжённые устройства';

  @override
  String get pairedFootnote =>
      'Напрямую: данные передаются между двумя устройствами без посредников. Ретрансляция: если сеть не пропускает прямое соединение, данные идут через ваш сервер и остаются под сквозным шифрованием.';

  @override
  String get offline => 'Не в сети';

  @override
  String get direct => 'Напрямую';

  @override
  String get relay => 'Ретрансляция';

  @override
  String get online => 'В сети';

  @override
  String get moreActions => 'Ещё';

  @override
  String get copyFingerprint => 'Скопировать отпечаток';

  @override
  String get unpairEllipsis => 'Отменить сопряжение…';

  @override
  String get fingerprintCopied => 'Отпечаток скопирован';

  @override
  String unpairTitle(String name) {
    return 'Отменить сопряжение с «$name»?';
  }

  @override
  String get unpairBody =>
      'Устройства перестанут синхронизироваться. Чтобы снова их синхронизировать, нужно будет заново выполнить сопряжение и сверить отпечатки.';

  @override
  String get unpair => 'Отменить сопряжение';

  @override
  String get unpaired => 'Сопряжение отменено';

  @override
  String get enterAddressEllipsis => 'Ввести его адрес…';

  @override
  String setAddressTitle(String name) {
    return 'Адрес «$name»';
  }

  @override
  String setAddressBody(String name) {
    return 'Используйте, если устройства в разных подсетях или оба сменили адреса. Введите адрес, который показан на «$name» в разделе «Добавить устройство → Показать код».';
  }

  @override
  String get addressSaved => 'Ищем устройство по этому адресу';

  @override
  String get lanBlockedTitle => 'macOS блокирует локальную сеть';

  @override
  String lanBlockedBody(String device) {
    return 'Включите PasteFerry Daemon в разделе «Системные настройки → Конфиденциальность и безопасность → Локальная сеть». Пока доступ не открыт, $device не сможет подключаться к устройствам в этой сети.';
  }

  @override
  String get searchNearby => 'Поиск рядом';

  @override
  String get nearbyTitle => 'Устройства рядом';

  @override
  String get nearbySearching => 'Поиск устройств рядом…';

  @override
  String get nearbyHint =>
      'Откройте «Поиск рядом» и на другом компьютере — он появится здесь. Нажмите на него, чтобы выполнить сопряжение.';

  @override
  String nearbyVisible(String device) {
    return 'Пока это окно открыто, $device показывает своё имя устройствам в этой сети.';
  }

  @override
  String get nearbyPaired => 'Сопряжено';

  @override
  String nearbyRequesting(String name) {
    return 'Связь с «$name»…';
  }

  @override
  String nearbyNoReply(String name) {
    return '«$name» не отвечает. Убедитесь, что на нём всё ещё открыт «Поиск рядом».';
  }

  @override
  String get nearbyLanOffTitle => 'Поиск в локальной сети выключен';

  @override
  String get nearbyLanOffBody =>
      'Включите «Искать устройства в этой сети» в разделе «Настройки → Подключение», чтобы видеть устройства рядом, или используйте код сопряжения.';

  @override
  String get generateCode => 'Показать код';

  @override
  String get enterCode => 'Ввести код';

  @override
  String get codeFailedTitle => 'Не удалось создать код сопряжения';

  @override
  String get enterOnOther => 'Введите этот код на другом устройстве';

  @override
  String get codeCopied => 'Код скопирован';

  @override
  String get codeHint => 'Нажмите, чтобы скопировать. Действует 5 минут.';

  @override
  String afterEnterFootnote(String both) {
    return 'После ввода кода $both покажут одни и те же две строки отпечатков безопасности. Подтверждайте, только если они совпадают.';
  }

  @override
  String get codeInvalid => 'Код сопряжения — 6 букв или цифр';

  @override
  String get localAddress => 'Адрес';

  @override
  String get addressHint =>
      'Устройство в другой подсети? Введите этот адрес и на нём.';

  @override
  String get addressCopied => 'Адрес скопирован';

  @override
  String get differentSubnet => 'В другой подсети?';

  @override
  String get peerAddress => 'Адрес под кодом';

  @override
  String get pairNotFound =>
      'Устройство не найдено. Если оно в другой подсети, введите адрес, показанный под его кодом.';

  @override
  String get pairNotFoundAddress =>
      'По этому адресу никто не отвечает. Проверьте адрес и убедитесь, что другое устройство всё ещё показывает код. Соединение также может блокировать брандмауэр на том устройстве.';

  @override
  String get codeWrong => 'Неверный код, или срок его действия истёк';

  @override
  String get codeExpired =>
      'Срок действия кода истёк. Покажите новый код на другом устройстве.';

  @override
  String get addressInvalid =>
      'Недопустимый адрес. Введите адрес вида 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Сначала включите поиск в локальной сети или укажите сервер в разделе «Настройки → Подключение».';

  @override
  String get enterCodeShown => 'Введите код, показанный на другом устройстве';

  @override
  String get pairingDone => 'Сопряжение выполнено';

  @override
  String get pairingRejected => 'Сопряжение отклонено';

  @override
  String get verifyTitle => 'Сверьте отпечатки безопасности';

  @override
  String pairingWith(String name) {
    return 'Сопряжение с «$name»';
  }

  @override
  String verifyBody(String both) {
    return 'Две строки, которые показывают $both, должны полностью совпадать. Если отличается хоть один символ, кто-то может вмешиваться в соединение — отклоните запрос.';
  }

  @override
  String get rejectMismatch => 'Не совпадают, отклонить';

  @override
  String get confirmMatch => 'Совпадают, подтвердить';

  @override
  String get server => 'Сервер (необязательно)';

  @override
  String get signalingUrl => 'Сигнальный сервер';

  @override
  String get signalingUrlDesc =>
      'Оставьте пустым, чтобы синхронизировать только в локальной сети';

  @override
  String get signalingUrlPlaceholder => 'ws://адрес-сервера:8787/signal';

  @override
  String get publicStun => 'Улучшить прямые соединения';

  @override
  String get publicStunDesc => 'Публичные серверы видят ваш внешний IP-адрес';

  @override
  String get connectionStatus => 'Подключение';

  @override
  String get disconnectedDesc => 'Проверьте адрес сервера и его доступность';

  @override
  String get connected => 'Подключено';

  @override
  String get notConnected => 'Не подключено';

  @override
  String get notSet => 'Не задан';

  @override
  String get serverCleared =>
      'Сервер удалён. Синхронизация только в этой сети.';

  @override
  String get localNetwork => 'Локальная сеть';

  @override
  String get lanDiscovery => 'Искать устройства в этой сети';

  @override
  String get lanDiscoveryDesc =>
      'Анонимный поиск; имена видны только во время «Поиска рядом»';

  @override
  String get macLocalNetwork => 'Доступ к локальной сети';

  @override
  String get macLocalNetworkDesc =>
      'Разрешите PasteFerry Daemon в Системных настройках';

  @override
  String get allowLan => 'Брандмауэр Windows';

  @override
  String get allowLanDesc =>
      'Разрешить заблокированные подключения; нужны права администратора';

  @override
  String get allow => 'Разрешить';

  @override
  String get allowLanDone =>
      'Разрешено. Теперь другие устройства могут подключаться к этому.';

  @override
  String get deviceName => 'Имя устройства';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get sync => 'Синхронизация';

  @override
  String get autoSyncLimit => 'Лимит автосинхронизации';

  @override
  String get autoSyncLimitDesc => 'Записи крупнее получайте вручную в истории';

  @override
  String get autoApply => 'Копировать полученное в буфер обмена';

  @override
  String get whatToSync => 'Что синхронизировать';

  @override
  String get syncFiles => 'Файлы и папки';

  @override
  String get syncText => 'Простой текст';

  @override
  String get syncRich => 'Форматированный текст';

  @override
  String get syncImages => 'Изображения и снимки экрана';

  @override
  String get storage => 'Хранилище';

  @override
  String get storageFootnote =>
      'Устаревшая история и кэшированные файлы удаляются автоматически.';

  @override
  String get keepHistory => 'Хранить историю';

  @override
  String get keepCache => 'Хранить кэш файлов';

  @override
  String get keepCacheDesc => 'Не дольше срока хранения истории';

  @override
  String get cacheUsage => 'Размер кэша';

  @override
  String get backgroundSync => 'Фоновая синхронизация';

  @override
  String get backgroundService => 'Фоновая служба';

  @override
  String get backgroundServiceDesc =>
      'Запускается при входе; синхронизирует и при закрытом окне';

  @override
  String get restart => 'Перезапустить';

  @override
  String get restarted => 'Фоновая служба перезапущена';

  @override
  String get disableEllipsis => 'Выключить…';

  @override
  String get about => 'О программе';

  @override
  String get aboutDesc => 'Открытый код по лицензии AGPL-3.0';

  @override
  String get homepage => 'Сайт';

  @override
  String get feedback => 'Сообщить о проблеме';

  @override
  String get disableTitle => 'Выключить фоновую синхронизацию?';

  @override
  String disableBody(String device) {
    return 'PasteFerry перестанет синхронизировать, и $device больше не будет запускать его при входе. История и сопряжения сохранятся.';
  }

  @override
  String get disable => 'Выключить';

  @override
  String get disabled => 'Фоновая синхронизация выключена';

  @override
  String get urlMustBeWs => 'Адрес должен начинаться с ws:// или wss://';

  @override
  String get serverUpdated => 'Сервер изменён. Переподключение…';

  @override
  String get deviceNameUpdated => 'Имя устройства изменено';

  @override
  String get diagIntro =>
      'В отчёте есть версия приложения, сведения о системе, настройки, устройства и недавние журналы. Имена устройств, адрес сервера, внешние IP-адреса, папка пользователя и имена файлов заменены, а скопированное никогда не попадает в журналы. Обращения на GitHub публичны, поэтому прочитайте отчёт перед публикацией.';

  @override
  String get diagVerboseTitle => 'Подробный журнал';

  @override
  String get diagVerboseDesc =>
      'При проблемах с подключением включите его, воспроизведите проблему и вернитесь за отчётом. Через 30 минут он выключится сам.';

  @override
  String get diagVerboseOn => 'Включить на 30 минут';

  @override
  String diagVerboseUntil(String time) {
    return 'Включено до $time';
  }

  @override
  String get diagVerboseOff => 'Выключить';

  @override
  String get diagRefresh => 'Создать заново';

  @override
  String get diagSave => 'Сохранить в файл';

  @override
  String diagSaved(String name) {
    return 'Сохранено в папку «Загрузки»: $name';
  }

  @override
  String get diagCopy => 'Скопировать отчёт';

  @override
  String get diagCopied => 'Отчёт скопирован';

  @override
  String get diagNewIssue => 'Новое обращение на GitHub';

  @override
  String get diagIssueHint =>
      'Отчёт скопирован. Вставьте его в поле «Diagnostics report» обращения.';

  @override
  String diagFailed(String detail) {
    return 'Не удалось создать отчёт: $detail';
  }

  @override
  String get svcExtractTitle => 'Сначала установите или распакуйте PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry запущен прямо из ZIP-архива, и его временная папка исчезнет после закрытия. Чтобы включить фоновую синхронизацию, запустите установщик или распакуйте всю папку и откройте PasteFerry оттуда.';

  @override
  String get svcMoveTitle => 'Сначала переместите PasteFerry в «Программы»';

  @override
  String get svcMoveBody =>
      'PasteFerry запущен прямо с образа диска. Чтобы включить фоновую синхронизацию, перетащите его в папку «Программы», извлеките образ диска и откройте PasteFerry из «Программ».';

  @override
  String get svcStartTitle => 'Начало работы с PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry синхронизирует буфер обмена с помощью небольшого фонового процесса. Он продолжает работать и после закрытия окна. Запуск при входе настраивается отдельно и в новых установках выключен.';

  @override
  String get svcEnable => 'Включить фоновую синхронизацию';

  @override
  String get svcStaleTitle => 'Снова включите фоновую синхронизацию';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry перемещён, но автозапуск при входе всё ещё указывает на старое место. Включите синхронизацию снова, чтобы фоновый процесс использовал эту копию. История и сопряжения сохранятся.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry перемещён или был установлен старым скриптом. Включите синхронизацию снова, чтобы фоновый процесс использовал это приложение. История и сопряжения сохранятся.';

  @override
  String get svcReenable => 'Включить снова';

  @override
  String get svcStoppedTitle => 'Фоновая служба не запущена';

  @override
  String get svcStoppedBody =>
      'Фоновая служба остановлена. Запустите её кнопкой ниже; запуск при входе настраивается отдельно в настройках.';

  @override
  String get svcDevBodyWin =>
      'Это сборка для разработки, рядом с ней нет pasteferryd.exe. Чтобы собрать полную версию, выполните scripts\\build-windows.ps1 в папке с исходным кодом.';

  @override
  String get svcDevBodyLinux =>
      'Это сборка для разработки, рядом с ней нет pasteferryd. Чтобы собрать полную версию, выполните ./scripts/package-linux.sh в папке с исходным кодом.';

  @override
  String get svcDevBodyMac =>
      'Это сборка для разработки без фоновой службы. Чтобы установить службу, выполните ./scripts/install-macos.sh в папке с исходным кодом.';

  @override
  String svcLogPath(String path) {
    return 'Журнал: $path';
  }

  @override
  String get svcCanDisable =>
      'Фоновую синхронизацию можно выключить в настройках в любой момент.';

  @override
  String get officialService => 'Сервис';

  @override
  String get useOfficialService => 'Использовать сервис';

  @override
  String get officialServiceDesc =>
      'Синхронизация между сетями, сначала напрямую';

  @override
  String get officialPrivacy =>
      'Подключается к сервису только после включения и записывает лишь необходимые сведения о подключении. Сначала пробуется прямое соединение; ретрансляция запрашивается, только если оно не удалось. Содержимое, настоящие имена устройств и исходные системные идентификаторы не передаются.';

  @override
  String get officialEnableTitle => 'Включить сервис?';

  @override
  String get officialSwitchConfirm =>
      'Вместо вашего сервера будет использоваться официальный. Сохранённый адрес вашего сервера останется.';

  @override
  String get customServer => 'Свой сервер';

  @override
  String get saveAndConnect => 'Сохранить и подключить';

  @override
  String get officialLoading => 'Проверка лимита…';

  @override
  String get officialFetchFailed =>
      'Сейчас не удаётся получить лимит. Попытка будет повторена автоматически.';

  @override
  String get officialUnavailable =>
      'Данные о расходе недоступны; имеющиеся сведения могут быть устаревшими';

  @override
  String get officialQuotaTitle => 'Дневной лимит ретрансляции исчерпан';

  @override
  String get officialQuotaBody =>
      'Ретрансляция через сервис приостановлена до ежедневного сброса в полночь по пекинскому времени. Локальная сеть и прямые интернет-соединения работают. Неудавшиеся передачи можно повторить позже.';

  @override
  String get officialPeerQuota =>
      'У другого устройства закончился лимит ретрансляции. Прямые соединения работают.';

  @override
  String get officialPaused =>
      'Ретрансляция через сервис недоступна. Прямые соединения работают.';

  @override
  String get officialViewUsage => 'Показать расход';

  @override
  String get officialAcknowledge => 'Понятно';

  @override
  String get officialToday => 'Лимит ретрансляции на сегодня';

  @override
  String get officialUsed => 'Использовано';

  @override
  String get officialRemaining => 'Осталось';

  @override
  String get officialDailyLimit => 'Дневной лимит';

  @override
  String get officialUpload => 'Отправка';

  @override
  String get officialDownload => 'Загрузка';

  @override
  String get officialReset => 'Сброс (по Пекину)';

  @override
  String get officialUpdated => 'Обновлено';

  @override
  String get officialRoutes => 'Как подключаются устройства';

  @override
  String get officialRoutesFootnote =>
      'Прямые соединения не проходят через ретрансляцию сервиса и не расходуют лимит.';

  @override
  String get officialDeviceID => 'ID устройства';

  @override
  String get officialWarning =>
      'Использовано 90 % дневного лимита ретрансляции. Прямые соединения его не расходуют.';

  @override
  String get updateCheck => 'Проверить обновления';

  @override
  String get updateCheckEllipsis => 'Проверить обновления…';

  @override
  String get updateAuto => 'Проверять обновления автоматически';

  @override
  String get updateChecking => 'Проверка обновлений…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version — последняя версия.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'Доступен PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'У вас версия $current. Размер загрузки: $size.';
  }

  @override
  String get updateNew => 'Новое';

  @override
  String get updateFixed => 'Исправлено';

  @override
  String get updateSkip => 'Пропустить эту версию';

  @override
  String get updateLater => 'Позже';

  @override
  String get updateInstall => 'Загрузить и установить';

  @override
  String updateDownloading(String done, String total) {
    return 'Загрузка: $done из $total';
  }

  @override
  String get updateVerifying => 'Проверка загрузки…';

  @override
  String get updateInstalling =>
      'Установка. PasteFerry откроется снова автоматически.';

  @override
  String get updateInstallingPassword =>
      'Установка. Система запросит пароль, так как для /opt нужны права администратора; затем PasteFerry откроется снова автоматически.';

  @override
  String get updateCheckFailed =>
      'Не удалось связаться с GitHub или Gitee. Повторите попытку позже.';

  @override
  String get updateDownloadFailed =>
      'Загрузка не завершена. Повторите попытку или скачайте новую версию с сайта.';

  @override
  String updateInstallFailed(String error) {
    return 'Не удалось начать установку: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Эта сборка не может проверять обновления.';

  @override
  String get updateBlockedDev =>
      'Это сборка для разработки, она не может обновляться сама.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry запущен с образа диска. Перетащите его в «Программы» и откройте оттуда, чтобы он обновлялся автоматически.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry не может записывать в папку, где он установлен. Скачайте новую версию с сайта.';

  @override
  String get updateBlockedUnsupported =>
      'Для этого компьютера нет автоматического обновления. Скачайте новую версию с сайта.';

  @override
  String get updateOpenDownload => 'Открыть страницу загрузки';

  @override
  String updateSidebar(String version) {
    return 'Доступна версия $version';
  }

  @override
  String updatedTo(String version) {
    return 'Обновлено до $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Обновление не завершено. У вас по-прежнему версия $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Обновление не завершено. У вас по-прежнему версия $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Интерфейс $uiVersion · Служба $serviceVersion · Сборка $build';
  }

  @override
  String get notReceived => 'Не получено — получите перед вставкой';

  @override
  String get receivedPreserved =>
      'Получено; нажмите «Скопировать в буфер», когда будете готовы';

  @override
  String get clipboardWriteFailed =>
      'Получено, но обновить буфер обмена не удалось';

  @override
  String get receivingStatus => 'Получение…';

  @override
  String get largeFileNotifications => 'Напоминания о больших файлах';

  @override
  String get notificationsAllowed =>
      'Уведомления включены. Ход получения виден в истории.';

  @override
  String get notificationsNotRequested =>
      'Включите уведомления, чтобы большие файлы не ждали незаметно. Получить их всегда можно и в истории.';

  @override
  String get notificationsDenied =>
      'Уведомления запрещены в системных настройках. Получайте ожидающие записи в истории.';

  @override
  String get notificationsUnknown =>
      'Показ уведомлений и режим «Не беспокоить» настраиваются в системе. Если напоминание не появилось, получите запись в истории.';

  @override
  String get notificationsUnavailable =>
      'Системные уведомления недоступны. Получайте большие файлы в истории.';

  @override
  String get enableNotifications => 'Включить напоминания';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get notifyPendingTitle => 'Получите, чтобы вставить';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nПолучите эту запись перед вставкой. Это можно сделать и в истории.';
  }

  @override
  String get notifyReceivingTitle => 'Получение…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nХод получения — в истории.';
  }

  @override
  String get notifyReadyTitle => 'Можно вставлять';

  @override
  String notifyReadyBody(String name) {
    return '$name\nПолучено и скопировано в буфер обмена.';
  }

  @override
  String get notifyReceivedTitle => 'Получено';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nБуфер обмена не изменён. Нажмите «Скопировать в буфер», когда будете готовы; это можно сделать и в истории.';
  }

  @override
  String get notifyFailedTitle => 'Не удалось получить';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nПовторите попытку из этого уведомления или из истории.';
  }

  @override
  String get notifyClipboardFailedTitle => 'Получено; буфер обмена не обновлён';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nНажмите «Скопировать в буфер», чтобы повторить, здесь или в истории.';
  }

  @override
  String get reconnect => 'Переподключить';

  @override
  String get reconnecting => 'Подключение…';

  @override
  String get reconnectDirect => 'Подключено напрямую';

  @override
  String get reconnectRelay =>
      'Не удалось подключиться напрямую, по-прежнему через ретрансляцию';

  @override
  String reconnectOffline(String name) {
    return '«$name» не в сети. Убедитесь, что на нём открыт PasteFerry.';
  }

  @override
  String get reconnectPending => 'Подключение ещё идёт, проверьте чуть позже';

  @override
  String get renameAction => 'Переименовать';

  @override
  String get renameFavoriteTitle => 'Переименовать запись';

  @override
  String get renameFavoriteHint =>
      'Это имя показывается в избранном и в быстрой вставке, по нему можно искать. Оставьте поле пустым, чтобы снова показывать содержимое.';

  @override
  String get renamedToast => 'Переименовано';

  @override
  String get aliasClearedToast => 'Снова показывается содержимое';

  @override
  String get navSend => 'Отправка файлов';

  @override
  String get sendSubtitle =>
      'Перетащите файлы на устройство, чтобы отправить их напрямую';

  @override
  String get sendNoDevicesTitle => 'Нет сопряжённых устройств';

  @override
  String get sendNoDevicesBody =>
      'Сначала выполните сопряжение с другим компьютером, затем отправляйте ему файлы здесь.';

  @override
  String get sendDropHint => 'Перетащите на устройство, чтобы отправить';

  @override
  String sendReleaseTo(String name) {
    return 'Отпустите, чтобы отправить на $name';
  }

  @override
  String get sendLan => 'Локальная сеть';

  @override
  String sendRelayLeft(String left) {
    return 'Ретрансляция · сегодня осталось $left';
  }

  @override
  String get sendNeedsUpdate => 'Нужно обновление';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name сможет получать файлы после обновления до PasteFerry 2.5 или новее.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Подключение к $name. Отправить можно будет после подключения.';
  }

  @override
  String get sendNotReceiving => 'Не принимает файлы';

  @override
  String get sendDelivered => 'Доставлено';

  @override
  String sendToTitle(String name) {
    return 'Отправить на $name';
  }

  @override
  String get sendDropHere => 'Перетащите сюда файлы или папки';

  @override
  String get sendDropStarts => 'Отправка начнётся сразу, как вы их отпустите';

  @override
  String get sendChooseFiles => 'Выбрать файлы…';

  @override
  String get sendChooseFolder => 'Выбрать папку…';

  @override
  String get sendDropMore => 'Перетащите ещё файлы — они отправятся следом';

  @override
  String sendSavedWhere(String name) {
    return 'Файлы сохраняются туда, куда настроит $name, — по умолчанию в папку «Загрузки».';
  }

  @override
  String get sendCloseKeeps => 'Закрытие окна не останавливает отправку';

  @override
  String get sendRemoveQueued => 'Убрать';

  @override
  String get sendCannotDrop =>
      'Этот объект нельзя отправить перетаскиванием. Сначала сохраните его в файл или нажмите «Выбрать файлы…».';

  @override
  String sendErrOffline(String name) {
    return '$name не в сети.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name не принимает файлы.';
  }

  @override
  String get sendErrMissing => 'Некоторых из этих файлов больше нет.';

  @override
  String get relayConfirmTitle => 'Отправить через ретрансляцию сервиса?';

  @override
  String relayConfirmBody(String name, String left) {
    return 'Сейчас у $name нет прямого соединения с этим компьютером, поэтому файлы пойдут через ретрансляцию сервиса со скоростью около 0,25 МБ/с. Сегодняшнего лимита ретрансляции осталось: $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Эти файлы ($size) больше оставшегося лимита. Когда лимит закончится, отправка приостановится и продолжится, как только компьютеры соединятся напрямую или завтра лимит обновится.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Будет израсходовано около $size сегодняшнего лимита.';
  }

  @override
  String get relayExhausted =>
      'Сегодняшний лимит ретрансляции исчерпан. Он обновится в полночь по пекинскому времени. Для компьютеров, соединённых напрямую, ограничений нет.';

  @override
  String get relayDontAskToday =>
      'Сегодня больше не спрашивать для этого устройства';

  @override
  String get relaySendAnyway => 'Всё равно отправить';

  @override
  String get relayOwnServer =>
      'Через ретрансляцию — скорость зависит от вашего сервера';

  @override
  String get transfersReceived => 'Полученные';

  @override
  String get transfersSent => 'Отправленные';

  @override
  String get transfersClearAll => 'Очистить всё';

  @override
  String get transfersClearTitle => 'Очистить этот список?';

  @override
  String get transfersClearBody =>
      'Очищается только список. Файлы остаются на месте.';

  @override
  String get transfersEmptyReceived =>
      'Здесь появятся файлы, которые вам отправят другие устройства';

  @override
  String get transfersEmptySent => 'Здесь появятся файлы, которые вы отправите';

  @override
  String transferFrom(String name) {
    return 'От: $name';
  }

  @override
  String transferTo(String name) {
    return 'Кому: $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name и ещё $others';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файла',
      many: '$count файлов',
      few: '$count файла',
      one: '$count файл',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'В очереди';

  @override
  String transferScanning(String count) {
    return 'Подсчёт… найдено файлов: $count';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Ожидание $name…';
  }

  @override
  String get transferSending => 'Отправка';

  @override
  String get transferReceiving => 'Получение';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Сейчас: $file ($index из $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Осталось: $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n секунды',
      many: '$n секунд',
      few: '$n секунды',
      one: '$n секунда',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n минуты',
      many: '$n минут',
      few: '$n минуты',
      one: '$n минута',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h ч $m мин';
  }

  @override
  String get transferPaused => 'Пауза: сегодняшний лимит ретрансляции исчерпан';

  @override
  String get transferInterrupted =>
      'Прервано — продолжится после переподключения';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Прервано — ждём, когда $name продолжит';
  }

  @override
  String get transferCancelled => 'Отменено';

  @override
  String transferPeerCancelled(String name) {
    return '$name: отменено';
  }

  @override
  String get transferExpired => 'Срок истёк';

  @override
  String get transferMissing => 'Перемещено или удалено';

  @override
  String transferNotSent(String reason) {
    return 'Не отправлено: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Не получено: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return 'у $name недостаточно места на диске (не хватает $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'недостаточно места на диске (не хватает $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'папка для сохранения на $name недоступна';
  }

  @override
  String get reasonDestUnavailable =>
      'папка для сохранения недоступна — проверьте её в настройках';

  @override
  String get reasonFileTooLarge =>
      'папка для сохранения находится на диске FAT32, который не вмещает файлы больше 4 ГБ';

  @override
  String reasonDisabledPeer(String name) {
    return '$name не принимает файлы';
  }

  @override
  String get reasonSourceChanged => 'файл изменился во время отправки';

  @override
  String get reasonSourceMissing => 'файла больше нет';

  @override
  String get reasonReadError => 'не удалось прочитать файл';

  @override
  String get reasonWriteFailed => 'не удалось записать файлы';

  @override
  String get reasonHashMismatch => 'файл повреждён при передаче';

  @override
  String reasonUnsupported(String name) {
    return '$name нужно обновиться, чтобы получать файлы';
  }

  @override
  String get reasonOther => 'что-то пошло не так';

  @override
  String get revealInFinder => 'Показать в Finder';

  @override
  String get revealInFolder => 'Показать в папке';

  @override
  String get revealOpenFolder => 'Открыть папку';

  @override
  String get transferResend => 'Отправить снова';

  @override
  String get transferRemove => 'Убрать из списка';

  @override
  String get transferCopyPath => 'Скопировать путь';

  @override
  String get transferPathCopied => 'Путь скопирован';

  @override
  String sendingTo(String name, String percent) {
    return 'Отправка на $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Получение от $name · $percent';
  }

  @override
  String get receiveFiles => 'Получать файлы с других устройств';

  @override
  String get saveTo => 'Сохранять в';

  @override
  String get saveToChange => 'Изменить…';

  @override
  String get saveToDefault => 'Загрузки (по умолчанию)';

  @override
  String get saveToUseDefault => 'Использовать «Загрузки»';

  @override
  String get receiveNotify => 'Уведомлять о новых файлах';

  @override
  String receiveFootnote(String device) {
    return 'Отправлять файлы на $device могут только сопряжённые устройства. Пока идёт передача, $device не перейдёт в режим сна сам.';
  }

  @override
  String get saveDirNotFound => 'Эта папка не существует.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry не может сохранять файлы в эту папку.';

  @override
  String get saveDirPermission =>
      'У PasteFerry нет доступа к этой папке. Разрешите его в разделе «Системные настройки → Конфиденциальность и безопасность → Файлы и папки».';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'В $count именах файлов были недопустимые в Windows символы; они заменены похожими полноширинными символами',
      many:
          'В $count именах файлов были недопустимые в Windows символы; они заменены похожими полноширинными символами',
      few:
          'В $count именах файлов были недопустимые в Windows символы; они заменены похожими полноширинными символами',
      one:
          'В $count имени файла были недопустимые в Windows символы; они заменены похожими полноширинными символами',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Эта сеть';

  @override
  String get sendRingOther => 'Другие сети';

  @override
  String sendOfflineList(String names) {
    return 'Не в сети: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Список передач';

  @override
  String get sendLayoutSide => 'Справа от радара';

  @override
  String get sendLayoutBelow => 'Под радаром';

  @override
  String get general => 'Основные';

  @override
  String get launchAtLogin => 'Запуск при входе';

  @override
  String get launchAtLoginDesc =>
      'Запускаться в фоне при входе в систему. Изменение не останавливает текущий сеанс.';

  @override
  String get realtimeSync => 'Синхронизация буфера в реальном времени';

  @override
  String get realtimeSyncDesc =>
      'Автоматически передавать новые копирования на сопряжённые устройства. Если выключено, локальная история и отправка файлов остаются доступны.';

  @override
  String get syncBacklog => 'Догонять после переподключения';

  @override
  String get syncBacklogDesc =>
      'По умолчанию выключено: пропущенные копирования не передаются. Если включить, до 20 копирований за последние 24 часа попадут в историю, не заменяя буфер обмена.';

  @override
  String get peerRealtimeSync => 'Синхронизировать с этим компьютером';

  @override
  String get syncPaused => 'Синхронизация буфера приостановлена';

  @override
  String get quitApp => 'Выйти из PasteFerry';

  @override
  String get quitAppDesc =>
      'Завершить все процессы PasteFerry. Настройка запуска при входе сохранится.';

  @override
  String get quitTransfersWarning =>
      'Файлы ещё передаются. Выйти и прервать передачу?';

  @override
  String get backgroundRunningTitle => 'PasteFerry продолжит работать';

  @override
  String get backgroundRunningBody =>
      'После закрытия окна синхронизация и быстрая вставка продолжают работать. Чтобы остановить всё, выберите «Выйти из PasteFerry» в настройках или в меню приложения.';

  @override
  String get displayAs => 'Отображается как';

  @override
  String get editName => 'Изменить имя';

  @override
  String get nameHint => 'Имя, которое видят ваши контакты';

  @override
  String get nameDefaultHint =>
      'Оставьте пустым, чтобы использовать имя учётной записи.';

  @override
  String get avatarTitle => 'Фото профиля';

  @override
  String get avatarChoose => 'Выбрать изображение…';

  @override
  String get avatarPaste => 'Вставить изображение';

  @override
  String get avatarReset => 'Фото по умолчанию';

  @override
  String get avatarZoom => 'Масштаб';

  @override
  String get avatarDragHint => 'Перетаскивайте, чтобы сдвинуть изображение.';

  @override
  String get avatarNoImage => 'В буфере обмена нет изображения.';

  @override
  String get avatarBad =>
      'Это изображение не подходит. Выберите PNG, JPEG или GIF.';

  @override
  String get done => 'Готово';

  @override
  String get friendsTitle => 'Контакты';

  @override
  String get addFriend => 'Добавить контакт';

  @override
  String get friendsEmpty => 'Контактов пока нет';

  @override
  String get friendsEmptyBody =>
      'Добавьте человека, который тоже пользуется PasteFerry, чтобы обмениваться файлами без сопряжения. Контакты могут только отправлять файлы и никогда не видят ваш буфер обмена.';

  @override
  String get friendSendAction => 'Отправить…';

  @override
  String get friendHistory => 'Передачи';

  @override
  String friendHistoryTitle(String name) {
    return 'Передачи с $name';
  }

  @override
  String get friendHistoryEmpty => 'Передач пока не было.';

  @override
  String get friendAutoAccept => 'Принимать файлы автоматически';

  @override
  String get friendRemove => 'Удалить контакт';

  @override
  String friendRemoveTitle(String name) {
    return 'Удалить $name?';
  }

  @override
  String get friendRemoveBody =>
      'Вы удалите друг друга из контактов и больше не сможете обмениваться файлами. Прошлые передачи останутся на этом компьютере.';

  @override
  String friendLastActivity(String time) {
    return 'Последняя передача: $time';
  }

  @override
  String get friendNoActivity => 'Передач пока не было';

  @override
  String get friendCodeShare =>
      'Отправьте этот код своему контакту. Когда он введёт его в PasteFerry, вы появитесь друг у друга в контактах.';

  @override
  String friendCodeExpires(String time) {
    return 'Истекает через $time';
  }

  @override
  String get friendCodeOr => 'или';

  @override
  String get friendCodeEnter => 'Введите код контакта';

  @override
  String get friendCodeAdd => 'Добавить';

  @override
  String get friendCodeWaiting => 'Ждём, когда код введут…';

  @override
  String friendConfirmBody(String name) {
    return 'Добавить $name в контакты?';
  }

  @override
  String get friendSafetyCode => 'Сверить код безопасности (необязательно)';

  @override
  String get friendSafetyHint =>
      'Когда будете рядом, сравните эти две строки. Если на обоих компьютерах они совпадают, никто не вмешивался.';

  @override
  String get friendWaitingPeer => 'Ждём, когда вас добавят…';

  @override
  String friendAdded(String name) {
    return 'Контакт $name добавлен';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name: отменено';
  }

  @override
  String get friendErrFriendCode =>
      'Это код контакта. Введите его в разделе «Добавить контакт» на странице «Отправка файлов».';

  @override
  String get friendErrDeviceCode =>
      'Это код сопряжения. Введите его в разделе «Устройства → Добавить устройство».';

  @override
  String get friendErrOutdated =>
      'Собеседнику нужен PasteFerry 2.6.0 или новее.';

  @override
  String get friendErrAlreadyPaired =>
      'Этот компьютер уже входит в ваши устройства.';

  @override
  String get friendErrNoChannel =>
      'Вы не в одной сети. Чтобы добавить друг друга, включите «Сервис» на обоих компьютерах.';

  @override
  String get openService => 'Включить «Сервис»…';

  @override
  String get noteLabel => 'Примечание (необязательно)';

  @override
  String get noteHintEmpty => 'Сначала выберите файлы';

  @override
  String get noteHint => 'Например: подпишите, пожалуйста, страницу 3';

  @override
  String noteLine(String note) {
    return 'Примечание: $note';
  }

  @override
  String get sendAction => 'Отправить';

  @override
  String sendItemsSummary(String count, String size) {
    return 'Объектов: $count · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Перетащите сюда файлы или изображения либо вставьте ($key)';
  }

  @override
  String get sendDropMorePaste => 'Перетащите или вставьте ещё';

  @override
  String get sendPasteNothing =>
      'Нечего вставить. Сначала скопируйте файлы или изображение.';

  @override
  String get sendRemoveItem => 'Убрать';

  @override
  String sendFriendSaved(String name) {
    return '$name подтверждает каждую отправку, прежде чем она начнётся.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Ждём, когда $name примет…';
  }

  @override
  String get transferAskingIn => 'Ждёт вашего подтверждения';

  @override
  String reasonDeclined(String name) {
    return '$name: отклонено';
  }

  @override
  String reasonTimeout(String name) {
    return '$name: нет ответа';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name не принимает файлы';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name сейчас не принимает ваши файлы';
  }

  @override
  String get reasonYouDeclined => 'Отклонено';

  @override
  String get reasonYouIgnored => 'Проигнорировано';

  @override
  String get sendAgain => 'Отправить ещё раз';

  @override
  String incomingTitle(String name) {
    return '$name хочет отправить вам файлы';
  }

  @override
  String get incomingAlways => 'Всегда принимать файлы от этого контакта';

  @override
  String get incomingDecline => 'Отклонить';

  @override
  String get incomingAccept => 'Принять';

  @override
  String incomingCountdown(String seconds) {
    return 'Автоматический отказ через $seconds с';
  }

  @override
  String get incomingStranger => 'Рядом';

  @override
  String get friendsStrip => 'Контакты';

  @override
  String get strangersStrip => 'Рядом, в режиме «Все»';

  @override
  String get strangerNearby => 'Рядом';

  @override
  String get friendNeedService => 'Включите «Сервис»';

  @override
  String get friendCantReach => 'Нет связи';

  @override
  String reachSelfNoService(String name) {
    return 'Вы и $name в разных сетях. Включите «Сервис», чтобы отправлять файлы; если прямое соединение невозможно, они пойдут через ретрансляцию сервиса.';
  }

  @override
  String reachPeerNoService(String name) {
    return 'У $name не включён «Сервис», поэтому файлы можно отправлять только в одной сети. Попросите включить «Сервис» в PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Вы используете разные серверы. Чтобы отправлять файлы, включите «Сервис» на обоих компьютерах или используйте один сервер.';

  @override
  String get receiveFromLabel => 'Кто может отправлять мне файлы:';

  @override
  String get receiveFromOff => 'Никто';

  @override
  String get receiveFromFriends => 'Только контакты';

  @override
  String get receiveFromEveryone => 'Все';

  @override
  String everyoneLeft(String minutes) {
    return 'Все · осталось $minutes мин';
  }

  @override
  String get receiveFromOffDesc =>
      'Файлы могут отправлять только ваши сопряжённые компьютеры.';

  @override
  String get receiveFromFriendsDesc =>
      'Ваши контакты могут отправлять вам файлы. Каждую отправку подтверждаете вы.';

  @override
  String get receiveFromEveryoneDesc =>
      'В течение 10 минут любой в этой сети может отправлять вам файлы. Каждую отправку подтверждаете вы.';

  @override
  String get everyoneEnded => 'Режим «Все» выключен; снова «Только контакты».';

  @override
  String get friendsCountTooltip => 'Контакты';

  @override
  String get waitingAccept => 'Ожидание…';

  @override
  String get settingsConnection => 'Подключение';

  @override
  String get settingsGeneralSummary => 'Запуск при входе, имя устройства, язык';

  @override
  String get settingsConnectionSummary => 'Сервис, свой сервер, локальная сеть';

  @override
  String get settingsSyncSummary =>
      'Синхронизация в реальном времени, лимит, что синхронизировать';

  @override
  String get settingsQuickPasteSummary =>
      'Сочетание клавиш и действие после выбора';

  @override
  String get settingsSendSummary => 'Получение файлов, место сохранения';

  @override
  String get settingsStorageSummary => 'Срок хранения истории, занятое место';

  @override
  String get settingsAboutSummary => 'Версия, обновления, обратная связь';

  @override
  String get friendsSubtitle =>
      'Отправляйте файлы на компьютеры других людей без сопряжения';

  @override
  String get friendsSearch => 'Поиск контактов';

  @override
  String get friendsNoMatch => 'Контакты не найдены';

  @override
  String get friendsPick =>
      'Выберите контакт, чтобы посмотреть передачи или отправить файлы';

  @override
  String friendDropHint(String name) {
    return 'Перетащите сюда файлы для отправки: $name';
  }

  @override
  String get webShareTitle => 'Веб-передача с телефона';

  @override
  String get webShareFootnote =>
      'Отсканируйте QR-код телефоном, чтобы обмениваться текстом, фото и файлами с этим компьютером прямо в браузере, без приложения. Телефон и компьютер должны быть в одной сети.';

  @override
  String get webShareSwitch => 'Разрешить телефонам подключаться через браузер';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вкл., $count телефона',
      many: 'Вкл., $count телефонов',
      few: 'Вкл., $count телефона',
      one: 'Вкл., $count телефон',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'Выкл.';

  @override
  String get webShareShowQr => 'Показать QR-код';

  @override
  String get webShareDialogTitle => 'Отсканируйте телефоном';

  @override
  String get webShareDialogBody =>
      'Отсканируйте камерой или браузером телефона и откройте ссылку в браузере. Каждый QR-код регистрирует один телефон и после использования заменяется.';

  @override
  String get webShareAddress => 'Адрес';

  @override
  String get webShareSecurity =>
      'Содержимое шифруется на странице, поэтому другие в сети не могут его прочитать. Но сама страница работает по http и не защищает от намеренной подмены. Пользуйтесь дома или в надёжной рабочей сети, но не в общедоступной Wi‑Fi.';

  @override
  String get webSharePhones => 'Зарегистрированные телефоны';

  @override
  String get webShareNoPhones => 'Телефонов пока нет';

  @override
  String webShareLastUsed(String time) {
    return 'Использовался: $time';
  }

  @override
  String get webShareRemove => 'Удалить';

  @override
  String webShareRemoved(String name) {
    return '«$name» удалён';
  }

  @override
  String webShareNewPhone(String name) {
    return '«$name» зарегистрирован';
  }

  @override
  String webShareNotListening(String error) {
    return 'Не удалось начать прослушивание: $error';
  }

  @override
  String get webSharePortFallback =>
      'Обычный порт занят, поэтому используется временный. Сохранённые адреса не откроются, пока телефоны не отсканируют код заново.';

  @override
  String get webShareNoAddress =>
      'Нет адреса в локальной сети. Сначала подключитесь к Wi‑Fi или проводной сети.';

  @override
  String get webShareCantOpen =>
      'Если страница не открывается на телефоне, убедитесь, что оба устройства в одной сети (гостевые сети обычно не подходят). В Windows также нужно разрешить PasteFerry в брандмауэре.';

  @override
  String get mTabRecords => 'История';

  @override
  String get mTabSend => 'Отправка';

  @override
  String get mThisPhone => 'Этот телефон';

  @override
  String get mThisPhoneInText => 'этот телефон';

  @override
  String mThisPhoneName(String name) {
    return 'Этот телефон: $name';
  }

  @override
  String get mSendTitle => 'Отправить на компьютер';

  @override
  String get mSendHint => 'Введите или вставьте текст';

  @override
  String get mPaste => 'Вставить';

  @override
  String get mPhotosFiles => 'Фото или файлы';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Отправить файлы ($n)?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n файла отправлено на компьютер',
      many: '$n файлов отправлено на компьютер',
      few: '$n файла отправлено на компьютер',
      one: '$n файл отправлен на компьютер',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'В буфере обмена нет текста';

  @override
  String get mSendAction => 'Отправить';

  @override
  String mSendTo(String names) {
    return 'Получатель: $names';
  }

  @override
  String get mNoOnlineDevices => 'Рядом нет устройств в сети';

  @override
  String get mNoPairedDevices => 'Сначала выполните сопряжение с компьютером';

  @override
  String get mSent => 'Отправлено';

  @override
  String get mSendFootnote =>
      'Текст и файлы попадают в историю на компьютере и, в зависимости от его настроек, в его буфер обмена. Скопированное на телефоне само не отправляется.';

  @override
  String get mSentRecords => 'Отправленное';

  @override
  String get mSentRetention => 'Хранить отправленное';

  @override
  String mSentRetentionDesc(Object d) {
    return 'В разделе «Отправленное» показано, что телефон отправил за последние $d дн.';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d дн.';
  }

  @override
  String get mViewAll => 'Показать все';

  @override
  String get mClearCache => 'Очистить';

  @override
  String get mCheckUpdate => 'Проверить обновления';

  @override
  String get mUpdateFailed => 'Не удалось проверить обновления';

  @override
  String get mUpToDate => 'У вас последняя версия';

  @override
  String mNewVersion(Object v) {
    return 'Доступна версия $v';
  }

  @override
  String get mDownloadInstall => 'Скачать новую версию';

  @override
  String mSendFailed(String detail) {
    return 'Не удалось отправить: $detail';
  }

  @override
  String get mCopy => 'Копировать';

  @override
  String get mCopied => 'Скопировано в буфер обмена телефона';

  @override
  String get mShare => 'Поделиться';

  @override
  String get mSaved => 'Сохранено в «Фото» или Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Не получилось: $detail';
  }

  @override
  String get mDownloading => 'Загрузка…';

  @override
  String get mNotDownloaded => 'Ещё не загружено';

  @override
  String get mDownloadHint =>
      'При нажатии «Копировать», «Сохранить» или «Поделиться» сначала начнётся загрузка.';

  @override
  String get mFullTextLoading => 'Загрузка…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Показано символов: $shown из $total. Копируется весь текст.';
  }

  @override
  String get mNotOnLanTitle => 'Нет подключения к Wi‑Fi';

  @override
  String get mNotOnLanBody =>
      'Пока PasteFerry синхронизирует только в локальной сети. Подключитесь к той же сети Wi‑Fi, что и компьютер.';

  @override
  String mStartFailed(String detail) {
    return 'Не удалось запустить PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'На компьютере откройте PasteFerry → «Устройства» → «Добавить устройство» и введите здесь показанный код. В одной сети Wi‑Fi можно также открыть «Поиск рядом» на обоих устройствах.';

  @override
  String get mSectionSync => 'Синхронизация';

  @override
  String get mSectionBackground => 'Фоновая работа';

  @override
  String get mAutoApplyDesc =>
      'Текст, скопированный на компьютере, сразу попадает в буфер обмена телефона. Изображения и файлы ждут, пока вы не нажмёте «Копировать».';

  @override
  String get mKeepAlive => 'Оставаться на связи в фоне';

  @override
  String get mKeepAliveDesc =>
      'Получать текст, даже когда PasteFerry не открыт. Показывается постоянное уведомление.';

  @override
  String get mNotifications => 'Уведомления';

  @override
  String get mNotificationsDesc =>
      'Нужны для постоянного уведомления. PasteFerry работает и без них.';

  @override
  String get mBattery => 'Работа в фоне';

  @override
  String get mBatteryDesc =>
      'Отключите оптимизацию батареи, чтобы система не останавливала PasteFerry при заблокированном экране. На некоторых телефонах также нужно добавить PasteFerry в список автозапуска или фоновой работы в настройках.';

  @override
  String get mAllowed => 'Разрешено';

  @override
  String get mAllow => 'Разрешить';

  @override
  String mVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get mDeleteConfirm => 'Удалить эту запись?';

  @override
  String get mDelete => 'Удалить';

  @override
  String get webShareFirewallPreparing =>
      'Проверка брандмауэра Windows. Если Windows запросит разрешение администратора, выберите «Да», чтобы телефон смог подключиться.';

  @override
  String get webShareFirewallReady =>
      'Правила брандмауэра Windows готовы. Подключите телефон к той же сети и отсканируйте QR-код. Если подключиться всё равно не удаётся, проверьте брандмауэр ещё раз кнопкой ниже.';

  @override
  String get webShareFirewallFailed =>
      'Настройка брандмауэра не завершена. Телефон может не открыть страницу. Повторите попытку и подтвердите запрос администратора Windows.';

  @override
  String get webShareFirewallAllow =>
      'Проверить и разрешить подключение телефона';

  @override
  String get mCopyMediaFailed =>
      'Не удалось скопировать это изображение или файл. Попробуйте сначала сохранить его.';

  @override
  String get mShareMediaFailed =>
      'Не удалось открыть меню «Поделиться» для этого изображения или файла. Попробуйте сначала сохранить его.';

  @override
  String get mSaveMediaFailed =>
      'Не удалось сохранить это изображение или файл. Проверьте доступ к хранилищу и свободное место, затем повторите попытку.';

  @override
  String get noticeFilesUnreadable =>
      'Не удалось прочитать только что скопированные файлы, поэтому ничего не синхронизировано';

  @override
  String get mAddMore => 'Добавить ещё';

  @override
  String get mChoosePhotos => 'Выбрать фото…';

  @override
  String get mMultiSelectHint =>
      'Можно выбрать сразу несколько фото. В «Файлах» нажмите и удерживайте объект, чтобы выбрать ещё.';

  @override
  String get webSendFiles => 'Отправить файлы';

  @override
  String get webFilesQueued =>
      'Добавлено в веб-передачу. Откройте «Отправку файлов» на телефоне, чтобы скачать.';

  @override
  String get webFilesLimit =>
      'Через веб можно скачать до 200 МБ на файл и до 64 файлов за раз.';

  @override
  String get appearance => 'Оформление';

  @override
  String get settingsAppearanceSummary => 'Тема, светлое и тёмное оформление';

  @override
  String get themeTitle => 'Тема';

  @override
  String get themeDefault => 'Стандартная';

  @override
  String get themePixel => 'Пиксельная';

  @override
  String get themeMode => 'Светлое и тёмное';

  @override
  String get themeModeSystem => 'Как в системе';

  @override
  String get themeModeLight => 'Светлое';

  @override
  String get themeModeDark => 'Тёмное';

  @override
  String get themeCustom => 'Своя';

  @override
  String get themeDelete => 'Удалить тему';

  @override
  String themeDeleteConfirm(String name) {
    return 'Удалить тему «$name»?';
  }

  @override
  String get themeLowContrast =>
      'Часть текста в этой теме может плохо читаться';

  @override
  String get themeFootnote =>
      'Темы применяются только на этом устройстве, включая окно быстрой вставки. На другие устройства они не синхронизируются.';

  @override
  String get themeBuiltinGroup => 'Встроенные';

  @override
  String get themeCustomGroup => 'Свои';

  @override
  String get themeUse => 'Применить';

  @override
  String get themeDuplicate => 'Дублировать';

  @override
  String themeCopyName(String name) {
    return '$name (копия)';
  }

  @override
  String get themeExport => 'Экспортировать…';

  @override
  String get themeImport => 'Импортировать тему…';

  @override
  String themeImported(String name) {
    return 'Тема «$name» импортирована';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count цвета текста могут плохо читаться.',
      many: '$count цветов текста могут плохо читаться.',
      few: '$count цвета текста могут плохо читаться.',
      one: '$count цвет текста может плохо читаться.',
    );
    return 'Тема «$name» импортирована. $_temp0';
  }

  @override
  String get themeExported => 'Тема экспортирована';

  @override
  String get themeCustomEmpty =>
      'Своих тем пока нет. Дублируйте встроенную тему, импортируйте тему или попросите ИИ создать её.';

  @override
  String get themeAskAi => 'Попросить ИИ создать тему';

  @override
  String get themeAskAiBody =>
      'Добавьте этот MCP-сервер в ИИ-приложение, например Claude или Cursor, и попросите тему, например: «Сделай мне тему в стиле киберпанк». ИИ изучит формат темы, подберёт цвета, проверит контраст и применит тему.';

  @override
  String get themeAskAiCopy => 'Скопировать конфигурацию';

  @override
  String get themeAskAiCopied => 'Конфигурация скопирована';

  @override
  String get themeScanlines => 'Линии развёртки';

  @override
  String get themeScanlinesDesc =>
      'Накладывает на окно едва заметные линии развёртки, как на ЭЛТ-экране. Только для пиксельных тем.';

  @override
  String get themeBackground => 'Фоновое изображение';

  @override
  String get themeBackgroundDesc =>
      'Заполняет окно за боковой панелью и страницами. Затемнение поверх сохраняет текст читаемым.';

  @override
  String get themeBackgroundChoose => 'Выбрать изображение…';

  @override
  String get themeBackgroundChange => 'Изменить…';

  @override
  String get themeBackgroundRemove => 'Удалить';

  @override
  String get themeBlur => 'Размытие';

  @override
  String get themeBlurNone => 'Нет';

  @override
  String get themeBlurLight => 'Слабое';

  @override
  String get themeBlurStrong => 'Сильное';

  @override
  String get themeScrim => 'Затемнение';

  @override
  String get themeScrimDesc =>
      'Слой цвета поверх изображения, чтобы текст оставался читаемым. Он никогда не светлее, чем нужно изображению.';

  @override
  String get themeScrimAuto => 'Авто';

  @override
  String get themeScrimMore => 'Плотнее';

  @override
  String get themeScrimMost => 'Максимум';

  @override
  String get themePanels => 'Панели';

  @override
  String get themePanelsDesc =>
      'Насколько изображение просвечивает сквозь боковую панель и списки.';

  @override
  String get themePanelsClear => 'Прозрачные';

  @override
  String get themePanelsMedium => 'Средние';

  @override
  String get themePanelsSolid => 'Непрозрачные';

  @override
  String get themeAccentFromImage => 'Цвета изображения';

  @override
  String get themeAccentFromImageDesc => 'Брать акцентный цвет из изображения.';

  @override
  String get themeBackgroundPicker => 'Показывать и в быстрой вставке';

  @override
  String get themeScenery => 'Показывать пейзажи';

  @override
  String get themeSceneryDesc =>
      'Картинки вверху страниц и внизу боковой панели.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Встроенные темы нельзя изменять, поэтому создана и применена копия «$name»';
  }

  @override
  String get themeBackgroundFootnote =>
      'Фон относится к текущей теме. Встроенные темы нельзя изменять: при первом изменении создаётся копия. Изображения хранятся только на этом устройстве; поддерживаются JPEG, PNG и GIF.';

  @override
  String get themeSceneGroup => 'Пейзажи';

  @override
  String get themeSceneHeader => 'Шапка страницы';

  @override
  String get themeSceneHeaderDesc =>
      'Широкая картинка за заголовками страниц; её нижний край плавно переходит в страницу. В пиксельной теме здесь пиксельный пейзаж.';

  @override
  String get themeSceneSidebar => 'Низ боковой панели';

  @override
  String get themeSceneSidebarDesc =>
      'Небольшая картинка внизу боковой панели. В пиксельной теме здесь маленький лагерь.';

  @override
  String get themeSceneReset => 'Сбросить';

  @override
  String get themeSceneFootnote =>
      'В любой теме здесь можно показать свои картинки. Затемнение сохраняет заголовок страницы читаемым. Пейзажи скрыты, пока окно заполняет фоновое изображение.';

  @override
  String get starTitle => 'Как вам PasteFerry?';

  @override
  String get starBody =>
      'Если нравится, поставьте звезду на GitHub — это очень поможет.';

  @override
  String get starAction => 'Звезда на GitHub';

  @override
  String get starLater => 'Позже';

  @override
  String get starDismiss => 'Больше не показывать';
}
