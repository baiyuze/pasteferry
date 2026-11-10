// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Historia';

  @override
  String get navDevices => 'Urządzenia';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get navFavorites => 'Ulubione';

  @override
  String get linkConnecting => 'Łączenie…';

  @override
  String get linkServiceNotRunning => 'Usługa nie działa';

  @override
  String get linkLanMode => 'Wyszukiwanie urządzeń w tej sieci';

  @override
  String get linkServerUnreachable =>
      'Brak połączenia z serwerem; synchronizacja w tej sieci';

  @override
  String get linkNothingOn =>
      'Wykrywanie w sieci lokalnej jest wyłączone i nie ustawiono serwera';

  @override
  String get linkLanBlocked => 'macOS blokuje dostęp do sieci lokalnej';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count urządzenia online',
      many: '$count urządzeń online',
      few: '$count urządzenia online',
      one: '$count urządzenie online',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Połączono z serwerem';

  @override
  String linkConnectionLost(String detail) {
    return 'Utracono połączenie: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Usługa rozłączona';

  @override
  String get linkServiceDisabled => 'Synchronizacja w tle jest wyłączona';

  @override
  String get errServiceNotConnected => 'Brak połączenia z usługą w tle';

  @override
  String get errUnimplemented => 'Ta funkcja nie jest jeszcze dostępna';

  @override
  String get errUnavailable => 'Nie można połączyć się z usługą w tle';

  @override
  String errServiceStart(String detail) {
    return 'Nie można uruchomić usługi w tle: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Nie można ponownie uruchomić usługi w tle: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Nie można ustawić uruchamiania PasteFerry po zalogowaniu: $detail';
  }

  @override
  String get thisMacTitle => 'Ten Mac';

  @override
  String get thisPcTitle => 'Ten komputer';

  @override
  String get thisMacInText => 'ten Mac';

  @override
  String get thisPcInText => 'ten komputer';

  @override
  String get bothMacs => 'oba komputery Mac';

  @override
  String get bothDevices => 'oba urządzenia';

  @override
  String get thisDeviceShort => 'To urządzenie';

  @override
  String fromDevice(String name) {
    return 'Z urządzenia $name';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String get close => 'Zamknij';

  @override
  String get save => 'Zapisz';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get continueAction => 'Dalej';

  @override
  String get justNow => 'Przed chwilą';

  @override
  String secondsAgo(int n) {
    return '$n s temu';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minuty temu',
      many: '$n minut temu',
      few: '$n minuty temu',
      one: '$n minutę temu',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n godziny temu',
      many: '$n godzin temu',
      few: '$n godziny temu',
      one: '$n godzinę temu',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dni temu',
      many: '$n dni temu',
      few: '$n dni temu',
      one: 'Wczoraj',
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
      other: '$n godziny',
      many: '$n godzin',
      few: '$n godziny',
      one: '$n godzina',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dnia',
      many: '$n dni',
      few: '$n dni',
      one: '$n dzień',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Skopiuj coś na dowolnym urządzeniu, a pojawi się tutaj';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '$count element',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '$count element',
    );
    return '$_temp0, czas przechowywania: $ttl';
  }

  @override
  String get filterAll => 'Wszystko';

  @override
  String get filterText => 'Tekst';

  @override
  String get filterImage => 'Obrazy';

  @override
  String get filterFile => 'Pliki';

  @override
  String get filterLink => 'Linki';

  @override
  String get historyClearTooltip => 'Wyczyść historię';

  @override
  String get historyEmptyTitle => 'Na razie pusto';

  @override
  String get historyEmptyFilteredTitle => 'Brak elementów tego typu';

  @override
  String get historyEmptyBody =>
      'Skopiuj tekst, obraz lub plik na dowolnym sparowanym urządzeniu, a pojawi się tutaj.';

  @override
  String get clearConfirmTitle => 'Wyczyścić całą historię?';

  @override
  String clearConfirmBody(String device) {
    return 'Wszystko, co zsynchronizowano z urządzeń, oraz pliki w pamięci podręcznej zostaną usunięte – $device przestanie je przechowywać. Oryginalne pliki pozostaną bez zmian.';
  }

  @override
  String get clear => 'Wyczyść';

  @override
  String get historyCleared => 'Wyczyszczono historię';

  @override
  String get permDeniedTitle => 'PasteFerry nie może odczytywać schowka';

  @override
  String get permAskTitle => 'Zezwól PasteFerry na odczyt schowka';

  @override
  String get permDeniedBody =>
      'To, co skopiujesz na tym Macu, nie będzie synchronizowane. W Ustawieniach systemowych ustaw PasteFerry Daemon na „Zezwalaj”.';

  @override
  String get permAskBody =>
      'W przeciwnym razie macOS będzie pytać za każdym razem. W Ustawieniach systemowych ustaw PasteFerry Daemon na „Zezwalaj”.';

  @override
  String get openSystemSettings => 'Otwórz Ustawienia systemowe';

  @override
  String get fetch => 'Odbierz';

  @override
  String get fetchStarted => 'Odbieranie… Postęp widać w Historii';

  @override
  String get transferFailed => 'Przesyłanie nie powiodło się';

  @override
  String get expired => 'Wygasło';

  @override
  String get putOnClipboard => 'Kopiuj do schowka';

  @override
  String get putOnClipboardDone => 'W schowku';

  @override
  String get deleteRecord => 'Usuń ten element';

  @override
  String get deleted => 'Usunięto';

  @override
  String get emptyRecord => '(pusty)';

  @override
  String get imageRecord => 'Obraz';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name i jeszcze $others';
  }

  @override
  String get searchHint => 'Szukaj w tekście i nazwach plików';

  @override
  String get searchClear => 'Wyczyść wyszukiwanie';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wyniku',
      many: '$count wyników',
      few: '$count wyniki',
      one: '$count wynik',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Brak wyników dla „$query”';
  }

  @override
  String get searchEmptyBody =>
      'Wyszukiwanie obejmuje skopiowany tekst i nazwy skopiowanych plików.';

  @override
  String get favoriteAction => 'Dodaj do ulubionych';

  @override
  String get unfavoriteAction => 'Usuń z ulubionych';

  @override
  String get favoritedToast => 'Dodano do ulubionych';

  @override
  String get unfavoritedToast => 'Przeniesiono z powrotem do Historii';

  @override
  String get undo => 'Cofnij';

  @override
  String get favoriteSaving => 'Zapisywanie…';

  @override
  String favoritedAt(String date) {
    return 'Zapisano $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '$count element',
    );
    return '$_temp0 · bez automatycznego czyszczenia · do $size';
  }

  @override
  String get favoritesEmptyTitle => 'Brak ulubionych';

  @override
  String get favoritesEmptyBody =>
      'Oznacz element w Historii gwiazdką, aby zachować tu jego kopię. Ulubione nigdy nie są czyszczone automatycznie.';

  @override
  String get favoritesSearchHint => 'Szukaj w ulubionych';

  @override
  String favoriteLargeTitle(String size) {
    return 'Zapisać kopię o rozmiarze $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Ulubiony element ma własną kopię, więc zmiana lub usunięcie oryginalnych plików na niego nie wpłynie. Kopia zajmie $size – przechowa ją $device.';
  }

  @override
  String get saveCopy => 'Zapisz kopię';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ulubione ($count) zostaną zachowane.',
      many: '$count ulubionych elementów zostanie zachowanych.',
      few: '$count ulubione elementy zostaną zachowane.',
      one: '$count ulubiony element zostanie zachowany.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Ulubione';

  @override
  String get favoritesUsageDesc =>
      'Ulubione nigdy nie są czyszczone, niezależnie od powyższych ustawień';

  @override
  String upToSize(String size) {
    return 'Do $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count znaku',
      many: '$count znaków',
      few: '$count znaki',
      one: '$count znak',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count znaku',
      many: '$count znaków',
      few: '$count znaki',
      one: '$count znak',
    );
    return '… łącznie $_temp0';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jeszcze $count pliku',
      many: 'Jeszcze $count plików',
      few: 'Jeszcze $count pliki',
      one: 'Jeszcze $count plik',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Wybierz, aby najpierw pobrać';

  @override
  String detailTotalSize(String size) {
    return 'Łącznie $size';
  }

  @override
  String get quickPaste => 'Szybkie wklejanie';

  @override
  String get quickPasteWindow => 'Okno szybkiego wklejania';

  @override
  String get quickPasteWindowDesc =>
      'Naciśnij skrót w dowolnej aplikacji, aby otworzyć historię; wybrany element zostanie wklejony';

  @override
  String get quickPasteShortcut => 'Skrót';

  @override
  String get quickPasteRecord => 'Kliknij, aby zmienić';

  @override
  String get quickPasteRecording => 'Naciśnij nowy skrót…';

  @override
  String get quickPasteUseDefault => 'Przywróć domyślny';

  @override
  String get quickPasteNeedsModifier =>
      'Użyj ⌃, ⌥, ⇧ lub ⌘ albo klawisza funkcyjnego';

  @override
  String get quickPasteNeedsModifierPc =>
      'Użyj Ctrl, Alt, Shift lub klawisza Windows albo klawisza funkcyjnego';

  @override
  String get quickPasteAfterPick => 'Po wybraniu elementu';

  @override
  String get quickPastePasteIt => 'Wklej go';

  @override
  String get quickPasteCopyIt => 'Tylko skopiuj';

  @override
  String get quickPasteIndexKey => 'Wybór jednego z 9 pierwszych';

  @override
  String get quickPasteIndexKeyDesc =>
      'W oknie szybkiego wklejania przytrzymaj ten klawisz i naciśnij 1–9';

  @override
  String get quickPasteAccessibility => 'Dostępność';

  @override
  String get quickPasteAccessibilityDesc =>
      'Potrzebne do automatycznego wklejania. Bez tego elementy są tylko kopiowane i trzeba nacisnąć ⌘V.';

  @override
  String get quickPasteAllowed => 'Dozwolone';

  @override
  String get quickPasteAllow => 'Zezwól…';

  @override
  String get quickPasteNotRunning => 'Okno szybkiego wklejania nie działa';

  @override
  String quickPasteInUse(String key) {
    return 'Skrót $key jest używany przez inną aplikację. Wybierz inny.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Nie można ustawić $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Ustaw w systemowych ustawieniach skrótów';

  @override
  String get quickPasteWaylandDesc =>
      'W Wayland dodaj skrót w ustawieniach klawiatury środowiska pulpitu. Wybrane elementy są kopiowane; naciśnij Ctrl+V, aby wkleić.';

  @override
  String get quickPasteAddShortcut => 'Dodaj skrót systemowy';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Dodano. Naciśnij $key, aby wypróbować.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'W ustawieniach klawiatury środowiska pulpitu dodaj własny skrót, który uruchamia: $command';
  }

  @override
  String get pickerSearch => 'Szukaj';

  @override
  String get pickerPaste => 'Wklej';

  @override
  String get pickerPlainText => 'Zwykły tekst';

  @override
  String get pickerCopyOnly => 'Tylko kopiuj';

  @override
  String get pickerUnfavoriteHint => 'Usuń (wraca do Historii)';

  @override
  String pickerPasteManually(String key) {
    return 'Wybrane elementy są kopiowane — naciśnij $key, aby wkleić';
  }

  @override
  String get pickerGrantHint =>
      'Zezwól na Dostępność, aby wklejać bezpośrednio';

  @override
  String pickerElevated(String key) {
    return 'To okno działa jako administrator — po wybraniu naciśnij $key, aby wkleić';
  }

  @override
  String get pickerDownloading => 'Pobieranie — wklejenie po zakończeniu';

  @override
  String get imagePreviewTitle => 'Podgląd obrazu';

  @override
  String get closePreview => 'Zamknij podgląd';

  @override
  String get previousImage => 'Poprzedni obraz';

  @override
  String get nextImage => 'Następny obraz';

  @override
  String get previewHint =>
      'Przewiń lub zsuń palce, aby powiększyć; przeciągnij, aby przesunąć';

  @override
  String get fitWindow => 'Dopasuj do okna';

  @override
  String get previewDeleted => 'Ten obraz został usunięty z historii';

  @override
  String get previewExpired => 'Ten obraz wygasł i nie można go wyświetlić';

  @override
  String get previewDownloading => 'Pobieranie obrazu…';

  @override
  String get previewDownloadFailed =>
      'Pobieranie nie powiodło się. Spróbuj ponownie.';

  @override
  String get previewNotDownloaded =>
      'Tego obrazu nie ma jeszcze na tym komputerze';

  @override
  String get downloadAndPreview => 'Pobierz i wyświetl';

  @override
  String get previewUnavailable => 'Nie można teraz wyświetlić tego obrazu';

  @override
  String get imageSemantic => 'Obraz z historii';

  @override
  String get previewUnreadable =>
      'Nie można odczytać obrazu. Plik mógł zostać usunięty lub uszkodzony.';

  @override
  String get devicesSubtitleEmpty =>
      'Po sparowaniu urządzenia współdzielą jeden schowek';

  @override
  String devicesSubtitle(int paired, int online) {
    return 'Sparowane: $paired, online: $online';
  }

  @override
  String get addDevice => 'Dodaj urządzenie';

  @override
  String thisDeviceFootnote(String both) {
    return 'Podczas parowania $both pokazują te same dwa wiersze odcisków bezpieczeństwa, po jednym dla każdego urządzenia. Potwierdź tylko wtedy, gdy zgadzają się co do znaku.';
  }

  @override
  String get noDevicesTitle => 'Brak sparowanych urządzeń';

  @override
  String get noDevicesBody =>
      'Otwórz PasteFerry na drugim komputerze i połącz oba 6-znakowym kodem parowania. W tej samej sieci można też otworzyć „Szukaj w pobliżu” na obu i kliknąć drugi komputer.';

  @override
  String get pairedDevices => 'Sparowane urządzenia';

  @override
  String get pairedFootnote =>
      'Bezpośrednio: dane są przesyłane wprost między dwoma urządzeniami. Przekaźnik: gdy sieć blokuje połączenie bezpośrednie, dane idą przez Twój serwer i pozostają szyfrowane end-to-end.';

  @override
  String get offline => 'Offline';

  @override
  String get direct => 'Bezpośrednio';

  @override
  String get relay => 'Przekaźnik';

  @override
  String get online => 'Online';

  @override
  String get moreActions => 'Więcej';

  @override
  String get copyFingerprint => 'Kopiuj odcisk';

  @override
  String get unpairEllipsis => 'Usuń parowanie…';

  @override
  String get fingerprintCopied => 'Skopiowano odcisk';

  @override
  String unpairTitle(String name) {
    return 'Usunąć parowanie z „$name”?';
  }

  @override
  String get unpairBody =>
      'Te dwa urządzenia przestaną się synchronizować. Aby znów je zsynchronizować, trzeba je ponownie sparować i sprawdzić odciski.';

  @override
  String get unpair => 'Usuń parowanie';

  @override
  String get unpaired => 'Usunięto parowanie';

  @override
  String get enterAddressEllipsis => 'Wpisz jego adres…';

  @override
  String setAddressTitle(String name) {
    return 'Adres urządzenia „$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Przydatne, gdy urządzenia są w różnych podsieciach lub oba zmieniły adresy. Wpisz adres widoczny na urządzeniu „$name” w sekcji Dodaj urządzenie → Pokaż kod.';
  }

  @override
  String get addressSaved => 'Szukanie pod tym adresem';

  @override
  String get lanBlockedTitle => 'macOS blokuje dostęp do sieci lokalnej';

  @override
  String lanBlockedBody(String device) {
    return 'Włącz PasteFerry Daemon w Ustawieniach systemowych → Prywatność i ochrona → Sieć lokalna. Do tego czasu $device nie może łączyć się z urządzeniami w tej sieci.';
  }

  @override
  String get searchNearby => 'Szukaj w pobliżu';

  @override
  String get nearbyTitle => 'Urządzenia w pobliżu';

  @override
  String get nearbySearching => 'Wyszukiwanie urządzeń w pobliżu…';

  @override
  String get nearbyHint =>
      'Otwórz „Szukaj w pobliżu” również na drugim komputerze, a pojawi się on tutaj. Kliknij go, aby sparować.';

  @override
  String nearbyVisible(String device) {
    return 'Gdy to okno jest otwarte, $device pokazuje swoją nazwę urządzeniom w tej sieci.';
  }

  @override
  String get nearbyPaired => 'Sparowano';

  @override
  String nearbyRequesting(String name) {
    return 'Łączenie z „$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '„$name” nie odpowiada. Upewnij się, że „Szukaj w pobliżu” jest tam nadal otwarte.';
  }

  @override
  String get nearbyLanOffTitle => 'Wykrywanie w sieci lokalnej jest wyłączone';

  @override
  String get nearbyLanOffBody =>
      'Włącz „Znajduj urządzenia w tej sieci” w Ustawieniach → Połączenie, aby widzieć urządzenia w pobliżu, lub sparuj za pomocą kodu.';

  @override
  String get generateCode => 'Pokaż kod';

  @override
  String get enterCode => 'Wpisz kod';

  @override
  String get codeFailedTitle => 'Nie można utworzyć kodu parowania';

  @override
  String get enterOnOther => 'Wpisz ten kod na drugim urządzeniu';

  @override
  String get codeCopied => 'Skopiowano kod';

  @override
  String get codeHint => 'Kliknij, aby skopiować. Ważny przez 5 minut.';

  @override
  String afterEnterFootnote(String both) {
    return 'Po wpisaniu kodu $both pokażą te same dwa wiersze odcisków bezpieczeństwa. Potwierdź tylko, jeśli się zgadzają.';
  }

  @override
  String get codeInvalid => 'Kod parowania ma 6 liter lub cyfr';

  @override
  String get localAddress => 'Adres';

  @override
  String get addressHint =>
      'Inna podsieć? Wpisz ten adres również na drugim urządzeniu.';

  @override
  String get addressCopied => 'Skopiowano adres';

  @override
  String get differentSubnet => 'Inna podsieć?';

  @override
  String get peerAddress => 'Adres widoczny pod kodem';

  @override
  String get pairNotFound =>
      'Nie znaleziono tego urządzenia. Jeśli jest w innej podsieci, wpisz adres widoczny pod jego kodem.';

  @override
  String get pairNotFoundAddress =>
      'Pod tym adresem nic nie odpowiada. Sprawdź adres i to, czy drugie urządzenie nadal pokazuje kod. Połączenie może też blokować zapora na tamtym urządzeniu.';

  @override
  String get codeWrong => 'Kod jest nieprawidłowy lub wygasł';

  @override
  String get codeExpired => 'Ten kod wygasł. Pokaż nowy na drugim urządzeniu.';

  @override
  String get addressInvalid =>
      'Nieprawidłowy adres. Wpisz coś w rodzaju 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Najpierw włącz wykrywanie w sieci lokalnej lub ustaw serwer w Ustawieniach → Połączenie.';

  @override
  String get enterCodeShown => 'Wpisz kod widoczny na drugim urządzeniu';

  @override
  String get pairingDone => 'Sparowano';

  @override
  String get pairingRejected => 'Odrzucono parowanie';

  @override
  String get verifyTitle => 'Sprawdź odciski bezpieczeństwa';

  @override
  String pairingWith(String name) {
    return 'Parowanie z „$name”';
  }

  @override
  String verifyBody(String both) {
    return 'Dwa wiersze, które pokazują $both, muszą być identyczne. Jeśli różni się choćby jeden znak, ktoś może ingerować w połączenie — odrzuć.';
  }

  @override
  String get rejectMismatch => 'Nie zgadzają się, odrzuć';

  @override
  String get confirmMatch => 'Zgadzają się, sparuj';

  @override
  String get server => 'Serwer (opcjonalnie)';

  @override
  String get signalingUrl => 'Serwer sygnalizacyjny';

  @override
  String get signalingUrlDesc =>
      'Pozostaw puste, aby synchronizować tylko lokalnie';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'Lepsze połączenia bezpośrednie';

  @override
  String get publicStunDesc =>
      'Publiczne serwery widzą Twój publiczny adres IP';

  @override
  String get connectionStatus => 'Połączenie';

  @override
  String get disconnectedDesc => 'Sprawdź adres serwera i jego dostępność';

  @override
  String get connected => 'Połączono';

  @override
  String get notConnected => 'Brak połączenia';

  @override
  String get notSet => 'Nie ustawiono';

  @override
  String get serverCleared =>
      'Usunięto serwer. Synchronizacja tylko w tej sieci.';

  @override
  String get localNetwork => 'Sieć lokalna';

  @override
  String get lanDiscovery => 'Znajduj urządzenia w tej sieci';

  @override
  String get lanDiscoveryDesc =>
      'Anonimowe wykrywanie; nazwy są widoczne tylko podczas „Szukaj w pobliżu”';

  @override
  String get macLocalNetwork => 'Dostęp do sieci lokalnej';

  @override
  String get macLocalNetworkDesc =>
      'Zezwól na PasteFerry Daemon w Ustawieniach systemowych';

  @override
  String get allowLan => 'Zapora systemu Windows';

  @override
  String get allowLanDesc =>
      'Przepuść zablokowane połączenia; wymaga zgody administratora';

  @override
  String get allow => 'Zezwól';

  @override
  String get allowLanDone =>
      'Zezwolono. Inne urządzenia mogą teraz łączyć się z tym urządzeniem.';

  @override
  String get deviceName => 'Nazwa urządzenia';

  @override
  String get language => 'Język';

  @override
  String get languageSystem => 'Jak w systemie';

  @override
  String get sync => 'Synchronizacja';

  @override
  String get autoSyncLimit => 'Limit automatycznej synchronizacji';

  @override
  String get autoSyncLimitDesc =>
      'Większe elementy odbieraj ręcznie z Historii';

  @override
  String get autoApply => 'Umieszczaj odebrane elementy w schowku';

  @override
  String get whatToSync => 'Co synchronizować';

  @override
  String get syncFiles => 'Pliki i foldery';

  @override
  String get syncText => 'Zwykły tekst';

  @override
  String get syncRich => 'Tekst sformatowany';

  @override
  String get syncImages => 'Obrazy i zrzuty ekranu';

  @override
  String get storage => 'Pamięć';

  @override
  String get storageFootnote =>
      'Wygasła historia i pliki w pamięci podręcznej są usuwane automatycznie.';

  @override
  String get keepHistory => 'Przechowywanie historii';

  @override
  String get keepCache => 'Przechowywanie plików podręcznych';

  @override
  String get keepCacheDesc => 'Nie dłużej niż historia';

  @override
  String get cacheUsage => 'Rozmiar pamięci podręcznej';

  @override
  String get backgroundSync => 'Synchronizacja w tle';

  @override
  String get backgroundService => 'Usługa w tle';

  @override
  String get backgroundServiceDesc =>
      'Uruchamia się po zalogowaniu; synchronizuje przy zamkniętym oknie';

  @override
  String get restart => 'Uruchom ponownie';

  @override
  String get restarted => 'Uruchomiono ponownie usługę w tle';

  @override
  String get disableEllipsis => 'Wyłącz…';

  @override
  String get about => 'O aplikacji';

  @override
  String get aboutDesc => 'Oprogramowanie open source na licencji AGPL-3.0';

  @override
  String get homepage => 'Strona internetowa';

  @override
  String get feedback => 'Zgłoś problem';

  @override
  String get disableTitle => 'Wyłączyć synchronizację w tle?';

  @override
  String disableBody(String device) {
    return 'PasteFerry przestanie synchronizować, a $device nie będzie go uruchamiać po zalogowaniu. Historia i parowania zostaną zachowane.';
  }

  @override
  String get disable => 'Wyłącz';

  @override
  String get disabled => 'Synchronizacja w tle jest wyłączona';

  @override
  String get urlMustBeWs => 'Adres musi zaczynać się od ws:// lub wss://';

  @override
  String get serverUpdated => 'Zaktualizowano serwer. Ponowne łączenie…';

  @override
  String get deviceNameUpdated => 'Zaktualizowano nazwę urządzenia';

  @override
  String get diagIntro =>
      'Raport zawiera wersję aplikacji, informacje o systemie, ustawienia, urządzenia i najnowsze logi. Nazwy urządzeń, adres serwera, publiczne adresy IP, folder użytkownika i nazwy plików są zastępowane, a kopiowana treść nigdy nie trafia do logów. Zgłoszenia na GitHubie są publiczne, więc przed wysłaniem przeczytaj raport.';

  @override
  String get diagVerboseTitle => 'Szczegółowe logi';

  @override
  String get diagVerboseDesc =>
      'Przy problemach z połączeniem: włącz, odtwórz problem, a potem wróć po raport. Wyłącza się automatycznie po 30 minutach.';

  @override
  String get diagVerboseOn => 'Włącz na 30 minut';

  @override
  String diagVerboseUntil(String time) {
    return 'Włączone do $time';
  }

  @override
  String get diagVerboseOff => 'Wyłącz';

  @override
  String get diagRefresh => 'Wygeneruj ponownie';

  @override
  String get diagSave => 'Zapisz jako plik';

  @override
  String diagSaved(String name) {
    return 'Zapisano w folderze Pobrane: $name';
  }

  @override
  String get diagCopy => 'Kopiuj raport';

  @override
  String get diagCopied => 'Skopiowano raport';

  @override
  String get diagNewIssue => 'Nowe zgłoszenie na GitHubie';

  @override
  String get diagIssueHint =>
      'Skopiowano raport. Wklej go w zgłoszeniu w polu „Diagnostics report”.';

  @override
  String diagFailed(String detail) {
    return 'Nie można utworzyć raportu: $detail';
  }

  @override
  String get svcExtractTitle => 'Najpierw zainstaluj lub rozpakuj PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry działa bezpośrednio z archiwum ZIP, a jego folder tymczasowy znika po zamknięciu. Uruchom instalator albo rozpakuj cały folder i otwórz aplikację stamtąd, aby włączyć synchronizację w tle.';

  @override
  String get svcMoveTitle =>
      'Najpierw przenieś PasteFerry do folderu Aplikacje';

  @override
  String get svcMoveBody =>
      'PasteFerry działa bezpośrednio z obrazu dysku. Przeciągnij aplikację do folderu Aplikacje, wysuń obraz dysku i otwórz ją z folderu Aplikacje, aby włączyć synchronizację w tle.';

  @override
  String get svcStartTitle => 'Pierwsze kroki z PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry synchronizuje schowek za pomocą małego procesu w tle. Zamknięcie okna go nie zatrzymuje. Uruchamianie po zalogowaniu to osobne ustawienie, w nowych instalacjach wyłączone.';

  @override
  String get svcEnable => 'Włącz synchronizację w tle';

  @override
  String get svcStaleTitle => 'Włącz ponownie synchronizację w tle';

  @override
  String get svcStaleBodyWin =>
      'Aplikację PasteFerry przeniesiono, ale uruchamianie po zalogowaniu nadal wskazuje stare miejsce. Włącz ponownie, aby proces w tle używał tej kopii. Historia i parowania zostaną zachowane.';

  @override
  String get svcStaleBodyMac =>
      'Aplikację PasteFerry przeniesiono lub zainstalowano starym skryptem. Włącz ponownie, aby proces w tle używał tej aplikacji. Historia i parowania zostaną zachowane.';

  @override
  String get svcReenable => 'Włącz ponownie';

  @override
  String get svcStoppedTitle => 'Usługa w tle nie działa';

  @override
  String get svcStoppedBody =>
      'Usługa w tle jest zatrzymana. Uruchom ją przyciskiem poniżej; uruchamianie po zalogowaniu ustawia się osobno w Ustawieniach.';

  @override
  String get svcDevBodyWin =>
      'To wersja deweloperska bez pliku pasteferryd.exe obok. Uruchom scripts\\build-windows.ps1 w folderze ze źródłami, aby zbudować pełną wersję.';

  @override
  String get svcDevBodyLinux =>
      'To wersja deweloperska bez pliku pasteferryd obok. Uruchom ./scripts/package-linux.sh w folderze ze źródłami, aby zbudować pełną wersję.';

  @override
  String get svcDevBodyMac =>
      'To wersja deweloperska bez usługi w tle. Uruchom ./scripts/install-macos.sh w folderze ze źródłami, aby ją zainstalować.';

  @override
  String svcLogPath(String path) {
    return 'Log: $path';
  }

  @override
  String get svcCanDisable =>
      'Synchronizację w tle można w każdej chwili wyłączyć w Ustawieniach.';

  @override
  String get officialService => 'Usługa';

  @override
  String get useOfficialService => 'Używaj usługi';

  @override
  String get officialServiceDesc =>
      'Synchronizacja między sieciami, najpierw połączenia bezpośrednie';

  @override
  String get officialPrivacy =>
      'Połączenie z usługą następuje tylko po jej włączeniu i zapisywane są wyłącznie niezbędne informacje o połączeniu. Najpierw próbowane jest połączenie bezpośrednie; o dostęp do przekaźnika aplikacja prosi tylko, gdy się nie uda. Nie są wysyłane treści, prawdziwe nazwy urządzeń ani surowe identyfikatory systemu.';

  @override
  String get officialEnableTitle => 'Włączyć usługę?';

  @override
  String get officialSwitchConfirm =>
      'Zastąpi to Twój własny serwer. Jego zapisany adres zostanie zachowany.';

  @override
  String get customServer => 'Własny serwer';

  @override
  String get saveAndConnect => 'Zapisz i połącz';

  @override
  String get officialLoading => 'Sprawdzanie limitu…';

  @override
  String get officialFetchFailed =>
      'Nie można teraz pobrać limitu. Ponowna próba nastąpi automatycznie.';

  @override
  String get officialUnavailable =>
      'Dane o użyciu są niedostępne; dotychczasowe dane mogą być nieaktualne';

  @override
  String get officialQuotaTitle => 'Wykorzystano dzienny limit przekaźnika';

  @override
  String get officialQuotaBody =>
      'Przekaźnik usługi jest wstrzymany do codziennego resetu o północy czasu pekińskiego. Połączenia w sieci lokalnej i bezpośrednie przez internet nadal działają. Nieudane przesyłanie można ponowić później.';

  @override
  String get officialPeerQuota =>
      'Drugie urządzenie wykorzystało limit przekaźnika. Połączenia bezpośrednie nadal działają.';

  @override
  String get officialPaused =>
      'Przekaźnik usługi jest niedostępny. Połączenia bezpośrednie nadal działają.';

  @override
  String get officialViewUsage => 'Pokaż użycie';

  @override
  String get officialAcknowledge => 'OK';

  @override
  String get officialToday => 'Dzisiejszy limit przekaźnika';

  @override
  String get officialUsed => 'Wykorzystano';

  @override
  String get officialRemaining => 'Pozostało';

  @override
  String get officialDailyLimit => 'Limit dzienny';

  @override
  String get officialUpload => 'Wysyłanie';

  @override
  String get officialDownload => 'Pobieranie';

  @override
  String get officialReset => 'Godzina resetu (Pekin)';

  @override
  String get officialUpdated => 'Ostatnia aktualizacja';

  @override
  String get officialRoutes => 'Sposób łączenia urządzeń';

  @override
  String get officialRoutesFootnote =>
      'Połączenia bezpośrednie nie przechodzą przez przekaźnik usługi i nie zużywają limitu.';

  @override
  String get officialDeviceID => 'ID urządzenia';

  @override
  String get officialWarning =>
      'Wykorzystano 90% dziennego limitu przekaźnika. Połączenia bezpośrednie go nie zużywają.';

  @override
  String get updateCheck => 'Sprawdź aktualizacje';

  @override
  String get updateCheckEllipsis => 'Sprawdź aktualizacje…';

  @override
  String get updateAuto => 'Automatycznie sprawdzaj aktualizacje';

  @override
  String get updateChecking => 'Sprawdzanie aktualizacji…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version to najnowsza wersja.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'Dostępna jest wersja PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Obecna wersja: $current. Rozmiar pobierania: $size.';
  }

  @override
  String get updateNew => 'Nowości';

  @override
  String get updateFixed => 'Poprawki';

  @override
  String get updateSkip => 'Pomiń tę wersję';

  @override
  String get updateLater => 'Później';

  @override
  String get updateInstall => 'Pobierz i zainstaluj';

  @override
  String updateDownloading(String done, String total) {
    return 'Pobieranie: $done z $total';
  }

  @override
  String get updateVerifying => 'Sprawdzanie pobranego pliku…';

  @override
  String get updateInstalling =>
      'Instalowanie. PasteFerry uruchomi się ponownie automatycznie.';

  @override
  String get updateInstallingPassword =>
      'Instalowanie. System poprosi o hasło, ponieważ /opt wymaga uprawnień administratora; potem PasteFerry uruchomi się ponownie automatycznie.';

  @override
  String get updateCheckFailed =>
      'Nie można połączyć się z GitHubem ani Gitee. Spróbuj ponownie później.';

  @override
  String get updateDownloadFailed =>
      'Pobieranie nie zostało ukończone. Spróbuj ponownie lub pobierz nową wersję ze strony internetowej.';

  @override
  String updateInstallFailed(String error) {
    return 'Nie można rozpocząć instalacji: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Ta kompilacja nie może sprawdzać aktualizacji.';

  @override
  String get updateBlockedDev =>
      'To wersja deweloperska, więc nie może aktualizować się sama.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry działa z obrazu dysku. Przeciągnij aplikację do folderu Aplikacje i otwórz ją stamtąd, aby aktualizować automatycznie.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry nie może zapisywać w swoim folderze instalacyjnym. Pobierz nową wersję ze strony internetowej.';

  @override
  String get updateBlockedUnsupported =>
      'Dla tego komputera nie ma automatycznych aktualizacji. Pobierz nową wersję ze strony internetowej.';

  @override
  String get updateOpenDownload => 'Otwórz stronę pobierania';

  @override
  String updateSidebar(String version) {
    return 'Dostępna jest wersja $version';
  }

  @override
  String updatedTo(String version) {
    return 'Zaktualizowano do wersji $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Aktualizacja nie została ukończona. Nadal używana jest wersja $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Aktualizacja nie została ukończona. Nadal używana jest wersja $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Interfejs $uiVersion · Usługa $serviceVersion · Kompilacja $build';
  }

  @override
  String get notReceived => 'Nie odebrano — odbierz przed wklejeniem';

  @override
  String get receivedPreserved =>
      'Odebrano; użyj „Kopiuj do schowka”, gdy będzie potrzebne';

  @override
  String get clipboardWriteFailed =>
      'Odebrano, ale nie udało się zaktualizować schowka';

  @override
  String get receivingStatus => 'Odbieranie…';

  @override
  String get largeFileNotifications => 'Przypomnienia o dużych plikach';

  @override
  String get notificationsAllowed =>
      'Powiadomienia są włączone. Postęp widać w Historii.';

  @override
  String get notificationsNotRequested =>
      'Włącz powiadomienia, aby duże pliki nie czekały niezauważone. Zawsze można je odebrać z Historii.';

  @override
  String get notificationsDenied =>
      'Powiadomienia są zablokowane w ustawieniach systemu. Odbierz oczekujące elementy z Historii.';

  @override
  String get notificationsUnknown =>
      'Wyświetlanie powiadomień i tryb „Nie przeszkadzać” zależą od środowiska pulpitu. Jeśli przypomnienie się nie pojawi, odbierz elementy z Historii.';

  @override
  String get notificationsUnavailable =>
      'Powiadomienia systemowe są niedostępne. Odbieraj duże pliki z Historii.';

  @override
  String get enableNotifications => 'Włącz przypomnienia';

  @override
  String get notificationSettings => 'Ustawienia powiadomień';

  @override
  String get notifyPendingTitle => 'Odbierz, aby wkleić';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nOdbierz ten element przed wklejeniem. Można go też odebrać z Historii.';
  }

  @override
  String get notifyReceivingTitle => 'Odbieranie…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nPostęp widać w Historii.';
  }

  @override
  String get notifyReadyTitle => 'Gotowe do wklejenia';

  @override
  String notifyReadyBody(String name) {
    return '$name\nOdebrano i umieszczono w schowku.';
  }

  @override
  String get notifyReceivedTitle => 'Odebrano';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nZawartość schowka została zachowana. Użyj „Kopiuj do schowka”, gdy będzie potrzebne; opcja jest też dostępna w Historii.';
  }

  @override
  String get notifyFailedTitle => 'Nie można odebrać';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nSpróbuj ponownie z tego powiadomienia lub z Historii.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Odebrano; schowek nie został zaktualizowany';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUżyj „Kopiuj do schowka”, aby spróbować ponownie — tutaj lub w Historii.';
  }

  @override
  String get reconnect => 'Połącz ponownie';

  @override
  String get reconnecting => 'Łączenie…';

  @override
  String get reconnectDirect => 'Połączono bezpośrednio';

  @override
  String get reconnectRelay =>
      'Nie udało się połączyć bezpośrednio, nadal przez przekaźnik';

  @override
  String reconnectOffline(String name) {
    return '„$name” jest offline. Upewnij się, że PasteFerry jest tam otwarty.';
  }

  @override
  String get reconnectPending => 'Nadal trwa łączenie, sprawdź za chwilę';

  @override
  String get renameAction => 'Zmień nazwę';

  @override
  String get renameFavoriteTitle => 'Zmień nazwę ulubionego';

  @override
  String get renameFavoriteHint =>
      'Wyświetlana w Ulubionych i w szybkim wklejaniu; można jej też szukać. Pozostaw puste, aby znów pokazywać zawartość.';

  @override
  String get renamedToast => 'Zmieniono nazwę';

  @override
  String get aliasClearedToast => 'Znów pokazywana jest zawartość';

  @override
  String get navSend => 'Wysyłanie plików';

  @override
  String get sendSubtitle =>
      'Przeciągnij pliki na urządzenie, aby wysłać je bezpośrednio';

  @override
  String get sendNoDevicesTitle => 'Brak sparowanych urządzeń';

  @override
  String get sendNoDevicesBody =>
      'Najpierw sparuj inny komputer, a potem wysyłaj do niego pliki tutaj.';

  @override
  String get sendDropHint => 'Upuść na urządzenie, aby wysłać';

  @override
  String sendReleaseTo(String name) {
    return 'Puść, aby wysłać do: $name';
  }

  @override
  String get sendLan => 'Sieć lokalna';

  @override
  String sendRelayLeft(String left) {
    return 'Przekaźnik · dziś pozostało $left';
  }

  @override
  String get sendNeedsUpdate => 'Wymaga aktualizacji';

  @override
  String sendNeedsUpdateTip(String name) {
    return 'Odbieranie plików przez $name będzie możliwe po aktualizacji do PasteFerry 2.5 lub nowszej.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Łączenie z: $name. Wysyłanie będzie możliwe po połączeniu.';
  }

  @override
  String get sendNotReceiving => 'Nie odbiera plików';

  @override
  String get sendDelivered => 'Dostarczono';

  @override
  String sendToTitle(String name) {
    return 'Wyślij do: $name';
  }

  @override
  String get sendDropHere => 'Przeciągnij tutaj pliki lub foldery';

  @override
  String get sendDropStarts => 'Wysyłanie zaczyna się od razu po upuszczeniu';

  @override
  String get sendChooseFiles => 'Wybierz pliki…';

  @override
  String get sendChooseFolder => 'Wybierz folder…';

  @override
  String get sendDropMore =>
      'Upuść więcej plików, aby wysłać je w następnej kolejności';

  @override
  String sendSavedWhere(String name) {
    return 'Pliki są zapisywane w miejscu wybranym na urządzeniu $name — domyślnie w folderze Pobrane.';
  }

  @override
  String get sendCloseKeeps => 'Zamknięcie tego okna nie przerywa wysyłania';

  @override
  String get sendRemoveQueued => 'Usuń';

  @override
  String get sendCannotDrop =>
      'Tego elementu nie można wysłać przez przeciągnięcie. Najpierw zapisz go jako plik albo użyj „Wybierz pliki…”.';

  @override
  String sendErrOffline(String name) {
    return '$name jest offline.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name nie odbiera plików.';
  }

  @override
  String get sendErrMissing => 'Niektóre z tych plików już nie istnieją.';

  @override
  String get relayConfirmTitle => 'Wysłać przez przekaźnik usługi?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name nie ma teraz bezpośredniego połączenia z tym komputerem, więc pliki pójdą przez przekaźnik usługi z prędkością ok. 0,25 MB/s. Z dzisiejszego limitu przekaźnika pozostało $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Te pliki ($size) przekraczają pozostały limit. Wysyłanie zatrzyma się, gdy limit się wyczerpie, i wznowi, gdy oba komputery połączą się bezpośrednio lub jutro limit się odnowi.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Zużyje to ok. $size z dzisiejszego limitu.';
  }

  @override
  String get relayExhausted =>
      'Dzisiejszy limit przekaźnika został wykorzystany. Odnowi się o północy czasu pekińskiego. Komputery połączone bezpośrednio nie mają limitu.';

  @override
  String get relayDontAskToday => 'Nie pytaj dziś ponownie dla tego urządzenia';

  @override
  String get relaySendAnyway => 'Wyślij mimo to';

  @override
  String get relayOwnServer =>
      'Przez przekaźnik — prędkość zależy od Twojego serwera';

  @override
  String get transfersReceived => 'Odebrane';

  @override
  String get transfersSent => 'Wysłane';

  @override
  String get transfersClearAll => 'Wyczyść wszystko';

  @override
  String get transfersClearTitle => 'Wyczyścić tę listę?';

  @override
  String get transfersClearBody =>
      'Czyszczona jest tylko lista. Pliki pozostaną na swoich miejscach.';

  @override
  String get transfersEmptyReceived =>
      'Tutaj pojawią się pliki wysłane przez inne urządzenia';

  @override
  String get transfersEmptySent => 'Tutaj pojawią się wysłane pliki';

  @override
  String transferFrom(String name) {
    return 'Od: $name';
  }

  @override
  String transferTo(String name) {
    return 'Do: $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name i jeszcze $others';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pliku',
      many: '$count plików',
      few: '$count pliki',
      one: '$count plik',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'W kolejce';

  @override
  String transferScanning(String count) {
    return 'Liczenie… znalezione pliki: $count';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Oczekiwanie na: $name…';
  }

  @override
  String get transferSending => 'Wysyłanie';

  @override
  String get transferReceiving => 'Odbieranie';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Teraz: $file ($index z $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Pozostało: $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sekundy',
      many: '$n sekund',
      few: '$n sekundy',
      one: '$n sekunda',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minuty',
      many: '$n minut',
      few: '$n minuty',
      one: '$n minuta',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h godz. $m min';
  }

  @override
  String get transferPaused =>
      'Wstrzymano: dzisiejszy limit przekaźnika został wykorzystany';

  @override
  String get transferInterrupted =>
      'Przerwano — wznowi się po ponownym połączeniu';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Przerwano — oczekiwanie na wznowienie przez: $name';
  }

  @override
  String get transferCancelled => 'Anulowano';

  @override
  String transferPeerCancelled(String name) {
    return 'Anulowane przez: $name';
  }

  @override
  String get transferExpired => 'Wygasło';

  @override
  String get transferMissing => 'Przeniesiono lub usunięto';

  @override
  String transferNotSent(String reason) {
    return 'Nie wysłano: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Nie odebrano: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name nie ma wystarczająco miejsca na dysku (brakuje $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'za mało miejsca na dysku (brakuje $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'miejsce zapisu na urządzeniu $name jest niedostępne';
  }

  @override
  String get reasonDestUnavailable =>
      'miejsce zapisu jest niedostępne — sprawdź je w Ustawieniach';

  @override
  String get reasonFileTooLarge =>
      'miejsce zapisu jest na dysku FAT32, który nie mieści plików większych niż 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name nie odbiera plików';
  }

  @override
  String get reasonSourceChanged => 'plik zmienił się w trakcie wysyłania';

  @override
  String get reasonSourceMissing => 'plik już nie istnieje';

  @override
  String get reasonReadError => 'nie można odczytać pliku';

  @override
  String get reasonWriteFailed => 'nie można zapisać plików';

  @override
  String get reasonHashMismatch => 'plik został uszkodzony podczas przesyłania';

  @override
  String reasonUnsupported(String name) {
    return '$name wymaga aktualizacji, aby odbierać pliki';
  }

  @override
  String get reasonOther => 'coś poszło nie tak';

  @override
  String get revealInFinder => 'Pokaż w Finderze';

  @override
  String get revealInFolder => 'Pokaż w folderze';

  @override
  String get revealOpenFolder => 'Otwórz folder';

  @override
  String get transferResend => 'Wyślij ponownie';

  @override
  String get transferRemove => 'Usuń z listy';

  @override
  String get transferCopyPath => 'Kopiuj ścieżkę';

  @override
  String get transferPathCopied => 'Skopiowano ścieżkę';

  @override
  String sendingTo(String name, String percent) {
    return 'Wysyłanie do: $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Odbieranie od: $name · $percent';
  }

  @override
  String get receiveFiles => 'Odbieraj pliki z innych urządzeń';

  @override
  String get saveTo => 'Zapisuj w';

  @override
  String get saveToChange => 'Zmień…';

  @override
  String get saveToDefault => 'Pobrane (domyślnie)';

  @override
  String get saveToUseDefault => 'Użyj folderu Pobrane';

  @override
  String get receiveNotify => 'Powiadamiaj o nadejściu plików';

  @override
  String receiveFootnote(String device) {
    return 'Tylko sparowane urządzenia mogą wysyłać pliki; odbiera je $device. Podczas przesyłania plików $device nie przejdzie samoczynnie w stan uśpienia.';
  }

  @override
  String get saveDirNotFound => 'Ten folder nie istnieje.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry nie może zapisywać plików w tym folderze.';

  @override
  String get saveDirPermission =>
      'PasteFerry nie ma dostępu do tego folderu. Zezwól na dostęp w Ustawieniach systemowych → Prywatność i ochrona → Pliki i foldery.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Nazwy plików ($count) zawierały znaki niedozwolone w Windows; zastąpiono je podobnymi znakami pełnej szerokości',
      many:
          '$count nazw plików zawierało znaki niedozwolone w Windows; zastąpiono je podobnymi znakami pełnej szerokości',
      few:
          '$count nazwy plików zawierały znaki niedozwolone w Windows; zastąpiono je podobnymi znakami pełnej szerokości',
      one:
          '$count nazwa pliku zawierała znaki niedozwolone w Windows; zastąpiono je podobnymi znakami pełnej szerokości',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Ta sama sieć';

  @override
  String get sendRingOther => 'Inne sieci';

  @override
  String sendOfflineList(String names) {
    return 'Offline: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Lista przesyłania';

  @override
  String get sendLayoutSide => 'Obok radaru';

  @override
  String get sendLayoutBelow => 'Pod radarem';

  @override
  String get general => 'Ogólne';

  @override
  String get launchAtLogin => 'Uruchamiaj po zalogowaniu';

  @override
  String get launchAtLoginDesc =>
      'Uruchamia aplikację w tle po zalogowaniu. Zmiana nie zatrzymuje bieżącej sesji.';

  @override
  String get realtimeSync => 'Synchronizacja schowka w czasie rzeczywistym';

  @override
  String get realtimeSyncDesc =>
      'Automatycznie udostępniaj nowo skopiowane elementy sparowanym urządzeniom. Po wyłączeniu lokalna historia i Wysyłanie plików nadal działają.';

  @override
  String get syncBacklog => 'Nadrabiaj po ponownym połączeniu';

  @override
  String get syncBacklogDesc =>
      'Domyślnie wyłączone: pominięte kopie są ignorowane. Po włączeniu do historii trafia do 20 kopii z ostatnich 24 godzin, bez zastępowania zawartości schowka.';

  @override
  String get peerRealtimeSync => 'Synchronizuj z tym komputerem';

  @override
  String get syncPaused => 'Synchronizacja schowka wstrzymana';

  @override
  String get quitApp => 'Zakończ PasteFerry';

  @override
  String get quitAppDesc =>
      'Zatrzymuje wszystkie procesy PasteFerry. Ustawienie uruchamiania po zalogowaniu zostaje zachowane.';

  @override
  String get quitTransfersWarning =>
      'Pliki są nadal przesyłane. Zakończyć i przerwać przesyłanie?';

  @override
  String get backgroundRunningTitle => 'PasteFerry będzie nadal działać';

  @override
  String get backgroundRunningBody =>
      'Po zamknięciu okna synchronizacja i szybkie wklejanie nadal działają. Aby zatrzymać wszystko, wybierz „Zakończ PasteFerry” w Ustawieniach lub w menu aplikacji.';

  @override
  String get displayAs => 'Wyświetlana nazwa';

  @override
  String get editName => 'Zmień nazwę';

  @override
  String get nameHint => 'Nazwa widoczna dla kontaktów';

  @override
  String get nameDefaultHint => 'Pozostaw puste, aby użyć nazwy konta.';

  @override
  String get avatarTitle => 'Zdjęcie profilowe';

  @override
  String get avatarChoose => 'Wybierz obraz…';

  @override
  String get avatarPaste => 'Wklej obraz';

  @override
  String get avatarReset => 'Użyj domyślnego zdjęcia';

  @override
  String get avatarZoom => 'Powiększenie';

  @override
  String get avatarDragHint => 'Przeciągnij, aby przesunąć zdjęcie.';

  @override
  String get avatarNoImage => 'W schowku nie ma obrazu.';

  @override
  String get avatarBad =>
      'Nie można użyć tego obrazu. Wybierz plik PNG, JPEG lub GIF.';

  @override
  String get done => 'Gotowe';

  @override
  String get friendsTitle => 'Kontakty';

  @override
  String get addFriend => 'Dodaj kontakt';

  @override
  String get friendsEmpty => 'Brak kontaktów';

  @override
  String get friendsEmptyBody =>
      'Dodaj kogoś, kto też używa PasteFerry, aby wysyłać sobie pliki bez parowania. Kontakty mogą tylko wysyłać pliki; nigdy nie widzą Twojego schowka.';

  @override
  String get friendSendAction => 'Wyślij…';

  @override
  String get friendHistory => 'Przesłane pliki';

  @override
  String friendHistoryTitle(String name) {
    return 'Przesyłanie z: $name';
  }

  @override
  String get friendHistoryEmpty => 'Brak przesłanych plików.';

  @override
  String get friendAutoAccept => 'Akceptuj pliki automatycznie';

  @override
  String get friendRemove => 'Usuń kontakt';

  @override
  String friendRemoveTitle(String name) {
    return 'Usunąć kontakt $name?';
  }

  @override
  String get friendRemoveBody =>
      'Kontakt zostanie usunięty po obu stronach i nie będzie już można wysyłać sobie plików. Wcześniej przesłane pliki pozostaną na tym komputerze.';

  @override
  String friendLastActivity(String time) {
    return 'Ostatnie przesyłanie: $time';
  }

  @override
  String get friendNoActivity => 'Brak przesłanych plików';

  @override
  String get friendCodeShare =>
      'Wyślij ten kod drugiej osobie. Gdy wpisze go w PasteFerry, kontakt zostanie dodany po obu stronach.';

  @override
  String friendCodeExpires(String time) {
    return 'Wygasa za $time';
  }

  @override
  String get friendCodeOr => 'lub';

  @override
  String get friendCodeEnter => 'Wpisz kod kontaktu drugiej osoby';

  @override
  String get friendCodeAdd => 'Dodaj';

  @override
  String get friendCodeWaiting => 'Oczekiwanie na wpisanie kodu…';

  @override
  String friendConfirmBody(String name) {
    return 'Dodać $name do kontaktów?';
  }

  @override
  String get friendSafetyCode => 'Sprawdź kod bezpieczeństwa (opcjonalnie)';

  @override
  String get friendSafetyHint =>
      'Gdy jesteście obok siebie, porównajcie te dwa wiersze. Jeśli są takie same na obu komputerach, nikt nie ingerował w połączenie.';

  @override
  String get friendWaitingPeer => 'Oczekiwanie na dodanie przez drugą osobę…';

  @override
  String friendAdded(String name) {
    return 'Dodano $name do kontaktów';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name: anulowano';
  }

  @override
  String get friendErrFriendCode =>
      'To jest kod kontaktu. Wpisz go w „Dodaj kontakt” na stronie Wysyłanie plików.';

  @override
  String get friendErrDeviceCode =>
      'To jest kod parowania. Wpisz go w Urządzenia → Dodaj urządzenie.';

  @override
  String get friendErrOutdated =>
      'Druga osoba potrzebuje PasteFerry 2.6.0 lub nowszego.';

  @override
  String get friendErrAlreadyPaired =>
      'Ten komputer jest już jednym z Twoich urządzeń.';

  @override
  String get friendErrNoChannel =>
      'Nie jesteście w tej samej sieci. Włączcie usługę na obu komputerach, aby dodać się nawzajem.';

  @override
  String get openService => 'Włącz usługę…';

  @override
  String get noteLabel => 'Notatka (opcjonalnie)';

  @override
  String get noteHintEmpty => 'Najpierw wybierz pliki';

  @override
  String get noteHint => 'Na przykład: proszę podpisać stronę 3';

  @override
  String noteLine(String note) {
    return 'Notatka: $note';
  }

  @override
  String get sendAction => 'Wyślij';

  @override
  String sendItemsSummary(String count, String size) {
    return 'Elementy: $count · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Upuść tutaj pliki lub obrazy albo wklej ($key)';
  }

  @override
  String get sendDropMorePaste => 'Upuść lub wklej więcej';

  @override
  String get sendPasteNothing =>
      'Nie ma nic do wklejenia. Najpierw skopiuj pliki lub obraz.';

  @override
  String get sendRemoveItem => 'Usuń';

  @override
  String sendFriendSaved(String name) {
    return '$name akceptuje każdą partię plików przed wysłaniem.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Oczekiwanie na akceptację: $name…';
  }

  @override
  String get transferAskingIn => 'Czeka na akceptację';

  @override
  String reasonDeclined(String name) {
    return '$name: odrzucono';
  }

  @override
  String reasonTimeout(String name) {
    return '$name: brak odpowiedzi';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name nie przyjmuje plików';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name nie przyjmuje teraz Twoich plików';
  }

  @override
  String get reasonYouDeclined => 'Odrzucono';

  @override
  String get reasonYouIgnored => 'Zignorowano';

  @override
  String get sendAgain => 'Wyślij ponownie';

  @override
  String incomingTitle(String name) {
    return '$name chce wysłać Ci pliki';
  }

  @override
  String get incomingAlways => 'Zawsze akceptuj pliki od tego kontaktu';

  @override
  String get incomingDecline => 'Odrzuć';

  @override
  String get incomingAccept => 'Akceptuj';

  @override
  String incomingCountdown(String seconds) {
    return 'Automatyczne odrzucenie za $seconds s';
  }

  @override
  String get incomingStranger => 'W pobliżu';

  @override
  String get friendsStrip => 'Kontakty';

  @override
  String get strangersStrip => 'W pobliżu z opcją „Wszyscy”';

  @override
  String get strangerNearby => 'W pobliżu';

  @override
  String get friendNeedService => 'Włącz usługę';

  @override
  String get friendCantReach => 'Nie można połączyć';

  @override
  String reachSelfNoService(String name) {
    return 'Ty i $name nie jesteście w tej samej sieci. Włącz usługę, aby wysyłać pliki; jeśli połączenie bezpośrednie nie jest możliwe, pójdą przez przekaźnik usługi.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name nie ma włączonej usługi, więc pliki można wysyłać tylko w tej samej sieci. Poproś o włączenie usługi w PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Nie używacie tego samego serwera. Aby wysyłać pliki, włączcie usługę na obu komputerach lub użyjcie tego samego serwera.';

  @override
  String get receiveFromLabel => 'Kto może wysyłać mi pliki:';

  @override
  String get receiveFromOff => 'Nikt';

  @override
  String get receiveFromFriends => 'Tylko kontakty';

  @override
  String get receiveFromEveryone => 'Wszyscy';

  @override
  String everyoneLeft(String minutes) {
    return 'Wszyscy · pozostało $minutes min';
  }

  @override
  String get receiveFromOffDesc =>
      'Pliki mogą wysyłać tylko Twoje sparowane komputery.';

  @override
  String get receiveFromFriendsDesc =>
      'Kontakty mogą wysyłać Ci pliki. Każdą partię trzeba zaakceptować.';

  @override
  String get receiveFromEveryoneDesc =>
      'Przez 10 minut każdy w tej samej sieci może wysyłać Ci pliki. Każdą partię trzeba zaakceptować.';

  @override
  String get everyoneEnded =>
      'Opcja „Wszyscy” wyłączona; przywrócono „Tylko kontakty”.';

  @override
  String get friendsCountTooltip => 'Kontakty';

  @override
  String get waitingAccept => 'Oczekiwanie…';

  @override
  String get settingsConnection => 'Połączenie';

  @override
  String get settingsGeneralSummary =>
      'Uruchamianie po zalogowaniu, nazwa urządzenia, język';

  @override
  String get settingsConnectionSummary => 'Usługa, własny serwer, sieć lokalna';

  @override
  String get settingsSyncSummary =>
      'Synchronizacja w czasie rzeczywistym, limit rozmiaru, co synchronizować';

  @override
  String get settingsQuickPasteSummary =>
      'Skrót i działanie po wybraniu elementu';

  @override
  String get settingsSendSummary => 'Odbieranie plików, miejsce zapisu';

  @override
  String get settingsStorageSummary =>
      'Czas przechowywania historii, zajęte miejsce';

  @override
  String get settingsAboutSummary => 'Wersja, aktualizacje, opinie';

  @override
  String get friendsSubtitle =>
      'Wysyłaj pliki na komputery innych osób, bez parowania';

  @override
  String get friendsSearch => 'Szukaj kontaktów';

  @override
  String get friendsNoMatch => 'Brak pasujących kontaktów';

  @override
  String get friendsPick =>
      'Wybierz kontakt, aby zobaczyć przesłane pliki lub wysłać nowe';

  @override
  String friendDropHint(String name) {
    return 'Upuść tutaj pliki, aby wysłać je do: $name';
  }

  @override
  String get webShareTitle => 'Przesyłanie przez przeglądarkę w telefonie';

  @override
  String get webShareFootnote =>
      'Zeskanuj kod QR telefonem, aby w przeglądarce wymieniać tekst, zdjęcia i pliki z tym komputerem — bez instalowania aplikacji. Telefon i komputer muszą być w tej samej sieci.';

  @override
  String get webShareSwitch =>
      'Zezwalaj telefonom na łączenie przez przeglądarkę';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Włączone, $count telefonu',
      many: 'Włączone, $count telefonów',
      few: 'Włączone, $count telefony',
      one: 'Włączone, $count telefon',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'Wyłączone';

  @override
  String get webShareShowQr => 'Pokaż kod QR';

  @override
  String get webShareDialogTitle => 'Zeskanuj telefonem';

  @override
  String get webShareDialogBody =>
      'Zeskanuj aparatem lub przeglądarką telefonu i otwórz stronę w przeglądarce. Każdy kod QR rejestruje jeden telefon i po użyciu jest zastępowany nowym.';

  @override
  String get webShareAddress => 'Adres';

  @override
  String get webShareSecurity =>
      'Treść jest szyfrowana na stronie, więc inni w tej sieci nie mogą jej odczytać. Sama strona działa jednak przez http i nie ochroni przed celową ingerencją. Używaj jej w domu lub w zaufanej sieci biurowej, nie w publicznym Wi-Fi.';

  @override
  String get webSharePhones => 'Zarejestrowane telefony';

  @override
  String get webShareNoPhones => 'Brak telefonów';

  @override
  String webShareLastUsed(String time) {
    return 'Ostatnio używany: $time';
  }

  @override
  String get webShareRemove => 'Usuń';

  @override
  String webShareRemoved(String name) {
    return 'Usunięto „$name”';
  }

  @override
  String webShareNewPhone(String name) {
    return 'Zarejestrowano „$name”';
  }

  @override
  String webShareNotListening(String error) {
    return 'Nie można rozpocząć nasłuchiwania: $error';
  }

  @override
  String get webSharePortFallback =>
      'Zwykły port jest zajęty, więc używany jest tymczasowy. Zapisane adresy nie otworzą się, dopóki telefony nie zeskanują kodu ponownie.';

  @override
  String get webShareNoAddress =>
      'Brak adresu w sieci lokalnej. Najpierw połącz się z Wi-Fi lub siecią przewodową.';

  @override
  String get webShareCantOpen =>
      'Jeśli strona nie otwiera się w telefonie, upewnij się, że oba urządzenia są w tej samej sieci (sieci dla gości zwykle nie działają). W Windows PasteFerry musi też mieć zezwolenie w zaporze.';

  @override
  String get mTabRecords => 'Historia';

  @override
  String get mTabSend => 'Wyślij';

  @override
  String get mThisPhone => 'Ten telefon';

  @override
  String get mThisPhoneInText => 'ten telefon';

  @override
  String mThisPhoneName(String name) {
    return 'Ten telefon: $name';
  }

  @override
  String get mSendTitle => 'Wyślij na komputer';

  @override
  String get mSendHint => 'Wpisz lub wklej tekst';

  @override
  String get mPaste => 'Wklej';

  @override
  String get mPhotosFiles => 'Zdjęcia lub pliki';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Wysłać pliki ($n)?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Wysłano $n pliku na komputer',
      many: 'Wysłano $n plików na komputer',
      few: 'Wysłano $n pliki na komputer',
      one: 'Wysłano $n plik na komputer',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'W schowku nie ma tekstu';

  @override
  String get mSendAction => 'Wyślij';

  @override
  String mSendTo(String names) {
    return 'Odbiorcy: $names';
  }

  @override
  String get mNoOnlineDevices => 'Brak urządzeń online w pobliżu';

  @override
  String get mNoPairedDevices => 'Najpierw sparuj telefon z komputerem';

  @override
  String get mSent => 'Wysłano';

  @override
  String get mSendFootnote =>
      'Tekst i pliki trafiają do historii na komputerze oraz, zależnie od jego ustawień, do jego schowka. To, co kopiujesz w telefonie, nie jest wysyłane samo.';

  @override
  String get mSentRecords => 'Wysłane';

  @override
  String get mSentRetention => 'Przechowuj wysłane';

  @override
  String mSentRetentionDesc(Object d) {
    return '„Wysłane” pokazuje, co ten telefon wysłał w ciągu ostatnich dni: $d';
  }

  @override
  String mSentRetentionDays(Object d) {
    return 'Dni: $d';
  }

  @override
  String get mViewAll => 'Pokaż wszystko';

  @override
  String get mClearCache => 'Wyczyść';

  @override
  String get mCheckUpdate => 'Sprawdź aktualizacje';

  @override
  String get mUpdateFailed => 'Nie można sprawdzić aktualizacji';

  @override
  String get mUpToDate => 'Masz najnowszą wersję';

  @override
  String mNewVersion(Object v) {
    return 'Dostępna jest wersja $v';
  }

  @override
  String get mDownloadInstall => 'Pobierz nową wersję';

  @override
  String mSendFailed(String detail) {
    return 'Nie można wysłać: $detail';
  }

  @override
  String get mCopy => 'Kopiuj';

  @override
  String get mCopied => 'Skopiowano do schowka telefonu';

  @override
  String get mShare => 'Udostępnij';

  @override
  String get mSaved => 'Zapisano w Zdjęciach lub w Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Nie udało się: $detail';
  }

  @override
  String get mDownloading => 'Pobieranie…';

  @override
  String get mNotDownloaded => 'Jeszcze nie pobrano';

  @override
  String get mDownloadHint =>
      'Zostanie najpierw pobrane po dotknięciu „Kopiuj”, „Zapisz” lub „Udostępnij”.';

  @override
  String get mFullTextLoading => 'Wczytywanie…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Pokazano pierwsze $shown z $total znaków. „Kopiuj” kopiuje całość.';
  }

  @override
  String get mNotOnLanTitle => 'Brak połączenia z Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Na razie PasteFerry synchronizuje tylko w sieci lokalnej. Połącz się z tą samą siecią Wi-Fi co komputer.';

  @override
  String mStartFailed(String detail) {
    return 'Nie można uruchomić PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Na komputerze otwórz PasteFerry → Urządzenia → Dodaj urządzenie, a następnie wpisz tutaj wyświetlony kod. W tej samej sieci Wi-Fi można też otworzyć „Szukaj w pobliżu” na obu urządzeniach.';

  @override
  String get mSectionSync => 'Synchronizacja';

  @override
  String get mSectionBackground => 'Działanie w tle';

  @override
  String get mAutoApplyDesc =>
      'Tekst skopiowany na komputerze trafia od razu do schowka telefonu. Obrazy i pliki czekają, aż dotkniesz „Kopiuj”.';

  @override
  String get mKeepAlive => 'Utrzymuj połączenie w tle';

  @override
  String get mKeepAliveDesc =>
      'Odbieraj tekst, nawet gdy PasteFerry nie jest otwarty. Wyświetla stałe powiadomienie.';

  @override
  String get mNotifications => 'Powiadomienia';

  @override
  String get mNotificationsDesc =>
      'Potrzebne do stałego powiadomienia. PasteFerry działa też bez nich.';

  @override
  String get mBattery => 'Działanie w tle';

  @override
  String get mBatteryDesc =>
      'Wyłącz optymalizację baterii, aby system nie zatrzymywał PasteFerry po zablokowaniu ekranu. Na niektórych telefonach trzeba też dodać PasteFerry do listy autostartu lub działania w tle w Ustawieniach.';

  @override
  String get mAllowed => 'Dozwolone';

  @override
  String get mAllow => 'Zezwól';

  @override
  String mVersion(String version) {
    return 'Wersja $version';
  }

  @override
  String get mDeleteConfirm => 'Usunąć ten element?';

  @override
  String get mDelete => 'Usuń';

  @override
  String get webShareFirewallPreparing =>
      'Sprawdzanie Zapory systemu Windows. Jeśli Windows poprosi o zgodę administratora, wybierz „Tak”, aby telefon mógł się połączyć.';

  @override
  String get webShareFirewallReady =>
      'Reguły Zapory systemu Windows są gotowe. Połącz telefon z tą samą siecią i zeskanuj kod QR. Jeśli nadal nie można się połączyć, sprawdź zaporę ponownie poniżej.';

  @override
  String get webShareFirewallFailed =>
      'Konfiguracja zapory nie została ukończona. Telefon może nie otworzyć strony. Spróbuj ponownie i zatwierdź monit administratora systemu Windows.';

  @override
  String get webShareFirewallAllow =>
      'Sprawdź i zezwól na połączenia z telefonu';

  @override
  String get mCopyMediaFailed =>
      'Nie można skopiować tego obrazu lub pliku. Spróbuj go najpierw zapisać.';

  @override
  String get mShareMediaFailed =>
      'Nie można udostępnić tego obrazu lub pliku. Spróbuj go najpierw zapisać.';

  @override
  String get mSaveMediaFailed =>
      'Nie można zapisać tego obrazu lub pliku. Sprawdź dostęp do pamięci i wolne miejsce, a potem spróbuj ponownie.';

  @override
  String get noticeFilesUnreadable =>
      'Nie można odczytać właśnie skopiowanych plików, więc nic nie zsynchronizowano';

  @override
  String get mAddMore => 'Dodaj więcej';

  @override
  String get mChoosePhotos => 'Wybierz zdjęcia…';

  @override
  String get mMultiSelectHint =>
      'Można zaznaczyć kilka zdjęć naraz. W Plikach dotknij elementu i przytrzymaj, aby zaznaczyć więcej.';

  @override
  String get webSendFiles => 'Wyślij pliki';

  @override
  String get webFilesQueued =>
      'Dodano do przesyłania przez przeglądarkę. Otwórz Wysyłanie plików w telefonie, aby pobrać.';

  @override
  String get webFilesLimit =>
      'Pobieranie przez przeglądarkę obsługuje do 200 MB na plik i do 64 plików naraz.';

  @override
  String get appearance => 'Wygląd';

  @override
  String get settingsAppearanceSummary => 'Motyw, tryb jasny i ciemny';

  @override
  String get themeTitle => 'Motyw';

  @override
  String get themeDefault => 'Domyślny';

  @override
  String get themePixel => 'Pikselowy';

  @override
  String get themeMode => 'Jasny i ciemny';

  @override
  String get themeModeSystem => 'Jak w systemie';

  @override
  String get themeModeLight => 'Jasny';

  @override
  String get themeModeDark => 'Ciemny';

  @override
  String get themeCustom => 'Własny';

  @override
  String get themeDelete => 'Usuń motyw';

  @override
  String themeDeleteConfirm(String name) {
    return 'Usunąć motyw „$name”?';
  }

  @override
  String get themeLowContrast =>
      'Część tekstu w tym motywie może być słabo czytelna';

  @override
  String get themeFootnote =>
      'Motywy dotyczą tylko tego urządzenia, łącznie z szybkim wklejaniem. Nie są synchronizowane z innymi urządzeniami.';

  @override
  String get themeBuiltinGroup => 'Wbudowane';

  @override
  String get themeCustomGroup => 'Własne';

  @override
  String get themeUse => 'Użyj';

  @override
  String get themeDuplicate => 'Duplikuj';

  @override
  String themeCopyName(String name) {
    return '$name — kopia';
  }

  @override
  String get themeExport => 'Eksportuj…';

  @override
  String get themeImport => 'Importuj motyw…';

  @override
  String themeImported(String name) {
    return 'Zaimportowano „$name”';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kolory tekstu ($count) mogą być słabo czytelne.',
      many: '$count kolorów tekstu może być słabo czytelnych.',
      few: '$count kolory tekstu mogą być słabo czytelne.',
      one: '$count kolor tekstu może być słabo czytelny.',
    );
    return 'Zaimportowano „$name”. $_temp0';
  }

  @override
  String get themeExported => 'Wyeksportowano motyw';

  @override
  String get themeCustomEmpty =>
      'Brak własnych motywów. Zduplikuj motyw wbudowany, zaimportuj motyw lub poproś AI o jego utworzenie.';

  @override
  String get themeAskAi => 'Poproś AI o motyw';

  @override
  String get themeAskAiBody =>
      'Dodaj ten serwer MCP do aplikacji AI, takiej jak Claude lub Cursor, a potem poproś o motyw, np. „Zrób mi motyw w stylu cyberpunk”. AI odczyta format motywu, dobierze kolory, sprawdzi kontrast i zastosuje motyw.';

  @override
  String get themeAskAiCopy => 'Kopiuj konfigurację';

  @override
  String get themeAskAiCopied => 'Skopiowano konfigurację';

  @override
  String get themeScanlines => 'Linie skanowania';

  @override
  String get themeScanlinesDesc =>
      'Nakłada na okno delikatne linie skanowania jak w monitorze CRT. Tylko w motywach pikselowych.';

  @override
  String get themeBackground => 'Obraz tła';

  @override
  String get themeBackgroundDesc =>
      'Wypełnia okno za paskiem bocznym i stronami. Nakładka na wierzchu zapewnia czytelność tekstu.';

  @override
  String get themeBackgroundChoose => 'Wybierz obraz…';

  @override
  String get themeBackgroundChange => 'Zmień…';

  @override
  String get themeBackgroundRemove => 'Usuń';

  @override
  String get themeBlur => 'Rozmycie';

  @override
  String get themeBlurNone => 'Brak';

  @override
  String get themeBlurLight => 'Lekkie';

  @override
  String get themeBlurStrong => 'Silne';

  @override
  String get themeScrim => 'Nakładka';

  @override
  String get themeScrimDesc =>
      'Kolor nałożony na obraz, aby tekst był czytelny. Nigdy nie jest jaśniejszy, niż wymaga tego obraz.';

  @override
  String get themeScrimAuto => 'Automatyczna';

  @override
  String get themeScrimMore => 'Gęstsza';

  @override
  String get themeScrimMost => 'Najgęstsza';

  @override
  String get themePanels => 'Panele';

  @override
  String get themePanelsDesc =>
      'Na ile obraz prześwituje przez pasek boczny i listy.';

  @override
  String get themePanelsClear => 'Przezroczyste';

  @override
  String get themePanelsMedium => 'Średnie';

  @override
  String get themePanelsSolid => 'Pełne';

  @override
  String get themeAccentFromImage => 'Użyj kolorów obrazu';

  @override
  String get themeAccentFromImageDesc =>
      'Kolor wyróżnienia zostanie pobrany z obrazu.';

  @override
  String get themeBackgroundPicker => 'Pokazuj też w szybkim wklejaniu';

  @override
  String get themeScenery => 'Pokaż krajobraz';

  @override
  String get themeSceneryDesc =>
      'Obrazy u góry stron i na dole paska bocznego.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Motywów wbudowanych nie można zmieniać, więc utworzono i zastosowano kopię o nazwie „$name”';
  }

  @override
  String get themeBackgroundFootnote =>
      'Tło należy do bieżącego motywu. Motywów wbudowanych nie można zmieniać: pierwsza zmiana tworzy kopię. Obrazy pozostają na tym urządzeniu; obsługiwane są JPEG, PNG i GIF.';

  @override
  String get themeSceneGroup => 'Krajobraz';

  @override
  String get themeSceneHeader => 'Nagłówek strony';

  @override
  String get themeSceneHeaderDesc =>
      'Szeroki obraz za tytułami stron; jego dół przechodzi płynnie w stronę. Motyw pikselowy rysuje tu pikselowy krajobraz.';

  @override
  String get themeSceneSidebar => 'Dół paska bocznego';

  @override
  String get themeSceneSidebarDesc =>
      'Mały obraz na dole paska bocznego. Motyw pikselowy rysuje tu mały obóz.';

  @override
  String get themeSceneReset => 'Przywróć';

  @override
  String get themeSceneFootnote =>
      'W każdym motywie można tu pokazać własne obrazy. Nakładka zapewnia czytelność tytułu strony. Krajobraz jest ukryty, gdy okno wypełnia obraz tła.';

  @override
  String get starTitle => 'Jak oceniasz PasteFerry?';

  @override
  String get starBody =>
      'Jeśli aplikacja się podoba, gwiazdka na GitHubie bardzo pomoże.';

  @override
  String get starAction => 'Daj gwiazdkę na GitHubie';

  @override
  String get starLater => 'Później';

  @override
  String get starDismiss => 'Nie pokazuj ponownie';
}
