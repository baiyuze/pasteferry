// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navDevices => 'Perangkat';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get navFavorites => 'Favorit';

  @override
  String get linkConnecting => 'Menghubungkan…';

  @override
  String get linkServiceNotRunning => 'Layanan tidak berjalan';

  @override
  String get linkLanMode => 'Mencari perangkat di jaringan ini';

  @override
  String get linkServerUnreachable =>
      'Server tidak terjangkau; sinkron di jaringan ini';

  @override
  String get linkNothingOn =>
      'Penemuan jaringan lokal nonaktif dan server belum diatur';

  @override
  String get linkLanBlocked => 'macOS memblokir jaringan lokal';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perangkat online',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Terhubung ke server';

  @override
  String linkConnectionLost(String detail) {
    return 'Koneksi terputus: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Layanan terputus';

  @override
  String get linkServiceDisabled => 'Sinkronisasi latar belakang nonaktif';

  @override
  String get errServiceNotConnected =>
      'Tidak terhubung ke layanan latar belakang';

  @override
  String get errUnimplemented => 'Fitur ini belum tersedia';

  @override
  String get errUnavailable => 'Tidak dapat menjangkau layanan latar belakang';

  @override
  String errServiceStart(String detail) {
    return 'Tidak dapat memulai layanan latar belakang: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Tidak dapat memulai ulang layanan latar belakang: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Tidak dapat mengatur PasteFerry agar dibuka saat login: $detail';
  }

  @override
  String get thisMacTitle => 'Mac Ini';

  @override
  String get thisPcTitle => 'Komputer Ini';

  @override
  String get thisMacInText => 'Mac ini';

  @override
  String get thisPcInText => 'komputer ini';

  @override
  String get bothMacs => 'kedua Mac';

  @override
  String get bothDevices => 'kedua perangkat';

  @override
  String get thisDeviceShort => 'Perangkat ini';

  @override
  String fromDevice(String name) {
    return 'Dari $name';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get close => 'Tutup';

  @override
  String get save => 'Simpan';

  @override
  String get retry => 'Coba lagi';

  @override
  String get continueAction => 'Lanjutkan';

  @override
  String get justNow => 'Baru saja';

  @override
  String secondsAgo(int n) {
    return '$n dtk lalu';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n menit lalu',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jam lalu',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hari lalu',
      one: 'Kemarin',
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
      other: '$n jam',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hari',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Salin di perangkat mana pun dan hasilnya muncul di sini';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
    );
    return '$_temp0, disimpan selama $ttl';
  }

  @override
  String get filterAll => 'Semua';

  @override
  String get filterText => 'Teks';

  @override
  String get filterImage => 'Gambar';

  @override
  String get filterFile => 'File';

  @override
  String get filterLink => 'Tautan';

  @override
  String get historyClearTooltip => 'Hapus riwayat';

  @override
  String get historyEmptyTitle => 'Belum ada apa pun';

  @override
  String get historyEmptyFilteredTitle => 'Tidak ada item jenis ini';

  @override
  String get historyEmptyBody =>
      'Salin teks, gambar, atau file di perangkat mana pun yang sudah dipasangkan, dan hasilnya muncul di sini.';

  @override
  String get clearConfirmTitle => 'Hapus seluruh riwayat?';

  @override
  String clearConfirmBody(String device) {
    return 'Semua yang disinkronkan dari perangkat Anda, beserta file cache, akan dihapus dari $device. File aslinya tidak terpengaruh.';
  }

  @override
  String get clear => 'Hapus';

  @override
  String get historyCleared => 'Riwayat dihapus';

  @override
  String get permDeniedTitle => 'PasteFerry tidak dapat membaca papan klip';

  @override
  String get permAskTitle => 'Izinkan PasteFerry membaca papan klip';

  @override
  String get permDeniedBody =>
      'Yang Anda salin di Mac ini tidak akan disinkronkan. Di Pengaturan Sistem, atur PasteFerry Daemon ke Izinkan.';

  @override
  String get permAskBody =>
      'Jika tidak, macOS akan selalu bertanya. Di Pengaturan Sistem, atur PasteFerry Daemon ke Izinkan.';

  @override
  String get openSystemSettings => 'Buka Pengaturan Sistem';

  @override
  String get fetch => 'Terima';

  @override
  String get fetchStarted => 'Menerima… Lihat progresnya di Riwayat';

  @override
  String get transferFailed => 'Transfer gagal';

  @override
  String get expired => 'Kedaluwarsa';

  @override
  String get putOnClipboard => 'Salin ke papan klip';

  @override
  String get putOnClipboardDone => 'Ada di papan klip';

  @override
  String get deleteRecord => 'Hapus item ini';

  @override
  String get deleted => 'Dihapus';

  @override
  String get emptyRecord => '(kosong)';

  @override
  String get imageRecord => 'Gambar';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others lainnya',
    );
    return '$name dan $_temp0';
  }

  @override
  String get searchHint => 'Cari teks dan nama file';

  @override
  String get searchClear => 'Hapus pencarian';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hasil',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Tidak ada hasil untuk “$query”';
  }

  @override
  String get searchEmptyBody =>
      'Pencarian mencakup teks yang disalin dan nama file yang disalin.';

  @override
  String get favoriteAction => 'Tambahkan ke favorit';

  @override
  String get unfavoriteAction => 'Hapus dari favorit';

  @override
  String get favoritedToast => 'Ditambahkan ke Favorit';

  @override
  String get unfavoritedToast => 'Dikembalikan ke Riwayat';

  @override
  String get undo => 'Urungkan';

  @override
  String get favoriteSaving => 'Menyimpan…';

  @override
  String favoritedAt(String date) {
    return 'Disimpan $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
    );
    return '$_temp0 · tidak pernah dibersihkan · maks. $size';
  }

  @override
  String get favoritesEmptyTitle => 'Belum ada favorit';

  @override
  String get favoritesEmptyBody =>
      'Beri bintang pada item di Riwayat untuk menyimpan salinannya di sini. Favorit tidak pernah dibersihkan otomatis.';

  @override
  String get favoritesSearchHint => 'Cari favorit';

  @override
  String favoriteLargeTitle(String size) {
    return 'Simpan salinan sebesar $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Favorit menyimpan salinannya sendiri, jadi mengubah atau menghapus file asli tidak memengaruhinya. Ini memakai $size di $device.';
  }

  @override
  String get saveCopy => 'Simpan salinan';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count favorit Anda tetap disimpan.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favorit';

  @override
  String get favoritesUsageDesc =>
      'Favorit tidak pernah dibersihkan, apa pun pengaturan di atas';

  @override
  String upToSize(String size) {
    return 'Maks. $size';
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
    return '… total $count karakter';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lainnya',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Pilih untuk mengunduhnya terlebih dahulu';

  @override
  String detailTotalSize(String size) {
    return 'Total $size';
  }

  @override
  String get quickPaste => 'Tempel cepat';

  @override
  String get quickPasteWindow => 'Jendela tempel cepat';

  @override
  String get quickPasteWindowDesc =>
      'Tekan pintasan di aplikasi apa pun untuk membuka riwayat; pilih item dan item itu ditempelkan';

  @override
  String get quickPasteShortcut => 'Pintasan';

  @override
  String get quickPasteRecord => 'Klik untuk mengubah';

  @override
  String get quickPasteRecording => 'Tekan pintasan baru…';

  @override
  String get quickPasteUseDefault => 'Gunakan default';

  @override
  String get quickPasteNeedsModifier =>
      'Sertakan ⌃, ⌥, ⇧ atau ⌘, atau gunakan tombol fungsi';

  @override
  String get quickPasteNeedsModifierPc =>
      'Sertakan Ctrl, Alt, Shift atau tombol Windows, atau gunakan tombol fungsi';

  @override
  String get quickPasteAfterPick => 'Setelah memilih item';

  @override
  String get quickPastePasteIt => 'Tempelkan';

  @override
  String get quickPasteCopyIt => 'Salin saja';

  @override
  String get quickPasteIndexKey => 'Pilih salah satu dari 9 teratas';

  @override
  String get quickPasteIndexKeyDesc =>
      'Di jendela tempel cepat, tahan tombol ini lalu tekan 1–9';

  @override
  String get quickPasteAccessibility => 'Aksesibilitas';

  @override
  String get quickPasteAccessibilityDesc =>
      'Diperlukan untuk menempelkan secara otomatis. Tanpanya, item disalin dan Anda menekan ⌘V.';

  @override
  String get quickPasteAllowed => 'Diizinkan';

  @override
  String get quickPasteAllow => 'Izinkan…';

  @override
  String get quickPasteNotRunning => 'Jendela tempel cepat tidak berjalan';

  @override
  String quickPasteInUse(String key) {
    return '$key dipakai aplikasi lain. Pilih pintasan lain.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Tidak dapat mengatur $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Atur di pengaturan pintasan sistem';

  @override
  String get quickPasteWaylandDesc =>
      'Di Wayland, tambahkan pintasan di pengaturan keyboard desktop Anda. Item yang dipilih akan disalin; tekan Ctrl+V untuk menempel.';

  @override
  String get quickPasteAddShortcut => 'Tambah pintasan sistem';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Ditambahkan. Tekan $key untuk mencobanya.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Tambahkan pintasan khusus di pengaturan keyboard desktop Anda yang menjalankan: $command';
  }

  @override
  String get pickerSearch => 'Cari';

  @override
  String get pickerPaste => 'Tempel';

  @override
  String get pickerPlainText => 'Teks biasa';

  @override
  String get pickerCopyOnly => 'Salin saja';

  @override
  String get pickerUnfavoriteHint => 'Hapus (kembali ke Riwayat)';

  @override
  String pickerPasteManually(String key) {
    return 'Item yang dipilih akan disalin — tekan $key untuk menempel';
  }

  @override
  String get pickerGrantHint => 'Izinkan Aksesibilitas untuk menempel langsung';

  @override
  String pickerElevated(String key) {
    return 'Jendela ini berjalan sebagai administrator — tekan $key untuk menempel setelah memilih';
  }

  @override
  String get pickerDownloading => 'Mengunduh — ditempel setelah selesai';

  @override
  String get imagePreviewTitle => 'Pratinjau gambar';

  @override
  String get closePreview => 'Tutup pratinjau';

  @override
  String get previousImage => 'Gambar sebelumnya';

  @override
  String get nextImage => 'Gambar berikutnya';

  @override
  String get previewHint =>
      'Gulir atau cubit untuk memperbesar, seret untuk menggeser';

  @override
  String get fitWindow => 'Sesuaikan dengan jendela';

  @override
  String get previewDeleted => 'Gambar ini telah dihapus dari riwayat';

  @override
  String get previewExpired =>
      'Gambar ini sudah kedaluwarsa dan tidak dapat dipratinjau';

  @override
  String get previewDownloading => 'Mengunduh gambar…';

  @override
  String get previewDownloadFailed => 'Unduhan gagal. Coba lagi.';

  @override
  String get previewNotDownloaded => 'Gambar ini belum ada di komputer ini';

  @override
  String get downloadAndPreview => 'Unduh dan pratinjau';

  @override
  String get previewUnavailable =>
      'Gambar ini tidak dapat dipratinjau saat ini';

  @override
  String get imageSemantic => 'Gambar dari riwayat';

  @override
  String get previewUnreadable =>
      'Tidak dapat membaca gambar. File mungkin sudah dibersihkan atau rusak.';

  @override
  String get devicesSubtitleEmpty =>
      'Setelah dipasangkan, perangkat Anda berbagi satu papan klip';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired dipasangkan, $online online';
  }

  @override
  String get addDevice => 'Tambah perangkat';

  @override
  String thisDeviceFootnote(String both) {
    return 'Saat memasangkan, $both menampilkan dua baris sidik jari keamanan yang sama, satu untuk tiap perangkat. Konfirmasi hanya jika semua karakternya cocok.';
  }

  @override
  String get noDevicesTitle => 'Belum ada perangkat yang dipasangkan';

  @override
  String get noDevicesBody =>
      'Buka PasteFerry di komputer Anda yang lain dan hubungkan keduanya dengan kode pemasangan 6 karakter. Di jaringan yang sama, Anda juga bisa membuka Cari di sekitar di keduanya lalu mengeklik perangkat yang lain.';

  @override
  String get pairedDevices => 'Perangkat yang dipasangkan';

  @override
  String get pairedFootnote =>
      'Langsung: data dikirim langsung antara kedua perangkat. Relai: jika jaringan menghalangi jalur langsung, data melewati server Anda dan tetap terenkripsi ujung ke ujung.';

  @override
  String get offline => 'Offline';

  @override
  String get direct => 'Langsung';

  @override
  String get relay => 'Relai';

  @override
  String get online => 'Online';

  @override
  String get moreActions => 'Lainnya';

  @override
  String get copyFingerprint => 'Salin sidik jari';

  @override
  String get unpairEllipsis => 'Lepas pasangan…';

  @override
  String get fingerprintCopied => 'Sidik jari disalin';

  @override
  String unpairTitle(String name) {
    return 'Lepas pasangan “$name”?';
  }

  @override
  String get unpairBody =>
      'Kedua perangkat akan berhenti sinkron. Untuk sinkron lagi, Anda perlu memasangkannya dan memeriksa sidik jari lagi.';

  @override
  String get unpair => 'Lepas pasangan';

  @override
  String get unpaired => 'Pasangan dilepas';

  @override
  String get enterAddressEllipsis => 'Masukkan alamatnya…';

  @override
  String setAddressTitle(String name) {
    return 'Alamat “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Gunakan ini jika kedua perangkat berada di subnet berbeda, atau keduanya berganti alamat. Masukkan alamat yang tampil di “$name” pada Tambah perangkat → Tampilkan kode.';
  }

  @override
  String get addressSaved => 'Mencarinya di alamat itu';

  @override
  String get lanBlockedTitle => 'macOS memblokir jaringan lokal';

  @override
  String lanBlockedBody(String device) {
    return 'Aktifkan PasteFerry Daemon di Pengaturan Sistem → Privasi & Keamanan → Jaringan Lokal. Sebelum itu, $device tidak dapat terhubung ke perangkat di jaringan ini.';
  }

  @override
  String get searchNearby => 'Cari di sekitar';

  @override
  String get nearbyTitle => 'Perangkat di sekitar';

  @override
  String get nearbySearching => 'Mencari perangkat di sekitar…';

  @override
  String get nearbyHint =>
      'Buka juga Cari di sekitar di komputer yang lain, dan komputer itu akan muncul di sini. Klik untuk memasangkan.';

  @override
  String nearbyVisible(String device) {
    return 'Selama jendela ini terbuka, perangkat di jaringan ini dapat melihat nama $device.';
  }

  @override
  String get nearbyPaired => 'Dipasangkan';

  @override
  String nearbyRequesting(String name) {
    return 'Menghubungi “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” tidak menjawab. Pastikan Cari di sekitar masih terbuka di perangkat itu.';
  }

  @override
  String get nearbyLanOffTitle => 'Penemuan jaringan lokal nonaktif';

  @override
  String get nearbyLanOffBody =>
      'Aktifkan “Cari perangkat di jaringan ini” di Pengaturan → Koneksi untuk melihat perangkat di sekitar, atau pasangkan dengan kode.';

  @override
  String get generateCode => 'Tampilkan kode';

  @override
  String get enterCode => 'Masukkan kode';

  @override
  String get codeFailedTitle => 'Tidak dapat membuat kode pemasangan';

  @override
  String get enterOnOther => 'Masukkan kode ini di perangkat Anda yang lain';

  @override
  String get codeCopied => 'Kode disalin';

  @override
  String get codeHint => 'Klik untuk menyalin. Berlaku selama 5 menit.';

  @override
  String afterEnterFootnote(String both) {
    return 'Setelah kode dimasukkan, $both menampilkan dua baris sidik jari keamanan yang sama. Konfirmasi hanya jika keduanya cocok.';
  }

  @override
  String get codeInvalid => 'Kode pemasangan terdiri dari 6 huruf atau angka';

  @override
  String get localAddress => 'Alamat';

  @override
  String get addressHint =>
      'Di subnet berbeda? Masukkan juga alamat ini di perangkat yang lain.';

  @override
  String get addressCopied => 'Alamat disalin';

  @override
  String get differentSubnet => 'Di subnet berbeda?';

  @override
  String get peerAddress => 'Alamat yang tampil di bawah kode';

  @override
  String get pairNotFound =>
      'Perangkat itu tidak ditemukan. Jika berada di subnet berbeda, masukkan alamat yang tampil di bawah kodenya.';

  @override
  String get pairNotFoundAddress =>
      'Tidak ada jawaban di alamat itu. Periksa alamatnya dan pastikan perangkat yang lain masih menampilkan kodenya. Firewall di perangkat itu juga mungkin memblokirnya.';

  @override
  String get codeWrong => 'Kode itu salah atau sudah kedaluwarsa';

  @override
  String get codeExpired =>
      'Kode ini sudah kedaluwarsa. Tampilkan kode baru di perangkat yang lain.';

  @override
  String get addressInvalid =>
      'Alamat itu tidak valid. Masukkan sesuatu seperti 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Aktifkan penemuan jaringan lokal atau atur server di Pengaturan → Koneksi terlebih dahulu.';

  @override
  String get enterCodeShown =>
      'Masukkan kode yang tampil di perangkat Anda yang lain';

  @override
  String get pairingDone => 'Dipasangkan';

  @override
  String get pairingRejected => 'Pemasangan ditolak';

  @override
  String get verifyTitle => 'Periksa sidik jari keamanan';

  @override
  String pairingWith(String name) {
    return 'Memasangkan dengan “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'Dua baris di $both harus sama persis. Jika satu karakter saja berbeda, mungkin ada yang mengganggu koneksi, jadi tolak.';
  }

  @override
  String get rejectMismatch => 'Tidak cocok, tolak';

  @override
  String get confirmMatch => 'Cocok, pasangkan';

  @override
  String get server => 'Server (opsional)';

  @override
  String get signalingUrl => 'Server pensinyalan';

  @override
  String get signalingUrlDesc => 'Kosongkan untuk sinkron lokal saja';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'Tingkatkan koneksi langsung';

  @override
  String get publicStunDesc => 'Server publik dapat melihat IP publik Anda';

  @override
  String get connectionStatus => 'Koneksi';

  @override
  String get disconnectedDesc => 'Periksa alamat dan ketersediaan server';

  @override
  String get connected => 'Terhubung';

  @override
  String get notConnected => 'Tidak terhubung';

  @override
  String get notSet => 'Belum diatur';

  @override
  String get serverCleared => 'Server dihapus. Hanya sinkron di jaringan ini.';

  @override
  String get localNetwork => 'Jaringan lokal';

  @override
  String get lanDiscovery => 'Cari perangkat di jaringan ini';

  @override
  String get lanDiscoveryDesc =>
      'Penemuan anonim; nama hanya terlihat saat Cari di sekitar';

  @override
  String get macLocalNetwork => 'Akses Jaringan Lokal';

  @override
  String get macLocalNetworkDesc =>
      'Izinkan PasteFerry Daemon di Pengaturan Sistem';

  @override
  String get allowLan => 'Windows Firewall';

  @override
  String get allowLanDesc =>
      'Izinkan koneksi yang diblokir; perlu persetujuan administrator';

  @override
  String get allow => 'Izinkan';

  @override
  String get allowLanDone =>
      'Diizinkan. Perangkat lain kini dapat menjangkau perangkat ini.';

  @override
  String get deviceName => 'Nama perangkat';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get sync => 'Sinkronisasi';

  @override
  String get autoSyncLimit => 'Batas sinkron otomatis';

  @override
  String get autoSyncLimitDesc =>
      'Terima item yang lebih besar secara manual dari Riwayat';

  @override
  String get autoApply => 'Taruh item yang diterima di papan klip';

  @override
  String get whatToSync => 'Yang disinkronkan';

  @override
  String get syncFiles => 'File dan folder';

  @override
  String get syncText => 'Teks biasa';

  @override
  String get syncRich => 'Teks berformat';

  @override
  String get syncImages => 'Gambar dan tangkapan layar';

  @override
  String get storage => 'Penyimpanan';

  @override
  String get storageFootnote =>
      'Riwayat dan file cache yang kedaluwarsa dihapus otomatis.';

  @override
  String get keepHistory => 'Simpan riwayat selama';

  @override
  String get keepCache => 'Simpan file cache selama';

  @override
  String get keepCacheDesc => 'Tidak lebih lama dari masa simpan riwayat';

  @override
  String get cacheUsage => 'Ukuran cache';

  @override
  String get backgroundSync => 'Sinkronisasi latar belakang';

  @override
  String get backgroundService => 'Layanan latar belakang';

  @override
  String get backgroundServiceDesc =>
      'Mulai saat login; tetap sinkron saat jendela ditutup';

  @override
  String get restart => 'Mulai ulang';

  @override
  String get restarted => 'Layanan latar belakang dimulai ulang';

  @override
  String get disableEllipsis => 'Nonaktifkan…';

  @override
  String get about => 'Tentang';

  @override
  String get aboutDesc => 'Sumber terbuka dengan lisensi AGPL-3.0';

  @override
  String get homepage => 'Situs web';

  @override
  String get feedback => 'Laporkan masalah';

  @override
  String get disableTitle => 'Nonaktifkan sinkronisasi latar belakang?';

  @override
  String disableBody(String device) {
    return 'PasteFerry di $device akan berhenti sinkron dan tidak dibuka saat login. Riwayat dan pasangan perangkat tetap disimpan.';
  }

  @override
  String get disable => 'Nonaktifkan';

  @override
  String get disabled => 'Sinkronisasi latar belakang nonaktif';

  @override
  String get urlMustBeWs => 'Alamat harus diawali dengan ws:// atau wss://';

  @override
  String get serverUpdated => 'Server diperbarui. Menghubungkan ulang…';

  @override
  String get deviceNameUpdated => 'Nama perangkat diperbarui';

  @override
  String get diagIntro =>
      'Laporan ini berisi versi aplikasi, sistem, pengaturan, perangkat, dan log terbaru Anda. Nama perangkat, alamat server, alamat IP publik, folder pengguna, dan nama file diganti, dan yang Anda salin tidak pernah ditulis ke log. Issue di GitHub bersifat publik, jadi baca dulu sebelum mengirimnya.';

  @override
  String get diagVerboseTitle => 'Log terperinci';

  @override
  String get diagVerboseDesc =>
      'Untuk masalah koneksi: aktifkan, ulangi masalahnya, lalu kembali ke sini untuk membuat laporan. Log ini nonaktif sendiri setelah 30 menit.';

  @override
  String get diagVerboseOn => 'Aktifkan selama 30 menit';

  @override
  String diagVerboseUntil(String time) {
    return 'Aktif hingga $time';
  }

  @override
  String get diagVerboseOff => 'Nonaktifkan';

  @override
  String get diagRefresh => 'Buat ulang';

  @override
  String get diagSave => 'Simpan sebagai file';

  @override
  String diagSaved(String name) {
    return 'Disimpan ke folder Unduhan: $name';
  }

  @override
  String get diagCopy => 'Salin laporan';

  @override
  String get diagCopied => 'Laporan disalin';

  @override
  String get diagNewIssue => 'Issue baru di GitHub';

  @override
  String get diagIssueHint =>
      'Laporan disalin. Tempelkan ke kotak “Diagnostics report” di issue.';

  @override
  String diagFailed(String detail) {
    return 'Tidak dapat membuat laporan: $detail';
  }

  @override
  String get svcExtractTitle =>
      'Instal atau ekstrak PasteFerry terlebih dahulu';

  @override
  String get svcExtractBody =>
      'PasteFerry dijalankan langsung dari file zip, dan folder sementaranya hilang saat Anda menutupnya. Jalankan penginstal, atau ekstrak seluruh folder dan buka dari sana, untuk mengaktifkan sinkronisasi latar belakang.';

  @override
  String get svcMoveTitle => 'Pindahkan PasteFerry ke Aplikasi terlebih dahulu';

  @override
  String get svcMoveBody =>
      'PasteFerry dijalankan langsung dari image disk. Seret ke Aplikasi, keluarkan image disk, lalu buka dari Aplikasi untuk mengaktifkan sinkronisasi latar belakang.';

  @override
  String get svcStartTitle => 'Mulai menggunakan PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry menjalankan proses latar belakang kecil untuk sinkronisasi papan klip. Proses ini tetap berjalan saat jendela ditutup. Buka saat login adalah pengaturan tersendiri dan nonaktif untuk instalasi baru.';

  @override
  String get svcEnable => 'Aktifkan sinkronisasi latar belakang';

  @override
  String get svcStaleTitle => 'Aktifkan lagi sinkronisasi latar belakang';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry telah dipindahkan, tetapi pembukaan saat login masih mengarah ke lokasi lama. Aktifkan lagi agar proses latar belakang memakai salinan ini. Riwayat dan pasangan perangkat tetap disimpan.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry telah dipindahkan, atau diinstal dengan skrip lama. Aktifkan lagi agar proses latar belakang memakai aplikasi ini. Riwayat dan pasangan perangkat tetap disimpan.';

  @override
  String get svcReenable => 'Aktifkan lagi';

  @override
  String get svcStoppedTitle => 'Layanan latar belakang tidak berjalan';

  @override
  String get svcStoppedBody =>
      'Layanan latar belakang berhenti. Mulai dengan tombol di bawah; buka saat login diatur terpisah di Pengaturan.';

  @override
  String get svcDevBodyWin =>
      'Ini adalah build pengembangan tanpa pasteferryd.exe di sebelahnya. Jalankan scripts\\build-windows.ps1 di folder sumber untuk membuat versi lengkap.';

  @override
  String get svcDevBodyLinux =>
      'Ini adalah build pengembangan tanpa pasteferryd di sebelahnya. Jalankan ./scripts/package-linux.sh di folder sumber untuk membuat versi lengkap.';

  @override
  String get svcDevBodyMac =>
      'Ini adalah build pengembangan tanpa layanan latar belakang. Jalankan ./scripts/install-macos.sh di folder sumber untuk menginstalnya.';

  @override
  String svcLogPath(String path) {
    return 'Log: $path';
  }

  @override
  String get svcCanDisable =>
      'Anda dapat menonaktifkan sinkronisasi latar belakang kapan saja di Pengaturan.';

  @override
  String get officialService => 'Layanan';

  @override
  String get useOfficialService => 'Gunakan Layanan';

  @override
  String get officialServiceDesc =>
      'Sinkron antarjaringan, utamakan koneksi langsung';

  @override
  String get officialPrivacy =>
      'Terhubung ke Layanan hanya jika diaktifkan dan mencatat informasi koneksi yang penting. Koneksi langsung dicoba terlebih dahulu; akses relai hanya diminta jika gagal. Konten, nama asli perangkat, dan pengenal sistem mentah tidak diunggah.';

  @override
  String get officialEnableTitle => 'Aktifkan Layanan?';

  @override
  String get officialSwitchConfirm =>
      'Ini akan beralih dari server khusus Anda. Alamatnya yang tersimpan tetap dipertahankan.';

  @override
  String get customServer => 'Server khusus';

  @override
  String get saveAndConnect => 'Simpan dan hubungkan';

  @override
  String get officialLoading => 'Memeriksa jatah…';

  @override
  String get officialFetchFailed =>
      'Jatah tidak dapat diambil saat ini. Akan dicoba lagi otomatis.';

  @override
  String get officialUnavailable =>
      'Data penggunaan tidak tersedia; data yang ada mungkin sudah usang';

  @override
  String get officialQuotaTitle => 'Jatah relai harian habis';

  @override
  String get officialQuotaBody =>
      'Relai Layanan dijeda hingga reset harian pukul 00.00 waktu Beijing. Koneksi LAN dan internet langsung tetap tersedia. Transfer yang gagal dapat dicoba lagi nanti.';

  @override
  String get officialPeerQuota =>
      'Jatah relai perangkat lain sudah habis. Koneksi langsung tetap tersedia.';

  @override
  String get officialPaused =>
      'Relai Layanan tidak tersedia. Koneksi langsung tetap tersedia.';

  @override
  String get officialViewUsage => 'Lihat penggunaan';

  @override
  String get officialAcknowledge => 'Mengerti';

  @override
  String get officialToday => 'Jatah relai hari ini';

  @override
  String get officialUsed => 'Terpakai';

  @override
  String get officialRemaining => 'Sisa';

  @override
  String get officialDailyLimit => 'Jatah harian';

  @override
  String get officialUpload => 'Unggah';

  @override
  String get officialDownload => 'Unduh';

  @override
  String get officialReset => 'Waktu reset (Beijing)';

  @override
  String get officialUpdated => 'Terakhir diperbarui';

  @override
  String get officialRoutes => 'Cara perangkat terhubung';

  @override
  String get officialRoutesFootnote =>
      'Koneksi langsung tidak melewati relai Layanan dan tidak memakai jatah.';

  @override
  String get officialDeviceID => 'ID perangkat';

  @override
  String get officialWarning =>
      '90% jatah relai harian telah terpakai. Koneksi langsung tidak memakainya.';

  @override
  String get updateCheck => 'Periksa pembaruan';

  @override
  String get updateCheckEllipsis => 'Periksa pembaruan…';

  @override
  String get updateAuto => 'Periksa pembaruan secara otomatis';

  @override
  String get updateChecking => 'Memeriksa pembaruan…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version adalah versi terbaru.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version tersedia';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Versi Anda $current. Ukuran unduhan $size.';
  }

  @override
  String get updateNew => 'Baru';

  @override
  String get updateFixed => 'Diperbaiki';

  @override
  String get updateSkip => 'Lewati versi ini';

  @override
  String get updateLater => 'Nanti';

  @override
  String get updateInstall => 'Unduh dan instal';

  @override
  String updateDownloading(String done, String total) {
    return 'Mengunduh $done dari $total';
  }

  @override
  String get updateVerifying => 'Memeriksa unduhan…';

  @override
  String get updateInstalling =>
      'Menginstal. PasteFerry akan terbuka kembali dengan sendirinya.';

  @override
  String get updateInstallingPassword =>
      'Menginstal. Sistem akan meminta kata sandi Anda karena /opt memerlukan hak administrator; setelah itu PasteFerry terbuka kembali dengan sendirinya.';

  @override
  String get updateCheckFailed =>
      'Tidak dapat menjangkau GitHub atau Gitee. Coba lagi nanti.';

  @override
  String get updateDownloadFailed =>
      'Unduhan tidak selesai. Coba lagi, atau unduh versi baru dari situs web.';

  @override
  String updateInstallFailed(String error) {
    return 'Tidak dapat memulai instalasi: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Build ini tidak dapat memeriksa pembaruan.';

  @override
  String get updateBlockedDev =>
      'Ini adalah build pengembangan, jadi tidak dapat memperbarui sendiri.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry dijalankan dari image disk. Seret ke Aplikasi dan buka dari sana agar dapat diperbarui otomatis.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry tidak dapat menulis ke folder instalasinya. Unduh versi baru dari situs web.';

  @override
  String get updateBlockedUnsupported =>
      'Tidak ada pembaruan otomatis untuk komputer ini. Unduh versi baru dari situs web.';

  @override
  String get updateOpenDownload => 'Buka halaman unduhan';

  @override
  String updateSidebar(String version) {
    return 'Versi $version tersedia';
  }

  @override
  String updatedTo(String version) {
    return 'Diperbarui ke $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Pembaruan tidak selesai. Anda masih memakai $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Pembaruan tidak selesai. Anda masih memakai $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · Layanan $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Belum diterima — terima sebelum menempel';

  @override
  String get receivedPreserved =>
      'Diterima; gunakan Salin ke papan klip jika sudah siap';

  @override
  String get clipboardWriteFailed =>
      'Diterima, tetapi papan klip tidak dapat diperbarui';

  @override
  String get receivingStatus => 'Menerima…';

  @override
  String get largeFileNotifications => 'Pengingat file besar';

  @override
  String get notificationsAllowed =>
      'Notifikasi diaktifkan. Progres ditampilkan di Riwayat.';

  @override
  String get notificationsNotRequested =>
      'Aktifkan notifikasi agar file besar tidak menunggu tanpa pemberitahuan. Anda selalu dapat menerimanya dari Riwayat.';

  @override
  String get notificationsDenied =>
      'Notifikasi diblokir di pengaturan sistem. Terima item yang tertunda dari Riwayat.';

  @override
  String get notificationsUnknown =>
      'Desktop Anda yang mengatur pengiriman notifikasi dan Jangan Ganggu. Terima item dari Riwayat jika tidak ada pengingat yang muncul.';

  @override
  String get notificationsUnavailable =>
      'Notifikasi sistem tidak tersedia. Terima file besar dari Riwayat.';

  @override
  String get enableNotifications => 'Aktifkan pengingat';

  @override
  String get notificationSettings => 'Pengaturan notifikasi';

  @override
  String get notifyPendingTitle => 'Terima untuk menempel';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nTerima item ini sebelum menempel. Anda juga dapat menerimanya dari Riwayat.';
  }

  @override
  String get notifyReceivingTitle => 'Menerima…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nLihat progresnya di Riwayat.';
  }

  @override
  String get notifyReadyTitle => 'Siap ditempel';

  @override
  String notifyReadyBody(String name) {
    return '$name\nDiterima dan ditaruh di papan klip.';
  }

  @override
  String get notifyReceivedTitle => 'Diterima';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nPapan klip Anda tidak diubah. Gunakan Salin ke papan klip jika sudah siap; opsi ini juga ada di Riwayat.';
  }

  @override
  String get notifyFailedTitle => 'Tidak dapat menerima';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nCoba lagi dari notifikasi ini atau dari Riwayat.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Diterima; papan klip tidak diperbarui';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nGunakan Salin ke papan klip untuk mencoba lagi, di sini atau di Riwayat.';
  }

  @override
  String get reconnect => 'Hubungkan ulang';

  @override
  String get reconnecting => 'Menghubungkan…';

  @override
  String get reconnectDirect => 'Terhubung langsung';

  @override
  String get reconnectRelay =>
      'Tidak dapat terhubung langsung, masih memakai relai';

  @override
  String reconnectOffline(String name) {
    return '“$name” sedang offline. Pastikan PasteFerry terbuka di perangkat itu.';
  }

  @override
  String get reconnectPending =>
      'Masih menghubungkan, periksa lagi sebentar lagi';

  @override
  String get renameAction => 'Ganti nama';

  @override
  String get renameFavoriteTitle => 'Ganti nama favorit';

  @override
  String get renameFavoriteHint =>
      'Ditampilkan di Favorit dan Tempel cepat, dan dapat dicari. Kosongkan untuk menampilkan isinya lagi.';

  @override
  String get renamedToast => 'Nama diganti';

  @override
  String get aliasClearedToast => 'Menampilkan isinya lagi';

  @override
  String get navSend => 'Kirim File';

  @override
  String get sendSubtitle =>
      'Seret file ke perangkat untuk mengirimnya langsung';

  @override
  String get sendNoDevicesTitle => 'Belum ada perangkat yang dipasangkan';

  @override
  String get sendNoDevicesBody =>
      'Pasangkan komputer lain terlebih dahulu, lalu kirim file ke komputer itu di sini.';

  @override
  String get sendDropHint => 'Letakkan di perangkat untuk mengirim';

  @override
  String sendReleaseTo(String name) {
    return 'Lepaskan untuk mengirim ke $name';
  }

  @override
  String get sendLan => 'Jaringan lokal';

  @override
  String sendRelayLeft(String left) {
    return 'Relai · sisa $left hari ini';
  }

  @override
  String get sendNeedsUpdate => 'Perlu diperbarui';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name dapat menerima file setelah diperbarui ke PasteFerry 2.5 atau yang lebih baru.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Menghubungkan ke $name. Anda dapat mengirim setelah terhubung.';
  }

  @override
  String get sendNotReceiving => 'Tidak menerima file';

  @override
  String get sendDelivered => 'Terkirim';

  @override
  String sendToTitle(String name) {
    return 'Kirim ke $name';
  }

  @override
  String get sendDropHere => 'Seret file atau folder ke sini';

  @override
  String get sendDropStarts => 'Pengiriman dimulai begitu Anda meletakkannya';

  @override
  String get sendChooseFiles => 'Pilih File…';

  @override
  String get sendChooseFolder => 'Pilih Folder…';

  @override
  String get sendDropMore => 'Letakkan file lain untuk mengirimnya berikutnya';

  @override
  String sendSavedWhere(String name) {
    return 'File disimpan di lokasi yang dipilih $name — secara default folder Unduhan.';
  }

  @override
  String get sendCloseKeeps =>
      'Menutup jendela ini tidak menghentikan pengiriman';

  @override
  String get sendRemoveQueued => 'Hapus';

  @override
  String get sendCannotDrop =>
      'Item ini tidak dapat dikirim dengan diseret. Simpan sebagai file terlebih dahulu, atau gunakan Pilih File….';

  @override
  String sendErrOffline(String name) {
    return '$name sedang offline.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name tidak menerima file.';
  }

  @override
  String get sendErrMissing => 'Beberapa file ini sudah tidak ada.';

  @override
  String get relayConfirmTitle => 'Kirim melalui relai Layanan?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name saat ini tidak terhubung langsung ke komputer ini, jadi file dikirim melalui relai Layanan dengan kecepatan sekitar 0,25 MB/s. Sisa jatah relai hari ini: $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'File ini ($size) melebihi sisa jatah. Pengiriman dijeda saat jatah habis dan berlanjut ketika kedua komputer terhubung langsung atau jatah direset besok.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Ini memakai sekitar $size dari jatah hari ini.';
  }

  @override
  String get relayExhausted =>
      'Jatah relai hari ini sudah habis dan akan direset pukul 00.00 waktu Beijing. Dua komputer yang terhubung langsung tidak dibatasi.';

  @override
  String get relayDontAskToday =>
      'Jangan tanya lagi hari ini untuk perangkat ini';

  @override
  String get relaySendAnyway => 'Tetap Kirim';

  @override
  String get relayOwnServer =>
      'Melalui relai — kecepatan bergantung pada server Anda';

  @override
  String get transfersReceived => 'Diterima';

  @override
  String get transfersSent => 'Terkirim';

  @override
  String get transfersClearAll => 'Hapus Semua';

  @override
  String get transfersClearTitle => 'Hapus daftar ini?';

  @override
  String get transfersClearBody =>
      'Hanya daftarnya yang dihapus. File tetap di tempatnya.';

  @override
  String get transfersEmptyReceived =>
      'File yang dikirim perangkat lain kepada Anda muncul di sini';

  @override
  String get transfersEmptySent => 'File yang Anda kirim muncul di sini';

  @override
  String transferFrom(String name) {
    return 'Dari $name';
  }

  @override
  String transferTo(String name) {
    return 'Ke $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name dan $others lainnya';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'Dalam antrean';

  @override
  String transferScanning(String count) {
    return 'Menghitung… $count file ditemukan';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Menunggu $name…';
  }

  @override
  String get transferSending => 'Mengirim';

  @override
  String get transferReceiving => 'Menerima';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Sekarang: $file ($index dari $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Sisa $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n detik',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n menit',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h j $m mnt';
  }

  @override
  String get transferPaused => 'Dijeda: jatah relai hari ini sudah habis';

  @override
  String get transferInterrupted =>
      'Terputus — berlanjut setelah terhubung lagi';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Terputus — menunggu $name melanjutkan';
  }

  @override
  String get transferCancelled => 'Dibatalkan';

  @override
  String transferPeerCancelled(String name) {
    return 'Dibatalkan oleh $name';
  }

  @override
  String get transferExpired => 'Kedaluwarsa';

  @override
  String get transferMissing => 'Dipindahkan atau dihapus';

  @override
  String transferNotSent(String reason) {
    return 'Tidak terkirim: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Tidak diterima: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return 'Ruang disk $name tidak cukup (kurang $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'ruang disk tidak cukup (kurang $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'lokasi penyimpanan $name tidak tersedia';
  }

  @override
  String get reasonDestUnavailable =>
      'lokasi penyimpanan tidak tersedia — periksa di Pengaturan';

  @override
  String get reasonFileTooLarge =>
      'lokasi penyimpanan ada di drive FAT32, yang tidak dapat menampung file lebih dari 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name tidak menerima file';
  }

  @override
  String get reasonSourceChanged => 'ada file yang berubah saat sedang dikirim';

  @override
  String get reasonSourceMissing => 'ada file yang sudah tidak ada';

  @override
  String get reasonReadError => 'ada file yang tidak dapat dibaca';

  @override
  String get reasonWriteFailed => 'file tidak dapat ditulis';

  @override
  String get reasonHashMismatch => 'ada file yang rusak saat dikirim';

  @override
  String reasonUnsupported(String name) {
    return '$name perlu diperbarui untuk menerima file';
  }

  @override
  String get reasonOther => 'terjadi kesalahan';

  @override
  String get revealInFinder => 'Tampilkan di Finder';

  @override
  String get revealInFolder => 'Tampilkan di Folder';

  @override
  String get revealOpenFolder => 'Buka Folder';

  @override
  String get transferResend => 'Kirim Lagi';

  @override
  String get transferRemove => 'Hapus dari Daftar';

  @override
  String get transferCopyPath => 'Salin Jalur';

  @override
  String get transferPathCopied => 'Jalur disalin';

  @override
  String sendingTo(String name, String percent) {
    return 'Mengirim ke $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Menerima dari $name · $percent';
  }

  @override
  String get receiveFiles => 'Terima file dari perangkat lain';

  @override
  String get saveTo => 'Simpan ke';

  @override
  String get saveToChange => 'Ubah…';

  @override
  String get saveToDefault => 'Unduhan (default)';

  @override
  String get saveToUseDefault => 'Gunakan Unduhan';

  @override
  String get receiveNotify => 'Beri tahu saat file tiba';

  @override
  String receiveFootnote(String device) {
    return 'Hanya perangkat yang dipasangkan yang dapat mengirim file ke $device. Selama file ditransfer, $device tidak akan tidur dengan sendirinya.';
  }

  @override
  String get saveDirNotFound => 'Folder ini tidak ada.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry tidak dapat menyimpan file di folder ini.';

  @override
  String get saveDirPermission =>
      'PasteFerry tidak diizinkan memakai folder ini. Izinkan di Pengaturan Sistem → Privasi & Keamanan → File dan Folder.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count nama file berisi karakter yang tidak diizinkan Windows; karakter itu diganti dengan karakter lebar penuh yang mirip',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Jaringan sama';

  @override
  String get sendRingOther => 'Jaringan lain';

  @override
  String sendOfflineList(String names) {
    return 'Offline: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Daftar transfer';

  @override
  String get sendLayoutSide => 'Di samping radar';

  @override
  String get sendLayoutBelow => 'Di bawah radar';

  @override
  String get general => 'Umum';

  @override
  String get launchAtLogin => 'Buka saat login';

  @override
  String get launchAtLoginDesc =>
      'Mulai di latar belakang saat Anda login. Mengubah ini tidak menghentikan sesi saat ini.';

  @override
  String get realtimeSync => 'Sinkronisasi papan klip real-time';

  @override
  String get realtimeSyncDesc =>
      'Bagikan salinan baru ke perangkat yang dipasangkan secara otomatis. Riwayat lokal dan Kirim File tetap tersedia saat nonaktif.';

  @override
  String get syncBacklog => 'Susul setelah terhubung lagi';

  @override
  String get syncBacklogDesc =>
      'Nonaktif secara default: salinan yang terlewat diabaikan. Jika diaktifkan, hingga 20 salinan dari 24 jam terakhir masuk ke riwayat tanpa mengganti papan klip.';

  @override
  String get peerRealtimeSync => 'Sinkron dengan komputer ini';

  @override
  String get syncPaused => 'Sinkronisasi papan klip dijeda';

  @override
  String get quitApp => 'Keluar dari PasteFerry';

  @override
  String get quitAppDesc =>
      'Hentikan semua proses PasteFerry. Preferensi buka saat login tetap disimpan.';

  @override
  String get quitTransfersWarning =>
      'Masih ada file yang sedang ditransfer. Keluar dan hentikan transfer ini?';

  @override
  String get backgroundRunningTitle => 'PasteFerry akan tetap berjalan';

  @override
  String get backgroundRunningBody =>
      'Menutup jendela tidak menghentikan sinkronisasi dan tempel cepat. Untuk menghentikan semuanya, pilih Keluar dari PasteFerry di Pengaturan atau menu aplikasi.';

  @override
  String get displayAs => 'Ditampilkan sebagai';

  @override
  String get editName => 'Ubah Nama';

  @override
  String get nameHint => 'Nama yang dilihat kontak Anda';

  @override
  String get nameDefaultHint => 'Kosongkan untuk memakai nama akun Anda.';

  @override
  String get avatarTitle => 'Foto Profil';

  @override
  String get avatarChoose => 'Pilih Gambar…';

  @override
  String get avatarPaste => 'Tempel Gambar';

  @override
  String get avatarReset => 'Gunakan Foto Default';

  @override
  String get avatarZoom => 'Perbesar';

  @override
  String get avatarDragHint => 'Seret untuk memindahkan gambar.';

  @override
  String get avatarNoImage => 'Tidak ada gambar di papan klip.';

  @override
  String get avatarBad =>
      'Gambar ini tidak dapat dipakai. Pilih PNG, JPEG, atau GIF.';

  @override
  String get done => 'Selesai';

  @override
  String get friendsTitle => 'Kontak';

  @override
  String get addFriend => 'Tambah Kontak';

  @override
  String get friendsEmpty => 'Belum ada kontak';

  @override
  String get friendsEmptyBody =>
      'Tambahkan orang lain yang juga memakai PasteFerry untuk saling mengirim file tanpa memasangkan perangkat. Kontak hanya dapat mengirim file; mereka tidak pernah melihat papan klip Anda.';

  @override
  String get friendSendAction => 'Kirim…';

  @override
  String get friendHistory => 'Transfer';

  @override
  String friendHistoryTitle(String name) {
    return 'Transfer dengan $name';
  }

  @override
  String get friendHistoryEmpty => 'Belum ada transfer.';

  @override
  String get friendAutoAccept => 'Terima File Secara Otomatis';

  @override
  String get friendRemove => 'Hapus Kontak';

  @override
  String friendRemoveTitle(String name) {
    return 'Hapus $name?';
  }

  @override
  String get friendRemoveBody =>
      'Anda berdua akan dihapus dari kontak masing-masing dan tidak dapat lagi saling mengirim file. Transfer sebelumnya tetap ada di komputer ini.';

  @override
  String friendLastActivity(String time) {
    return 'Transfer terakhir $time';
  }

  @override
  String get friendNoActivity => 'Belum ada transfer';

  @override
  String get friendCodeShare =>
      'Kirim kode ini ke kontak Anda. Saat mereka memasukkannya di PasteFerry, Anda berdua akan saling ditambahkan ke kontak.';

  @override
  String friendCodeExpires(String time) {
    return 'Kedaluwarsa dalam $time';
  }

  @override
  String get friendCodeOr => 'atau';

  @override
  String get friendCodeEnter => 'Masukkan kode kontak mereka';

  @override
  String get friendCodeAdd => 'Tambah';

  @override
  String get friendCodeWaiting => 'Menunggu mereka memasukkannya…';

  @override
  String friendConfirmBody(String name) {
    return 'Tambahkan $name ke kontak Anda?';
  }

  @override
  String get friendSafetyCode => 'Periksa kode keamanan (opsional)';

  @override
  String get friendSafetyHint =>
      'Saat Anda bersama, bandingkan dua baris ini. Jika sama di kedua komputer, tidak ada yang mengganggu.';

  @override
  String get friendWaitingPeer => 'Menunggu mereka menambahkan Anda…';

  @override
  String friendAdded(String name) {
    return '$name ditambahkan ke kontak Anda';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name membatalkan';
  }

  @override
  String get friendErrFriendCode =>
      'Ini kode kontak. Masukkan di Tambah Kontak pada halaman Kirim File.';

  @override
  String get friendErrDeviceCode =>
      'Ini kode pemasangan. Masukkan di Perangkat → Tambah perangkat.';

  @override
  String get friendErrOutdated =>
      'Mereka memerlukan PasteFerry 2.6.0 atau yang lebih baru.';

  @override
  String get friendErrAlreadyPaired =>
      'Komputer itu sudah menjadi salah satu perangkat Anda.';

  @override
  String get friendErrNoChannel =>
      'Anda tidak berada di jaringan yang sama. Aktifkan Layanan di kedua komputer untuk saling menambahkan.';

  @override
  String get openService => 'Aktifkan Layanan…';

  @override
  String get noteLabel => 'Catatan (opsional)';

  @override
  String get noteHintEmpty => 'Pilih file terlebih dahulu';

  @override
  String get noteHint => 'Misalnya: tolong tanda tangani halaman 3';

  @override
  String noteLine(String note) {
    return 'Catatan: $note';
  }

  @override
  String get sendAction => 'Kirim';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count item · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Letakkan file atau gambar di sini, atau tempel ($key)';
  }

  @override
  String get sendDropMorePaste => 'Letakkan atau tempel lagi';

  @override
  String get sendPasteNothing =>
      'Tidak ada yang bisa ditempel. Salin file atau gambar terlebih dahulu.';

  @override
  String get sendRemoveItem => 'Hapus';

  @override
  String sendFriendSaved(String name) {
    return '$name menerima setiap kiriman sebelum dikirim.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Menunggu $name menerima…';
  }

  @override
  String get transferAskingIn => 'Menunggu Anda menerima';

  @override
  String reasonDeclined(String name) {
    return '$name menolak';
  }

  @override
  String reasonTimeout(String name) {
    return '$name tidak merespons';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name tidak menerima file';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name sedang tidak menerima file Anda';
  }

  @override
  String get reasonYouDeclined => 'Ditolak';

  @override
  String get reasonYouIgnored => 'Diabaikan';

  @override
  String get sendAgain => 'Kirim Lagi';

  @override
  String incomingTitle(String name) {
    return '$name ingin mengirimi Anda file';
  }

  @override
  String get incomingAlways => 'Selalu terima file dari kontak ini';

  @override
  String get incomingDecline => 'Tolak';

  @override
  String get incomingAccept => 'Terima';

  @override
  String incomingCountdown(String seconds) {
    return 'Ditolak otomatis dalam $seconds dtk';
  }

  @override
  String get incomingStranger => 'Di sekitar';

  @override
  String get friendsStrip => 'Kontak';

  @override
  String get strangersStrip => 'Di sekitar dengan Semua orang aktif';

  @override
  String get strangerNearby => 'Di sekitar';

  @override
  String get friendNeedService => 'Aktifkan Layanan';

  @override
  String get friendCantReach => 'Tidak dapat terhubung';

  @override
  String reachSelfNoService(String name) {
    return 'Anda dan $name tidak berada di jaringan yang sama. Aktifkan Layanan untuk mengirim file; jika koneksi langsung tidak memungkinkan, file dikirim melalui relai Layanan.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name belum mengaktifkan Layanan, jadi Anda hanya dapat mengirim file di jaringan yang sama. Minta mereka mengaktifkan Layanan di PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Anda tidak memakai server yang sama. Aktifkan Layanan di kedua komputer, atau gunakan server yang sama, untuk mengirim file.';

  @override
  String get receiveFromLabel => 'Izinkan orang-orang ini mengirimi saya file:';

  @override
  String get receiveFromOff => 'Tidak Ada';

  @override
  String get receiveFromFriends => 'Hanya Kontak';

  @override
  String get receiveFromEveryone => 'Semua Orang';

  @override
  String everyoneLeft(String minutes) {
    return 'Semua Orang · sisa $minutes mnt';
  }

  @override
  String get receiveFromOffDesc =>
      'Hanya komputer Anda sendiri yang dipasangkan yang dapat mengirimi Anda file.';

  @override
  String get receiveFromFriendsDesc =>
      'Kontak Anda dapat mengirimi Anda file. Anda menerima setiap kiriman.';

  @override
  String get receiveFromEveryoneDesc =>
      'Siapa pun di jaringan yang sama dapat mengirimi Anda file selama 10 menit. Anda menerima setiap kiriman.';

  @override
  String get everyoneEnded =>
      'Semua Orang dinonaktifkan; kembali ke Hanya Kontak.';

  @override
  String get friendsCountTooltip => 'Kontak';

  @override
  String get waitingAccept => 'Menunggu…';

  @override
  String get settingsConnection => 'Koneksi';

  @override
  String get settingsGeneralSummary =>
      'Buka saat login, nama perangkat, bahasa';

  @override
  String get settingsConnectionSummary =>
      'Layanan, server sendiri, jaringan lokal';

  @override
  String get settingsSyncSummary =>
      'Sinkronisasi real-time, batas ukuran, yang disinkronkan';

  @override
  String get settingsQuickPasteSummary =>
      'Pintasan dan tindakan setelah memilih';

  @override
  String get settingsSendSummary => 'Menerima file, lokasi penyimpanan';

  @override
  String get settingsStorageSummary => 'Lama riwayat disimpan, ruang terpakai';

  @override
  String get settingsAboutSummary => 'Versi, pembaruan, masukan';

  @override
  String get friendsSubtitle =>
      'Kirim file ke komputer orang lain, tanpa perlu memasangkan';

  @override
  String get friendsSearch => 'Cari kontak';

  @override
  String get friendsNoMatch => 'Tidak ada kontak yang cocok';

  @override
  String get friendsPick =>
      'Pilih kontak untuk melihat transfer atau mengirim file';

  @override
  String friendDropHint(String name) {
    return 'Letakkan file di sini untuk mengirimnya ke $name';
  }

  @override
  String get webShareTitle => 'Transfer web ponsel';

  @override
  String get webShareFootnote =>
      'Pindai kode QR dengan ponsel untuk saling mengirim teks, foto, dan file dengan komputer ini lewat browser, tanpa aplikasi. Ponsel dan komputer harus berada di jaringan yang sama.';

  @override
  String get webShareSwitch => 'Izinkan ponsel terhubung lewat browser';

  @override
  String webShareOn(int count) {
    return 'Aktif, $count ponsel';
  }

  @override
  String get webShareOff => 'Nonaktif';

  @override
  String get webShareShowQr => 'Tampilkan kode QR';

  @override
  String get webShareDialogTitle => 'Pindai dengan ponsel Anda';

  @override
  String get webShareDialogBody =>
      'Pindai dengan kamera atau browser ponsel lalu buka di browser. Setiap kode QR mendaftarkan satu ponsel dan diganti setelah dipakai.';

  @override
  String get webShareAddress => 'Alamat';

  @override
  String get webShareSecurity =>
      'Konten dienkripsi di halaman, jadi orang lain di jaringan tidak dapat membacanya. Namun halamannya sendiri memakai http dan tidak dapat mencegah orang yang sengaja mengubahnya. Gunakan di rumah atau di jaringan kantor tepercaya, bukan di Wi-Fi publik.';

  @override
  String get webSharePhones => 'Ponsel terdaftar';

  @override
  String get webShareNoPhones => 'Belum ada ponsel';

  @override
  String webShareLastUsed(String time) {
    return 'Terakhir dipakai $time';
  }

  @override
  String get webShareRemove => 'Hapus';

  @override
  String webShareRemoved(String name) {
    return '“$name” dihapus';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name” terdaftar';
  }

  @override
  String webShareNotListening(String error) {
    return 'Tidak dapat mulai mendengarkan: $error';
  }

  @override
  String get webSharePortFallback =>
      'Port biasa sedang dipakai, jadi port sementara digunakan. Alamat yang disimpan tidak akan terbuka sampai ponsel memindai lagi.';

  @override
  String get webShareNoAddress =>
      'Tidak ada alamat jaringan lokal. Hubungkan ke Wi-Fi atau jaringan kabel terlebih dahulu.';

  @override
  String get webShareCantOpen =>
      'Jika halaman tidak terbuka di ponsel, pastikan keduanya berada di jaringan yang sama (jaringan tamu biasanya tidak berfungsi). Di Windows, PasteFerry juga harus diizinkan melewati firewall.';

  @override
  String get mTabRecords => 'Riwayat';

  @override
  String get mTabSend => 'Kirim';

  @override
  String get mThisPhone => 'Ponsel ini';

  @override
  String get mThisPhoneInText => 'ponsel ini';

  @override
  String mThisPhoneName(String name) {
    return 'Ponsel ini: $name';
  }

  @override
  String get mSendTitle => 'Kirim ke komputer Anda';

  @override
  String get mSendHint => 'Ketik atau tempel teks';

  @override
  String get mPaste => 'Tempel';

  @override
  String get mPhotosFiles => 'Foto atau file';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Kirim $n file?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n file terkirim ke komputer Anda',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Tidak ada teks di papan klip';

  @override
  String get mSendAction => 'Kirim';

  @override
  String mSendTo(String names) {
    return 'Dikirim ke $names';
  }

  @override
  String get mNoOnlineDevices => 'Tidak ada perangkat online di sekitar';

  @override
  String get mNoPairedDevices => 'Pasangkan dengan komputer terlebih dahulu';

  @override
  String get mSent => 'Terkirim';

  @override
  String get mSendFootnote =>
      'Teks dan file masuk ke riwayat di komputer dan, sesuai pengaturannya, ke papan klipnya. Yang Anda salin di ponsel tidak dikirim dengan sendirinya.';

  @override
  String get mSentRecords => 'Terkirim';

  @override
  String get mSentRetention => 'Simpan riwayat kiriman';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Terkirim menampilkan yang dikirim ponsel ini dalam $d hari terakhir';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d hari';
  }

  @override
  String get mViewAll => 'Lihat semua';

  @override
  String get mClearCache => 'Hapus';

  @override
  String get mCheckUpdate => 'Periksa pembaruan';

  @override
  String get mUpdateFailed => 'Tidak dapat memeriksa pembaruan';

  @override
  String get mUpToDate => 'Versi Anda sudah terbaru';

  @override
  String mNewVersion(Object v) {
    return 'Versi $v tersedia';
  }

  @override
  String get mDownloadInstall => 'Unduh versi baru';

  @override
  String mSendFailed(String detail) {
    return 'Tidak dapat mengirim: $detail';
  }

  @override
  String get mCopy => 'Salin';

  @override
  String get mCopied => 'Disalin ke papan klip ponsel ini';

  @override
  String get mShare => 'Bagikan';

  @override
  String get mSaved => 'Disimpan ke Foto atau Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Tidak berhasil: $detail';
  }

  @override
  String get mDownloading => 'Mengunduh…';

  @override
  String get mNotDownloaded => 'Belum diunduh';

  @override
  String get mDownloadHint =>
      'Item diunduh terlebih dahulu saat Anda mengetuk Salin, Simpan, atau Bagikan.';

  @override
  String get mFullTextLoading => 'Memuat…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Menampilkan $shown karakter pertama dari $total. Salin mengambil semuanya.';
  }

  @override
  String get mNotOnLanTitle => 'Tidak terhubung ke Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Untuk saat ini PasteFerry hanya sinkron di jaringan lokal. Hubungkan ke Wi-Fi yang sama dengan komputer Anda.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry tidak dapat dimulai: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Di komputer Anda, buka PasteFerry → Perangkat → Tambah perangkat, lalu masukkan kode yang ditampilkannya di sini. Di Wi-Fi yang sama, Anda juga dapat membuka “Cari di sekitar” di keduanya.';

  @override
  String get mSectionSync => 'Sinkronisasi';

  @override
  String get mSectionBackground => 'Latar belakang';

  @override
  String get mAutoApplyDesc =>
      'Teks yang disalin di komputer langsung masuk ke papan klip ponsel ini. Gambar dan file menunggu sampai Anda mengetuk Salin.';

  @override
  String get mKeepAlive => 'Tetap terhubung di latar belakang';

  @override
  String get mKeepAliveDesc =>
      'Terima teks meski PasteFerry tidak terbuka. Menampilkan notifikasi yang terus aktif.';

  @override
  String get mNotifications => 'Notifikasi';

  @override
  String get mNotificationsDesc =>
      'Diperlukan untuk notifikasi yang terus aktif. PasteFerry tetap berfungsi tanpanya.';

  @override
  String get mBattery => 'Berjalan di latar belakang';

  @override
  String get mBatteryDesc =>
      'Nonaktifkan pengoptimalan baterai agar sistem tidak menghentikan PasteFerry saat layar terkunci. Beberapa ponsel juga perlu menambahkan PasteFerry ke daftar mulai otomatis atau latar belakang di Setelan.';

  @override
  String get mAllowed => 'Diizinkan';

  @override
  String get mAllow => 'Izinkan';

  @override
  String mVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get mDeleteConfirm => 'Hapus item ini?';

  @override
  String get mDelete => 'Hapus';

  @override
  String get webShareFirewallPreparing =>
      'Memeriksa Windows Firewall. Jika Windows meminta persetujuan administrator, pilih Ya agar ponsel Anda dapat terhubung.';

  @override
  String get webShareFirewallReady =>
      'Aturan Windows Firewall sudah siap. Hubungkan ponsel Anda ke jaringan yang sama dan pindai kode QR. Jika masih tidak dapat terhubung, periksa lagi firewall di bawah.';

  @override
  String get webShareFirewallFailed =>
      'Pengaturan firewall tidak selesai. Ponsel Anda mungkin tidak dapat membuka halaman. Coba lagi dan setujui permintaan administrator Windows.';

  @override
  String get webShareFirewallAllow => 'Periksa dan izinkan koneksi ponsel';

  @override
  String get mCopyMediaFailed =>
      'Tidak dapat menyalin gambar atau file ini. Coba simpan terlebih dahulu.';

  @override
  String get mShareMediaFailed =>
      'Tidak dapat membuka berbagi untuk gambar atau file ini. Coba simpan terlebih dahulu.';

  @override
  String get mSaveMediaFailed =>
      'Tidak dapat menyimpan gambar atau file ini. Periksa akses penyimpanan dan ruang kosong, lalu coba lagi.';

  @override
  String get noticeFilesUnreadable =>
      'File yang baru saja Anda salin tidak dapat dibaca, jadi tidak ada yang disinkronkan';

  @override
  String get mAddMore => 'Tambah lagi';

  @override
  String get mChoosePhotos => 'Pilih Foto…';

  @override
  String get mMultiSelectHint =>
      'Pilih beberapa foto sekaligus. Di File, sentuh lama sebuah item untuk memilih lebih banyak.';

  @override
  String get webSendFiles => 'Kirim file';

  @override
  String get webFilesQueued =>
      'Ditambahkan ke transfer web. Buka Kirim File di ponsel Anda untuk mengunduh.';

  @override
  String get webFilesLimit =>
      'Unduhan web mendukung hingga 200 MB per file dan 64 file per kiriman.';

  @override
  String get appearance => 'Tampilan';

  @override
  String get settingsAppearanceSummary => 'Tema, terang dan gelap';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeDefault => 'Default';

  @override
  String get themePixel => 'Piksel';

  @override
  String get themeMode => 'Terang dan gelap';

  @override
  String get themeModeSystem => 'Ikuti sistem';

  @override
  String get themeModeLight => 'Terang';

  @override
  String get themeModeDark => 'Gelap';

  @override
  String get themeCustom => 'Kustom';

  @override
  String get themeDelete => 'Hapus tema';

  @override
  String themeDeleteConfirm(String name) {
    return 'Hapus tema “$name”?';
  }

  @override
  String get themeLowContrast =>
      'Sebagian teks di tema ini mungkin sulit dibaca';

  @override
  String get themeFootnote =>
      'Tema hanya berlaku di perangkat ini, termasuk Tempel cepat. Tema tidak disinkronkan ke perangkat lain.';

  @override
  String get themeBuiltinGroup => 'Bawaan';

  @override
  String get themeCustomGroup => 'Kustom';

  @override
  String get themeUse => 'Gunakan';

  @override
  String get themeDuplicate => 'Duplikat';

  @override
  String themeCopyName(String name) {
    return 'Salinan $name';
  }

  @override
  String get themeExport => 'Ekspor…';

  @override
  String get themeImport => 'Impor tema…';

  @override
  String themeImported(String name) {
    return '“$name” diimpor';
  }

  @override
  String themeImportedWarn(String name, int count) {
    return '“$name” diimpor. $count warna teks mungkin sulit dibaca.';
  }

  @override
  String get themeExported => 'Tema diekspor';

  @override
  String get themeCustomEmpty =>
      'Belum ada tema kustom. Duplikat tema bawaan, impor tema, atau minta AI membuatkannya.';

  @override
  String get themeAskAi => 'Minta AI membuat tema';

  @override
  String get themeAskAiBody =>
      'Tambahkan server MCP ini ke aplikasi AI seperti Claude atau Cursor, lalu minta tema, misalnya “Buatkan tema cyberpunk”. AI akan membaca format tema, memilih warna, memeriksa kontras, dan menerapkan tema.';

  @override
  String get themeAskAiCopy => 'Salin konfigurasi';

  @override
  String get themeAskAiCopied => 'Konfigurasi disalin';

  @override
  String get themeScanlines => 'Garis pindai';

  @override
  String get themeScanlinesDesc =>
      'Lapisi jendela dengan garis pindai CRT yang samar. Hanya untuk tema piksel.';

  @override
  String get themeBackground => 'Gambar latar';

  @override
  String get themeBackgroundDesc =>
      'Mengisi jendela di belakang bilah samping dan halaman. Lapisan penutup di atasnya menjaga teks tetap terbaca.';

  @override
  String get themeBackgroundChoose => 'Pilih Gambar…';

  @override
  String get themeBackgroundChange => 'Ubah…';

  @override
  String get themeBackgroundRemove => 'Hapus';

  @override
  String get themeBlur => 'Buram';

  @override
  String get themeBlurNone => 'Tidak ada';

  @override
  String get themeBlurLight => 'Ringan';

  @override
  String get themeBlurStrong => 'Kuat';

  @override
  String get themeScrim => 'Lapisan penutup';

  @override
  String get themeScrimDesc =>
      'Warna yang dilapiskan di atas gambar agar teks tetap terbaca. Tidak pernah lebih terang dari yang diperlukan gambar.';

  @override
  String get themeScrimAuto => 'Otomatis';

  @override
  String get themeScrimMore => 'Lebih tebal';

  @override
  String get themeScrimMost => 'Paling tebal';

  @override
  String get themePanels => 'Panel';

  @override
  String get themePanelsDesc =>
      'Seberapa banyak gambar terlihat melalui bilah samping dan daftar.';

  @override
  String get themePanelsClear => 'Bening';

  @override
  String get themePanelsMedium => 'Sedang';

  @override
  String get themePanelsSolid => 'Pekat';

  @override
  String get themeAccentFromImage => 'Gunakan warna gambar';

  @override
  String get themeAccentFromImageDesc => 'Ambil warna aksen dari gambar.';

  @override
  String get themeBackgroundPicker => 'Tampilkan juga di Tempel cepat';

  @override
  String get themeScenery => 'Tampilkan pemandangan';

  @override
  String get themeSceneryDesc =>
      'Gambar di bagian atas halaman dan bagian bawah bilah samping.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Tema bawaan tidak dapat diubah, jadi salinan bernama “$name” dibuat dan diterapkan';
  }

  @override
  String get themeBackgroundFootnote =>
      'Latar belakang adalah bagian dari tema saat ini. Tema bawaan tidak dapat diubah: perubahan pertama akan membuat salinan. Gambar tetap di perangkat ini; JPEG, PNG, dan GIF didukung.';

  @override
  String get themeSceneGroup => 'Pemandangan';

  @override
  String get themeSceneHeader => 'Kepala halaman';

  @override
  String get themeSceneHeaderDesc =>
      'Gambar lebar di belakang judul halaman; bagian bawahnya memudar ke halaman. Tema piksel menggambar lanskap piksel di sini.';

  @override
  String get themeSceneSidebar => 'Bawah bilah samping';

  @override
  String get themeSceneSidebarDesc =>
      'Gambar kecil di bagian bawah bilah samping. Tema piksel menggambar perkemahan kecil di sini.';

  @override
  String get themeSceneReset => 'Atur ulang';

  @override
  String get themeSceneFootnote =>
      'Tema apa pun dapat menampilkan gambar Anda sendiri di sini. Lapisan penutup menjaga judul halaman tetap terbaca. Pemandangan disembunyikan saat gambar latar mengisi jendela.';

  @override
  String get starTitle => 'Bagaimana pendapat Anda tentang PasteFerry?';

  @override
  String get starBody =>
      'Jika Anda menyukainya, bintang di GitHub akan sangat berarti.';

  @override
  String get starAction => 'Beri Bintang di GitHub';

  @override
  String get starLater => 'Nanti';

  @override
  String get starDismiss => 'Jangan tampilkan lagi';
}
