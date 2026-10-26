// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'History';

  @override
  String get navDevices => 'Devices';

  @override
  String get navSettings => 'Settings';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get linkConnecting => 'Connecting…';

  @override
  String get linkServiceNotRunning => 'Service not running';

  @override
  String get linkLanMode => 'Looking for devices on this network';

  @override
  String get linkServerUnreachable =>
      'Can\'t reach the server; syncing on this network';

  @override
  String get linkNothingOn =>
      'Local network discovery is off and no server is set';

  @override
  String get linkLanBlocked => 'macOS is blocking the local network';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices online',
      one: '1 device online',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Connected to the server';

  @override
  String linkConnectionLost(String detail) {
    return 'Connection lost: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Service disconnected';

  @override
  String get linkServiceDisabled => 'Background sync is off';

  @override
  String get errServiceNotConnected =>
      'Not connected to the background service';

  @override
  String get errUnimplemented => 'This isn\'t available yet';

  @override
  String get errUnavailable => 'Can\'t reach the background service';

  @override
  String errServiceStart(String detail) {
    return 'Couldn\'t start the background service: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Couldn\'t restart the background service: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Couldn\'t set PasteFerry to start at login: $detail';
  }

  @override
  String get thisMacTitle => 'This Mac';

  @override
  String get thisPcTitle => 'This computer';

  @override
  String get thisMacInText => 'this Mac';

  @override
  String get thisPcInText => 'this computer';

  @override
  String get bothMacs => 'both Macs';

  @override
  String get bothDevices => 'both devices';

  @override
  String get thisDeviceShort => 'This device';

  @override
  String fromDevice(String name) {
    return 'From $name';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Try again';

  @override
  String get continueAction => 'Continue';

  @override
  String get justNow => 'Just now';

  @override
  String secondsAgo(int n) {
    return '${n}s ago';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days ago',
      one: 'Yesterday',
    );
    return '$_temp0';
  }

  @override
  String monthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String durationHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Copy on any of your devices and it shows up here';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0, kept for $ttl';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterText => 'Text';

  @override
  String get filterImage => 'Images';

  @override
  String get filterFile => 'Files';

  @override
  String get filterLink => 'Links';

  @override
  String get historyClearTooltip => 'Clear history';

  @override
  String get historyEmptyTitle => 'Nothing here yet';

  @override
  String get historyEmptyFilteredTitle => 'Nothing of this kind';

  @override
  String get historyEmptyBody =>
      'Copy text, an image or a file on any paired device and it appears here.';

  @override
  String get clearConfirmTitle => 'Clear the whole history?';

  @override
  String clearConfirmBody(String device) {
    return 'Everything synced from your devices, and the cached files, will be removed from $device. The original files aren\'t affected.';
  }

  @override
  String get clear => 'Clear';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get permDeniedTitle => 'PasteFerry can\'t read the clipboard';

  @override
  String get permAskTitle => 'Allow PasteFerry to read the clipboard';

  @override
  String get permDeniedBody =>
      'What you copy on this Mac won\'t be synced. In System Settings, set PasteFerry Daemon to Allow.';

  @override
  String get permAskBody =>
      'Otherwise macOS asks every time. In System Settings, set PasteFerry Daemon to Allow.';

  @override
  String get openSystemSettings => 'Open System Settings';

  @override
  String get fetch => 'Receive';

  @override
  String get fetchStarted => 'Receiving… See History for progress';

  @override
  String get transferFailed => 'Transfer failed';

  @override
  String get expired => 'Expired';

  @override
  String get putOnClipboard => 'Copy to clipboard';

  @override
  String get putOnClipboardDone => 'On the clipboard';

  @override
  String get deleteRecord => 'Delete this item';

  @override
  String get deleted => 'Deleted';

  @override
  String get emptyRecord => '(empty)';

  @override
  String get imageRecord => 'Image';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others more',
      one: '1 more',
    );
    return '$name and $_temp0';
  }

  @override
  String get searchHint => 'Search text and file names';

  @override
  String get searchClear => 'Clear search';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'No matches for “$query”';
  }

  @override
  String get searchEmptyBody =>
      'Search looks through copied text and the names of copied files.';

  @override
  String get favoriteAction => 'Add to favorites';

  @override
  String get unfavoriteAction => 'Remove from favorites';

  @override
  String get favoritedToast => 'Added to Favorites';

  @override
  String get unfavoritedToast => 'Moved back to History';

  @override
  String get undo => 'Undo';

  @override
  String get favoriteSaving => 'Saving…';

  @override
  String favoritedAt(String date) {
    return 'Saved $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 · never cleaned up · up to $size';
  }

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyBody =>
      'Star an item in History to keep a copy here. Favorites are never cleaned up automatically.';

  @override
  String get favoritesSearchHint => 'Search favorites';

  @override
  String favoriteLargeTitle(String size) {
    return 'Save a copy of $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'A favorite keeps its own copy, so changing or deleting the original files won\'t affect it. This uses $size on $device.';
  }

  @override
  String get saveCopy => 'Save copy';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your $count favorites stay.',
      one: 'Your 1 favorite stays.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favorites';

  @override
  String get favoritesUsageDesc =>
      'Favorites are never cleaned up, whatever the settings above';

  @override
  String upToSize(String size) {
    return 'Up to $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters',
      one: '1 character',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… $count characters in total';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more',
      one: '1 more',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Pick it to download it first';

  @override
  String detailTotalSize(String size) {
    return '$size in total';
  }

  @override
  String get quickPaste => 'Quick paste';

  @override
  String get quickPasteWindow => 'Quick paste window';

  @override
  String get quickPasteWindowDesc =>
      'Press the shortcut in any app to bring up your history; pick an item and it\'s pasted';

  @override
  String get quickPasteShortcut => 'Shortcut';

  @override
  String get quickPasteRecord => 'Click to change';

  @override
  String get quickPasteRecording => 'Press the new shortcut…';

  @override
  String get quickPasteUseDefault => 'Use default';

  @override
  String get quickPasteNeedsModifier =>
      'Include ⌃, ⌥, ⇧ or ⌘, or use a function key';

  @override
  String get quickPasteNeedsModifierPc =>
      'Include Ctrl, Alt, Shift or the Windows key, or use a function key';

  @override
  String get quickPasteAfterPick => 'After you pick an item';

  @override
  String get quickPastePasteIt => 'Paste it';

  @override
  String get quickPasteCopyIt => 'Just copy it';

  @override
  String get quickPasteAccessibility => 'Accessibility';

  @override
  String get quickPasteAccessibilityDesc =>
      'Needed to paste for you. Without it, items are copied and you press ⌘V.';

  @override
  String get quickPasteAllowed => 'Allowed';

  @override
  String get quickPasteAllow => 'Allow…';

  @override
  String get quickPasteNotRunning => 'The quick paste window isn\'t running';

  @override
  String quickPasteInUse(String key) {
    return '$key is used by another app. Pick another shortcut.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Couldn\'t set $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Set in the system shortcut settings';

  @override
  String get quickPasteWaylandDesc =>
      'On Wayland, add the shortcut in your desktop\'s keyboard settings. Picked items are copied; press Ctrl+V to paste.';

  @override
  String get quickPasteAddShortcut => 'Add system shortcut';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Added. Press $key to try it.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Add a custom shortcut in your desktop\'s keyboard settings that runs: $command';
  }

  @override
  String get pickerSearch => 'Search';

  @override
  String get pickerPaste => 'Paste';

  @override
  String get pickerPlainText => 'Plain text';

  @override
  String get pickerCopyOnly => 'Copy only';

  @override
  String get pickerUnfavoriteHint => 'Remove (back to History)';

  @override
  String pickerPasteManually(String key) {
    return 'Picked items are copied — press $key to paste';
  }

  @override
  String get pickerGrantHint => 'Allow Accessibility to paste directly';

  @override
  String pickerElevated(String key) {
    return 'This window runs as administrator — press $key to paste after picking';
  }

  @override
  String get pickerDownloading => 'Downloading — pastes when done';

  @override
  String get imagePreviewTitle => 'Image preview';

  @override
  String get closePreview => 'Close preview';

  @override
  String get previousImage => 'Previous image';

  @override
  String get nextImage => 'Next image';

  @override
  String get previewHint => 'Scroll or pinch to zoom, drag to move around';

  @override
  String get fitWindow => 'Fit to window';

  @override
  String get previewDeleted => 'This image has been deleted from the history';

  @override
  String get previewExpired => 'This image has expired and can\'t be previewed';

  @override
  String get previewDownloading => 'Downloading the image…';

  @override
  String get previewDownloadFailed => 'The download failed. Try again.';

  @override
  String get previewNotDownloaded => 'This image isn\'t on this computer yet';

  @override
  String get downloadAndPreview => 'Download and preview';

  @override
  String get previewUnavailable => 'This image can\'t be previewed right now';

  @override
  String get imageSemantic => 'Image from the history';

  @override
  String get previewUnreadable =>
      'Can\'t read the image. The file may have been cleaned up or damaged.';

  @override
  String get devicesSubtitleEmpty =>
      'Once paired, your devices share one clipboard';

  @override
  String devicesSubtitle(int paired, int online) {
    return '$paired paired, $online online';
  }

  @override
  String get addDevice => 'Add device';

  @override
  String thisDeviceFootnote(String both) {
    return 'When pairing, $both show the same two lines of security fingerprints, one for each device. Confirm only if they match character for character.';
  }

  @override
  String get noDevicesTitle => 'No paired devices yet';

  @override
  String get noDevicesBody =>
      'Open PasteFerry on your other computer and link the two with a 6-character pairing code. On the same network, you can also open Search nearby on both and click the other one.';

  @override
  String get pairedDevices => 'Paired devices';

  @override
  String get pairedFootnote =>
      'Direct: data goes straight between the two devices. Relay: when the network blocks a direct path, data goes through your server and stays end-to-end encrypted.';

  @override
  String get offline => 'Offline';

  @override
  String get direct => 'Direct';

  @override
  String get relay => 'Relay';

  @override
  String get online => 'Online';

  @override
  String get moreActions => 'More';

  @override
  String get copyFingerprint => 'Copy fingerprint';

  @override
  String get unpairEllipsis => 'Unpair…';

  @override
  String get fingerprintCopied => 'Fingerprint copied';

  @override
  String unpairTitle(String name) {
    return 'Unpair “$name”?';
  }

  @override
  String get unpairBody =>
      'The two devices will stop syncing. To sync again, you\'ll need to pair them and check the fingerprints again.';

  @override
  String get unpair => 'Unpair';

  @override
  String get unpaired => 'Unpaired';

  @override
  String get enterAddressEllipsis => 'Enter its address…';

  @override
  String setAddressTitle(String name) {
    return 'Address of “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Use this when the two devices are on different subnets, or both changed addresses. Enter the address shown on “$name” under Add device → Show a code.';
  }

  @override
  String get addressSaved => 'Looking for it at that address';

  @override
  String get lanBlockedTitle => 'macOS is blocking the local network';

  @override
  String lanBlockedBody(String device) {
    return 'Turn on PasteFerry Daemon in System Settings → Privacy & Security → Local Network. Until then, $device can\'t connect to devices on this network.';
  }

  @override
  String get searchNearby => 'Search nearby';

  @override
  String get nearbyTitle => 'Nearby devices';

  @override
  String get nearbySearching => 'Looking for nearby devices…';

  @override
  String get nearbyHint =>
      'Open Search nearby on the other computer too, and it shows up here. Click it to pair.';

  @override
  String nearbyVisible(String device) {
    return 'While this window is open, devices on this network can see the name of $device.';
  }

  @override
  String get nearbyPaired => 'Paired';

  @override
  String nearbyRequesting(String name) {
    return 'Contacting “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” didn\'t answer. Make sure Search nearby is still open on it.';
  }

  @override
  String get nearbyLanOffTitle => 'Local network discovery is off';

  @override
  String get nearbyLanOffBody =>
      'Turn on “Find devices on this network” in Settings to see nearby devices, or pair with a code instead.';

  @override
  String get generateCode => 'Show a code';

  @override
  String get enterCode => 'Enter a code';

  @override
  String get codeFailedTitle => 'Couldn\'t create a pairing code';

  @override
  String get enterOnOther => 'Enter this code on your other device';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get codeHint => 'Click to copy. Valid for 5 minutes.';

  @override
  String afterEnterFootnote(String both) {
    return 'Once it\'s entered, $both show the same two lines of security fingerprints. Confirm only if they match.';
  }

  @override
  String get codeInvalid => 'A pairing code is 6 letters or digits';

  @override
  String get localAddress => 'Address';

  @override
  String get addressHint =>
      'On a different subnet? Enter this address on the other device as well.';

  @override
  String get addressCopied => 'Address copied';

  @override
  String get differentSubnet => 'On a different subnet?';

  @override
  String get peerAddress => 'Address shown under the code';

  @override
  String get pairNotFound =>
      'Couldn\'t find that device. If it\'s on a different subnet, enter the address shown under its code.';

  @override
  String get pairNotFoundAddress =>
      'Nothing answered at that address. Check the address and that the other device is still showing its code. A firewall on that device may also be blocking it.';

  @override
  String get codeWrong => 'That code isn\'t right, or it has expired';

  @override
  String get codeExpired =>
      'This code has expired. Show a new one on the other device.';

  @override
  String get addressInvalid =>
      'That address isn\'t valid. Enter something like 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Turn on local network discovery or set a server in Settings first.';

  @override
  String get enterCodeShown => 'Enter the code shown on your other device';

  @override
  String get pairingDone => 'Paired';

  @override
  String get pairingRejected => 'Pairing declined';

  @override
  String get verifyTitle => 'Check the security fingerprints';

  @override
  String pairingWith(String name) {
    return 'Pairing with “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'The two lines on $both must be identical. If even one character differs, someone may be tampering with the connection, so decline.';
  }

  @override
  String get rejectMismatch => 'Mismatch, decline';

  @override
  String get confirmMatch => 'They match, pair';

  @override
  String get server => 'Server (optional)';

  @override
  String get signalingUrl => 'Signaling server';

  @override
  String get signalingUrlDesc => 'Leave blank for local sync only';

  @override
  String get signalingUrlPlaceholder => 'ws://server-address:8787/signal';

  @override
  String get publicStun => 'Improve direct connections';

  @override
  String get publicStunDesc => 'Public servers can see your public IP';

  @override
  String get connectionStatus => 'Connection';

  @override
  String get disconnectedDesc => 'Check the server address and availability';

  @override
  String get connected => 'Connected';

  @override
  String get notConnected => 'Not connected';

  @override
  String get notSet => 'Not set';

  @override
  String get serverCleared => 'Server removed. Syncing on this network only.';

  @override
  String get localNetwork => 'Local network';

  @override
  String get lanDiscovery => 'Find devices on this network';

  @override
  String get lanDiscoveryDesc =>
      'Anonymous discovery; names are visible only during Search nearby';

  @override
  String get macLocalNetwork => 'Local Network access';

  @override
  String get macLocalNetworkDesc =>
      'Allow PasteFerry Daemon in System Settings';

  @override
  String get allowLan => 'Windows Firewall';

  @override
  String get allowLanDesc =>
      'Allow blocked connections; requires administrator approval';

  @override
  String get allow => 'Allow';

  @override
  String get allowLanDone => 'Allowed. Other devices can now reach this one.';

  @override
  String get deviceName => 'Device name';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get sync => 'Sync';

  @override
  String get autoSyncLimit => 'Auto-sync limit';

  @override
  String get autoSyncLimitDesc => 'Receive larger items manually from History';

  @override
  String get autoApply => 'Put received items on the clipboard';

  @override
  String get whatToSync => 'What to sync';

  @override
  String get syncFiles => 'Files and folders';

  @override
  String get syncText => 'Plain text';

  @override
  String get syncRich => 'Rich text';

  @override
  String get syncImages => 'Images and screenshots';

  @override
  String get storage => 'Storage';

  @override
  String get storageFootnote =>
      'Expired history and cached files are deleted automatically.';

  @override
  String get keepHistory => 'Keep history for';

  @override
  String get keepCache => 'Keep cached files for';

  @override
  String get keepCacheDesc => 'No longer than history retention';

  @override
  String get cacheUsage => 'Cache size';

  @override
  String get backgroundSync => 'Background sync';

  @override
  String get backgroundService => 'Background service';

  @override
  String get backgroundServiceDesc =>
      'Starts at login; syncs with the window closed';

  @override
  String get restart => 'Restart';

  @override
  String get restarted => 'Background service restarted';

  @override
  String get disableEllipsis => 'Turn off…';

  @override
  String get about => 'About';

  @override
  String get aboutDesc => 'Open source under the AGPL-3.0';

  @override
  String get homepage => 'Website';

  @override
  String get feedback => 'Report a problem';

  @override
  String get disableTitle => 'Turn off background sync?';

  @override
  String disableBody(String device) {
    return 'PasteFerry on $device will stop syncing and won\'t start at login. History and pairings are kept.';
  }

  @override
  String get disable => 'Turn off';

  @override
  String get disabled => 'Background sync is off';

  @override
  String get urlMustBeWs => 'The address must start with ws:// or wss://';

  @override
  String get serverUpdated => 'Server updated. Reconnecting…';

  @override
  String get deviceNameUpdated => 'Device name updated';

  @override
  String get diagIntro =>
      'This report has the app version, your system, settings, devices and recent logs. Device names, the server address, public IP addresses, your user folder and file names are replaced, and what you copy is never written to the logs. Issues on GitHub are public, so read it through before posting.';

  @override
  String get diagVerboseTitle => 'Detailed logging';

  @override
  String get diagVerboseDesc =>
      'For connection problems: turn it on, make the problem happen again, then come back for the report. It turns itself off after 30 minutes.';

  @override
  String get diagVerboseOn => 'Turn on for 30 minutes';

  @override
  String diagVerboseUntil(String time) {
    return 'On until $time';
  }

  @override
  String get diagVerboseOff => 'Turn off';

  @override
  String get diagRefresh => 'Regenerate';

  @override
  String get diagSave => 'Save as file';

  @override
  String diagSaved(String name) {
    return 'Saved to your Downloads folder: $name';
  }

  @override
  String get diagCopy => 'Copy report';

  @override
  String get diagCopied => 'Report copied';

  @override
  String get diagNewIssue => 'New issue on GitHub';

  @override
  String get diagIssueHint =>
      'Report copied. Paste it into the issue\'s “Diagnostics report” box.';

  @override
  String diagFailed(String detail) {
    return 'Couldn\'t create the report: $detail';
  }

  @override
  String get svcExtractTitle => 'Install or extract PasteFerry first';

  @override
  String get svcExtractBody =>
      'PasteFerry is running straight from the zip, and its temporary folder disappears when you close it. Run the installer, or extract the whole folder and open it from there, to turn on background sync.';

  @override
  String get svcMoveTitle => 'Move PasteFerry to Applications first';

  @override
  String get svcMoveBody =>
      'PasteFerry is running straight from the disk image. Drag it into Applications, eject the disk image, and open it from Applications to turn on background sync.';

  @override
  String get svcStartTitle => 'Get started with PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry runs a small background process for clipboard sync. Closing the window keeps it running. Launch at login is a separate setting and is off for new installations.';

  @override
  String get svcEnable => 'Turn on background sync';

  @override
  String get svcStaleTitle => 'Turn background sync on again';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry has moved, but starting at login still points to the old place. Turn it on again so the background process uses this copy. History and pairings are kept.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry has moved, or was installed with an old script. Turn it on again so the background process uses this app. History and pairings are kept.';

  @override
  String get svcReenable => 'Turn on again';

  @override
  String get svcStoppedTitle => 'The background service isn\'t running';

  @override
  String get svcStoppedBody =>
      'The background service is stopped. Start it with the button below; launch at login is controlled separately in Settings.';

  @override
  String get svcDevBodyWin =>
      'This is a development build with no pasteferryd.exe next to it. Run scripts\\build-windows.ps1 in the source folder to build a complete version.';

  @override
  String get svcDevBodyLinux =>
      'This is a development build with no pasteferryd next to it. Run ./scripts/package-linux.sh in the source folder to build a complete version.';

  @override
  String get svcDevBodyMac =>
      'This is a development build without the background service. Run ./scripts/install-macos.sh in the source folder to install it.';

  @override
  String svcLogPath(String path) {
    return 'Log: $path';
  }

  @override
  String get svcCanDisable =>
      'You can turn background sync off anytime in Settings.';

  @override
  String get officialService => 'Service';

  @override
  String get useOfficialService => 'Use the service';

  @override
  String get officialServiceDesc =>
      'Sync across networks, direct connections first';

  @override
  String get officialPrivacy =>
      'Connects to the service only when enabled and records essential access statistics. Direct connections are tried first; relay access is requested only if they fail. Content, real device names and raw system identifiers are not uploaded.';

  @override
  String get officialEnableTitle => 'Enable the service?';

  @override
  String get officialSwitchConfirm =>
      'This switches away from your custom server. Its saved address will be retained.';

  @override
  String get customServer => 'Custom server';

  @override
  String get saveAndConnect => 'Save and connect';

  @override
  String get officialLoading => 'Checking the allowance…';

  @override
  String get officialFetchFailed =>
      'Can\'t get the allowance right now. It will be retried automatically.';

  @override
  String get officialUnavailable =>
      'Usage is unavailable; existing data may be out of date';

  @override
  String get officialQuotaTitle => 'Daily relay allowance used up';

  @override
  String get officialQuotaBody =>
      'The service relay is paused until the daily reset at midnight Beijing time. LAN and direct Internet connections remain available. Failed transfers can be retried later.';

  @override
  String get officialPeerQuota =>
      'The peer has no relay allowance left. Direct connections remain available.';

  @override
  String get officialPaused =>
      'The service relay is unavailable. Direct connections remain available.';

  @override
  String get officialViewUsage => 'View usage';

  @override
  String get officialAcknowledge => 'Got it';

  @override
  String get officialToday => 'Today\'s relay allowance';

  @override
  String get officialUsed => 'Used';

  @override
  String get officialRemaining => 'Remaining';

  @override
  String get officialDailyLimit => 'Daily allowance';

  @override
  String get officialUpload => 'Upload';

  @override
  String get officialDownload => 'Download';

  @override
  String get officialReset => 'Reset time (Beijing)';

  @override
  String get officialUpdated => 'Last updated';

  @override
  String get officialRoutes => 'How devices connect';

  @override
  String get officialRoutesFootnote =>
      'Direct connections don\'t go through the service relay and don\'t use the allowance.';

  @override
  String get officialDeviceID => 'Device ID';

  @override
  String get officialWarning =>
      '90% of the daily relay allowance has been used. Direct connections do not consume it.';

  @override
  String get updateCheck => 'Check for updates';

  @override
  String get updateCheckEllipsis => 'Check for updates…';

  @override
  String get updateAuto => 'Check for updates automatically';

  @override
  String get updateAutoDesc =>
      'Once a day. Only reads the update list on GitHub and Gitee; nothing that identifies you is sent.';

  @override
  String get updateChecking => 'Checking for updates…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version is the latest version.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version is available';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'You have $current. Download size $size.';
  }

  @override
  String get updateNew => 'New';

  @override
  String get updateFixed => 'Fixed';

  @override
  String get updateSkip => 'Skip this version';

  @override
  String get updateLater => 'Later';

  @override
  String get updateInstall => 'Download and install';

  @override
  String updateDownloading(String done, String total) {
    return 'Downloading $done of $total';
  }

  @override
  String get updateVerifying => 'Checking the download…';

  @override
  String get updateInstalling =>
      'Installing. PasteFerry will reopen by itself.';

  @override
  String get updateInstallingPassword =>
      'Installing. Your system will ask for your password, because /opt needs administrator rights; PasteFerry then reopens by itself.';

  @override
  String get updateCheckFailed =>
      'Couldn\'t reach GitHub or Gitee. Try again later.';

  @override
  String get updateDownloadFailed =>
      'The download didn\'t finish. Try again, or download the new version from the website.';

  @override
  String updateInstallFailed(String error) {
    return 'Couldn\'t start the installation: $error';
  }

  @override
  String get updateUnsupportedBuild => 'This build can\'t check for updates.';

  @override
  String get updateBlockedDev =>
      'This is a development build, so it can\'t update itself.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry is running from the disk image. Drag it to Applications and open it from there to update automatically.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry can\'t write to the folder it is installed in. Download the new version from the website instead.';

  @override
  String get updateBlockedUnsupported =>
      'There is no automatic update for this computer. Download the new version from the website.';

  @override
  String get updateOpenDownload => 'Open download page';

  @override
  String updateSidebar(String version) {
    return 'Version $version is available';
  }

  @override
  String updatedTo(String version) {
    return 'Updated to $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'The update didn\'t finish. You\'re still on $version.';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · Service $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Not received — receive before pasting';

  @override
  String get receivedPreserved => 'Received; use Copy to clipboard when ready';

  @override
  String get clipboardWriteFailed =>
      'Received, but the clipboard could not be updated';

  @override
  String get receivingStatus => 'Receiving…';

  @override
  String get largeFileNotifications => 'Large file reminders';

  @override
  String get notificationsAllowed =>
      'Notifications are enabled. Progress is shown in History.';

  @override
  String get notificationsNotRequested =>
      'Enable notifications so large files do not wait silently. You can always receive them from History.';

  @override
  String get notificationsDenied =>
      'Notifications are blocked in system settings. Receive pending items from History.';

  @override
  String get notificationsUnknown =>
      'Your desktop controls notification delivery and Do Not Disturb. Receive items from History if no reminder appears.';

  @override
  String get notificationsUnavailable =>
      'System notifications are unavailable. Receive large files from History.';

  @override
  String get enableNotifications => 'Enable reminders';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get notifyPendingTitle => 'Receive to paste';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nReceive this item before pasting. You can also receive it from History.';
  }

  @override
  String get notifyReceivingTitle => 'Receiving…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nSee History for progress.';
  }

  @override
  String get notifyReadyTitle => 'Ready to paste';

  @override
  String notifyReadyBody(String name) {
    return '$name\nReceived and placed on the clipboard.';
  }

  @override
  String get notifyReceivedTitle => 'Received';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nYour clipboard was kept. Use Copy to clipboard when ready; this is also available in History.';
  }

  @override
  String get notifyFailedTitle => 'Could not receive';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nTry again from this notification or History.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Received; clipboard was not updated';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUse Copy to clipboard to try again, here or in History.';
  }

  @override
  String get reconnect => 'Reconnect';

  @override
  String get reconnecting => 'Connecting…';

  @override
  String get reconnectDirect => 'Connected directly';

  @override
  String get reconnectRelay =>
      'Couldn’t connect directly, still using the relay';

  @override
  String reconnectOffline(String name) {
    return '“$name” is offline. Make sure PasteFerry is open on it.';
  }

  @override
  String get reconnectPending => 'Still connecting, check back in a moment';

  @override
  String get renameAction => 'Rename';

  @override
  String get renameFavoriteTitle => 'Rename favorite';

  @override
  String get renameFavoriteHint =>
      'Shown in Favorites and Quick paste, and you can search for it. Leave it empty to show the content again.';

  @override
  String get renamedToast => 'Renamed';

  @override
  String get aliasClearedToast => 'Showing the content again';

  @override
  String get navSend => 'Send Files';

  @override
  String get sendSubtitle => 'Drag files onto a device to send them directly';

  @override
  String get sendNoDevicesTitle => 'No paired devices yet';

  @override
  String get sendNoDevicesBody =>
      'Pair another computer first, then send files to it here.';

  @override
  String get sendDropHint => 'Drop onto a device to send';

  @override
  String sendReleaseTo(String name) {
    return 'Release to send to $name';
  }

  @override
  String get sendLan => 'Local network';

  @override
  String sendRelayLeft(String left) {
    return 'Relay · $left left today';
  }

  @override
  String get sendNeedsUpdate => 'Needs update';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name can receive files after updating to PasteFerry 2.5 or later.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Connecting to $name. You can send once it\'s connected.';
  }

  @override
  String get sendNotReceiving => 'Not receiving files';

  @override
  String get sendDelivered => 'Delivered';

  @override
  String sendToTitle(String name) {
    return 'Send to $name';
  }

  @override
  String get sendDropHere => 'Drag files or folders here';

  @override
  String get sendDropStarts => 'Sending starts as soon as you drop them';

  @override
  String get sendChooseFiles => 'Choose Files…';

  @override
  String get sendChooseFolder => 'Choose Folder…';

  @override
  String get sendDropMore => 'Drop more files to send them next';

  @override
  String sendSavedWhere(String name) {
    return 'Files are saved where $name chooses — the Downloads folder by default.';
  }

  @override
  String get sendCloseKeeps => 'Closing this window doesn’t stop sending';

  @override
  String get sendRemoveQueued => 'Remove';

  @override
  String get sendCannotDrop =>
      'This item can’t be sent by dragging. Save it as a file first, or use Choose Files….';

  @override
  String sendErrOffline(String name) {
    return '$name is offline.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name isn’t receiving files.';
  }

  @override
  String get sendErrMissing => 'Some of these files no longer exist.';

  @override
  String get relayConfirmTitle => 'Send through the service relay?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name has no direct connection to this computer right now, so the files go through the service relay at about 0.25 MB/s. $left of today’s relay allowance is left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'These files ($size) are more than the remaining allowance. Sending pauses when it runs out and continues when the two computers connect directly or the allowance resets tomorrow.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'This uses about $size of today’s allowance.';
  }

  @override
  String get relayExhausted =>
      'Today’s relay allowance is used up. It resets at midnight Beijing time. Two computers that connect directly have no limit.';

  @override
  String get relayDontAskToday => 'Don’t ask again today for this device';

  @override
  String get relaySendAnyway => 'Send Anyway';

  @override
  String get relayOwnServer => 'Relayed — speed depends on your server';

  @override
  String get transfersReceived => 'Received';

  @override
  String get transfersSent => 'Sent';

  @override
  String get transfersClearAll => 'Clear All';

  @override
  String get transfersClearTitle => 'Clear this list?';

  @override
  String get transfersClearBody =>
      'Only the list is cleared. Files stay where they are.';

  @override
  String get transfersEmptyReceived =>
      'Files other devices send you appear here';

  @override
  String get transfersEmptySent => 'Files you send appear here';

  @override
  String transferFrom(String name) {
    return 'From $name';
  }

  @override
  String transferTo(String name) {
    return 'To $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    return '$name and $others more';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'Queued';

  @override
  String transferScanning(String count) {
    return 'Counting… $count files found';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Waiting for $name…';
  }

  @override
  String get transferSending => 'Sending';

  @override
  String get transferReceiving => 'Receiving';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Now: $file ($index of $total)';
  }

  @override
  String transferLeft(String time) {
    return '$time left';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h h $m min';
  }

  @override
  String get transferPaused => 'Paused: today’s relay allowance is used up';

  @override
  String get transferInterrupted => 'Interrupted — continues when reconnected';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Interrupted — waiting for $name to continue';
  }

  @override
  String get transferCancelled => 'Cancelled';

  @override
  String transferPeerCancelled(String name) {
    return 'Cancelled by $name';
  }

  @override
  String get transferExpired => 'Expired';

  @override
  String get transferMissing => 'Moved or deleted';

  @override
  String transferNotSent(String reason) {
    return 'Not sent: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Not received: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name is out of disk space ($size short)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'not enough disk space ($size short)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return '$name’s save location is unavailable';
  }

  @override
  String get reasonDestUnavailable =>
      'the save location is unavailable — check it in Settings';

  @override
  String get reasonFileTooLarge =>
      'the save location is on a FAT32 drive, which can’t hold files over 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name isn’t receiving files';
  }

  @override
  String get reasonSourceChanged => 'a file changed while it was being sent';

  @override
  String get reasonSourceMissing => 'a file no longer exists';

  @override
  String get reasonReadError => 'a file couldn’t be read';

  @override
  String get reasonWriteFailed => 'the files couldn’t be written';

  @override
  String get reasonHashMismatch => 'a file was damaged in transit';

  @override
  String reasonUnsupported(String name) {
    return '$name needs to update to receive files';
  }

  @override
  String get reasonOther => 'something went wrong';

  @override
  String get revealInFinder => 'Show in Finder';

  @override
  String get revealInFolder => 'Show in Folder';

  @override
  String get revealOpenFolder => 'Open Folder';

  @override
  String get transferResend => 'Send Again';

  @override
  String get transferRemove => 'Remove from List';

  @override
  String get transferCopyPath => 'Copy Path';

  @override
  String get transferPathCopied => 'Path copied';

  @override
  String sendingTo(String name, String percent) {
    return 'Sending to $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Receiving from $name · $percent';
  }

  @override
  String get receiveFiles => 'Receive files from other devices';

  @override
  String get saveTo => 'Save to';

  @override
  String get saveToChange => 'Change…';

  @override
  String get saveToDefault => 'Downloads (default)';

  @override
  String get saveToUseDefault => 'Use Downloads';

  @override
  String get receiveNotify => 'Notify when files arrive';

  @override
  String receiveFootnote(String device) {
    return 'Only paired devices can send files to $device. While files are transferring, $device won’t go to sleep on its own.';
  }

  @override
  String get saveDirNotFound => 'This folder doesn’t exist.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry can’t save files in this folder.';

  @override
  String get saveDirPermission =>
      'PasteFerry isn’t allowed to use this folder. Allow it in System Settings → Privacy & Security → Files and Folders.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count file names had characters Windows doesn’t allow; they were replaced with similar full-width characters',
      one:
          '1 file name had characters Windows doesn’t allow; they were replaced with similar full-width characters',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Same network';

  @override
  String get sendRingOther => 'Other networks';

  @override
  String sendOfflineList(String names) {
    return 'Offline: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Transfer list';

  @override
  String get sendLayoutSide => 'Beside the radar';

  @override
  String get sendLayoutBelow => 'Below the radar';

  @override
  String get general => 'General';

  @override
  String get launchAtLogin => 'Launch at login';

  @override
  String get launchAtLoginDesc =>
      'Start in the background when you log in. Changing this does not stop the current session.';

  @override
  String get realtimeSync => 'Real-time clipboard sync';

  @override
  String get realtimeSyncDesc =>
      'Automatically share new copies with paired devices. Local history and Send Files remain available when off.';

  @override
  String get syncBacklog => 'Catch up after reconnecting';

  @override
  String get syncBacklogDesc =>
      'Off by default: missed copies are skipped. When enabled, up to 20 copies from the last 24 hours enter history without replacing the clipboard.';

  @override
  String get peerRealtimeSync => 'Sync with this computer';

  @override
  String get syncPaused => 'Clipboard sync paused';

  @override
  String get quitApp => 'Quit PasteFerry';

  @override
  String get quitAppDesc =>
      'Stop all PasteFerry processes. Your launch-at-login preference is preserved.';

  @override
  String get quitTransfersWarning =>
      'Files are still being transferred. Quit and interrupt these transfers?';

  @override
  String get backgroundRunningTitle => 'PasteFerry will keep running';

  @override
  String get backgroundRunningBody =>
      'Closing the window keeps sync and quick paste running. To stop everything, choose Quit PasteFerry in Settings or the app menu.';
}
