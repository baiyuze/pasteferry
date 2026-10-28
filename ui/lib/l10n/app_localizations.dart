import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
    Locale.fromSubtags(
      languageCode: 'zh',
      countryCode: 'HK',
      scriptCode: 'Hant',
    ),
    Locale.fromSubtags(
      languageCode: 'zh',
      countryCode: 'TW',
      scriptCode: 'Hant',
    ),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry'**
  String get appName;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get navDevices;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @linkConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get linkConnecting;

  /// No description provided for @linkServiceNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Service not running'**
  String get linkServiceNotRunning;

  /// No description provided for @linkLanMode.
  ///
  /// In en, this message translates to:
  /// **'Looking for devices on this network'**
  String get linkLanMode;

  /// No description provided for @linkServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server; syncing on this network'**
  String get linkServerUnreachable;

  /// No description provided for @linkNothingOn.
  ///
  /// In en, this message translates to:
  /// **'Local network discovery is off and no server is set'**
  String get linkNothingOn;

  /// No description provided for @linkLanBlocked.
  ///
  /// In en, this message translates to:
  /// **'macOS is blocking the local network'**
  String get linkLanBlocked;

  /// No description provided for @linkOnlinePeers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 device online} other{{count} devices online}}'**
  String linkOnlinePeers(int count);

  /// No description provided for @linkServerConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected to the server'**
  String get linkServerConnected;

  /// No description provided for @linkConnectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost: {detail}'**
  String linkConnectionLost(String detail);

  /// No description provided for @linkServiceDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Service disconnected'**
  String get linkServiceDisconnected;

  /// No description provided for @linkServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Background sync is off'**
  String get linkServiceDisabled;

  /// No description provided for @errServiceNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to the background service'**
  String get errServiceNotConnected;

  /// No description provided for @errUnimplemented.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t available yet'**
  String get errUnimplemented;

  /// No description provided for @errUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the background service'**
  String get errUnavailable;

  /// No description provided for @errServiceStart.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the background service: {detail}'**
  String errServiceStart(String detail);

  /// No description provided for @errServiceRestart.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restart the background service: {detail}'**
  String errServiceRestart(String detail);

  /// No description provided for @errAutostart.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t set PasteFerry to start at login: {detail}'**
  String errAutostart(String detail);

  /// No description provided for @thisMacTitle.
  ///
  /// In en, this message translates to:
  /// **'This Mac'**
  String get thisMacTitle;

  /// No description provided for @thisPcTitle.
  ///
  /// In en, this message translates to:
  /// **'This computer'**
  String get thisPcTitle;

  /// No description provided for @thisMacInText.
  ///
  /// In en, this message translates to:
  /// **'this Mac'**
  String get thisMacInText;

  /// No description provided for @thisPcInText.
  ///
  /// In en, this message translates to:
  /// **'this computer'**
  String get thisPcInText;

  /// No description provided for @bothMacs.
  ///
  /// In en, this message translates to:
  /// **'both Macs'**
  String get bothMacs;

  /// No description provided for @bothDevices.
  ///
  /// In en, this message translates to:
  /// **'both devices'**
  String get bothDevices;

  /// No description provided for @thisDeviceShort.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDeviceShort;

  /// No description provided for @fromDevice.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String fromDevice(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}s ago'**
  String secondsAgo(int n);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 minute ago} other{{n} minutes ago}}'**
  String minutesAgo(int n);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 hour ago} other{{n} hours ago}}'**
  String hoursAgo(int n);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Yesterday} other{{n} days ago}}'**
  String daysAgo(int n);

  /// No description provided for @monthDay.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day}'**
  String monthDay(int month, int day);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 hour} other{{n} hours}}'**
  String durationHours(int n);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day} other{{n} days}}'**
  String durationDays(int n);

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy on any of your devices and it shows up here'**
  String get historyEmptySubtitle;

  /// No description provided for @historyCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String historyCount(int count);

  /// No description provided for @historyCountKept.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}, kept for {ttl}'**
  String historyCountKept(int count, String ttl);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get filterText;

  /// No description provided for @filterImage.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get filterImage;

  /// No description provided for @filterFile.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get filterFile;

  /// No description provided for @filterLink.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get filterLink;

  /// No description provided for @historyClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClearTooltip;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing of this kind'**
  String get historyEmptyFilteredTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Copy text, an image or a file on any paired device and it appears here.'**
  String get historyEmptyBody;

  /// No description provided for @clearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the whole history?'**
  String get clearConfirmTitle;

  /// No description provided for @clearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Everything synced from your devices, and the cached files, will be removed from {device}. The original files aren\'t affected.'**
  String clearConfirmBody(String device);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @permDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry can\'t read the clipboard'**
  String get permDeniedTitle;

  /// No description provided for @permAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow PasteFerry to read the clipboard'**
  String get permAskTitle;

  /// No description provided for @permDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'What you copy on this Mac won\'t be synced. In System Settings, set PasteFerry Daemon to Allow.'**
  String get permDeniedBody;

  /// No description provided for @permAskBody.
  ///
  /// In en, this message translates to:
  /// **'Otherwise macOS asks every time. In System Settings, set PasteFerry Daemon to Allow.'**
  String get permAskBody;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get openSystemSettings;

  /// No description provided for @fetch.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get fetch;

  /// No description provided for @fetchStarted.
  ///
  /// In en, this message translates to:
  /// **'Receiving… See History for progress'**
  String get fetchStarted;

  /// No description provided for @transferFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get transferFailed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @putOnClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get putOnClipboard;

  /// No description provided for @putOnClipboardDone.
  ///
  /// In en, this message translates to:
  /// **'On the clipboard'**
  String get putOnClipboardDone;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete this item'**
  String get deleteRecord;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @emptyRecord.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get emptyRecord;

  /// No description provided for @imageRecord.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageRecord;

  /// No description provided for @itemsSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} and {others, plural, =1{1 more} other{{others} more}}'**
  String itemsSummary(String name, int others, int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search text and file names'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// No description provided for @searchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 match} other{{count} matches}}'**
  String searchResultCount(int count);

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches for “{query}”'**
  String searchEmptyTitle(String query);

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Search looks through copied text and the names of copied files.'**
  String get searchEmptyBody;

  /// No description provided for @favoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAction;

  /// No description provided for @unfavoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get unfavoriteAction;

  /// No description provided for @favoritedToast.
  ///
  /// In en, this message translates to:
  /// **'Added to Favorites'**
  String get favoritedToast;

  /// No description provided for @unfavoritedToast.
  ///
  /// In en, this message translates to:
  /// **'Moved back to History'**
  String get unfavoritedToast;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @favoriteSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get favoriteSaving;

  /// No description provided for @favoritedAt.
  ///
  /// In en, this message translates to:
  /// **'Saved {date}'**
  String favoritedAt(String date);

  /// No description provided for @favoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}} · never cleaned up · up to {size}'**
  String favoritesSubtitle(int count, String size);

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Star an item in History to keep a copy here. Favorites are never cleaned up automatically.'**
  String get favoritesEmptyBody;

  /// No description provided for @favoritesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search favorites'**
  String get favoritesSearchHint;

  /// No description provided for @favoriteLargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save a copy of {size}?'**
  String favoriteLargeTitle(String size);

  /// No description provided for @favoriteLargeBody.
  ///
  /// In en, this message translates to:
  /// **'A favorite keeps its own copy, so changing or deleting the original files won\'t affect it. This uses {size} on {device}.'**
  String favoriteLargeBody(String size, String device);

  /// No description provided for @saveCopy.
  ///
  /// In en, this message translates to:
  /// **'Save copy'**
  String get saveCopy;

  /// No description provided for @clearKeepsFavorites.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your 1 favorite stays.} other{Your {count} favorites stay.}}'**
  String clearKeepsFavorites(int count);

  /// No description provided for @favoritesUsage.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesUsage;

  /// No description provided for @favoritesUsageDesc.
  ///
  /// In en, this message translates to:
  /// **'Favorites are never cleaned up, whatever the settings above'**
  String get favoritesUsageDesc;

  /// No description provided for @upToSize.
  ///
  /// In en, this message translates to:
  /// **'Up to {size}'**
  String upToSize(String size);

  /// No description provided for @detailChars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 character} other{{count} characters}}'**
  String detailChars(int count);

  /// No description provided for @detailTruncated.
  ///
  /// In en, this message translates to:
  /// **'… {count} characters in total'**
  String detailTruncated(int count);

  /// No description provided for @detailMoreFiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more} other{{count} more}}'**
  String detailMoreFiles(int count);

  /// No description provided for @detailReceiveFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick it to download it first'**
  String get detailReceiveFirst;

  /// No description provided for @detailTotalSize.
  ///
  /// In en, this message translates to:
  /// **'{size} in total'**
  String detailTotalSize(String size);

  /// No description provided for @quickPaste.
  ///
  /// In en, this message translates to:
  /// **'Quick paste'**
  String get quickPaste;

  /// No description provided for @quickPasteWindow.
  ///
  /// In en, this message translates to:
  /// **'Quick paste window'**
  String get quickPasteWindow;

  /// No description provided for @quickPasteWindowDesc.
  ///
  /// In en, this message translates to:
  /// **'Press the shortcut in any app to bring up your history; pick an item and it\'s pasted'**
  String get quickPasteWindowDesc;

  /// No description provided for @quickPasteShortcut.
  ///
  /// In en, this message translates to:
  /// **'Shortcut'**
  String get quickPasteShortcut;

  /// No description provided for @quickPasteRecord.
  ///
  /// In en, this message translates to:
  /// **'Click to change'**
  String get quickPasteRecord;

  /// No description provided for @quickPasteRecording.
  ///
  /// In en, this message translates to:
  /// **'Press the new shortcut…'**
  String get quickPasteRecording;

  /// No description provided for @quickPasteUseDefault.
  ///
  /// In en, this message translates to:
  /// **'Use default'**
  String get quickPasteUseDefault;

  /// No description provided for @quickPasteNeedsModifier.
  ///
  /// In en, this message translates to:
  /// **'Include ⌃, ⌥, ⇧ or ⌘, or use a function key'**
  String get quickPasteNeedsModifier;

  /// No description provided for @quickPasteNeedsModifierPc.
  ///
  /// In en, this message translates to:
  /// **'Include Ctrl, Alt, Shift or the Windows key, or use a function key'**
  String get quickPasteNeedsModifierPc;

  /// No description provided for @quickPasteAfterPick.
  ///
  /// In en, this message translates to:
  /// **'After you pick an item'**
  String get quickPasteAfterPick;

  /// No description provided for @quickPastePasteIt.
  ///
  /// In en, this message translates to:
  /// **'Paste it'**
  String get quickPastePasteIt;

  /// No description provided for @quickPasteCopyIt.
  ///
  /// In en, this message translates to:
  /// **'Just copy it'**
  String get quickPasteCopyIt;

  /// No description provided for @quickPasteIndexKey.
  ///
  /// In en, this message translates to:
  /// **'Pick one of the first 9'**
  String get quickPasteIndexKey;

  /// No description provided for @quickPasteIndexKeyDesc.
  ///
  /// In en, this message translates to:
  /// **'In the quick paste window, hold this key and press 1–9'**
  String get quickPasteIndexKeyDesc;

  /// No description provided for @quickPasteAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get quickPasteAccessibility;

  /// No description provided for @quickPasteAccessibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Needed to paste for you. Without it, items are copied and you press ⌘V.'**
  String get quickPasteAccessibilityDesc;

  /// No description provided for @quickPasteAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get quickPasteAllowed;

  /// No description provided for @quickPasteAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow…'**
  String get quickPasteAllow;

  /// No description provided for @quickPasteNotRunning.
  ///
  /// In en, this message translates to:
  /// **'The quick paste window isn\'t running'**
  String get quickPasteNotRunning;

  /// No description provided for @quickPasteInUse.
  ///
  /// In en, this message translates to:
  /// **'{key} is used by another app. Pick another shortcut.'**
  String quickPasteInUse(String key);

  /// No description provided for @quickPasteHotkeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t set {key}: {detail}'**
  String quickPasteHotkeyFailed(String key, String detail);

  /// No description provided for @quickPastePortalKey.
  ///
  /// In en, this message translates to:
  /// **'Set in the system shortcut settings'**
  String get quickPastePortalKey;

  /// No description provided for @quickPasteWaylandDesc.
  ///
  /// In en, this message translates to:
  /// **'On Wayland, add the shortcut in your desktop\'s keyboard settings. Picked items are copied; press Ctrl+V to paste.'**
  String get quickPasteWaylandDesc;

  /// No description provided for @quickPasteAddShortcut.
  ///
  /// In en, this message translates to:
  /// **'Add system shortcut'**
  String get quickPasteAddShortcut;

  /// No description provided for @quickPasteShortcutAdded.
  ///
  /// In en, this message translates to:
  /// **'Added. Press {key} to try it.'**
  String quickPasteShortcutAdded(String key);

  /// No description provided for @quickPasteShortcutManual.
  ///
  /// In en, this message translates to:
  /// **'Add a custom shortcut in your desktop\'s keyboard settings that runs: {command}'**
  String quickPasteShortcutManual(String command);

  /// No description provided for @pickerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get pickerSearch;

  /// No description provided for @pickerPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pickerPaste;

  /// No description provided for @pickerPlainText.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get pickerPlainText;

  /// No description provided for @pickerCopyOnly.
  ///
  /// In en, this message translates to:
  /// **'Copy only'**
  String get pickerCopyOnly;

  /// No description provided for @pickerUnfavoriteHint.
  ///
  /// In en, this message translates to:
  /// **'Remove (back to History)'**
  String get pickerUnfavoriteHint;

  /// No description provided for @pickerPasteManually.
  ///
  /// In en, this message translates to:
  /// **'Picked items are copied — press {key} to paste'**
  String pickerPasteManually(String key);

  /// No description provided for @pickerGrantHint.
  ///
  /// In en, this message translates to:
  /// **'Allow Accessibility to paste directly'**
  String get pickerGrantHint;

  /// No description provided for @pickerElevated.
  ///
  /// In en, this message translates to:
  /// **'This window runs as administrator — press {key} to paste after picking'**
  String pickerElevated(String key);

  /// No description provided for @pickerDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading — pastes when done'**
  String get pickerDownloading;

  /// No description provided for @imagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Image preview'**
  String get imagePreviewTitle;

  /// No description provided for @closePreview.
  ///
  /// In en, this message translates to:
  /// **'Close preview'**
  String get closePreview;

  /// No description provided for @previousImage.
  ///
  /// In en, this message translates to:
  /// **'Previous image'**
  String get previousImage;

  /// No description provided for @nextImage.
  ///
  /// In en, this message translates to:
  /// **'Next image'**
  String get nextImage;

  /// No description provided for @previewHint.
  ///
  /// In en, this message translates to:
  /// **'Scroll or pinch to zoom, drag to move around'**
  String get previewHint;

  /// No description provided for @fitWindow.
  ///
  /// In en, this message translates to:
  /// **'Fit to window'**
  String get fitWindow;

  /// No description provided for @previewDeleted.
  ///
  /// In en, this message translates to:
  /// **'This image has been deleted from the history'**
  String get previewDeleted;

  /// No description provided for @previewExpired.
  ///
  /// In en, this message translates to:
  /// **'This image has expired and can\'t be previewed'**
  String get previewExpired;

  /// No description provided for @previewDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading the image…'**
  String get previewDownloading;

  /// No description provided for @previewDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The download failed. Try again.'**
  String get previewDownloadFailed;

  /// No description provided for @previewNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'This image isn\'t on this computer yet'**
  String get previewNotDownloaded;

  /// No description provided for @downloadAndPreview.
  ///
  /// In en, this message translates to:
  /// **'Download and preview'**
  String get downloadAndPreview;

  /// No description provided for @previewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This image can\'t be previewed right now'**
  String get previewUnavailable;

  /// No description provided for @imageSemantic.
  ///
  /// In en, this message translates to:
  /// **'Image from the history'**
  String get imageSemantic;

  /// No description provided for @previewUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t read the image. The file may have been cleaned up or damaged.'**
  String get previewUnreadable;

  /// No description provided for @devicesSubtitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Once paired, your devices share one clipboard'**
  String get devicesSubtitleEmpty;

  /// No description provided for @devicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{paired} paired, {online} online'**
  String devicesSubtitle(int paired, int online);

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add device'**
  String get addDevice;

  /// No description provided for @thisDeviceFootnote.
  ///
  /// In en, this message translates to:
  /// **'When pairing, {both} show the same two lines of security fingerprints, one for each device. Confirm only if they match character for character.'**
  String thisDeviceFootnote(String both);

  /// No description provided for @noDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No paired devices yet'**
  String get noDevicesTitle;

  /// No description provided for @noDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'Open PasteFerry on your other computer and link the two with a 6-character pairing code. On the same network, you can also open Search nearby on both and click the other one.'**
  String get noDevicesBody;

  /// No description provided for @pairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired devices'**
  String get pairedDevices;

  /// No description provided for @pairedFootnote.
  ///
  /// In en, this message translates to:
  /// **'Direct: data goes straight between the two devices. Relay: when the network blocks a direct path, data goes through your server and stays end-to-end encrypted.'**
  String get pairedFootnote;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @relay.
  ///
  /// In en, this message translates to:
  /// **'Relay'**
  String get relay;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreActions;

  /// No description provided for @copyFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Copy fingerprint'**
  String get copyFingerprint;

  /// No description provided for @unpairEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Unpair…'**
  String get unpairEllipsis;

  /// No description provided for @fingerprintCopied.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint copied'**
  String get fingerprintCopied;

  /// No description provided for @unpairTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpair “{name}”?'**
  String unpairTitle(String name);

  /// No description provided for @unpairBody.
  ///
  /// In en, this message translates to:
  /// **'The two devices will stop syncing. To sync again, you\'ll need to pair them and check the fingerprints again.'**
  String get unpairBody;

  /// No description provided for @unpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get unpair;

  /// No description provided for @unpaired.
  ///
  /// In en, this message translates to:
  /// **'Unpaired'**
  String get unpaired;

  /// No description provided for @enterAddressEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Enter its address…'**
  String get enterAddressEllipsis;

  /// No description provided for @setAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address of “{name}”'**
  String setAddressTitle(String name);

  /// No description provided for @setAddressBody.
  ///
  /// In en, this message translates to:
  /// **'Use this when the two devices are on different subnets, or both changed addresses. Enter the address shown on “{name}” under Add device → Show a code.'**
  String setAddressBody(String name);

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Looking for it at that address'**
  String get addressSaved;

  /// No description provided for @lanBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'macOS is blocking the local network'**
  String get lanBlockedTitle;

  /// No description provided for @lanBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on PasteFerry Daemon in System Settings → Privacy & Security → Local Network. Until then, {device} can\'t connect to devices on this network.'**
  String lanBlockedBody(String device);

  /// No description provided for @searchNearby.
  ///
  /// In en, this message translates to:
  /// **'Search nearby'**
  String get searchNearby;

  /// No description provided for @nearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get nearbyTitle;

  /// No description provided for @nearbySearching.
  ///
  /// In en, this message translates to:
  /// **'Looking for nearby devices…'**
  String get nearbySearching;

  /// No description provided for @nearbyHint.
  ///
  /// In en, this message translates to:
  /// **'Open Search nearby on the other computer too, and it shows up here. Click it to pair.'**
  String get nearbyHint;

  /// No description provided for @nearbyVisible.
  ///
  /// In en, this message translates to:
  /// **'While this window is open, devices on this network can see the name of {device}.'**
  String nearbyVisible(String device);

  /// No description provided for @nearbyPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get nearbyPaired;

  /// No description provided for @nearbyRequesting.
  ///
  /// In en, this message translates to:
  /// **'Contacting “{name}”…'**
  String nearbyRequesting(String name);

  /// No description provided for @nearbyNoReply.
  ///
  /// In en, this message translates to:
  /// **'“{name}” didn\'t answer. Make sure Search nearby is still open on it.'**
  String nearbyNoReply(String name);

  /// No description provided for @nearbyLanOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Local network discovery is off'**
  String get nearbyLanOffTitle;

  /// No description provided for @nearbyLanOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on “Find devices on this network” in Settings → Connection to see nearby devices, or pair with a code instead.'**
  String get nearbyLanOffBody;

  /// No description provided for @generateCode.
  ///
  /// In en, this message translates to:
  /// **'Show a code'**
  String get generateCode;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a code'**
  String get enterCode;

  /// No description provided for @codeFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create a pairing code'**
  String get codeFailedTitle;

  /// No description provided for @enterOnOther.
  ///
  /// In en, this message translates to:
  /// **'Enter this code on your other device'**
  String get enterOnOther;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'Click to copy. Valid for 5 minutes.'**
  String get codeHint;

  /// No description provided for @afterEnterFootnote.
  ///
  /// In en, this message translates to:
  /// **'Once it\'s entered, {both} show the same two lines of security fingerprints. Confirm only if they match.'**
  String afterEnterFootnote(String both);

  /// No description provided for @codeInvalid.
  ///
  /// In en, this message translates to:
  /// **'A pairing code is 6 letters or digits'**
  String get codeInvalid;

  /// No description provided for @localAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get localAddress;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'On a different subnet? Enter this address on the other device as well.'**
  String get addressHint;

  /// No description provided for @addressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get addressCopied;

  /// No description provided for @differentSubnet.
  ///
  /// In en, this message translates to:
  /// **'On a different subnet?'**
  String get differentSubnet;

  /// No description provided for @peerAddress.
  ///
  /// In en, this message translates to:
  /// **'Address shown under the code'**
  String get peerAddress;

  /// No description provided for @pairNotFound.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find that device. If it\'s on a different subnet, enter the address shown under its code.'**
  String get pairNotFound;

  /// No description provided for @pairNotFoundAddress.
  ///
  /// In en, this message translates to:
  /// **'Nothing answered at that address. Check the address and that the other device is still showing its code. A firewall on that device may also be blocking it.'**
  String get pairNotFoundAddress;

  /// No description provided for @codeWrong.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right, or it has expired'**
  String get codeWrong;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Show a new one on the other device.'**
  String get codeExpired;

  /// No description provided for @addressInvalid.
  ///
  /// In en, this message translates to:
  /// **'That address isn\'t valid. Enter something like 192.168.1.20.'**
  String get addressInvalid;

  /// No description provided for @pairNoChannel.
  ///
  /// In en, this message translates to:
  /// **'Turn on local network discovery or set a server in Settings → Connection first.'**
  String get pairNoChannel;

  /// No description provided for @enterCodeShown.
  ///
  /// In en, this message translates to:
  /// **'Enter the code shown on your other device'**
  String get enterCodeShown;

  /// No description provided for @pairingDone.
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get pairingDone;

  /// No description provided for @pairingRejected.
  ///
  /// In en, this message translates to:
  /// **'Pairing declined'**
  String get pairingRejected;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check the security fingerprints'**
  String get verifyTitle;

  /// No description provided for @pairingWith.
  ///
  /// In en, this message translates to:
  /// **'Pairing with “{name}”'**
  String pairingWith(String name);

  /// No description provided for @verifyBody.
  ///
  /// In en, this message translates to:
  /// **'The two lines on {both} must be identical. If even one character differs, someone may be tampering with the connection, so decline.'**
  String verifyBody(String both);

  /// No description provided for @rejectMismatch.
  ///
  /// In en, this message translates to:
  /// **'Mismatch, decline'**
  String get rejectMismatch;

  /// No description provided for @confirmMatch.
  ///
  /// In en, this message translates to:
  /// **'They match, pair'**
  String get confirmMatch;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server (optional)'**
  String get server;

  /// No description provided for @signalingUrl.
  ///
  /// In en, this message translates to:
  /// **'Signaling server'**
  String get signalingUrl;

  /// No description provided for @signalingUrlDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for local sync only'**
  String get signalingUrlDesc;

  /// No description provided for @signalingUrlPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'ws://server-address:8787/signal'**
  String get signalingUrlPlaceholder;

  /// No description provided for @publicStun.
  ///
  /// In en, this message translates to:
  /// **'Improve direct connections'**
  String get publicStun;

  /// No description provided for @publicStunDesc.
  ///
  /// In en, this message translates to:
  /// **'Public servers can see your public IP'**
  String get publicStunDesc;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connectionStatus;

  /// No description provided for @disconnectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Check the server address and availability'**
  String get disconnectedDesc;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @serverCleared.
  ///
  /// In en, this message translates to:
  /// **'Server removed. Syncing on this network only.'**
  String get serverCleared;

  /// No description provided for @localNetwork.
  ///
  /// In en, this message translates to:
  /// **'Local network'**
  String get localNetwork;

  /// No description provided for @lanDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Find devices on this network'**
  String get lanDiscovery;

  /// No description provided for @lanDiscoveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Anonymous discovery; names are visible only during Search nearby'**
  String get lanDiscoveryDesc;

  /// No description provided for @macLocalNetwork.
  ///
  /// In en, this message translates to:
  /// **'Local Network access'**
  String get macLocalNetwork;

  /// No description provided for @macLocalNetworkDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow PasteFerry Daemon in System Settings'**
  String get macLocalNetworkDesc;

  /// No description provided for @allowLan.
  ///
  /// In en, this message translates to:
  /// **'Windows Firewall'**
  String get allowLan;

  /// No description provided for @allowLanDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow blocked connections; requires administrator approval'**
  String get allowLanDesc;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @allowLanDone.
  ///
  /// In en, this message translates to:
  /// **'Allowed. Other devices can now reach this one.'**
  String get allowLanDone;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @autoSyncLimit.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync limit'**
  String get autoSyncLimit;

  /// No description provided for @autoSyncLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive larger items manually from History'**
  String get autoSyncLimitDesc;

  /// No description provided for @autoApply.
  ///
  /// In en, this message translates to:
  /// **'Put received items on the clipboard'**
  String get autoApply;

  /// No description provided for @whatToSync.
  ///
  /// In en, this message translates to:
  /// **'What to sync'**
  String get whatToSync;

  /// No description provided for @syncFiles.
  ///
  /// In en, this message translates to:
  /// **'Files and folders'**
  String get syncFiles;

  /// No description provided for @syncText.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get syncText;

  /// No description provided for @syncRich.
  ///
  /// In en, this message translates to:
  /// **'Rich text'**
  String get syncRich;

  /// No description provided for @syncImages.
  ///
  /// In en, this message translates to:
  /// **'Images and screenshots'**
  String get syncImages;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @storageFootnote.
  ///
  /// In en, this message translates to:
  /// **'Expired history and cached files are deleted automatically.'**
  String get storageFootnote;

  /// No description provided for @keepHistory.
  ///
  /// In en, this message translates to:
  /// **'Keep history for'**
  String get keepHistory;

  /// No description provided for @keepCache.
  ///
  /// In en, this message translates to:
  /// **'Keep cached files for'**
  String get keepCache;

  /// No description provided for @keepCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'No longer than history retention'**
  String get keepCacheDesc;

  /// No description provided for @cacheUsage.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get cacheUsage;

  /// No description provided for @backgroundSync.
  ///
  /// In en, this message translates to:
  /// **'Background sync'**
  String get backgroundSync;

  /// No description provided for @backgroundService.
  ///
  /// In en, this message translates to:
  /// **'Background service'**
  String get backgroundService;

  /// No description provided for @backgroundServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Starts at login; syncs with the window closed'**
  String get backgroundServiceDesc;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @restarted.
  ///
  /// In en, this message translates to:
  /// **'Background service restarted'**
  String get restarted;

  /// No description provided for @disableEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Turn off…'**
  String get disableEllipsis;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDesc.
  ///
  /// In en, this message translates to:
  /// **'Open source under the AGPL-3.0'**
  String get aboutDesc;

  /// No description provided for @homepage.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get homepage;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get feedback;

  /// No description provided for @disableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off background sync?'**
  String get disableTitle;

  /// No description provided for @disableBody.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry on {device} will stop syncing and won\'t start at login. History and pairings are kept.'**
  String disableBody(String device);

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get disable;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Background sync is off'**
  String get disabled;

  /// No description provided for @urlMustBeWs.
  ///
  /// In en, this message translates to:
  /// **'The address must start with ws:// or wss://'**
  String get urlMustBeWs;

  /// No description provided for @serverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Server updated. Reconnecting…'**
  String get serverUpdated;

  /// No description provided for @deviceNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Device name updated'**
  String get deviceNameUpdated;

  /// No description provided for @diagIntro.
  ///
  /// In en, this message translates to:
  /// **'This report has the app version, your system, settings, devices and recent logs. Device names, the server address, public IP addresses, your user folder and file names are replaced, and what you copy is never written to the logs. Issues on GitHub are public, so read it through before posting.'**
  String get diagIntro;

  /// No description provided for @diagVerboseTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed logging'**
  String get diagVerboseTitle;

  /// No description provided for @diagVerboseDesc.
  ///
  /// In en, this message translates to:
  /// **'For connection problems: turn it on, make the problem happen again, then come back for the report. It turns itself off after 30 minutes.'**
  String get diagVerboseDesc;

  /// No description provided for @diagVerboseOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on for 30 minutes'**
  String get diagVerboseOn;

  /// No description provided for @diagVerboseUntil.
  ///
  /// In en, this message translates to:
  /// **'On until {time}'**
  String diagVerboseUntil(String time);

  /// No description provided for @diagVerboseOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get diagVerboseOff;

  /// No description provided for @diagRefresh.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get diagRefresh;

  /// No description provided for @diagSave.
  ///
  /// In en, this message translates to:
  /// **'Save as file'**
  String get diagSave;

  /// No description provided for @diagSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to your Downloads folder: {name}'**
  String diagSaved(String name);

  /// No description provided for @diagCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy report'**
  String get diagCopy;

  /// No description provided for @diagCopied.
  ///
  /// In en, this message translates to:
  /// **'Report copied'**
  String get diagCopied;

  /// No description provided for @diagNewIssue.
  ///
  /// In en, this message translates to:
  /// **'New issue on GitHub'**
  String get diagNewIssue;

  /// No description provided for @diagIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Report copied. Paste it into the issue\'s “Diagnostics report” box.'**
  String get diagIssueHint;

  /// No description provided for @diagFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the report: {detail}'**
  String diagFailed(String detail);

  /// No description provided for @svcExtractTitle.
  ///
  /// In en, this message translates to:
  /// **'Install or extract PasteFerry first'**
  String get svcExtractTitle;

  /// No description provided for @svcExtractBody.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry is running straight from the zip, and its temporary folder disappears when you close it. Run the installer, or extract the whole folder and open it from there, to turn on background sync.'**
  String get svcExtractBody;

  /// No description provided for @svcMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move PasteFerry to Applications first'**
  String get svcMoveTitle;

  /// No description provided for @svcMoveBody.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry is running straight from the disk image. Drag it into Applications, eject the disk image, and open it from Applications to turn on background sync.'**
  String get svcMoveBody;

  /// No description provided for @svcStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Get started with PasteFerry'**
  String get svcStartTitle;

  /// No description provided for @svcStartBody.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry runs a small background process for clipboard sync. Closing the window keeps it running. Launch at login is a separate setting and is off for new installations.'**
  String get svcStartBody;

  /// No description provided for @svcEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn on background sync'**
  String get svcEnable;

  /// No description provided for @svcStaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn background sync on again'**
  String get svcStaleTitle;

  /// No description provided for @svcStaleBodyWin.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry has moved, but starting at login still points to the old place. Turn it on again so the background process uses this copy. History and pairings are kept.'**
  String get svcStaleBodyWin;

  /// No description provided for @svcStaleBodyMac.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry has moved, or was installed with an old script. Turn it on again so the background process uses this app. History and pairings are kept.'**
  String get svcStaleBodyMac;

  /// No description provided for @svcReenable.
  ///
  /// In en, this message translates to:
  /// **'Turn on again'**
  String get svcReenable;

  /// No description provided for @svcStoppedTitle.
  ///
  /// In en, this message translates to:
  /// **'The background service isn\'t running'**
  String get svcStoppedTitle;

  /// No description provided for @svcStoppedBody.
  ///
  /// In en, this message translates to:
  /// **'The background service is stopped. Start it with the button below; launch at login is controlled separately in Settings.'**
  String get svcStoppedBody;

  /// No description provided for @svcDevBodyWin.
  ///
  /// In en, this message translates to:
  /// **'This is a development build with no pasteferryd.exe next to it. Run scripts\\build-windows.ps1 in the source folder to build a complete version.'**
  String get svcDevBodyWin;

  /// No description provided for @svcDevBodyLinux.
  ///
  /// In en, this message translates to:
  /// **'This is a development build with no pasteferryd next to it. Run ./scripts/package-linux.sh in the source folder to build a complete version.'**
  String get svcDevBodyLinux;

  /// No description provided for @svcDevBodyMac.
  ///
  /// In en, this message translates to:
  /// **'This is a development build without the background service. Run ./scripts/install-macos.sh in the source folder to install it.'**
  String get svcDevBodyMac;

  /// No description provided for @svcLogPath.
  ///
  /// In en, this message translates to:
  /// **'Log: {path}'**
  String svcLogPath(String path);

  /// No description provided for @svcCanDisable.
  ///
  /// In en, this message translates to:
  /// **'You can turn background sync off anytime in Settings.'**
  String get svcCanDisable;

  /// No description provided for @officialService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get officialService;

  /// No description provided for @useOfficialService.
  ///
  /// In en, this message translates to:
  /// **'Use the service'**
  String get useOfficialService;

  /// No description provided for @officialServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync across networks, direct connections first'**
  String get officialServiceDesc;

  /// No description provided for @officialPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Connects to the service only when enabled and records the essential connection information. Direct connections are tried first; relay access is requested only if they fail. Content, real device names and raw system identifiers are not uploaded.'**
  String get officialPrivacy;

  /// No description provided for @officialEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable the service?'**
  String get officialEnableTitle;

  /// No description provided for @officialSwitchConfirm.
  ///
  /// In en, this message translates to:
  /// **'This switches away from your custom server. Its saved address will be retained.'**
  String get officialSwitchConfirm;

  /// No description provided for @customServer.
  ///
  /// In en, this message translates to:
  /// **'Custom server'**
  String get customServer;

  /// No description provided for @saveAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Save and connect'**
  String get saveAndConnect;

  /// No description provided for @officialLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking the allowance…'**
  String get officialLoading;

  /// No description provided for @officialFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Can\'t get the allowance right now. It will be retried automatically.'**
  String get officialFetchFailed;

  /// No description provided for @officialUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Usage is unavailable; existing data may be out of date'**
  String get officialUnavailable;

  /// No description provided for @officialQuotaTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily relay allowance used up'**
  String get officialQuotaTitle;

  /// No description provided for @officialQuotaBody.
  ///
  /// In en, this message translates to:
  /// **'The service relay is paused until the daily reset at midnight Beijing time. LAN and direct Internet connections remain available. Failed transfers can be retried later.'**
  String get officialQuotaBody;

  /// No description provided for @officialPeerQuota.
  ///
  /// In en, this message translates to:
  /// **'The peer has no relay allowance left. Direct connections remain available.'**
  String get officialPeerQuota;

  /// No description provided for @officialPaused.
  ///
  /// In en, this message translates to:
  /// **'The service relay is unavailable. Direct connections remain available.'**
  String get officialPaused;

  /// No description provided for @officialViewUsage.
  ///
  /// In en, this message translates to:
  /// **'View usage'**
  String get officialViewUsage;

  /// No description provided for @officialAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get officialAcknowledge;

  /// No description provided for @officialToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s relay allowance'**
  String get officialToday;

  /// No description provided for @officialUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get officialUsed;

  /// No description provided for @officialRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get officialRemaining;

  /// No description provided for @officialDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily allowance'**
  String get officialDailyLimit;

  /// No description provided for @officialUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get officialUpload;

  /// No description provided for @officialDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get officialDownload;

  /// No description provided for @officialReset.
  ///
  /// In en, this message translates to:
  /// **'Reset time (Beijing)'**
  String get officialReset;

  /// No description provided for @officialUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get officialUpdated;

  /// No description provided for @officialRoutes.
  ///
  /// In en, this message translates to:
  /// **'How devices connect'**
  String get officialRoutes;

  /// No description provided for @officialRoutesFootnote.
  ///
  /// In en, this message translates to:
  /// **'Direct connections don\'t go through the service relay and don\'t use the allowance.'**
  String get officialRoutesFootnote;

  /// No description provided for @officialDeviceID.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get officialDeviceID;

  /// No description provided for @officialWarning.
  ///
  /// In en, this message translates to:
  /// **'90% of the daily relay allowance has been used. Direct connections do not consume it.'**
  String get officialWarning;

  /// No description provided for @updateCheck.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get updateCheck;

  /// No description provided for @updateCheckEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Check for updates…'**
  String get updateCheckEllipsis;

  /// No description provided for @updateAuto.
  ///
  /// In en, this message translates to:
  /// **'Check for updates automatically'**
  String get updateAuto;

  /// No description provided for @updateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates…'**
  String get updateChecking;

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry {version} is the latest version.'**
  String updateUpToDate(String version);

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry {version} is available'**
  String updateAvailableTitle(String version);

  /// No description provided for @updateCurrentSize.
  ///
  /// In en, this message translates to:
  /// **'You have {current}. Download size {size}.'**
  String updateCurrentSize(String current, String size);

  /// No description provided for @updateNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get updateNew;

  /// No description provided for @updateFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get updateFixed;

  /// No description provided for @updateSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get updateSkip;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateInstall.
  ///
  /// In en, this message translates to:
  /// **'Download and install'**
  String get updateInstall;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {done} of {total}'**
  String updateDownloading(String done, String total);

  /// No description provided for @updateVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking the download…'**
  String get updateVerifying;

  /// No description provided for @updateInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing. PasteFerry will reopen by itself.'**
  String get updateInstalling;

  /// No description provided for @updateInstallingPassword.
  ///
  /// In en, this message translates to:
  /// **'Installing. Your system will ask for your password, because /opt needs administrator rights; PasteFerry then reopens by itself.'**
  String get updateInstallingPassword;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach GitHub or Gitee. Try again later.'**
  String get updateCheckFailed;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The download didn\'t finish. Try again, or download the new version from the website.'**
  String get updateDownloadFailed;

  /// No description provided for @updateInstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the installation: {error}'**
  String updateInstallFailed(String error);

  /// No description provided for @updateUnsupportedBuild.
  ///
  /// In en, this message translates to:
  /// **'This build can\'t check for updates.'**
  String get updateUnsupportedBuild;

  /// No description provided for @updateBlockedDev.
  ///
  /// In en, this message translates to:
  /// **'This is a development build, so it can\'t update itself.'**
  String get updateBlockedDev;

  /// No description provided for @updateBlockedMustMove.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry is running from the disk image. Drag it to Applications and open it from there to update automatically.'**
  String get updateBlockedMustMove;

  /// No description provided for @updateBlockedReadOnly.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry can\'t write to the folder it is installed in. Download the new version from the website instead.'**
  String get updateBlockedReadOnly;

  /// No description provided for @updateBlockedUnsupported.
  ///
  /// In en, this message translates to:
  /// **'There is no automatic update for this computer. Download the new version from the website.'**
  String get updateBlockedUnsupported;

  /// No description provided for @updateOpenDownload.
  ///
  /// In en, this message translates to:
  /// **'Open download page'**
  String get updateOpenDownload;

  /// No description provided for @updateSidebar.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String updateSidebar(String version);

  /// No description provided for @updatedTo.
  ///
  /// In en, this message translates to:
  /// **'Updated to {version}'**
  String updatedTo(String version);

  /// No description provided for @updateNotFinished.
  ///
  /// In en, this message translates to:
  /// **'The update didn\'t finish. You\'re still on {version}.'**
  String updateNotFinished(String version);

  /// No description provided for @updateNotFinishedWhy.
  ///
  /// In en, this message translates to:
  /// **'The update didn\'t finish. You\'re still on {version}. {detail}'**
  String updateNotFinishedWhy(String version, String detail);

  /// No description provided for @buildDetails.
  ///
  /// In en, this message translates to:
  /// **'UI {uiVersion} · Service {serviceVersion} · Build {build}'**
  String buildDetails(String uiVersion, String serviceVersion, String build);

  /// No description provided for @notReceived.
  ///
  /// In en, this message translates to:
  /// **'Not received — receive before pasting'**
  String get notReceived;

  /// No description provided for @receivedPreserved.
  ///
  /// In en, this message translates to:
  /// **'Received; use Copy to clipboard when ready'**
  String get receivedPreserved;

  /// No description provided for @clipboardWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Received, but the clipboard could not be updated'**
  String get clipboardWriteFailed;

  /// No description provided for @receivingStatus.
  ///
  /// In en, this message translates to:
  /// **'Receiving…'**
  String get receivingStatus;

  /// No description provided for @largeFileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Large file reminders'**
  String get largeFileNotifications;

  /// No description provided for @notificationsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled. Progress is shown in History.'**
  String get notificationsAllowed;

  /// No description provided for @notificationsNotRequested.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications so large files do not wait silently. You can always receive them from History.'**
  String get notificationsNotRequested;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked in system settings. Receive pending items from History.'**
  String get notificationsDenied;

  /// No description provided for @notificationsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Your desktop controls notification delivery and Do Not Disturb. Receive items from History if no reminder appears.'**
  String get notificationsUnknown;

  /// No description provided for @notificationsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'System notifications are unavailable. Receive large files from History.'**
  String get notificationsUnavailable;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get enableNotifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @notifyPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Receive to paste'**
  String get notifyPendingTitle;

  /// No description provided for @notifyPendingBody.
  ///
  /// In en, this message translates to:
  /// **'{device} · {name} · {size}\nReceive this item before pasting. You can also receive it from History.'**
  String notifyPendingBody(String device, String name, String size);

  /// No description provided for @notifyReceivingTitle.
  ///
  /// In en, this message translates to:
  /// **'Receiving…'**
  String get notifyReceivingTitle;

  /// No description provided for @notifyReceivingBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\nSee History for progress.'**
  String notifyReceivingBody(String name);

  /// No description provided for @notifyReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to paste'**
  String get notifyReadyTitle;

  /// No description provided for @notifyReadyBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\nReceived and placed on the clipboard.'**
  String notifyReadyBody(String name);

  /// No description provided for @notifyReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get notifyReceivedTitle;

  /// No description provided for @notifyReceivedBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\nYour clipboard was kept. Use Copy to clipboard when ready; this is also available in History.'**
  String notifyReceivedBody(String name);

  /// No description provided for @notifyFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not receive'**
  String get notifyFailedTitle;

  /// No description provided for @notifyFailedBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\n{error}\nTry again from this notification or History.'**
  String notifyFailedBody(String name, String error);

  /// No description provided for @notifyClipboardFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Received; clipboard was not updated'**
  String get notifyClipboardFailedTitle;

  /// No description provided for @notifyClipboardFailedBody.
  ///
  /// In en, this message translates to:
  /// **'{name}\n{error}\nUse Copy to clipboard to try again, here or in History.'**
  String notifyClipboardFailedBody(String name, String error);

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get reconnecting;

  /// No description provided for @reconnectDirect.
  ///
  /// In en, this message translates to:
  /// **'Connected directly'**
  String get reconnectDirect;

  /// No description provided for @reconnectRelay.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t connect directly, still using the relay'**
  String get reconnectRelay;

  /// No description provided for @reconnectOffline.
  ///
  /// In en, this message translates to:
  /// **'“{name}” is offline. Make sure PasteFerry is open on it.'**
  String reconnectOffline(String name);

  /// No description provided for @reconnectPending.
  ///
  /// In en, this message translates to:
  /// **'Still connecting, check back in a moment'**
  String get reconnectPending;

  /// No description provided for @renameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameAction;

  /// No description provided for @renameFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename favorite'**
  String get renameFavoriteTitle;

  /// No description provided for @renameFavoriteHint.
  ///
  /// In en, this message translates to:
  /// **'Shown in Favorites and Quick paste, and you can search for it. Leave it empty to show the content again.'**
  String get renameFavoriteHint;

  /// No description provided for @renamedToast.
  ///
  /// In en, this message translates to:
  /// **'Renamed'**
  String get renamedToast;

  /// No description provided for @aliasClearedToast.
  ///
  /// In en, this message translates to:
  /// **'Showing the content again'**
  String get aliasClearedToast;

  /// No description provided for @navSend.
  ///
  /// In en, this message translates to:
  /// **'Send Files'**
  String get navSend;

  /// No description provided for @sendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag files onto a device to send them directly'**
  String get sendSubtitle;

  /// No description provided for @sendNoDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No paired devices yet'**
  String get sendNoDevicesTitle;

  /// No description provided for @sendNoDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'Pair another computer first, then send files to it here.'**
  String get sendNoDevicesBody;

  /// No description provided for @sendDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drop onto a device to send'**
  String get sendDropHint;

  /// No description provided for @sendReleaseTo.
  ///
  /// In en, this message translates to:
  /// **'Release to send to {name}'**
  String sendReleaseTo(String name);

  /// No description provided for @sendLan.
  ///
  /// In en, this message translates to:
  /// **'Local network'**
  String get sendLan;

  /// No description provided for @sendRelayLeft.
  ///
  /// In en, this message translates to:
  /// **'Relay · {left} left today'**
  String sendRelayLeft(String left);

  /// No description provided for @sendNeedsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Needs update'**
  String get sendNeedsUpdate;

  /// No description provided for @sendNeedsUpdateTip.
  ///
  /// In en, this message translates to:
  /// **'{name} can receive files after updating to PasteFerry 2.5 or later.'**
  String sendNeedsUpdateTip(String name);

  /// No description provided for @sendConnectingTip.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {name}. You can send once it\'s connected.'**
  String sendConnectingTip(String name);

  /// No description provided for @sendNotReceiving.
  ///
  /// In en, this message translates to:
  /// **'Not receiving files'**
  String get sendNotReceiving;

  /// No description provided for @sendDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get sendDelivered;

  /// No description provided for @sendToTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to {name}'**
  String sendToTitle(String name);

  /// No description provided for @sendDropHere.
  ///
  /// In en, this message translates to:
  /// **'Drag files or folders here'**
  String get sendDropHere;

  /// No description provided for @sendDropStarts.
  ///
  /// In en, this message translates to:
  /// **'Sending starts as soon as you drop them'**
  String get sendDropStarts;

  /// No description provided for @sendChooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose Files…'**
  String get sendChooseFiles;

  /// No description provided for @sendChooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose Folder…'**
  String get sendChooseFolder;

  /// No description provided for @sendDropMore.
  ///
  /// In en, this message translates to:
  /// **'Drop more files to send them next'**
  String get sendDropMore;

  /// No description provided for @sendSavedWhere.
  ///
  /// In en, this message translates to:
  /// **'Files are saved where {name} chooses — the Downloads folder by default.'**
  String sendSavedWhere(String name);

  /// No description provided for @sendCloseKeeps.
  ///
  /// In en, this message translates to:
  /// **'Closing this window doesn’t stop sending'**
  String get sendCloseKeeps;

  /// No description provided for @sendRemoveQueued.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sendRemoveQueued;

  /// No description provided for @sendCannotDrop.
  ///
  /// In en, this message translates to:
  /// **'This item can’t be sent by dragging. Save it as a file first, or use Choose Files….'**
  String get sendCannotDrop;

  /// No description provided for @sendErrOffline.
  ///
  /// In en, this message translates to:
  /// **'{name} is offline.'**
  String sendErrOffline(String name);

  /// No description provided for @sendErrDisabled.
  ///
  /// In en, this message translates to:
  /// **'{name} isn’t receiving files.'**
  String sendErrDisabled(String name);

  /// No description provided for @sendErrMissing.
  ///
  /// In en, this message translates to:
  /// **'Some of these files no longer exist.'**
  String get sendErrMissing;

  /// No description provided for @relayConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Send through the service relay?'**
  String get relayConfirmTitle;

  /// No description provided for @relayConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} has no direct connection to this computer right now, so the files go through the service relay at about 0.25 MB/s. {left} of today’s relay allowance is left.'**
  String relayConfirmBody(String name, String left);

  /// No description provided for @relayConfirmOver.
  ///
  /// In en, this message translates to:
  /// **'These files ({size}) are more than the remaining allowance. Sending pauses when it runs out and continues when the two computers connect directly or the allowance resets tomorrow.'**
  String relayConfirmOver(String size);

  /// No description provided for @relayConfirmWithin.
  ///
  /// In en, this message translates to:
  /// **'This uses about {size} of today’s allowance.'**
  String relayConfirmWithin(String size);

  /// No description provided for @relayExhausted.
  ///
  /// In en, this message translates to:
  /// **'Today’s relay allowance is used up. It resets at midnight Beijing time. Two computers that connect directly have no limit.'**
  String get relayExhausted;

  /// No description provided for @relayDontAskToday.
  ///
  /// In en, this message translates to:
  /// **'Don’t ask again today for this device'**
  String get relayDontAskToday;

  /// No description provided for @relaySendAnyway.
  ///
  /// In en, this message translates to:
  /// **'Send Anyway'**
  String get relaySendAnyway;

  /// No description provided for @relayOwnServer.
  ///
  /// In en, this message translates to:
  /// **'Relayed — speed depends on your server'**
  String get relayOwnServer;

  /// No description provided for @transfersReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get transfersReceived;

  /// No description provided for @transfersSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get transfersSent;

  /// No description provided for @transfersClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get transfersClearAll;

  /// No description provided for @transfersClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear this list?'**
  String get transfersClearTitle;

  /// No description provided for @transfersClearBody.
  ///
  /// In en, this message translates to:
  /// **'Only the list is cleared. Files stay where they are.'**
  String get transfersClearBody;

  /// No description provided for @transfersEmptyReceived.
  ///
  /// In en, this message translates to:
  /// **'Files other devices send you appear here'**
  String get transfersEmptyReceived;

  /// No description provided for @transfersEmptySent.
  ///
  /// In en, this message translates to:
  /// **'Files you send appear here'**
  String get transfersEmptySent;

  /// No description provided for @transferFrom.
  ///
  /// In en, this message translates to:
  /// **'From {name}'**
  String transferFrom(String name);

  /// No description provided for @transferTo.
  ///
  /// In en, this message translates to:
  /// **'To {name}'**
  String transferTo(String name);

  /// No description provided for @transferItems.
  ///
  /// In en, this message translates to:
  /// **'{name} and {others} more'**
  String transferItems(String name, int total, int others);

  /// No description provided for @transferFileCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String transferFileCount(int count);

  /// No description provided for @transferQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get transferQueued;

  /// No description provided for @transferScanning.
  ///
  /// In en, this message translates to:
  /// **'Counting… {count} files found'**
  String transferScanning(String count);

  /// No description provided for @transferWaitingPeer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}…'**
  String transferWaitingPeer(String name);

  /// No description provided for @transferSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get transferSending;

  /// No description provided for @transferReceiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get transferReceiving;

  /// No description provided for @transferCurrent.
  ///
  /// In en, this message translates to:
  /// **'Now: {file} ({index} of {total})'**
  String transferCurrent(String file, String index, String total);

  /// No description provided for @transferLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String transferLeft(String time);

  /// No description provided for @etaSeconds.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 second} other{{n} seconds}}'**
  String etaSeconds(int n);

  /// No description provided for @etaMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 minute} other{{n} minutes}}'**
  String etaMinutes(int n);

  /// No description provided for @etaHours.
  ///
  /// In en, this message translates to:
  /// **'{h} h {m} min'**
  String etaHours(int h, int m);

  /// No description provided for @transferPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused: today’s relay allowance is used up'**
  String get transferPaused;

  /// No description provided for @transferInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted — continues when reconnected'**
  String get transferInterrupted;

  /// No description provided for @transferInterruptedIncoming.
  ///
  /// In en, this message translates to:
  /// **'Interrupted — waiting for {name} to continue'**
  String transferInterruptedIncoming(String name);

  /// No description provided for @transferCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get transferCancelled;

  /// No description provided for @transferPeerCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by {name}'**
  String transferPeerCancelled(String name);

  /// No description provided for @transferExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get transferExpired;

  /// No description provided for @transferMissing.
  ///
  /// In en, this message translates to:
  /// **'Moved or deleted'**
  String get transferMissing;

  /// No description provided for @transferNotSent.
  ///
  /// In en, this message translates to:
  /// **'Not sent: {reason}'**
  String transferNotSent(String reason);

  /// No description provided for @transferNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Not received: {reason}'**
  String transferNotReceived(String reason);

  /// No description provided for @reasonNoSpacePeer.
  ///
  /// In en, this message translates to:
  /// **'{name} is out of disk space ({size} short)'**
  String reasonNoSpacePeer(String name, String size);

  /// No description provided for @reasonNoSpace.
  ///
  /// In en, this message translates to:
  /// **'not enough disk space ({size} short)'**
  String reasonNoSpace(String size);

  /// No description provided for @reasonDestUnavailablePeer.
  ///
  /// In en, this message translates to:
  /// **'{name}’s save location is unavailable'**
  String reasonDestUnavailablePeer(String name);

  /// No description provided for @reasonDestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'the save location is unavailable — check it in Settings'**
  String get reasonDestUnavailable;

  /// No description provided for @reasonFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'the save location is on a FAT32 drive, which can’t hold files over 4 GB'**
  String get reasonFileTooLarge;

  /// No description provided for @reasonDisabledPeer.
  ///
  /// In en, this message translates to:
  /// **'{name} isn’t receiving files'**
  String reasonDisabledPeer(String name);

  /// No description provided for @reasonSourceChanged.
  ///
  /// In en, this message translates to:
  /// **'a file changed while it was being sent'**
  String get reasonSourceChanged;

  /// No description provided for @reasonSourceMissing.
  ///
  /// In en, this message translates to:
  /// **'a file no longer exists'**
  String get reasonSourceMissing;

  /// No description provided for @reasonReadError.
  ///
  /// In en, this message translates to:
  /// **'a file couldn’t be read'**
  String get reasonReadError;

  /// No description provided for @reasonWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'the files couldn’t be written'**
  String get reasonWriteFailed;

  /// No description provided for @reasonHashMismatch.
  ///
  /// In en, this message translates to:
  /// **'a file was damaged in transit'**
  String get reasonHashMismatch;

  /// No description provided for @reasonUnsupported.
  ///
  /// In en, this message translates to:
  /// **'{name} needs to update to receive files'**
  String reasonUnsupported(String name);

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'something went wrong'**
  String get reasonOther;

  /// No description provided for @revealInFinder.
  ///
  /// In en, this message translates to:
  /// **'Show in Finder'**
  String get revealInFinder;

  /// No description provided for @revealInFolder.
  ///
  /// In en, this message translates to:
  /// **'Show in Folder'**
  String get revealInFolder;

  /// No description provided for @revealOpenFolder.
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get revealOpenFolder;

  /// No description provided for @transferResend.
  ///
  /// In en, this message translates to:
  /// **'Send Again'**
  String get transferResend;

  /// No description provided for @transferRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from List'**
  String get transferRemove;

  /// No description provided for @transferCopyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy Path'**
  String get transferCopyPath;

  /// No description provided for @transferPathCopied.
  ///
  /// In en, this message translates to:
  /// **'Path copied'**
  String get transferPathCopied;

  /// No description provided for @sendingTo.
  ///
  /// In en, this message translates to:
  /// **'Sending to {name} · {percent}'**
  String sendingTo(String name, String percent);

  /// No description provided for @receivingFrom.
  ///
  /// In en, this message translates to:
  /// **'Receiving from {name} · {percent}'**
  String receivingFrom(String name, String percent);

  /// No description provided for @receiveFiles.
  ///
  /// In en, this message translates to:
  /// **'Receive files from other devices'**
  String get receiveFiles;

  /// No description provided for @saveTo.
  ///
  /// In en, this message translates to:
  /// **'Save to'**
  String get saveTo;

  /// No description provided for @saveToChange.
  ///
  /// In en, this message translates to:
  /// **'Change…'**
  String get saveToChange;

  /// No description provided for @saveToDefault.
  ///
  /// In en, this message translates to:
  /// **'Downloads (default)'**
  String get saveToDefault;

  /// No description provided for @saveToUseDefault.
  ///
  /// In en, this message translates to:
  /// **'Use Downloads'**
  String get saveToUseDefault;

  /// No description provided for @receiveNotify.
  ///
  /// In en, this message translates to:
  /// **'Notify when files arrive'**
  String get receiveNotify;

  /// No description provided for @receiveFootnote.
  ///
  /// In en, this message translates to:
  /// **'Only paired devices can send files to {device}. While files are transferring, {device} won’t go to sleep on its own.'**
  String receiveFootnote(String device);

  /// No description provided for @saveDirNotFound.
  ///
  /// In en, this message translates to:
  /// **'This folder doesn’t exist.'**
  String get saveDirNotFound;

  /// No description provided for @saveDirNotWritable.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry can’t save files in this folder.'**
  String get saveDirNotWritable;

  /// No description provided for @saveDirPermission.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry isn’t allowed to use this folder. Allow it in System Settings → Privacy & Security → Files and Folders.'**
  String get saveDirPermission;

  /// No description provided for @transferRenamed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file name had characters Windows doesn’t allow; they were replaced with similar full-width characters} other{{count} file names had characters Windows doesn’t allow; they were replaced with similar full-width characters}}'**
  String transferRenamed(int count);

  /// No description provided for @sendRingLan.
  ///
  /// In en, this message translates to:
  /// **'Same network'**
  String get sendRingLan;

  /// No description provided for @sendRingOther.
  ///
  /// In en, this message translates to:
  /// **'Other networks'**
  String get sendRingOther;

  /// No description provided for @sendOfflineList.
  ///
  /// In en, this message translates to:
  /// **'Offline: {names}'**
  String sendOfflineList(String names);

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @sendLayout.
  ///
  /// In en, this message translates to:
  /// **'Transfer list'**
  String get sendLayout;

  /// No description provided for @sendLayoutSide.
  ///
  /// In en, this message translates to:
  /// **'Beside the radar'**
  String get sendLayoutSide;

  /// No description provided for @sendLayoutBelow.
  ///
  /// In en, this message translates to:
  /// **'Below the radar'**
  String get sendLayoutBelow;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @launchAtLogin.
  ///
  /// In en, this message translates to:
  /// **'Launch at login'**
  String get launchAtLogin;

  /// No description provided for @launchAtLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Start in the background when you log in. Changing this does not stop the current session.'**
  String get launchAtLoginDesc;

  /// No description provided for @realtimeSync.
  ///
  /// In en, this message translates to:
  /// **'Real-time clipboard sync'**
  String get realtimeSync;

  /// No description provided for @realtimeSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically share new copies with paired devices. Local history and Send Files remain available when off.'**
  String get realtimeSyncDesc;

  /// No description provided for @syncBacklog.
  ///
  /// In en, this message translates to:
  /// **'Catch up after reconnecting'**
  String get syncBacklog;

  /// No description provided for @syncBacklogDesc.
  ///
  /// In en, this message translates to:
  /// **'Off by default: missed copies are skipped. When enabled, up to 20 copies from the last 24 hours enter history without replacing the clipboard.'**
  String get syncBacklogDesc;

  /// No description provided for @peerRealtimeSync.
  ///
  /// In en, this message translates to:
  /// **'Sync with this computer'**
  String get peerRealtimeSync;

  /// No description provided for @syncPaused.
  ///
  /// In en, this message translates to:
  /// **'Clipboard sync paused'**
  String get syncPaused;

  /// No description provided for @quitApp.
  ///
  /// In en, this message translates to:
  /// **'Quit PasteFerry'**
  String get quitApp;

  /// No description provided for @quitAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Stop all PasteFerry processes. Your launch-at-login preference is preserved.'**
  String get quitAppDesc;

  /// No description provided for @quitTransfersWarning.
  ///
  /// In en, this message translates to:
  /// **'Files are still being transferred. Quit and interrupt these transfers?'**
  String get quitTransfersWarning;

  /// No description provided for @backgroundRunningTitle.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry will keep running'**
  String get backgroundRunningTitle;

  /// No description provided for @backgroundRunningBody.
  ///
  /// In en, this message translates to:
  /// **'Closing the window keeps sync and quick paste running. To stop everything, choose Quit PasteFerry in Settings or the app menu.'**
  String get backgroundRunningBody;

  /// No description provided for @displayAs.
  ///
  /// In en, this message translates to:
  /// **'Shown as'**
  String get displayAs;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get editName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'The name your contacts see'**
  String get nameHint;

  /// No description provided for @nameDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use your account name.'**
  String get nameDefaultHint;

  /// No description provided for @avatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get avatarTitle;

  /// No description provided for @avatarChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose Image…'**
  String get avatarChoose;

  /// No description provided for @avatarPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste Image'**
  String get avatarPaste;

  /// No description provided for @avatarReset.
  ///
  /// In en, this message translates to:
  /// **'Use Default Picture'**
  String get avatarReset;

  /// No description provided for @avatarZoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get avatarZoom;

  /// No description provided for @avatarDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to move the picture.'**
  String get avatarDragHint;

  /// No description provided for @avatarNoImage.
  ///
  /// In en, this message translates to:
  /// **'There\'s no image on the clipboard.'**
  String get avatarNoImage;

  /// No description provided for @avatarBad.
  ///
  /// In en, this message translates to:
  /// **'This image can\'t be used. Choose a PNG, JPEG or GIF.'**
  String get avatarBad;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get friendsTitle;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addFriend;

  /// No description provided for @friendsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet'**
  String get friendsEmpty;

  /// No description provided for @friendsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add someone who also uses PasteFerry to send each other files without pairing. Contacts can only send files; they never see your clipboard.'**
  String get friendsEmptyBody;

  /// No description provided for @friendSendAction.
  ///
  /// In en, this message translates to:
  /// **'Send…'**
  String get friendSendAction;

  /// No description provided for @friendHistory.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get friendHistory;

  /// No description provided for @friendHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfers with {name}'**
  String friendHistoryTitle(String name);

  /// No description provided for @friendHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transfers yet.'**
  String get friendHistoryEmpty;

  /// No description provided for @friendAutoAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept Files Automatically'**
  String get friendAutoAccept;

  /// No description provided for @friendRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove Contact'**
  String get friendRemove;

  /// No description provided for @friendRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String friendRemoveTitle(String name);

  /// No description provided for @friendRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be removed from each other\'s contacts and can no longer send each other files. Past transfers stay on this computer.'**
  String get friendRemoveBody;

  /// No description provided for @friendLastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last transfer {time}'**
  String friendLastActivity(String time);

  /// No description provided for @friendNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No transfers yet'**
  String get friendNoActivity;

  /// No description provided for @friendCodeShare.
  ///
  /// In en, this message translates to:
  /// **'Send this code to your contact. When they enter it in PasteFerry, you\'ll be added to each other\'s contacts.'**
  String get friendCodeShare;

  /// No description provided for @friendCodeExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires in {time}'**
  String friendCodeExpires(String time);

  /// No description provided for @friendCodeOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get friendCodeOr;

  /// No description provided for @friendCodeEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter their contact code'**
  String get friendCodeEnter;

  /// No description provided for @friendCodeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get friendCodeAdd;

  /// No description provided for @friendCodeWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for them to enter it…'**
  String get friendCodeWaiting;

  /// No description provided for @friendConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Add {name} to your contacts?'**
  String friendConfirmBody(String name);

  /// No description provided for @friendSafetyCode.
  ///
  /// In en, this message translates to:
  /// **'Check safety code (optional)'**
  String get friendSafetyCode;

  /// No description provided for @friendSafetyHint.
  ///
  /// In en, this message translates to:
  /// **'When you\'re together, compare these two lines. If they match on both computers, no one has interfered.'**
  String get friendSafetyHint;

  /// No description provided for @friendWaitingPeer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for them to add you…'**
  String get friendWaitingPeer;

  /// No description provided for @friendAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} was added to your contacts'**
  String friendAdded(String name);

  /// No description provided for @friendPeerCancelled.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled'**
  String friendPeerCancelled(String name);

  /// No description provided for @friendErrFriendCode.
  ///
  /// In en, this message translates to:
  /// **'This is a contact code. Enter it in Add Contact on the Send Files page.'**
  String get friendErrFriendCode;

  /// No description provided for @friendErrDeviceCode.
  ///
  /// In en, this message translates to:
  /// **'This is a pairing code. Enter it in Devices → Add Device.'**
  String get friendErrDeviceCode;

  /// No description provided for @friendErrOutdated.
  ///
  /// In en, this message translates to:
  /// **'They need PasteFerry 2.6.0 or later.'**
  String get friendErrOutdated;

  /// No description provided for @friendErrAlreadyPaired.
  ///
  /// In en, this message translates to:
  /// **'That computer is already one of your devices.'**
  String get friendErrAlreadyPaired;

  /// No description provided for @friendErrNoChannel.
  ///
  /// In en, this message translates to:
  /// **'You\'re not on the same network. Turn on Service on both computers to add each other.'**
  String get friendErrNoChannel;

  /// No description provided for @openService.
  ///
  /// In en, this message translates to:
  /// **'Turn On Service…'**
  String get openService;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @noteHintEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose files first'**
  String get noteHintEmpty;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: please sign page 3'**
  String get noteHint;

  /// No description provided for @noteLine.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteLine(String note);

  /// No description provided for @sendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendAction;

  /// No description provided for @sendItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} items · {size}'**
  String sendItemsSummary(String count, String size);

  /// No description provided for @sendDropOrPaste.
  ///
  /// In en, this message translates to:
  /// **'Drop files or images here, or paste ({key})'**
  String sendDropOrPaste(String key);

  /// No description provided for @sendDropMorePaste.
  ///
  /// In en, this message translates to:
  /// **'Drop or paste more'**
  String get sendDropMorePaste;

  /// No description provided for @sendPasteNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing to paste. Copy files or an image first.'**
  String get sendPasteNothing;

  /// No description provided for @sendRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sendRemoveItem;

  /// No description provided for @sendFriendSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} accepts each batch before it\'s sent.'**
  String sendFriendSaved(String name);

  /// No description provided for @transferAskingOut.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to accept…'**
  String transferAskingOut(String name);

  /// No description provided for @transferAskingIn.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you to accept'**
  String get transferAskingIn;

  /// No description provided for @reasonDeclined.
  ///
  /// In en, this message translates to:
  /// **'{name} declined'**
  String reasonDeclined(String name);

  /// No description provided for @reasonTimeout.
  ///
  /// In en, this message translates to:
  /// **'{name} didn\'t respond'**
  String reasonTimeout(String name);

  /// No description provided for @reasonNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'{name} isn\'t accepting files'**
  String reasonNotAllowed(String name);

  /// No description provided for @reasonRateLimited.
  ///
  /// In en, this message translates to:
  /// **'{name} isn\'t accepting your files right now'**
  String reasonRateLimited(String name);

  /// No description provided for @reasonYouDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get reasonYouDeclined;

  /// No description provided for @reasonYouIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get reasonYouIgnored;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send Again'**
  String get sendAgain;

  /// No description provided for @incomingTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to send you files'**
  String incomingTitle(String name);

  /// No description provided for @incomingAlways.
  ///
  /// In en, this message translates to:
  /// **'Always accept files from this contact'**
  String get incomingAlways;

  /// No description provided for @incomingDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get incomingDecline;

  /// No description provided for @incomingAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get incomingAccept;

  /// No description provided for @incomingCountdown.
  ///
  /// In en, this message translates to:
  /// **'Declines automatically in {seconds} s'**
  String incomingCountdown(String seconds);

  /// No description provided for @incomingStranger.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get incomingStranger;

  /// No description provided for @friendsStrip.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get friendsStrip;

  /// No description provided for @strangersStrip.
  ///
  /// In en, this message translates to:
  /// **'Nearby with Everyone on'**
  String get strangersStrip;

  /// No description provided for @strangerNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get strangerNearby;

  /// No description provided for @friendNeedService.
  ///
  /// In en, this message translates to:
  /// **'Turn on Service'**
  String get friendNeedService;

  /// No description provided for @friendCantReach.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect'**
  String get friendCantReach;

  /// No description provided for @reachSelfNoService.
  ///
  /// In en, this message translates to:
  /// **'You and {name} aren\'t on the same network. Turn on Service to send files; if no direct connection is possible, they go through the Service relay.'**
  String reachSelfNoService(String name);

  /// No description provided for @reachPeerNoService.
  ///
  /// In en, this message translates to:
  /// **'{name} hasn\'t turned on Service, so you can only send files on the same network. Ask them to turn on Service in PasteFerry.'**
  String reachPeerNoService(String name);

  /// No description provided for @reachDifferentServer.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t using the same server. Turn on Service on both computers, or use the same server, to send files.'**
  String get reachDifferentServer;

  /// No description provided for @receiveFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Let these people send me files:'**
  String get receiveFromLabel;

  /// No description provided for @receiveFromOff.
  ///
  /// In en, this message translates to:
  /// **'No One'**
  String get receiveFromOff;

  /// No description provided for @receiveFromFriends.
  ///
  /// In en, this message translates to:
  /// **'Contacts Only'**
  String get receiveFromFriends;

  /// No description provided for @receiveFromEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get receiveFromEveryone;

  /// No description provided for @everyoneLeft.
  ///
  /// In en, this message translates to:
  /// **'Everyone · {minutes} min left'**
  String everyoneLeft(String minutes);

  /// No description provided for @receiveFromOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Only your own paired computers can send you files.'**
  String get receiveFromOffDesc;

  /// No description provided for @receiveFromFriendsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your contacts can send you files. You accept each batch.'**
  String get receiveFromFriendsDesc;

  /// No description provided for @receiveFromEveryoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Anyone on the same network can send you files for 10 minutes. You accept each batch.'**
  String get receiveFromEveryoneDesc;

  /// No description provided for @everyoneEnded.
  ///
  /// In en, this message translates to:
  /// **'Everyone is off; back to Contacts Only.'**
  String get everyoneEnded;

  /// No description provided for @friendsCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get friendsCountTooltip;

  /// No description provided for @waitingAccept.
  ///
  /// In en, this message translates to:
  /// **'Waiting…'**
  String get waitingAccept;

  /// No description provided for @settingsConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get settingsConnection;

  /// No description provided for @settingsGeneralSummary.
  ///
  /// In en, this message translates to:
  /// **'Launch at login, device name, language'**
  String get settingsGeneralSummary;

  /// No description provided for @settingsConnectionSummary.
  ///
  /// In en, this message translates to:
  /// **'Service, your own server, local network'**
  String get settingsConnectionSummary;

  /// No description provided for @settingsSyncSummary.
  ///
  /// In en, this message translates to:
  /// **'Real-time sync, size limit, what to sync'**
  String get settingsSyncSummary;

  /// No description provided for @settingsQuickPasteSummary.
  ///
  /// In en, this message translates to:
  /// **'Shortcut and what happens after you pick'**
  String get settingsQuickPasteSummary;

  /// No description provided for @settingsSendSummary.
  ///
  /// In en, this message translates to:
  /// **'Receiving files, save location'**
  String get settingsSendSummary;

  /// No description provided for @settingsStorageSummary.
  ///
  /// In en, this message translates to:
  /// **'How long history is kept, space used'**
  String get settingsStorageSummary;

  /// No description provided for @settingsAboutSummary.
  ///
  /// In en, this message translates to:
  /// **'Version, updates, feedback'**
  String get settingsAboutSummary;

  /// No description provided for @friendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send files to other people\'s computers, no pairing needed'**
  String get friendsSubtitle;

  /// No description provided for @friendsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search contacts'**
  String get friendsSearch;

  /// No description provided for @friendsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching contacts'**
  String get friendsNoMatch;

  /// No description provided for @friendsPick.
  ///
  /// In en, this message translates to:
  /// **'Pick a contact to see your transfers or send files'**
  String get friendsPick;

  /// No description provided for @friendDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drop files here to send them to {name}'**
  String friendDropHint(String name);

  /// No description provided for @webShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone web transfer'**
  String get webShareTitle;

  /// No description provided for @webShareFootnote.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code with a phone to send text, photos and files to and from this computer in the browser, no app needed. The phone and computer need to be on the same network.'**
  String get webShareFootnote;

  /// No description provided for @webShareSwitch.
  ///
  /// In en, this message translates to:
  /// **'Let phones connect in the browser'**
  String get webShareSwitch;

  /// No description provided for @webShareOn.
  ///
  /// In en, this message translates to:
  /// **'On, {count} phone(s)'**
  String webShareOn(int count);

  /// No description provided for @webShareOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get webShareOff;

  /// No description provided for @webShareShowQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR code'**
  String get webShareShowQr;

  /// No description provided for @webShareDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan with your phone'**
  String get webShareDialogTitle;

  /// No description provided for @webShareDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Scan with the phone’s camera or browser and open it in the browser. Each QR code registers one phone and is replaced after use.'**
  String get webShareDialogBody;

  /// No description provided for @webShareAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get webShareAddress;

  /// No description provided for @webShareSecurity.
  ///
  /// In en, this message translates to:
  /// **'Content is encrypted in the page, so others on the network can’t read it. But the page itself is http and can’t stop someone who deliberately tampers with it. Use it at home or on a trusted office network, not on public Wi-Fi.'**
  String get webShareSecurity;

  /// No description provided for @webSharePhones.
  ///
  /// In en, this message translates to:
  /// **'Registered phones'**
  String get webSharePhones;

  /// No description provided for @webShareNoPhones.
  ///
  /// In en, this message translates to:
  /// **'No phones yet'**
  String get webShareNoPhones;

  /// No description provided for @webShareLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used {time}'**
  String webShareLastUsed(String time);

  /// No description provided for @webShareRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get webShareRemove;

  /// No description provided for @webShareRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed “{name}”'**
  String webShareRemoved(String name);

  /// No description provided for @webShareNewPhone.
  ///
  /// In en, this message translates to:
  /// **'“{name}” registered'**
  String webShareNewPhone(String name);

  /// No description provided for @webShareNotListening.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t start listening: {error}'**
  String webShareNotListening(String error);

  /// No description provided for @webSharePortFallback.
  ///
  /// In en, this message translates to:
  /// **'The usual port is taken, so a temporary one is in use. Saved addresses won’t open until phones scan again.'**
  String get webSharePortFallback;

  /// No description provided for @webShareNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No local network address. Connect to Wi-Fi or a wired network first.'**
  String get webShareNoAddress;

  /// No description provided for @webShareCantOpen.
  ///
  /// In en, this message translates to:
  /// **'If the page won’t open on the phone, make sure both are on the same network (guest networks usually don’t work). On Windows, PasteFerry also needs to be allowed through the firewall.'**
  String get webShareCantOpen;

  /// No description provided for @mTabRecords.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get mTabRecords;

  /// No description provided for @mTabSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get mTabSend;

  /// No description provided for @mThisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get mThisPhone;

  /// No description provided for @mThisPhoneName.
  ///
  /// In en, this message translates to:
  /// **'This phone: {name}'**
  String mThisPhoneName(String name);

  /// No description provided for @mSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to your computer'**
  String get mSendTitle;

  /// No description provided for @mSendHint.
  ///
  /// In en, this message translates to:
  /// **'Type or paste text'**
  String get mSendHint;

  /// No description provided for @mPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get mPaste;

  /// No description provided for @mPhotosFiles.
  ///
  /// In en, this message translates to:
  /// **'Photos or files'**
  String get mPhotosFiles;

  /// No description provided for @mSendConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Send {n} file(s)?'**
  String mSendConfirmTitle(Object n);

  /// No description provided for @mFilesSent.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 file sent to your computer} other{{n} files sent to your computer}}'**
  String mFilesSent(num n);

  /// No description provided for @mClipboardNoText.
  ///
  /// In en, this message translates to:
  /// **'The clipboard has no text'**
  String get mClipboardNoText;

  /// No description provided for @mSendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get mSendAction;

  /// No description provided for @mSendTo.
  ///
  /// In en, this message translates to:
  /// **'Goes to {names}'**
  String mSendTo(String names);

  /// No description provided for @mNoOnlineDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices online nearby'**
  String get mNoOnlineDevices;

  /// No description provided for @mNoPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Pair with a computer first'**
  String get mNoPairedDevices;

  /// No description provided for @mSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get mSent;

  /// No description provided for @mSendFootnote.
  ///
  /// In en, this message translates to:
  /// **'Text and files go into the records on the computer and, by its setting, into its clipboard. What you copy on the phone is not sent by itself.'**
  String get mSendFootnote;

  /// No description provided for @mSentRecords.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get mSentRecords;

  /// No description provided for @mViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get mViewAll;

  /// No description provided for @mClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get mClearCache;

  /// No description provided for @mCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get mCheckUpdate;

  /// No description provided for @mUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates'**
  String get mUpdateFailed;

  /// No description provided for @mUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You are up to date'**
  String get mUpToDate;

  /// No description provided for @mNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {v} is available'**
  String mNewVersion(Object v);

  /// No description provided for @mDownloadInstall.
  ///
  /// In en, this message translates to:
  /// **'Download the new version'**
  String get mDownloadInstall;

  /// No description provided for @mSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t send: {detail}'**
  String mSendFailed(String detail);

  /// No description provided for @mCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get mCopy;

  /// No description provided for @mCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to this phone’s clipboard'**
  String get mCopied;

  /// No description provided for @mShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get mShare;

  /// No description provided for @mSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Photos or Download/PasteFerry'**
  String get mSaved;

  /// No description provided for @mActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Didn’t work: {detail}'**
  String mActionFailed(String detail);

  /// No description provided for @mDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get mDownloading;

  /// No description provided for @mNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded yet'**
  String get mNotDownloaded;

  /// No description provided for @mDownloadHint.
  ///
  /// In en, this message translates to:
  /// **'It downloads first when you tap Copy, Save or Share.'**
  String get mDownloadHint;

  /// No description provided for @mFullTextLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get mFullTextLoading;

  /// No description provided for @mTextTruncated.
  ///
  /// In en, this message translates to:
  /// **'Showing the first {shown} of {total} characters. Copy gets all of it.'**
  String mTextTruncated(int shown, int total);

  /// No description provided for @mNotOnLanTitle.
  ///
  /// In en, this message translates to:
  /// **'Not on Wi-Fi'**
  String get mNotOnLanTitle;

  /// No description provided for @mNotOnLanBody.
  ///
  /// In en, this message translates to:
  /// **'For now PasteFerry syncs only on the local network. Join the same Wi-Fi as your computer.'**
  String get mNotOnLanBody;

  /// No description provided for @mStartFailed.
  ///
  /// In en, this message translates to:
  /// **'PasteFerry couldn’t start: {detail}'**
  String mStartFailed(String detail);

  /// No description provided for @mNoDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'On your computer, open PasteFerry → Devices → Add device, then enter the code it shows here. On the same Wi-Fi you can also open “Search nearby” on both.'**
  String get mNoDevicesBody;

  /// No description provided for @mSectionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get mSectionSync;

  /// No description provided for @mSectionBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get mSectionBackground;

  /// No description provided for @mAutoApplyDesc.
  ///
  /// In en, this message translates to:
  /// **'Text copied on your computer goes straight onto this phone’s clipboard. Images and files wait until you tap Copy.'**
  String get mAutoApplyDesc;

  /// No description provided for @mKeepAlive.
  ///
  /// In en, this message translates to:
  /// **'Stay connected in the background'**
  String get mKeepAlive;

  /// No description provided for @mKeepAliveDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive text even when PasteFerry isn’t open. Shows an ongoing notification.'**
  String get mKeepAliveDesc;

  /// No description provided for @mNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get mNotifications;

  /// No description provided for @mNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Needed for the ongoing notification. PasteFerry works without it.'**
  String get mNotificationsDesc;

  /// No description provided for @mBattery.
  ///
  /// In en, this message translates to:
  /// **'Run in the background'**
  String get mBattery;

  /// No description provided for @mBatteryDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn off battery optimization so the system doesn’t stop PasteFerry when the screen is locked. Some phones also need PasteFerry added to their auto-start or background list in Settings.'**
  String get mBatteryDesc;

  /// No description provided for @mAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get mAllowed;

  /// No description provided for @mAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get mAllow;

  /// No description provided for @mVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String mVersion(String version);

  /// No description provided for @mDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get mDeleteConfirm;

  /// No description provided for @mDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script+country codes are specified.
  switch (locale.toString()) {
    case 'zh_Hant_HK':
      return AppLocalizationsZhHantHk();
    case 'zh_Hant_TW':
      return AppLocalizationsZhHantTw();
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
