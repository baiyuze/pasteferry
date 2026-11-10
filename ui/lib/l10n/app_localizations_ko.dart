// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => '기록';

  @override
  String get navDevices => '기기';

  @override
  String get navSettings => '설정';

  @override
  String get navFavorites => '즐겨찾기';

  @override
  String get linkConnecting => '연결 중…';

  @override
  String get linkServiceNotRunning => '서비스가 실행되고 있지 않음';

  @override
  String get linkLanMode => '이 네트워크에서 기기를 찾는 중';

  @override
  String get linkServerUnreachable => '서버에 연결할 수 없어 이 네트워크에서 동기화 중';

  @override
  String get linkNothingOn => '로컬 네트워크 검색이 꺼져 있고 서버가 설정되지 않음';

  @override
  String get linkLanBlocked => 'macOS가 로컬 네트워크를 차단하고 있음';

  @override
  String linkOnlinePeers(int count) {
    return '기기 $count대 온라인';
  }

  @override
  String get linkServerConnected => '서버에 연결됨';

  @override
  String linkConnectionLost(String detail) {
    return '연결 끊김: $detail';
  }

  @override
  String get linkServiceDisconnected => '서비스 연결 끊김';

  @override
  String get linkServiceDisabled => '백그라운드 동기화 꺼짐';

  @override
  String get errServiceNotConnected => '백그라운드 서비스에 연결되지 않았습니다';

  @override
  String get errUnimplemented => '아직 사용할 수 없는 기능입니다';

  @override
  String get errUnavailable => '백그라운드 서비스에 연결할 수 없습니다';

  @override
  String errServiceStart(String detail) {
    return '백그라운드 서비스를 시작할 수 없습니다: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return '백그라운드 서비스를 다시 시작할 수 없습니다: $detail';
  }

  @override
  String errAutostart(String detail) {
    return '로그인 시 PasteFerry가 시작되도록 설정할 수 없습니다: $detail';
  }

  @override
  String get thisMacTitle => '이 Mac';

  @override
  String get thisPcTitle => '이 컴퓨터';

  @override
  String get thisMacInText => '이 Mac';

  @override
  String get thisPcInText => '이 컴퓨터';

  @override
  String get bothMacs => '두 Mac';

  @override
  String get bothDevices => '두 기기';

  @override
  String get thisDeviceShort => '이 기기';

  @override
  String fromDevice(String name) {
    return '$name에서';
  }

  @override
  String get cancel => '취소';

  @override
  String get close => '닫기';

  @override
  String get save => '저장';

  @override
  String get retry => '다시 시도';

  @override
  String get continueAction => '계속';

  @override
  String get justNow => '방금';

  @override
  String secondsAgo(int n) {
    return '$n초 전';
  }

  @override
  String minutesAgo(int n) {
    return '$n분 전';
  }

  @override
  String hoursAgo(int n) {
    return '$n시간 전';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n일 전',
      one: '어제',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String durationHours(int n) {
    return '$n시간';
  }

  @override
  String durationDays(int n) {
    return '$n일';
  }

  @override
  String get historyEmptySubtitle => '어느 기기에서든 복사하면 여기에 표시됩니다';

  @override
  String historyCount(int count) {
    return '$count개 항목';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '$count개 항목, $ttl 동안 보관';
  }

  @override
  String get filterAll => '전체';

  @override
  String get filterText => '텍스트';

  @override
  String get filterImage => '이미지';

  @override
  String get filterFile => '파일';

  @override
  String get filterLink => '링크';

  @override
  String get historyClearTooltip => '기록 지우기';

  @override
  String get historyEmptyTitle => '아직 항목이 없음';

  @override
  String get historyEmptyFilteredTitle => '이 유형의 항목이 없음';

  @override
  String get historyEmptyBody => '페어링된 기기에서 텍스트, 이미지 또는 파일을 복사하면 여기에 표시됩니다.';

  @override
  String get clearConfirmTitle => '기록을 모두 지우시겠습니까?';

  @override
  String clearConfirmBody(String device) {
    return '기기에서 동기화된 모든 항목과 캐시된 파일이 $device에서 삭제됩니다. 원본 파일에는 영향이 없습니다.';
  }

  @override
  String get clear => '지우기';

  @override
  String get historyCleared => '기록을 지웠습니다';

  @override
  String get permDeniedTitle => 'PasteFerry가 클립보드를 읽을 수 없음';

  @override
  String get permAskTitle => 'PasteFerry의 클립보드 읽기 허용';

  @override
  String get permDeniedBody =>
      '이 Mac에서 복사한 내용이 동기화되지 않습니다. 시스템 설정에서 PasteFerry Daemon을 ‘허용’으로 설정하세요.';

  @override
  String get permAskBody =>
      '허용하지 않으면 macOS가 매번 물어봅니다. 시스템 설정에서 PasteFerry Daemon을 ‘허용’으로 설정하세요.';

  @override
  String get openSystemSettings => '시스템 설정 열기';

  @override
  String get fetch => '받기';

  @override
  String get fetchStarted => '받는 중… 진행 상황은 기록에서 확인하세요';

  @override
  String get transferFailed => '전송 실패';

  @override
  String get expired => '만료됨';

  @override
  String get putOnClipboard => '클립보드에 복사';

  @override
  String get putOnClipboardDone => '클립보드에 복사됨';

  @override
  String get deleteRecord => '이 항목 삭제';

  @override
  String get deleted => '삭제됨';

  @override
  String get emptyRecord => '(비어 있음)';

  @override
  String get imageRecord => '이미지';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name 외 $others개';
  }

  @override
  String get searchHint => '텍스트 및 파일 이름 검색';

  @override
  String get searchClear => '검색 지우기';

  @override
  String searchResultCount(int count) {
    return '$count개 찾음';
  }

  @override
  String searchEmptyTitle(String query) {
    return '“$query”에 대한 결과 없음';
  }

  @override
  String get searchEmptyBody => '복사한 텍스트와 복사한 파일의 이름에서 검색합니다.';

  @override
  String get favoriteAction => '즐겨찾기에 추가';

  @override
  String get unfavoriteAction => '즐겨찾기에서 제거';

  @override
  String get favoritedToast => '즐겨찾기에 추가됨';

  @override
  String get unfavoritedToast => '기록으로 되돌림';

  @override
  String get undo => '실행 취소';

  @override
  String get favoriteSaving => '저장 중…';

  @override
  String favoritedAt(String date) {
    return '$date에 저장됨';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count개 항목 · 자동으로 정리되지 않음 · 최대 $size';
  }

  @override
  String get favoritesEmptyTitle => '아직 즐겨찾기가 없음';

  @override
  String get favoritesEmptyBody =>
      '기록에서 항목에 별표를 표시하면 여기에 사본이 보관됩니다. 즐겨찾기는 자동으로 정리되지 않습니다.';

  @override
  String get favoritesSearchHint => '즐겨찾기 검색';

  @override
  String favoriteLargeTitle(String size) {
    return '$size 크기의 사본을 저장하시겠습니까?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return '즐겨찾기는 별도의 사본을 보관하므로 원본 파일을 변경하거나 삭제해도 영향을 받지 않습니다. $device에서 $size를 사용합니다.';
  }

  @override
  String get saveCopy => '사본 저장';

  @override
  String clearKeepsFavorites(int count) {
    return '즐겨찾기 $count개는 유지됩니다.';
  }

  @override
  String get favoritesUsage => '즐겨찾기';

  @override
  String get favoritesUsageDesc => '위 설정과 관계없이 즐겨찾기는 정리되지 않습니다';

  @override
  String upToSize(String size) {
    return '최대 $size';
  }

  @override
  String detailChars(int count) {
    return '$count자';
  }

  @override
  String detailTruncated(int count) {
    return '… 총 $count자';
  }

  @override
  String detailMoreFiles(int count) {
    return '외 $count개';
  }

  @override
  String get detailReceiveFirst => '선택하면 먼저 다운로드합니다';

  @override
  String detailTotalSize(String size) {
    return '총 $size';
  }

  @override
  String get quickPaste => '빠른 붙여넣기';

  @override
  String get quickPasteWindow => '빠른 붙여넣기 윈도우';

  @override
  String get quickPasteWindowDesc =>
      '어떤 앱에서든 단축키를 눌러 기록을 불러오고, 항목을 선택하면 붙여넣습니다';

  @override
  String get quickPasteShortcut => '단축키';

  @override
  String get quickPasteRecord => '클릭하여 변경';

  @override
  String get quickPasteRecording => '새 단축키를 누르세요…';

  @override
  String get quickPasteUseDefault => '기본값 사용';

  @override
  String get quickPasteNeedsModifier => '⌃, ⌥, ⇧ 또는 ⌘를 포함하거나 기능 키를 사용하세요';

  @override
  String get quickPasteNeedsModifierPc =>
      'Ctrl, Alt, Shift 또는 Windows 키를 포함하거나 기능 키를 사용하세요';

  @override
  String get quickPasteAfterPick => '항목 선택 후';

  @override
  String get quickPastePasteIt => '붙여넣기';

  @override
  String get quickPasteCopyIt => '복사만 하기';

  @override
  String get quickPasteIndexKey => '처음 9개 중 선택';

  @override
  String get quickPasteIndexKeyDesc => '빠른 붙여넣기 윈도우에서 이 키를 누른 채 1–9를 누르세요';

  @override
  String get quickPasteAccessibility => '손쉬운 사용';

  @override
  String get quickPasteAccessibilityDesc =>
      '자동으로 붙여넣는 데 필요합니다. 허용하지 않으면 항목이 복사만 되며 ⌘V를 직접 눌러야 합니다.';

  @override
  String get quickPasteAllowed => '허용됨';

  @override
  String get quickPasteAllow => '허용…';

  @override
  String get quickPasteNotRunning => '빠른 붙여넣기 윈도우가 실행되고 있지 않습니다';

  @override
  String quickPasteInUse(String key) {
    return '$key은(는) 다른 앱에서 사용 중입니다. 다른 단축키를 선택하세요.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '$key을(를) 설정할 수 없습니다: $detail';
  }

  @override
  String get quickPastePortalKey => '시스템 단축키 설정에서 지정';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland에서는 데스크톱의 키보드 설정에서 단축키를 추가하세요. 선택한 항목은 복사되며 Ctrl+V를 눌러 붙여넣습니다.';

  @override
  String get quickPasteAddShortcut => '시스템 단축키 추가';

  @override
  String quickPasteShortcutAdded(String key) {
    return '추가되었습니다. $key을(를) 눌러 보세요.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return '데스크톱의 키보드 설정에서 다음 명령을 실행하는 사용자 지정 단축키를 추가하세요: $command';
  }

  @override
  String get pickerSearch => '검색';

  @override
  String get pickerPaste => '붙여넣기';

  @override
  String get pickerPlainText => '일반 텍스트';

  @override
  String get pickerCopyOnly => '복사만';

  @override
  String get pickerUnfavoriteHint => '제거(기록으로 되돌림)';

  @override
  String pickerPasteManually(String key) {
    return '선택한 항목은 복사됩니다 — $key을(를) 눌러 붙여넣으세요';
  }

  @override
  String get pickerGrantHint => '손쉬운 사용을 허용하면 바로 붙여넣을 수 있습니다';

  @override
  String pickerElevated(String key) {
    return '이 윈도우는 관리자 권한으로 실행 중입니다 — 선택한 후 $key을(를) 눌러 붙여넣으세요';
  }

  @override
  String get pickerDownloading => '다운로드 중 — 완료되면 붙여넣습니다';

  @override
  String get imagePreviewTitle => '이미지 미리보기';

  @override
  String get closePreview => '미리보기 닫기';

  @override
  String get previousImage => '이전 이미지';

  @override
  String get nextImage => '다음 이미지';

  @override
  String get previewHint => '스크롤하거나 핀치하여 확대/축소하고, 드래그하여 이동하세요';

  @override
  String get fitWindow => '윈도우에 맞추기';

  @override
  String get previewDeleted => '이 이미지는 기록에서 삭제되었습니다';

  @override
  String get previewExpired => '이 이미지는 만료되어 미리 볼 수 없습니다';

  @override
  String get previewDownloading => '이미지 다운로드 중…';

  @override
  String get previewDownloadFailed => '다운로드에 실패했습니다. 다시 시도하세요.';

  @override
  String get previewNotDownloaded => '이 이미지가 아직 이 컴퓨터에 없습니다';

  @override
  String get downloadAndPreview => '다운로드 및 미리보기';

  @override
  String get previewUnavailable => '지금은 이 이미지를 미리 볼 수 없습니다';

  @override
  String get imageSemantic => '기록의 이미지';

  @override
  String get previewUnreadable => '이미지를 읽을 수 없습니다. 파일이 정리되었거나 손상되었을 수 있습니다.';

  @override
  String get devicesSubtitleEmpty => '페어링하면 기기들이 하나의 클립보드를 공유합니다';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired대 페어링됨, $online대 온라인';
  }

  @override
  String get addDevice => '기기 추가';

  @override
  String thisDeviceFootnote(String both) {
    return '페어링할 때 $both에 기기별로 한 줄씩, 똑같은 두 줄의 보안 지문이 표시됩니다. 한 글자도 빠짐없이 일치할 때만 확인하세요.';
  }

  @override
  String get noDevicesTitle => '아직 페어링된 기기가 없음';

  @override
  String get noDevicesBody =>
      '다른 컴퓨터에서 PasteFerry를 열고 6자리 페어링 코드로 두 기기를 연결하세요. 같은 네트워크에 있다면 두 기기 모두에서 ‘주변 기기 검색’을 열고 상대 기기를 클릭해도 됩니다.';

  @override
  String get pairedDevices => '페어링된 기기';

  @override
  String get pairedFootnote =>
      '직접 연결: 데이터가 두 기기 사이에서 바로 전송됩니다. 중계: 네트워크가 직접 연결을 막으면 데이터가 서버를 거쳐 전송되며, 계속 종단 간 암호화됩니다.';

  @override
  String get offline => '오프라인';

  @override
  String get direct => '직접 연결';

  @override
  String get relay => '중계';

  @override
  String get online => '온라인';

  @override
  String get moreActions => '더 보기';

  @override
  String get copyFingerprint => '지문 복사';

  @override
  String get unpairEllipsis => '페어링 해제…';

  @override
  String get fingerprintCopied => '지문을 복사했습니다';

  @override
  String unpairTitle(String name) {
    return '“$name”과(와)의 페어링을 해제하시겠습니까?';
  }

  @override
  String get unpairBody => '두 기기의 동기화가 중단됩니다. 다시 동기화하려면 다시 페어링하고 지문을 확인해야 합니다.';

  @override
  String get unpair => '페어링 해제';

  @override
  String get unpaired => '페어링 해제됨';

  @override
  String get enterAddressEllipsis => '주소 입력…';

  @override
  String setAddressTitle(String name) {
    return '“$name”의 주소';
  }

  @override
  String setAddressBody(String name) {
    return '두 기기가 서로 다른 서브넷에 있거나 둘 다 주소가 바뀌었을 때 사용합니다. “$name”의 ‘기기 추가 → 코드 표시’ 아래에 표시된 주소를 입력하세요.';
  }

  @override
  String get addressSaved => '해당 주소에서 찾는 중';

  @override
  String get lanBlockedTitle => 'macOS가 로컬 네트워크를 차단하고 있음';

  @override
  String lanBlockedBody(String device) {
    return '시스템 설정 → 개인정보 보호 및 보안 → 로컬 네트워크에서 PasteFerry Daemon을 켜세요. 켜기 전까지 $device은(는) 이 네트워크의 기기에 연결할 수 없습니다.';
  }

  @override
  String get searchNearby => '주변 기기 검색';

  @override
  String get nearbyTitle => '주변 기기';

  @override
  String get nearbySearching => '주변 기기를 찾는 중…';

  @override
  String get nearbyHint => '다른 컴퓨터에서도 ‘주변 기기 검색’을 열면 여기에 표시됩니다. 클릭하여 페어링하세요.';

  @override
  String nearbyVisible(String device) {
    return '이 윈도우가 열려 있는 동안 이 네트워크의 기기에서 $device의 이름을 볼 수 있습니다.';
  }

  @override
  String get nearbyPaired => '페어링됨';

  @override
  String nearbyRequesting(String name) {
    return '“$name”에 연결 요청 중…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name”이(가) 응답하지 않았습니다. 해당 기기에서 ‘주변 기기 검색’이 열려 있는지 확인하세요.';
  }

  @override
  String get nearbyLanOffTitle => '로컬 네트워크 검색이 꺼져 있음';

  @override
  String get nearbyLanOffBody =>
      '주변 기기를 보려면 설정 → 연결에서 ‘이 네트워크에서 기기 찾기’를 켜거나, 대신 코드로 페어링하세요.';

  @override
  String get generateCode => '코드 표시';

  @override
  String get enterCode => '코드 입력';

  @override
  String get codeFailedTitle => '페어링 코드를 만들 수 없음';

  @override
  String get enterOnOther => '다른 기기에서 이 코드를 입력하세요';

  @override
  String get codeCopied => '코드를 복사했습니다';

  @override
  String get codeHint => '클릭하여 복사합니다. 5분 동안 유효합니다.';

  @override
  String afterEnterFootnote(String both) {
    return '코드를 입력하면 $both에 똑같은 두 줄의 보안 지문이 표시됩니다. 일치할 때만 확인하세요.';
  }

  @override
  String get codeInvalid => '페어링 코드는 영문자 또는 숫자 6자리입니다';

  @override
  String get localAddress => '주소';

  @override
  String get addressHint => '다른 서브넷에 있나요? 다른 기기에서도 이 주소를 입력하세요.';

  @override
  String get addressCopied => '주소를 복사했습니다';

  @override
  String get differentSubnet => '다른 서브넷에 있나요?';

  @override
  String get peerAddress => '코드 아래에 표시된 주소';

  @override
  String get pairNotFound =>
      '해당 기기를 찾을 수 없습니다. 다른 서브넷에 있다면 그 기기의 코드 아래에 표시된 주소를 입력하세요.';

  @override
  String get pairNotFoundAddress =>
      '해당 주소에서 응답이 없습니다. 주소가 맞는지, 다른 기기에 아직 코드가 표시되어 있는지 확인하세요. 그 기기의 방화벽이 차단하고 있을 수도 있습니다.';

  @override
  String get codeWrong => '코드가 올바르지 않거나 만료되었습니다';

  @override
  String get codeExpired => '코드가 만료되었습니다. 다른 기기에서 새 코드를 표시하세요.';

  @override
  String get addressInvalid => '올바른 주소가 아닙니다. 192.168.1.20과 같은 형식으로 입력하세요.';

  @override
  String get pairNoChannel => '먼저 설정 → 연결에서 로컬 네트워크 검색을 켜거나 서버를 설정하세요.';

  @override
  String get enterCodeShown => '다른 기기에 표시된 코드를 입력하세요';

  @override
  String get pairingDone => '페어링됨';

  @override
  String get pairingRejected => '페어링 거절됨';

  @override
  String get verifyTitle => '보안 지문 확인';

  @override
  String pairingWith(String name) {
    return '“$name”과(와) 페어링 중';
  }

  @override
  String verifyBody(String both) {
    return '$both에 표시된 두 줄은 완전히 같아야 합니다. 한 글자라도 다르면 누군가 연결을 조작하고 있을 수 있으니 거절하세요.';
  }

  @override
  String get rejectMismatch => '다름, 거절';

  @override
  String get confirmMatch => '일치함, 페어링';

  @override
  String get server => '서버(선택 사항)';

  @override
  String get signalingUrl => '시그널링 서버';

  @override
  String get signalingUrlDesc => '로컬에서만 동기화하려면 비워 두세요';

  @override
  String get signalingUrlPlaceholder => 'ws://서버-주소:8787/signal';

  @override
  String get publicStun => '직접 연결 개선';

  @override
  String get publicStunDesc => '공용 서버에 공인 IP가 노출됩니다';

  @override
  String get connectionStatus => '연결';

  @override
  String get disconnectedDesc => '서버 주소와 서버 상태를 확인하세요';

  @override
  String get connected => '연결됨';

  @override
  String get notConnected => '연결되지 않음';

  @override
  String get notSet => '설정되지 않음';

  @override
  String get serverCleared => '서버를 제거했습니다. 이 네트워크에서만 동기화합니다.';

  @override
  String get localNetwork => '로컬 네트워크';

  @override
  String get lanDiscovery => '이 네트워크에서 기기 찾기';

  @override
  String get lanDiscoveryDesc => '익명으로 검색하며, 이름은 ‘주변 기기 검색’ 중에만 표시됩니다';

  @override
  String get macLocalNetwork => '로컬 네트워크 접근';

  @override
  String get macLocalNetworkDesc => '시스템 설정에서 PasteFerry Daemon을 허용하세요';

  @override
  String get allowLan => 'Windows 방화벽';

  @override
  String get allowLanDesc => '차단된 연결을 허용합니다. 관리자 승인이 필요합니다';

  @override
  String get allow => '허용';

  @override
  String get allowLanDone => '허용되었습니다. 이제 다른 기기에서 이 기기에 연결할 수 있습니다.';

  @override
  String get deviceName => '기기 이름';

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템 설정';

  @override
  String get sync => '동기화';

  @override
  String get autoSyncLimit => '자동 동기화 한도';

  @override
  String get autoSyncLimitDesc => '더 큰 항목은 기록에서 직접 받으세요';

  @override
  String get autoApply => '받은 항목을 클립보드에 넣기';

  @override
  String get whatToSync => '동기화할 항목';

  @override
  String get syncFiles => '파일 및 폴더';

  @override
  String get syncText => '일반 텍스트';

  @override
  String get syncRich => '서식 있는 텍스트';

  @override
  String get syncImages => '이미지 및 스크린샷';

  @override
  String get storage => '저장 공간';

  @override
  String get storageFootnote => '만료된 기록과 캐시 파일은 자동으로 삭제됩니다.';

  @override
  String get keepHistory => '기록 보관 기간';

  @override
  String get keepCache => '캐시 파일 보관 기간';

  @override
  String get keepCacheDesc => '기록 보관 기간보다 길 수 없습니다';

  @override
  String get cacheUsage => '캐시 크기';

  @override
  String get backgroundSync => '백그라운드 동기화';

  @override
  String get backgroundService => '백그라운드 서비스';

  @override
  String get backgroundServiceDesc => '로그인 시 시작되며, 윈도우를 닫아도 동기화합니다';

  @override
  String get restart => '다시 시작';

  @override
  String get restarted => '백그라운드 서비스를 다시 시작했습니다';

  @override
  String get disableEllipsis => '끄기…';

  @override
  String get about => '정보';

  @override
  String get aboutDesc => 'AGPL-3.0 라이선스의 오픈 소스';

  @override
  String get homepage => '웹사이트';

  @override
  String get feedback => '문제 신고';

  @override
  String get disableTitle => '백그라운드 동기화를 끄시겠습니까?';

  @override
  String disableBody(String device) {
    return '$device의 PasteFerry가 동기화를 중단하고 로그인 시 시작되지 않습니다. 기록과 페어링은 유지됩니다.';
  }

  @override
  String get disable => '끄기';

  @override
  String get disabled => '백그라운드 동기화 꺼짐';

  @override
  String get urlMustBeWs => '주소는 ws:// 또는 wss://로 시작해야 합니다';

  @override
  String get serverUpdated => '서버를 변경했습니다. 다시 연결 중…';

  @override
  String get deviceNameUpdated => '기기 이름을 변경했습니다';

  @override
  String get diagIntro =>
      '이 보고서에는 앱 버전, 시스템, 설정, 기기 및 최근 로그가 포함됩니다. 기기 이름, 서버 주소, 공인 IP 주소, 사용자 폴더와 파일 이름은 다른 값으로 바뀌며, 복사한 내용은 로그에 기록되지 않습니다. GitHub의 이슈는 공개되므로 게시하기 전에 끝까지 읽어 보세요.';

  @override
  String get diagVerboseTitle => '상세 로그';

  @override
  String get diagVerboseDesc =>
      '연결 문제가 있을 때: 켜고 문제를 다시 재현한 다음 돌아와서 보고서를 만드세요. 30분 후 자동으로 꺼집니다.';

  @override
  String get diagVerboseOn => '30분 동안 켜기';

  @override
  String diagVerboseUntil(String time) {
    return '$time까지 켜짐';
  }

  @override
  String get diagVerboseOff => '끄기';

  @override
  String get diagRefresh => '다시 생성';

  @override
  String get diagSave => '파일로 저장';

  @override
  String diagSaved(String name) {
    return '다운로드 폴더에 저장됨: $name';
  }

  @override
  String get diagCopy => '보고서 복사';

  @override
  String get diagCopied => '보고서를 복사했습니다';

  @override
  String get diagNewIssue => 'GitHub에 새 이슈 작성';

  @override
  String get diagIssueHint =>
      '보고서를 복사했습니다. 이슈의 ‘Diagnostics report’ 칸에 붙여넣으세요.';

  @override
  String diagFailed(String detail) {
    return '보고서를 만들 수 없습니다: $detail';
  }

  @override
  String get svcExtractTitle => '먼저 PasteFerry를 설치하거나 압축을 푸세요';

  @override
  String get svcExtractBody =>
      'PasteFerry가 zip 파일에서 바로 실행되고 있어, 닫으면 임시 폴더가 사라집니다. 백그라운드 동기화를 켜려면 설치 프로그램을 실행하거나, 폴더 전체의 압축을 푼 다음 그 위치에서 여세요.';

  @override
  String get svcMoveTitle => '먼저 PasteFerry를 응용 프로그램으로 옮기세요';

  @override
  String get svcMoveBody =>
      'PasteFerry가 디스크 이미지에서 바로 실행되고 있습니다. 백그라운드 동기화를 켜려면 응용 프로그램 폴더로 드래그하고 디스크 이미지를 추출한 다음, 응용 프로그램 폴더에서 여세요.';

  @override
  String get svcStartTitle => 'PasteFerry 시작하기';

  @override
  String get svcStartBody =>
      'PasteFerry는 클립보드 동기화를 위해 작은 백그라운드 프로세스를 실행합니다. 윈도우를 닫아도 계속 실행됩니다. 로그인 시 실행은 별도 설정이며, 새로 설치하면 꺼져 있습니다.';

  @override
  String get svcEnable => '백그라운드 동기화 켜기';

  @override
  String get svcStaleTitle => '백그라운드 동기화 다시 켜기';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry의 위치가 바뀌었지만 로그인 시 시작 항목은 여전히 이전 위치를 가리킵니다. 백그라운드 프로세스가 이 사본을 사용하도록 다시 켜세요. 기록과 페어링은 유지됩니다.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry의 위치가 바뀌었거나 이전 스크립트로 설치되었습니다. 백그라운드 프로세스가 이 앱을 사용하도록 다시 켜세요. 기록과 페어링은 유지됩니다.';

  @override
  String get svcReenable => '다시 켜기';

  @override
  String get svcStoppedTitle => '백그라운드 서비스가 실행되고 있지 않음';

  @override
  String get svcStoppedBody =>
      '백그라운드 서비스가 중지되었습니다. 아래 버튼으로 시작하세요. 로그인 시 실행 여부는 설정에서 따로 지정합니다.';

  @override
  String get svcDevBodyWin =>
      '이 빌드는 개발용 빌드로, 옆에 pasteferryd.exe가 없습니다. 완전한 버전을 빌드하려면 소스 폴더에서 scripts\\build-windows.ps1을 실행하세요.';

  @override
  String get svcDevBodyLinux =>
      '이 빌드는 개발용 빌드로, 옆에 pasteferryd가 없습니다. 완전한 버전을 빌드하려면 소스 폴더에서 ./scripts/package-linux.sh를 실행하세요.';

  @override
  String get svcDevBodyMac =>
      '이 빌드는 백그라운드 서비스가 없는 개발용 빌드입니다. 설치하려면 소스 폴더에서 ./scripts/install-macos.sh를 실행하세요.';

  @override
  String svcLogPath(String path) {
    return '로그: $path';
  }

  @override
  String get svcCanDisable => '백그라운드 동기화는 언제든지 설정에서 끌 수 있습니다.';

  @override
  String get officialService => '서비스';

  @override
  String get useOfficialService => '서비스 사용';

  @override
  String get officialServiceDesc => '여러 네트워크 간 동기화, 직접 연결 우선';

  @override
  String get officialPrivacy =>
      '켠 경우에만 서비스에 연결하며 꼭 필요한 연결 정보만 기록합니다. 먼저 직접 연결을 시도하고, 실패할 때만 중계를 요청합니다. 내용, 실제 기기 이름, 원본 시스템 식별자는 업로드되지 않습니다.';

  @override
  String get officialEnableTitle => '서비스를 켜시겠습니까?';

  @override
  String get officialSwitchConfirm => '사용자 지정 서버에서 전환됩니다. 저장된 주소는 유지됩니다.';

  @override
  String get customServer => '사용자 지정 서버';

  @override
  String get saveAndConnect => '저장 후 연결';

  @override
  String get officialLoading => '사용량 한도 확인 중…';

  @override
  String get officialFetchFailed => '지금은 사용량 한도를 가져올 수 없습니다. 자동으로 다시 시도합니다.';

  @override
  String get officialUnavailable => '사용량을 확인할 수 없습니다. 기존 데이터가 최신이 아닐 수 있습니다';

  @override
  String get officialQuotaTitle => '오늘의 중계 한도를 모두 사용함';

  @override
  String get officialQuotaBody =>
      '서비스 중계는 베이징 시간 자정에 한도가 초기화될 때까지 일시 중지됩니다. 로컬 네트워크와 인터넷 직접 연결은 계속 사용할 수 있습니다. 실패한 전송은 나중에 다시 시도할 수 있습니다.';

  @override
  String get officialPeerQuota =>
      '상대 기기의 중계 한도가 남아 있지 않습니다. 직접 연결은 계속 사용할 수 있습니다.';

  @override
  String get officialPaused => '서비스 중계를 사용할 수 없습니다. 직접 연결은 계속 사용할 수 있습니다.';

  @override
  String get officialViewUsage => '사용량 보기';

  @override
  String get officialAcknowledge => '확인';

  @override
  String get officialToday => '오늘의 중계 한도';

  @override
  String get officialUsed => '사용함';

  @override
  String get officialRemaining => '남음';

  @override
  String get officialDailyLimit => '일일 한도';

  @override
  String get officialUpload => '업로드';

  @override
  String get officialDownload => '다운로드';

  @override
  String get officialReset => '초기화 시간(베이징)';

  @override
  String get officialUpdated => '마지막 업데이트';

  @override
  String get officialRoutes => '기기 연결 방식';

  @override
  String get officialRoutesFootnote => '직접 연결은 서비스 중계를 거치지 않으며 한도를 사용하지 않습니다.';

  @override
  String get officialDeviceID => '기기 ID';

  @override
  String get officialWarning => '오늘의 중계 한도를 90% 사용했습니다. 직접 연결은 한도를 사용하지 않습니다.';

  @override
  String get updateCheck => '업데이트 확인';

  @override
  String get updateCheckEllipsis => '업데이트 확인…';

  @override
  String get updateAuto => '자동으로 업데이트 확인';

  @override
  String get updateChecking => '업데이트 확인 중…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version이(가) 최신 버전입니다.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version 사용 가능';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return '현재 버전은 $current입니다. 다운로드 크기는 $size입니다.';
  }

  @override
  String get updateNew => '새로운 기능';

  @override
  String get updateFixed => '수정 사항';

  @override
  String get updateSkip => '이 버전 건너뛰기';

  @override
  String get updateLater => '나중에';

  @override
  String get updateInstall => '다운로드 및 설치';

  @override
  String updateDownloading(String done, String total) {
    return '다운로드 중 $done / $total';
  }

  @override
  String get updateVerifying => '다운로드한 파일 확인 중…';

  @override
  String get updateInstalling => '설치 중입니다. PasteFerry가 자동으로 다시 열립니다.';

  @override
  String get updateInstallingPassword =>
      '설치 중입니다. /opt에는 관리자 권한이 필요하므로 시스템에서 암호를 요청합니다. 그런 다음 PasteFerry가 자동으로 다시 열립니다.';

  @override
  String get updateCheckFailed => 'GitHub 또는 Gitee에 연결할 수 없습니다. 나중에 다시 시도하세요.';

  @override
  String get updateDownloadFailed =>
      '다운로드가 완료되지 않았습니다. 다시 시도하거나 웹사이트에서 새 버전을 다운로드하세요.';

  @override
  String updateInstallFailed(String error) {
    return '설치를 시작할 수 없습니다: $error';
  }

  @override
  String get updateUnsupportedBuild => '이 빌드는 업데이트를 확인할 수 없습니다.';

  @override
  String get updateBlockedDev => '개발용 빌드이므로 자동으로 업데이트할 수 없습니다.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry가 디스크 이미지에서 실행되고 있습니다. 자동으로 업데이트하려면 응용 프로그램 폴더로 드래그한 후 그곳에서 여세요.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry가 설치된 폴더에 쓸 수 없습니다. 대신 웹사이트에서 새 버전을 다운로드하세요.';

  @override
  String get updateBlockedUnsupported =>
      '이 컴퓨터에서는 자동 업데이트를 사용할 수 없습니다. 웹사이트에서 새 버전을 다운로드하세요.';

  @override
  String get updateOpenDownload => '다운로드 페이지 열기';

  @override
  String updateSidebar(String version) {
    return '버전 $version 사용 가능';
  }

  @override
  String updatedTo(String version) {
    return '$version(으)로 업데이트됨';
  }

  @override
  String updateNotFinished(String version) {
    return '업데이트가 완료되지 않았습니다. 여전히 $version을(를) 사용 중입니다.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return '업데이트가 완료되지 않았습니다. 여전히 $version을(를) 사용 중입니다. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · 서비스 $serviceVersion · 빌드 $build';
  }

  @override
  String get notReceived => '받지 않음 — 붙여넣기 전에 받으세요';

  @override
  String get receivedPreserved => '받았습니다. 준비되면 ‘클립보드에 복사’를 사용하세요';

  @override
  String get clipboardWriteFailed => '받았지만 클립보드를 업데이트할 수 없습니다';

  @override
  String get receivingStatus => '받는 중…';

  @override
  String get largeFileNotifications => '대용량 파일 알림';

  @override
  String get notificationsAllowed => '알림이 켜져 있습니다. 진행 상황은 기록에 표시됩니다.';

  @override
  String get notificationsNotRequested =>
      '대용량 파일이 알림 없이 대기하지 않도록 알림을 켜세요. 언제든지 기록에서 받을 수도 있습니다.';

  @override
  String get notificationsDenied =>
      '시스템 설정에서 알림이 차단되어 있습니다. 대기 중인 항목은 기록에서 받으세요.';

  @override
  String get notificationsUnknown =>
      '알림 표시와 방해 금지 모드는 데스크톱에서 관리합니다. 알림이 나타나지 않으면 기록에서 항목을 받으세요.';

  @override
  String get notificationsUnavailable =>
      '시스템 알림을 사용할 수 없습니다. 대용량 파일은 기록에서 받으세요.';

  @override
  String get enableNotifications => '알림 켜기';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get notifyPendingTitle => '받은 후 붙여넣기';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\n붙여넣기 전에 이 항목을 받으세요. 기록에서 받을 수도 있습니다.';
  }

  @override
  String get notifyReceivingTitle => '받는 중…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\n진행 상황은 기록에서 확인하세요.';
  }

  @override
  String get notifyReadyTitle => '붙여넣기 준비됨';

  @override
  String notifyReadyBody(String name) {
    return '$name\n받아서 클립보드에 넣었습니다.';
  }

  @override
  String get notifyReceivedTitle => '받음';

  @override
  String notifyReceivedBody(String name) {
    return '$name\n현재 클립보드는 유지되었습니다. 준비되면 ‘클립보드에 복사’를 사용하세요. 기록에서도 할 수 있습니다.';
  }

  @override
  String get notifyFailedTitle => '받을 수 없음';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\n이 알림이나 기록에서 다시 시도하세요.';
  }

  @override
  String get notifyClipboardFailedTitle => '받았지만 클립보드가 업데이트되지 않음';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\n여기나 기록에서 ‘클립보드에 복사’로 다시 시도하세요.';
  }

  @override
  String get reconnect => '다시 연결';

  @override
  String get reconnecting => '연결 중…';

  @override
  String get reconnectDirect => '직접 연결됨';

  @override
  String get reconnectRelay => '직접 연결할 수 없어 계속 중계를 사용합니다';

  @override
  String reconnectOffline(String name) {
    return '“$name”이(가) 오프라인입니다. 해당 기기에서 PasteFerry가 열려 있는지 확인하세요.';
  }

  @override
  String get reconnectPending => '아직 연결 중입니다. 잠시 후 다시 확인하세요';

  @override
  String get renameAction => '이름 변경';

  @override
  String get renameFavoriteTitle => '즐겨찾기 이름 변경';

  @override
  String get renameFavoriteHint =>
      '즐겨찾기와 빠른 붙여넣기에 이 이름이 표시되며, 이 이름으로 검색할 수도 있습니다. 비워 두면 다시 내용이 표시됩니다.';

  @override
  String get renamedToast => '이름을 변경했습니다';

  @override
  String get aliasClearedToast => '다시 내용을 표시합니다';

  @override
  String get navSend => '파일 보내기';

  @override
  String get sendSubtitle => '파일을 기기 위로 드래그하면 바로 보냅니다';

  @override
  String get sendNoDevicesTitle => '아직 페어링된 기기가 없음';

  @override
  String get sendNoDevicesBody => '먼저 다른 컴퓨터와 페어링한 다음, 여기에서 파일을 보내세요.';

  @override
  String get sendDropHint => '기기 위에 놓아서 보내기';

  @override
  String sendReleaseTo(String name) {
    return '놓으면 $name(으)로 보냅니다';
  }

  @override
  String get sendLan => '로컬 네트워크';

  @override
  String sendRelayLeft(String left) {
    return '중계 · 오늘 $left 남음';
  }

  @override
  String get sendNeedsUpdate => '업데이트 필요';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name은(는) PasteFerry 2.5 이상으로 업데이트한 후 파일을 받을 수 있습니다.';
  }

  @override
  String sendConnectingTip(String name) {
    return '$name에 연결 중입니다. 연결되면 보낼 수 있습니다.';
  }

  @override
  String get sendNotReceiving => '파일을 받지 않음';

  @override
  String get sendDelivered => '전달됨';

  @override
  String sendToTitle(String name) {
    return '$name(으)로 보내기';
  }

  @override
  String get sendDropHere => '파일이나 폴더를 여기로 드래그하세요';

  @override
  String get sendDropStarts => '놓는 즉시 전송이 시작됩니다';

  @override
  String get sendChooseFiles => '파일 선택…';

  @override
  String get sendChooseFolder => '폴더 선택…';

  @override
  String get sendDropMore => '파일을 더 놓으면 이어서 보냅니다';

  @override
  String sendSavedWhere(String name) {
    return '파일은 $name에서 지정한 위치에 저장됩니다(기본값은 다운로드 폴더).';
  }

  @override
  String get sendCloseKeeps => '이 윈도우를 닫아도 전송은 계속됩니다';

  @override
  String get sendRemoveQueued => '제거';

  @override
  String get sendCannotDrop =>
      '이 항목은 드래그해서 보낼 수 없습니다. 먼저 파일로 저장하거나 ‘파일 선택…’을 사용하세요.';

  @override
  String sendErrOffline(String name) {
    return '$name이(가) 오프라인입니다.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name은(는) 파일을 받지 않습니다.';
  }

  @override
  String get sendErrMissing => '일부 파일이 더 이상 존재하지 않습니다.';

  @override
  String get relayConfirmTitle => '서비스 중계를 통해 보내시겠습니까?';

  @override
  String relayConfirmBody(String name, String left) {
    return '지금은 $name과(와) 이 컴퓨터 사이에 직접 연결이 없으므로 파일이 약 0.25MB/s 속도로 서비스 중계를 거쳐 전송됩니다. 오늘의 중계 한도가 $left 남았습니다.';
  }

  @override
  String relayConfirmOver(String size) {
    return '이 파일($size)은 남은 한도보다 큽니다. 한도를 다 쓰면 전송이 일시 중지되며, 두 컴퓨터가 직접 연결되거나 내일 한도가 초기화되면 이어서 전송됩니다.';
  }

  @override
  String relayConfirmWithin(String size) {
    return '오늘 한도 중 약 $size를 사용합니다.';
  }

  @override
  String get relayExhausted =>
      '오늘의 중계 한도를 모두 사용했습니다. 베이징 시간 자정에 초기화됩니다. 직접 연결된 두 컴퓨터 사이에는 제한이 없습니다.';

  @override
  String get relayDontAskToday => '오늘은 이 기기에 대해 다시 묻지 않기';

  @override
  String get relaySendAnyway => '그래도 보내기';

  @override
  String get relayOwnServer => '중계됨 — 속도는 서버에 따라 다릅니다';

  @override
  String get transfersReceived => '받음';

  @override
  String get transfersSent => '보냄';

  @override
  String get transfersClearAll => '모두 지우기';

  @override
  String get transfersClearTitle => '이 목록을 지우시겠습니까?';

  @override
  String get transfersClearBody => '목록만 지워집니다. 파일은 그대로 남아 있습니다.';

  @override
  String get transfersEmptyReceived => '다른 기기에서 보낸 파일이 여기에 표시됩니다';

  @override
  String get transfersEmptySent => '보낸 파일이 여기에 표시됩니다';

  @override
  String transferFrom(String name) {
    return '$name에서';
  }

  @override
  String transferTo(String name) {
    return '$name(으)로';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name 외 $others개';
  }

  @override
  String transferFileCount(int count) {
    return '파일 $count개';
  }

  @override
  String get transferQueued => '대기 중';

  @override
  String transferScanning(String count) {
    return '세는 중… 파일 $count개 찾음';
  }

  @override
  String transferWaitingPeer(String name) {
    return '$name 기다리는 중…';
  }

  @override
  String get transferSending => '보내는 중';

  @override
  String get transferReceiving => '받는 중';

  @override
  String transferCurrent(String file, String index, String total) {
    return '현재: $file($total개 중 $index번째)';
  }

  @override
  String transferLeft(String time) {
    return '$time 남음';
  }

  @override
  String etaSeconds(int n) {
    return '$n초';
  }

  @override
  String etaMinutes(int n) {
    return '$n분';
  }

  @override
  String etaHours(int h, int m) {
    return '$h시간 $m분';
  }

  @override
  String get transferPaused => '일시 중지됨: 오늘의 중계 한도를 모두 사용함';

  @override
  String get transferInterrupted => '중단됨 — 다시 연결되면 계속됩니다';

  @override
  String transferInterruptedIncoming(String name) {
    return '중단됨 — $name에서 이어서 보내기를 기다리는 중';
  }

  @override
  String get transferCancelled => '취소됨';

  @override
  String transferPeerCancelled(String name) {
    return '$name에서 취소함';
  }

  @override
  String get transferExpired => '만료됨';

  @override
  String get transferMissing => '이동되었거나 삭제됨';

  @override
  String transferNotSent(String reason) {
    return '보내지 못함: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return '받지 못함: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name의 디스크 공간이 부족합니다($size 부족)';
  }

  @override
  String reasonNoSpace(String size) {
    return '디스크 공간이 부족합니다($size 부족)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name의 저장 위치를 사용할 수 없습니다';
  }

  @override
  String get reasonDestUnavailable => '저장 위치를 사용할 수 없습니다 — 설정에서 확인하세요';

  @override
  String get reasonFileTooLarge =>
      '저장 위치가 FAT32 드라이브에 있어 4GB가 넘는 파일을 저장할 수 없습니다';

  @override
  String reasonDisabledPeer(String name) {
    return '$name은(는) 파일을 받지 않습니다';
  }

  @override
  String get reasonSourceChanged => '보내는 도중 파일이 변경되었습니다';

  @override
  String get reasonSourceMissing => '파일이 더 이상 존재하지 않습니다';

  @override
  String get reasonReadError => '파일을 읽을 수 없습니다';

  @override
  String get reasonWriteFailed => '파일을 쓸 수 없습니다';

  @override
  String get reasonHashMismatch => '전송 중에 파일이 손상되었습니다';

  @override
  String reasonUnsupported(String name) {
    return '$name이(가) 파일을 받으려면 업데이트해야 합니다';
  }

  @override
  String get reasonOther => '문제가 발생했습니다';

  @override
  String get revealInFinder => 'Finder에서 보기';

  @override
  String get revealInFolder => '폴더에서 보기';

  @override
  String get revealOpenFolder => '폴더 열기';

  @override
  String get transferResend => '다시 보내기';

  @override
  String get transferRemove => '목록에서 제거';

  @override
  String get transferCopyPath => '경로 복사';

  @override
  String get transferPathCopied => '경로를 복사했습니다';

  @override
  String sendingTo(String name, String percent) {
    return '$name(으)로 보내는 중 · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '$name에서 받는 중 · $percent';
  }

  @override
  String get receiveFiles => '다른 기기에서 파일 받기';

  @override
  String get saveTo => '저장 위치';

  @override
  String get saveToChange => '변경…';

  @override
  String get saveToDefault => '다운로드(기본값)';

  @override
  String get saveToUseDefault => '다운로드 폴더 사용';

  @override
  String get receiveNotify => '파일이 도착하면 알림';

  @override
  String receiveFootnote(String device) {
    return '페어링된 기기만 $device(으)로 파일을 보낼 수 있습니다. 파일을 전송하는 동안 $device은(는) 자동으로 잠자기 상태가 되지 않습니다.';
  }

  @override
  String get saveDirNotFound => '이 폴더가 존재하지 않습니다.';

  @override
  String get saveDirNotWritable => 'PasteFerry가 이 폴더에 파일을 저장할 수 없습니다.';

  @override
  String get saveDirPermission =>
      'PasteFerry에 이 폴더를 사용할 권한이 없습니다. 시스템 설정 → 개인정보 보호 및 보안 → 파일 및 폴더에서 허용하세요.';

  @override
  String transferRenamed(int count) {
    return '파일 이름 $count개에 Windows에서 허용하지 않는 문자가 있어 비슷한 전각 문자로 바꿨습니다';
  }

  @override
  String get sendRingLan => '같은 네트워크';

  @override
  String get sendRingOther => '다른 네트워크';

  @override
  String sendOfflineList(String names) {
    return '오프라인: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => '전송 목록';

  @override
  String get sendLayoutSide => '레이더 옆';

  @override
  String get sendLayoutBelow => '레이더 아래';

  @override
  String get general => '일반';

  @override
  String get launchAtLogin => '로그인 시 실행';

  @override
  String get launchAtLoginDesc =>
      '로그인하면 백그라운드에서 시작합니다. 이 설정을 바꿔도 현재 실행은 중지되지 않습니다.';

  @override
  String get realtimeSync => '실시간 클립보드 동기화';

  @override
  String get realtimeSyncDesc =>
      '새로 복사한 내용을 페어링된 기기와 자동으로 공유합니다. 꺼도 로컬 기록과 파일 보내기는 계속 사용할 수 있습니다.';

  @override
  String get syncBacklog => '다시 연결된 후 밀린 항목 받기';

  @override
  String get syncBacklogDesc =>
      '기본값은 꺼짐으로, 놓친 복사 항목은 건너뜁니다. 켜면 최근 24시간 동안의 항목이 최대 20개까지 클립보드를 바꾸지 않고 기록에 추가됩니다.';

  @override
  String get peerRealtimeSync => '이 컴퓨터와 동기화';

  @override
  String get syncPaused => '클립보드 동기화 일시 중지됨';

  @override
  String get quitApp => 'PasteFerry 종료';

  @override
  String get quitAppDesc => 'PasteFerry의 모든 프로세스를 중지합니다. 로그인 시 실행 설정은 유지됩니다.';

  @override
  String get quitTransfersWarning => '아직 파일을 전송하고 있습니다. 종료하고 전송을 중단하시겠습니까?';

  @override
  String get backgroundRunningTitle => 'PasteFerry가 계속 실행됩니다';

  @override
  String get backgroundRunningBody =>
      '윈도우를 닫아도 동기화와 빠른 붙여넣기는 계속 실행됩니다. 모두 중지하려면 설정이나 앱 메뉴에서 ‘PasteFerry 종료’를 선택하세요.';

  @override
  String get displayAs => '표시 이름';

  @override
  String get editName => '이름 변경';

  @override
  String get nameHint => '연락처에 표시되는 이름';

  @override
  String get nameDefaultHint => '비워 두면 계정 이름을 사용합니다.';

  @override
  String get avatarTitle => '프로필 사진';

  @override
  String get avatarChoose => '이미지 선택…';

  @override
  String get avatarPaste => '이미지 붙여넣기';

  @override
  String get avatarReset => '기본 사진 사용';

  @override
  String get avatarZoom => '확대/축소';

  @override
  String get avatarDragHint => '드래그하여 사진을 이동하세요.';

  @override
  String get avatarNoImage => '클립보드에 이미지가 없습니다.';

  @override
  String get avatarBad => '이 이미지는 사용할 수 없습니다. PNG, JPEG 또는 GIF를 선택하세요.';

  @override
  String get done => '완료';

  @override
  String get friendsTitle => '연락처';

  @override
  String get addFriend => '연락처 추가';

  @override
  String get friendsEmpty => '아직 연락처가 없음';

  @override
  String get friendsEmptyBody =>
      'PasteFerry를 사용하는 다른 사람을 추가하면 페어링 없이 서로 파일을 보낼 수 있습니다. 연락처는 파일만 보낼 수 있으며 클립보드는 볼 수 없습니다.';

  @override
  String get friendSendAction => '보내기…';

  @override
  String get friendHistory => '전송 기록';

  @override
  String friendHistoryTitle(String name) {
    return '$name과(와)의 전송 기록';
  }

  @override
  String get friendHistoryEmpty => '아직 전송 기록이 없습니다.';

  @override
  String get friendAutoAccept => '파일 자동 수락';

  @override
  String get friendRemove => '연락처 삭제';

  @override
  String friendRemoveTitle(String name) {
    return '$name을(를) 삭제하시겠습니까?';
  }

  @override
  String get friendRemoveBody =>
      '서로의 연락처에서 삭제되어 더 이상 파일을 주고받을 수 없습니다. 이전 전송 기록은 이 컴퓨터에 남아 있습니다.';

  @override
  String friendLastActivity(String time) {
    return '마지막 전송: $time';
  }

  @override
  String get friendNoActivity => '아직 전송 기록 없음';

  @override
  String get friendCodeShare =>
      '이 코드를 상대에게 보내세요. 상대가 PasteFerry에 입력하면 서로의 연락처에 추가됩니다.';

  @override
  String friendCodeExpires(String time) {
    return '$time 후 만료';
  }

  @override
  String get friendCodeOr => '또는';

  @override
  String get friendCodeEnter => '상대의 연락처 코드 입력';

  @override
  String get friendCodeAdd => '추가';

  @override
  String get friendCodeWaiting => '상대가 입력하기를 기다리는 중…';

  @override
  String friendConfirmBody(String name) {
    return '$name을(를) 연락처에 추가하시겠습니까?';
  }

  @override
  String get friendSafetyCode => '안전 코드 확인(선택 사항)';

  @override
  String get friendSafetyHint =>
      '함께 있을 때 이 두 줄을 비교해 보세요. 두 컴퓨터에서 일치하면 아무도 중간에 개입하지 않은 것입니다.';

  @override
  String get friendWaitingPeer => '상대가 추가하기를 기다리는 중…';

  @override
  String friendAdded(String name) {
    return '$name을(를) 연락처에 추가했습니다';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name이(가) 취소했습니다';
  }

  @override
  String get friendErrFriendCode => '연락처 코드입니다. 파일 보내기 화면의 ‘연락처 추가’에서 입력하세요.';

  @override
  String get friendErrDeviceCode => '페어링 코드입니다. 기기 → 기기 추가에서 입력하세요.';

  @override
  String get friendErrOutdated => '상대가 PasteFerry 2.6.0 이상을 사용해야 합니다.';

  @override
  String get friendErrAlreadyPaired => '해당 컴퓨터는 이미 내 기기입니다.';

  @override
  String get friendErrNoChannel =>
      '같은 네트워크에 있지 않습니다. 서로 추가하려면 두 컴퓨터 모두에서 서비스를 켜세요.';

  @override
  String get openService => '서비스 켜기…';

  @override
  String get noteLabel => '메모(선택 사항)';

  @override
  String get noteHintEmpty => '먼저 파일을 선택하세요';

  @override
  String get noteHint => '예: 3페이지에 서명해 주세요';

  @override
  String noteLine(String note) {
    return '메모: $note';
  }

  @override
  String get sendAction => '보내기';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count개 항목 · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return '파일이나 이미지를 여기에 놓거나 붙여넣으세요($key)';
  }

  @override
  String get sendDropMorePaste => '더 놓거나 붙여넣기';

  @override
  String get sendPasteNothing => '붙여넣을 항목이 없습니다. 먼저 파일이나 이미지를 복사하세요.';

  @override
  String get sendRemoveItem => '제거';

  @override
  String sendFriendSaved(String name) {
    return '$name이(가) 매번 수락해야 전송이 시작됩니다.';
  }

  @override
  String transferAskingOut(String name) {
    return '$name의 수락을 기다리는 중…';
  }

  @override
  String get transferAskingIn => '수락 대기 중';

  @override
  String reasonDeclined(String name) {
    return '$name이(가) 거절했습니다';
  }

  @override
  String reasonTimeout(String name) {
    return '$name이(가) 응답하지 않았습니다';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name은(는) 파일을 받지 않습니다';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name이(가) 지금은 내 파일을 받지 않습니다';
  }

  @override
  String get reasonYouDeclined => '거절함';

  @override
  String get reasonYouIgnored => '무시함';

  @override
  String get sendAgain => '다시 보내기';

  @override
  String incomingTitle(String name) {
    return '$name에서 파일을 보내려고 합니다';
  }

  @override
  String get incomingAlways => '이 연락처의 파일을 항상 수락';

  @override
  String get incomingDecline => '거절';

  @override
  String get incomingAccept => '수락';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds초 후 자동으로 거절';
  }

  @override
  String get incomingStranger => '주변';

  @override
  String get friendsStrip => '연락처';

  @override
  String get strangersStrip => '‘모든 사람’이 켜진 주변 기기';

  @override
  String get strangerNearby => '주변';

  @override
  String get friendNeedService => '서비스 켜기';

  @override
  String get friendCantReach => '연결할 수 없음';

  @override
  String reachSelfNoService(String name) {
    return '나와 $name은(는) 같은 네트워크에 있지 않습니다. 파일을 보내려면 서비스를 켜세요. 직접 연결할 수 없으면 서비스 중계를 거쳐 전송됩니다.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name이(가) 서비스를 켜지 않아 같은 네트워크에서만 파일을 보낼 수 있습니다. 상대에게 PasteFerry에서 서비스를 켜 달라고 요청하세요.';
  }

  @override
  String get reachDifferentServer =>
      '같은 서버를 사용하고 있지 않습니다. 파일을 보내려면 두 컴퓨터 모두에서 서비스를 켜거나 같은 서버를 사용하세요.';

  @override
  String get receiveFromLabel => '파일을 보낼 수 있는 사람:';

  @override
  String get receiveFromOff => '없음';

  @override
  String get receiveFromFriends => '연락처만';

  @override
  String get receiveFromEveryone => '모든 사람';

  @override
  String everyoneLeft(String minutes) {
    return '모든 사람 · $minutes분 남음';
  }

  @override
  String get receiveFromOffDesc => '내가 페어링한 컴퓨터만 파일을 보낼 수 있습니다.';

  @override
  String get receiveFromFriendsDesc => '연락처가 파일을 보낼 수 있습니다. 매번 직접 수락합니다.';

  @override
  String get receiveFromEveryoneDesc =>
      '같은 네트워크의 누구나 10분 동안 파일을 보낼 수 있습니다. 매번 직접 수락합니다.';

  @override
  String get everyoneEnded => '‘모든 사람’이 꺼지고 ‘연락처만’으로 돌아갔습니다.';

  @override
  String get friendsCountTooltip => '연락처';

  @override
  String get waitingAccept => '대기 중…';

  @override
  String get settingsConnection => '연결';

  @override
  String get settingsGeneralSummary => '로그인 시 실행, 기기 이름, 언어';

  @override
  String get settingsConnectionSummary => '서비스, 내 서버, 로컬 네트워크';

  @override
  String get settingsSyncSummary => '실시간 동기화, 크기 한도, 동기화할 항목';

  @override
  String get settingsQuickPasteSummary => '단축키와 항목 선택 후 동작';

  @override
  String get settingsSendSummary => '파일 받기, 저장 위치';

  @override
  String get settingsStorageSummary => '기록 보관 기간, 사용 중인 공간';

  @override
  String get settingsAboutSummary => '버전, 업데이트, 피드백';

  @override
  String get friendsSubtitle => '페어링 없이 다른 사람의 컴퓨터로 파일 보내기';

  @override
  String get friendsSearch => '연락처 검색';

  @override
  String get friendsNoMatch => '일치하는 연락처 없음';

  @override
  String get friendsPick => '연락처를 선택하여 전송 기록을 보거나 파일을 보내세요';

  @override
  String friendDropHint(String name) {
    return '여기에 파일을 놓으면 $name에게 보냅니다';
  }

  @override
  String get webShareTitle => '휴대폰 웹 전송';

  @override
  String get webShareFootnote =>
      '휴대폰으로 QR 코드를 스캔하면 앱 없이 브라우저에서 이 컴퓨터와 텍스트, 사진, 파일을 주고받을 수 있습니다. 휴대폰과 컴퓨터가 같은 네트워크에 있어야 합니다.';

  @override
  String get webShareSwitch => '휴대폰의 브라우저 연결 허용';

  @override
  String webShareOn(int count) {
    return '켜짐, 휴대폰 $count대';
  }

  @override
  String get webShareOff => '꺼짐';

  @override
  String get webShareShowQr => 'QR 코드 보기';

  @override
  String get webShareDialogTitle => '휴대폰으로 스캔';

  @override
  String get webShareDialogBody =>
      '휴대폰의 카메라나 브라우저로 스캔한 다음 브라우저에서 여세요. QR 코드 하나로 휴대폰 한 대를 등록하며, 사용하면 새 코드로 바뀝니다.';

  @override
  String get webShareAddress => '주소';

  @override
  String get webShareSecurity =>
      '내용은 페이지 안에서 암호화되므로 같은 네트워크의 다른 사람이 읽을 수 없습니다. 하지만 페이지 자체는 http이므로 누군가 의도적으로 변조하는 것은 막을 수 없습니다. 공용 Wi‑Fi가 아닌 집이나 신뢰할 수 있는 사무실 네트워크에서 사용하세요.';

  @override
  String get webSharePhones => '등록된 휴대폰';

  @override
  String get webShareNoPhones => '아직 등록된 휴대폰 없음';

  @override
  String webShareLastUsed(String time) {
    return '마지막 사용: $time';
  }

  @override
  String get webShareRemove => '제거';

  @override
  String webShareRemoved(String name) {
    return '“$name”을(를) 제거했습니다';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name”이(가) 등록되었습니다';
  }

  @override
  String webShareNotListening(String error) {
    return '수신을 시작할 수 없습니다: $error';
  }

  @override
  String get webSharePortFallback =>
      '평소 사용하는 포트가 사용 중이어서 임시 포트를 사용합니다. 휴대폰에서 다시 스캔하기 전까지 저장해 둔 주소는 열리지 않습니다.';

  @override
  String get webShareNoAddress => '로컬 네트워크 주소가 없습니다. 먼저 Wi‑Fi나 유선 네트워크에 연결하세요.';

  @override
  String get webShareCantOpen =>
      '휴대폰에서 페이지가 열리지 않으면 두 기기가 같은 네트워크에 있는지 확인하세요(게스트 네트워크에서는 보통 작동하지 않습니다). Windows에서는 방화벽에서 PasteFerry도 허용해야 합니다.';

  @override
  String get mTabRecords => '기록';

  @override
  String get mTabSend => '보내기';

  @override
  String get mThisPhone => '이 휴대폰';

  @override
  String get mThisPhoneInText => '이 휴대폰';

  @override
  String mThisPhoneName(String name) {
    return '이 휴대폰: $name';
  }

  @override
  String get mSendTitle => '컴퓨터로 보내기';

  @override
  String get mSendHint => '텍스트를 입력하거나 붙여넣으세요';

  @override
  String get mPaste => '붙여넣기';

  @override
  String get mPhotosFiles => '사진 또는 파일';

  @override
  String mSendConfirmTitle(Object n) {
    return '파일 $n개를 보내시겠습니까?';
  }

  @override
  String mFilesSent(num n) {
    return '파일 $n개를 컴퓨터로 보냈습니다';
  }

  @override
  String get mClipboardNoText => '클립보드에 텍스트가 없습니다';

  @override
  String get mSendAction => '보내기';

  @override
  String mSendTo(String names) {
    return '받는 기기: $names';
  }

  @override
  String get mNoOnlineDevices => '주변에 온라인 기기 없음';

  @override
  String get mNoPairedDevices => '먼저 컴퓨터와 페어링하세요';

  @override
  String get mSent => '보냄';

  @override
  String get mSendFootnote =>
      '텍스트와 파일은 컴퓨터의 기록에 추가되며, 컴퓨터 설정에 따라 클립보드에도 들어갑니다. 휴대폰에서 복사한 내용은 자동으로 보내지지 않습니다.';

  @override
  String get mSentRecords => '보낸 항목';

  @override
  String get mSentRetention => '보낸 항목 보관';

  @override
  String mSentRetentionDesc(Object d) {
    return '‘보낸 항목’에는 최근 $d일 동안 이 휴대폰에서 보낸 내용이 표시됩니다';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d일';
  }

  @override
  String get mViewAll => '모두 보기';

  @override
  String get mClearCache => '지우기';

  @override
  String get mCheckUpdate => '업데이트 확인';

  @override
  String get mUpdateFailed => '업데이트를 확인할 수 없습니다';

  @override
  String get mUpToDate => '최신 버전입니다';

  @override
  String mNewVersion(Object v) {
    return '버전 $v 사용 가능';
  }

  @override
  String get mDownloadInstall => '새 버전 다운로드';

  @override
  String mSendFailed(String detail) {
    return '보낼 수 없습니다: $detail';
  }

  @override
  String get mCopy => '복사';

  @override
  String get mCopied => '이 휴대폰의 클립보드에 복사했습니다';

  @override
  String get mShare => '공유';

  @override
  String get mSaved => '사진 또는 Download/PasteFerry에 저장했습니다';

  @override
  String mActionFailed(String detail) {
    return '실패했습니다: $detail';
  }

  @override
  String get mDownloading => '다운로드 중…';

  @override
  String get mNotDownloaded => '아직 다운로드하지 않음';

  @override
  String get mDownloadHint => '복사, 저장 또는 공유를 탭하면 먼저 다운로드합니다.';

  @override
  String get mFullTextLoading => '불러오는 중…';

  @override
  String mTextTruncated(int shown, int total) {
    return '전체 $total자 중 처음 $shown자만 표시합니다. 복사하면 전체가 복사됩니다.';
  }

  @override
  String get mNotOnLanTitle => 'Wi‑Fi에 연결되지 않음';

  @override
  String get mNotOnLanBody =>
      '현재 PasteFerry는 로컬 네트워크에서만 동기화합니다. 컴퓨터와 같은 Wi‑Fi에 연결하세요.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry를 시작할 수 없습니다: $detail';
  }

  @override
  String get mNoDevicesBody =>
      '컴퓨터에서 PasteFerry → 기기 → 기기 추가를 연 다음, 표시되는 코드를 여기에 입력하세요. 같은 Wi‑Fi에 있다면 양쪽에서 ‘주변 기기 검색’을 열어도 됩니다.';

  @override
  String get mSectionSync => '동기화';

  @override
  String get mSectionBackground => '백그라운드';

  @override
  String get mAutoApplyDesc =>
      '컴퓨터에서 복사한 텍스트가 바로 이 휴대폰의 클립보드에 들어갑니다. 이미지와 파일은 복사를 탭할 때까지 기다립니다.';

  @override
  String get mKeepAlive => '백그라운드에서 연결 유지';

  @override
  String get mKeepAliveDesc => 'PasteFerry를 열지 않아도 텍스트를 받습니다. 상시 알림이 표시됩니다.';

  @override
  String get mNotifications => '알림';

  @override
  String get mNotificationsDesc => '상시 알림에 필요합니다. 허용하지 않아도 PasteFerry는 작동합니다.';

  @override
  String get mBattery => '백그라운드에서 실행';

  @override
  String get mBatteryDesc =>
      '화면이 잠겼을 때 시스템이 PasteFerry를 중지하지 않도록 배터리 최적화를 끄세요. 일부 휴대폰은 설정에서 PasteFerry를 자동 실행 또는 백그라운드 목록에 추가해야 합니다.';

  @override
  String get mAllowed => '허용됨';

  @override
  String get mAllow => '허용';

  @override
  String mVersion(String version) {
    return '버전 $version';
  }

  @override
  String get mDeleteConfirm => '이 항목을 삭제하시겠습니까?';

  @override
  String get mDelete => '삭제';

  @override
  String get webShareFirewallPreparing =>
      'Windows 방화벽을 확인하는 중입니다. Windows에서 관리자 승인을 요청하면 휴대폰이 연결될 수 있도록 ‘예’를 선택하세요.';

  @override
  String get webShareFirewallReady =>
      'Windows 방화벽 규칙이 준비되었습니다. 휴대폰을 같은 네트워크에 연결하고 QR 코드를 스캔하세요. 그래도 연결되지 않으면 아래에서 방화벽을 다시 확인하세요.';

  @override
  String get webShareFirewallFailed =>
      '방화벽 설정이 완료되지 않아 휴대폰에서 페이지를 열지 못할 수 있습니다. 다시 시도하고 Windows 관리자 승인 요청을 허용하세요.';

  @override
  String get webShareFirewallAllow => '확인 후 휴대폰 연결 허용';

  @override
  String get mCopyMediaFailed => '이 이미지나 파일을 복사할 수 없습니다. 먼저 저장해 보세요.';

  @override
  String get mShareMediaFailed => '이 이미지나 파일의 공유를 열 수 없습니다. 먼저 저장해 보세요.';

  @override
  String get mSaveMediaFailed =>
      '이 이미지나 파일을 저장할 수 없습니다. 저장 공간 접근 권한과 여유 공간을 확인한 후 다시 시도하세요.';

  @override
  String get noticeFilesUnreadable => '방금 복사한 파일을 읽을 수 없어 아무것도 동기화되지 않았습니다';

  @override
  String get mAddMore => '더 추가';

  @override
  String get mChoosePhotos => '사진 선택…';

  @override
  String get mMultiSelectHint =>
      '사진은 한 번에 여러 장 선택할 수 있습니다. 파일에서는 항목을 길게 터치하면 더 선택할 수 있습니다.';

  @override
  String get webSendFiles => '파일 보내기';

  @override
  String get webFilesQueued => '웹 전송에 추가했습니다. 휴대폰에서 파일 보내기를 열어 다운로드하세요.';

  @override
  String get webFilesLimit => '웹 다운로드는 파일당 최대 200MB, 한 번에 최대 64개 파일까지 지원합니다.';

  @override
  String get appearance => '모양';

  @override
  String get settingsAppearanceSummary => '테마, 라이트 및 다크';

  @override
  String get themeTitle => '테마';

  @override
  String get themeDefault => '기본';

  @override
  String get themePixel => '픽셀';

  @override
  String get themeMode => '라이트 및 다크';

  @override
  String get themeModeSystem => '시스템 설정';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeDark => '다크';

  @override
  String get themeCustom => '사용자 지정';

  @override
  String get themeDelete => '테마 삭제';

  @override
  String themeDeleteConfirm(String name) {
    return '“$name” 테마를 삭제하시겠습니까?';
  }

  @override
  String get themeLowContrast => '이 테마의 일부 텍스트는 읽기 어려울 수 있습니다';

  @override
  String get themeFootnote =>
      '테마는 빠른 붙여넣기를 포함해 이 기기에만 적용되며, 다른 기기와 동기화되지 않습니다.';

  @override
  String get themeBuiltinGroup => '기본 제공';

  @override
  String get themeCustomGroup => '사용자 지정';

  @override
  String get themeUse => '사용';

  @override
  String get themeDuplicate => '복제';

  @override
  String themeCopyName(String name) {
    return '$name 사본';
  }

  @override
  String get themeExport => '내보내기…';

  @override
  String get themeImport => '테마 가져오기…';

  @override
  String themeImported(String name) {
    return '“$name”을(를) 가져왔습니다';
  }

  @override
  String themeImportedWarn(String name, int count) {
    return '“$name”을(를) 가져왔습니다. 텍스트 색상 $count개는 읽기 어려울 수 있습니다.';
  }

  @override
  String get themeExported => '테마를 내보냈습니다';

  @override
  String get themeCustomEmpty =>
      '아직 사용자 지정 테마가 없습니다. 기본 제공 테마를 복제하거나, 테마를 가져오거나, AI에게 만들어 달라고 요청하세요.';

  @override
  String get themeAskAi => 'AI에게 테마 만들기 요청';

  @override
  String get themeAskAiBody =>
      '이 MCP 서버를 Claude나 Cursor 같은 AI 앱에 추가한 다음, “사이버펑크 테마를 만들어 줘”처럼 테마를 요청하세요. AI가 테마 형식을 읽고 색상을 고르고 대비를 확인한 뒤 테마를 적용합니다.';

  @override
  String get themeAskAiCopy => '구성 복사';

  @override
  String get themeAskAiCopied => '구성을 복사했습니다';

  @override
  String get themeScanlines => '스캔라인';

  @override
  String get themeScanlinesDesc =>
      '윈도우에 희미한 CRT 스캔라인을 겹쳐 표시합니다. 픽셀 테마에서만 적용됩니다.';

  @override
  String get themeBackground => '배경 이미지';

  @override
  String get themeBackgroundDesc =>
      '사이드바와 페이지 뒤의 윈도우 전체를 채웁니다. 위에 덮는 반투명 막이 텍스트를 읽기 쉽게 유지합니다.';

  @override
  String get themeBackgroundChoose => '이미지 선택…';

  @override
  String get themeBackgroundChange => '변경…';

  @override
  String get themeBackgroundRemove => '제거';

  @override
  String get themeBlur => '흐림';

  @override
  String get themeBlurNone => '없음';

  @override
  String get themeBlurLight => '약하게';

  @override
  String get themeBlurStrong => '강하게';

  @override
  String get themeScrim => '반투명 막';

  @override
  String get themeScrimDesc =>
      '텍스트를 읽기 쉽도록 이미지 위에 덮는 색입니다. 필요한 정도보다 옅어지지 않습니다.';

  @override
  String get themeScrimAuto => '자동';

  @override
  String get themeScrimMore => '더 진하게';

  @override
  String get themeScrimMost => '가장 진하게';

  @override
  String get themePanels => '패널';

  @override
  String get themePanelsDesc => '사이드바와 목록에 이미지가 비치는 정도입니다.';

  @override
  String get themePanelsClear => '투명';

  @override
  String get themePanelsMedium => '중간';

  @override
  String get themePanelsSolid => '불투명';

  @override
  String get themeAccentFromImage => '이미지 색상 사용';

  @override
  String get themeAccentFromImageDesc => '이미지에서 강조 색상을 가져옵니다.';

  @override
  String get themeBackgroundPicker => '빠른 붙여넣기에도 표시';

  @override
  String get themeScenery => '풍경 표시';

  @override
  String get themeSceneryDesc => '페이지 상단과 사이드바 하단의 그림입니다.';

  @override
  String themeCopiedForEdit(String name) {
    return '기본 제공 테마는 변경할 수 없어 “$name”(이)라는 사본을 만들어 적용했습니다';
  }

  @override
  String get themeBackgroundFootnote =>
      '배경은 현재 테마에 속합니다. 기본 제공 테마는 변경할 수 없으므로 처음 변경할 때 사본이 만들어집니다. 이미지는 이 기기에만 저장되며 JPEG, PNG, GIF를 지원합니다.';

  @override
  String get themeSceneGroup => '풍경';

  @override
  String get themeSceneHeader => '페이지 상단';

  @override
  String get themeSceneHeaderDesc =>
      '페이지 제목 뒤에 깔리는 넓은 그림으로, 아래쪽은 페이지로 서서히 사라집니다. 픽셀 테마는 여기에 픽셀 풍경을 그립니다.';

  @override
  String get themeSceneSidebar => '사이드바 하단';

  @override
  String get themeSceneSidebarDesc =>
      '사이드바 하단의 작은 그림입니다. 픽셀 테마는 여기에 작은 캠프를 그립니다.';

  @override
  String get themeSceneReset => '재설정';

  @override
  String get themeSceneFootnote =>
      '어떤 테마든 여기에 직접 고른 그림을 표시할 수 있습니다. 반투명 막이 페이지 제목을 읽기 쉽게 유지합니다. 배경 이미지가 윈도우를 채우는 동안에는 풍경이 숨겨집니다.';

  @override
  String get starTitle => 'PasteFerry가 마음에 드시나요?';

  @override
  String get starBody => '마음에 드신다면 GitHub에서 별표를 눌러 주시면 큰 힘이 됩니다.';

  @override
  String get starAction => 'GitHub에서 별표 누르기';

  @override
  String get starLater => '나중에';

  @override
  String get starDismiss => '다시 표시하지 않음';
}
