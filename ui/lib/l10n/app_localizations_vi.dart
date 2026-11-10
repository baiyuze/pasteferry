// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Lịch sử';

  @override
  String get navDevices => 'Thiết bị';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get linkConnecting => 'Đang kết nối…';

  @override
  String get linkServiceNotRunning => 'Dịch vụ nền không chạy';

  @override
  String get linkLanMode => 'Đang tìm thiết bị trong mạng này';

  @override
  String get linkServerUnreachable =>
      'Không kết nối được máy chủ; đang đồng bộ trong mạng này';

  @override
  String get linkNothingOn =>
      'Đã tắt tìm thiết bị trong mạng cục bộ và chưa đặt máy chủ';

  @override
  String get linkLanBlocked => 'macOS đang chặn mạng cục bộ';

  @override
  String linkOnlinePeers(int count) {
    return '$count thiết bị trực tuyến';
  }

  @override
  String get linkServerConnected => 'Đã kết nối máy chủ';

  @override
  String linkConnectionLost(String detail) {
    return 'Mất kết nối: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Dịch vụ nền đã ngắt kết nối';

  @override
  String get linkServiceDisabled => 'Đồng bộ nền đang tắt';

  @override
  String get errServiceNotConnected => 'Chưa kết nối với dịch vụ nền';

  @override
  String get errUnimplemented => 'Tính năng này chưa khả dụng';

  @override
  String get errUnavailable => 'Không kết nối được dịch vụ nền';

  @override
  String errServiceStart(String detail) {
    return 'Không thể khởi động dịch vụ nền: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Không thể khởi động lại dịch vụ nền: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Không thể đặt PasteFerry tự mở khi đăng nhập: $detail';
  }

  @override
  String get thisMacTitle => 'Máy Mac này';

  @override
  String get thisPcTitle => 'Máy tính này';

  @override
  String get thisMacInText => 'máy Mac này';

  @override
  String get thisPcInText => 'máy tính này';

  @override
  String get bothMacs => 'cả hai máy Mac';

  @override
  String get bothDevices => 'cả hai thiết bị';

  @override
  String get thisDeviceShort => 'Thiết bị này';

  @override
  String fromDevice(String name) {
    return 'Từ $name';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get close => 'Đóng';

  @override
  String get save => 'Lưu';

  @override
  String get retry => 'Thử lại';

  @override
  String get continueAction => 'Tiếp tục';

  @override
  String get justNow => 'Vừa xong';

  @override
  String secondsAgo(int n) {
    return '$n giây trước';
  }

  @override
  String minutesAgo(int n) {
    return '$n phút trước';
  }

  @override
  String hoursAgo(int n) {
    return '$n giờ trước';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ngày trước',
      one: 'Hôm qua',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String durationHours(int n) {
    return '$n giờ';
  }

  @override
  String durationDays(int n) {
    return '$n ngày';
  }

  @override
  String get historyEmptySubtitle =>
      'Sao chép trên bất kỳ thiết bị nào, nội dung sẽ hiện ở đây';

  @override
  String historyCount(int count) {
    return '$count mục';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '$count mục, giữ trong $ttl';
  }

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterText => 'Văn bản';

  @override
  String get filterImage => 'Hình ảnh';

  @override
  String get filterFile => 'Tệp';

  @override
  String get filterLink => 'Liên kết';

  @override
  String get historyClearTooltip => 'Xóa lịch sử';

  @override
  String get historyEmptyTitle => 'Chưa có gì';

  @override
  String get historyEmptyFilteredTitle => 'Không có mục loại này';

  @override
  String get historyEmptyBody =>
      'Sao chép văn bản, hình ảnh hoặc tệp trên bất kỳ thiết bị nào đã ghép nối, nội dung sẽ hiện ở đây.';

  @override
  String get clearConfirmTitle => 'Xóa toàn bộ lịch sử?';

  @override
  String clearConfirmBody(String device) {
    return 'Mọi nội dung đồng bộ từ các thiết bị của bạn và các tệp trong bộ nhớ đệm sẽ bị xóa khỏi $device. Tệp gốc không bị ảnh hưởng.';
  }

  @override
  String get clear => 'Xóa';

  @override
  String get historyCleared => 'Đã xóa lịch sử';

  @override
  String get permDeniedTitle => 'PasteFerry không thể đọc bảng nhớ tạm';

  @override
  String get permAskTitle => 'Cho phép PasteFerry đọc bảng nhớ tạm';

  @override
  String get permDeniedBody =>
      'Nội dung bạn sao chép trên máy Mac này sẽ không được đồng bộ. Trong Cài đặt hệ thống, đặt PasteFerry Daemon thành Cho phép.';

  @override
  String get permAskBody =>
      'Nếu không, macOS sẽ hỏi mỗi lần. Trong Cài đặt hệ thống, đặt PasteFerry Daemon thành Cho phép.';

  @override
  String get openSystemSettings => 'Mở Cài đặt hệ thống';

  @override
  String get fetch => 'Nhận';

  @override
  String get fetchStarted => 'Đang nhận… Xem tiến trình trong Lịch sử';

  @override
  String get transferFailed => 'Truyền không thành công';

  @override
  String get expired => 'Đã hết hạn';

  @override
  String get putOnClipboard => 'Chép vào bảng nhớ tạm';

  @override
  String get putOnClipboardDone => 'Đã chép vào bảng nhớ tạm';

  @override
  String get deleteRecord => 'Xóa mục này';

  @override
  String get deleted => 'Đã xóa';

  @override
  String get emptyRecord => '(trống)';

  @override
  String get imageRecord => 'Hình ảnh';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name và $others mục khác';
  }

  @override
  String get searchHint => 'Tìm văn bản và tên tệp';

  @override
  String get searchClear => 'Xóa tìm kiếm';

  @override
  String searchResultCount(int count) {
    return '$count kết quả';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Không có kết quả cho “$query”';
  }

  @override
  String get searchEmptyBody =>
      'Tìm kiếm trong văn bản đã sao chép và tên của các tệp đã sao chép.';

  @override
  String get favoriteAction => 'Thêm vào Yêu thích';

  @override
  String get unfavoriteAction => 'Xóa khỏi Yêu thích';

  @override
  String get favoritedToast => 'Đã thêm vào Yêu thích';

  @override
  String get unfavoritedToast => 'Đã chuyển lại vào Lịch sử';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get favoriteSaving => 'Đang lưu…';

  @override
  String favoritedAt(String date) {
    return 'Đã lưu $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count mục · không bao giờ tự động xóa · tối đa $size';
  }

  @override
  String get favoritesEmptyTitle => 'Chưa có mục yêu thích';

  @override
  String get favoritesEmptyBody =>
      'Gắn sao cho một mục trong Lịch sử để lưu một bản ở đây. Mục yêu thích không bao giờ bị tự động xóa.';

  @override
  String get favoritesSearchHint => 'Tìm trong Yêu thích';

  @override
  String favoriteLargeTitle(String size) {
    return 'Lưu một bản sao $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Mục yêu thích giữ bản sao riêng, nên việc sửa hoặc xóa tệp gốc sẽ không ảnh hưởng đến nó. Bản sao này chiếm $size trên $device.';
  }

  @override
  String get saveCopy => 'Lưu bản sao';

  @override
  String clearKeepsFavorites(int count) {
    return '$count mục yêu thích của bạn vẫn được giữ lại.';
  }

  @override
  String get favoritesUsage => 'Yêu thích';

  @override
  String get favoritesUsageDesc =>
      'Mục yêu thích không bao giờ bị tự động xóa, bất kể cài đặt ở trên';

  @override
  String upToSize(String size) {
    return 'Tối đa $size';
  }

  @override
  String detailChars(int count) {
    return '$count ký tự';
  }

  @override
  String detailTruncated(int count) {
    return '… tổng cộng $count ký tự';
  }

  @override
  String detailMoreFiles(int count) {
    return 'Còn $count mục nữa';
  }

  @override
  String get detailReceiveFirst => 'Chọn để tải về trước';

  @override
  String detailTotalSize(String size) {
    return 'Tổng cộng $size';
  }

  @override
  String get quickPaste => 'Dán nhanh';

  @override
  String get quickPasteWindow => 'Cửa sổ dán nhanh';

  @override
  String get quickPasteWindowDesc =>
      'Nhấn phím tắt trong bất kỳ ứng dụng nào để mở lịch sử; chọn một mục là dán ngay';

  @override
  String get quickPasteShortcut => 'Phím tắt';

  @override
  String get quickPasteRecord => 'Bấm để thay đổi';

  @override
  String get quickPasteRecording => 'Nhấn phím tắt mới…';

  @override
  String get quickPasteUseDefault => 'Dùng mặc định';

  @override
  String get quickPasteNeedsModifier =>
      'Cần có ⌃, ⌥, ⇧ hoặc ⌘, hoặc dùng phím chức năng';

  @override
  String get quickPasteNeedsModifierPc =>
      'Cần có Ctrl, Alt, Shift hoặc phím Windows, hoặc dùng phím chức năng';

  @override
  String get quickPasteAfterPick => 'Sau khi chọn một mục';

  @override
  String get quickPastePasteIt => 'Dán luôn';

  @override
  String get quickPasteCopyIt => 'Chỉ sao chép';

  @override
  String get quickPasteIndexKey => 'Chọn một trong 9 mục đầu';

  @override
  String get quickPasteIndexKeyDesc =>
      'Trong cửa sổ dán nhanh, giữ phím này rồi nhấn 1–9';

  @override
  String get quickPasteAccessibility => 'Trợ năng';

  @override
  String get quickPasteAccessibilityDesc =>
      'Cần để tự động dán. Nếu không có, mục sẽ được sao chép và bạn tự nhấn ⌘V.';

  @override
  String get quickPasteAllowed => 'Đã cho phép';

  @override
  String get quickPasteAllow => 'Cho phép…';

  @override
  String get quickPasteNotRunning => 'Cửa sổ dán nhanh không chạy';

  @override
  String quickPasteInUse(String key) {
    return '$key đang được ứng dụng khác sử dụng. Hãy chọn phím tắt khác.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Không thể đặt $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Đặt trong cài đặt phím tắt của hệ thống';

  @override
  String get quickPasteWaylandDesc =>
      'Trên Wayland, hãy thêm phím tắt trong cài đặt bàn phím của môi trường desktop. Mục được chọn sẽ được sao chép; nhấn Ctrl+V để dán.';

  @override
  String get quickPasteAddShortcut => 'Thêm phím tắt hệ thống';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Đã thêm. Nhấn $key để thử.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Thêm một phím tắt tùy chỉnh trong cài đặt bàn phím của môi trường desktop để chạy: $command';
  }

  @override
  String get pickerSearch => 'Tìm kiếm';

  @override
  String get pickerPaste => 'Dán';

  @override
  String get pickerPlainText => 'Văn bản thuần';

  @override
  String get pickerCopyOnly => 'Chỉ sao chép';

  @override
  String get pickerUnfavoriteHint => 'Bỏ yêu thích (trả về Lịch sử)';

  @override
  String pickerPasteManually(String key) {
    return 'Mục được chọn sẽ được sao chép — nhấn $key để dán';
  }

  @override
  String get pickerGrantHint => 'Cho phép Trợ năng để dán trực tiếp';

  @override
  String pickerElevated(String key) {
    return 'Cửa sổ này chạy với quyền quản trị viên — nhấn $key để dán sau khi chọn';
  }

  @override
  String get pickerDownloading => 'Đang tải về — sẽ dán khi xong';

  @override
  String get imagePreviewTitle => 'Xem trước hình ảnh';

  @override
  String get closePreview => 'Đóng bản xem trước';

  @override
  String get previousImage => 'Ảnh trước';

  @override
  String get nextImage => 'Ảnh tiếp theo';

  @override
  String get previewHint => 'Cuộn hoặc chụm để thu phóng, kéo để di chuyển';

  @override
  String get fitWindow => 'Vừa cửa sổ';

  @override
  String get previewDeleted => 'Hình ảnh này đã bị xóa khỏi lịch sử';

  @override
  String get previewExpired => 'Hình ảnh này đã hết hạn và không thể xem trước';

  @override
  String get previewDownloading => 'Đang tải hình ảnh về…';

  @override
  String get previewDownloadFailed => 'Tải về không thành công. Hãy thử lại.';

  @override
  String get previewNotDownloaded => 'Hình ảnh này chưa có trên máy tính này';

  @override
  String get downloadAndPreview => 'Tải về và xem trước';

  @override
  String get previewUnavailable => 'Hiện không thể xem trước hình ảnh này';

  @override
  String get imageSemantic => 'Hình ảnh trong lịch sử';

  @override
  String get previewUnreadable =>
      'Không đọc được hình ảnh. Tệp có thể đã bị dọn dẹp hoặc bị hỏng.';

  @override
  String get devicesSubtitleEmpty =>
      'Sau khi ghép nối, các thiết bị sẽ dùng chung một bảng nhớ tạm';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired đã ghép nối, $online trực tuyến';
  }

  @override
  String get addDevice => 'Thêm thiết bị';

  @override
  String thisDeviceFootnote(String both) {
    return 'Khi ghép nối, $both sẽ hiển thị cùng hai dòng dấu vân tay bảo mật, mỗi dòng cho một thiết bị. Chỉ xác nhận khi chúng khớp đến từng ký tự.';
  }

  @override
  String get noDevicesTitle => 'Chưa có thiết bị nào được ghép nối';

  @override
  String get noDevicesBody =>
      'Mở PasteFerry trên máy tính còn lại và kết nối hai máy bằng mã ghép nối 6 ký tự. Nếu cùng một mạng, bạn cũng có thể mở Tìm lân cận trên cả hai máy rồi bấm vào máy kia.';

  @override
  String get pairedDevices => 'Thiết bị đã ghép nối';

  @override
  String get pairedFootnote =>
      'Trực tiếp: dữ liệu đi thẳng giữa hai thiết bị. Chuyển tiếp: khi mạng chặn đường trực tiếp, dữ liệu đi qua máy chủ của bạn và vẫn được mã hóa đầu cuối.';

  @override
  String get offline => 'Ngoại tuyến';

  @override
  String get direct => 'Trực tiếp';

  @override
  String get relay => 'Chuyển tiếp';

  @override
  String get online => 'Trực tuyến';

  @override
  String get moreActions => 'Thêm';

  @override
  String get copyFingerprint => 'Sao chép dấu vân tay';

  @override
  String get unpairEllipsis => 'Hủy ghép nối…';

  @override
  String get fingerprintCopied => 'Đã sao chép dấu vân tay';

  @override
  String unpairTitle(String name) {
    return 'Hủy ghép nối “$name”?';
  }

  @override
  String get unpairBody =>
      'Hai thiết bị sẽ ngừng đồng bộ. Để đồng bộ lại, bạn cần ghép nối và kiểm tra dấu vân tay lần nữa.';

  @override
  String get unpair => 'Hủy ghép nối';

  @override
  String get unpaired => 'Đã hủy ghép nối';

  @override
  String get enterAddressEllipsis => 'Nhập địa chỉ…';

  @override
  String setAddressTitle(String name) {
    return 'Địa chỉ của “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Dùng khi hai thiết bị ở khác mạng con, hoặc cả hai đều đã đổi địa chỉ. Nhập địa chỉ hiển thị trên “$name” trong Thêm thiết bị → Hiện mã.';
  }

  @override
  String get addressSaved => 'Đang tìm thiết bị ở địa chỉ đó';

  @override
  String get lanBlockedTitle => 'macOS đang chặn mạng cục bộ';

  @override
  String lanBlockedBody(String device) {
    return 'Bật PasteFerry Daemon trong Cài đặt hệ thống → Quyền riêng tư & Bảo mật → Mạng cục bộ. Cho đến lúc đó, $device không thể kết nối với các thiết bị trong mạng này.';
  }

  @override
  String get searchNearby => 'Tìm lân cận';

  @override
  String get nearbyTitle => 'Thiết bị lân cận';

  @override
  String get nearbySearching => 'Đang tìm thiết bị lân cận…';

  @override
  String get nearbyHint =>
      'Mở Tìm lân cận trên máy tính kia, máy đó sẽ hiện ở đây. Bấm vào để ghép nối.';

  @override
  String nearbyVisible(String device) {
    return 'Khi cửa sổ này đang mở, các thiết bị trong mạng này có thể thấy tên của $device.';
  }

  @override
  String get nearbyPaired => 'Đã ghép nối';

  @override
  String nearbyRequesting(String name) {
    return 'Đang liên hệ “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” không phản hồi. Hãy đảm bảo Tìm lân cận vẫn đang mở trên thiết bị đó.';
  }

  @override
  String get nearbyLanOffTitle => 'Đã tắt tìm thiết bị trong mạng cục bộ';

  @override
  String get nearbyLanOffBody =>
      'Bật “Tìm thiết bị trong mạng này” trong Cài đặt → Kết nối để thấy thiết bị lân cận, hoặc ghép nối bằng mã.';

  @override
  String get generateCode => 'Hiện mã';

  @override
  String get enterCode => 'Nhập mã';

  @override
  String get codeFailedTitle => 'Không thể tạo mã ghép nối';

  @override
  String get enterOnOther => 'Nhập mã này trên thiết bị kia';

  @override
  String get codeCopied => 'Đã sao chép mã';

  @override
  String get codeHint => 'Bấm để sao chép. Có hiệu lực trong 5 phút.';

  @override
  String afterEnterFootnote(String both) {
    return 'Sau khi nhập mã, $both sẽ hiển thị cùng hai dòng dấu vân tay bảo mật. Chỉ xác nhận khi chúng khớp nhau.';
  }

  @override
  String get codeInvalid => 'Mã ghép nối gồm 6 chữ cái hoặc chữ số';

  @override
  String get localAddress => 'Địa chỉ';

  @override
  String get addressHint =>
      'Khác mạng con? Hãy nhập cả địa chỉ này trên thiết bị kia.';

  @override
  String get addressCopied => 'Đã sao chép địa chỉ';

  @override
  String get differentSubnet => 'Khác mạng con?';

  @override
  String get peerAddress => 'Địa chỉ hiển thị dưới mã';

  @override
  String get pairNotFound =>
      'Không tìm thấy thiết bị đó. Nếu thiết bị ở khác mạng con, hãy nhập địa chỉ hiển thị dưới mã của nó.';

  @override
  String get pairNotFoundAddress =>
      'Không có phản hồi tại địa chỉ đó. Hãy kiểm tra địa chỉ và đảm bảo thiết bị kia vẫn đang hiện mã. Tường lửa trên thiết bị đó cũng có thể đang chặn kết nối.';

  @override
  String get codeWrong => 'Mã không đúng hoặc đã hết hạn';

  @override
  String get codeExpired =>
      'Mã này đã hết hạn. Hãy hiện mã mới trên thiết bị kia.';

  @override
  String get addressInvalid =>
      'Địa chỉ không hợp lệ. Hãy nhập dạng như 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Trước tiên, hãy bật tìm thiết bị trong mạng cục bộ hoặc đặt máy chủ trong Cài đặt → Kết nối.';

  @override
  String get enterCodeShown => 'Nhập mã hiển thị trên thiết bị kia';

  @override
  String get pairingDone => 'Đã ghép nối';

  @override
  String get pairingRejected => 'Đã từ chối ghép nối';

  @override
  String get verifyTitle => 'Kiểm tra dấu vân tay bảo mật';

  @override
  String pairingWith(String name) {
    return 'Đang ghép nối với “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'Hai dòng trên $both phải giống hệt nhau. Nếu chỉ cần một ký tự khác, có thể ai đó đang can thiệp vào kết nối, vì vậy hãy từ chối.';
  }

  @override
  String get rejectMismatch => 'Không khớp, từ chối';

  @override
  String get confirmMatch => 'Khớp, ghép nối';

  @override
  String get server => 'Máy chủ (tùy chọn)';

  @override
  String get signalingUrl => 'Máy chủ báo hiệu';

  @override
  String get signalingUrlDesc => 'Để trống để chỉ đồng bộ trong mạng cục bộ';

  @override
  String get signalingUrlPlaceholder => 'ws://địa-chỉ-máy-chủ:8787/signal';

  @override
  String get publicStun => 'Cải thiện kết nối trực tiếp';

  @override
  String get publicStunDesc =>
      'Máy chủ công cộng có thể thấy IP công khai của bạn';

  @override
  String get connectionStatus => 'Kết nối';

  @override
  String get disconnectedDesc => 'Hãy kiểm tra địa chỉ và tình trạng máy chủ';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get notConnected => 'Chưa kết nối';

  @override
  String get notSet => 'Chưa đặt';

  @override
  String get serverCleared => 'Đã xóa máy chủ. Chỉ đồng bộ trong mạng này.';

  @override
  String get localNetwork => 'Mạng cục bộ';

  @override
  String get lanDiscovery => 'Tìm thiết bị trong mạng này';

  @override
  String get lanDiscoveryDesc =>
      'Tìm ẩn danh; tên chỉ hiển thị khi đang Tìm lân cận';

  @override
  String get macLocalNetwork => 'Quyền truy cập mạng cục bộ';

  @override
  String get macLocalNetworkDesc =>
      'Cho phép PasteFerry Daemon trong Cài đặt hệ thống';

  @override
  String get allowLan => 'Tường lửa Windows';

  @override
  String get allowLanDesc =>
      'Cho phép các kết nối bị chặn; cần quyền quản trị viên';

  @override
  String get allow => 'Cho phép';

  @override
  String get allowLanDone =>
      'Đã cho phép. Các thiết bị khác giờ có thể kết nối với thiết bị này.';

  @override
  String get deviceName => 'Tên thiết bị';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get sync => 'Đồng bộ';

  @override
  String get autoSyncLimit => 'Giới hạn tự động đồng bộ';

  @override
  String get autoSyncLimitDesc => 'Nhận thủ công các mục lớn hơn từ Lịch sử';

  @override
  String get autoApply => 'Đưa mục nhận được vào bảng nhớ tạm';

  @override
  String get whatToSync => 'Nội dung đồng bộ';

  @override
  String get syncFiles => 'Tệp và thư mục';

  @override
  String get syncText => 'Văn bản thuần';

  @override
  String get syncRich => 'Văn bản có định dạng';

  @override
  String get syncImages => 'Hình ảnh và ảnh chụp màn hình';

  @override
  String get storage => 'Lưu trữ';

  @override
  String get storageFootnote =>
      'Lịch sử và tệp trong bộ nhớ đệm khi hết hạn sẽ tự động bị xóa.';

  @override
  String get keepHistory => 'Giữ lịch sử trong';

  @override
  String get keepCache => 'Giữ tệp bộ nhớ đệm trong';

  @override
  String get keepCacheDesc => 'Không lâu hơn thời gian giữ lịch sử';

  @override
  String get cacheUsage => 'Dung lượng bộ nhớ đệm';

  @override
  String get backgroundSync => 'Đồng bộ nền';

  @override
  String get backgroundService => 'Dịch vụ nền';

  @override
  String get backgroundServiceDesc =>
      'Khởi động khi đăng nhập; vẫn đồng bộ khi đóng cửa sổ';

  @override
  String get restart => 'Khởi động lại';

  @override
  String get restarted => 'Đã khởi động lại dịch vụ nền';

  @override
  String get disableEllipsis => 'Tắt…';

  @override
  String get about => 'Giới thiệu';

  @override
  String get aboutDesc => 'Mã nguồn mở theo giấy phép AGPL-3.0';

  @override
  String get homepage => 'Trang web';

  @override
  String get feedback => 'Báo cáo sự cố';

  @override
  String get disableTitle => 'Tắt đồng bộ nền?';

  @override
  String disableBody(String device) {
    return 'PasteFerry trên $device sẽ ngừng đồng bộ và không khởi động khi đăng nhập. Lịch sử và các thiết bị đã ghép nối vẫn được giữ.';
  }

  @override
  String get disable => 'Tắt';

  @override
  String get disabled => 'Đã tắt đồng bộ nền';

  @override
  String get urlMustBeWs => 'Địa chỉ phải bắt đầu bằng ws:// hoặc wss://';

  @override
  String get serverUpdated => 'Đã cập nhật máy chủ. Đang kết nối lại…';

  @override
  String get deviceNameUpdated => 'Đã cập nhật tên thiết bị';

  @override
  String get diagIntro =>
      'Báo cáo này gồm phiên bản ứng dụng, hệ thống, cài đặt, thiết bị và nhật ký gần đây. Tên thiết bị, địa chỉ máy chủ, địa chỉ IP công khai, thư mục người dùng và tên tệp đã được thay thế, và nội dung bạn sao chép không bao giờ được ghi vào nhật ký. Báo cáo sự cố trên GitHub là công khai, vì vậy hãy đọc kỹ trước khi đăng.';

  @override
  String get diagVerboseTitle => 'Nhật ký chi tiết';

  @override
  String get diagVerboseDesc =>
      'Dành cho sự cố kết nối: bật lên, làm sự cố xảy ra lần nữa, rồi quay lại đây để lấy báo cáo. Tự động tắt sau 30 phút.';

  @override
  String get diagVerboseOn => 'Bật trong 30 phút';

  @override
  String diagVerboseUntil(String time) {
    return 'Bật đến $time';
  }

  @override
  String get diagVerboseOff => 'Tắt';

  @override
  String get diagRefresh => 'Tạo lại';

  @override
  String get diagSave => 'Lưu thành tệp';

  @override
  String diagSaved(String name) {
    return 'Đã lưu vào thư mục Tải về: $name';
  }

  @override
  String get diagCopy => 'Sao chép báo cáo';

  @override
  String get diagCopied => 'Đã sao chép báo cáo';

  @override
  String get diagNewIssue => 'Báo sự cố trên GitHub';

  @override
  String get diagIssueHint =>
      'Đã sao chép báo cáo. Hãy dán vào ô “Diagnostics report” của báo cáo sự cố.';

  @override
  String diagFailed(String detail) {
    return 'Không thể tạo báo cáo: $detail';
  }

  @override
  String get svcExtractTitle => 'Hãy cài đặt hoặc giải nén PasteFerry trước';

  @override
  String get svcExtractBody =>
      'PasteFerry đang chạy trực tiếp từ tệp zip, và thư mục tạm của nó sẽ biến mất khi bạn đóng ứng dụng. Hãy chạy trình cài đặt, hoặc giải nén toàn bộ thư mục rồi mở từ đó, để bật đồng bộ nền.';

  @override
  String get svcMoveTitle => 'Hãy chuyển PasteFerry vào Ứng dụng trước';

  @override
  String get svcMoveBody =>
      'PasteFerry đang chạy trực tiếp từ ảnh đĩa. Hãy kéo ứng dụng vào thư mục Ứng dụng, đẩy ảnh đĩa ra, rồi mở từ Ứng dụng để bật đồng bộ nền.';

  @override
  String get svcStartTitle => 'Bắt đầu dùng PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry chạy một tiến trình nền nhỏ để đồng bộ bảng nhớ tạm. Tiến trình vẫn chạy khi đóng cửa sổ. Khởi động khi đăng nhập là một cài đặt riêng và mặc định tắt với bản cài mới.';

  @override
  String get svcEnable => 'Bật đồng bộ nền';

  @override
  String get svcStaleTitle => 'Bật lại đồng bộ nền';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry đã được chuyển sang vị trí khác, nhưng mục khởi động khi đăng nhập vẫn trỏ đến vị trí cũ. Hãy bật lại để tiến trình nền dùng bản này. Lịch sử và các thiết bị đã ghép nối vẫn được giữ.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry đã được chuyển sang vị trí khác, hoặc đã được cài bằng tập lệnh cũ. Hãy bật lại để tiến trình nền dùng ứng dụng này. Lịch sử và các thiết bị đã ghép nối vẫn được giữ.';

  @override
  String get svcReenable => 'Bật lại';

  @override
  String get svcStoppedTitle => 'Dịch vụ nền không chạy';

  @override
  String get svcStoppedBody =>
      'Dịch vụ nền đã dừng. Hãy khởi động bằng nút bên dưới; việc khởi động khi đăng nhập được đặt riêng trong Cài đặt.';

  @override
  String get svcDevBodyWin =>
      'Đây là bản dựng phát triển, không có pasteferryd.exe đi kèm. Hãy chạy scripts\\build-windows.ps1 trong thư mục mã nguồn để dựng phiên bản đầy đủ.';

  @override
  String get svcDevBodyLinux =>
      'Đây là bản dựng phát triển, không có pasteferryd đi kèm. Hãy chạy ./scripts/package-linux.sh trong thư mục mã nguồn để dựng phiên bản đầy đủ.';

  @override
  String get svcDevBodyMac =>
      'Đây là bản dựng phát triển, không có dịch vụ nền. Hãy chạy ./scripts/install-macos.sh trong thư mục mã nguồn để cài đặt.';

  @override
  String svcLogPath(String path) {
    return 'Nhật ký: $path';
  }

  @override
  String get svcCanDisable =>
      'Bạn có thể tắt đồng bộ nền bất cứ lúc nào trong Cài đặt.';

  @override
  String get officialService => 'Dịch vụ';

  @override
  String get useOfficialService => 'Dùng Dịch vụ';

  @override
  String get officialServiceDesc =>
      'Đồng bộ qua các mạng khác nhau, ưu tiên kết nối trực tiếp';

  @override
  String get officialPrivacy =>
      'Chỉ kết nối với Dịch vụ khi được bật và chỉ ghi lại thông tin kết nối cần thiết. Kết nối trực tiếp được thử trước; chỉ yêu cầu chuyển tiếp khi kết nối trực tiếp không thành công. Nội dung, tên thật của thiết bị và mã định danh gốc của hệ thống không được tải lên.';

  @override
  String get officialEnableTitle => 'Bật Dịch vụ?';

  @override
  String get officialSwitchConfirm =>
      'Thao tác này sẽ chuyển khỏi máy chủ tùy chỉnh của bạn. Địa chỉ đã lưu của máy chủ đó vẫn được giữ.';

  @override
  String get customServer => 'Máy chủ tùy chỉnh';

  @override
  String get saveAndConnect => 'Lưu và kết nối';

  @override
  String get officialLoading => 'Đang kiểm tra hạn mức…';

  @override
  String get officialFetchFailed =>
      'Hiện không lấy được hạn mức. Sẽ tự động thử lại.';

  @override
  String get officialUnavailable =>
      'Không có thông tin sử dụng; dữ liệu hiện có có thể đã cũ';

  @override
  String get officialQuotaTitle => 'Đã dùng hết hạn mức chuyển tiếp trong ngày';

  @override
  String get officialQuotaBody =>
      'Chuyển tiếp của Dịch vụ tạm dừng cho đến khi hạn mức được đặt lại lúc nửa đêm giờ Bắc Kinh. Kết nối qua mạng cục bộ và kết nối Internet trực tiếp vẫn dùng được. Bạn có thể thử lại các lần truyền không thành công sau.';

  @override
  String get officialPeerQuota =>
      'Thiết bị bên kia đã hết hạn mức chuyển tiếp. Kết nối trực tiếp vẫn dùng được.';

  @override
  String get officialPaused =>
      'Chuyển tiếp của Dịch vụ không khả dụng. Kết nối trực tiếp vẫn dùng được.';

  @override
  String get officialViewUsage => 'Xem mức sử dụng';

  @override
  String get officialAcknowledge => 'Đã hiểu';

  @override
  String get officialToday => 'Hạn mức chuyển tiếp hôm nay';

  @override
  String get officialUsed => 'Đã dùng';

  @override
  String get officialRemaining => 'Còn lại';

  @override
  String get officialDailyLimit => 'Hạn mức hằng ngày';

  @override
  String get officialUpload => 'Tải lên';

  @override
  String get officialDownload => 'Tải xuống';

  @override
  String get officialReset => 'Thời điểm đặt lại (giờ Bắc Kinh)';

  @override
  String get officialUpdated => 'Cập nhật lần cuối';

  @override
  String get officialRoutes => 'Cách thiết bị kết nối';

  @override
  String get officialRoutesFootnote =>
      'Kết nối trực tiếp không đi qua chuyển tiếp của Dịch vụ và không tính vào hạn mức.';

  @override
  String get officialDeviceID => 'ID thiết bị';

  @override
  String get officialWarning =>
      'Đã dùng 90% hạn mức chuyển tiếp trong ngày. Kết nối trực tiếp không tính vào hạn mức này.';

  @override
  String get updateCheck => 'Kiểm tra cập nhật';

  @override
  String get updateCheckEllipsis => 'Kiểm tra cập nhật…';

  @override
  String get updateAuto => 'Tự động kiểm tra cập nhật';

  @override
  String get updateChecking => 'Đang kiểm tra cập nhật…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version là phiên bản mới nhất.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'Đã có PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Bạn đang dùng $current. Dung lượng tải về: $size.';
  }

  @override
  String get updateNew => 'Mới';

  @override
  String get updateFixed => 'Đã sửa';

  @override
  String get updateSkip => 'Bỏ qua phiên bản này';

  @override
  String get updateLater => 'Để sau';

  @override
  String get updateInstall => 'Tải về và cài đặt';

  @override
  String updateDownloading(String done, String total) {
    return 'Đang tải về $done/$total';
  }

  @override
  String get updateVerifying => 'Đang kiểm tra tệp tải về…';

  @override
  String get updateInstalling => 'Đang cài đặt. PasteFerry sẽ tự mở lại.';

  @override
  String get updateInstallingPassword =>
      'Đang cài đặt. Hệ thống sẽ hỏi mật khẩu của bạn vì /opt cần quyền quản trị viên; sau đó PasteFerry sẽ tự mở lại.';

  @override
  String get updateCheckFailed =>
      'Không kết nối được GitHub hoặc Gitee. Hãy thử lại sau.';

  @override
  String get updateDownloadFailed =>
      'Chưa tải về xong. Hãy thử lại, hoặc tải phiên bản mới từ trang web.';

  @override
  String updateInstallFailed(String error) {
    return 'Không thể bắt đầu cài đặt: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Bản dựng này không thể kiểm tra cập nhật.';

  @override
  String get updateBlockedDev =>
      'Đây là bản dựng phát triển nên không thể tự cập nhật.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry đang chạy từ ảnh đĩa. Hãy kéo ứng dụng vào thư mục Ứng dụng và mở từ đó để tự động cập nhật.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry không thể ghi vào thư mục cài đặt của mình. Hãy tải phiên bản mới từ trang web.';

  @override
  String get updateBlockedUnsupported =>
      'Không có bản cập nhật tự động cho máy tính này. Hãy tải phiên bản mới từ trang web.';

  @override
  String get updateOpenDownload => 'Mở trang tải về';

  @override
  String updateSidebar(String version) {
    return 'Đã có phiên bản $version';
  }

  @override
  String updatedTo(String version) {
    return 'Đã cập nhật lên $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'Cập nhật chưa hoàn tất. Bạn vẫn đang dùng $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'Cập nhật chưa hoàn tất. Bạn vẫn đang dùng $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Giao diện $uiVersion · Dịch vụ $serviceVersion · Bản dựng $build';
  }

  @override
  String get notReceived => 'Chưa nhận — hãy nhận trước khi dán';

  @override
  String get receivedPreserved =>
      'Đã nhận; dùng Chép vào bảng nhớ tạm khi sẵn sàng';

  @override
  String get clipboardWriteFailed =>
      'Đã nhận nhưng không thể cập nhật bảng nhớ tạm';

  @override
  String get receivingStatus => 'Đang nhận…';

  @override
  String get largeFileNotifications => 'Nhắc nhở tệp lớn';

  @override
  String get notificationsAllowed =>
      'Đã bật thông báo. Tiến trình hiển thị trong Lịch sử.';

  @override
  String get notificationsNotRequested =>
      'Bật thông báo để được nhắc khi có tệp lớn đang chờ. Bạn luôn có thể nhận chúng từ Lịch sử.';

  @override
  String get notificationsDenied =>
      'Thông báo đang bị chặn trong cài đặt hệ thống. Hãy nhận các mục đang chờ từ Lịch sử.';

  @override
  String get notificationsUnknown =>
      'Môi trường desktop của bạn quản lý việc hiển thị thông báo và chế độ Không làm phiền. Nếu không thấy nhắc nhở, hãy nhận các mục từ Lịch sử.';

  @override
  String get notificationsUnavailable =>
      'Thông báo hệ thống không khả dụng. Hãy nhận tệp lớn từ Lịch sử.';

  @override
  String get enableNotifications => 'Bật nhắc nhở';

  @override
  String get notificationSettings => 'Cài đặt thông báo';

  @override
  String get notifyPendingTitle => 'Nhận để dán';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nHãy nhận mục này trước khi dán. Bạn cũng có thể nhận từ Lịch sử.';
  }

  @override
  String get notifyReceivingTitle => 'Đang nhận…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nXem tiến trình trong Lịch sử.';
  }

  @override
  String get notifyReadyTitle => 'Sẵn sàng để dán';

  @override
  String notifyReadyBody(String name) {
    return '$name\nĐã nhận và chép vào bảng nhớ tạm.';
  }

  @override
  String get notifyReceivedTitle => 'Đã nhận';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nBảng nhớ tạm của bạn được giữ nguyên. Dùng Chép vào bảng nhớ tạm khi sẵn sàng; thao tác này cũng có trong Lịch sử.';
  }

  @override
  String get notifyFailedTitle => 'Không thể nhận';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nHãy thử lại từ thông báo này hoặc từ Lịch sử.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Đã nhận; chưa cập nhật bảng nhớ tạm';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nDùng Chép vào bảng nhớ tạm để thử lại, tại đây hoặc trong Lịch sử.';
  }

  @override
  String get reconnect => 'Kết nối lại';

  @override
  String get reconnecting => 'Đang kết nối…';

  @override
  String get reconnectDirect => 'Đã kết nối trực tiếp';

  @override
  String get reconnectRelay =>
      'Không kết nối trực tiếp được, vẫn dùng chuyển tiếp';

  @override
  String reconnectOffline(String name) {
    return '“$name” đang ngoại tuyến. Hãy đảm bảo PasteFerry đang mở trên thiết bị đó.';
  }

  @override
  String get reconnectPending => 'Vẫn đang kết nối, hãy xem lại sau giây lát';

  @override
  String get renameAction => 'Đổi tên';

  @override
  String get renameFavoriteTitle => 'Đổi tên mục yêu thích';

  @override
  String get renameFavoriteHint =>
      'Tên này hiển thị trong Yêu thích và Dán nhanh, và có thể tìm kiếm được. Để trống để hiển thị lại nội dung.';

  @override
  String get renamedToast => 'Đã đổi tên';

  @override
  String get aliasClearedToast => 'Đã hiển thị lại nội dung';

  @override
  String get navSend => 'Gửi tệp';

  @override
  String get sendSubtitle => 'Kéo tệp vào một thiết bị để gửi trực tiếp';

  @override
  String get sendNoDevicesTitle => 'Chưa có thiết bị nào được ghép nối';

  @override
  String get sendNoDevicesBody =>
      'Hãy ghép nối với một máy tính khác trước, rồi gửi tệp cho máy đó tại đây.';

  @override
  String get sendDropHint => 'Thả vào một thiết bị để gửi';

  @override
  String sendReleaseTo(String name) {
    return 'Thả ra để gửi tới $name';
  }

  @override
  String get sendLan => 'Mạng cục bộ';

  @override
  String sendRelayLeft(String left) {
    return 'Chuyển tiếp · hôm nay còn $left';
  }

  @override
  String get sendNeedsUpdate => 'Cần cập nhật';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name có thể nhận tệp sau khi cập nhật lên PasteFerry 2.5 trở lên.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Đang kết nối với $name. Bạn có thể gửi khi đã kết nối.';
  }

  @override
  String get sendNotReceiving => 'Không nhận tệp';

  @override
  String get sendDelivered => 'Đã gửi tới';

  @override
  String sendToTitle(String name) {
    return 'Gửi tới $name';
  }

  @override
  String get sendDropHere => 'Kéo tệp hoặc thư mục vào đây';

  @override
  String get sendDropStarts => 'Việc gửi bắt đầu ngay khi bạn thả';

  @override
  String get sendChooseFiles => 'Chọn tệp…';

  @override
  String get sendChooseFolder => 'Chọn thư mục…';

  @override
  String get sendDropMore => 'Thả thêm tệp để gửi tiếp theo';

  @override
  String sendSavedWhere(String name) {
    return 'Tệp được lưu ở vị trí do $name chọn — mặc định là thư mục Tải về.';
  }

  @override
  String get sendCloseKeeps => 'Đóng cửa sổ này không làm dừng việc gửi';

  @override
  String get sendRemoveQueued => 'Xóa';

  @override
  String get sendCannotDrop =>
      'Không thể gửi mục này bằng cách kéo thả. Hãy lưu thành tệp trước, hoặc dùng Chọn tệp….';

  @override
  String sendErrOffline(String name) {
    return '$name đang ngoại tuyến.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name không nhận tệp.';
  }

  @override
  String get sendErrMissing => 'Một số tệp không còn tồn tại.';

  @override
  String get relayConfirmTitle => 'Gửi qua chuyển tiếp của Dịch vụ?';

  @override
  String relayConfirmBody(String name, String left) {
    return 'Hiện $name không có kết nối trực tiếp với máy tính này, nên tệp sẽ đi qua chuyển tiếp của Dịch vụ với tốc độ khoảng 0,25 MB/s. Hạn mức chuyển tiếp hôm nay còn $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Các tệp này ($size) vượt quá hạn mức còn lại. Việc gửi sẽ tạm dừng khi hết hạn mức và tiếp tục khi hai máy tính kết nối trực tiếp hoặc khi hạn mức được đặt lại vào ngày mai.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Lần gửi này dùng khoảng $size hạn mức hôm nay.';
  }

  @override
  String get relayExhausted =>
      'Đã dùng hết hạn mức chuyển tiếp hôm nay. Hạn mức được đặt lại lúc nửa đêm giờ Bắc Kinh. Hai máy tính kết nối trực tiếp thì không bị giới hạn.';

  @override
  String get relayDontAskToday => 'Hôm nay không hỏi lại cho thiết bị này';

  @override
  String get relaySendAnyway => 'Vẫn gửi';

  @override
  String get relayOwnServer =>
      'Chuyển tiếp — tốc độ phụ thuộc vào máy chủ của bạn';

  @override
  String get transfersReceived => 'Đã nhận';

  @override
  String get transfersSent => 'Đã gửi';

  @override
  String get transfersClearAll => 'Xóa tất cả';

  @override
  String get transfersClearTitle => 'Xóa danh sách này?';

  @override
  String get transfersClearBody =>
      'Chỉ danh sách bị xóa. Các tệp vẫn ở nguyên chỗ.';

  @override
  String get transfersEmptyReceived =>
      'Tệp từ các thiết bị khác gửi cho bạn sẽ hiện ở đây';

  @override
  String get transfersEmptySent => 'Tệp bạn gửi đi sẽ hiện ở đây';

  @override
  String transferFrom(String name) {
    return 'Từ $name';
  }

  @override
  String transferTo(String name) {
    return 'Tới $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name và $others mục khác';
  }

  @override
  String transferFileCount(int count) {
    return '$count tệp';
  }

  @override
  String get transferQueued => 'Đang chờ';

  @override
  String transferScanning(String count) {
    return 'Đang đếm… đã tìm thấy $count tệp';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Đang chờ $name…';
  }

  @override
  String get transferSending => 'Đang gửi';

  @override
  String get transferReceiving => 'Đang nhận';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Hiện tại: $file ($index/$total)';
  }

  @override
  String transferLeft(String time) {
    return 'Còn $time';
  }

  @override
  String etaSeconds(int n) {
    return '$n giây';
  }

  @override
  String etaMinutes(int n) {
    return '$n phút';
  }

  @override
  String etaHours(int h, int m) {
    return '$h giờ $m phút';
  }

  @override
  String get transferPaused =>
      'Đã tạm dừng: đã dùng hết hạn mức chuyển tiếp hôm nay';

  @override
  String get transferInterrupted =>
      'Bị gián đoạn — sẽ tiếp tục khi kết nối lại';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Bị gián đoạn — đang chờ $name tiếp tục';
  }

  @override
  String get transferCancelled => 'Đã hủy';

  @override
  String transferPeerCancelled(String name) {
    return '$name đã hủy';
  }

  @override
  String get transferExpired => 'Đã hết hạn';

  @override
  String get transferMissing => 'Đã bị di chuyển hoặc xóa';

  @override
  String transferNotSent(String reason) {
    return 'Chưa gửi: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Chưa nhận: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name không đủ dung lượng ổ đĩa (thiếu $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'không đủ dung lượng ổ đĩa (thiếu $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'vị trí lưu của $name không khả dụng';
  }

  @override
  String get reasonDestUnavailable =>
      'vị trí lưu không khả dụng — hãy kiểm tra trong Cài đặt';

  @override
  String get reasonFileTooLarge =>
      'vị trí lưu nằm trên ổ FAT32, không chứa được tệp lớn hơn 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name không nhận tệp';
  }

  @override
  String get reasonSourceChanged => 'một tệp đã bị thay đổi trong lúc đang gửi';

  @override
  String get reasonSourceMissing => 'một tệp không còn tồn tại';

  @override
  String get reasonReadError => 'không đọc được một tệp';

  @override
  String get reasonWriteFailed => 'không thể ghi tệp';

  @override
  String get reasonHashMismatch => 'một tệp đã bị hỏng trong khi truyền';

  @override
  String reasonUnsupported(String name) {
    return '$name cần cập nhật để nhận tệp';
  }

  @override
  String get reasonOther => 'đã xảy ra lỗi';

  @override
  String get revealInFinder => 'Hiển thị trong Finder';

  @override
  String get revealInFolder => 'Hiển thị trong thư mục';

  @override
  String get revealOpenFolder => 'Mở thư mục';

  @override
  String get transferResend => 'Gửi lại';

  @override
  String get transferRemove => 'Xóa khỏi danh sách';

  @override
  String get transferCopyPath => 'Sao chép đường dẫn';

  @override
  String get transferPathCopied => 'Đã sao chép đường dẫn';

  @override
  String sendingTo(String name, String percent) {
    return 'Đang gửi tới $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Đang nhận từ $name · $percent';
  }

  @override
  String get receiveFiles => 'Nhận tệp từ thiết bị khác';

  @override
  String get saveTo => 'Lưu vào';

  @override
  String get saveToChange => 'Thay đổi…';

  @override
  String get saveToDefault => 'Tải về (mặc định)';

  @override
  String get saveToUseDefault => 'Dùng Tải về';

  @override
  String get receiveNotify => 'Thông báo khi có tệp đến';

  @override
  String receiveFootnote(String device) {
    return 'Chỉ các thiết bị đã ghép nối mới có thể gửi tệp tới $device. Trong khi đang truyền tệp, $device sẽ không tự chuyển sang chế độ ngủ.';
  }

  @override
  String get saveDirNotFound => 'Thư mục này không tồn tại.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry không thể lưu tệp vào thư mục này.';

  @override
  String get saveDirPermission =>
      'PasteFerry chưa được phép dùng thư mục này. Hãy cho phép trong Cài đặt hệ thống → Quyền riêng tư & Bảo mật → Tệp và thư mục.';

  @override
  String transferRenamed(int count) {
    return '$count tên tệp chứa ký tự Windows không cho phép; các ký tự đó đã được thay bằng ký tự toàn độ tương tự';
  }

  @override
  String get sendRingLan => 'Cùng mạng';

  @override
  String get sendRingOther => 'Mạng khác';

  @override
  String sendOfflineList(String names) {
    return 'Ngoại tuyến: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Danh sách truyền';

  @override
  String get sendLayoutSide => 'Bên cạnh radar';

  @override
  String get sendLayoutBelow => 'Bên dưới radar';

  @override
  String get general => 'Chung';

  @override
  String get launchAtLogin => 'Khởi động khi đăng nhập';

  @override
  String get launchAtLoginDesc =>
      'Khởi động ở chế độ nền khi bạn đăng nhập. Thay đổi cài đặt này không làm dừng phiên hiện tại.';

  @override
  String get realtimeSync => 'Đồng bộ bảng nhớ tạm theo thời gian thực';

  @override
  String get realtimeSyncDesc =>
      'Tự động chia sẻ nội dung mới sao chép với các thiết bị đã ghép nối. Khi tắt, lịch sử trên máy này và Gửi tệp vẫn dùng được.';

  @override
  String get syncBacklog => 'Bù lại sau khi kết nối lại';

  @override
  String get syncBacklogDesc =>
      'Mặc định tắt: các nội dung sao chép bị lỡ sẽ được bỏ qua. Khi bật, tối đa 20 nội dung sao chép trong 24 giờ qua sẽ được đưa vào lịch sử mà không thay thế bảng nhớ tạm.';

  @override
  String get peerRealtimeSync => 'Đồng bộ với máy tính này';

  @override
  String get syncPaused => 'Đã tạm dừng đồng bộ bảng nhớ tạm';

  @override
  String get quitApp => 'Thoát PasteFerry';

  @override
  String get quitAppDesc =>
      'Dừng mọi tiến trình của PasteFerry. Tùy chọn khởi động khi đăng nhập vẫn được giữ.';

  @override
  String get quitTransfersWarning =>
      'Vẫn còn tệp đang được truyền. Thoát và làm gián đoạn các lần truyền này?';

  @override
  String get backgroundRunningTitle => 'PasteFerry sẽ tiếp tục chạy';

  @override
  String get backgroundRunningBody =>
      'Khi đóng cửa sổ, đồng bộ và dán nhanh vẫn tiếp tục chạy. Để dừng hẳn, hãy chọn Thoát PasteFerry trong Cài đặt hoặc trong menu ứng dụng.';

  @override
  String get displayAs => 'Hiển thị là';

  @override
  String get editName => 'Đổi tên';

  @override
  String get nameHint => 'Tên mà các liên hệ của bạn nhìn thấy';

  @override
  String get nameDefaultHint => 'Để trống để dùng tên tài khoản của bạn.';

  @override
  String get avatarTitle => 'Ảnh đại diện';

  @override
  String get avatarChoose => 'Chọn ảnh…';

  @override
  String get avatarPaste => 'Dán ảnh';

  @override
  String get avatarReset => 'Dùng ảnh mặc định';

  @override
  String get avatarZoom => 'Thu phóng';

  @override
  String get avatarDragHint => 'Kéo để di chuyển ảnh.';

  @override
  String get avatarNoImage => 'Không có ảnh nào trong bảng nhớ tạm.';

  @override
  String get avatarBad =>
      'Không dùng được ảnh này. Hãy chọn ảnh PNG, JPEG hoặc GIF.';

  @override
  String get done => 'Xong';

  @override
  String get friendsTitle => 'Liên hệ';

  @override
  String get addFriend => 'Thêm liên hệ';

  @override
  String get friendsEmpty => 'Chưa có liên hệ nào';

  @override
  String get friendsEmptyBody =>
      'Thêm người cũng dùng PasteFerry để gửi tệp cho nhau mà không cần ghép nối. Liên hệ chỉ có thể gửi tệp; họ không bao giờ thấy bảng nhớ tạm của bạn.';

  @override
  String get friendSendAction => 'Gửi…';

  @override
  String get friendHistory => 'Lượt truyền';

  @override
  String friendHistoryTitle(String name) {
    return 'Lượt truyền với $name';
  }

  @override
  String get friendHistoryEmpty => 'Chưa có lượt truyền nào.';

  @override
  String get friendAutoAccept => 'Tự động chấp nhận tệp';

  @override
  String get friendRemove => 'Xóa liên hệ';

  @override
  String friendRemoveTitle(String name) {
    return 'Xóa $name?';
  }

  @override
  String get friendRemoveBody =>
      'Hai bạn sẽ bị xóa khỏi danh sách liên hệ của nhau và không thể gửi tệp cho nhau nữa. Các lượt truyền trước đây vẫn còn trên máy tính này.';

  @override
  String friendLastActivity(String time) {
    return 'Lần truyền cuối $time';
  }

  @override
  String get friendNoActivity => 'Chưa có lượt truyền nào';

  @override
  String get friendCodeShare =>
      'Gửi mã này cho liên hệ của bạn. Khi họ nhập mã vào PasteFerry, hai bạn sẽ được thêm vào danh sách liên hệ của nhau.';

  @override
  String friendCodeExpires(String time) {
    return 'Hết hạn sau $time';
  }

  @override
  String get friendCodeOr => 'hoặc';

  @override
  String get friendCodeEnter => 'Nhập mã liên hệ của họ';

  @override
  String get friendCodeAdd => 'Thêm';

  @override
  String get friendCodeWaiting => 'Đang chờ họ nhập mã…';

  @override
  String friendConfirmBody(String name) {
    return 'Thêm $name vào danh sách liên hệ?';
  }

  @override
  String get friendSafetyCode => 'Kiểm tra mã an toàn (tùy chọn)';

  @override
  String get friendSafetyHint =>
      'Khi ở cạnh nhau, hãy so sánh hai dòng này. Nếu chúng khớp trên cả hai máy tính thì không ai can thiệp.';

  @override
  String get friendWaitingPeer => 'Đang chờ họ thêm bạn…';

  @override
  String friendAdded(String name) {
    return 'Đã thêm $name vào danh sách liên hệ';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name đã hủy';
  }

  @override
  String get friendErrFriendCode =>
      'Đây là mã liên hệ. Hãy nhập mã này trong Thêm liên hệ ở trang Gửi tệp.';

  @override
  String get friendErrDeviceCode =>
      'Đây là mã ghép nối. Hãy nhập mã này trong Thiết bị → Thêm thiết bị.';

  @override
  String get friendErrOutdated => 'Họ cần PasteFerry 2.6.0 trở lên.';

  @override
  String get friendErrAlreadyPaired =>
      'Máy tính đó đã là một trong các thiết bị của bạn.';

  @override
  String get friendErrNoChannel =>
      'Hai bạn không ở cùng một mạng. Hãy bật Dịch vụ trên cả hai máy tính để thêm nhau.';

  @override
  String get openService => 'Bật Dịch vụ…';

  @override
  String get noteLabel => 'Ghi chú (tùy chọn)';

  @override
  String get noteHintEmpty => 'Hãy chọn tệp trước';

  @override
  String get noteHint => 'Ví dụ: vui lòng ký trang 3';

  @override
  String noteLine(String note) {
    return 'Ghi chú: $note';
  }

  @override
  String get sendAction => 'Gửi';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count mục · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Thả tệp hoặc ảnh vào đây, hoặc dán ($key)';
  }

  @override
  String get sendDropMorePaste => 'Thả hoặc dán thêm';

  @override
  String get sendPasteNothing =>
      'Không có gì để dán. Hãy sao chép tệp hoặc ảnh trước.';

  @override
  String get sendRemoveItem => 'Xóa';

  @override
  String sendFriendSaved(String name) {
    return '$name sẽ chấp nhận từng lượt gửi trước khi tệp được gửi đi.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Đang chờ $name chấp nhận…';
  }

  @override
  String get transferAskingIn => 'Đang chờ bạn chấp nhận';

  @override
  String reasonDeclined(String name) {
    return '$name đã từ chối';
  }

  @override
  String reasonTimeout(String name) {
    return '$name không phản hồi';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name không nhận tệp';
  }

  @override
  String reasonRateLimited(String name) {
    return 'Hiện $name không nhận tệp của bạn';
  }

  @override
  String get reasonYouDeclined => 'Đã từ chối';

  @override
  String get reasonYouIgnored => 'Đã bỏ qua';

  @override
  String get sendAgain => 'Gửi lại';

  @override
  String incomingTitle(String name) {
    return '$name muốn gửi tệp cho bạn';
  }

  @override
  String get incomingAlways => 'Luôn chấp nhận tệp từ liên hệ này';

  @override
  String get incomingDecline => 'Từ chối';

  @override
  String get incomingAccept => 'Chấp nhận';

  @override
  String incomingCountdown(String seconds) {
    return 'Tự động từ chối sau $seconds giây';
  }

  @override
  String get incomingStranger => 'Lân cận';

  @override
  String get friendsStrip => 'Liên hệ';

  @override
  String get strangersStrip => 'Lân cận đang bật Mọi người';

  @override
  String get strangerNearby => 'Lân cận';

  @override
  String get friendNeedService => 'Hãy bật Dịch vụ';

  @override
  String get friendCantReach => 'Không kết nối được';

  @override
  String reachSelfNoService(String name) {
    return 'Bạn và $name không ở cùng một mạng. Hãy bật Dịch vụ để gửi tệp; nếu không thể kết nối trực tiếp, tệp sẽ đi qua chuyển tiếp của Dịch vụ.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name chưa bật Dịch vụ, nên bạn chỉ có thể gửi tệp khi ở cùng mạng. Hãy nhờ họ bật Dịch vụ trong PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Hai bạn không dùng cùng một máy chủ. Hãy bật Dịch vụ trên cả hai máy tính, hoặc dùng cùng một máy chủ, để gửi tệp.';

  @override
  String get receiveFromLabel => 'Cho phép những người này gửi tệp cho tôi:';

  @override
  String get receiveFromOff => 'Không ai';

  @override
  String get receiveFromFriends => 'Chỉ liên hệ';

  @override
  String get receiveFromEveryone => 'Mọi người';

  @override
  String everyoneLeft(String minutes) {
    return 'Mọi người · còn $minutes phút';
  }

  @override
  String get receiveFromOffDesc =>
      'Chỉ các máy tính đã ghép nối của bạn mới có thể gửi tệp cho bạn.';

  @override
  String get receiveFromFriendsDesc =>
      'Liên hệ của bạn có thể gửi tệp cho bạn. Bạn chấp nhận từng lượt gửi.';

  @override
  String get receiveFromEveryoneDesc =>
      'Bất kỳ ai trong cùng mạng đều có thể gửi tệp cho bạn trong 10 phút. Bạn chấp nhận từng lượt gửi.';

  @override
  String get everyoneEnded => 'Mọi người đã tắt; đã chuyển lại Chỉ liên hệ.';

  @override
  String get friendsCountTooltip => 'Liên hệ';

  @override
  String get waitingAccept => 'Đang chờ…';

  @override
  String get settingsConnection => 'Kết nối';

  @override
  String get settingsGeneralSummary =>
      'Khởi động khi đăng nhập, tên thiết bị, ngôn ngữ';

  @override
  String get settingsConnectionSummary => 'Dịch vụ, máy chủ riêng, mạng cục bộ';

  @override
  String get settingsSyncSummary =>
      'Đồng bộ thời gian thực, giới hạn dung lượng, nội dung đồng bộ';

  @override
  String get settingsQuickPasteSummary => 'Phím tắt và thao tác sau khi chọn';

  @override
  String get settingsSendSummary => 'Nhận tệp, vị trí lưu';

  @override
  String get settingsStorageSummary =>
      'Thời gian giữ lịch sử, dung lượng đã dùng';

  @override
  String get settingsAboutSummary => 'Phiên bản, cập nhật, phản hồi';

  @override
  String get friendsSubtitle =>
      'Gửi tệp tới máy tính của người khác, không cần ghép nối';

  @override
  String get friendsSearch => 'Tìm liên hệ';

  @override
  String get friendsNoMatch => 'Không có liên hệ phù hợp';

  @override
  String get friendsPick => 'Chọn một liên hệ để xem lượt truyền hoặc gửi tệp';

  @override
  String friendDropHint(String name) {
    return 'Thả tệp vào đây để gửi tới $name';
  }

  @override
  String get webShareTitle => 'Truyền qua web trên điện thoại';

  @override
  String get webShareFootnote =>
      'Quét mã QR bằng điện thoại để gửi và nhận văn bản, ảnh và tệp với máy tính này ngay trong trình duyệt, không cần cài ứng dụng. Điện thoại và máy tính cần ở cùng một mạng.';

  @override
  String get webShareSwitch => 'Cho phép điện thoại kết nối qua trình duyệt';

  @override
  String webShareOn(int count) {
    return 'Đang bật, $count điện thoại';
  }

  @override
  String get webShareOff => 'Tắt';

  @override
  String get webShareShowQr => 'Hiện mã QR';

  @override
  String get webShareDialogTitle => 'Quét bằng điện thoại';

  @override
  String get webShareDialogBody =>
      'Quét bằng máy ảnh hoặc trình duyệt của điện thoại và mở trong trình duyệt. Mỗi mã QR đăng ký một điện thoại và được thay mới sau khi dùng.';

  @override
  String get webShareAddress => 'Địa chỉ';

  @override
  String get webShareSecurity =>
      'Nội dung được mã hóa ngay trong trang nên người khác trong mạng không đọc được. Nhưng bản thân trang dùng http và không thể ngăn người cố tình can thiệp vào nó. Hãy dùng ở nhà hoặc trong mạng văn phòng tin cậy, không dùng trên Wi-Fi công cộng.';

  @override
  String get webSharePhones => 'Điện thoại đã đăng ký';

  @override
  String get webShareNoPhones => 'Chưa có điện thoại nào';

  @override
  String webShareLastUsed(String time) {
    return 'Dùng lần cuối $time';
  }

  @override
  String get webShareRemove => 'Xóa';

  @override
  String webShareRemoved(String name) {
    return 'Đã xóa “$name”';
  }

  @override
  String webShareNewPhone(String name) {
    return 'Đã đăng ký “$name”';
  }

  @override
  String webShareNotListening(String error) {
    return 'Không thể bắt đầu lắng nghe: $error';
  }

  @override
  String get webSharePortFallback =>
      'Cổng thông thường đang bị chiếm nên đang dùng một cổng tạm. Các địa chỉ đã lưu sẽ không mở được cho đến khi điện thoại quét lại.';

  @override
  String get webShareNoAddress =>
      'Không có địa chỉ mạng cục bộ. Hãy kết nối Wi-Fi hoặc mạng có dây trước.';

  @override
  String get webShareCantOpen =>
      'Nếu điện thoại không mở được trang, hãy đảm bảo hai thiết bị ở cùng một mạng (mạng khách thường không dùng được). Trên Windows, PasteFerry còn cần được cho phép qua tường lửa.';

  @override
  String get mTabRecords => 'Lịch sử';

  @override
  String get mTabSend => 'Gửi';

  @override
  String get mThisPhone => 'Điện thoại này';

  @override
  String get mThisPhoneInText => 'điện thoại này';

  @override
  String mThisPhoneName(String name) {
    return 'Điện thoại này: $name';
  }

  @override
  String get mSendTitle => 'Gửi tới máy tính';

  @override
  String get mSendHint => 'Nhập hoặc dán văn bản';

  @override
  String get mPaste => 'Dán';

  @override
  String get mPhotosFiles => 'Ảnh hoặc tệp';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Gửi $n tệp?';
  }

  @override
  String mFilesSent(num n) {
    return 'Đã gửi $n tệp tới máy tính';
  }

  @override
  String get mClipboardNoText => 'Bảng nhớ tạm không có văn bản';

  @override
  String get mSendAction => 'Gửi';

  @override
  String mSendTo(String names) {
    return 'Gửi tới $names';
  }

  @override
  String get mNoOnlineDevices => 'Không có thiết bị trực tuyến nào ở gần';

  @override
  String get mNoPairedDevices => 'Hãy ghép nối với một máy tính trước';

  @override
  String get mSent => 'Đã gửi';

  @override
  String get mSendFootnote =>
      'Văn bản và tệp được đưa vào lịch sử trên máy tính và, tùy theo cài đặt của máy tính, vào bảng nhớ tạm của nó. Nội dung bạn sao chép trên điện thoại không tự được gửi đi.';

  @override
  String get mSentRecords => 'Đã gửi';

  @override
  String get mSentRetention => 'Giữ mục đã gửi';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Đã gửi hiển thị những gì điện thoại này đã gửi trong $d ngày qua';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d ngày';
  }

  @override
  String get mViewAll => 'Xem tất cả';

  @override
  String get mClearCache => 'Xóa';

  @override
  String get mCheckUpdate => 'Kiểm tra cập nhật';

  @override
  String get mUpdateFailed => 'Không thể kiểm tra cập nhật';

  @override
  String get mUpToDate => 'Bạn đang dùng phiên bản mới nhất';

  @override
  String mNewVersion(Object v) {
    return 'Đã có phiên bản $v';
  }

  @override
  String get mDownloadInstall => 'Tải phiên bản mới';

  @override
  String mSendFailed(String detail) {
    return 'Không gửi được: $detail';
  }

  @override
  String get mCopy => 'Sao chép';

  @override
  String get mCopied => 'Đã sao chép vào bảng nhớ tạm của điện thoại này';

  @override
  String get mShare => 'Chia sẻ';

  @override
  String get mSaved => 'Đã lưu vào Ảnh hoặc Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Không thành công: $detail';
  }

  @override
  String get mDownloading => 'Đang tải về…';

  @override
  String get mNotDownloaded => 'Chưa tải về';

  @override
  String get mDownloadHint =>
      'Mục sẽ được tải về trước khi bạn nhấn Sao chép, Lưu hoặc Chia sẻ.';

  @override
  String get mFullTextLoading => 'Đang tải…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Đang hiển thị $shown trên tổng số $total ký tự. Sao chép sẽ lấy toàn bộ.';
  }

  @override
  String get mNotOnLanTitle => 'Chưa kết nối Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Hiện PasteFerry chỉ đồng bộ trong mạng cục bộ. Hãy kết nối cùng Wi-Fi với máy tính của bạn.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry không thể khởi động: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Trên máy tính, mở PasteFerry → Thiết bị → Thêm thiết bị, rồi nhập mã hiển thị ở đó vào đây. Nếu cùng Wi-Fi, bạn cũng có thể mở “Tìm lân cận” trên cả hai thiết bị.';

  @override
  String get mSectionSync => 'Đồng bộ';

  @override
  String get mSectionBackground => 'Chạy nền';

  @override
  String get mAutoApplyDesc =>
      'Văn bản sao chép trên máy tính được đưa thẳng vào bảng nhớ tạm của điện thoại này. Ảnh và tệp sẽ chờ đến khi bạn nhấn Sao chép.';

  @override
  String get mKeepAlive => 'Giữ kết nối ở chế độ nền';

  @override
  String get mKeepAliveDesc =>
      'Nhận văn bản ngay cả khi PasteFerry không mở. Hiển thị một thông báo thường trực.';

  @override
  String get mNotifications => 'Thông báo';

  @override
  String get mNotificationsDesc =>
      'Cần cho thông báo thường trực. PasteFerry vẫn hoạt động khi không có quyền này.';

  @override
  String get mBattery => 'Chạy ở chế độ nền';

  @override
  String get mBatteryDesc =>
      'Tắt tối ưu hóa pin để hệ thống không dừng PasteFerry khi khóa màn hình. Một số điện thoại còn cần thêm PasteFerry vào danh sách tự khởi động hoặc chạy nền trong Cài đặt.';

  @override
  String get mAllowed => 'Đã cho phép';

  @override
  String get mAllow => 'Cho phép';

  @override
  String mVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get mDeleteConfirm => 'Xóa mục này?';

  @override
  String get mDelete => 'Xóa';

  @override
  String get webShareFirewallPreparing =>
      'Đang kiểm tra Tường lửa Windows. Nếu Windows yêu cầu quyền quản trị viên, hãy chọn Có để điện thoại có thể kết nối.';

  @override
  String get webShareFirewallReady =>
      'Quy tắc Tường lửa Windows đã sẵn sàng. Hãy kết nối điện thoại vào cùng mạng và quét mã QR. Nếu vẫn không kết nối được, hãy kiểm tra lại tường lửa bên dưới.';

  @override
  String get webShareFirewallFailed =>
      'Chưa thiết lập xong tường lửa. Điện thoại có thể không mở được trang. Hãy thử lại và chấp thuận lời nhắc quản trị viên của Windows.';

  @override
  String get webShareFirewallAllow => 'Kiểm tra và cho phép điện thoại kết nối';

  @override
  String get mCopyMediaFailed =>
      'Không thể sao chép hình ảnh hoặc tệp này. Hãy thử lưu trước.';

  @override
  String get mShareMediaFailed =>
      'Không thể mở chia sẻ cho hình ảnh hoặc tệp này. Hãy thử lưu trước.';

  @override
  String get mSaveMediaFailed =>
      'Không thể lưu hình ảnh hoặc tệp này. Hãy kiểm tra quyền truy cập bộ nhớ và dung lượng trống, rồi thử lại.';

  @override
  String get noticeFilesUnreadable =>
      'Không đọc được các tệp bạn vừa sao chép nên chưa có gì được đồng bộ';

  @override
  String get mAddMore => 'Thêm nữa';

  @override
  String get mChoosePhotos => 'Chọn ảnh…';

  @override
  String get mMultiSelectHint =>
      'Có thể chọn nhiều ảnh cùng lúc. Trong Tệp, chạm và giữ một mục để chọn thêm.';

  @override
  String get webSendFiles => 'Gửi tệp';

  @override
  String get webFilesQueued =>
      'Đã thêm vào mục truyền qua web. Mở Gửi tệp trên điện thoại để tải về.';

  @override
  String get webFilesLimit =>
      'Tải về qua web hỗ trợ tối đa 200 MB mỗi tệp và 64 tệp mỗi lượt.';

  @override
  String get appearance => 'Giao diện';

  @override
  String get settingsAppearanceSummary => 'Chủ đề, sáng và tối';

  @override
  String get themeTitle => 'Chủ đề';

  @override
  String get themeDefault => 'Mặc định';

  @override
  String get themePixel => 'Pixel';

  @override
  String get themeMode => 'Sáng và tối';

  @override
  String get themeModeSystem => 'Theo hệ thống';

  @override
  String get themeModeLight => 'Sáng';

  @override
  String get themeModeDark => 'Tối';

  @override
  String get themeCustom => 'Tùy chỉnh';

  @override
  String get themeDelete => 'Xóa chủ đề';

  @override
  String themeDeleteConfirm(String name) {
    return 'Xóa chủ đề “$name”?';
  }

  @override
  String get themeLowContrast => 'Một số chữ trong chủ đề này có thể khó đọc';

  @override
  String get themeFootnote =>
      'Chủ đề chỉ áp dụng cho thiết bị này, kể cả Dán nhanh. Chủ đề không được đồng bộ sang các thiết bị khác.';

  @override
  String get themeBuiltinGroup => 'Có sẵn';

  @override
  String get themeCustomGroup => 'Tùy chỉnh';

  @override
  String get themeUse => 'Dùng';

  @override
  String get themeDuplicate => 'Nhân bản';

  @override
  String themeCopyName(String name) {
    return 'Bản sao của $name';
  }

  @override
  String get themeExport => 'Xuất…';

  @override
  String get themeImport => 'Nhập chủ đề…';

  @override
  String themeImported(String name) {
    return 'Đã nhập “$name”';
  }

  @override
  String themeImportedWarn(String name, int count) {
    return 'Đã nhập “$name”. $count màu chữ có thể khó đọc.';
  }

  @override
  String get themeExported => 'Đã xuất chủ đề';

  @override
  String get themeCustomEmpty =>
      'Chưa có chủ đề tùy chỉnh. Hãy nhân bản một chủ đề có sẵn, nhập một chủ đề, hoặc nhờ AI tạo một chủ đề.';

  @override
  String get themeAskAi => 'Nhờ AI tạo chủ đề';

  @override
  String get themeAskAiBody =>
      'Thêm máy chủ MCP này vào một ứng dụng AI như Claude hoặc Cursor, rồi yêu cầu một chủ đề, ví dụ “Tạo cho tôi một chủ đề cyberpunk”. AI sẽ đọc định dạng chủ đề, chọn màu, kiểm tra độ tương phản và áp dụng chủ đề.';

  @override
  String get themeAskAiCopy => 'Sao chép cấu hình';

  @override
  String get themeAskAiCopied => 'Đã sao chép cấu hình';

  @override
  String get themeScanlines => 'Đường quét';

  @override
  String get themeScanlinesDesc =>
      'Phủ các đường quét CRT mờ lên cửa sổ. Chỉ dùng cho chủ đề Pixel.';

  @override
  String get themeBackground => 'Ảnh nền';

  @override
  String get themeBackgroundDesc =>
      'Phủ kín cửa sổ phía sau thanh bên và các trang. Một lớp phủ phía trên giúp chữ vẫn dễ đọc.';

  @override
  String get themeBackgroundChoose => 'Chọn ảnh…';

  @override
  String get themeBackgroundChange => 'Thay đổi…';

  @override
  String get themeBackgroundRemove => 'Xóa';

  @override
  String get themeBlur => 'Làm mờ';

  @override
  String get themeBlurNone => 'Không';

  @override
  String get themeBlurLight => 'Nhẹ';

  @override
  String get themeBlurStrong => 'Mạnh';

  @override
  String get themeScrim => 'Lớp phủ';

  @override
  String get themeScrimDesc =>
      'Một lớp màu phủ lên ảnh để chữ vẫn dễ đọc. Lớp này không bao giờ nhạt hơn mức ảnh cần.';

  @override
  String get themeScrimAuto => 'Tự động';

  @override
  String get themeScrimMore => 'Dày hơn';

  @override
  String get themeScrimMost => 'Dày nhất';

  @override
  String get themePanels => 'Bảng';

  @override
  String get themePanelsDesc =>
      'Mức độ ảnh hiện qua thanh bên và các danh sách.';

  @override
  String get themePanelsClear => 'Trong';

  @override
  String get themePanelsMedium => 'Vừa';

  @override
  String get themePanelsSolid => 'Đặc';

  @override
  String get themeAccentFromImage => 'Dùng màu của ảnh';

  @override
  String get themeAccentFromImageDesc => 'Lấy màu nhấn từ ảnh.';

  @override
  String get themeBackgroundPicker => 'Hiện cả trong Dán nhanh';

  @override
  String get themeScenery => 'Hiện phong cảnh';

  @override
  String get themeSceneryDesc => 'Các hình ở đầu trang và cuối thanh bên.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Không thể sửa chủ đề có sẵn, nên đã tạo và áp dụng một bản sao tên “$name”';
  }

  @override
  String get themeBackgroundFootnote =>
      'Ảnh nền thuộc về chủ đề hiện tại. Không thể sửa chủ đề có sẵn: lần thay đổi đầu tiên sẽ tạo một bản sao. Ảnh chỉ lưu trên thiết bị này; hỗ trợ JPEG, PNG và GIF.';

  @override
  String get themeSceneGroup => 'Phong cảnh';

  @override
  String get themeSceneHeader => 'Đầu trang';

  @override
  String get themeSceneHeaderDesc =>
      'Một hình rộng phía sau tiêu đề trang; phần dưới mờ dần vào trang. Chủ đề Pixel vẽ một phong cảnh pixel ở đây.';

  @override
  String get themeSceneSidebar => 'Cuối thanh bên';

  @override
  String get themeSceneSidebarDesc =>
      'Một hình nhỏ ở cuối thanh bên. Chủ đề Pixel vẽ một khu cắm trại nhỏ ở đây.';

  @override
  String get themeSceneReset => 'Đặt lại';

  @override
  String get themeSceneFootnote =>
      'Mọi chủ đề đều có thể hiển thị hình của riêng bạn ở đây. Một lớp phủ giúp tiêu đề trang vẫn dễ đọc. Phong cảnh bị ẩn khi ảnh nền phủ kín cửa sổ.';

  @override
  String get starTitle => 'Bạn thấy PasteFerry thế nào?';

  @override
  String get starBody =>
      'Nếu bạn thích, một ngôi sao trên GitHub sẽ rất có ý nghĩa.';

  @override
  String get starAction => 'Gắn sao trên GitHub';

  @override
  String get starLater => 'Để sau';

  @override
  String get starDismiss => 'Không hiện lại';
}
