// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Geçmiş';

  @override
  String get navDevices => 'Cihazlar';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navFavorites => 'Favoriler';

  @override
  String get linkConnecting => 'Bağlanıyor…';

  @override
  String get linkServiceNotRunning => 'Hizmet çalışmıyor';

  @override
  String get linkLanMode => 'Bu ağdaki cihazlar aranıyor';

  @override
  String get linkServerUnreachable =>
      'Sunucuya ulaşılamıyor; bu ağda eşzamanlanıyor';

  @override
  String get linkNothingOn => 'Yerel ağ keşfi kapalı ve sunucu ayarlanmamış';

  @override
  String get linkLanBlocked => 'macOS yerel ağı engelliyor';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cihaz çevrimiçi',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Sunucuya bağlandı';

  @override
  String linkConnectionLost(String detail) {
    return 'Bağlantı kesildi: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Hizmet bağlantısı kesildi';

  @override
  String get linkServiceDisabled => 'Arka plan eşzamanlaması kapalı';

  @override
  String get errServiceNotConnected => 'Arka plan hizmetine bağlı değil';

  @override
  String get errUnimplemented => 'Bu özellik henüz kullanılamıyor';

  @override
  String get errUnavailable => 'Arka plan hizmetine ulaşılamıyor';

  @override
  String errServiceStart(String detail) {
    return 'Arka plan hizmeti başlatılamadı: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Arka plan hizmeti yeniden başlatılamadı: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'PasteFerry oturum açılışında başlayacak şekilde ayarlanamadı: $detail';
  }

  @override
  String get thisMacTitle => 'Bu Mac';

  @override
  String get thisPcTitle => 'Bu bilgisayar';

  @override
  String get thisMacInText => 'bu Mac';

  @override
  String get thisPcInText => 'bu bilgisayar';

  @override
  String get bothMacs => 'her iki Mac';

  @override
  String get bothDevices => 'her iki cihaz';

  @override
  String get thisDeviceShort => 'Bu cihaz';

  @override
  String fromDevice(String name) {
    return 'Kaynak: $name';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get close => 'Kapat';

  @override
  String get save => 'Kaydet';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get continueAction => 'Devam';

  @override
  String get justNow => 'Az önce';

  @override
  String secondsAgo(int n) {
    return '$n sn önce';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dakika önce',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n saat önce',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gün önce',
      one: 'Dün',
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
      other: '$n saat',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gün',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Herhangi bir cihazınızda kopyalayın, burada görünür';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
    );
    return '$_temp0, $ttl boyunca saklanır';
  }

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterText => 'Metin';

  @override
  String get filterImage => 'Görseller';

  @override
  String get filterFile => 'Dosyalar';

  @override
  String get filterLink => 'Bağlantılar';

  @override
  String get historyClearTooltip => 'Geçmişi temizle';

  @override
  String get historyEmptyTitle => 'Henüz bir şey yok';

  @override
  String get historyEmptyFilteredTitle => 'Bu türde öğe yok';

  @override
  String get historyEmptyBody =>
      'Eşleştirilmiş herhangi bir cihazda metin, görsel veya dosya kopyalayın; burada görünür.';

  @override
  String get clearConfirmTitle => 'Tüm geçmiş temizlensin mi?';

  @override
  String clearConfirmBody(String device) {
    return 'Cihazlarınızdan eşzamanlanan her şey ve önbellekteki dosyalar $device üzerinden kaldırılacak. Özgün dosyalar etkilenmez.';
  }

  @override
  String get clear => 'Temizle';

  @override
  String get historyCleared => 'Geçmiş temizlendi';

  @override
  String get permDeniedTitle => 'PasteFerry panoyu okuyamıyor';

  @override
  String get permAskTitle => 'PasteFerry\'nin panoyu okumasına izin verin';

  @override
  String get permDeniedBody =>
      'Bu Mac\'te kopyaladıklarınız eşzamanlanmayacak. Sistem Ayarları\'nda PasteFerry Daemon ayarını İzin Ver olarak değiştirin.';

  @override
  String get permAskBody =>
      'Aksi halde macOS her seferinde sorar. Sistem Ayarları\'nda PasteFerry Daemon ayarını İzin Ver olarak değiştirin.';

  @override
  String get openSystemSettings => 'Sistem Ayarları\'nı aç';

  @override
  String get fetch => 'Al';

  @override
  String get fetchStarted =>
      'Alınıyor… İlerlemeyi Geçmiş bölümünde görebilirsiniz';

  @override
  String get transferFailed => 'Aktarım başarısız';

  @override
  String get expired => 'Süresi doldu';

  @override
  String get putOnClipboard => 'Panoya kopyala';

  @override
  String get putOnClipboardDone => 'Panoda';

  @override
  String get deleteRecord => 'Bu öğeyi sil';

  @override
  String get deleted => 'Silindi';

  @override
  String get emptyRecord => '(boş)';

  @override
  String get imageRecord => 'Görsel';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others öğe daha',
    );
    return '$name ve $_temp0';
  }

  @override
  String get searchHint => 'Metin ve dosya adlarında ara';

  @override
  String get searchClear => 'Aramayı temizle';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuç',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return '“$query” için sonuç yok';
  }

  @override
  String get searchEmptyBody =>
      'Arama, kopyalanan metinlere ve kopyalanan dosyaların adlarına bakar.';

  @override
  String get favoriteAction => 'Favorilere ekle';

  @override
  String get unfavoriteAction => 'Favorilerden kaldır';

  @override
  String get favoritedToast => 'Favorilere eklendi';

  @override
  String get unfavoritedToast => 'Geçmiş bölümüne geri taşındı';

  @override
  String get undo => 'Geri al';

  @override
  String get favoriteSaving => 'Kaydediliyor…';

  @override
  String favoritedAt(String date) {
    return 'Kaydedildi: $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
    );
    return '$_temp0 · hiç temizlenmez · en fazla $size';
  }

  @override
  String get favoritesEmptyTitle => 'Henüz favori yok';

  @override
  String get favoritesEmptyBody =>
      'Bir kopyasını burada saklamak için Geçmiş bölümünde bir öğeyi yıldızlayın. Favoriler hiçbir zaman otomatik olarak temizlenmez.';

  @override
  String get favoritesSearchHint => 'Favorilerde ara';

  @override
  String favoriteLargeTitle(String size) {
    return '$size boyutunda bir kopya kaydedilsin mi?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Favoriler kendi kopyasını saklar; özgün dosyaları değiştirmek veya silmek onu etkilemez. Bu, $device üzerinde $size yer kaplar.';
  }

  @override
  String get saveCopy => 'Kopyayı kaydet';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favoriniz korunur.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favoriler';

  @override
  String get favoritesUsageDesc =>
      'Yukarıdaki ayarlardan bağımsız olarak favoriler hiçbir zaman temizlenmez';

  @override
  String upToSize(String size) {
    return 'En fazla $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count karakter',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… toplam $count karakter';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tane daha',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Önce indirmek için seçin';

  @override
  String detailTotalSize(String size) {
    return 'Toplam $size';
  }

  @override
  String get quickPaste => 'Hızlı yapıştır';

  @override
  String get quickPasteWindow => 'Hızlı yapıştır penceresi';

  @override
  String get quickPasteWindowDesc =>
      'Geçmişinizi açmak için herhangi bir uygulamada kısayola basın; seçtiğiniz öğe yapıştırılır';

  @override
  String get quickPasteShortcut => 'Kısayol';

  @override
  String get quickPasteRecord => 'Değiştirmek için tıklayın';

  @override
  String get quickPasteRecording => 'Yeni kısayola basın…';

  @override
  String get quickPasteUseDefault => 'Varsayılanı kullan';

  @override
  String get quickPasteNeedsModifier =>
      '⌃, ⌥, ⇧ veya ⌘ ekleyin ya da bir işlev tuşu kullanın';

  @override
  String get quickPasteNeedsModifierPc =>
      'Ctrl, Alt, Shift veya Windows tuşunu ekleyin ya da bir işlev tuşu kullanın';

  @override
  String get quickPasteAfterPick => 'Bir öğe seçtikten sonra';

  @override
  String get quickPastePasteIt => 'Yapıştır';

  @override
  String get quickPasteCopyIt => 'Yalnızca kopyala';

  @override
  String get quickPasteIndexKey => 'İlk 9 öğeden seç';

  @override
  String get quickPasteIndexKeyDesc =>
      'Hızlı yapıştır penceresinde bu tuşu basılı tutup 1–9 tuşlarına basın';

  @override
  String get quickPasteAccessibility => 'Erişilebilirlik';

  @override
  String get quickPasteAccessibilityDesc =>
      'Sizin yerinize yapıştırmak için gerekir. İzin yoksa öğeler kopyalanır ve ⌘V tuşlarına siz basarsınız.';

  @override
  String get quickPasteAllowed => 'İzin verildi';

  @override
  String get quickPasteAllow => 'İzin ver…';

  @override
  String get quickPasteNotRunning => 'Hızlı yapıştır penceresi çalışmıyor';

  @override
  String quickPasteInUse(String key) {
    return '$key başka bir uygulama tarafından kullanılıyor. Başka bir kısayol seçin.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '$key kısayolu ayarlanamadı: $detail';
  }

  @override
  String get quickPastePortalKey => 'Sistemin kısayol ayarlarından değiştirin';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland\'de kısayolu masaüstünüzün klavye ayarlarına ekleyin. Seçilen öğeler kopyalanır; yapıştırmak için Ctrl+V tuşlarına basın.';

  @override
  String get quickPasteAddShortcut => 'Sistem kısayolu ekle';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Eklendi. Denemek için $key tuşlarına basın.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Masaüstünüzün klavye ayarlarında şu komutu çalıştıran özel bir kısayol ekleyin: $command';
  }

  @override
  String get pickerSearch => 'Ara';

  @override
  String get pickerPaste => 'Yapıştır';

  @override
  String get pickerPlainText => 'Düz metin';

  @override
  String get pickerCopyOnly => 'Yalnızca kopyala';

  @override
  String get pickerUnfavoriteHint => 'Kaldır (Geçmiş bölümüne döner)';

  @override
  String pickerPasteManually(String key) {
    return 'Seçilen öğeler kopyalanır — yapıştırmak için $key tuşlarına basın';
  }

  @override
  String get pickerGrantHint =>
      'Doğrudan yapıştırmak için Erişilebilirlik izni verin';

  @override
  String pickerElevated(String key) {
    return 'Bu pencere yönetici olarak çalışıyor — seçtikten sonra yapıştırmak için $key tuşlarına basın';
  }

  @override
  String get pickerDownloading => 'İndiriliyor — bitince yapıştırılacak';

  @override
  String get imagePreviewTitle => 'Görsel önizlemesi';

  @override
  String get closePreview => 'Önizlemeyi kapat';

  @override
  String get previousImage => 'Önceki görsel';

  @override
  String get nextImage => 'Sonraki görsel';

  @override
  String get previewHint =>
      'Yakınlaştırmak için kaydırın veya kıstırın, gezinmek için sürükleyin';

  @override
  String get fitWindow => 'Pencereye sığdır';

  @override
  String get previewDeleted => 'Bu görsel geçmişten silindi';

  @override
  String get previewExpired => 'Bu görselin süresi doldu ve önizlenemiyor';

  @override
  String get previewDownloading => 'Görsel indiriliyor…';

  @override
  String get previewDownloadFailed =>
      'İndirme başarısız oldu. Yeniden deneyin.';

  @override
  String get previewNotDownloaded => 'Bu görsel henüz bu bilgisayarda değil';

  @override
  String get downloadAndPreview => 'İndir ve önizle';

  @override
  String get previewUnavailable => 'Bu görsel şu anda önizlenemiyor';

  @override
  String get imageSemantic => 'Geçmişteki görsel';

  @override
  String get previewUnreadable =>
      'Görsel okunamıyor. Dosya temizlenmiş veya bozulmuş olabilir.';

  @override
  String get devicesSubtitleEmpty =>
      'Eşleştirildikten sonra cihazlarınız tek bir panoyu paylaşır';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired eşleştirilmiş, $online çevrimiçi';
  }

  @override
  String get addDevice => 'Cihaz ekle';

  @override
  String thisDeviceFootnote(String both) {
    return 'Eşleştirme sırasında $both, her cihaz için birer satır olmak üzere aynı iki satır güvenlik parmak izini gösterir. Yalnızca karakteri karakterine eşleşiyorsa onaylayın.';
  }

  @override
  String get noDevicesTitle => 'Henüz eşleştirilmiş cihaz yok';

  @override
  String get noDevicesBody =>
      'Diğer bilgisayarınızda PasteFerry\'yi açın ve ikisini 6 karakterli bir eşleştirme koduyla bağlayın. Aynı ağdaysanız her ikisinde de Yakındakileri ara penceresini açıp diğerine tıklayabilirsiniz.';

  @override
  String get pairedDevices => 'Eşleştirilmiş cihazlar';

  @override
  String get pairedFootnote =>
      'Doğrudan: veriler iki cihaz arasında doğrudan gider. Aktarma: ağ doğrudan yolu engellediğinde veriler sunucunuz üzerinden gider ve uçtan uca şifreli kalır.';

  @override
  String get offline => 'Çevrimdışı';

  @override
  String get direct => 'Doğrudan';

  @override
  String get relay => 'Aktarma';

  @override
  String get online => 'Çevrimiçi';

  @override
  String get moreActions => 'Diğer';

  @override
  String get copyFingerprint => 'Parmak izini kopyala';

  @override
  String get unpairEllipsis => 'Eşleştirmeyi kaldır…';

  @override
  String get fingerprintCopied => 'Parmak izi kopyalandı';

  @override
  String unpairTitle(String name) {
    return '“$name” ile eşleştirme kaldırılsın mı?';
  }

  @override
  String get unpairBody =>
      'İki cihaz artık eşzamanlanmayacak. Yeniden eşzamanlamak için onları tekrar eşleştirmeniz ve parmak izlerini yeniden kontrol etmeniz gerekir.';

  @override
  String get unpair => 'Eşleştirmeyi kaldır';

  @override
  String get unpaired => 'Eşleştirme kaldırıldı';

  @override
  String get enterAddressEllipsis => 'Adresini gir…';

  @override
  String setAddressTitle(String name) {
    return '“$name” cihazının adresi';
  }

  @override
  String setAddressBody(String name) {
    return 'İki cihaz farklı alt ağlardaysa veya ikisinin de adresi değiştiyse bunu kullanın. “$name” üzerinde Cihaz ekle → Kod göster altında görünen adresi girin.';
  }

  @override
  String get addressSaved => 'O adreste aranıyor';

  @override
  String get lanBlockedTitle => 'macOS yerel ağı engelliyor';

  @override
  String lanBlockedBody(String device) {
    return 'Sistem Ayarları → Gizlilik ve Güvenlik → Yerel Ağ bölümünde PasteFerry Daemon seçeneğini açın. O zamana kadar $device, bu ağdaki cihazlara bağlanamaz.';
  }

  @override
  String get searchNearby => 'Yakındakileri ara';

  @override
  String get nearbyTitle => 'Yakındaki cihazlar';

  @override
  String get nearbySearching => 'Yakındaki cihazlar aranıyor…';

  @override
  String get nearbyHint =>
      'Diğer bilgisayarda da Yakındakileri ara penceresini açın, burada görünür. Eşleştirmek için üzerine tıklayın.';

  @override
  String nearbyVisible(String device) {
    return 'Bu pencere açıkken bu ağdaki cihazlar, $device için ayarlanan adı görebilir.';
  }

  @override
  String get nearbyPaired => 'Eşleştirildi';

  @override
  String nearbyRequesting(String name) {
    return '“$name” ile iletişim kuruluyor…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” yanıt vermedi. O cihazda Yakındakileri ara penceresinin hâlâ açık olduğundan emin olun.';
  }

  @override
  String get nearbyLanOffTitle => 'Yerel ağ keşfi kapalı';

  @override
  String get nearbyLanOffBody =>
      'Yakındaki cihazları görmek için Ayarlar → Bağlantı bölümünde “Bu ağdaki cihazları bul” seçeneğini açın ya da bunun yerine kodla eşleştirin.';

  @override
  String get generateCode => 'Kod göster';

  @override
  String get enterCode => 'Kod gir';

  @override
  String get codeFailedTitle => 'Eşleştirme kodu oluşturulamadı';

  @override
  String get enterOnOther => 'Bu kodu diğer cihazınıza girin';

  @override
  String get codeCopied => 'Kod kopyalandı';

  @override
  String get codeHint => 'Kopyalamak için tıklayın. 5 dakika geçerlidir.';

  @override
  String afterEnterFootnote(String both) {
    return 'Kod girildiğinde $both aynı iki satır güvenlik parmak izini gösterir. Yalnızca eşleşiyorsa onaylayın.';
  }

  @override
  String get codeInvalid => 'Eşleştirme kodu 6 harf veya rakamdan oluşur';

  @override
  String get localAddress => 'Adres';

  @override
  String get addressHint =>
      'Farklı bir alt ağda mı? Bu adresi diğer cihaza da girin.';

  @override
  String get addressCopied => 'Adres kopyalandı';

  @override
  String get differentSubnet => 'Farklı bir alt ağda mı?';

  @override
  String get peerAddress => 'Kodun altında görünen adres';

  @override
  String get pairNotFound =>
      'O cihaz bulunamadı. Farklı bir alt ağdaysa kodunun altında görünen adresi girin.';

  @override
  String get pairNotFoundAddress =>
      'O adreste yanıt veren olmadı. Adresi ve diğer cihazın kodu hâlâ gösterdiğini kontrol edin. O cihazdaki bir güvenlik duvarı da bağlantıyı engelliyor olabilir.';

  @override
  String get codeWrong => 'Bu kod yanlış ya da süresi dolmuş';

  @override
  String get codeExpired =>
      'Bu kodun süresi doldu. Diğer cihazda yeni bir kod gösterin.';

  @override
  String get addressInvalid =>
      'Bu adres geçerli değil. 192.168.1.20 gibi bir adres girin.';

  @override
  String get pairNoChannel =>
      'Önce Ayarlar → Bağlantı bölümünde yerel ağ keşfini açın veya bir sunucu ayarlayın.';

  @override
  String get enterCodeShown => 'Diğer cihazınızda görünen kodu girin';

  @override
  String get pairingDone => 'Eşleştirildi';

  @override
  String get pairingRejected => 'Eşleştirme reddedildi';

  @override
  String get verifyTitle => 'Güvenlik parmak izlerini kontrol edin';

  @override
  String pairingWith(String name) {
    return '“$name” ile eşleştiriliyor';
  }

  @override
  String verifyBody(String both) {
    return '$both üzerindeki iki satır birebir aynı olmalıdır. Tek bir karakter bile farklıysa biri bağlantıya müdahale ediyor olabilir; bu durumda reddedin.';
  }

  @override
  String get rejectMismatch => 'Eşleşmiyor, reddet';

  @override
  String get confirmMatch => 'Eşleşiyor, eşleştir';

  @override
  String get server => 'Sunucu (isteğe bağlı)';

  @override
  String get signalingUrl => 'Sinyal sunucusu';

  @override
  String get signalingUrlDesc => 'Yalnızca yerel eşzamanlama için boş bırakın';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'Doğrudan bağlantıları iyileştir';

  @override
  String get publicStunDesc => 'Genel sunucular genel IP adresinizi görebilir';

  @override
  String get connectionStatus => 'Bağlantı';

  @override
  String get disconnectedDesc =>
      'Sunucu adresini ve erişilebilirliğini kontrol edin';

  @override
  String get connected => 'Bağlı';

  @override
  String get notConnected => 'Bağlı değil';

  @override
  String get notSet => 'Ayarlanmadı';

  @override
  String get serverCleared =>
      'Sunucu kaldırıldı. Yalnızca bu ağda eşzamanlanıyor.';

  @override
  String get localNetwork => 'Yerel ağ';

  @override
  String get lanDiscovery => 'Bu ağdaki cihazları bul';

  @override
  String get lanDiscoveryDesc =>
      'Anonim keşif; adlar yalnızca yakındakiler aranırken görünür';

  @override
  String get macLocalNetwork => 'Yerel Ağ erişimi';

  @override
  String get macLocalNetworkDesc =>
      'Sistem Ayarları\'nda PasteFerry Daemon için izin verin';

  @override
  String get allowLan => 'Windows Güvenlik Duvarı';

  @override
  String get allowLanDesc =>
      'Engellenen bağlantılara izin verir; yönetici onayı gerekir';

  @override
  String get allow => 'İzin ver';

  @override
  String get allowLanDone =>
      'İzin verildi. Diğer cihazlar artık bu cihaza ulaşabilir.';

  @override
  String get deviceName => 'Cihaz adı';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get sync => 'Eşzamanlama';

  @override
  String get autoSyncLimit => 'Otomatik eşzamanlama sınırı';

  @override
  String get autoSyncLimitDesc =>
      'Daha büyük öğeleri Geçmiş bölümünden elle alın';

  @override
  String get autoApply => 'Alınan öğeleri panoya koy';

  @override
  String get whatToSync => 'Neler eşzamanlansın';

  @override
  String get syncFiles => 'Dosyalar ve klasörler';

  @override
  String get syncText => 'Düz metin';

  @override
  String get syncRich => 'Zengin metin';

  @override
  String get syncImages => 'Görseller ve ekran görüntüleri';

  @override
  String get storage => 'Depolama';

  @override
  String get storageFootnote =>
      'Süresi dolan geçmiş ve önbellekteki dosyalar otomatik olarak silinir.';

  @override
  String get keepHistory => 'Geçmişi saklama süresi';

  @override
  String get keepCache => 'Önbellek dosyalarını saklama süresi';

  @override
  String get keepCacheDesc => 'Geçmiş saklama süresinden uzun olamaz';

  @override
  String get cacheUsage => 'Önbellek boyutu';

  @override
  String get backgroundSync => 'Arka plan eşzamanlaması';

  @override
  String get backgroundService => 'Arka plan hizmeti';

  @override
  String get backgroundServiceDesc =>
      'Oturum açılışında başlar; pencere kapalıyken de eşzamanlar';

  @override
  String get restart => 'Yeniden başlat';

  @override
  String get restarted => 'Arka plan hizmeti yeniden başlatıldı';

  @override
  String get disableEllipsis => 'Kapat…';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutDesc => 'AGPL-3.0 lisanslı açık kaynak yazılım';

  @override
  String get homepage => 'Web sitesi';

  @override
  String get feedback => 'Sorun bildir';

  @override
  String get disableTitle => 'Arka plan eşzamanlaması kapatılsın mı?';

  @override
  String disableBody(String device) {
    return '$device üzerindeki PasteFerry eşzamanlamayı durdurur ve oturum açılışında başlamaz. Geçmiş ve eşleştirmeler korunur.';
  }

  @override
  String get disable => 'Kapat';

  @override
  String get disabled => 'Arka plan eşzamanlaması kapalı';

  @override
  String get urlMustBeWs => 'Adres ws:// veya wss:// ile başlamalıdır';

  @override
  String get serverUpdated => 'Sunucu güncellendi. Yeniden bağlanıyor…';

  @override
  String get deviceNameUpdated => 'Cihaz adı güncellendi';

  @override
  String get diagIntro =>
      'Bu rapor uygulama sürümünü, sisteminizi, ayarlarınızı, cihazlarınızı ve son günlükleri içerir. Cihaz adları, sunucu adresi, genel IP adresleri, kullanıcı klasörünüz ve dosya adları değiştirilir; kopyaladıklarınız asla günlüklere yazılmaz. GitHub\'daki sorun kayıtları herkese açıktır, bu yüzden göndermeden önce baştan sona okuyun.';

  @override
  String get diagVerboseTitle => 'Ayrıntılı günlük';

  @override
  String get diagVerboseDesc =>
      'Bağlantı sorunları için: açın, sorunu yeniden oluşturun, sonra rapor için geri gelin. 30 dakika sonra kendiliğinden kapanır.';

  @override
  String get diagVerboseOn => '30 dakikalığına aç';

  @override
  String diagVerboseUntil(String time) {
    return '$time saatine kadar açık';
  }

  @override
  String get diagVerboseOff => 'Kapat';

  @override
  String get diagRefresh => 'Yeniden oluştur';

  @override
  String get diagSave => 'Dosya olarak kaydet';

  @override
  String diagSaved(String name) {
    return 'İndirilenler klasörüne kaydedildi: $name';
  }

  @override
  String get diagCopy => 'Raporu kopyala';

  @override
  String get diagCopied => 'Rapor kopyalandı';

  @override
  String get diagNewIssue => 'GitHub\'da yeni sorun kaydı';

  @override
  String get diagIssueHint =>
      'Rapor kopyalandı. Sorun kaydındaki “Diagnostics report” kutusuna yapıştırın.';

  @override
  String diagFailed(String detail) {
    return 'Rapor oluşturulamadı: $detail';
  }

  @override
  String get svcExtractTitle => 'Önce PasteFerry\'yi kurun veya ayıklayın';

  @override
  String get svcExtractBody =>
      'PasteFerry doğrudan zip dosyasından çalışıyor; bulunduğu geçici klasör, uygulamayı kapattığınızda silinir. Arka plan eşzamanlamasını açmak için yükleyiciyi çalıştırın ya da klasörün tamamını ayıklayıp oradan açın.';

  @override
  String get svcMoveTitle =>
      'Önce PasteFerry\'yi Uygulamalar klasörüne taşıyın';

  @override
  String get svcMoveBody =>
      'PasteFerry doğrudan disk görüntüsünden çalışıyor. Arka plan eşzamanlamasını açmak için onu Uygulamalar klasörüne sürükleyin, disk görüntüsünü çıkarın ve Uygulamalar klasöründen açın.';

  @override
  String get svcStartTitle => 'PasteFerry\'yi kullanmaya başlayın';

  @override
  String get svcStartBody =>
      'PasteFerry, pano eşzamanlaması için küçük bir arka plan işlemi çalıştırır. Pencereyi kapatmak onu durdurmaz. Oturum açılışında başlatma ayrı bir ayardır ve yeni kurulumlarda kapalıdır.';

  @override
  String get svcEnable => 'Arka plan eşzamanlamasını aç';

  @override
  String get svcStaleTitle => 'Arka plan eşzamanlamasını yeniden açın';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry taşındı ancak oturum açılışında başlatma hâlâ eski konumu gösteriyor. Arka plan işleminin bu kopyayı kullanması için yeniden açın. Geçmiş ve eşleştirmeler korunur.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry taşındı ya da eski bir betikle kuruldu. Arka plan işleminin bu uygulamayı kullanması için yeniden açın. Geçmiş ve eşleştirmeler korunur.';

  @override
  String get svcReenable => 'Yeniden aç';

  @override
  String get svcStoppedTitle => 'Arka plan hizmeti çalışmıyor';

  @override
  String get svcStoppedBody =>
      'Arka plan hizmeti durduruldu. Aşağıdaki düğmeyle başlatın; oturum açılışında başlatma Ayarlar\'dan ayrıca yönetilir.';

  @override
  String get svcDevBodyWin =>
      'Bu, yanında pasteferryd.exe bulunmayan bir geliştirme derlemesi. Tam sürümü derlemek için kaynak klasöründe scripts\\build-windows.ps1 komutunu çalıştırın.';

  @override
  String get svcDevBodyLinux =>
      'Bu, yanında pasteferryd bulunmayan bir geliştirme derlemesi. Tam sürümü derlemek için kaynak klasöründe ./scripts/package-linux.sh komutunu çalıştırın.';

  @override
  String get svcDevBodyMac =>
      'Bu, arka plan hizmeti içermeyen bir geliştirme derlemesi. Kurmak için kaynak klasöründe ./scripts/install-macos.sh komutunu çalıştırın.';

  @override
  String svcLogPath(String path) {
    return 'Günlük: $path';
  }

  @override
  String get svcCanDisable =>
      'Arka plan eşzamanlamasını istediğiniz zaman Ayarlar\'dan kapatabilirsiniz.';

  @override
  String get officialService => 'Hizmet';

  @override
  String get useOfficialService => 'Hizmeti kullan';

  @override
  String get officialServiceDesc =>
      'Ağlar arası eşzamanlama, önce doğrudan bağlantı';

  @override
  String get officialPrivacy =>
      'Hizmete yalnızca etkinleştirildiğinde bağlanır ve gerekli bağlantı bilgilerini kaydeder. Önce doğrudan bağlantı denenir; aktarma erişimi yalnızca bu başarısız olursa istenir. İçerik, gerçek cihaz adları ve ham sistem tanımlayıcıları yüklenmez.';

  @override
  String get officialEnableTitle => 'Hizmet etkinleştirilsin mi?';

  @override
  String get officialSwitchConfirm =>
      'Bu işlem özel sunucunuzdan geçiş yapar. Kayıtlı adresi saklanır.';

  @override
  String get customServer => 'Özel sunucu';

  @override
  String get saveAndConnect => 'Kaydet ve bağlan';

  @override
  String get officialLoading => 'Kota kontrol ediliyor…';

  @override
  String get officialFetchFailed =>
      'Kota şu anda alınamıyor. Otomatik olarak yeniden denenecek.';

  @override
  String get officialUnavailable =>
      'Kullanım bilgisi alınamıyor; mevcut veriler güncel olmayabilir';

  @override
  String get officialQuotaTitle => 'Günlük aktarma kotası doldu';

  @override
  String get officialQuotaBody =>
      'Hizmet aktarması, Pekin saatiyle gece yarısı yapılan günlük sıfırlamaya kadar duraklatıldı. Yerel ağ ve doğrudan internet bağlantıları kullanılabilir. Başarısız aktarımlar daha sonra yeniden denenebilir.';

  @override
  String get officialPeerQuota =>
      'Karşı cihazın aktarma kotası kalmadı. Doğrudan bağlantılar kullanılabilir.';

  @override
  String get officialPaused =>
      'Hizmet aktarması kullanılamıyor. Doğrudan bağlantılar kullanılabilir.';

  @override
  String get officialViewUsage => 'Kullanımı görüntüle';

  @override
  String get officialAcknowledge => 'Anladım';

  @override
  String get officialToday => 'Bugünkü aktarma kotası';

  @override
  String get officialUsed => 'Kullanılan';

  @override
  String get officialRemaining => 'Kalan';

  @override
  String get officialDailyLimit => 'Günlük kota';

  @override
  String get officialUpload => 'Yükleme';

  @override
  String get officialDownload => 'İndirme';

  @override
  String get officialReset => 'Sıfırlanma saati (Pekin)';

  @override
  String get officialUpdated => 'Son güncelleme';

  @override
  String get officialRoutes => 'Cihazlar nasıl bağlanıyor';

  @override
  String get officialRoutesFootnote =>
      'Doğrudan bağlantılar Hizmet aktarmasından geçmez ve kotayı kullanmaz.';

  @override
  String get officialDeviceID => 'Cihaz kimliği';

  @override
  String get officialWarning =>
      'Günlük aktarma kotasının %90\'ı kullanıldı. Doğrudan bağlantılar bu kotayı tüketmez.';

  @override
  String get updateCheck => 'Güncellemeleri denetle';

  @override
  String get updateCheckEllipsis => 'Güncellemeleri denetle…';

  @override
  String get updateAuto => 'Güncellemeleri otomatik olarak denetle';

  @override
  String get updateChecking => 'Güncellemeler denetleniyor…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version en son sürüm.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version kullanılabilir';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Mevcut sürüm: $current. İndirme boyutu: $size.';
  }

  @override
  String get updateNew => 'Yeni';

  @override
  String get updateFixed => 'Düzeltilen';

  @override
  String get updateSkip => 'Bu sürümü atla';

  @override
  String get updateLater => 'Daha sonra';

  @override
  String get updateInstall => 'İndir ve kur';

  @override
  String updateDownloading(String done, String total) {
    return 'İndiriliyor: $done / $total';
  }

  @override
  String get updateVerifying => 'İndirilen dosya denetleniyor…';

  @override
  String get updateInstalling =>
      'Kuruluyor. PasteFerry kendiliğinden yeniden açılacak.';

  @override
  String get updateInstallingPassword =>
      'Kuruluyor. /opt yönetici izni gerektirdiğinden sistem parolanızı soracak; ardından PasteFerry kendiliğinden yeniden açılacak.';

  @override
  String get updateCheckFailed =>
      'GitHub ve Gitee sunucularına ulaşılamadı. Daha sonra yeniden deneyin.';

  @override
  String get updateDownloadFailed =>
      'İndirme tamamlanmadı. Yeniden deneyin ya da yeni sürümü web sitesinden indirin.';

  @override
  String updateInstallFailed(String error) {
    return 'Kurulum başlatılamadı: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Bu derleme güncellemeleri denetleyemez.';

  @override
  String get updateBlockedDev =>
      'Bu bir geliştirme derlemesi, bu yüzden kendini güncelleyemez.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry disk görüntüsünden çalışıyor. Otomatik güncelleme için onu Uygulamalar klasörüne sürükleyip oradan açın.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry kurulu olduğu klasöre yazamıyor. Bunun yerine yeni sürümü web sitesinden indirin.';

  @override
  String get updateBlockedUnsupported =>
      'Bu bilgisayar için otomatik güncelleme yok. Yeni sürümü web sitesinden indirin.';

  @override
  String get updateOpenDownload => 'İndirme sayfasını aç';

  @override
  String updateSidebar(String version) {
    return '$version sürümü kullanılabilir';
  }

  @override
  String updatedTo(String version) {
    return '$version sürümüne güncellendi';
  }

  @override
  String updateNotFinished(String version) {
    return 'Güncelleme tamamlanmadı. Hâlâ $version sürümünü kullanıyorsunuz.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Güncelleme tamamlanmadı. Hâlâ $version sürümünü kullanıyorsunuz. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Arayüz $uiVersion · Hizmet $serviceVersion · Derleme $build';
  }

  @override
  String get notReceived => 'Alınmadı — yapıştırmadan önce alın';

  @override
  String get receivedPreserved =>
      'Alındı; hazır olduğunuzda Panoya kopyala düğmesini kullanın';

  @override
  String get clipboardWriteFailed => 'Alındı ancak pano güncellenemedi';

  @override
  String get receivingStatus => 'Alınıyor…';

  @override
  String get largeFileNotifications => 'Büyük dosya hatırlatıcıları';

  @override
  String get notificationsAllowed =>
      'Bildirimler açık. İlerleme Geçmiş bölümünde gösterilir.';

  @override
  String get notificationsNotRequested =>
      'Büyük dosyaların sessizce beklememesi için bildirimleri açın. Onları her zaman Geçmiş bölümünden de alabilirsiniz.';

  @override
  String get notificationsDenied =>
      'Bildirimler sistem ayarlarında engellenmiş. Bekleyen öğeleri Geçmiş bölümünden alın.';

  @override
  String get notificationsUnknown =>
      'Bildirimlerin iletilmesini ve Rahatsız Etme modunu masaüstünüz yönetir. Hatırlatıcı görünmezse öğeleri Geçmiş bölümünden alın.';

  @override
  String get notificationsUnavailable =>
      'Sistem bildirimleri kullanılamıyor. Büyük dosyaları Geçmiş bölümünden alın.';

  @override
  String get enableNotifications => 'Hatırlatıcıları aç';

  @override
  String get notificationSettings => 'Bildirim ayarları';

  @override
  String get notifyPendingTitle => 'Yapıştırmak için alın';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nYapıştırmadan önce bu öğeyi alın. Geçmiş bölümünden de alabilirsiniz.';
  }

  @override
  String get notifyReceivingTitle => 'Alınıyor…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nİlerlemeyi Geçmiş bölümünde görebilirsiniz.';
  }

  @override
  String get notifyReadyTitle => 'Yapıştırmaya hazır';

  @override
  String notifyReadyBody(String name) {
    return '$name\nAlındı ve panoya kopyalandı.';
  }

  @override
  String get notifyReceivedTitle => 'Alındı';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nPanonuz korundu. Hazır olduğunuzda Panoya kopyala düğmesini kullanın; bu seçenek Geçmiş bölümünde de var.';
  }

  @override
  String get notifyFailedTitle => 'Alınamadı';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nBu bildirimden veya Geçmiş bölümünden yeniden deneyin.';
  }

  @override
  String get notifyClipboardFailedTitle => 'Alındı; pano güncellenmedi';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nYeniden denemek için burada veya Geçmiş bölümünde Panoya kopyala düğmesini kullanın.';
  }

  @override
  String get reconnect => 'Yeniden bağlan';

  @override
  String get reconnecting => 'Bağlanıyor…';

  @override
  String get reconnectDirect => 'Doğrudan bağlandı';

  @override
  String get reconnectRelay =>
      'Doğrudan bağlanılamadı, aktarma kullanılmaya devam ediyor';

  @override
  String reconnectOffline(String name) {
    return '“$name” çevrimdışı. O cihazda PasteFerry\'nin açık olduğundan emin olun.';
  }

  @override
  String get reconnectPending => 'Hâlâ bağlanıyor, birazdan tekrar bakın';

  @override
  String get renameAction => 'Yeniden adlandır';

  @override
  String get renameFavoriteTitle => 'Favoriyi yeniden adlandır';

  @override
  String get renameFavoriteHint =>
      'Favoriler\'de ve Hızlı yapıştır\'da gösterilir, aramada da bulunur. İçeriği yeniden göstermek için boş bırakın.';

  @override
  String get renamedToast => 'Yeniden adlandırıldı';

  @override
  String get aliasClearedToast => 'İçerik yeniden gösteriliyor';

  @override
  String get navSend => 'Dosya Gönder';

  @override
  String get sendSubtitle =>
      'Doğrudan göndermek için dosyaları bir cihazın üzerine sürükleyin';

  @override
  String get sendNoDevicesTitle => 'Henüz eşleştirilmiş cihaz yok';

  @override
  String get sendNoDevicesBody =>
      'Önce başka bir bilgisayarı eşleştirin, sonra buradan ona dosya gönderin.';

  @override
  String get sendDropHint => 'Göndermek için bir cihazın üzerine bırakın';

  @override
  String sendReleaseTo(String name) {
    return 'Bırakınca $name alıcısına gönderilir';
  }

  @override
  String get sendLan => 'Yerel ağ';

  @override
  String sendRelayLeft(String left) {
    return 'Aktarma · bugün $left kaldı';
  }

  @override
  String get sendNeedsUpdate => 'Güncelleme gerekli';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name, PasteFerry 2.5 veya sonraki bir sürüme güncellendikten sonra dosya alabilir.';
  }

  @override
  String sendConnectingTip(String name) {
    return '$name ile bağlantı kuruluyor. Bağlantı kurulunca gönderebilirsiniz.';
  }

  @override
  String get sendNotReceiving => 'Dosya almıyor';

  @override
  String get sendDelivered => 'Teslim edildi';

  @override
  String sendToTitle(String name) {
    return 'Alıcı: $name';
  }

  @override
  String get sendDropHere => 'Dosyaları veya klasörleri buraya sürükleyin';

  @override
  String get sendDropStarts => 'Bıraktığınız anda gönderim başlar';

  @override
  String get sendChooseFiles => 'Dosya Seç…';

  @override
  String get sendChooseFolder => 'Klasör Seç…';

  @override
  String get sendDropMore =>
      'Sırada gönderilmeleri için daha fazla dosya bırakın';

  @override
  String sendSavedWhere(String name) {
    return 'Dosyalar $name tarafından seçilen konuma kaydedilir — varsayılan olarak İndirilenler klasörüne.';
  }

  @override
  String get sendCloseKeeps => 'Bu pencereyi kapatmak gönderimi durdurmaz';

  @override
  String get sendRemoveQueued => 'Kaldır';

  @override
  String get sendCannotDrop =>
      'Bu öğe sürükleyerek gönderilemez. Önce dosya olarak kaydedin ya da Dosya Seç… seçeneğini kullanın.';

  @override
  String sendErrOffline(String name) {
    return '$name çevrimdışı.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name dosya almıyor.';
  }

  @override
  String get sendErrMissing => 'Bu dosyalardan bazıları artık mevcut değil.';

  @override
  String get relayConfirmTitle => 'Hizmet aktarması üzerinden gönderilsin mi?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name ile bu bilgisayar arasında şu anda doğrudan bağlantı yok; bu yüzden dosyalar Hizmet aktarması üzerinden yaklaşık 0,25 MB/sn hızla gider. Bugünkü aktarma kotasından $left kaldı.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Bu dosyalar ($size) kalan kotadan fazla. Kota bitince gönderim duraklar; iki bilgisayar doğrudan bağlandığında veya kota yarın sıfırlandığında devam eder.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Bu işlem bugünkü kotanın yaklaşık $size kadarını kullanır.';
  }

  @override
  String get relayExhausted =>
      'Bugünkü aktarma kotası doldu. Pekin saatiyle gece yarısı sıfırlanır. Doğrudan bağlanan iki bilgisayar için sınır yoktur.';

  @override
  String get relayDontAskToday => 'Bu cihaz için bugün bir daha sorma';

  @override
  String get relaySendAnyway => 'Yine de Gönder';

  @override
  String get relayOwnServer => 'Aktarılıyor — hız sunucunuza bağlı';

  @override
  String get transfersReceived => 'Alınanlar';

  @override
  String get transfersSent => 'Gönderilenler';

  @override
  String get transfersClearAll => 'Tümünü Temizle';

  @override
  String get transfersClearTitle => 'Bu liste temizlensin mi?';

  @override
  String get transfersClearBody =>
      'Yalnızca liste temizlenir. Dosyalar yerinde kalır.';

  @override
  String get transfersEmptyReceived =>
      'Diğer cihazların size gönderdiği dosyalar burada görünür';

  @override
  String get transfersEmptySent => 'Gönderdiğiniz dosyalar burada görünür';

  @override
  String transferFrom(String name) {
    return 'Gönderen: $name';
  }

  @override
  String transferTo(String name) {
    return 'Alıcı: $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name ve $others öğe daha';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'Sırada';

  @override
  String transferScanning(String count) {
    return 'Sayılıyor… $count dosya bulundu';
  }

  @override
  String transferWaitingPeer(String name) {
    return '$name bekleniyor…';
  }

  @override
  String get transferSending => 'Gönderiliyor';

  @override
  String get transferReceiving => 'Alınıyor';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Şu an: $file ($index/$total)';
  }

  @override
  String transferLeft(String time) {
    return '$time kaldı';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n saniye',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dakika',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h sa $m dk';
  }

  @override
  String get transferPaused => 'Duraklatıldı: bugünkü aktarma kotası doldu';

  @override
  String get transferInterrupted => 'Kesildi — yeniden bağlanınca devam eder';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Kesildi — $name devam ettirene kadar bekleniyor';
  }

  @override
  String get transferCancelled => 'İptal edildi';

  @override
  String transferPeerCancelled(String name) {
    return '$name iptal etti';
  }

  @override
  String get transferExpired => 'Süresi doldu';

  @override
  String get transferMissing => 'Taşındı veya silindi';

  @override
  String transferNotSent(String reason) {
    return 'Gönderilmedi: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Alınmadı: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name: disk alanı yetersiz ($size eksik)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'disk alanı yetersiz ($size eksik)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name: kaydetme konumu kullanılamıyor';
  }

  @override
  String get reasonDestUnavailable =>
      'kaydetme konumu kullanılamıyor — Ayarlar\'dan kontrol edin';

  @override
  String get reasonFileTooLarge =>
      'kaydetme konumu FAT32 biçimli bir sürücüde ve bu sürücü 4 GB\'tan büyük dosyaları tutamaz';

  @override
  String reasonDisabledPeer(String name) {
    return '$name dosya almıyor';
  }

  @override
  String get reasonSourceChanged => 'bir dosya gönderilirken değiştirildi';

  @override
  String get reasonSourceMissing => 'bir dosya artık mevcut değil';

  @override
  String get reasonReadError => 'bir dosya okunamadı';

  @override
  String get reasonWriteFailed => 'dosyalar yazılamadı';

  @override
  String get reasonHashMismatch => 'bir dosya aktarım sırasında bozuldu';

  @override
  String reasonUnsupported(String name) {
    return '$name dosya alabilmek için güncellenmeli';
  }

  @override
  String get reasonOther => 'bir sorun oluştu';

  @override
  String get revealInFinder => 'Finder\'da Göster';

  @override
  String get revealInFolder => 'Klasörde Göster';

  @override
  String get revealOpenFolder => 'Klasörü Aç';

  @override
  String get transferResend => 'Yeniden Gönder';

  @override
  String get transferRemove => 'Listeden Kaldır';

  @override
  String get transferCopyPath => 'Yolu Kopyala';

  @override
  String get transferPathCopied => 'Yol kopyalandı';

  @override
  String sendingTo(String name, String percent) {
    return '$name alıcısına gönderiliyor · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '$name gönderiyor · $percent';
  }

  @override
  String get receiveFiles => 'Diğer cihazlardan dosya al';

  @override
  String get saveTo => 'Kaydetme yeri';

  @override
  String get saveToChange => 'Değiştir…';

  @override
  String get saveToDefault => 'İndirilenler (varsayılan)';

  @override
  String get saveToUseDefault => 'İndirilenler\'i kullan';

  @override
  String get receiveNotify => 'Dosya gelince bildir';

  @override
  String receiveFootnote(String device) {
    return 'Yalnızca eşleştirilmiş cihazlar $device üzerine dosya gönderebilir. Dosya aktarılırken $device kendiliğinden uyku moduna geçmez.';
  }

  @override
  String get saveDirNotFound => 'Bu klasör mevcut değil.';

  @override
  String get saveDirNotWritable => 'PasteFerry bu klasöre dosya kaydedemiyor.';

  @override
  String get saveDirPermission =>
      'PasteFerry\'nin bu klasörü kullanma izni yok. Sistem Ayarları → Gizlilik ve Güvenlik → Dosyalar ve Klasörler bölümünden izin verin.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count dosya adında Windows\'un izin vermediği karakterler vardı; bunlar benzer tam genişlikli karakterlerle değiştirildi',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Aynı ağ';

  @override
  String get sendRingOther => 'Diğer ağlar';

  @override
  String sendOfflineList(String names) {
    return 'Çevrimdışı: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Aktarım listesi';

  @override
  String get sendLayoutSide => 'Radarın yanında';

  @override
  String get sendLayoutBelow => 'Radarın altında';

  @override
  String get general => 'Genel';

  @override
  String get launchAtLogin => 'Oturum açılışında başlat';

  @override
  String get launchAtLoginDesc =>
      'Oturum açtığınızda arka planda başlar. Bunu değiştirmek mevcut oturumu durdurmaz.';

  @override
  String get realtimeSync => 'Gerçek zamanlı pano eşzamanlaması';

  @override
  String get realtimeSyncDesc =>
      'Yeni kopyaladıklarınızı eşleştirilmiş cihazlarla otomatik olarak paylaşır. Kapalıyken yerel geçmiş ve Dosya Gönder kullanılmaya devam eder.';

  @override
  String get syncBacklog => 'Yeniden bağlanınca eksikleri tamamla';

  @override
  String get syncBacklogDesc =>
      'Varsayılan olarak kapalı: kaçırılan kopyalar atlanır. Açıldığında son 24 saatteki en fazla 20 kopya, panoyu değiştirmeden geçmişe eklenir.';

  @override
  String get peerRealtimeSync => 'Bu bilgisayarla eşzamanla';

  @override
  String get syncPaused => 'Pano eşzamanlaması duraklatıldı';

  @override
  String get quitApp => 'PasteFerry\'den Çık';

  @override
  String get quitAppDesc =>
      'Tüm PasteFerry işlemlerini durdurur. Oturum açılışında başlatma tercihiniz korunur.';

  @override
  String get quitTransfersWarning =>
      'Hâlâ aktarılan dosyalar var. Çıkılıp bu aktarımlar kesilsin mi?';

  @override
  String get backgroundRunningTitle => 'PasteFerry çalışmaya devam edecek';

  @override
  String get backgroundRunningBody =>
      'Pencereyi kapatmak eşzamanlamayı ve hızlı yapıştırı durdurmaz. Her şeyi durdurmak için Ayarlar\'da veya uygulama menüsünde PasteFerry\'den Çık\'ı seçin.';

  @override
  String get displayAs => 'Görünen ad';

  @override
  String get editName => 'Adı Değiştir';

  @override
  String get nameHint => 'Kişilerinizin gördüğü ad';

  @override
  String get nameDefaultHint => 'Hesap adınızı kullanmak için boş bırakın.';

  @override
  String get avatarTitle => 'Profil Resmi';

  @override
  String get avatarChoose => 'Görsel Seç…';

  @override
  String get avatarPaste => 'Görseli Yapıştır';

  @override
  String get avatarReset => 'Varsayılan Resmi Kullan';

  @override
  String get avatarZoom => 'Yakınlaştır';

  @override
  String get avatarDragHint => 'Resmi taşımak için sürükleyin.';

  @override
  String get avatarNoImage => 'Panoda görsel yok.';

  @override
  String get avatarBad => 'Bu görsel kullanılamıyor. PNG, JPEG veya GIF seçin.';

  @override
  String get done => 'Bitti';

  @override
  String get friendsTitle => 'Kişiler';

  @override
  String get addFriend => 'Kişi Ekle';

  @override
  String get friendsEmpty => 'Henüz kişi yok';

  @override
  String get friendsEmptyBody =>
      'Eşleştirme yapmadan birbirinize dosya göndermek için PasteFerry kullanan birini ekleyin. Kişiler yalnızca dosya gönderebilir; panonuzu asla göremez.';

  @override
  String get friendSendAction => 'Gönder…';

  @override
  String get friendHistory => 'Aktarımlar';

  @override
  String friendHistoryTitle(String name) {
    return '$name ile aktarımlar';
  }

  @override
  String get friendHistoryEmpty => 'Henüz aktarım yok.';

  @override
  String get friendAutoAccept => 'Dosyaları Otomatik Kabul Et';

  @override
  String get friendRemove => 'Kişiyi Kaldır';

  @override
  String friendRemoveTitle(String name) {
    return '$name kişilerden kaldırılsın mı?';
  }

  @override
  String get friendRemoveBody =>
      'Birbirinizin kişi listesinden kaldırılacaksınız ve artık birbirinize dosya gönderemeyeceksiniz. Geçmiş aktarımlar bu bilgisayarda kalır.';

  @override
  String friendLastActivity(String time) {
    return 'Son aktarım: $time';
  }

  @override
  String get friendNoActivity => 'Henüz aktarım yok';

  @override
  String get friendCodeShare =>
      'Bu kodu kişinize gönderin. Kodu PasteFerry\'ye girdiğinde birbirinizin kişi listesine eklenirsiniz.';

  @override
  String friendCodeExpires(String time) {
    return '$time sonra geçersiz olur';
  }

  @override
  String get friendCodeOr => 'veya';

  @override
  String get friendCodeEnter => 'Karşı tarafın kişi kodunu girin';

  @override
  String get friendCodeAdd => 'Ekle';

  @override
  String get friendCodeWaiting => 'Kodu girmesi bekleniyor…';

  @override
  String friendConfirmBody(String name) {
    return '$name kişilerinize eklensin mi?';
  }

  @override
  String get friendSafetyCode => 'Güvenlik kodunu kontrol et (isteğe bağlı)';

  @override
  String get friendSafetyHint =>
      'Yan yanayken bu iki satırı karşılaştırın. İki bilgisayarda da aynıysa kimse araya girmemiştir.';

  @override
  String get friendWaitingPeer => 'Sizi eklemesi bekleniyor…';

  @override
  String friendAdded(String name) {
    return '$name kişilerinize eklendi';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name iptal etti';
  }

  @override
  String get friendErrFriendCode =>
      'Bu bir kişi kodu. Dosya Gönder sayfasındaki Kişi Ekle bölümüne girin.';

  @override
  String get friendErrDeviceCode =>
      'Bu bir eşleştirme kodu. Cihazlar → Cihaz ekle bölümüne girin.';

  @override
  String get friendErrOutdated =>
      'Karşı tarafın PasteFerry 2.6.0 veya sonraki bir sürüme ihtiyacı var.';

  @override
  String get friendErrAlreadyPaired =>
      'O bilgisayar zaten cihazlarınızdan biri.';

  @override
  String get friendErrNoChannel =>
      'Aynı ağda değilsiniz. Birbirinizi eklemek için iki bilgisayarda da Hizmet özelliğini açın.';

  @override
  String get openService => 'Hizmeti Aç…';

  @override
  String get noteLabel => 'Not (isteğe bağlı)';

  @override
  String get noteHintEmpty => 'Önce dosya seçin';

  @override
  String get noteHint => 'Örneğin: lütfen 3. sayfayı imzalayın';

  @override
  String noteLine(String note) {
    return 'Not: $note';
  }

  @override
  String get sendAction => 'Gönder';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count öğe · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Dosyaları veya görselleri buraya bırakın ya da yapıştırın ($key)';
  }

  @override
  String get sendDropMorePaste => 'Daha fazla bırakın veya yapıştırın';

  @override
  String get sendPasteNothing =>
      'Yapıştırılacak bir şey yok. Önce dosya veya görsel kopyalayın.';

  @override
  String get sendRemoveItem => 'Kaldır';

  @override
  String sendFriendSaved(String name) {
    return '$name her dosya grubunu gönderilmeden önce kabul eder.';
  }

  @override
  String transferAskingOut(String name) {
    return '$name kabul edene kadar bekleniyor…';
  }

  @override
  String get transferAskingIn => 'Kabul etmeniz bekleniyor';

  @override
  String reasonDeclined(String name) {
    return '$name reddetti';
  }

  @override
  String reasonTimeout(String name) {
    return '$name yanıt vermedi';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name dosya kabul etmiyor';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name şu anda dosyalarınızı kabul etmiyor';
  }

  @override
  String get reasonYouDeclined => 'Reddedildi';

  @override
  String get reasonYouIgnored => 'Yok sayıldı';

  @override
  String get sendAgain => 'Yeniden Gönder';

  @override
  String incomingTitle(String name) {
    return '$name size dosya göndermek istiyor';
  }

  @override
  String get incomingAlways => 'Bu kişiden gelen dosyaları her zaman kabul et';

  @override
  String get incomingDecline => 'Reddet';

  @override
  String get incomingAccept => 'Kabul et';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds sn içinde otomatik olarak reddedilecek';
  }

  @override
  String get incomingStranger => 'Yakında';

  @override
  String get friendsStrip => 'Kişiler';

  @override
  String get strangersStrip => 'Yakındaki, Herkes ayarı açık olanlar';

  @override
  String get strangerNearby => 'Yakında';

  @override
  String get friendNeedService => 'Hizmeti açın';

  @override
  String get friendCantReach => 'Bağlanılamıyor';

  @override
  String reachSelfNoService(String name) {
    return '$name ile aynı ağda değilsiniz. Dosya göndermek için Hizmet özelliğini açın; doğrudan bağlantı kurulamazsa dosyalar Hizmet aktarması üzerinden gider.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name, Hizmet özelliğini açmamış; bu yüzden yalnızca aynı ağdayken dosya gönderebilirsiniz. PasteFerry\'de Hizmet özelliğini açmasını isteyin.';
  }

  @override
  String get reachDifferentServer =>
      'Aynı sunucuyu kullanmıyorsunuz. Dosya göndermek için iki bilgisayarda da Hizmet özelliğini açın ya da aynı sunucuyu kullanın.';

  @override
  String get receiveFromLabel => 'Bana dosya gönderebilecekler:';

  @override
  String get receiveFromOff => 'Hiç Kimse';

  @override
  String get receiveFromFriends => 'Yalnızca Kişiler';

  @override
  String get receiveFromEveryone => 'Herkes';

  @override
  String everyoneLeft(String minutes) {
    return 'Herkes · $minutes dk kaldı';
  }

  @override
  String get receiveFromOffDesc =>
      'Size yalnızca kendi eşleştirilmiş bilgisayarlarınız dosya gönderebilir.';

  @override
  String get receiveFromFriendsDesc =>
      'Kişileriniz size dosya gönderebilir. Her dosya grubunu siz kabul edersiniz.';

  @override
  String get receiveFromEveryoneDesc =>
      'Aynı ağdaki herkes 10 dakika boyunca size dosya gönderebilir. Her dosya grubunu siz kabul edersiniz.';

  @override
  String get everyoneEnded =>
      'Herkes ayarı sona erdi; Yalnızca Kişiler ayarına dönüldü.';

  @override
  String get friendsCountTooltip => 'Kişiler';

  @override
  String get waitingAccept => 'Bekleniyor…';

  @override
  String get settingsConnection => 'Bağlantı';

  @override
  String get settingsGeneralSummary =>
      'Oturum açılışında başlatma, cihaz adı, dil';

  @override
  String get settingsConnectionSummary => 'Hizmet, kendi sunucunuz, yerel ağ';

  @override
  String get settingsSyncSummary =>
      'Gerçek zamanlı eşzamanlama, boyut sınırı, neler eşzamanlanır';

  @override
  String get settingsQuickPasteSummary =>
      'Kısayol ve seçimden sonra ne olacağı';

  @override
  String get settingsSendSummary => 'Dosya alma, kaydetme yeri';

  @override
  String get settingsStorageSummary => 'Geçmiş saklama süresi, kullanılan alan';

  @override
  String get settingsAboutSummary => 'Sürüm, güncellemeler, geri bildirim';

  @override
  String get friendsSubtitle =>
      'Başkalarının bilgisayarlarına eşleştirme yapmadan dosya gönderin';

  @override
  String get friendsSearch => 'Kişilerde ara';

  @override
  String get friendsNoMatch => 'Eşleşen kişi yok';

  @override
  String get friendsPick =>
      'Aktarımlarınızı görmek veya dosya göndermek için bir kişi seçin';

  @override
  String friendDropHint(String name) {
    return 'Dosyaları $name kişisine göndermek için buraya bırakın';
  }

  @override
  String get webShareTitle => 'Telefonla web aktarımı';

  @override
  String get webShareFootnote =>
      'Bu bilgisayarla tarayıcıda metin, fotoğraf ve dosya alışverişi yapmak için telefonla bir QR kodu tarayın; uygulama gerekmez. Telefon ve bilgisayar aynı ağda olmalıdır.';

  @override
  String get webShareSwitch => 'Telefonların tarayıcıdan bağlanmasına izin ver';

  @override
  String webShareOn(int count) {
    return 'Açık, $count telefon';
  }

  @override
  String get webShareOff => 'Kapalı';

  @override
  String get webShareShowQr => 'QR kodunu göster';

  @override
  String get webShareDialogTitle => 'Telefonunuzla tarayın';

  @override
  String get webShareDialogBody =>
      'Telefonun kamerası veya tarayıcısıyla tarayıp tarayıcıda açın. Her QR kodu bir telefonu kaydeder ve kullanıldıktan sonra yenisiyle değiştirilir.';

  @override
  String get webShareAddress => 'Adres';

  @override
  String get webShareSecurity =>
      'İçerik sayfada şifrelenir, bu yüzden ağdaki başkaları onu okuyamaz. Ancak sayfanın kendisi http\'dir ve bilerek müdahale eden birini durduramaz. Halka açık Wi-Fi\'da değil, evde veya güvenilir bir ofis ağında kullanın.';

  @override
  String get webSharePhones => 'Kayıtlı telefonlar';

  @override
  String get webShareNoPhones => 'Henüz telefon yok';

  @override
  String webShareLastUsed(String time) {
    return 'Son kullanım: $time';
  }

  @override
  String get webShareRemove => 'Kaldır';

  @override
  String webShareRemoved(String name) {
    return '“$name” kaldırıldı';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name” kaydedildi';
  }

  @override
  String webShareNotListening(String error) {
    return 'Dinleme başlatılamadı: $error';
  }

  @override
  String get webSharePortFallback =>
      'Her zamanki bağlantı noktası kullanımda olduğundan geçici bir bağlantı noktası kullanılıyor. Kayıtlı adresler, telefonlar yeniden tarayana kadar açılmaz.';

  @override
  String get webShareNoAddress =>
      'Yerel ağ adresi yok. Önce Wi-Fi\'a veya kablolu bir ağa bağlanın.';

  @override
  String get webShareCantOpen =>
      'Sayfa telefonda açılmıyorsa ikisinin de aynı ağda olduğundan emin olun (misafir ağlar genellikle çalışmaz). Windows\'ta PasteFerry\'ye güvenlik duvarından geçiş izni de verilmelidir.';

  @override
  String get mTabRecords => 'Geçmiş';

  @override
  String get mTabSend => 'Gönder';

  @override
  String get mThisPhone => 'Bu telefon';

  @override
  String get mThisPhoneInText => 'bu telefon';

  @override
  String mThisPhoneName(String name) {
    return 'Bu telefon: $name';
  }

  @override
  String get mSendTitle => 'Bilgisayarınıza gönderin';

  @override
  String get mSendHint => 'Metin yazın veya yapıştırın';

  @override
  String get mPaste => 'Yapıştır';

  @override
  String get mPhotosFiles => 'Fotoğraflar veya dosyalar';

  @override
  String mSendConfirmTitle(Object n) {
    return '$n dosya gönderilsin mi?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dosya bilgisayarınıza gönderildi',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Panoda metin yok';

  @override
  String get mSendAction => 'Gönder';

  @override
  String mSendTo(String names) {
    return 'Alıcılar: $names';
  }

  @override
  String get mNoOnlineDevices => 'Yakında çevrimiçi cihaz yok';

  @override
  String get mNoPairedDevices => 'Önce bir bilgisayarla eşleştirin';

  @override
  String get mSent => 'Gönderildi';

  @override
  String get mSendFootnote =>
      'Metin ve dosyalar bilgisayardaki geçmişe eklenir ve bilgisayarın ayarına göre panosuna kopyalanır. Telefonda kopyaladıklarınız kendiliğinden gönderilmez.';

  @override
  String get mSentRecords => 'Gönderilenler';

  @override
  String get mSentRetention => 'Gönderilenleri saklama süresi';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Gönderilenler, bu telefonun son $d günde gönderdiklerini gösterir';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d gün';
  }

  @override
  String get mViewAll => 'Tümünü gör';

  @override
  String get mClearCache => 'Temizle';

  @override
  String get mCheckUpdate => 'Güncellemeleri denetle';

  @override
  String get mUpdateFailed => 'Güncellemeler denetlenemedi';

  @override
  String get mUpToDate => 'En son sürümü kullanıyorsunuz';

  @override
  String mNewVersion(Object v) {
    return '$v sürümü kullanılabilir';
  }

  @override
  String get mDownloadInstall => 'Yeni sürümü indir';

  @override
  String mSendFailed(String detail) {
    return 'Gönderilemedi: $detail';
  }

  @override
  String get mCopy => 'Kopyala';

  @override
  String get mCopied => 'Bu telefonun panosuna kopyalandı';

  @override
  String get mShare => 'Paylaş';

  @override
  String get mSaved =>
      'Fotoğraflar\'a veya Download/PasteFerry klasörüne kaydedildi';

  @override
  String mActionFailed(String detail) {
    return 'İşlem başarısız: $detail';
  }

  @override
  String get mDownloading => 'İndiriliyor…';

  @override
  String get mNotDownloaded => 'Henüz indirilmedi';

  @override
  String get mDownloadHint =>
      'Kopyala, Kaydet veya Paylaş\'a dokunduğunuzda önce indirilir.';

  @override
  String get mFullTextLoading => 'Yükleniyor…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Toplam $total karakterin ilk $shown karakteri gösteriliyor. Kopyala ile tamamı alınır.';
  }

  @override
  String get mNotOnLanTitle => 'Wi-Fi\'a bağlı değil';

  @override
  String get mNotOnLanBody =>
      'PasteFerry şimdilik yalnızca yerel ağda eşzamanlar. Bilgisayarınızla aynı Wi-Fi ağına katılın.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry başlatılamadı: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Bilgisayarınızda PasteFerry → Cihazlar → Cihaz ekle\'yi açın, ardından gösterilen kodu buraya girin. Aynı Wi-Fi ağındaysanız her ikisinde de “Yakındakileri ara” penceresini açabilirsiniz.';

  @override
  String get mSectionSync => 'Eşzamanlama';

  @override
  String get mSectionBackground => 'Arka plan';

  @override
  String get mAutoApplyDesc =>
      'Bilgisayarınızda kopyalanan metin doğrudan bu telefonun panosuna gider. Görseller ve dosyalar, Kopyala\'ya dokunana kadar bekler.';

  @override
  String get mKeepAlive => 'Arka planda bağlı kal';

  @override
  String get mKeepAliveDesc =>
      'PasteFerry açık değilken de metin alır. Sürekli bir bildirim gösterir.';

  @override
  String get mNotifications => 'Bildirimler';

  @override
  String get mNotificationsDesc =>
      'Sürekli bildirim için gerekir. PasteFerry bu izin olmadan da çalışır.';

  @override
  String get mBattery => 'Arka planda çalış';

  @override
  String get mBatteryDesc =>
      'Ekran kilitliyken sistemin PasteFerry\'yi durdurmaması için pil optimizasyonunu kapatın. Bazı telefonlarda PasteFerry\'nin Ayarlar\'daki otomatik başlatma veya arka plan listesine de eklenmesi gerekir.';

  @override
  String get mAllowed => 'İzin verildi';

  @override
  String get mAllow => 'İzin ver';

  @override
  String mVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get mDeleteConfirm => 'Bu kayıt silinsin mi?';

  @override
  String get mDelete => 'Sil';

  @override
  String get webShareFirewallPreparing =>
      'Windows Güvenlik Duvarı denetleniyor. Windows yönetici onayı isterse telefonunuzun bağlanabilmesi için Evet\'i seçin.';

  @override
  String get webShareFirewallReady =>
      'Windows Güvenlik Duvarı kuralları hazır. Telefonunuzu aynı ağa bağlayın ve QR kodunu tarayın. Hâlâ bağlanamıyorsa güvenlik duvarını aşağıdan yeniden denetleyin.';

  @override
  String get webShareFirewallFailed =>
      'Güvenlik duvarı ayarı tamamlanmadı. Telefonunuz sayfayı açamayabilir. Yeniden deneyin ve Windows yönetici isteğini onaylayın.';

  @override
  String get webShareFirewallAllow =>
      'Denetle ve telefon bağlantılarına izin ver';

  @override
  String get mCopyMediaFailed =>
      'Bu görsel veya dosya kopyalanamadı. Önce kaydetmeyi deneyin.';

  @override
  String get mShareMediaFailed =>
      'Bu görsel veya dosya için paylaşım açılamadı. Önce kaydetmeyi deneyin.';

  @override
  String get mSaveMediaFailed =>
      'Bu görsel veya dosya kaydedilemedi. Depolama erişimini ve boş alanı kontrol edip yeniden deneyin.';

  @override
  String get noticeFilesUnreadable =>
      'Az önce kopyaladığınız dosyalar okunamadı, bu yüzden hiçbir şey eşzamanlanmadı';

  @override
  String get mAddMore => 'Daha fazla ekle';

  @override
  String get mChoosePhotos => 'Fotoğraf Seç…';

  @override
  String get mMultiSelectHint =>
      'Aynı anda birden çok fotoğraf seçin. Dosyalar\'da daha fazlasını seçmek için bir öğeye dokunup basılı tutun.';

  @override
  String get webSendFiles => 'Dosya gönder';

  @override
  String get webFilesQueued =>
      'Web aktarımlarına eklendi. İndirmek için telefonunuzda Dosya Gönder\'i açın.';

  @override
  String get webFilesLimit =>
      'Web indirmeleri dosya başına en fazla 200 MB ve grup başına 64 dosya destekler.';

  @override
  String get appearance => 'Görünüm';

  @override
  String get settingsAppearanceSummary => 'Tema, açık ve koyu';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeDefault => 'Varsayılan';

  @override
  String get themePixel => 'Piksel';

  @override
  String get themeMode => 'Açık ve koyu';

  @override
  String get themeModeSystem => 'Sisteme uy';

  @override
  String get themeModeLight => 'Açık';

  @override
  String get themeModeDark => 'Koyu';

  @override
  String get themeCustom => 'Özel';

  @override
  String get themeDelete => 'Temayı sil';

  @override
  String themeDeleteConfirm(String name) {
    return '“$name” teması silinsin mi?';
  }

  @override
  String get themeLowContrast => 'Bu temadaki bazı metinler zor okunabilir';

  @override
  String get themeFootnote =>
      'Temalar, Hızlı yapıştır dahil yalnızca bu cihaza uygulanır. Diğer cihazlarla eşzamanlanmaz.';

  @override
  String get themeBuiltinGroup => 'Yerleşik';

  @override
  String get themeCustomGroup => 'Özel';

  @override
  String get themeUse => 'Kullan';

  @override
  String get themeDuplicate => 'Çoğalt';

  @override
  String themeCopyName(String name) {
    return '$name kopyası';
  }

  @override
  String get themeExport => 'Dışa aktar…';

  @override
  String get themeImport => 'Tema içe aktar…';

  @override
  String themeImported(String name) {
    return '“$name” içe aktarıldı';
  }

  @override
  String themeImportedWarn(String name, int count) {
    return '“$name” içe aktarıldı. $count metin rengi zor okunabilir.';
  }

  @override
  String get themeExported => 'Tema dışa aktarıldı';

  @override
  String get themeCustomEmpty =>
      'Henüz özel tema yok. Yerleşik bir temayı çoğaltın, bir tema içe aktarın ya da bir yapay zekâdan tema yapmasını isteyin.';

  @override
  String get themeAskAi => 'Yapay zekâdan tema iste';

  @override
  String get themeAskAiBody =>
      'Bu MCP sunucusunu Claude veya Cursor gibi bir yapay zekâ uygulamasına ekleyin, ardından bir tema isteyin; örneğin “Bana siberpunk bir tema yap”. Yapay zekâ tema biçimini okur, renkleri seçer, kontrastı denetler ve temayı uygular.';

  @override
  String get themeAskAiCopy => 'Yapılandırmayı kopyala';

  @override
  String get themeAskAiCopied => 'Yapılandırma kopyalandı';

  @override
  String get themeScanlines => 'Tarama çizgileri';

  @override
  String get themeScanlinesDesc =>
      'Pencerenin üzerine soluk CRT tarama çizgileri ekler. Yalnızca piksel temalarda.';

  @override
  String get themeBackground => 'Arka plan görseli';

  @override
  String get themeBackgroundDesc =>
      'Kenar çubuğunun ve sayfaların arkasında pencereyi doldurur. Üstteki örtü metni okunur tutar.';

  @override
  String get themeBackgroundChoose => 'Görsel Seç…';

  @override
  String get themeBackgroundChange => 'Değiştir…';

  @override
  String get themeBackgroundRemove => 'Kaldır';

  @override
  String get themeBlur => 'Bulanıklık';

  @override
  String get themeBlurNone => 'Yok';

  @override
  String get themeBlurLight => 'Hafif';

  @override
  String get themeBlurStrong => 'Güçlü';

  @override
  String get themeScrim => 'Örtü';

  @override
  String get themeScrimDesc =>
      'Metnin okunur kalması için görselin üzerine konan bir renk. Görselin gerektirdiğinden asla daha açık olmaz.';

  @override
  String get themeScrimAuto => 'Otomatik';

  @override
  String get themeScrimMore => 'Daha yoğun';

  @override
  String get themeScrimMost => 'En yoğun';

  @override
  String get themePanels => 'Paneller';

  @override
  String get themePanelsDesc =>
      'Görselin kenar çubuğu ve listelerden ne kadar göründüğü.';

  @override
  String get themePanelsClear => 'Saydam';

  @override
  String get themePanelsMedium => 'Orta';

  @override
  String get themePanelsSolid => 'Opak';

  @override
  String get themeAccentFromImage => 'Görselin renklerini kullan';

  @override
  String get themeAccentFromImageDesc => 'Vurgu rengini görselden alır.';

  @override
  String get themeBackgroundPicker => 'Hızlı yapıştırda da göster';

  @override
  String get themeScenery => 'Manzarayı göster';

  @override
  String get themeSceneryDesc =>
      'Sayfaların üstündeki ve kenar çubuğunun altındaki resimler.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Yerleşik temalar değiştirilemez; bu yüzden “$name” adlı bir kopya oluşturulup uygulandı';
  }

  @override
  String get themeBackgroundFootnote =>
      'Arka plan geçerli temaya aittir. Yerleşik temalar değiştirilemez: ilk değişiklik bir kopya oluşturur. Görseller bu cihazda kalır; JPEG, PNG ve GIF desteklenir.';

  @override
  String get themeSceneGroup => 'Manzara';

  @override
  String get themeSceneHeader => 'Sayfa başlığı';

  @override
  String get themeSceneHeaderDesc =>
      'Sayfa başlıklarının arkasında geniş bir resim; alt kısmı sayfaya doğru solar. Piksel tema burada piksel bir manzara çizer.';

  @override
  String get themeSceneSidebar => 'Kenar çubuğu altı';

  @override
  String get themeSceneSidebarDesc =>
      'Kenar çubuğunun altında küçük bir resim. Piksel tema burada küçük bir kamp çizer.';

  @override
  String get themeSceneReset => 'Sıfırla';

  @override
  String get themeSceneFootnote =>
      'Her tema burada kendi resimlerinizi gösterebilir. Bir örtü sayfa başlığını okunur tutar. Pencereyi bir arka plan görseli doldururken manzara gizlenir.';

  @override
  String get starTitle => 'PasteFerry\'yi nasıl buldunuz?';

  @override
  String get starBody =>
      'Beğendiyseniz GitHub\'da vereceğiniz bir yıldız bizim için çok değerli olur.';

  @override
  String get starAction => 'GitHub\'da yıldız ver';

  @override
  String get starLater => 'Daha sonra';

  @override
  String get starDismiss => 'Bir daha gösterme';
}
