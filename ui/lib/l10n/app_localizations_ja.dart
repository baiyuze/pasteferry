// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => '履歴';

  @override
  String get navDevices => 'デバイス';

  @override
  String get navSettings => '設定';

  @override
  String get navFavorites => 'お気に入り';

  @override
  String get linkConnecting => '接続中…';

  @override
  String get linkServiceNotRunning => 'サービス停止中';

  @override
  String get linkLanMode => 'このネットワークでデバイスを探しています';

  @override
  String get linkServerUnreachable => 'サーバーに接続できません。このネットワーク内では同期します';

  @override
  String get linkNothingOn => 'ローカルネットワークの検出がオフで、サーバーも未設定です';

  @override
  String get linkLanBlocked => 'macOS がローカルネットワークをブロックしています';

  @override
  String linkOnlinePeers(int count) {
    return '$count 台がオンライン';
  }

  @override
  String get linkServerConnected => 'サーバーに接続済み';

  @override
  String linkConnectionLost(String detail) {
    return '接続が切れました：$detail';
  }

  @override
  String get linkServiceDisconnected => 'サービスとの接続が切れました';

  @override
  String get linkServiceDisabled => '同期はオフです';

  @override
  String get errServiceNotConnected => 'バックグラウンドサービスに接続していません';

  @override
  String get errUnimplemented => 'この機能はまだ使えません';

  @override
  String get errUnavailable => 'バックグラウンドサービスに接続できません';

  @override
  String errServiceStart(String detail) {
    return 'バックグラウンドサービスを起動できませんでした：$detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'バックグラウンドサービスを再起動できませんでした：$detail';
  }

  @override
  String errAutostart(String detail) {
    return 'ログイン時の自動起動を設定できませんでした：$detail';
  }

  @override
  String get thisMacTitle => 'この Mac';

  @override
  String get thisPcTitle => 'このコンピューター';

  @override
  String get thisMacInText => 'この Mac ';

  @override
  String get thisPcInText => 'このコンピューター';

  @override
  String get bothMacs => '両方の Mac ';

  @override
  String get bothDevices => '両方のデバイス';

  @override
  String get thisDeviceShort => 'このデバイス';

  @override
  String fromDevice(String name) {
    return '$name から';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get close => '閉じる';

  @override
  String get save => '保存';

  @override
  String get retry => '再試行';

  @override
  String get continueAction => '続ける';

  @override
  String get justNow => 'たった今';

  @override
  String secondsAgo(int n) {
    return '$n 秒前';
  }

  @override
  String minutesAgo(int n) {
    return '$n 分前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 時間前';
  }

  @override
  String daysAgo(int n) {
    return '$n 日前';
  }

  @override
  String monthDay(int month, int day) {
    return '$month月$day日';
  }

  @override
  String durationHours(int n) {
    return '$n 時間';
  }

  @override
  String durationDays(int n) {
    return '$n 日';
  }

  @override
  String get historyEmptySubtitle => 'どのデバイスでコピーしても、ここに表示されます';

  @override
  String historyCount(int count) {
    return '$count 件';
  }

  @override
  String historyCountKept(int count, String ttl) {
    return '$count 件、$ttl保存';
  }

  @override
  String get filterAll => 'すべて';

  @override
  String get filterText => 'テキスト';

  @override
  String get filterImage => '画像';

  @override
  String get filterFile => 'ファイル';

  @override
  String get filterLink => 'リンク';

  @override
  String get historyClearTooltip => '履歴を消去';

  @override
  String get historyEmptyTitle => 'まだ履歴がありません';

  @override
  String get historyEmptyFilteredTitle => 'この種類の履歴はありません';

  @override
  String get historyEmptyBody => 'ペアリングしたどのデバイスでテキスト、画像、ファイルをコピーしても、ここに表示されます。';

  @override
  String get clearConfirmTitle => '履歴をすべて消去しますか？';

  @override
  String clearConfirmBody(String device) {
    return '同期した履歴とキャッシュしたファイルが$deviceから削除されます。元のファイルには影響しません。';
  }

  @override
  String get clear => '消去';

  @override
  String get historyCleared => '履歴を消去しました';

  @override
  String get permDeniedTitle => 'PasteFerry はクリップボードを読み取れません';

  @override
  String get permAskTitle => 'PasteFerry にクリップボードの読み取りを許可してください';

  @override
  String get permDeniedBody =>
      'この Mac でコピーした内容は同期されません。システム設定で PasteFerry Daemon を「許可」にしてください。';

  @override
  String get permAskBody =>
      '許可しないと macOS が毎回確認します。システム設定で PasteFerry Daemon を「許可」にしてください。';

  @override
  String get openSystemSettings => 'システム設定を開く';

  @override
  String get fetch => '受信';

  @override
  String get fetchStarted => '受信中…進捗は履歴で確認できます';

  @override
  String get transferFailed => '転送に失敗しました';

  @override
  String get expired => '期限切れ';

  @override
  String get putOnClipboard => 'クリップボードに入れる';

  @override
  String get putOnClipboardDone => 'クリップボードに入れました';

  @override
  String get deleteRecord => 'この履歴を削除';

  @override
  String get deleted => '削除しました';

  @override
  String get emptyRecord => '（空）';

  @override
  String get imageRecord => '画像';

  @override
  String itemsSummary(String name, int others, int count) {
    return '$name ほか $others 件';
  }

  @override
  String get searchHint => 'テキストとファイル名を検索';

  @override
  String get searchClear => '検索をクリア';

  @override
  String searchResultCount(int count) {
    return '$count 件見つかりました';
  }

  @override
  String searchEmptyTitle(String query) {
    return '「$query」は見つかりません';
  }

  @override
  String get searchEmptyBody => 'コピーしたテキストとファイル名から検索します。';

  @override
  String get favoriteAction => 'お気に入りに追加';

  @override
  String get unfavoriteAction => 'お気に入りから外す';

  @override
  String get favoritedToast => 'お気に入りに追加しました';

  @override
  String get unfavoritedToast => '履歴に戻しました';

  @override
  String get undo => '元に戻す';

  @override
  String get favoriteSaving => '保存中…';

  @override
  String favoritedAt(String date) {
    return '$date に保存';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    return '$count 件・自動では削除されません・最大 $size';
  }

  @override
  String get favoritesEmptyTitle => 'お気に入りはまだありません';

  @override
  String get favoritesEmptyBody =>
      '履歴で星をクリックすると、ここにコピーが保存されます。お気に入りは自動では削除されません。';

  @override
  String get favoritesSearchHint => 'お気に入りを検索';

  @override
  String favoriteLargeTitle(String size) {
    return '$size のコピーを保存しますか？';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'お気に入りは独自のコピーを保存するため、元のファイルを変更・削除しても影響を受けません。$deviceの $size を使用します。';
  }

  @override
  String get saveCopy => '保存';

  @override
  String clearKeepsFavorites(int count) {
    return 'お気に入りの $count 件は残ります。';
  }

  @override
  String get favoritesUsage => 'お気に入りの使用量';

  @override
  String get favoritesUsageDesc => 'お気に入りは上の設定にかかわらず自動では削除されません';

  @override
  String upToSize(String size) {
    return '最大 $size';
  }

  @override
  String detailChars(int count) {
    return '$count 文字';
  }

  @override
  String detailTruncated(int count) {
    return '…（全 $count 文字）';
  }

  @override
  String detailMoreFiles(int count) {
    return 'ほか $count 件';
  }

  @override
  String get detailReceiveFirst => '選ぶと先にダウンロードします';

  @override
  String detailTotalSize(String size) {
    return '合計 $size';
  }

  @override
  String get quickPaste => 'クイックペースト';

  @override
  String get quickPasteWindow => 'クイックペーストウィンドウ';

  @override
  String get quickPasteWindowDesc => 'どのアプリでもショートカットで履歴を表示し、選ぶとペーストします';

  @override
  String get quickPasteShortcut => 'ショートカット';

  @override
  String get quickPasteRecord => 'クリックして変更';

  @override
  String get quickPasteRecording => '新しいショートカットを押してください…';

  @override
  String get quickPasteUseDefault => 'デフォルトに戻す';

  @override
  String get quickPasteNeedsModifier => '⌃、⌥、⇧、⌘ のいずれかを含めるか、ファンクションキーを使ってください';

  @override
  String get quickPasteNeedsModifierPc =>
      'Ctrl、Alt、Shift、Windows キーのいずれかを含めるか、ファンクションキーを使ってください';

  @override
  String get quickPasteAfterPick => '選んだ後';

  @override
  String get quickPastePasteIt => 'ペーストする';

  @override
  String get quickPasteCopyIt => 'コピーのみ';

  @override
  String get quickPasteIndexKey => '最初の 9 件を選ぶ';

  @override
  String get quickPasteIndexKeyDesc => 'クイックペーストウィンドウでこのキーを押しながら 1〜9 を押します';

  @override
  String get quickPasteAccessibility => 'アクセシビリティ';

  @override
  String get quickPasteAccessibilityDesc =>
      'ペーストするのに必要です。許可しない場合はコピーだけされ、⌘V で貼り付けます。';

  @override
  String get quickPasteAllowed => '許可済み';

  @override
  String get quickPasteAllow => '許可する…';

  @override
  String get quickPasteNotRunning => 'クイックペーストウィンドウが起動していません';

  @override
  String quickPasteInUse(String key) {
    return '$key は別のアプリが使用しています。別のショートカットを選んでください。';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return '$key を設定できませんでした：$detail';
  }

  @override
  String get quickPastePortalKey => 'システムのショートカット設定で変更します';

  @override
  String get quickPasteWaylandDesc =>
      'Wayland ではデスクトップのキーボード設定でショートカットを追加します。選ぶとコピーされるので、Ctrl+V で貼り付けてください。';

  @override
  String get quickPasteAddShortcut => 'システムのショートカットを追加';

  @override
  String quickPasteShortcutAdded(String key) {
    return '追加しました。$key を押して試してください。';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'デスクトップのキーボード設定で、次のコマンドを実行するカスタムショートカットを追加してください：$command';
  }

  @override
  String get pickerSearch => '検索';

  @override
  String get pickerPaste => 'ペースト';

  @override
  String get pickerPlainText => 'プレーンテキスト';

  @override
  String get pickerCopyOnly => 'コピーのみ';

  @override
  String get pickerUnfavoriteHint => 'お気に入りから外す（履歴に戻す）';

  @override
  String pickerPasteManually(String key) {
    return '選ぶとコピーされます。$key で貼り付けてください';
  }

  @override
  String get pickerGrantHint => 'アクセシビリティを許可すると直接ペーストできます';

  @override
  String pickerElevated(String key) {
    return 'このウィンドウは管理者として実行中です。選んだあと $key で貼り付けてください';
  }

  @override
  String get pickerDownloading => 'ダウンロード中。完了するとペーストします';

  @override
  String get imagePreviewTitle => '画像プレビュー';

  @override
  String get closePreview => 'プレビューを閉じる';

  @override
  String get previousImage => '前の画像';

  @override
  String get nextImage => '次の画像';

  @override
  String get previewHint => 'ホイールやトラックパッドで拡大縮小、ドラッグで移動';

  @override
  String get fitWindow => 'ウィンドウに合わせる';

  @override
  String get previewDeleted => 'この画像は履歴から削除されました';

  @override
  String get previewExpired => 'この画像は期限切れのためプレビューできません';

  @override
  String get previewDownloading => '画像をダウンロード中…';

  @override
  String get previewDownloadFailed => 'ダウンロードに失敗しました。もう一度お試しください。';

  @override
  String get previewNotDownloaded => 'この画像はまだこのコンピューターにありません';

  @override
  String get downloadAndPreview => 'ダウンロードしてプレビュー';

  @override
  String get previewUnavailable => '現在この画像はプレビューできません';

  @override
  String get imageSemantic => '履歴の画像';

  @override
  String get previewUnreadable => '画像を読み込めません。ファイルが削除されたか破損している可能性があります。';

  @override
  String get devicesSubtitleEmpty => 'ペアリングすると、デバイス間でクリップボードが同期されます';

  @override
  String devicesSubtitle(int paired, int online) {
    return 'ペアリング済み $paired 台、オンライン $online 台';
  }

  @override
  String get addDevice => 'デバイスを追加';

  @override
  String thisDeviceFootnote(String both) {
    return 'ペアリング時、$bothに同じ 2 行のセキュリティ指紋（このデバイスと相手のもの）が表示されます。1 文字ずつ一致を確かめてから確定してください。';
  }

  @override
  String get noDevicesTitle => 'ペアリングしたデバイスはまだありません';

  @override
  String get noDevicesBody =>
      'もう一台のコンピューターで PasteFerry を開き、6 桁のペアリングコードでつなげます。同じネットワーク内なら、両方で「近くを検索」を開いて相手をクリックすることもできます。';

  @override
  String get pairedDevices => 'ペアリング済みのデバイス';

  @override
  String get pairedFootnote =>
      '直接接続：データは 2 台のデバイス間で直接やり取りされます。中継：直接つながらないネットワークでは、あなたのサーバーを経由します。内容はエンドツーエンドで暗号化されたままです。';

  @override
  String get offline => 'オフライン';

  @override
  String get direct => '直接接続';

  @override
  String get relay => '中継';

  @override
  String get online => 'オンライン';

  @override
  String get moreActions => 'その他の操作';

  @override
  String get copyFingerprint => '指紋をコピー';

  @override
  String get unpairEllipsis => 'ペアリングを解除…';

  @override
  String get fingerprintCopied => '指紋をコピーしました';

  @override
  String unpairTitle(String name) {
    return '「$name」とのペアリングを解除しますか？';
  }

  @override
  String get unpairBody =>
      '2 台のデバイスは同期しなくなります。再開するには、もう一度ペアリングして指紋を確かめる必要があります。';

  @override
  String get unpair => 'ペアリングを解除';

  @override
  String get unpaired => 'ペアリングを解除しました';

  @override
  String get enterAddressEllipsis => 'アドレスを入力…';

  @override
  String setAddressTitle(String name) {
    return '「$name」のアドレス';
  }

  @override
  String setAddressBody(String name) {
    return '2 台が別のサブネットにある場合や、どちらもアドレスが変わった場合に使います。「$name」の「デバイスを追加 → コードを表示」に表示されるアドレスを入力してください。';
  }

  @override
  String get addressSaved => 'そのアドレスで探しています';

  @override
  String get lanBlockedTitle => 'macOS がローカルネットワークへのアクセスをブロックしています';

  @override
  String lanBlockedBody(String device) {
    return '「システム設定 → プライバシーとセキュリティ → ローカルネットワーク」で PasteFerry Daemon をオンにしてください。オンにするまで、$deviceは同じネットワークのデバイスに接続できません。';
  }

  @override
  String get searchNearby => '近くを検索';

  @override
  String get nearbyTitle => '近くのデバイス';

  @override
  String get nearbySearching => '近くのデバイスを探しています…';

  @override
  String get nearbyHint => 'もう一台でも「近くを検索」を開くと、ここに表示されます。クリックしてペアリングします。';

  @override
  String nearbyVisible(String device) {
    return 'このウィンドウを開いている間は、同じネットワークのデバイスから$deviceの名前が見えます。';
  }

  @override
  String get nearbyPaired => 'ペアリング済み';

  @override
  String nearbyRequesting(String name) {
    return '「$name」に接続しています…';
  }

  @override
  String nearbyNoReply(String name) {
    return '「$name」から応答がありません。相手で「近くを検索」が開いたままか確認してください。';
  }

  @override
  String get nearbyLanOffTitle => 'ローカルネットワークの検出がオフです';

  @override
  String get nearbyLanOffBody =>
      '近くのデバイスを表示するには「設定 → 接続」で「このネットワークでデバイスを探す」をオンにするか、コードでペアリングしてください。';

  @override
  String get generateCode => 'コードを表示';

  @override
  String get enterCode => 'コードを入力';

  @override
  String get codeFailedTitle => 'ペアリングコードを作成できませんでした';

  @override
  String get enterOnOther => 'もう一台のデバイスでこのコードを入力してください';

  @override
  String get codeCopied => 'コードをコピーしました';

  @override
  String get codeHint => 'クリックでコピー。有効期間は 5 分です。';

  @override
  String afterEnterFootnote(String both) {
    return '入力されると、$bothに同じ 2 行のセキュリティ指紋が表示されます。一致を確かめてから確定してください。';
  }

  @override
  String get codeInvalid => 'ペアリングコードは 6 桁の英数字です';

  @override
  String get localAddress => 'アドレス';

  @override
  String get addressHint => '別のサブネットにある場合は、もう一台でこのアドレスも入力します';

  @override
  String get addressCopied => 'アドレスをコピーしました';

  @override
  String get differentSubnet => '別のサブネットにありますか？';

  @override
  String get peerAddress => 'コードの下に表示されたアドレス';

  @override
  String get pairNotFound =>
      'そのデバイスが見つかりません。別のサブネットにある場合は、コードの下に表示されたアドレスを入力してください。';

  @override
  String get pairNotFoundAddress =>
      'そのアドレスから応答がありません。アドレスと、相手がまだコードを表示しているかを確認してください。相手のファイアウォールがブロックしている可能性もあります。';

  @override
  String get codeWrong => 'コードが違うか、有効期限が切れています';

  @override
  String get codeExpired => 'このコードは無効になりました。もう一台で新しいコードを表示してください。';

  @override
  String get addressInvalid => 'アドレスの形式が正しくありません。192.168.1.20 のように入力してください。';

  @override
  String get pairNoChannel => '先に「設定 → 接続」でローカルネットワークの検出をオンにするか、サーバーを設定してください。';

  @override
  String get enterCodeShown => 'もう一台のデバイスに表示されたコードを入力してください';

  @override
  String get pairingDone => 'ペアリングしました';

  @override
  String get pairingRejected => 'ペアリングを拒否しました';

  @override
  String get verifyTitle => 'セキュリティ指紋を確認';

  @override
  String pairingWith(String name) {
    return '「$name」とペアリング中';
  }

  @override
  String verifyBody(String both) {
    return '$bothに表示された 2 行は完全に同じはずです。1 文字でも違う場合は、第三者が通信を改ざんしている可能性があるため、拒否してください。';
  }

  @override
  String get rejectMismatch => '不一致、拒否';

  @override
  String get confirmMatch => '一致、ペアリング';

  @override
  String get server => 'サーバー（任意）';

  @override
  String get signalingUrl => 'シグナリングサーバー';

  @override
  String get signalingUrlDesc => '空欄ならローカル同期のみ';

  @override
  String get signalingUrlPlaceholder => 'ws://サーバーアドレス:8787/signal';

  @override
  String get publicStun => '直接接続を補助';

  @override
  String get publicStunDesc => '公開サーバーにグローバル IP が伝わります';

  @override
  String get connectionStatus => '接続状態';

  @override
  String get disconnectedDesc => 'アドレスとサーバーの稼働を確認';

  @override
  String get connected => '接続済み';

  @override
  String get notConnected => '未接続';

  @override
  String get notSet => '未設定';

  @override
  String get serverCleared => 'サーバーを削除しました。このネットワーク内だけで同期します';

  @override
  String get localNetwork => 'ローカルネットワーク';

  @override
  String get lanDiscovery => 'このネットワークでデバイスを探す';

  @override
  String get lanDiscoveryDesc => '匿名で検出。「近くを検索」中のみ名前を公開';

  @override
  String get macLocalNetwork => 'ローカルネットワークへのアクセス';

  @override
  String get macLocalNetworkDesc => 'システム設定で PasteFerry Daemon を許可';

  @override
  String get allowLan => 'Windows ファイアウォール';

  @override
  String get allowLanDesc => '接続がブロックされた場合に許可。管理者権限が必要';

  @override
  String get allow => '許可';

  @override
  String get allowLanDone => '許可しました。他のデバイスからこのデバイスに接続できます。';

  @override
  String get deviceName => 'デバイス名';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システムに合わせる';

  @override
  String get sync => '同期';

  @override
  String get autoSyncLimit => '自動同期の上限';

  @override
  String get autoSyncLimitDesc => '上限を超える内容は履歴から手動で取得';

  @override
  String get autoApply => '受け取った内容をクリップボードに入れる';

  @override
  String get whatToSync => '同期する内容';

  @override
  String get syncFiles => 'ファイルとフォルダ';

  @override
  String get syncText => 'プレーンテキスト';

  @override
  String get syncRich => '書式付きテキスト';

  @override
  String get syncImages => '画像とスクリーンショット';

  @override
  String get storage => 'ストレージ';

  @override
  String get storageFootnote => '期限が切れると履歴とキャッシュを自動削除します。';

  @override
  String get keepHistory => '履歴の保存期間';

  @override
  String get keepCache => 'キャッシュの保存期間';

  @override
  String get keepCacheDesc => '履歴の保存期間以内';

  @override
  String get cacheUsage => 'キャッシュ容量';

  @override
  String get backgroundSync => 'バックグラウンド同期';

  @override
  String get backgroundService => 'バックグラウンドサービス';

  @override
  String get backgroundServiceDesc => 'ログイン時に起動。ウィンドウを閉じても同期';

  @override
  String get restart => '再起動';

  @override
  String get restarted => 'バックグラウンドサービスを再起動しました';

  @override
  String get disableEllipsis => 'オフにする…';

  @override
  String get about => 'このアプリについて';

  @override
  String get aboutDesc => 'オープンソース（AGPL-3.0）';

  @override
  String get homepage => 'ウェブサイト';

  @override
  String get feedback => '問題を報告';

  @override
  String get disableTitle => 'バックグラウンド同期をオフにしますか？';

  @override
  String disableBody(String device) {
    return '$deviceは同期を停止し、ログイン時にも起動しなくなります。履歴とペアリングは残ります。';
  }

  @override
  String get disable => 'オフにする';

  @override
  String get disabled => 'バックグラウンド同期をオフにしました';

  @override
  String get urlMustBeWs => 'アドレスは ws:// または wss:// で始めてください';

  @override
  String get serverUpdated => 'サーバーを更新しました。再接続しています…';

  @override
  String get deviceNameUpdated => 'デバイス名を更新しました';

  @override
  String get diagIntro =>
      'このレポートには、バージョン、システム、設定、デバイスの状態、最近のログが含まれます。デバイス名、サーバーのアドレス、グローバル IP アドレス、ユーザーフォルダ、ファイル名は置き換え済みで、コピーした内容はログに書かれません。GitHub の Issue は公開されるので、投稿する前に目を通してください。';

  @override
  String get diagVerboseTitle => '詳細ログ';

  @override
  String get diagVerboseDesc =>
      '接続の問題を調べるときに使います。オンにして問題をもう一度起こしてから、ここでレポートを作り直してください。30 分後に自動でオフになります。';

  @override
  String get diagVerboseOn => '30 分間オンにする';

  @override
  String diagVerboseUntil(String time) {
    return '$time までオン';
  }

  @override
  String get diagVerboseOff => 'オフにする';

  @override
  String get diagRefresh => '作り直す';

  @override
  String get diagSave => 'ファイルに保存';

  @override
  String diagSaved(String name) {
    return '「ダウンロード」フォルダに保存しました：$name';
  }

  @override
  String get diagCopy => 'レポートをコピー';

  @override
  String get diagCopied => 'レポートをコピーしました';

  @override
  String get diagNewIssue => 'GitHub で Issue を作成';

  @override
  String get diagIssueHint =>
      'レポートをコピーしました。Issue の「Diagnostics report」欄に貼り付けてください';

  @override
  String diagFailed(String detail) {
    return 'レポートを作成できませんでした：$detail';
  }

  @override
  String get svcExtractTitle => '先に PasteFerry をインストールまたは展開してください';

  @override
  String get svcExtractBody =>
      'PasteFerry は zip から直接開かれていて、閉じると一時フォルダごと消えます。インストーラーを実行するか、フォルダ全体を展開してから開くと、バックグラウンド同期を有効にできます。';

  @override
  String get svcMoveTitle => '先に PasteFerry を「アプリケーション」に移動してください';

  @override
  String get svcMoveBody =>
      'PasteFerry はディスクイメージから直接開かれています。「アプリケーション」にドラッグしてディスクイメージを取り出し、「アプリケーション」から開くと、バックグラウンド同期を有効にできます。';

  @override
  String get svcStartTitle => 'PasteFerry を始める';

  @override
  String get svcStartBody =>
      'PasteFerry はバックグラウンドでクリップボードを同期し、ウィンドウを閉じても動作します。ログイン時の起動は別の設定で、新規インストールではオフです。';

  @override
  String get svcEnable => 'バックグラウンド同期を有効にする';

  @override
  String get svcStaleTitle => 'バックグラウンド同期をもう一度有効にする';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry の場所が変わりましたが、自動起動は以前の場所を指しています。もう一度有効にすると、このコピーを使うようになります。履歴とペアリングは残ります。';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry の場所が変わったか、古いスクリプトでインストールされています。もう一度有効にすると、このアプリを使うようになります。履歴とペアリングは残ります。';

  @override
  String get svcReenable => 'もう一度有効にする';

  @override
  String get svcStoppedTitle => 'バックグラウンドサービスが動いていません';

  @override
  String get svcStoppedBody =>
      'バックグラウンドサービスは停止しています。下のボタンで起動できます。ログイン時の起動は設定で個別に選べます。';

  @override
  String get svcDevBodyWin =>
      '開発ビルドのため pasteferryd.exe がありません。ソースフォルダで scripts\\build-windows.ps1 を実行して完全版をビルドしてください。';

  @override
  String get svcDevBodyLinux =>
      '開発ビルドのため pasteferryd がありません。ソースフォルダで ./scripts/package-linux.sh を実行して完全版をビルドしてください。';

  @override
  String get svcDevBodyMac =>
      '開発ビルドのためバックグラウンドサービスが含まれていません。ソースフォルダで ./scripts/install-macos.sh を実行してインストールしてください。';

  @override
  String svcLogPath(String path) {
    return 'ログ：$path';
  }

  @override
  String get svcCanDisable => 'バックグラウンド同期は「設定」でいつでもオフにできます。';

  @override
  String get officialService => 'サービス';

  @override
  String get useOfficialService => 'サービスを使う';

  @override
  String get officialServiceDesc => '別のネットワーク間で同期。直接接続を優先';

  @override
  String get officialPrivacy =>
      '有効にした場合のみサービスに接続し、必要最小限の接続情報を記録します。まず直接接続を試み、失敗した場合のみ中継を申請します。内容、実際の端末名、元のシステム識別子は送信しません。';

  @override
  String get officialEnableTitle => 'サービスを有効にしますか？';

  @override
  String get officialSwitchConfirm => '現在のカスタムサーバーから切り替えます。保存済みのアドレスは保持されます。';

  @override
  String get customServer => 'カスタムサーバー';

  @override
  String get saveAndConnect => '保存して接続';

  @override
  String get officialLoading => '残量を確認しています…';

  @override
  String get officialFetchFailed => '残量を取得できません。自動的に再試行します。';

  @override
  String get officialUnavailable => '使用量を取得できません。表示データは古い可能性があります';

  @override
  String get officialQuotaTitle => '本日の中継上限に達しました';

  @override
  String get officialQuotaBody =>
      'サービスの中継は北京時間の午前0時にリセットされるまで停止します。LANと直接接続は引き続き利用できます。失敗した転送は後で再試行できます。';

  @override
  String get officialPeerQuota => '相手の中継残量がありません。直接接続は引き続き利用できます';

  @override
  String get officialPaused => 'サービスの中継は現在利用できません。直接接続は引き続き利用できます';

  @override
  String get officialViewUsage => '使用量を表示';

  @override
  String get officialAcknowledge => '確認しました';

  @override
  String get officialToday => '本日の中継残量';

  @override
  String get officialUsed => '使用済み';

  @override
  String get officialRemaining => '残量';

  @override
  String get officialDailyLimit => '1日の上限';

  @override
  String get officialUpload => 'アップロード';

  @override
  String get officialDownload => 'ダウンロード';

  @override
  String get officialReset => 'リセット時刻（北京時間）';

  @override
  String get officialUpdated => '最終更新';

  @override
  String get officialRoutes => 'デバイスの接続方法';

  @override
  String get officialRoutesFootnote => '直接接続はサービスの中継を経由せず、残量も消費しません。';

  @override
  String get officialDeviceID => '端末 ID';

  @override
  String get officialWarning => '本日の中継上限の90%を使用しました。直接接続ではこの残量は消費しません。';

  @override
  String get updateCheck => 'アップデートを確認';

  @override
  String get updateCheckEllipsis => 'アップデートを確認…';

  @override
  String get updateAuto => 'アップデートを自動で確認';

  @override
  String get updateChecking => 'アップデートを確認しています…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version は最新バージョンです。';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version があります';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return '現在のバージョンは $current、ダウンロードは $size です。';
  }

  @override
  String get updateNew => '新機能';

  @override
  String get updateFixed => '修正';

  @override
  String get updateSkip => 'このバージョンをスキップ';

  @override
  String get updateLater => '後で';

  @override
  String get updateInstall => 'ダウンロードしてインストール';

  @override
  String updateDownloading(String done, String total) {
    return 'ダウンロード中 $done / $total';
  }

  @override
  String get updateVerifying => 'ダウンロードしたファイルを検証しています…';

  @override
  String get updateInstalling => 'インストールしています。PasteFerry は自動的に再び開きます。';

  @override
  String get updateInstallingPassword =>
      'インストールしています。/opt には管理者権限が必要なため、システムがパスワードを求めます。その後 PasteFerry は自動的に再び開きます。';

  @override
  String get updateCheckFailed =>
      'GitHub と Gitee に接続できません。しばらくしてからもう一度お試しください。';

  @override
  String get updateDownloadFailed =>
      'ダウンロードが完了しませんでした。もう一度試すか、ウェブサイトから新しいバージョンをダウンロードしてください。';

  @override
  String updateInstallFailed(String error) {
    return 'インストールを開始できませんでした：$error';
  }

  @override
  String get updateUnsupportedBuild => 'このビルドはアップデートを確認できません。';

  @override
  String get updateBlockedDev => '開発ビルドのため、自動アップデートできません。';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry をディスクイメージから直接開いています。「アプリケーション」フォルダにドラッグし、そこから開くと自動アップデートできます。';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry のインストール先フォルダに書き込めないため、自動アップデートできません。ウェブサイトから新しいバージョンをダウンロードしてください。';

  @override
  String get updateBlockedUnsupported =>
      'このコンピュータ用の自動アップデートはありません。ウェブサイトから新しいバージョンをダウンロードしてください。';

  @override
  String get updateOpenDownload => 'ダウンロードページを開く';

  @override
  String updateSidebar(String version) {
    return 'バージョン $version があります';
  }

  @override
  String updatedTo(String version) {
    return '$version にアップデートしました';
  }

  @override
  String updateNotFinished(String version) {
    return 'アップデートが完了しませんでした。$version のままです。';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'アップデートが完了しませんでした。$version のままです。$detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · サービス $serviceVersion · ビルド $build';
  }

  @override
  String get notReceived => '未受信 — ペーストする前に受信してください';

  @override
  String get receivedPreserved => '受信済み。クリップボードに入れるとペーストできます';

  @override
  String get clipboardWriteFailed => '受信済みですが、クリップボードを更新できませんでした';

  @override
  String get receivingStatus => '受信中…';

  @override
  String get largeFileNotifications => '大きなファイルの受信通知';

  @override
  String get notificationsAllowed => '通知は有効です。受信の進捗は履歴で確認できます。';

  @override
  String get notificationsNotRequested => '大きなファイルの受信待ちを通知します。履歴からいつでも受信できます。';

  @override
  String get notificationsDenied => 'システム設定で通知が無効です。受信待ちの項目は履歴から受信できます。';

  @override
  String get notificationsUnknown =>
      '通知とおやすみモードはデスクトップで管理されます。通知がない場合は履歴から受信できます。';

  @override
  String get notificationsUnavailable => 'システム通知を利用できません。大きなファイルは履歴から受信してください。';

  @override
  String get enableNotifications => '通知を有効にする';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notifyPendingTitle => '受信するとペーストできます';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nペーストする前に受信してください。履歴からも受信できます。';
  }

  @override
  String get notifyReceivingTitle => '受信中…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\n進捗は履歴で確認できます。';
  }

  @override
  String get notifyReadyTitle => 'ペーストできます';

  @override
  String notifyReadyBody(String name) {
    return '$name\n受信してクリップボードに入れました。';
  }

  @override
  String get notifyReceivedTitle => '受信しました';

  @override
  String notifyReceivedBody(String name) {
    return '$name\n現在のクリップボードは保持しました。クリップボードに入れる操作は履歴からもできます。';
  }

  @override
  String get notifyFailedTitle => '受信できませんでした';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nこの通知または履歴から再試行できます。';
  }

  @override
  String get notifyClipboardFailedTitle => '受信済みですがクリップボードを更新できませんでした';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nこの通知または履歴からクリップボードに入れて再試行できます。';
  }

  @override
  String get reconnect => '再接続';

  @override
  String get reconnecting => '接続中…';

  @override
  String get reconnectDirect => '直接接続しました';

  @override
  String get reconnectRelay => '直接接続できなかったため、引き続き中継を使います';

  @override
  String reconnectOffline(String name) {
    return '「$name」はオフラインです。PasteFerry が起動しているか確認してください';
  }

  @override
  String get reconnectPending => 'まだ接続中です。しばらくしてから確認してください';

  @override
  String get renameAction => '名前を変更';

  @override
  String get renameFavoriteTitle => 'お気に入りの名前を変更';

  @override
  String get renameFavoriteHint =>
      'お気に入りとクイックペーストにこの名前が表示され、検索でも見つかります。空欄にすると内容の表示に戻ります。';

  @override
  String get renamedToast => '名前を変更しました';

  @override
  String get aliasClearedToast => '内容の表示に戻しました';

  @override
  String get navSend => 'ファイル送信';

  @override
  String get sendSubtitle => 'ファイルをデバイスにドラッグして、そのまま送ります';

  @override
  String get sendNoDevicesTitle => 'ペアリングしたデバイスがありません';

  @override
  String get sendNoDevicesBody => 'ほかのコンピューターとペアリングすると、ここからファイルを送れます。';

  @override
  String get sendDropHint => 'デバイスの上にドロップして送信';

  @override
  String sendReleaseTo(String name) {
    return '離すと $name に送信';
  }

  @override
  String get sendLan => 'ローカルネットワーク';

  @override
  String sendRelayLeft(String left) {
    return '中継 · 今日の残り $left';
  }

  @override
  String get sendNeedsUpdate => 'アップデートが必要';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name は PasteFerry 2.5 以降にアップデートするとファイルを受信できます。';
  }

  @override
  String sendConnectingTip(String name) {
    return '$name に接続しています。接続したら送信できます。';
  }

  @override
  String get sendNotReceiving => 'ファイルを受信しない';

  @override
  String get sendDelivered => '送信済み';

  @override
  String sendToTitle(String name) {
    return '$name に送信';
  }

  @override
  String get sendDropHere => 'ファイルやフォルダをここにドラッグ';

  @override
  String get sendDropStarts => 'ドロップするとすぐに送信します';

  @override
  String get sendChooseFiles => 'ファイルを選択…';

  @override
  String get sendChooseFolder => 'フォルダを選択…';

  @override
  String get sendDropMore => 'さらにドロップすると続けて送信します';

  @override
  String sendSavedWhere(String name) {
    return 'ファイルは $name で設定された場所（既定は「ダウンロード」フォルダ）に保存されます。';
  }

  @override
  String get sendCloseKeeps => 'ウインドウを閉じても送信は続きます';

  @override
  String get sendRemoveQueued => '取り除く';

  @override
  String get sendCannotDrop =>
      'この項目はドラッグでは送れません。ファイルとして保存するか、「ファイルを選択…」を使ってください。';

  @override
  String sendErrOffline(String name) {
    return '$name はオフラインです。';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name はファイルの受信をオフにしています。';
  }

  @override
  String get sendErrMissing => '一部のファイルが見つかりません。';

  @override
  String get relayConfirmTitle => 'サービスの中継で送信しますか？';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name は現在このコンピューターと直接つながっていないため、サービスの中継（約 0.25 MB/s）で送ります。今日の中継の残りは $left です。';
  }

  @override
  String relayConfirmOver(String size) {
    return 'これらのファイル（$size）は残りの枠を超えています。枠を使い切ると一時停止し、直接つながるか、明日枠が戻ると自動で再開します。';
  }

  @override
  String relayConfirmWithin(String size) {
    return '今日の枠のうち約 $size を使います。';
  }

  @override
  String get relayExhausted =>
      '今日の中継枠を使い切りました。北京時間の午前 0 時に戻ります。直接つながっていれば制限はありません。';

  @override
  String get relayDontAskToday => '今日はこのデバイスについて確認しない';

  @override
  String get relaySendAnyway => '送信する';

  @override
  String get relayOwnServer => '中継中 — 速度はサーバー次第です';

  @override
  String get transfersReceived => '受信';

  @override
  String get transfersSent => '送信';

  @override
  String get transfersClearAll => 'すべて消去';

  @override
  String get transfersClearTitle => 'このリストを消去しますか？';

  @override
  String get transfersClearBody => '記録だけを消去します。ファイルは削除されません。';

  @override
  String get transfersEmptyReceived => 'ほかのデバイスから届いたファイルがここに表示されます';

  @override
  String get transfersEmptySent => '送信したファイルがここに表示されます';

  @override
  String transferFrom(String name) {
    return '$name から';
  }

  @override
  String transferTo(String name) {
    return '$name へ';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name ほか $others 項目';
  }

  @override
  String transferFileCount(int count) {
    return '$count 個のファイル';
  }

  @override
  String get transferQueued => '待機中';

  @override
  String transferScanning(String count) {
    return '確認中… $count 個のファイル';
  }

  @override
  String transferWaitingPeer(String name) {
    return '$name の応答を待っています…';
  }

  @override
  String get transferSending => '送信中';

  @override
  String get transferReceiving => '受信中';

  @override
  String transferCurrent(String file, String index, String total) {
    return '転送中：$file（$index / $total）';
  }

  @override
  String transferLeft(String time) {
    return '残り $time';
  }

  @override
  String etaSeconds(int n) {
    return '$n 秒';
  }

  @override
  String etaMinutes(int n) {
    return '$n 分';
  }

  @override
  String etaHours(int h, int m) {
    return '$h 時間 $m 分';
  }

  @override
  String get transferPaused => '一時停止：今日の中継枠を使い切りました';

  @override
  String get transferInterrupted => '中断 — 再接続すると続行します';

  @override
  String transferInterruptedIncoming(String name) {
    return '中断 — $name からの再開を待っています';
  }

  @override
  String get transferCancelled => 'キャンセルしました';

  @override
  String transferPeerCancelled(String name) {
    return '$name がキャンセルしました';
  }

  @override
  String get transferExpired => '期限切れ';

  @override
  String get transferMissing => '移動または削除済み';

  @override
  String transferNotSent(String reason) {
    return '送信できませんでした：$reason';
  }

  @override
  String transferNotReceived(String reason) {
    return '受信できませんでした：$reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name のディスクの空きが $size 足りません';
  }

  @override
  String reasonNoSpace(String size) {
    return 'ディスクの空きが $size 足りません';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name の保存先を使用できません';
  }

  @override
  String get reasonDestUnavailable => '保存先を使用できません。設定を確認してください';

  @override
  String get reasonFileTooLarge => '保存先が FAT32 のディスクで、4 GB を超えるファイルを保存できません';

  @override
  String reasonDisabledPeer(String name) {
    return '$name はファイルの受信をオフにしています';
  }

  @override
  String get reasonSourceChanged => '送信中にファイルが変更されました';

  @override
  String get reasonSourceMissing => 'ファイルが見つかりません';

  @override
  String get reasonReadError => 'ファイルを読み取れませんでした';

  @override
  String get reasonWriteFailed => 'ファイルを書き込めませんでした';

  @override
  String get reasonHashMismatch => '転送中にファイルが破損しました';

  @override
  String reasonUnsupported(String name) {
    return '$name はファイルを受信するためにアップデートが必要です';
  }

  @override
  String get reasonOther => '問題が発生しました';

  @override
  String get revealInFinder => 'Finder に表示';

  @override
  String get revealInFolder => 'フォルダに表示';

  @override
  String get revealOpenFolder => 'フォルダを開く';

  @override
  String get transferResend => 'もう一度送信';

  @override
  String get transferRemove => 'リストから取り除く';

  @override
  String get transferCopyPath => 'パスをコピー';

  @override
  String get transferPathCopied => 'パスをコピーしました';

  @override
  String sendingTo(String name, String percent) {
    return '$name に送信中 · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return '$name から受信中 · $percent';
  }

  @override
  String get receiveFiles => 'ほかのデバイスからファイルを受信';

  @override
  String get saveTo => '保存先';

  @override
  String get saveToChange => '変更…';

  @override
  String get saveToDefault => 'ダウンロード（既定）';

  @override
  String get saveToUseDefault => '「ダウンロード」に戻す';

  @override
  String get receiveNotify => 'ファイルが届いたら通知';

  @override
  String receiveFootnote(String device) {
    return 'ペアリングしたデバイスだけが$deviceにファイルを送れます。転送中、$deviceは自動でスリープしません。';
  }

  @override
  String get saveDirNotFound => 'このフォルダは存在しません。';

  @override
  String get saveDirNotWritable => 'PasteFerry はこのフォルダにファイルを保存できません。';

  @override
  String get saveDirPermission =>
      'PasteFerry にこのフォルダの使用が許可されていません。「システム設定 → プライバシーとセキュリティ → ファイルとフォルダ」で許可してください。';

  @override
  String transferRenamed(int count) {
    return '$count 個のファイル名に Windows で使えない文字があったため、似た全角文字に置き換えました';
  }

  @override
  String get sendRingLan => '同じネットワーク';

  @override
  String get sendRingOther => 'ほかのネットワーク';

  @override
  String sendOfflineList(String names) {
    return 'オフライン：$names';
  }

  @override
  String get listSeparator => '、';

  @override
  String get sendLayout => '転送リスト';

  @override
  String get sendLayoutSide => 'レーダーの右';

  @override
  String get sendLayoutBelow => 'レーダーの下';

  @override
  String get general => '一般';

  @override
  String get launchAtLogin => 'ログイン時に起動';

  @override
  String get launchAtLoginDesc => 'ログイン時にバックグラウンドで起動します。現在の動作は停止しません。';

  @override
  String get realtimeSync => 'クリップボードをリアルタイム同期';

  @override
  String get realtimeSyncDesc => '新しくコピーした内容を自動共有します。オフでもローカル履歴とファイル送信は利用できます。';

  @override
  String get syncBacklog => '再接続後に未送信の内容を同期';

  @override
  String get syncBacklogDesc =>
      '初期設定はオフです。オンにすると、24時間以内の未送信内容を最大20件、クリップボードを上書きせず履歴に追加します。';

  @override
  String get peerRealtimeSync => 'このパソコンと同期';

  @override
  String get syncPaused => '同期を一時停止中';

  @override
  String get quitApp => 'PasteFerry を終了';

  @override
  String get quitAppDesc => 'すべてのプロセスを終了します。ログイン時の起動設定は保持されます。';

  @override
  String get quitTransfersWarning => 'ファイル転送中です。転送を中断して終了しますか？';

  @override
  String get backgroundRunningTitle => 'PasteFerry はバックグラウンドで動作します';

  @override
  String get backgroundRunningBody =>
      'ウィンドウを閉じても同期とクイック貼り付けは続きます。完全に停止するには、設定またはアプリメニューの「PasteFerry を終了」を選んでください。';

  @override
  String get displayAs => '表示名';

  @override
  String get editName => '名前を変更';

  @override
  String get nameHint => '連絡先に表示される名前';

  @override
  String get nameDefaultHint => '空欄にするとアカウント名を使います。';

  @override
  String get avatarTitle => 'プロフィール画像';

  @override
  String get avatarChoose => '画像を選択…';

  @override
  String get avatarPaste => '画像をペースト';

  @override
  String get avatarReset => 'デフォルトの画像に戻す';

  @override
  String get avatarZoom => '拡大';

  @override
  String get avatarDragHint => 'ドラッグで位置を調整できます。';

  @override
  String get avatarNoImage => 'クリップボードに画像がありません。';

  @override
  String get avatarBad => 'この画像は使えません。PNG、JPEG、GIF を選んでください。';

  @override
  String get done => '完了';

  @override
  String get friendsTitle => '連絡先';

  @override
  String get addFriend => '連絡先を追加';

  @override
  String get friendsEmpty => '連絡先はまだありません';

  @override
  String get friendsEmptyBody =>
      '連絡先に追加すると、ペアリングせずにファイルを送り合えます。連絡先はファイルを送れるだけで、クリップボードは見えません。';

  @override
  String get friendSendAction => '送信…';

  @override
  String get friendHistory => '転送履歴';

  @override
  String friendHistoryTitle(String name) {
    return '$name との転送';
  }

  @override
  String get friendHistoryEmpty => 'まだ転送していません。';

  @override
  String get friendAutoAccept => 'ファイルを自動で受け入れる';

  @override
  String get friendRemove => '連絡先を削除';

  @override
  String friendRemoveTitle(String name) {
    return '$name を削除しますか？';
  }

  @override
  String get friendRemoveBody =>
      'お互いの連絡先から削除され、ファイルを送り合えなくなります。これまでの転送履歴はこのパソコンに残ります。';

  @override
  String friendLastActivity(String time) {
    return '最終転送 $time';
  }

  @override
  String get friendNoActivity => 'まだ転送なし';

  @override
  String get friendCodeShare =>
      'このコードを相手に送ってください。相手が PasteFerry に入力すると、お互いの連絡先に追加されます。';

  @override
  String friendCodeExpires(String time) {
    return 'あと $time で無効';
  }

  @override
  String get friendCodeOr => 'または';

  @override
  String get friendCodeEnter => '相手のコードを入力';

  @override
  String get friendCodeAdd => '追加';

  @override
  String get friendCodeWaiting => '相手の入力を待っています…';

  @override
  String friendConfirmBody(String name) {
    return '$name を連絡先に追加しますか？';
  }

  @override
  String get friendSafetyCode => '安全コードを確認（任意）';

  @override
  String get friendSafetyHint =>
      '対面のときに確認できます。両方のパソコンでこの 2 行が同じなら、誰にも割り込まれていません。';

  @override
  String get friendWaitingPeer => '相手の追加を待っています…';

  @override
  String friendAdded(String name) {
    return '$name を連絡先に追加しました';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name がキャンセルしました';
  }

  @override
  String get friendErrFriendCode => 'これは連絡先のコードです。ファイル送信ページの「連絡先を追加」で入力してください。';

  @override
  String get friendErrDeviceCode => 'これはペアリングコードです。「デバイス → デバイスを追加」で入力してください。';

  @override
  String get friendErrOutdated => '相手は PasteFerry 2.6.0 以降が必要です。';

  @override
  String get friendErrAlreadyPaired => 'そのパソコンはすでにあなたのデバイスです。';

  @override
  String get friendErrNoChannel => '同じネットワークにいません。両方のパソコンで「サービス」をオンにすると追加できます。';

  @override
  String get openService => 'サービスをオンにする…';

  @override
  String get noteLabel => 'メモ（任意）';

  @override
  String get noteHintEmpty => '先にファイルを選んでください';

  @override
  String get noteHint => '例：3 ページ目に署名してください';

  @override
  String noteLine(String note) {
    return 'メモ：$note';
  }

  @override
  String get sendAction => '送信';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count 項目 · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'ファイルや画像をここにドロップ、またはペースト（$key）';
  }

  @override
  String get sendDropMorePaste => 'さらにドロップまたはペースト';

  @override
  String get sendPasteNothing => 'ペーストできるファイルや画像がありません。';

  @override
  String get sendRemoveItem => '削除';

  @override
  String sendFriendSaved(String name) {
    return '相手が受け入れると送信が始まります。';
  }

  @override
  String transferAskingOut(String name) {
    return '$name の受け入れを待っています…';
  }

  @override
  String get transferAskingIn => '受け入れを待っています';

  @override
  String reasonDeclined(String name) {
    return '$name が拒否しました';
  }

  @override
  String reasonTimeout(String name) {
    return '$name から応答がありません';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name はファイルを受け付けていません';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name は現在あなたのファイルを受け付けていません';
  }

  @override
  String get reasonYouDeclined => '拒否しました';

  @override
  String get reasonYouIgnored => '無視しました';

  @override
  String get sendAgain => 'もう一度送る';

  @override
  String incomingTitle(String name) {
    return '$name からファイルが届いています';
  }

  @override
  String get incomingAlways => '今後この連絡先のファイルを自動で受け入れる';

  @override
  String get incomingDecline => '拒否';

  @override
  String get incomingAccept => '受け入れる';

  @override
  String incomingCountdown(String seconds) {
    return '$seconds 秒後に自動で拒否';
  }

  @override
  String get incomingStranger => '近くのデバイス';

  @override
  String get friendsStrip => '連絡先';

  @override
  String get strangersStrip => '近くで「すべての人」がオンのデバイス';

  @override
  String get strangerNearby => '近く';

  @override
  String get friendNeedService => 'サービスが必要';

  @override
  String get friendCantReach => '接続できません';

  @override
  String reachSelfNoService(String name) {
    return '$name と同じネットワークにいません。サービスをオンにするとファイルを送れます。直接接続できないときはサービスの中継を使います。';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name はサービスをオンにしていないため、同じネットワークにいるときしか送れません。PasteFerry でサービスをオンにしてもらってください。';
  }

  @override
  String get reachDifferentServer =>
      '同じサーバーを使っていません。両方でサービスをオンにするか、同じサーバーを使うと送れます。';

  @override
  String get receiveFromLabel => 'ファイルの送信を許可：';

  @override
  String get receiveFromOff => '許可しない';

  @override
  String get receiveFromFriends => '連絡先のみ';

  @override
  String get receiveFromEveryone => 'すべての人';

  @override
  String everyoneLeft(String minutes) {
    return 'すべての人 · 残り $minutes 分';
  }

  @override
  String get receiveFromOffDesc => 'ペアリングした自分のパソコンだけが送れます。';

  @override
  String get receiveFromFriendsDesc => '連絡先が送れます。毎回あなたが受け入れます。';

  @override
  String get receiveFromEveryoneDesc => '同じネットワークの誰でも 10 分間送れます。毎回あなたが受け入れます。';

  @override
  String get everyoneEnded => '「すべての人」が終了し、「連絡先のみ」に戻りました。';

  @override
  String get friendsCountTooltip => '連絡先';

  @override
  String get waitingAccept => '承認待ち';

  @override
  String get settingsConnection => '接続';

  @override
  String get settingsGeneralSummary => 'ログイン時の起動、デバイス名、言語';

  @override
  String get settingsConnectionSummary => 'サービス、自前のサーバー、ローカルネットワーク';

  @override
  String get settingsSyncSummary => 'リアルタイム同期、自動同期の上限、同期する内容';

  @override
  String get settingsQuickPasteSummary => 'ショートカット、選んだ後の動作';

  @override
  String get settingsSendSummary => 'ファイルの受信、保存先';

  @override
  String get settingsStorageSummary => '履歴の保存期間と使用量';

  @override
  String get settingsAboutSummary => 'バージョン、アップデート、フィードバック';

  @override
  String get friendsSubtitle => 'ほかの人のパソコンにファイルを送れます。ペアリングは不要です';

  @override
  String get friendsSearch => '連絡先を検索';

  @override
  String get friendsNoMatch => '一致する連絡先はありません';

  @override
  String get friendsPick => '連絡先を選ぶと、転送履歴の確認やファイル送信ができます';

  @override
  String friendDropHint(String name) {
    return 'ここにドロップすると $name に送ります';
  }

  @override
  String get webShareTitle => 'スマートフォンの Web 転送';

  @override
  String get webShareFootnote =>
      'スマートフォンで QR コードを読み取ると、アプリなしでブラウザからこのコンピュータとテキスト、写真、ファイルをやり取りできます。同じネットワークにつながっている必要があります。';

  @override
  String get webShareSwitch => 'ブラウザからの接続を許可';

  @override
  String webShareOn(int count) {
    return 'オン、スマートフォン $count 台';
  }

  @override
  String get webShareOff => 'オフ';

  @override
  String get webShareShowQr => 'QR コードを表示';

  @override
  String get webShareDialogTitle => 'スマートフォンで読み取る';

  @override
  String get webShareDialogBody =>
      'スマートフォンのカメラやブラウザで読み取り、ブラウザで開きます。1 つの QR コードで登録できるのは 1 台で、使うと新しいものに替わります。';

  @override
  String get webShareAddress => 'アドレス';

  @override
  String get webShareSecurity =>
      '内容はページ内で暗号化され、同じネットワークの他の人には読めません。ただしページ自体は http のため、意図的な改ざんは防げません。自宅や信頼できる職場のネットワークで使い、公衆 Wi-Fi では使わないでください。';

  @override
  String get webSharePhones => '登録済みのスマートフォン';

  @override
  String get webShareNoPhones => 'まだありません';

  @override
  String webShareLastUsed(String time) {
    return '最終使用 $time';
  }

  @override
  String get webShareRemove => '削除';

  @override
  String webShareRemoved(String name) {
    return '「$name」を削除しました';
  }

  @override
  String webShareNewPhone(String name) {
    return '「$name」を登録しました';
  }

  @override
  String webShareNotListening(String error) {
    return '待ち受けを開始できませんでした：$error';
  }

  @override
  String get webSharePortFallback =>
      '通常のポートが使用中のため、一時的なポートを使っています。保存したアドレスは開けないため、読み取り直してください。';

  @override
  String get webShareNoAddress =>
      'ローカルネットワークのアドレスがありません。先に Wi-Fi か有線ネットワークにつないでください。';

  @override
  String get webShareCantOpen =>
      'スマートフォンでページが開けないときは、同じネットワークにいるか確認してください（ゲストネットワークでは通常つながりません）。Windows ではファイアウォールで PasteFerry を許可する必要もあります。';

  @override
  String get mTabRecords => '履歴';

  @override
  String get mTabSend => '送信';

  @override
  String get mThisPhone => 'このスマホ';

  @override
  String mThisPhoneName(String name) {
    return 'このスマホ：$name';
  }

  @override
  String get mSendTitle => 'パソコンへ送る';

  @override
  String get mSendHint => 'テキストを入力または貼り付け';

  @override
  String get mPaste => '貼り付け';

  @override
  String get mPhotosFiles => '写真またはファイル';

  @override
  String mSendConfirmTitle(Object n) {
    return '$n 件のファイルを送りますか？';
  }

  @override
  String mFilesSent(num n) {
    return '$n 件のファイルをコンピュータに送りました';
  }

  @override
  String get mClipboardNoText => 'クリップボードにテキストがありません';

  @override
  String get mSendAction => '送信';

  @override
  String mSendTo(String names) {
    return '$names に送信します';
  }

  @override
  String get mNoOnlineDevices => '近くにオンラインのデバイスがありません';

  @override
  String get mNoPairedDevices => '先にパソコンとペアリングしてください';

  @override
  String get mSent => '送信しました';

  @override
  String get mSendFootnote =>
      'テキストとファイルはパソコンの履歴に入り、設定に従ってクリップボードにも入ります。スマホでコピーした内容は自動では送られません。';

  @override
  String get mSentRecords => '送信履歴';

  @override
  String get mViewAll => 'すべて見る';

  @override
  String get mClearCache => 'キャッシュを消去';

  @override
  String mSendFailed(String detail) {
    return '送信できませんでした：$detail';
  }

  @override
  String get mCopy => 'コピー';

  @override
  String get mCopied => 'スマホのクリップボードにコピーしました';

  @override
  String get mShare => '共有';

  @override
  String get mSaved => '写真または「Download/PasteFerry」に保存しました';

  @override
  String mActionFailed(String detail) {
    return 'できませんでした：$detail';
  }

  @override
  String get mDownloading => 'ダウンロード中…';

  @override
  String get mNotDownloaded => '未ダウンロード';

  @override
  String get mDownloadHint => '「コピー」「保存」「共有」をタップすると先にダウンロードします。';

  @override
  String get mFullTextLoading => '読み込み中…';

  @override
  String mTextTruncated(int shown, int total) {
    return '全 $total 文字のうち最初の $shown 文字を表示しています。コピーされるのは全文です。';
  }

  @override
  String get mNotOnLanTitle => 'Wi-Fi に接続していません';

  @override
  String get mNotOnLanBody => '現在はローカルネットワーク内でのみ同期します。パソコンと同じ Wi-Fi に接続してください。';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry を起動できませんでした：$detail';
  }

  @override
  String get mNoDevicesBody =>
      'パソコンで PasteFerry の「デバイス → デバイスを追加」を開き、表示されたコードをここに入力します。同じ Wi-Fi なら、両方で「近くのデバイスを探す」を開いても構いません。';

  @override
  String get mSectionSync => '同期';

  @override
  String get mSectionBackground => 'バックグラウンド';

  @override
  String get mAutoApplyDesc =>
      'パソコンでコピーしたテキストをそのままスマホのクリップボードに入れます。画像とファイルは「コピー」をタップしたときだけです。';

  @override
  String get mKeepAlive => 'バックグラウンドで接続を保つ';

  @override
  String get mKeepAliveDesc => 'PasteFerry を開いていなくてもテキストを受け取れます。常駐通知が表示されます。';

  @override
  String get mNotifications => '通知';

  @override
  String get mNotificationsDesc => '常駐通知に必要です。許可しなくても使えます。';

  @override
  String get mBattery => 'バックグラウンドでの実行';

  @override
  String get mBatteryDesc =>
      '電池の最適化をオフにすると、画面ロック中にシステムに停止されにくくなります。機種によっては設定で自動起動やバックグラウンド実行の許可も必要です。';

  @override
  String get mAllowed => '許可済み';

  @override
  String get mAllow => '許可';

  @override
  String mVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get mDeleteConfirm => 'この履歴を削除しますか？';

  @override
  String get mDelete => '削除';
}
