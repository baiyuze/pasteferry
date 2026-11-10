// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navDevices => 'Geräte';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get linkConnecting => 'Verbinden…';

  @override
  String get linkServiceNotRunning => 'Dienst läuft nicht';

  @override
  String get linkLanMode => 'Suche nach Geräten im Netzwerk';

  @override
  String get linkServerUnreachable =>
      'Server nicht erreichbar; Sync im lokalen Netzwerk';

  @override
  String get linkNothingOn =>
      'Suche im lokalen Netzwerk ist aus und kein Server festgelegt';

  @override
  String get linkLanBlocked => 'macOS blockiert das lokale Netzwerk';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Geräte online',
      one: '1 Gerät online',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Mit dem Server verbunden';

  @override
  String linkConnectionLost(String detail) {
    return 'Verbindung unterbrochen: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Dienst getrennt';

  @override
  String get linkServiceDisabled => 'Hintergrund-Sync ist aus';

  @override
  String get errServiceNotConnected => 'Keine Verbindung zum Hintergrunddienst';

  @override
  String get errUnimplemented => 'Noch nicht verfügbar';

  @override
  String get errUnavailable => 'Hintergrunddienst nicht erreichbar';

  @override
  String errServiceStart(String detail) {
    return 'Hintergrunddienst konnte nicht gestartet werden: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Hintergrunddienst konnte nicht neu gestartet werden: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Autostart von PasteFerry bei der Anmeldung konnte nicht eingerichtet werden: $detail';
  }

  @override
  String get thisMacTitle => 'Dieser Mac';

  @override
  String get thisPcTitle => 'Dieser Computer';

  @override
  String get thisMacInText => 'diesem Mac';

  @override
  String get thisPcInText => 'diesem Computer';

  @override
  String get bothMacs => 'beide Macs';

  @override
  String get bothDevices => 'beide Geräte';

  @override
  String get thisDeviceShort => 'Dieses Gerät';

  @override
  String fromDevice(String name) {
    return 'Von $name';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get save => 'Speichern';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get justNow => 'Gerade eben';

  @override
  String secondsAgo(int n) {
    return 'Vor $n s';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Vor $n Minuten',
      one: 'Vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Vor $n Stunden',
      one: 'Vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Vor $n Tagen',
      one: 'Gestern',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$day.$month.';
  }

  @override
  String durationHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Was Sie auf einem Ihrer Geräte kopieren, erscheint hier';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0, aufbewahrt für $ttl';
  }

  @override
  String get filterAll => 'Alle';

  @override
  String get filterText => 'Text';

  @override
  String get filterImage => 'Bilder';

  @override
  String get filterFile => 'Dateien';

  @override
  String get filterLink => 'Links';

  @override
  String get historyClearTooltip => 'Verlauf löschen';

  @override
  String get historyEmptyTitle => 'Noch nichts hier';

  @override
  String get historyEmptyFilteredTitle => 'Keine Einträge dieser Art';

  @override
  String get historyEmptyBody =>
      'Kopieren Sie Text, ein Bild oder eine Datei auf einem gekoppelten Gerät, und es erscheint hier.';

  @override
  String get clearConfirmTitle => 'Gesamten Verlauf löschen?';

  @override
  String clearConfirmBody(String device) {
    return 'Alles, was von Ihren Geräten synchronisiert wurde, und die zwischengespeicherten Dateien werden von $device entfernt. Die Originaldateien bleiben unberührt.';
  }

  @override
  String get clear => 'Löschen';

  @override
  String get historyCleared => 'Verlauf gelöscht';

  @override
  String get permDeniedTitle =>
      'PasteFerry kann die Zwischenablage nicht lesen';

  @override
  String get permAskTitle => 'PasteFerry das Lesen der Zwischenablage erlauben';

  @override
  String get permDeniedBody =>
      'Was Sie auf diesem Mac kopieren, wird nicht synchronisiert. Setzen Sie PasteFerry Daemon in den Systemeinstellungen auf „Erlauben“.';

  @override
  String get permAskBody =>
      'Sonst fragt macOS jedes Mal nach. Setzen Sie PasteFerry Daemon in den Systemeinstellungen auf „Erlauben“.';

  @override
  String get openSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get fetch => 'Empfangen';

  @override
  String get fetchStarted => 'Wird empfangen… Fortschritt im Verlauf';

  @override
  String get transferFailed => 'Übertragung fehlgeschlagen';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get putOnClipboard => 'Kopieren';

  @override
  String get putOnClipboardDone => 'In der Zwischenablage';

  @override
  String get deleteRecord => 'Eintrag löschen';

  @override
  String get deleted => 'Gelöscht';

  @override
  String get emptyRecord => '(leer)';

  @override
  String get imageRecord => 'Bild';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others weitere',
      one: '1 weiteres',
    );
    return '$name und $_temp0';
  }

  @override
  String get searchHint => 'Text und Dateinamen durchsuchen';

  @override
  String get searchClear => 'Suche löschen';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Treffer',
      one: '1 Treffer',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Keine Treffer für „$query“';
  }

  @override
  String get searchEmptyBody =>
      'Die Suche umfasst kopierten Text und die Namen kopierter Dateien.';

  @override
  String get favoriteAction => 'Zu Favoriten hinzufügen';

  @override
  String get unfavoriteAction => 'Aus Favoriten entfernen';

  @override
  String get favoritedToast => 'Zu Favoriten hinzugefügt';

  @override
  String get unfavoritedToast => 'Zurück in den Verlauf verschoben';

  @override
  String get undo => 'Rückgängig';

  @override
  String get favoriteSaving => 'Wird gespeichert…';

  @override
  String favoritedAt(String date) {
    return 'Gespeichert am $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0 · nie automatisch gelöscht · bis zu $size';
  }

  @override
  String get favoritesEmptyTitle => 'Noch keine Favoriten';

  @override
  String get favoritesEmptyBody =>
      'Markieren Sie einen Eintrag im Verlauf mit dem Stern, um hier eine Kopie zu behalten. Favoriten werden nie automatisch gelöscht.';

  @override
  String get favoritesSearchHint => 'Favoriten durchsuchen';

  @override
  String favoriteLargeTitle(String size) {
    return 'Kopie mit $size speichern?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Ein Favorit behält eine eigene Kopie, Änderungen an den Originaldateien oder deren Löschen wirken sich also nicht darauf aus. Dadurch werden $size auf $device belegt.';
  }

  @override
  String get saveCopy => 'Kopie speichern';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ihre $count Favoriten bleiben erhalten.',
      one: 'Ihr Favorit bleibt erhalten.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favoriten';

  @override
  String get favoritesUsageDesc =>
      'Favoriten werden nie gelöscht, unabhängig von den Einstellungen oben';

  @override
  String upToSize(String size) {
    return 'Bis zu $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeichen',
      one: '1 Zeichen',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… insgesamt $count Zeichen';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weitere',
      one: '1 weitere',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Bei Auswahl wird es zuerst geladen';

  @override
  String detailTotalSize(String size) {
    return 'Insgesamt $size';
  }

  @override
  String get quickPaste => 'Schnelleinfügen';

  @override
  String get quickPasteWindow => 'Schnelleinfügen-Fenster';

  @override
  String get quickPasteWindowDesc =>
      'Drücken Sie in einer beliebigen App das Tastenkürzel, um den Verlauf zu öffnen; der gewählte Eintrag wird eingefügt';

  @override
  String get quickPasteShortcut => 'Tastenkürzel';

  @override
  String get quickPasteRecord => 'Zum Ändern klicken';

  @override
  String get quickPasteRecording => 'Neues Tastenkürzel drücken…';

  @override
  String get quickPasteUseDefault => 'Standard verwenden';

  @override
  String get quickPasteNeedsModifier =>
      'Mit ⌃, ⌥, ⇧ oder ⌘ kombinieren oder eine Funktionstaste verwenden';

  @override
  String get quickPasteNeedsModifierPc =>
      'Mit Ctrl, Alt, Shift oder der Windows-Taste kombinieren oder eine Funktionstaste verwenden';

  @override
  String get quickPasteAfterPick => 'Nach der Auswahl';

  @override
  String get quickPastePasteIt => 'Einfügen';

  @override
  String get quickPasteCopyIt => 'Nur kopieren';

  @override
  String get quickPasteIndexKey => 'Einen der ersten 9 wählen';

  @override
  String get quickPasteIndexKeyDesc =>
      'Im Schnelleinfügen-Fenster diese Taste halten und 1–9 drücken';

  @override
  String get quickPasteAccessibility => 'Bedienungshilfen';

  @override
  String get quickPasteAccessibilityDesc =>
      'Nötig, um direkt einzufügen. Ohne diese Berechtigung wird nur kopiert und Sie drücken ⌘V.';

  @override
  String get quickPasteAllowed => 'Erlaubt';

  @override
  String get quickPasteAllow => 'Erlauben…';

  @override
  String get quickPasteNotRunning => 'Das Schnelleinfügen-Fenster läuft nicht';

  @override
  String quickPasteInUse(String key) {
    return '$key wird von einer anderen App verwendet. Wählen Sie ein anderes Tastenkürzel.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '$key konnte nicht festgelegt werden: $detail';
  }

  @override
  String get quickPastePortalKey =>
      'In den Tastenkürzel-Einstellungen des Systems festlegen';

  @override
  String get quickPasteWaylandDesc =>
      'Fügen Sie unter Wayland das Tastenkürzel in den Tastatureinstellungen Ihres Desktops hinzu. Gewählte Einträge werden kopiert; zum Einfügen Ctrl+V drücken.';

  @override
  String get quickPasteAddShortcut => 'Systemkürzel hinzufügen';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Hinzugefügt. Drücken Sie $key zum Ausprobieren.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Fügen Sie in den Tastatureinstellungen Ihres Desktops ein eigenes Tastenkürzel mit diesem Befehl hinzu: $command';
  }

  @override
  String get pickerSearch => 'Suchen';

  @override
  String get pickerPaste => 'Einfügen';

  @override
  String get pickerPlainText => 'Reiner Text';

  @override
  String get pickerCopyOnly => 'Nur kopieren';

  @override
  String get pickerUnfavoriteHint => 'Entfernen (zurück in den Verlauf)';

  @override
  String pickerPasteManually(String key) {
    return 'Gewählte Einträge werden kopiert – zum Einfügen $key drücken';
  }

  @override
  String get pickerGrantHint =>
      'Bedienungshilfen erlauben, um direkt einzufügen';

  @override
  String pickerElevated(String key) {
    return 'Dieses Fenster läuft als Administrator – nach der Auswahl zum Einfügen $key drücken';
  }

  @override
  String get pickerDownloading => 'Wird geladen – danach wird eingefügt';

  @override
  String get imagePreviewTitle => 'Bildvorschau';

  @override
  String get closePreview => 'Vorschau schließen';

  @override
  String get previousImage => 'Vorheriges Bild';

  @override
  String get nextImage => 'Nächstes Bild';

  @override
  String get previewHint =>
      'Zum Zoomen scrollen oder Finger zusammenziehen, zum Verschieben ziehen';

  @override
  String get fitWindow => 'An Fenster anpassen';

  @override
  String get previewDeleted => 'Dieses Bild wurde aus dem Verlauf gelöscht';

  @override
  String get previewExpired =>
      'Dieses Bild ist abgelaufen und kann nicht angezeigt werden';

  @override
  String get previewDownloading => 'Bild wird geladen…';

  @override
  String get previewDownloadFailed =>
      'Download fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get previewNotDownloaded =>
      'Dieses Bild ist noch nicht auf diesem Computer';

  @override
  String get downloadAndPreview => 'Laden und anzeigen';

  @override
  String get previewUnavailable =>
      'Dieses Bild kann gerade nicht angezeigt werden';

  @override
  String get imageSemantic => 'Bild aus dem Verlauf';

  @override
  String get previewUnreadable =>
      'Bild kann nicht gelesen werden. Die Datei wurde eventuell bereinigt oder ist beschädigt.';

  @override
  String get devicesSubtitleEmpty =>
      'Gekoppelte Geräte teilen sich eine Zwischenablage';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired gekoppelt, $online online';
  }

  @override
  String get addDevice => 'Gerät hinzufügen';

  @override
  String thisDeviceFootnote(String both) {
    return 'Beim Koppeln zeigen $both dieselben zwei Zeilen mit Sicherheits-Fingerabdrücken, eine pro Gerät. Bestätigen Sie nur, wenn sie Zeichen für Zeichen übereinstimmen.';
  }

  @override
  String get noDevicesTitle => 'Noch keine gekoppelten Geräte';

  @override
  String get noDevicesBody =>
      'Öffnen Sie PasteFerry auf Ihrem anderen Computer und verbinden Sie beide mit einem 6-stelligen Kopplungscode. Im selben Netzwerk können Sie auch auf beiden „In der Nähe suchen“ öffnen und das jeweils andere Gerät anklicken.';

  @override
  String get pairedDevices => 'Gekoppelte Geräte';

  @override
  String get pairedFootnote =>
      'Direkt: Die Daten gehen direkt zwischen den beiden Geräten. Relay: Lässt das Netzwerk keine direkte Verbindung zu, laufen die Daten über Ihren Server und bleiben Ende-zu-Ende-verschlüsselt.';

  @override
  String get offline => 'Offline';

  @override
  String get direct => 'Direkt';

  @override
  String get relay => 'Relay';

  @override
  String get online => 'Online';

  @override
  String get moreActions => 'Mehr';

  @override
  String get copyFingerprint => 'Fingerabdruck kopieren';

  @override
  String get unpairEllipsis => 'Kopplung aufheben…';

  @override
  String get fingerprintCopied => 'Fingerabdruck kopiert';

  @override
  String unpairTitle(String name) {
    return 'Kopplung mit „$name“ aufheben?';
  }

  @override
  String get unpairBody =>
      'Die beiden Geräte synchronisieren dann nicht mehr. Um wieder zu synchronisieren, müssen Sie sie erneut koppeln und die Fingerabdrücke prüfen.';

  @override
  String get unpair => 'Kopplung aufheben';

  @override
  String get unpaired => 'Kopplung aufgehoben';

  @override
  String get enterAddressEllipsis => 'Adresse eingeben…';

  @override
  String setAddressTitle(String name) {
    return 'Adresse von „$name“';
  }

  @override
  String setAddressBody(String name) {
    return 'Für Geräte in verschiedenen Subnetzen oder wenn beide ihre Adresse geändert haben. Geben Sie die Adresse ein, die auf „$name“ unter „Gerät hinzufügen“ → „Code anzeigen“ steht.';
  }

  @override
  String get addressSaved => 'Suche unter dieser Adresse';

  @override
  String get lanBlockedTitle => 'macOS blockiert das lokale Netzwerk';

  @override
  String lanBlockedBody(String device) {
    return 'Aktivieren Sie PasteFerry Daemon unter Systemeinstellungen → Datenschutz & Sicherheit → Lokales Netzwerk. Bis dahin sind von $device aus keine Geräte in diesem Netzwerk erreichbar.';
  }

  @override
  String get searchNearby => 'In der Nähe suchen';

  @override
  String get nearbyTitle => 'Geräte in der Nähe';

  @override
  String get nearbySearching => 'Suche nach Geräten in der Nähe…';

  @override
  String get nearbyHint =>
      'Öffnen Sie „In der Nähe suchen“ auch auf dem anderen Computer, dann erscheint er hier. Klicken Sie darauf, um zu koppeln.';

  @override
  String nearbyVisible(String device) {
    return 'Solange dieses Fenster offen ist, sehen Geräte in diesem Netzwerk den Namen von $device.';
  }

  @override
  String get nearbyPaired => 'Gekoppelt';

  @override
  String nearbyRequesting(String name) {
    return '„$name“ wird kontaktiert…';
  }

  @override
  String nearbyNoReply(String name) {
    return '„$name“ antwortet nicht. Prüfen Sie, ob dort „In der Nähe suchen“ noch geöffnet ist.';
  }

  @override
  String get nearbyLanOffTitle => 'Suche im lokalen Netzwerk ist aus';

  @override
  String get nearbyLanOffBody =>
      'Aktivieren Sie „Geräte im Netzwerk finden“ unter Einstellungen → Verbindung, um Geräte in der Nähe zu sehen, oder koppeln Sie mit einem Code.';

  @override
  String get generateCode => 'Code anzeigen';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String get codeFailedTitle => 'Kopplungscode konnte nicht erstellt werden';

  @override
  String get enterOnOther =>
      'Geben Sie diesen Code auf Ihrem anderen Gerät ein';

  @override
  String get codeCopied => 'Code kopiert';

  @override
  String get codeHint => 'Zum Kopieren klicken. 5 Minuten gültig.';

  @override
  String afterEnterFootnote(String both) {
    return 'Nach der Eingabe zeigen $both dieselben zwei Zeilen mit Sicherheits-Fingerabdrücken. Bestätigen Sie nur, wenn sie übereinstimmen.';
  }

  @override
  String get codeInvalid =>
      'Ein Kopplungscode besteht aus 6 Buchstaben oder Ziffern';

  @override
  String get localAddress => 'Adresse';

  @override
  String get addressHint =>
      'Anderes Subnetz? Geben Sie diese Adresse auch auf dem anderen Gerät ein.';

  @override
  String get addressCopied => 'Adresse kopiert';

  @override
  String get differentSubnet => 'Anderes Subnetz?';

  @override
  String get peerAddress => 'Adresse unter dem Code';

  @override
  String get pairNotFound =>
      'Gerät nicht gefunden. Ist es in einem anderen Subnetz, geben Sie die Adresse unter seinem Code ein.';

  @override
  String get pairNotFoundAddress =>
      'Unter dieser Adresse antwortet nichts. Prüfen Sie die Adresse und ob das andere Gerät seinen Code noch anzeigt. Möglicherweise blockiert auch eine Firewall auf diesem Gerät die Verbindung.';

  @override
  String get codeWrong => 'Der Code ist falsch oder abgelaufen';

  @override
  String get codeExpired =>
      'Dieser Code ist abgelaufen. Lassen Sie auf dem anderen Gerät einen neuen anzeigen.';

  @override
  String get addressInvalid =>
      'Ungültige Adresse. Geben Sie etwa 192.168.1.20 ein.';

  @override
  String get pairNoChannel =>
      'Aktivieren Sie zuerst unter Einstellungen → Verbindung die Suche im lokalen Netzwerk oder legen Sie einen Server fest.';

  @override
  String get enterCodeShown =>
      'Geben Sie den Code ein, der auf Ihrem anderen Gerät angezeigt wird';

  @override
  String get pairingDone => 'Gekoppelt';

  @override
  String get pairingRejected => 'Kopplung abgelehnt';

  @override
  String get verifyTitle => 'Sicherheits-Fingerabdrücke prüfen';

  @override
  String pairingWith(String name) {
    return 'Kopplung mit „$name“';
  }

  @override
  String verifyBody(String both) {
    return 'Prüfen Sie, ob $both genau dieselben zwei Zeilen anzeigen. Weicht auch nur ein Zeichen ab, manipuliert eventuell jemand die Verbindung – lehnen Sie dann ab.';
  }

  @override
  String get rejectMismatch => 'Abweichend, ablehnen';

  @override
  String get confirmMatch => 'Stimmt überein, koppeln';

  @override
  String get server => 'Server (optional)';

  @override
  String get signalingUrl => 'Signaling-Server';

  @override
  String get signalingUrlDesc => 'Leer lassen, um nur lokal zu synchronisieren';

  @override
  String get signalingUrlPlaceholder => 'ws://serveradresse:8787/signal';

  @override
  String get publicStun => 'Direktverbindungen verbessern';

  @override
  String get publicStunDesc => 'Öffentliche Server sehen Ihre öffentliche IP';

  @override
  String get connectionStatus => 'Verbindung';

  @override
  String get disconnectedDesc => 'Prüfen Sie Serveradresse und Erreichbarkeit';

  @override
  String get connected => 'Verbunden';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get serverCleared =>
      'Server entfernt. Synchronisierung nur im lokalen Netzwerk.';

  @override
  String get localNetwork => 'Lokales Netzwerk';

  @override
  String get lanDiscovery => 'Geräte im Netzwerk finden';

  @override
  String get lanDiscoveryDesc =>
      'Anonyme Suche; Namen nur bei „In der Nähe suchen“ sichtbar';

  @override
  String get macLocalNetwork => 'Zugriff auf lokales Netzwerk';

  @override
  String get macLocalNetworkDesc =>
      'PasteFerry Daemon in den Systemeinstellungen erlauben';

  @override
  String get allowLan => 'Windows-Firewall';

  @override
  String get allowLanDesc =>
      'Blockierte Verbindungen zulassen; erfordert Administratorrechte';

  @override
  String get allow => 'Zulassen';

  @override
  String get allowLanDone =>
      'Zugelassen. Andere Geräte können dieses Gerät jetzt erreichen.';

  @override
  String get deviceName => 'Gerätename';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get sync => 'Synchronisierung';

  @override
  String get autoSyncLimit => 'Auto-Sync-Limit';

  @override
  String get autoSyncLimitDesc =>
      'Größere Einträge manuell im Verlauf empfangen';

  @override
  String get autoApply => 'Empfangenes in die Zwischenablage legen';

  @override
  String get whatToSync => 'Was synchronisiert wird';

  @override
  String get syncFiles => 'Dateien und Ordner';

  @override
  String get syncText => 'Reiner Text';

  @override
  String get syncRich => 'Formatierter Text';

  @override
  String get syncImages => 'Bilder und Bildschirmfotos';

  @override
  String get storage => 'Speicher';

  @override
  String get storageFootnote =>
      'Abgelaufener Verlauf und zwischengespeicherte Dateien werden automatisch gelöscht.';

  @override
  String get keepHistory => 'Verlauf behalten';

  @override
  String get keepCache => 'Cache-Dateien behalten';

  @override
  String get keepCacheDesc => 'Nicht länger als der Verlauf';

  @override
  String get cacheUsage => 'Cache-Größe';

  @override
  String get backgroundSync => 'Hintergrund-Sync';

  @override
  String get backgroundService => 'Hintergrunddienst';

  @override
  String get backgroundServiceDesc =>
      'Startet bei der Anmeldung; synchronisiert auch bei geschlossenem Fenster';

  @override
  String get restart => 'Neu starten';

  @override
  String get restarted => 'Hintergrunddienst neu gestartet';

  @override
  String get disableEllipsis => 'Ausschalten…';

  @override
  String get about => 'Über';

  @override
  String get aboutDesc => 'Open Source unter der AGPL-3.0';

  @override
  String get homepage => 'Website';

  @override
  String get feedback => 'Problem melden';

  @override
  String get disableTitle => 'Hintergrund-Sync ausschalten?';

  @override
  String disableBody(String device) {
    return 'PasteFerry auf $device synchronisiert dann nicht mehr und startet nicht bei der Anmeldung. Verlauf und Kopplungen bleiben erhalten.';
  }

  @override
  String get disable => 'Ausschalten';

  @override
  String get disabled => 'Hintergrund-Sync ist aus';

  @override
  String get urlMustBeWs => 'Die Adresse muss mit ws:// oder wss:// beginnen';

  @override
  String get serverUpdated => 'Server aktualisiert. Neu verbinden…';

  @override
  String get deviceNameUpdated => 'Gerätename aktualisiert';

  @override
  String get diagIntro =>
      'Dieser Bericht enthält App-Version, System, Einstellungen, Geräte und aktuelle Protokolle. Gerätenamen, Serveradresse, öffentliche IP-Adressen, Ihr Benutzerordner und Dateinamen werden ersetzt, und kopierte Inhalte landen nie in den Protokollen. Issues auf GitHub sind öffentlich – lesen Sie den Bericht vor dem Posten durch.';

  @override
  String get diagVerboseTitle => 'Ausführliche Protokolle';

  @override
  String get diagVerboseDesc =>
      'Bei Verbindungsproblemen: Einschalten, das Problem erneut auslösen und dann hier den Bericht erstellen. Schaltet sich nach 30 Minuten aus.';

  @override
  String get diagVerboseOn => 'Für 30 Minuten einschalten';

  @override
  String diagVerboseUntil(String time) {
    return 'An bis $time';
  }

  @override
  String get diagVerboseOff => 'Ausschalten';

  @override
  String get diagRefresh => 'Neu erstellen';

  @override
  String get diagSave => 'Als Datei speichern';

  @override
  String diagSaved(String name) {
    return 'Im Ordner „Downloads“ gespeichert: $name';
  }

  @override
  String get diagCopy => 'Bericht kopieren';

  @override
  String get diagCopied => 'Bericht kopiert';

  @override
  String get diagNewIssue => 'Neues Issue auf GitHub';

  @override
  String get diagIssueHint =>
      'Bericht kopiert. Fügen Sie ihn im Issue in das Feld „Diagnostics report“ ein.';

  @override
  String diagFailed(String detail) {
    return 'Bericht konnte nicht erstellt werden: $detail';
  }

  @override
  String get svcExtractTitle => 'PasteFerry zuerst installieren oder entpacken';

  @override
  String get svcExtractBody =>
      'PasteFerry läuft direkt aus der ZIP-Datei, und sein temporärer Ordner verschwindet beim Schließen. Führen Sie das Installationsprogramm aus oder entpacken Sie den ganzen Ordner und öffnen Sie PasteFerry von dort, um den Hintergrund-Sync zu aktivieren.';

  @override
  String get svcMoveTitle => 'PasteFerry zuerst in „Programme“ bewegen';

  @override
  String get svcMoveBody =>
      'PasteFerry läuft direkt vom Disk-Image. Ziehen Sie es in „Programme“, werfen Sie das Disk-Image aus und öffnen Sie PasteFerry aus „Programme“, um den Hintergrund-Sync zu aktivieren.';

  @override
  String get svcStartTitle => 'Erste Schritte mit PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry nutzt einen kleinen Hintergrundprozess für den Sync der Zwischenablage. Er läuft auch bei geschlossenem Fenster weiter. Der Start bei der Anmeldung ist eine eigene Einstellung und bei neuen Installationen aus.';

  @override
  String get svcEnable => 'Hintergrund-Sync aktivieren';

  @override
  String get svcStaleTitle => 'Hintergrund-Sync erneut aktivieren';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry wurde verschoben, aber der Autostart verweist noch auf den alten Ort. Aktivieren Sie den Sync erneut, damit der Hintergrundprozess diese Kopie verwendet. Verlauf und Kopplungen bleiben erhalten.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry wurde verschoben oder mit einem alten Skript installiert. Aktivieren Sie den Sync erneut, damit der Hintergrundprozess diese App verwendet. Verlauf und Kopplungen bleiben erhalten.';

  @override
  String get svcReenable => 'Erneut aktivieren';

  @override
  String get svcStoppedTitle => 'Der Hintergrunddienst läuft nicht';

  @override
  String get svcStoppedBody =>
      'Der Hintergrunddienst ist gestoppt. Starten Sie ihn mit der Schaltfläche unten; den Start bei der Anmeldung legen Sie separat in den Einstellungen fest.';

  @override
  String get svcDevBodyWin =>
      'Dies ist ein Entwicklungs-Build ohne pasteferryd.exe daneben. Führen Sie scripts\\build-windows.ps1 im Quellordner aus, um eine vollständige Version zu erstellen.';

  @override
  String get svcDevBodyLinux =>
      'Dies ist ein Entwicklungs-Build ohne pasteferryd daneben. Führen Sie ./scripts/package-linux.sh im Quellordner aus, um eine vollständige Version zu erstellen.';

  @override
  String get svcDevBodyMac =>
      'Dies ist ein Entwicklungs-Build ohne Hintergrunddienst. Führen Sie ./scripts/install-macos.sh im Quellordner aus, um ihn zu installieren.';

  @override
  String svcLogPath(String path) {
    return 'Protokoll: $path';
  }

  @override
  String get svcCanDisable =>
      'Sie können den Hintergrund-Sync jederzeit in den Einstellungen ausschalten.';

  @override
  String get officialService => 'Dienst';

  @override
  String get useOfficialService => 'Dienst nutzen';

  @override
  String get officialServiceDesc =>
      'Über Netzwerke hinweg synchronisieren, Direktverbindung zuerst';

  @override
  String get officialPrivacy =>
      'Verbindet sich nur bei Aktivierung mit dem Dienst und speichert die nötigen Verbindungsdaten. Zuerst werden Direktverbindungen versucht; Relay wird nur angefordert, wenn diese scheitern. Inhalte, echte Gerätenamen und rohe Systemkennungen werden nicht hochgeladen.';

  @override
  String get officialEnableTitle => 'Dienst aktivieren?';

  @override
  String get officialSwitchConfirm =>
      'Damit wechseln Sie weg von Ihrem eigenen Server. Dessen gespeicherte Adresse bleibt erhalten.';

  @override
  String get customServer => 'Eigener Server';

  @override
  String get saveAndConnect => 'Speichern und verbinden';

  @override
  String get officialLoading => 'Kontingent wird abgerufen…';

  @override
  String get officialFetchFailed =>
      'Kontingent derzeit nicht abrufbar. Es wird automatisch erneut versucht.';

  @override
  String get officialUnavailable =>
      'Nutzung nicht verfügbar; vorhandene Daten sind möglicherweise veraltet';

  @override
  String get officialQuotaTitle => 'Tägliches Relay-Kontingent aufgebraucht';

  @override
  String get officialQuotaBody =>
      'Das Relay des Dienstes pausiert bis zum täglichen Zurücksetzen um Mitternacht Pekinger Zeit. LAN- und direkte Internetverbindungen bleiben verfügbar. Fehlgeschlagene Übertragungen können Sie später wiederholen.';

  @override
  String get officialPeerQuota =>
      'Die Gegenseite hat kein Relay-Kontingent mehr. Direktverbindungen bleiben verfügbar.';

  @override
  String get officialPaused =>
      'Das Relay des Dienstes ist nicht verfügbar. Direktverbindungen bleiben verfügbar.';

  @override
  String get officialViewUsage => 'Nutzung anzeigen';

  @override
  String get officialAcknowledge => 'OK';

  @override
  String get officialToday => 'Heutiges Relay-Kontingent';

  @override
  String get officialUsed => 'Verbraucht';

  @override
  String get officialRemaining => 'Verbleibend';

  @override
  String get officialDailyLimit => 'Tageskontingent';

  @override
  String get officialUpload => 'Upload';

  @override
  String get officialDownload => 'Download';

  @override
  String get officialReset => 'Zurücksetzung (Pekinger Zeit)';

  @override
  String get officialUpdated => 'Zuletzt aktualisiert';

  @override
  String get officialRoutes => 'Verbindungsart der Geräte';

  @override
  String get officialRoutesFootnote =>
      'Direktverbindungen laufen nicht über das Relay des Dienstes und verbrauchen kein Kontingent.';

  @override
  String get officialDeviceID => 'Geräte-ID';

  @override
  String get officialWarning =>
      '90 % des täglichen Relay-Kontingents sind verbraucht. Direktverbindungen verbrauchen davon nichts.';

  @override
  String get updateCheck => 'Nach Updates suchen';

  @override
  String get updateCheckEllipsis => 'Nach Updates suchen…';

  @override
  String get updateAuto => 'Automatisch nach Updates suchen';

  @override
  String get updateChecking => 'Suche nach Updates…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version ist die neueste Version.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version ist verfügbar';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Sie haben $current. Downloadgröße: $size.';
  }

  @override
  String get updateNew => 'Neu';

  @override
  String get updateFixed => 'Behoben';

  @override
  String get updateSkip => 'Diese Version überspringen';

  @override
  String get updateLater => 'Später';

  @override
  String get updateInstall => 'Laden und installieren';

  @override
  String updateDownloading(String done, String total) {
    return '$done von $total geladen';
  }

  @override
  String get updateVerifying => 'Download wird geprüft…';

  @override
  String get updateInstalling =>
      'Wird installiert. PasteFerry startet danach von selbst neu.';

  @override
  String get updateInstallingPassword =>
      'Wird installiert. Das System fragt nach Ihrem Passwort, da /opt Administratorrechte erfordert; danach startet PasteFerry von selbst neu.';

  @override
  String get updateCheckFailed =>
      'GitHub und Gitee sind nicht erreichbar. Versuchen Sie es später erneut.';

  @override
  String get updateDownloadFailed =>
      'Der Download wurde nicht abgeschlossen. Versuchen Sie es erneut oder laden Sie die neue Version von der Website.';

  @override
  String updateInstallFailed(String error) {
    return 'Installation konnte nicht gestartet werden: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Dieser Build kann nicht nach Updates suchen.';

  @override
  String get updateBlockedDev =>
      'Dies ist ein Entwicklungs-Build und kann sich nicht selbst aktualisieren.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry läuft vom Disk-Image. Ziehen Sie es in „Programme“ und öffnen Sie es dort, damit es sich automatisch aktualisiert.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry kann nicht in seinen Installationsordner schreiben. Laden Sie die neue Version stattdessen von der Website.';

  @override
  String get updateBlockedUnsupported =>
      'Für diesen Computer gibt es kein automatisches Update. Laden Sie die neue Version von der Website.';

  @override
  String get updateOpenDownload => 'Downloadseite öffnen';

  @override
  String updateSidebar(String version) {
    return 'Version $version verfügbar';
  }

  @override
  String updatedTo(String version) {
    return 'Aktualisiert auf $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Das Update wurde nicht abgeschlossen. Sie haben weiterhin $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Das Update wurde nicht abgeschlossen. Sie haben weiterhin $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · Dienst $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Nicht empfangen – vor dem Einfügen empfangen';

  @override
  String get receivedPreserved =>
      'Empfangen; bei Bedarf „In Zwischenablage kopieren“ wählen';

  @override
  String get clipboardWriteFailed =>
      'Empfangen, aber die Zwischenablage konnte nicht aktualisiert werden';

  @override
  String get receivingStatus => 'Wird empfangen…';

  @override
  String get largeFileNotifications => 'Hinweise zu großen Dateien';

  @override
  String get notificationsAllowed =>
      'Benachrichtigungen sind aktiviert. Der Fortschritt erscheint im Verlauf.';

  @override
  String get notificationsNotRequested =>
      'Aktivieren Sie Benachrichtigungen, damit große Dateien nicht unbemerkt warten. Sie können sie jederzeit im Verlauf empfangen.';

  @override
  String get notificationsDenied =>
      'Benachrichtigungen sind in den Systemeinstellungen blockiert. Empfangen Sie ausstehende Einträge im Verlauf.';

  @override
  String get notificationsUnknown =>
      'Zustellung von Benachrichtigungen und „Nicht stören“ steuert Ihr Desktop. Erscheint kein Hinweis, empfangen Sie Einträge im Verlauf.';

  @override
  String get notificationsUnavailable =>
      'Systembenachrichtigungen sind nicht verfügbar. Empfangen Sie große Dateien im Verlauf.';

  @override
  String get enableNotifications => 'Hinweise aktivieren';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notifyPendingTitle => 'Zum Einfügen empfangen';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nEmpfangen Sie diesen Eintrag vor dem Einfügen. Das geht auch im Verlauf.';
  }

  @override
  String get notifyReceivingTitle => 'Wird empfangen…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nFortschritt im Verlauf.';
  }

  @override
  String get notifyReadyTitle => 'Bereit zum Einfügen';

  @override
  String notifyReadyBody(String name) {
    return '$name\nEmpfangen und in die Zwischenablage gelegt.';
  }

  @override
  String get notifyReceivedTitle => 'Empfangen';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nIhre Zwischenablage blieb unverändert. Wählen Sie bei Bedarf „In Zwischenablage kopieren“; das geht auch im Verlauf.';
  }

  @override
  String get notifyFailedTitle => 'Empfang fehlgeschlagen';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nVersuchen Sie es über diese Benachrichtigung oder im Verlauf erneut.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Empfangen; Zwischenablage nicht aktualisiert';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nMit „In Zwischenablage kopieren“ erneut versuchen, hier oder im Verlauf.';
  }

  @override
  String get reconnect => 'Neu verbinden';

  @override
  String get reconnecting => 'Verbinden…';

  @override
  String get reconnectDirect => 'Direkt verbunden';

  @override
  String get reconnectRelay =>
      'Keine Direktverbindung möglich, weiterhin über Relay';

  @override
  String reconnectOffline(String name) {
    return '„$name“ ist offline. Prüfen Sie, ob PasteFerry dort geöffnet ist.';
  }

  @override
  String get reconnectPending =>
      'Verbindung läuft noch, schauen Sie gleich wieder vorbei';

  @override
  String get renameAction => 'Umbenennen';

  @override
  String get renameFavoriteTitle => 'Favorit umbenennen';

  @override
  String get renameFavoriteHint =>
      'Wird in Favoriten und beim Schnelleinfügen angezeigt und ist durchsuchbar. Leer lassen, um wieder den Inhalt anzuzeigen.';

  @override
  String get renamedToast => 'Umbenannt';

  @override
  String get aliasClearedToast => 'Inhalt wird wieder angezeigt';

  @override
  String get navSend => 'Dateien senden';

  @override
  String get sendSubtitle =>
      'Dateien auf ein Gerät ziehen, um sie direkt zu senden';

  @override
  String get sendNoDevicesTitle => 'Noch keine gekoppelten Geräte';

  @override
  String get sendNoDevicesBody =>
      'Koppeln Sie zuerst einen anderen Computer, dann können Sie ihm hier Dateien senden.';

  @override
  String get sendDropHint => 'Zum Senden auf ein Gerät ziehen';

  @override
  String sendReleaseTo(String name) {
    return 'Loslassen, um an $name zu senden';
  }

  @override
  String get sendLan => 'Lokales Netzwerk';

  @override
  String sendRelayLeft(String left) {
    return 'Relay · heute noch $left';
  }

  @override
  String get sendNeedsUpdate => 'Update nötig';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name kann Dateien empfangen, sobald PasteFerry 2.5 oder neuer installiert ist.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Verbindung mit $name wird hergestellt. Danach können Sie senden.';
  }

  @override
  String get sendNotReceiving => 'Empfängt keine Dateien';

  @override
  String get sendDelivered => 'Zugestellt';

  @override
  String sendToTitle(String name) {
    return 'An $name senden';
  }

  @override
  String get sendDropHere => 'Dateien oder Ordner hierher ziehen';

  @override
  String get sendDropStarts => 'Das Senden beginnt, sobald Sie sie loslassen';

  @override
  String get sendChooseFiles => 'Dateien auswählen…';

  @override
  String get sendChooseFolder => 'Ordner auswählen…';

  @override
  String get sendDropMore => 'Weitere Dateien ablegen, um sie danach zu senden';

  @override
  String sendSavedWhere(String name) {
    return 'Dateien werden dort gespeichert, wo $name es festlegt – standardmäßig im Ordner „Downloads“.';
  }

  @override
  String get sendCloseKeeps => 'Schließen des Fensters stoppt das Senden nicht';

  @override
  String get sendRemoveQueued => 'Entfernen';

  @override
  String get sendCannotDrop =>
      'Dieses Objekt kann nicht per Ziehen gesendet werden. Speichern Sie es zuerst als Datei oder nutzen Sie „Dateien auswählen…“.';

  @override
  String sendErrOffline(String name) {
    return '$name ist offline.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name empfängt keine Dateien.';
  }

  @override
  String get sendErrMissing => 'Einige dieser Dateien existieren nicht mehr.';

  @override
  String get relayConfirmTitle => 'Über das Relay des Dienstes senden?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name hat gerade keine Direktverbindung zu diesem Computer, daher laufen die Dateien mit etwa 0,25 MB/s über das Relay des Dienstes. Vom heutigen Relay-Kontingent sind noch $left übrig.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Diese Dateien ($size) übersteigen das verbleibende Kontingent. Ist es aufgebraucht, pausiert das Senden und läuft weiter, sobald sich die beiden Computer direkt verbinden oder das Kontingent morgen zurückgesetzt wird.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Das verbraucht etwa $size des heutigen Kontingents.';
  }

  @override
  String get relayExhausted =>
      'Das heutige Relay-Kontingent ist aufgebraucht. Es wird um Mitternacht Pekinger Zeit zurückgesetzt. Für direkt verbundene Computer gibt es kein Limit.';

  @override
  String get relayDontAskToday => 'Heute für dieses Gerät nicht mehr fragen';

  @override
  String get relaySendAnyway => 'Trotzdem senden';

  @override
  String get relayOwnServer => 'Über Relay – Tempo hängt von Ihrem Server ab';

  @override
  String get transfersReceived => 'Empfangen';

  @override
  String get transfersSent => 'Gesendet';

  @override
  String get transfersClearAll => 'Alle löschen';

  @override
  String get transfersClearTitle => 'Diese Liste löschen?';

  @override
  String get transfersClearBody =>
      'Nur die Liste wird gelöscht. Die Dateien bleiben, wo sie sind.';

  @override
  String get transfersEmptyReceived =>
      'Dateien, die Ihnen andere Geräte senden, erscheinen hier';

  @override
  String get transfersEmptySent => 'Dateien, die Sie senden, erscheinen hier';

  @override
  String transferFrom(String name) {
    return 'Von $name';
  }

  @override
  String transferTo(String name) {
    return 'An $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others weitere',
      one: '1 weitere',
    );
    return '$name und $_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien',
      one: '1 Datei',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'In Warteschlange';

  @override
  String transferScanning(String count) {
    return 'Wird gezählt… $count Dateien gefunden';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Warten auf $name…';
  }

  @override
  String get transferSending => 'Wird gesendet';

  @override
  String get transferReceiving => 'Wird empfangen';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Aktuell: $file ($index von $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Noch $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Sekunden',
      one: '1 Sekunde',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h Std. $m Min.';
  }

  @override
  String get transferPaused =>
      'Pausiert: Das heutige Relay-Kontingent ist aufgebraucht';

  @override
  String get transferInterrupted =>
      'Unterbrochen – geht nach erneuter Verbindung weiter';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Unterbrochen – warten, bis $name fortsetzt';
  }

  @override
  String get transferCancelled => 'Abgebrochen';

  @override
  String transferPeerCancelled(String name) {
    return 'Von $name abgebrochen';
  }

  @override
  String get transferExpired => 'Abgelaufen';

  @override
  String get transferMissing => 'Verschoben oder gelöscht';

  @override
  String transferNotSent(String reason) {
    return 'Nicht gesendet: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Nicht empfangen: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name hat zu wenig Speicherplatz (es fehlen $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'nicht genug Speicherplatz (es fehlen $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'Der Speicherort von $name ist nicht verfügbar';
  }

  @override
  String get reasonDestUnavailable =>
      'der Speicherort ist nicht verfügbar – prüfen Sie ihn in den Einstellungen';

  @override
  String get reasonFileTooLarge =>
      'der Speicherort liegt auf einem FAT32-Laufwerk, das keine Dateien über 4 GB aufnehmen kann';

  @override
  String reasonDisabledPeer(String name) {
    return '$name empfängt keine Dateien';
  }

  @override
  String get reasonSourceChanged =>
      'eine Datei wurde während des Sendens geändert';

  @override
  String get reasonSourceMissing => 'eine Datei existiert nicht mehr';

  @override
  String get reasonReadError => 'eine Datei konnte nicht gelesen werden';

  @override
  String get reasonWriteFailed =>
      'die Dateien konnten nicht geschrieben werden';

  @override
  String get reasonHashMismatch =>
      'eine Datei wurde bei der Übertragung beschädigt';

  @override
  String reasonUnsupported(String name) {
    return '$name braucht ein Update, um Dateien zu empfangen';
  }

  @override
  String get reasonOther => 'etwas ist schiefgelaufen';

  @override
  String get revealInFinder => 'Im Finder zeigen';

  @override
  String get revealInFolder => 'Im Ordner anzeigen';

  @override
  String get revealOpenFolder => 'Ordner öffnen';

  @override
  String get transferResend => 'Erneut senden';

  @override
  String get transferRemove => 'Aus Liste entfernen';

  @override
  String get transferCopyPath => 'Pfad kopieren';

  @override
  String get transferPathCopied => 'Pfad kopiert';

  @override
  String sendingTo(String name, String percent) {
    return 'Wird an $name gesendet · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Wird von $name empfangen · $percent';
  }

  @override
  String get receiveFiles => 'Dateien von anderen Geräten empfangen';

  @override
  String get saveTo => 'Speichern in';

  @override
  String get saveToChange => 'Ändern…';

  @override
  String get saveToDefault => 'Downloads (Standard)';

  @override
  String get saveToUseDefault => 'Downloads verwenden';

  @override
  String get receiveNotify => 'Bei eingehenden Dateien benachrichtigen';

  @override
  String receiveFootnote(String device) {
    return 'Nur gekoppelte Geräte können Ihnen auf $device Dateien senden. Während einer Übertragung wird der Ruhezustand auf $device verhindert.';
  }

  @override
  String get saveDirNotFound => 'Dieser Ordner existiert nicht.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry kann in diesem Ordner keine Dateien speichern.';

  @override
  String get saveDirPermission =>
      'PasteFerry darf diesen Ordner nicht verwenden. Erlauben Sie es unter Systemeinstellungen → Datenschutz & Sicherheit → Dateien und Ordner.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Dateinamen enthielten Zeichen, die Windows nicht erlaubt; sie wurden durch ähnliche Zeichen voller Breite ersetzt',
      one:
          '1 Dateiname enthielt Zeichen, die Windows nicht erlaubt; sie wurden durch ähnliche Zeichen voller Breite ersetzt',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Gleiches Netzwerk';

  @override
  String get sendRingOther => 'Andere Netzwerke';

  @override
  String sendOfflineList(String names) {
    return 'Offline: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Übertragungsliste';

  @override
  String get sendLayoutSide => 'Neben dem Radar';

  @override
  String get sendLayoutBelow => 'Unter dem Radar';

  @override
  String get general => 'Allgemein';

  @override
  String get launchAtLogin => 'Bei Anmeldung starten';

  @override
  String get launchAtLoginDesc =>
      'Startet bei der Anmeldung im Hintergrund. Eine Änderung beendet die laufende Sitzung nicht.';

  @override
  String get realtimeSync => 'Zwischenablage in Echtzeit synchronisieren';

  @override
  String get realtimeSyncDesc =>
      'Neu Kopiertes automatisch mit gekoppelten Geräten teilen. Wenn aus, bleiben der lokale Verlauf und „Dateien senden“ verfügbar.';

  @override
  String get syncBacklog => 'Nach erneuter Verbindung nachholen';

  @override
  String get syncBacklogDesc =>
      'Standardmäßig aus: Verpasstes wird übersprungen. Wenn an, kommen bis zu 20 Kopien der letzten 24 Stunden in den Verlauf, ohne die Zwischenablage zu ersetzen.';

  @override
  String get peerRealtimeSync => 'Mit diesem Computer synchronisieren';

  @override
  String get syncPaused => 'Sync der Zwischenablage pausiert';

  @override
  String get quitApp => 'PasteFerry beenden';

  @override
  String get quitAppDesc =>
      'Alle PasteFerry-Prozesse beenden. Die Einstellung zum Start bei der Anmeldung bleibt erhalten.';

  @override
  String get quitTransfersWarning =>
      'Es werden noch Dateien übertragen. Beenden und diese Übertragungen abbrechen?';

  @override
  String get backgroundRunningTitle => 'PasteFerry läuft weiter';

  @override
  String get backgroundRunningBody =>
      'Nach dem Schließen des Fensters laufen Sync und Schnelleinfügen weiter. Um alles zu stoppen, wählen Sie „PasteFerry beenden“ in den Einstellungen oder im App-Menü.';

  @override
  String get displayAs => 'Angezeigt als';

  @override
  String get editName => 'Namen ändern';

  @override
  String get nameHint => 'Der Name, den Ihre Kontakte sehen';

  @override
  String get nameDefaultHint =>
      'Leer lassen, um Ihren Accountnamen zu verwenden.';

  @override
  String get avatarTitle => 'Profilbild';

  @override
  String get avatarChoose => 'Bild auswählen…';

  @override
  String get avatarPaste => 'Bild einfügen';

  @override
  String get avatarReset => 'Standardbild verwenden';

  @override
  String get avatarZoom => 'Zoom';

  @override
  String get avatarDragHint => 'Ziehen, um das Bild zu verschieben.';

  @override
  String get avatarNoImage => 'In der Zwischenablage ist kein Bild.';

  @override
  String get avatarBad =>
      'Dieses Bild kann nicht verwendet werden. Wählen Sie ein PNG, JPEG oder GIF.';

  @override
  String get done => 'Fertig';

  @override
  String get friendsTitle => 'Kontakte';

  @override
  String get addFriend => 'Kontakt hinzufügen';

  @override
  String get friendsEmpty => 'Noch keine Kontakte';

  @override
  String get friendsEmptyBody =>
      'Fügen Sie jemanden hinzu, der auch PasteFerry nutzt, um sich ohne Kopplung gegenseitig Dateien zu senden. Kontakte können nur Dateien senden; Ihre Zwischenablage sehen sie nie.';

  @override
  String get friendSendAction => 'Senden…';

  @override
  String get friendHistory => 'Übertragungen';

  @override
  String friendHistoryTitle(String name) {
    return 'Übertragungen mit $name';
  }

  @override
  String get friendHistoryEmpty => 'Noch keine Übertragungen.';

  @override
  String get friendAutoAccept => 'Dateien automatisch annehmen';

  @override
  String get friendRemove => 'Kontakt entfernen';

  @override
  String friendRemoveTitle(String name) {
    return '$name entfernen?';
  }

  @override
  String get friendRemoveBody =>
      'Sie werden gegenseitig aus den Kontakten entfernt und können sich keine Dateien mehr senden. Frühere Übertragungen bleiben auf diesem Computer.';

  @override
  String friendLastActivity(String time) {
    return 'Letzte Übertragung: $time';
  }

  @override
  String get friendNoActivity => 'Noch keine Übertragungen';

  @override
  String get friendCodeShare =>
      'Senden Sie diesen Code an Ihren Kontakt. Sobald er ihn in PasteFerry eingibt, sind Sie gegenseitig als Kontakte hinzugefügt.';

  @override
  String friendCodeExpires(String time) {
    return 'Läuft ab in $time';
  }

  @override
  String get friendCodeOr => 'oder';

  @override
  String get friendCodeEnter => 'Kontaktcode der anderen Person eingeben';

  @override
  String get friendCodeAdd => 'Hinzufügen';

  @override
  String get friendCodeWaiting => 'Warten auf Eingabe…';

  @override
  String friendConfirmBody(String name) {
    return '$name zu Ihren Kontakten hinzufügen?';
  }

  @override
  String get friendSafetyCode => 'Sicherheitscode prüfen (optional)';

  @override
  String get friendSafetyHint =>
      'Wenn Sie zusammen sind, vergleichen Sie diese zwei Zeilen. Stimmen sie auf beiden Computern überein, hat niemand eingegriffen.';

  @override
  String get friendWaitingPeer =>
      'Warten, bis die andere Person Sie hinzufügt…';

  @override
  String friendAdded(String name) {
    return '$name wurde zu Ihren Kontakten hinzugefügt';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name hat abgebrochen';
  }

  @override
  String get friendErrFriendCode =>
      'Dies ist ein Kontaktcode. Geben Sie ihn unter „Kontakt hinzufügen“ auf der Seite „Dateien senden“ ein.';

  @override
  String get friendErrDeviceCode =>
      'Dies ist ein Kopplungscode. Geben Sie ihn unter Geräte → Gerät hinzufügen ein.';

  @override
  String get friendErrOutdated =>
      'Die andere Person braucht PasteFerry 2.6.0 oder neuer.';

  @override
  String get friendErrAlreadyPaired =>
      'Dieser Computer ist bereits eines Ihrer Geräte.';

  @override
  String get friendErrNoChannel =>
      'Sie sind nicht im selben Netzwerk. Aktivieren Sie auf beiden Computern den Dienst, um sich gegenseitig hinzuzufügen.';

  @override
  String get openService => 'Dienst aktivieren…';

  @override
  String get noteLabel => 'Notiz (optional)';

  @override
  String get noteHintEmpty => 'Zuerst Dateien auswählen';

  @override
  String get noteHint => 'Zum Beispiel: Bitte Seite 3 unterschreiben';

  @override
  String noteLine(String note) {
    return 'Notiz: $note';
  }

  @override
  String get sendAction => 'Senden';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count Objekte · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Dateien oder Bilder hier ablegen oder einfügen ($key)';
  }

  @override
  String get sendDropMorePaste => 'Weitere ablegen oder einfügen';

  @override
  String get sendPasteNothing =>
      'Nichts zum Einfügen. Kopieren Sie zuerst Dateien oder ein Bild.';

  @override
  String get sendRemoveItem => 'Entfernen';

  @override
  String sendFriendSaved(String name) {
    return '$name muss jede Sendung erst annehmen.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Warten, bis $name annimmt…';
  }

  @override
  String get transferAskingIn => 'Wartet auf Ihre Annahme';

  @override
  String reasonDeclined(String name) {
    return '$name hat abgelehnt';
  }

  @override
  String reasonTimeout(String name) {
    return '$name hat nicht geantwortet';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name nimmt keine Dateien an';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name nimmt Ihre Dateien gerade nicht an';
  }

  @override
  String get reasonYouDeclined => 'Abgelehnt';

  @override
  String get reasonYouIgnored => 'Ignoriert';

  @override
  String get sendAgain => 'Erneut senden';

  @override
  String incomingTitle(String name) {
    return '$name möchte Ihnen Dateien senden';
  }

  @override
  String get incomingAlways => 'Dateien von diesem Kontakt immer annehmen';

  @override
  String get incomingDecline => 'Ablehnen';

  @override
  String get incomingAccept => 'Annehmen';

  @override
  String incomingCountdown(String seconds) {
    return 'Wird in $seconds s automatisch abgelehnt';
  }

  @override
  String get incomingStranger => 'In der Nähe';

  @override
  String get friendsStrip => 'Kontakte';

  @override
  String get strangersStrip => 'In der Nähe mit „Alle“';

  @override
  String get strangerNearby => 'In der Nähe';

  @override
  String get friendNeedService => 'Dienst aktivieren';

  @override
  String get friendCantReach => 'Keine Verbindung';

  @override
  String reachSelfNoService(String name) {
    return 'Sie und $name sind nicht im selben Netzwerk. Aktivieren Sie den Dienst, um Dateien zu senden; ohne Direktverbindung laufen sie über das Relay des Dienstes.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name hat den Dienst nicht aktiviert, daher können Sie nur im selben Netzwerk Dateien senden. Bitten Sie darum, den Dienst in PasteFerry zu aktivieren.';
  }

  @override
  String get reachDifferentServer =>
      'Sie nutzen nicht denselben Server. Aktivieren Sie auf beiden Computern den Dienst oder nutzen Sie denselben Server, um Dateien zu senden.';

  @override
  String get receiveFromLabel => 'Diese Personen dürfen mir Dateien senden:';

  @override
  String get receiveFromOff => 'Niemand';

  @override
  String get receiveFromFriends => 'Nur Kontakte';

  @override
  String get receiveFromEveryone => 'Alle';

  @override
  String everyoneLeft(String minutes) {
    return 'Alle · noch $minutes Min.';
  }

  @override
  String get receiveFromOffDesc =>
      'Nur Ihre eigenen gekoppelten Computer können Ihnen Dateien senden.';

  @override
  String get receiveFromFriendsDesc =>
      'Ihre Kontakte können Ihnen Dateien senden. Sie nehmen jede Sendung selbst an.';

  @override
  String get receiveFromEveryoneDesc =>
      'Alle im selben Netzwerk können Ihnen 10 Minuten lang Dateien senden. Sie nehmen jede Sendung selbst an.';

  @override
  String get everyoneEnded => '„Alle“ ist aus; wieder „Nur Kontakte“.';

  @override
  String get friendsCountTooltip => 'Kontakte';

  @override
  String get waitingAccept => 'Warten…';

  @override
  String get settingsConnection => 'Verbindung';

  @override
  String get settingsGeneralSummary =>
      'Start bei Anmeldung, Gerätename, Sprache';

  @override
  String get settingsConnectionSummary =>
      'Dienst, eigener Server, lokales Netzwerk';

  @override
  String get settingsSyncSummary =>
      'Echtzeit-Sync, Größenlimit, was synchronisiert wird';

  @override
  String get settingsQuickPasteSummary =>
      'Tastenkürzel und was nach der Auswahl passiert';

  @override
  String get settingsSendSummary => 'Dateiempfang, Speicherort';

  @override
  String get settingsStorageSummary =>
      'Aufbewahrung des Verlaufs, belegter Speicher';

  @override
  String get settingsAboutSummary => 'Version, Updates, Feedback';

  @override
  String get friendsSubtitle =>
      'Dateien an Computer anderer Personen senden, ohne Kopplung';

  @override
  String get friendsSearch => 'Kontakte durchsuchen';

  @override
  String get friendsNoMatch => 'Keine passenden Kontakte';

  @override
  String get friendsPick =>
      'Wählen Sie einen Kontakt, um Übertragungen zu sehen oder Dateien zu senden';

  @override
  String friendDropHint(String name) {
    return 'Dateien hier ablegen, um sie an $name zu senden';
  }

  @override
  String get webShareTitle => 'Übertragung per Smartphone-Browser';

  @override
  String get webShareFootnote =>
      'Scannen Sie mit einem Smartphone einen QR-Code, um im Browser Text, Fotos und Dateien mit diesem Computer auszutauschen – ohne App. Smartphone und Computer müssen im selben Netzwerk sein.';

  @override
  String get webShareSwitch =>
      'Verbindung per Browser für Smartphones erlauben';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Smartphones',
      one: '1 Smartphone',
    );
    return 'An, $_temp0';
  }

  @override
  String get webShareOff => 'Aus';

  @override
  String get webShareShowQr => 'QR-Code anzeigen';

  @override
  String get webShareDialogTitle => 'Mit dem Smartphone scannen';

  @override
  String get webShareDialogBody =>
      'Scannen Sie mit der Kamera oder dem Browser des Smartphones und öffnen Sie den Link im Browser. Jeder QR-Code registriert ein Smartphone und wird nach der Nutzung ersetzt.';

  @override
  String get webShareAddress => 'Adresse';

  @override
  String get webShareSecurity =>
      'Inhalte werden in der Seite verschlüsselt, andere im Netzwerk können sie also nicht lesen. Die Seite selbst nutzt aber http und schützt nicht vor gezielter Manipulation. Verwenden Sie sie zu Hause oder in einem vertrauenswürdigen Büronetz, nicht in öffentlichem Wi‑Fi.';

  @override
  String get webSharePhones => 'Registrierte Smartphones';

  @override
  String get webShareNoPhones => 'Noch keine Smartphones';

  @override
  String webShareLastUsed(String time) {
    return 'Zuletzt verwendet: $time';
  }

  @override
  String get webShareRemove => 'Entfernen';

  @override
  String webShareRemoved(String name) {
    return '„$name“ entfernt';
  }

  @override
  String webShareNewPhone(String name) {
    return '„$name“ registriert';
  }

  @override
  String webShareNotListening(String error) {
    return 'Empfang konnte nicht gestartet werden: $error';
  }

  @override
  String get webSharePortFallback =>
      'Der übliche Port ist belegt, daher wird ein temporärer verwendet. Gespeicherte Adressen funktionieren erst wieder, wenn Smartphones erneut scannen.';

  @override
  String get webShareNoAddress =>
      'Keine Adresse im lokalen Netzwerk. Verbinden Sie sich zuerst mit WLAN oder einem Kabelnetzwerk.';

  @override
  String get webShareCantOpen =>
      'Öffnet sich die Seite auf dem Smartphone nicht, prüfen Sie, ob beide im selben Netzwerk sind (Gastnetzwerke funktionieren meist nicht). Unter Windows muss PasteFerry zudem durch die Firewall erlaubt sein.';

  @override
  String get mTabRecords => 'Verlauf';

  @override
  String get mTabSend => 'Senden';

  @override
  String get mThisPhone => 'Dieses Smartphone';

  @override
  String get mThisPhoneInText => 'diesem Smartphone';

  @override
  String mThisPhoneName(String name) {
    return 'Dieses Smartphone: $name';
  }

  @override
  String get mSendTitle => 'An Ihren Computer senden';

  @override
  String get mSendHint => 'Text eingeben oder einfügen';

  @override
  String get mPaste => 'Einfügen';

  @override
  String get mPhotosFiles => 'Fotos oder Dateien';

  @override
  String mSendConfirmTitle(Object n) {
    return '$n Datei(en) senden?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Dateien an Ihren Computer gesendet',
      one: '1 Datei an Ihren Computer gesendet',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Die Zwischenablage enthält keinen Text';

  @override
  String get mSendAction => 'Senden';

  @override
  String mSendTo(String names) {
    return 'Geht an $names';
  }

  @override
  String get mNoOnlineDevices => 'Keine Geräte in der Nähe online';

  @override
  String get mNoPairedDevices => 'Zuerst mit einem Computer koppeln';

  @override
  String get mSent => 'Gesendet';

  @override
  String get mSendFootnote =>
      'Text und Dateien landen im Verlauf des Computers und, je nach dessen Einstellung, in seiner Zwischenablage. Was Sie auf dem Smartphone kopieren, wird nicht automatisch gesendet.';

  @override
  String get mSentRecords => 'Gesendet';

  @override
  String get mSentRetention => 'Gesendetes behalten';

  @override
  String mSentRetentionDesc(Object d) {
    return '„Gesendet“ zeigt, was dieses Smartphone in den letzten $d Tagen gesendet hat';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d Tage';
  }

  @override
  String get mViewAll => 'Alle anzeigen';

  @override
  String get mClearCache => 'Löschen';

  @override
  String get mCheckUpdate => 'Nach Updates suchen';

  @override
  String get mUpdateFailed => 'Suche nach Updates fehlgeschlagen';

  @override
  String get mUpToDate => 'Sie sind auf dem neuesten Stand';

  @override
  String mNewVersion(Object v) {
    return 'Version $v ist verfügbar';
  }

  @override
  String get mDownloadInstall => 'Neue Version laden';

  @override
  String mSendFailed(String detail) {
    return 'Senden fehlgeschlagen: $detail';
  }

  @override
  String get mCopy => 'Kopieren';

  @override
  String get mCopied => 'In die Zwischenablage des Smartphones kopiert';

  @override
  String get mShare => 'Teilen';

  @override
  String get mSaved => 'In Fotos oder Download/PasteFerry gespeichert';

  @override
  String mActionFailed(String detail) {
    return 'Hat nicht geklappt: $detail';
  }

  @override
  String get mDownloading => 'Wird geladen…';

  @override
  String get mNotDownloaded => 'Noch nicht geladen';

  @override
  String get mDownloadHint =>
      'Wird zuerst geladen, wenn Sie auf Kopieren, Speichern oder Teilen tippen.';

  @override
  String get mFullTextLoading => 'Wird geladen…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Die ersten $shown von $total Zeichen werden angezeigt. „Kopieren“ übernimmt alles.';
  }

  @override
  String get mNotOnLanTitle => 'Nicht mit WLAN verbunden';

  @override
  String get mNotOnLanBody =>
      'Derzeit synchronisiert PasteFerry nur im lokalen Netzwerk. Verbinden Sie sich mit demselben WLAN wie Ihr Computer.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry konnte nicht starten: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Öffnen Sie auf Ihrem Computer PasteFerry → Geräte → Gerät hinzufügen und geben Sie hier den angezeigten Code ein. Im selben WLAN können Sie auch auf beiden „In der Nähe suchen“ öffnen.';

  @override
  String get mSectionSync => 'Synchronisierung';

  @override
  String get mSectionBackground => 'Hintergrund';

  @override
  String get mAutoApplyDesc =>
      'Auf Ihrem Computer kopierter Text landet direkt in der Zwischenablage dieses Smartphones. Bilder und Dateien warten, bis Sie auf Kopieren tippen.';

  @override
  String get mKeepAlive => 'Im Hintergrund verbunden bleiben';

  @override
  String get mKeepAliveDesc =>
      'Empfängt Text auch, wenn PasteFerry nicht geöffnet ist. Zeigt eine dauerhafte Benachrichtigung.';

  @override
  String get mNotifications => 'Benachrichtigungen';

  @override
  String get mNotificationsDesc =>
      'Für die dauerhafte Benachrichtigung nötig. PasteFerry funktioniert auch ohne.';

  @override
  String get mBattery => 'Im Hintergrund ausführen';

  @override
  String get mBatteryDesc =>
      'Schalten Sie die Akkuoptimierung aus, damit das System PasteFerry bei gesperrtem Bildschirm nicht beendet. Bei manchen Smartphones muss PasteFerry zusätzlich in den Einstellungen zur Autostart- oder Hintergrundliste hinzugefügt werden.';

  @override
  String get mAllowed => 'Erlaubt';

  @override
  String get mAllow => 'Erlauben';

  @override
  String mVersion(String version) {
    return 'Version $version';
  }

  @override
  String get mDeleteConfirm => 'Diesen Eintrag löschen?';

  @override
  String get mDelete => 'Löschen';

  @override
  String get webShareFirewallPreparing =>
      'Windows-Firewall wird geprüft. Wenn Windows nach Administratorrechten fragt, wählen Sie „Ja“, damit sich Ihr Smartphone verbinden kann.';

  @override
  String get webShareFirewallReady =>
      'Die Regeln der Windows-Firewall sind eingerichtet. Verbinden Sie Ihr Smartphone mit demselben Netzwerk und scannen Sie den QR-Code. Klappt die Verbindung trotzdem nicht, prüfen Sie die Firewall unten erneut.';

  @override
  String get webShareFirewallFailed =>
      'Die Firewall-Einrichtung wurde nicht abgeschlossen. Ihr Smartphone kann die Seite eventuell nicht öffnen. Versuchen Sie es erneut und bestätigen Sie die Administratoranfrage von Windows.';

  @override
  String get webShareFirewallAllow => 'Prüfen und Smartphone zulassen';

  @override
  String get mCopyMediaFailed =>
      'Dieses Bild bzw. diese Datei konnte nicht kopiert werden. Speichern Sie es zuerst.';

  @override
  String get mShareMediaFailed =>
      'Teilen ist für dieses Bild bzw. diese Datei nicht möglich. Speichern Sie es zuerst.';

  @override
  String get mSaveMediaFailed =>
      'Dieses Bild bzw. diese Datei konnte nicht gespeichert werden. Prüfen Sie den Speicherzugriff und den freien Speicherplatz und versuchen Sie es erneut.';

  @override
  String get noticeFilesUnreadable =>
      'Die gerade kopierten Dateien konnten nicht gelesen werden, daher wurde nichts synchronisiert';

  @override
  String get mAddMore => 'Weitere hinzufügen';

  @override
  String get mChoosePhotos => 'Fotos auswählen…';

  @override
  String get mMultiSelectHint =>
      'Wählen Sie mehrere Fotos auf einmal. In „Dateien“ ein Objekt gedrückt halten, um weitere auszuwählen.';

  @override
  String get webSendFiles => 'Dateien senden';

  @override
  String get webFilesQueued =>
      'Zu den Web-Übertragungen hinzugefügt. Öffnen Sie „Dateien senden“ auf Ihrem Smartphone, um sie zu laden.';

  @override
  String get webFilesLimit =>
      'Web-Downloads unterstützen bis zu 200 MB pro Datei und 64 Dateien pro Sendung.';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get settingsAppearanceSummary => 'Thema, hell und dunkel';

  @override
  String get themeTitle => 'Thema';

  @override
  String get themeDefault => 'Standard';

  @override
  String get themePixel => 'Pixel';

  @override
  String get themeMode => 'Hell und dunkel';

  @override
  String get themeModeSystem => 'Wie System';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get themeCustom => 'Eigenes';

  @override
  String get themeDelete => 'Thema löschen';

  @override
  String themeDeleteConfirm(String name) {
    return 'Das Thema „$name“ löschen?';
  }

  @override
  String get themeLowContrast =>
      'Manche Texte in diesem Thema sind eventuell schwer lesbar';

  @override
  String get themeFootnote =>
      'Themen gelten nur für dieses Gerät, inklusive Schnelleinfügen. Sie werden nicht mit anderen Geräten synchronisiert.';

  @override
  String get themeBuiltinGroup => 'Integriert';

  @override
  String get themeCustomGroup => 'Eigene';

  @override
  String get themeUse => 'Verwenden';

  @override
  String get themeDuplicate => 'Duplizieren';

  @override
  String themeCopyName(String name) {
    return '$name Kopie';
  }

  @override
  String get themeExport => 'Exportieren…';

  @override
  String get themeImport => 'Thema importieren…';

  @override
  String themeImported(String name) {
    return '„$name“ importiert';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Textfarben sind',
      one: '1 Textfarbe ist',
    );
    return '„$name“ importiert. $_temp0 eventuell schwer lesbar.';
  }

  @override
  String get themeExported => 'Thema exportiert';

  @override
  String get themeCustomEmpty =>
      'Noch keine eigenen Themen. Duplizieren Sie ein integriertes Thema, importieren Sie eines oder lassen Sie eine KI eines erstellen.';

  @override
  String get themeAskAi => 'Thema von KI erstellen lassen';

  @override
  String get themeAskAiBody =>
      'Fügen Sie diesen MCP-Server einer KI-App wie Claude oder Cursor hinzu und bitten Sie dann um ein Thema, zum Beispiel „Erstelle mir ein Cyberpunk-Thema“. Die KI liest das Themenformat, wählt Farben, prüft den Kontrast und wendet das Thema an.';

  @override
  String get themeAskAiCopy => 'Konfiguration kopieren';

  @override
  String get themeAskAiCopied => 'Konfiguration kopiert';

  @override
  String get themeScanlines => 'Scanlines';

  @override
  String get themeScanlinesDesc =>
      'Legt dezente CRT-Scanlines über das Fenster. Nur bei Pixel-Themen.';

  @override
  String get themeBackground => 'Hintergrundbild';

  @override
  String get themeBackgroundDesc =>
      'Füllt das Fenster hinter Seitenleiste und Seiten. Ein Schleier darüber hält Text lesbar.';

  @override
  String get themeBackgroundChoose => 'Bild auswählen…';

  @override
  String get themeBackgroundChange => 'Ändern…';

  @override
  String get themeBackgroundRemove => 'Entfernen';

  @override
  String get themeBlur => 'Unschärfe';

  @override
  String get themeBlurNone => 'Keine';

  @override
  String get themeBlurLight => 'Leicht';

  @override
  String get themeBlurStrong => 'Stark';

  @override
  String get themeScrim => 'Schleier';

  @override
  String get themeScrimDesc =>
      'Eine Farbschicht über dem Bild, damit Text lesbar bleibt. Sie ist nie heller, als das Bild es erfordert.';

  @override
  String get themeScrimAuto => 'Auto';

  @override
  String get themeScrimMore => 'Dichter';

  @override
  String get themeScrimMost => 'Am dichtesten';

  @override
  String get themePanels => 'Flächen';

  @override
  String get themePanelsDesc =>
      'Wie viel vom Bild durch Seitenleiste und Listen scheint.';

  @override
  String get themePanelsClear => 'Klar';

  @override
  String get themePanelsMedium => 'Mittel';

  @override
  String get themePanelsSolid => 'Deckend';

  @override
  String get themeAccentFromImage => 'Bildfarben verwenden';

  @override
  String get themeAccentFromImageDesc => 'Akzentfarbe aus dem Bild übernehmen.';

  @override
  String get themeBackgroundPicker => 'Auch beim Schnelleinfügen zeigen';

  @override
  String get themeScenery => 'Szenerie anzeigen';

  @override
  String get themeSceneryDesc =>
      'Die Bilder oben auf den Seiten und unten in der Seitenleiste.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Integrierte Themen sind nicht änderbar, daher wurde die Kopie „$name“ erstellt und angewendet';
  }

  @override
  String get themeBackgroundFootnote =>
      'Der Hintergrund gehört zum aktuellen Thema. Integrierte Themen sind nicht änderbar: Die erste Änderung erstellt eine Kopie. Bilder bleiben auf diesem Gerät; unterstützt werden JPEG, PNG und GIF.';

  @override
  String get themeSceneGroup => 'Szenerie';

  @override
  String get themeSceneHeader => 'Seitenkopf';

  @override
  String get themeSceneHeaderDesc =>
      'Ein breites Bild hinter den Seitentiteln, das nach unten in die Seite übergeht. Das Pixel-Thema zeigt hier eine Pixellandschaft.';

  @override
  String get themeSceneSidebar => 'Seitenleiste unten';

  @override
  String get themeSceneSidebarDesc =>
      'Ein kleines Bild unten in der Seitenleiste. Das Pixel-Thema zeigt hier ein kleines Lager.';

  @override
  String get themeSceneReset => 'Zurücksetzen';

  @override
  String get themeSceneFootnote =>
      'Jedes Thema kann hier eigene Bilder zeigen. Ein Schleier hält den Seitentitel lesbar. Füllt ein Hintergrundbild das Fenster, wird die Szenerie ausgeblendet.';

  @override
  String get starTitle => 'Wie gefällt Ihnen PasteFerry?';

  @override
  String get starBody =>
      'Wenn es Ihnen gefällt, wäre ein Stern auf GitHub eine große Hilfe.';

  @override
  String get starAction => 'Stern auf GitHub geben';

  @override
  String get starLater => 'Später';

  @override
  String get starDismiss => 'Nicht mehr anzeigen';
}
