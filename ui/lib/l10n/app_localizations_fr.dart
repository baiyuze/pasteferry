// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Historique';

  @override
  String get navDevices => 'Appareils';

  @override
  String get navSettings => 'Réglages';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get linkConnecting => 'Connexion…';

  @override
  String get linkServiceNotRunning => 'Service arrêté';

  @override
  String get linkLanMode => 'Recherche d’appareils sur ce réseau';

  @override
  String get linkServerUnreachable =>
      'Serveur injoignable ; synchronisation sur ce réseau';

  @override
  String get linkNothingOn =>
      'La découverte sur le réseau local est désactivée et aucun serveur n’est défini';

  @override
  String get linkLanBlocked => 'macOS bloque le réseau local';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appareils en ligne',
      one: '$count appareil en ligne',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Connecté au serveur';

  @override
  String linkConnectionLost(String detail) {
    return 'Connexion perdue : $detail';
  }

  @override
  String get linkServiceDisconnected => 'Service déconnecté';

  @override
  String get linkServiceDisabled =>
      'Synchronisation en arrière-plan désactivée';

  @override
  String get errServiceNotConnected => 'Non connecté au service d’arrière-plan';

  @override
  String get errUnimplemented => 'Cette fonction n’est pas encore disponible';

  @override
  String get errUnavailable =>
      'Impossible de joindre le service d’arrière-plan';

  @override
  String errServiceStart(String detail) {
    return 'Impossible de démarrer le service d’arrière-plan : $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Impossible de redémarrer le service d’arrière-plan : $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Impossible d’ouvrir PasteFerry à l’ouverture de session : $detail';
  }

  @override
  String get thisMacTitle => 'Ce Mac';

  @override
  String get thisPcTitle => 'Cet ordinateur';

  @override
  String get thisMacInText => 'ce Mac';

  @override
  String get thisPcInText => 'cet ordinateur';

  @override
  String get bothMacs => 'les deux Mac';

  @override
  String get bothDevices => 'les deux appareils';

  @override
  String get thisDeviceShort => 'Cet appareil';

  @override
  String fromDevice(String name) {
    return 'De $name';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Enregistrer';

  @override
  String get retry => 'Réessayer';

  @override
  String get continueAction => 'Continuer';

  @override
  String get justNow => 'À l’instant';

  @override
  String secondsAgo(int n) {
    return 'Il y a $n s';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Il y a $n minutes',
      one: 'Il y a $n minute',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Il y a $n heures',
      one: 'Il y a $n heure',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Il y a $n jours',
      one: 'Hier',
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
      other: '$n heures',
      one: '$n heure',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '$n jour',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Copiez sur n’importe lequel de vos appareils, le contenu apparaît ici';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0, conservés $ttl';
  }

  @override
  String get filterAll => 'Tout';

  @override
  String get filterText => 'Texte';

  @override
  String get filterImage => 'Images';

  @override
  String get filterFile => 'Fichiers';

  @override
  String get filterLink => 'Liens';

  @override
  String get historyClearTooltip => 'Effacer l’historique';

  @override
  String get historyEmptyTitle => 'Rien pour l’instant';

  @override
  String get historyEmptyFilteredTitle => 'Aucun élément de ce type';

  @override
  String get historyEmptyBody =>
      'Copiez du texte, une image ou un fichier sur n’importe quel appareil jumelé, et il apparaît ici.';

  @override
  String get clearConfirmTitle => 'Effacer tout l’historique ?';

  @override
  String clearConfirmBody(String device) {
    return 'Tout ce qui a été synchronisé depuis vos appareils, ainsi que les fichiers en cache, sera supprimé de $device. Les fichiers d’origine ne sont pas touchés.';
  }

  @override
  String get clear => 'Effacer';

  @override
  String get historyCleared => 'Historique effacé';

  @override
  String get permDeniedTitle => 'PasteFerry ne peut pas lire le presse-papiers';

  @override
  String get permAskTitle => 'Autorisez PasteFerry à lire le presse-papiers';

  @override
  String get permDeniedBody =>
      'Ce que vous copiez sur ce Mac ne sera pas synchronisé. Dans Réglages Système, réglez PasteFerry Daemon sur Autoriser.';

  @override
  String get permAskBody =>
      'Sinon, macOS vous le demandera à chaque fois. Dans Réglages Système, réglez PasteFerry Daemon sur Autoriser.';

  @override
  String get openSystemSettings => 'Ouvrir Réglages Système';

  @override
  String get fetch => 'Recevoir';

  @override
  String get fetchStarted =>
      'Réception… Suivez la progression dans l’historique';

  @override
  String get transferFailed => 'Échec du transfert';

  @override
  String get expired => 'Expiré';

  @override
  String get putOnClipboard => 'Copier';

  @override
  String get putOnClipboardDone => 'Dans le presse-papiers';

  @override
  String get deleteRecord => 'Supprimer cet élément';

  @override
  String get deleted => 'Supprimé';

  @override
  String get emptyRecord => '(vide)';

  @override
  String get imageRecord => 'Image';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others autres',
      one: '$others autre',
    );
    return '$name et $_temp0';
  }

  @override
  String get searchHint => 'Rechercher dans le texte et les noms de fichiers';

  @override
  String get searchClear => 'Effacer la recherche';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '$count résultat',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get searchEmptyBody =>
      'La recherche porte sur le texte copié et les noms des fichiers copiés.';

  @override
  String get favoriteAction => 'Ajouter aux favoris';

  @override
  String get unfavoriteAction => 'Retirer des favoris';

  @override
  String get favoritedToast => 'Ajouté aux favoris';

  @override
  String get unfavoritedToast => 'Remis dans l’historique';

  @override
  String get undo => 'Annuler';

  @override
  String get favoriteSaving => 'Enregistrement…';

  @override
  String favoritedAt(String date) {
    return 'Enregistré le $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0 · jamais nettoyés · jusqu’à $size';
  }

  @override
  String get favoritesEmptyTitle => 'Aucun favori';

  @override
  String get favoritesEmptyBody =>
      'Ajoutez une étoile à un élément de l’historique pour en garder une copie ici. Les favoris ne sont jamais nettoyés automatiquement.';

  @override
  String get favoritesSearchHint => 'Rechercher dans les favoris';

  @override
  String favoriteLargeTitle(String size) {
    return 'Enregistrer une copie de $size ?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Un favori garde sa propre copie : modifier ou supprimer les fichiers d’origine ne le change pas. Cela occupe $size sur $device.';
  }

  @override
  String get saveCopy => 'Enregistrer une copie';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vos $count favoris sont conservés.',
      one: 'Votre favori est conservé.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favoris';

  @override
  String get favoritesUsageDesc =>
      'Les favoris ne sont jamais nettoyés, quels que soient les réglages ci-dessus';

  @override
  String upToSize(String size) {
    return 'Jusqu’à $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caractères',
      one: '$count caractère',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… $count caractères au total';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count autres',
      one: '$count autre',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst =>
      'Sélectionnez-le pour le télécharger d’abord';

  @override
  String detailTotalSize(String size) {
    return '$size au total';
  }

  @override
  String get quickPaste => 'Collage rapide';

  @override
  String get quickPasteWindow => 'Fenêtre de collage rapide';

  @override
  String get quickPasteWindowDesc =>
      'Appuyez sur le raccourci dans n’importe quelle app pour afficher l’historique ; choisissez un élément et il est collé';

  @override
  String get quickPasteShortcut => 'Raccourci';

  @override
  String get quickPasteRecord => 'Cliquer pour modifier';

  @override
  String get quickPasteRecording => 'Appuyez sur le nouveau raccourci…';

  @override
  String get quickPasteUseDefault => 'Par défaut';

  @override
  String get quickPasteNeedsModifier =>
      'Utilisez ⌃, ⌥, ⇧ ou ⌘, ou une touche de fonction';

  @override
  String get quickPasteNeedsModifierPc =>
      'Utilisez Ctrl, Alt, Maj ou la touche Windows, ou une touche de fonction';

  @override
  String get quickPasteAfterPick => 'Après le choix d’un élément';

  @override
  String get quickPastePasteIt => 'Le coller';

  @override
  String get quickPasteCopyIt => 'Le copier seulement';

  @override
  String get quickPasteIndexKey => 'Choisir parmi les 9 premiers';

  @override
  String get quickPasteIndexKeyDesc =>
      'Dans la fenêtre de collage rapide, maintenez cette touche et appuyez sur 1–9';

  @override
  String get quickPasteAccessibility => 'Accessibilité';

  @override
  String get quickPasteAccessibilityDesc =>
      'Nécessaire pour coller à votre place. Sans cette autorisation, les éléments sont copiés et vous appuyez sur ⌘V.';

  @override
  String get quickPasteAllowed => 'Autorisé';

  @override
  String get quickPasteAllow => 'Autoriser…';

  @override
  String get quickPasteNotRunning =>
      'La fenêtre de collage rapide n’est pas lancée';

  @override
  String quickPasteInUse(String key) {
    return '$key est utilisé par une autre app. Choisissez un autre raccourci.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Impossible de définir $key : $detail';
  }

  @override
  String get quickPastePortalKey =>
      'À définir dans les réglages de raccourcis du système';

  @override
  String get quickPasteWaylandDesc =>
      'Sous Wayland, ajoutez le raccourci dans les réglages clavier de votre bureau. Les éléments choisis sont copiés ; appuyez sur Ctrl+V pour coller.';

  @override
  String get quickPasteAddShortcut => 'Ajouter un raccourci système';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Ajouté. Appuyez sur $key pour l’essayer.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Dans les réglages clavier de votre bureau, ajoutez un raccourci personnalisé qui exécute : $command';
  }

  @override
  String get pickerSearch => 'Rechercher';

  @override
  String get pickerPaste => 'Coller';

  @override
  String get pickerPlainText => 'Texte brut';

  @override
  String get pickerCopyOnly => 'Copier seulement';

  @override
  String get pickerUnfavoriteHint => 'Retirer (remis dans l’historique)';

  @override
  String pickerPasteManually(String key) {
    return 'Les éléments choisis sont copiés ; appuyez sur $key pour coller';
  }

  @override
  String get pickerGrantHint =>
      'Autorisez l’accessibilité pour coller directement';

  @override
  String pickerElevated(String key) {
    return 'Cette fenêtre s’exécute en administrateur ; appuyez sur $key pour coller après votre choix';
  }

  @override
  String get pickerDownloading => 'Téléchargement ; collage à la fin';

  @override
  String get imagePreviewTitle => 'Aperçu de l’image';

  @override
  String get closePreview => 'Fermer l’aperçu';

  @override
  String get previousImage => 'Image précédente';

  @override
  String get nextImage => 'Image suivante';

  @override
  String get previewHint =>
      'Faites défiler ou pincez pour zoomer, faites glisser pour vous déplacer';

  @override
  String get fitWindow => 'Ajuster à la fenêtre';

  @override
  String get previewDeleted => 'Cette image a été supprimée de l’historique';

  @override
  String get previewExpired =>
      'Cette image a expiré et ne peut pas être prévisualisée';

  @override
  String get previewDownloading => 'Téléchargement de l’image…';

  @override
  String get previewDownloadFailed => 'Le téléchargement a échoué. Réessayez.';

  @override
  String get previewNotDownloaded =>
      'Cette image n’est pas encore sur cet ordinateur';

  @override
  String get downloadAndPreview => 'Télécharger et afficher';

  @override
  String get previewUnavailable =>
      'Impossible d’afficher cette image pour le moment';

  @override
  String get imageSemantic => 'Image de l’historique';

  @override
  String get previewUnreadable =>
      'Impossible de lire l’image. Le fichier a peut-être été nettoyé ou est endommagé.';

  @override
  String get devicesSubtitleEmpty =>
      'Une fois jumelés, vos appareils partagent le même presse-papiers';

  @override
  String devicesSubtitle(int paired, int online) {
    String _temp0 = intl.Intl.pluralLogic(
      paired,
      locale: localeName,
      other: '$paired jumelés',
      one: '$paired jumelé',
    );
    return '$_temp0, $online en ligne';
  }

  @override
  String get addDevice => 'Ajouter un appareil';

  @override
  String thisDeviceFootnote(String both) {
    return 'Lors du jumelage, $both affichent les deux mêmes lignes d’empreintes de sécurité, une par appareil. Ne confirmez que si elles sont identiques au caractère près.';
  }

  @override
  String get noDevicesTitle => 'Aucun appareil jumelé';

  @override
  String get noDevicesBody =>
      'Ouvrez PasteFerry sur votre autre ordinateur et reliez les deux avec un code de jumelage à 6 caractères. Sur le même réseau, vous pouvez aussi ouvrir Rechercher à proximité sur les deux et cliquer sur l’autre.';

  @override
  String get pairedDevices => 'Appareils jumelés';

  @override
  String get pairedFootnote =>
      'Direct : les données passent directement entre les deux appareils. Relais : quand le réseau bloque la connexion directe, les données passent par votre serveur et restent chiffrées de bout en bout.';

  @override
  String get offline => 'Hors ligne';

  @override
  String get direct => 'Direct';

  @override
  String get relay => 'Relais';

  @override
  String get online => 'En ligne';

  @override
  String get moreActions => 'Plus';

  @override
  String get copyFingerprint => 'Copier l’empreinte';

  @override
  String get unpairEllipsis => 'Dissocier…';

  @override
  String get fingerprintCopied => 'Empreinte copiée';

  @override
  String unpairTitle(String name) {
    return 'Dissocier « $name » ?';
  }

  @override
  String get unpairBody =>
      'Les deux appareils ne seront plus synchronisés. Pour les synchroniser à nouveau, il faudra les jumeler et vérifier les empreintes une nouvelle fois.';

  @override
  String get unpair => 'Dissocier';

  @override
  String get unpaired => 'Dissocié';

  @override
  String get enterAddressEllipsis => 'Saisir son adresse…';

  @override
  String setAddressTitle(String name) {
    return 'Adresse de « $name »';
  }

  @override
  String setAddressBody(String name) {
    return 'À utiliser si les deux appareils sont sur des sous-réseaux différents, ou si tous deux ont changé d’adresse. Saisissez l’adresse affichée sur « $name » sous Ajouter un appareil → Afficher un code.';
  }

  @override
  String get addressSaved => 'Recherche à cette adresse';

  @override
  String get lanBlockedTitle => 'macOS bloque le réseau local';

  @override
  String lanBlockedBody(String device) {
    return 'Activez PasteFerry Daemon dans Réglages Système → Confidentialité et sécurité → Réseau local. D’ici là, $device ne peut pas se connecter aux appareils de ce réseau.';
  }

  @override
  String get searchNearby => 'Rechercher à proximité';

  @override
  String get nearbyTitle => 'Appareils à proximité';

  @override
  String get nearbySearching => 'Recherche d’appareils à proximité…';

  @override
  String get nearbyHint =>
      'Ouvrez aussi Rechercher à proximité sur l’autre ordinateur : il apparaîtra ici. Cliquez dessus pour le jumeler.';

  @override
  String nearbyVisible(String device) {
    return 'Tant que cette fenêtre est ouverte, les appareils de ce réseau peuvent voir le nom de $device.';
  }

  @override
  String get nearbyPaired => 'Jumelé';

  @override
  String nearbyRequesting(String name) {
    return 'Contact de « $name »…';
  }

  @override
  String nearbyNoReply(String name) {
    return '« $name » n’a pas répondu. Vérifiez que Rechercher à proximité y est toujours ouvert.';
  }

  @override
  String get nearbyLanOffTitle =>
      'La découverte sur le réseau local est désactivée';

  @override
  String get nearbyLanOffBody =>
      'Activez « Trouver des appareils sur ce réseau » dans Réglages → Connexion pour voir les appareils à proximité, ou jumelez-les avec un code.';

  @override
  String get generateCode => 'Afficher un code';

  @override
  String get enterCode => 'Saisir un code';

  @override
  String get codeFailedTitle => 'Impossible de créer un code de jumelage';

  @override
  String get enterOnOther => 'Saisissez ce code sur votre autre appareil';

  @override
  String get codeCopied => 'Code copié';

  @override
  String get codeHint => 'Cliquez pour copier. Valable 5 minutes.';

  @override
  String afterEnterFootnote(String both) {
    return 'Une fois le code saisi, $both affichent les deux mêmes lignes d’empreintes de sécurité. Ne confirmez que si elles sont identiques.';
  }

  @override
  String get codeInvalid => 'Un code de jumelage compte 6 lettres ou chiffres';

  @override
  String get localAddress => 'Adresse';

  @override
  String get addressHint =>
      'Sur un autre sous-réseau ? Saisissez aussi cette adresse sur l’autre appareil.';

  @override
  String get addressCopied => 'Adresse copiée';

  @override
  String get differentSubnet => 'Sur un autre sous-réseau ?';

  @override
  String get peerAddress => 'Adresse affichée sous le code';

  @override
  String get pairNotFound =>
      'Appareil introuvable. S’il est sur un autre sous-réseau, saisissez l’adresse affichée sous son code.';

  @override
  String get pairNotFoundAddress =>
      'Aucune réponse à cette adresse. Vérifiez l’adresse et que l’autre appareil affiche toujours son code. Un pare-feu sur cet appareil peut aussi la bloquer.';

  @override
  String get codeWrong => 'Ce code est incorrect ou a expiré';

  @override
  String get codeExpired =>
      'Ce code a expiré. Affichez-en un nouveau sur l’autre appareil.';

  @override
  String get addressInvalid =>
      'Cette adresse n’est pas valide. Saisissez par exemple 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Activez d’abord la découverte sur le réseau local ou définissez un serveur dans Réglages → Connexion.';

  @override
  String get enterCodeShown =>
      'Saisissez le code affiché sur votre autre appareil';

  @override
  String get pairingDone => 'Jumelé';

  @override
  String get pairingRejected => 'Jumelage refusé';

  @override
  String get verifyTitle => 'Vérifiez les empreintes de sécurité';

  @override
  String pairingWith(String name) {
    return 'Jumelage avec « $name »';
  }

  @override
  String verifyBody(String both) {
    return 'Les deux lignes affichées sur $both doivent être identiques. Si un seul caractère diffère, quelqu’un tente peut-être d’altérer la connexion : refusez.';
  }

  @override
  String get rejectMismatch => 'Différentes, refuser';

  @override
  String get confirmMatch => 'Identiques, jumeler';

  @override
  String get server => 'Serveur (facultatif)';

  @override
  String get signalingUrl => 'Serveur de signalisation';

  @override
  String get signalingUrlDesc =>
      'Laissez vide pour synchroniser uniquement en local';

  @override
  String get signalingUrlPlaceholder => 'ws://adresse-du-serveur:8787/signal';

  @override
  String get publicStun => 'Améliorer les connexions directes';

  @override
  String get publicStunDesc =>
      'Les serveurs publics peuvent voir votre IP publique';

  @override
  String get connectionStatus => 'Connexion';

  @override
  String get disconnectedDesc =>
      'Vérifiez l’adresse du serveur et sa disponibilité';

  @override
  String get connected => 'Connecté';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get notSet => 'Non défini';

  @override
  String get serverCleared =>
      'Serveur supprimé. Synchronisation sur ce réseau uniquement.';

  @override
  String get localNetwork => 'Réseau local';

  @override
  String get lanDiscovery => 'Trouver des appareils sur ce réseau';

  @override
  String get lanDiscoveryDesc =>
      'Découverte anonyme ; les noms ne sont visibles que pendant la recherche à proximité';

  @override
  String get macLocalNetwork => 'Accès au réseau local';

  @override
  String get macLocalNetworkDesc =>
      'Autorisez PasteFerry Daemon dans Réglages Système';

  @override
  String get allowLan => 'Pare-feu Windows';

  @override
  String get allowLanDesc =>
      'Autoriser les connexions bloquées ; nécessite l’accord d’un administrateur';

  @override
  String get allow => 'Autoriser';

  @override
  String get allowLanDone =>
      'Autorisé. Les autres appareils peuvent maintenant joindre celui-ci.';

  @override
  String get deviceName => 'Nom de l’appareil';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get sync => 'Synchronisation';

  @override
  String get autoSyncLimit => 'Limite de synchronisation auto';

  @override
  String get autoSyncLimitDesc =>
      'Recevez manuellement les éléments plus volumineux depuis l’historique';

  @override
  String get autoApply => 'Placer les éléments reçus dans le presse-papiers';

  @override
  String get whatToSync => 'Contenu à synchroniser';

  @override
  String get syncFiles => 'Fichiers et dossiers';

  @override
  String get syncText => 'Texte brut';

  @override
  String get syncRich => 'Texte enrichi';

  @override
  String get syncImages => 'Images et captures d’écran';

  @override
  String get storage => 'Stockage';

  @override
  String get storageFootnote =>
      'L’historique et les fichiers en cache expirés sont supprimés automatiquement.';

  @override
  String get keepHistory => 'Conserver l’historique';

  @override
  String get keepCache => 'Conserver les fichiers en cache';

  @override
  String get keepCacheDesc => 'Pas plus longtemps que l’historique';

  @override
  String get cacheUsage => 'Taille du cache';

  @override
  String get backgroundSync => 'Synchronisation en arrière-plan';

  @override
  String get backgroundService => 'Service d’arrière-plan';

  @override
  String get backgroundServiceDesc =>
      'Démarre à l’ouverture de session ; synchronise même fenêtre fermée';

  @override
  String get restart => 'Redémarrer';

  @override
  String get restarted => 'Service d’arrière-plan redémarré';

  @override
  String get disableEllipsis => 'Désactiver…';

  @override
  String get about => 'À propos';

  @override
  String get aboutDesc => 'Logiciel libre sous licence AGPL-3.0';

  @override
  String get homepage => 'Site web';

  @override
  String get feedback => 'Signaler un problème';

  @override
  String get disableTitle => 'Désactiver la synchronisation en arrière-plan ?';

  @override
  String disableBody(String device) {
    return 'PasteFerry sur $device cessera de synchroniser et ne démarrera plus à l’ouverture de session. L’historique et les jumelages sont conservés.';
  }

  @override
  String get disable => 'Désactiver';

  @override
  String get disabled => 'Synchronisation en arrière-plan désactivée';

  @override
  String get urlMustBeWs => 'L’adresse doit commencer par ws:// ou wss://';

  @override
  String get serverUpdated => 'Serveur mis à jour. Reconnexion…';

  @override
  String get deviceNameUpdated => 'Nom de l’appareil mis à jour';

  @override
  String get diagIntro =>
      'Ce rapport contient la version de l’app, votre système, les réglages, les appareils et les journaux récents. Les noms d’appareils, l’adresse du serveur, les adresses IP publiques, votre dossier utilisateur et les noms de fichiers sont remplacés, et ce que vous copiez n’est jamais écrit dans les journaux. Les tickets sur GitHub sont publics : relisez-le avant de le publier.';

  @override
  String get diagVerboseTitle => 'Journalisation détaillée';

  @override
  String get diagVerboseDesc =>
      'Pour les problèmes de connexion : activez-la, reproduisez le problème, puis revenez générer le rapport. Elle se désactive au bout de 30 minutes.';

  @override
  String get diagVerboseOn => 'Activer pendant 30 minutes';

  @override
  String diagVerboseUntil(String time) {
    return 'Activée jusqu’à $time';
  }

  @override
  String get diagVerboseOff => 'Désactiver';

  @override
  String get diagRefresh => 'Régénérer';

  @override
  String get diagSave => 'Enregistrer dans un fichier';

  @override
  String diagSaved(String name) {
    return 'Enregistré dans votre dossier Téléchargements : $name';
  }

  @override
  String get diagCopy => 'Copier le rapport';

  @override
  String get diagCopied => 'Rapport copié';

  @override
  String get diagNewIssue => 'Nouveau ticket sur GitHub';

  @override
  String get diagIssueHint =>
      'Rapport copié. Collez-le dans le champ « Diagnostics report » du ticket.';

  @override
  String diagFailed(String detail) {
    return 'Impossible de créer le rapport : $detail';
  }

  @override
  String get svcExtractTitle => 'Installez ou extrayez d’abord PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry s’exécute directement depuis l’archive zip, et son dossier temporaire disparaît à la fermeture. Lancez le programme d’installation, ou extrayez tout le dossier et ouvrez PasteFerry depuis celui-ci, pour activer la synchronisation en arrière-plan.';

  @override
  String get svcMoveTitle => 'Placez d’abord PasteFerry dans Applications';

  @override
  String get svcMoveBody =>
      'PasteFerry s’exécute directement depuis l’image disque. Faites-le glisser dans Applications, éjectez l’image disque, puis ouvrez-le depuis Applications pour activer la synchronisation en arrière-plan.';

  @override
  String get svcStartTitle => 'Bienvenue dans PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry exécute un petit processus en arrière-plan pour synchroniser le presse-papiers. Il continue de tourner quand vous fermez la fenêtre. Le lancement à l’ouverture de session est un réglage distinct, désactivé sur les nouvelles installations.';

  @override
  String get svcEnable => 'Activer la synchronisation en arrière-plan';

  @override
  String get svcStaleTitle => 'Réactivez la synchronisation en arrière-plan';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry a été déplacé, mais le démarrage à l’ouverture de session pointe toujours vers l’ancien emplacement. Réactivez-la pour que le processus en arrière-plan utilise cette copie. L’historique et les jumelages sont conservés.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry a été déplacé ou installé avec un ancien script. Réactivez-la pour que le processus en arrière-plan utilise cette app. L’historique et les jumelages sont conservés.';

  @override
  String get svcReenable => 'Réactiver';

  @override
  String get svcStoppedTitle => 'Le service d’arrière-plan n’est pas lancé';

  @override
  String get svcStoppedBody =>
      'Le service d’arrière-plan est arrêté. Démarrez-le avec le bouton ci-dessous ; le lancement à l’ouverture de session se règle séparément dans les réglages.';

  @override
  String get svcDevBodyWin =>
      'Ceci est une version de développement sans pasteferryd.exe à côté. Exécutez scripts\\build-windows.ps1 dans le dossier des sources pour compiler une version complète.';

  @override
  String get svcDevBodyLinux =>
      'Ceci est une version de développement sans pasteferryd à côté. Exécutez ./scripts/package-linux.sh dans le dossier des sources pour compiler une version complète.';

  @override
  String get svcDevBodyMac =>
      'Ceci est une version de développement sans le service d’arrière-plan. Exécutez ./scripts/install-macos.sh dans le dossier des sources pour l’installer.';

  @override
  String svcLogPath(String path) {
    return 'Journal : $path';
  }

  @override
  String get svcCanDisable =>
      'Vous pouvez désactiver la synchronisation en arrière-plan à tout moment dans les réglages.';

  @override
  String get officialService => 'Service';

  @override
  String get useOfficialService => 'Utiliser le service';

  @override
  String get officialServiceDesc =>
      'Synchronisation entre réseaux, connexion directe en priorité';

  @override
  String get officialPrivacy =>
      'PasteFerry se connecte au service uniquement s’il est activé et enregistre les informations de connexion indispensables. Une connexion directe est d’abord tentée ; l’accès au relais n’est demandé qu’en cas d’échec. Ni le contenu, ni les vrais noms des appareils, ni les identifiants système bruts ne sont envoyés.';

  @override
  String get officialEnableTitle => 'Activer le service ?';

  @override
  String get officialSwitchConfirm =>
      'Votre serveur personnalisé ne sera plus utilisé. Son adresse enregistrée sera conservée.';

  @override
  String get customServer => 'Serveur personnalisé';

  @override
  String get saveAndConnect => 'Enregistrer et connecter';

  @override
  String get officialLoading => 'Vérification du quota…';

  @override
  String get officialFetchFailed =>
      'Impossible d’obtenir le quota pour le moment. Nouvelle tentative automatique.';

  @override
  String get officialUnavailable =>
      'Utilisation indisponible ; les données affichées peuvent être obsolètes';

  @override
  String get officialQuotaTitle => 'Quota de relais du jour épuisé';

  @override
  String get officialQuotaBody =>
      'Le relais du service est suspendu jusqu’à la réinitialisation quotidienne à minuit, heure de Pékin. Les connexions par réseau local et directes par Internet restent disponibles. Les transferts échoués pourront être relancés plus tard.';

  @override
  String get officialPeerQuota =>
      'L’autre appareil n’a plus de quota de relais. Les connexions directes restent disponibles.';

  @override
  String get officialPaused =>
      'Le relais du service est indisponible. Les connexions directes restent disponibles.';

  @override
  String get officialViewUsage => 'Voir l’utilisation';

  @override
  String get officialAcknowledge => 'OK';

  @override
  String get officialToday => 'Quota de relais du jour';

  @override
  String get officialUsed => 'Utilisé';

  @override
  String get officialRemaining => 'Restant';

  @override
  String get officialDailyLimit => 'Quota quotidien';

  @override
  String get officialUpload => 'Envoi';

  @override
  String get officialDownload => 'Réception';

  @override
  String get officialReset => 'Réinitialisation (heure de Pékin)';

  @override
  String get officialUpdated => 'Dernière mise à jour';

  @override
  String get officialRoutes => 'Mode de connexion des appareils';

  @override
  String get officialRoutesFootnote =>
      'Les connexions directes ne passent pas par le relais du service et n’utilisent pas le quota.';

  @override
  String get officialDeviceID => 'Identifiant de l’appareil';

  @override
  String get officialWarning =>
      '90 % du quota de relais du jour a été utilisé. Les connexions directes ne le consomment pas.';

  @override
  String get updateCheck => 'Rechercher des mises à jour';

  @override
  String get updateCheckEllipsis => 'Rechercher des mises à jour…';

  @override
  String get updateAuto => 'Rechercher automatiquement les mises à jour';

  @override
  String get updateChecking => 'Recherche de mises à jour…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version est la dernière version.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version est disponible';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Vous avez la version $current. Taille du téléchargement : $size.';
  }

  @override
  String get updateNew => 'Nouveautés';

  @override
  String get updateFixed => 'Corrections';

  @override
  String get updateSkip => 'Ignorer cette version';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get updateInstall => 'Télécharger et installer';

  @override
  String updateDownloading(String done, String total) {
    return 'Téléchargement : $done sur $total';
  }

  @override
  String get updateVerifying => 'Vérification du téléchargement…';

  @override
  String get updateInstalling =>
      'Installation. PasteFerry se rouvrira tout seul.';

  @override
  String get updateInstallingPassword =>
      'Installation. Le système va vous demander votre mot de passe, car /opt nécessite des droits d’administrateur ; PasteFerry se rouvrira ensuite tout seul.';

  @override
  String get updateCheckFailed =>
      'Impossible de joindre GitHub ou Gitee. Réessayez plus tard.';

  @override
  String get updateDownloadFailed =>
      'Le téléchargement n’a pas abouti. Réessayez ou téléchargez la nouvelle version depuis le site web.';

  @override
  String updateInstallFailed(String error) {
    return 'Impossible de lancer l’installation : $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Cette version ne peut pas rechercher de mises à jour.';

  @override
  String get updateBlockedDev =>
      'Ceci est une version de développement : elle ne peut pas se mettre à jour elle-même.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry s’exécute depuis l’image disque. Faites-le glisser dans Applications et ouvrez-le depuis ce dossier pour le mettre à jour automatiquement.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry ne peut pas écrire dans son dossier d’installation. Téléchargez plutôt la nouvelle version depuis le site web.';

  @override
  String get updateBlockedUnsupported =>
      'Aucune mise à jour automatique n’est disponible pour cet ordinateur. Téléchargez la nouvelle version depuis le site web.';

  @override
  String get updateOpenDownload => 'Ouvrir la page de téléchargement';

  @override
  String updateSidebar(String version) {
    return 'La version $version est disponible';
  }

  @override
  String updatedTo(String version) {
    return 'Mis à jour vers la version $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'La mise à jour n’a pas abouti. Vous utilisez toujours la version $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'La mise à jour n’a pas abouti. Vous utilisez toujours la version $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Interface $uiVersion · Service $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Non reçu ; recevez-le avant de coller';

  @override
  String get receivedPreserved =>
      'Reçu ; utilisez Copier dans le presse-papiers quand vous voulez';

  @override
  String get clipboardWriteFailed =>
      'Reçu, mais le presse-papiers n’a pas pu être mis à jour';

  @override
  String get receivingStatus => 'Réception…';

  @override
  String get largeFileNotifications => 'Rappels pour les gros fichiers';

  @override
  String get notificationsAllowed =>
      'Les notifications sont activées. La progression s’affiche dans l’historique.';

  @override
  String get notificationsNotRequested =>
      'Activez les notifications pour ne pas laisser les gros fichiers en attente sans le savoir. Vous pouvez toujours les recevoir depuis l’historique.';

  @override
  String get notificationsDenied =>
      'Les notifications sont bloquées dans les réglages du système. Recevez les éléments en attente depuis l’historique.';

  @override
  String get notificationsUnknown =>
      'Votre bureau gère l’affichage des notifications et le mode Ne pas déranger. Si aucun rappel n’apparaît, recevez les éléments depuis l’historique.';

  @override
  String get notificationsUnavailable =>
      'Les notifications système ne sont pas disponibles. Recevez les gros fichiers depuis l’historique.';

  @override
  String get enableNotifications => 'Activer les rappels';

  @override
  String get notificationSettings => 'Réglages des notifications';

  @override
  String get notifyPendingTitle => 'À recevoir avant de coller';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nRecevez cet élément avant de le coller. Vous pouvez aussi le recevoir depuis l’historique.';
  }

  @override
  String get notifyReceivingTitle => 'Réception…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nSuivez la progression dans l’historique.';
  }

  @override
  String get notifyReadyTitle => 'Prêt à coller';

  @override
  String notifyReadyBody(String name) {
    return '$name\nReçu et placé dans le presse-papiers.';
  }

  @override
  String get notifyReceivedTitle => 'Reçu';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nVotre presse-papiers a été conservé. Utilisez Copier dans le presse-papiers quand vous voulez ; c’est aussi possible depuis l’historique.';
  }

  @override
  String get notifyFailedTitle => 'Réception impossible';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nRéessayez depuis cette notification ou l’historique.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Reçu ; le presse-papiers n’a pas été mis à jour';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUtilisez Copier dans le presse-papiers pour réessayer, ici ou dans l’historique.';
  }

  @override
  String get reconnect => 'Reconnecter';

  @override
  String get reconnecting => 'Connexion…';

  @override
  String get reconnectDirect => 'Connecté directement';

  @override
  String get reconnectRelay =>
      'Connexion directe impossible, le relais reste utilisé';

  @override
  String reconnectOffline(String name) {
    return '« $name » est hors ligne. Vérifiez que PasteFerry y est ouvert.';
  }

  @override
  String get reconnectPending => 'Connexion en cours, revenez dans un instant';

  @override
  String get renameAction => 'Renommer';

  @override
  String get renameFavoriteTitle => 'Renommer le favori';

  @override
  String get renameFavoriteHint =>
      'Affiché dans les favoris et le collage rapide, et utilisable dans la recherche. Laissez vide pour afficher à nouveau le contenu.';

  @override
  String get renamedToast => 'Renommé';

  @override
  String get aliasClearedToast => 'Le contenu est de nouveau affiché';

  @override
  String get navSend => 'Envoi de fichiers';

  @override
  String get sendSubtitle =>
      'Faites glisser des fichiers sur un appareil pour les lui envoyer directement';

  @override
  String get sendNoDevicesTitle => 'Aucun appareil jumelé';

  @override
  String get sendNoDevicesBody =>
      'Jumelez d’abord un autre ordinateur, puis envoyez-lui des fichiers ici.';

  @override
  String get sendDropHint => 'Déposez sur un appareil pour envoyer';

  @override
  String sendReleaseTo(String name) {
    return 'Relâchez pour envoyer à $name';
  }

  @override
  String get sendLan => 'Réseau local';

  @override
  String sendRelayLeft(String left) {
    return 'Relais · reste $left aujourd’hui';
  }

  @override
  String get sendNeedsUpdate => 'Mise à jour requise';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name pourra recevoir des fichiers après la mise à jour vers PasteFerry 2.5 ou ultérieur.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Connexion à $name. Vous pourrez envoyer une fois la connexion établie.';
  }

  @override
  String get sendNotReceiving => 'Ne reçoit pas de fichiers';

  @override
  String get sendDelivered => 'Remis';

  @override
  String sendToTitle(String name) {
    return 'Envoyer à $name';
  }

  @override
  String get sendDropHere => 'Faites glisser des fichiers ou des dossiers ici';

  @override
  String get sendDropStarts => 'L’envoi commence dès que vous les déposez';

  @override
  String get sendChooseFiles => 'Choisir des fichiers…';

  @override
  String get sendChooseFolder => 'Choisir un dossier…';

  @override
  String get sendDropMore =>
      'Déposez d’autres fichiers pour les envoyer ensuite';

  @override
  String sendSavedWhere(String name) {
    return 'Les fichiers sont enregistrés à l’emplacement choisi par $name : le dossier Téléchargements par défaut.';
  }

  @override
  String get sendCloseKeeps => 'Fermer cette fenêtre n’interrompt pas l’envoi';

  @override
  String get sendRemoveQueued => 'Retirer';

  @override
  String get sendCannotDrop =>
      'Cet élément ne peut pas être envoyé par glisser-déposer. Enregistrez-le d’abord dans un fichier, ou utilisez Choisir des fichiers….';

  @override
  String sendErrOffline(String name) {
    return '$name est hors ligne.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name ne reçoit pas de fichiers.';
  }

  @override
  String get sendErrMissing => 'Certains de ces fichiers n’existent plus.';

  @override
  String get relayConfirmTitle => 'Envoyer par le relais du service ?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name n’a pas de connexion directe avec cet ordinateur pour le moment : les fichiers passeront par le relais du service, à environ 0,25 Mo/s. Il reste $left sur le quota de relais du jour.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Ces fichiers ($size) dépassent le quota restant. L’envoi s’interrompt quand il est épuisé et reprend quand les deux ordinateurs se connectent directement ou quand le quota est réinitialisé demain.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Cet envoi utilise environ $size du quota du jour.';
  }

  @override
  String get relayExhausted =>
      'Le quota de relais du jour est épuisé. Il est réinitialisé à minuit, heure de Pékin. Deux ordinateurs connectés directement n’ont aucune limite.';

  @override
  String get relayDontAskToday =>
      'Ne plus demander aujourd’hui pour cet appareil';

  @override
  String get relaySendAnyway => 'Envoyer quand même';

  @override
  String get relayOwnServer => 'Relayé ; la vitesse dépend de votre serveur';

  @override
  String get transfersReceived => 'Reçus';

  @override
  String get transfersSent => 'Envoyés';

  @override
  String get transfersClearAll => 'Tout effacer';

  @override
  String get transfersClearTitle => 'Effacer cette liste ?';

  @override
  String get transfersClearBody =>
      'Seule la liste est effacée. Les fichiers restent où ils sont.';

  @override
  String get transfersEmptyReceived =>
      'Les fichiers que vous envoient d’autres appareils apparaissent ici';

  @override
  String get transfersEmptySent =>
      'Les fichiers que vous envoyez apparaissent ici';

  @override
  String transferFrom(String name) {
    return 'De $name';
  }

  @override
  String transferTo(String name) {
    return 'À $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others autres',
      one: '$others autre',
    );
    return '$name et $_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers',
      one: '$count fichier',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'En attente';

  @override
  String transferScanning(String count) {
    return 'Comptage… $count fichiers trouvés';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'En attente de $name…';
  }

  @override
  String get transferSending => 'Envoi';

  @override
  String get transferReceiving => 'Réception';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'En cours : $file ($index sur $total)';
  }

  @override
  String transferLeft(String time) {
    return '$time restant';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n secondes',
      one: '$n seconde',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minutes',
      one: '$n minute',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h h $m min';
  }

  @override
  String get transferPaused =>
      'En pause : le quota de relais du jour est épuisé';

  @override
  String get transferInterrupted => 'Interrompu ; reprendra à la reconnexion';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Interrompu ; en attente de $name pour reprendre';
  }

  @override
  String get transferCancelled => 'Annulé';

  @override
  String transferPeerCancelled(String name) {
    return 'Annulé par $name';
  }

  @override
  String get transferExpired => 'Expiré';

  @override
  String get transferMissing => 'Déplacé ou supprimé';

  @override
  String transferNotSent(String reason) {
    return 'Non envoyé : $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Non reçu : $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name manque d’espace disque (il manque $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'espace disque insuffisant (il manque $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'l’emplacement d’enregistrement de $name n’est pas disponible';
  }

  @override
  String get reasonDestUnavailable =>
      'l’emplacement d’enregistrement n’est pas disponible ; vérifiez-le dans les réglages';

  @override
  String get reasonFileTooLarge =>
      'l’emplacement d’enregistrement est sur un disque FAT32, qui ne peut pas contenir de fichiers de plus de 4 Go';

  @override
  String reasonDisabledPeer(String name) {
    return '$name ne reçoit pas de fichiers';
  }

  @override
  String get reasonSourceChanged =>
      'un fichier a été modifié pendant son envoi';

  @override
  String get reasonSourceMissing => 'un fichier n’existe plus';

  @override
  String get reasonReadError => 'un fichier n’a pas pu être lu';

  @override
  String get reasonWriteFailed => 'les fichiers n’ont pas pu être écrits';

  @override
  String get reasonHashMismatch =>
      'un fichier a été endommagé pendant le transfert';

  @override
  String reasonUnsupported(String name) {
    return '$name doit se mettre à jour pour recevoir des fichiers';
  }

  @override
  String get reasonOther => 'un problème est survenu';

  @override
  String get revealInFinder => 'Afficher dans le Finder';

  @override
  String get revealInFolder => 'Afficher dans le dossier';

  @override
  String get revealOpenFolder => 'Ouvrir le dossier';

  @override
  String get transferResend => 'Renvoyer';

  @override
  String get transferRemove => 'Retirer de la liste';

  @override
  String get transferCopyPath => 'Copier le chemin';

  @override
  String get transferPathCopied => 'Chemin copié';

  @override
  String sendingTo(String name, String percent) {
    return 'Envoi à $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Réception de $name · $percent';
  }

  @override
  String get receiveFiles => 'Recevoir des fichiers d’autres appareils';

  @override
  String get saveTo => 'Enregistrer dans';

  @override
  String get saveToChange => 'Modifier…';

  @override
  String get saveToDefault => 'Téléchargements (par défaut)';

  @override
  String get saveToUseDefault => 'Utiliser Téléchargements';

  @override
  String get receiveNotify => 'Avertir à l’arrivée de fichiers';

  @override
  String receiveFootnote(String device) {
    return 'Seuls les appareils jumelés peuvent envoyer des fichiers à $device. Pendant un transfert, $device ne se met pas en veille de lui-même.';
  }

  @override
  String get saveDirNotFound => 'Ce dossier n’existe pas.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry ne peut pas enregistrer de fichiers dans ce dossier.';

  @override
  String get saveDirPermission =>
      'PasteFerry n’est pas autorisé à utiliser ce dossier. Autorisez-le dans Réglages Système → Confidentialité et sécurité → Fichiers et dossiers.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count noms de fichiers contenaient des caractères interdits par Windows ; ils ont été remplacés par des caractères pleine chasse similaires',
      one:
          '$count nom de fichier contenait des caractères interdits par Windows ; ils ont été remplacés par des caractères pleine chasse similaires',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Même réseau';

  @override
  String get sendRingOther => 'Autres réseaux';

  @override
  String sendOfflineList(String names) {
    return 'Hors ligne : $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Liste des transferts';

  @override
  String get sendLayoutSide => 'À côté du radar';

  @override
  String get sendLayoutBelow => 'Sous le radar';

  @override
  String get general => 'Général';

  @override
  String get launchAtLogin => 'Lancer à l’ouverture de session';

  @override
  String get launchAtLoginDesc =>
      'Démarre en arrière-plan quand vous ouvrez votre session. Modifier ce réglage n’arrête pas la session en cours.';

  @override
  String get realtimeSync => 'Synchronisation du presse-papiers en temps réel';

  @override
  String get realtimeSyncDesc =>
      'Partage automatiquement ce que vous copiez avec les appareils jumelés. Une fois désactivée, l’historique local et l’envoi de fichiers restent disponibles.';

  @override
  String get syncBacklog => 'Rattraper après la reconnexion';

  @override
  String get syncBacklogDesc =>
      'Désactivé par défaut : les copies manquées sont ignorées. Une fois activé, jusqu’à 20 copies des dernières 24 heures sont ajoutées à l’historique sans remplacer le presse-papiers.';

  @override
  String get peerRealtimeSync => 'Synchroniser avec cet ordinateur';

  @override
  String get syncPaused => 'Synchronisation du presse-papiers en pause';

  @override
  String get quitApp => 'Quitter PasteFerry';

  @override
  String get quitAppDesc =>
      'Arrête tous les processus de PasteFerry. Votre réglage de lancement à l’ouverture de session est conservé.';

  @override
  String get quitTransfersWarning =>
      'Des fichiers sont encore en cours de transfert. Quitter et interrompre ces transferts ?';

  @override
  String get backgroundRunningTitle => 'PasteFerry reste ouvert';

  @override
  String get backgroundRunningBody =>
      'Fermer la fenêtre laisse la synchronisation et le collage rapide actifs. Pour tout arrêter, choisissez Quitter PasteFerry dans les réglages ou le menu de l’app.';

  @override
  String get displayAs => 'Affiché sous le nom';

  @override
  String get editName => 'Modifier le nom';

  @override
  String get nameHint => 'Le nom que voient vos contacts';

  @override
  String get nameDefaultHint =>
      'Laissez vide pour utiliser le nom de votre compte.';

  @override
  String get avatarTitle => 'Photo de profil';

  @override
  String get avatarChoose => 'Choisir une image…';

  @override
  String get avatarPaste => 'Coller une image';

  @override
  String get avatarReset => 'Utiliser la photo par défaut';

  @override
  String get avatarZoom => 'Zoom';

  @override
  String get avatarDragHint => 'Faites glisser pour déplacer l’image.';

  @override
  String get avatarNoImage => 'Le presse-papiers ne contient pas d’image.';

  @override
  String get avatarBad =>
      'Cette image n’est pas utilisable. Choisissez un fichier PNG, JPEG ou GIF.';

  @override
  String get done => 'OK';

  @override
  String get friendsTitle => 'Contacts';

  @override
  String get addFriend => 'Ajouter un contact';

  @override
  String get friendsEmpty => 'Aucun contact';

  @override
  String get friendsEmptyBody =>
      'Ajoutez une personne qui utilise aussi PasteFerry pour vous envoyer des fichiers sans jumelage. Les contacts peuvent seulement envoyer des fichiers ; ils ne voient jamais votre presse-papiers.';

  @override
  String get friendSendAction => 'Envoyer…';

  @override
  String get friendHistory => 'Transferts';

  @override
  String friendHistoryTitle(String name) {
    return 'Transferts avec $name';
  }

  @override
  String get friendHistoryEmpty => 'Aucun transfert pour l’instant.';

  @override
  String get friendAutoAccept => 'Accepter les fichiers automatiquement';

  @override
  String get friendRemove => 'Supprimer le contact';

  @override
  String friendRemoveTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get friendRemoveBody =>
      'Vous serez retirés de vos contacts respectifs et ne pourrez plus vous envoyer de fichiers. Les transferts passés restent sur cet ordinateur.';

  @override
  String friendLastActivity(String time) {
    return 'Dernier transfert : $time';
  }

  @override
  String get friendNoActivity => 'Aucun transfert pour l’instant';

  @override
  String get friendCodeShare =>
      'Envoyez ce code à votre contact. Quand il le saisira dans PasteFerry, vous serez ajoutés à vos contacts respectifs.';

  @override
  String friendCodeExpires(String time) {
    return 'Expire dans $time';
  }

  @override
  String get friendCodeOr => 'ou';

  @override
  String get friendCodeEnter => 'Saisissez son code de contact';

  @override
  String get friendCodeAdd => 'Ajouter';

  @override
  String get friendCodeWaiting => 'En attente de sa saisie…';

  @override
  String friendConfirmBody(String name) {
    return 'Ajouter $name à vos contacts ?';
  }

  @override
  String get friendSafetyCode => 'Vérifier le code de sécurité (facultatif)';

  @override
  String get friendSafetyHint =>
      'Quand vous êtes ensemble, comparez ces deux lignes. Si elles sont identiques sur les deux ordinateurs, personne n’est intervenu.';

  @override
  String get friendWaitingPeer => 'En attente de son ajout…';

  @override
  String friendAdded(String name) {
    return '$name a été ajouté à vos contacts';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name a annulé';
  }

  @override
  String get friendErrFriendCode =>
      'Ceci est un code de contact. Saisissez-le dans Ajouter un contact, sur la page Envoi de fichiers.';

  @override
  String get friendErrDeviceCode =>
      'Ceci est un code de jumelage. Saisissez-le dans Appareils → Ajouter un appareil.';

  @override
  String get friendErrOutdated =>
      'Votre contact doit avoir PasteFerry 2.6.0 ou ultérieur.';

  @override
  String get friendErrAlreadyPaired =>
      'Cet ordinateur fait déjà partie de vos appareils.';

  @override
  String get friendErrNoChannel =>
      'Vous n’êtes pas sur le même réseau. Activez le service sur les deux ordinateurs pour vous ajouter.';

  @override
  String get openService => 'Activer le service…';

  @override
  String get noteLabel => 'Note (facultatif)';

  @override
  String get noteHintEmpty => 'Choisissez d’abord des fichiers';

  @override
  String get noteHint => 'Par exemple : merci de signer la page 3';

  @override
  String noteLine(String note) {
    return 'Note : $note';
  }

  @override
  String get sendAction => 'Envoyer';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count éléments · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Déposez des fichiers ou des images ici, ou collez-les ($key)';
  }

  @override
  String get sendDropMorePaste => 'Déposez ou collez-en d’autres';

  @override
  String get sendPasteNothing =>
      'Rien à coller. Copiez d’abord des fichiers ou une image.';

  @override
  String get sendRemoveItem => 'Retirer';

  @override
  String sendFriendSaved(String name) {
    return '$name accepte chaque lot avant son envoi.';
  }

  @override
  String transferAskingOut(String name) {
    return 'En attente de l’accord de $name…';
  }

  @override
  String get transferAskingIn => 'En attente de votre accord';

  @override
  String reasonDeclined(String name) {
    return '$name a refusé';
  }

  @override
  String reasonTimeout(String name) {
    return '$name n’a pas répondu';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name n’accepte pas de fichiers';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name n’accepte pas vos fichiers pour le moment';
  }

  @override
  String get reasonYouDeclined => 'Refusé';

  @override
  String get reasonYouIgnored => 'Ignoré';

  @override
  String get sendAgain => 'Renvoyer';

  @override
  String incomingTitle(String name) {
    return '$name veut vous envoyer des fichiers';
  }

  @override
  String get incomingAlways => 'Toujours accepter les fichiers de ce contact';

  @override
  String get incomingDecline => 'Refuser';

  @override
  String get incomingAccept => 'Accepter';

  @override
  String incomingCountdown(String seconds) {
    return 'Refus automatique dans $seconds s';
  }

  @override
  String get incomingStranger => 'À proximité';

  @override
  String get friendsStrip => 'Contacts';

  @override
  String get strangersStrip => 'À proximité, avec Tout le monde activé';

  @override
  String get strangerNearby => 'À proximité';

  @override
  String get friendNeedService => 'Activez le service';

  @override
  String get friendCantReach => 'Connexion impossible';

  @override
  String reachSelfNoService(String name) {
    return 'Vous et $name n’êtes pas sur le même réseau. Activez le service pour envoyer des fichiers ; sans connexion directe possible, ils passent par le relais du service.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name n’a pas activé le service : vous ne pouvez envoyer des fichiers que sur le même réseau. Demandez-lui d’activer le service dans PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Vous n’utilisez pas le même serveur. Activez le service sur les deux ordinateurs, ou utilisez le même serveur, pour envoyer des fichiers.';

  @override
  String get receiveFromLabel => 'Qui peut m’envoyer des fichiers :';

  @override
  String get receiveFromOff => 'Personne';

  @override
  String get receiveFromFriends => 'Contacts uniquement';

  @override
  String get receiveFromEveryone => 'Tout le monde';

  @override
  String everyoneLeft(String minutes) {
    return 'Tout le monde · encore $minutes min';
  }

  @override
  String get receiveFromOffDesc =>
      'Seuls vos propres ordinateurs jumelés peuvent vous envoyer des fichiers.';

  @override
  String get receiveFromFriendsDesc =>
      'Vos contacts peuvent vous envoyer des fichiers. Vous acceptez chaque lot.';

  @override
  String get receiveFromEveryoneDesc =>
      'Toute personne sur le même réseau peut vous envoyer des fichiers pendant 10 minutes. Vous acceptez chaque lot.';

  @override
  String get everyoneEnded =>
      'Tout le monde est désactivé ; retour à Contacts uniquement.';

  @override
  String get friendsCountTooltip => 'Contacts';

  @override
  String get waitingAccept => 'En attente…';

  @override
  String get settingsConnection => 'Connexion';

  @override
  String get settingsGeneralSummary =>
      'Lancement à l’ouverture de session, nom de l’appareil, langue';

  @override
  String get settingsConnectionSummary =>
      'Service, votre propre serveur, réseau local';

  @override
  String get settingsSyncSummary =>
      'Synchronisation en temps réel, limite de taille, contenu à synchroniser';

  @override
  String get settingsQuickPasteSummary => 'Raccourci et action après le choix';

  @override
  String get settingsSendSummary =>
      'Réception de fichiers, emplacement d’enregistrement';

  @override
  String get settingsStorageSummary =>
      'Durée de conservation de l’historique, espace utilisé';

  @override
  String get settingsAboutSummary => 'Version, mises à jour, commentaires';

  @override
  String get friendsSubtitle =>
      'Envoyez des fichiers aux ordinateurs d’autres personnes, sans jumelage';

  @override
  String get friendsSearch => 'Rechercher des contacts';

  @override
  String get friendsNoMatch => 'Aucun contact correspondant';

  @override
  String get friendsPick =>
      'Choisissez un contact pour voir vos transferts ou envoyer des fichiers';

  @override
  String friendDropHint(String name) {
    return 'Déposez des fichiers ici pour les envoyer à $name';
  }

  @override
  String get webShareTitle => 'Transfert web avec un téléphone';

  @override
  String get webShareFootnote =>
      'Scannez un code QR avec un téléphone pour échanger du texte, des photos et des fichiers avec cet ordinateur dans le navigateur, sans app à installer. Le téléphone et l’ordinateur doivent être sur le même réseau.';

  @override
  String get webShareSwitch =>
      'Autoriser les téléphones à se connecter via le navigateur';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléphones',
      one: '$count téléphone',
    );
    return 'Activé, $_temp0';
  }

  @override
  String get webShareOff => 'Désactivé';

  @override
  String get webShareShowQr => 'Afficher le code QR';

  @override
  String get webShareDialogTitle => 'Scannez avec votre téléphone';

  @override
  String get webShareDialogBody =>
      'Scannez avec l’appareil photo ou le navigateur du téléphone, puis ouvrez le lien dans le navigateur. Chaque code QR enregistre un téléphone et est remplacé après usage.';

  @override
  String get webShareAddress => 'Adresse';

  @override
  String get webShareSecurity =>
      'Le contenu est chiffré dans la page, les autres personnes du réseau ne peuvent donc pas le lire. Mais la page elle-même est en http et ne peut pas empêcher une modification délibérée. Utilisez-la chez vous ou sur un réseau de bureau de confiance, pas sur un Wi-Fi public.';

  @override
  String get webSharePhones => 'Téléphones enregistrés';

  @override
  String get webShareNoPhones => 'Aucun téléphone';

  @override
  String webShareLastUsed(String time) {
    return 'Dernière utilisation : $time';
  }

  @override
  String get webShareRemove => 'Retirer';

  @override
  String webShareRemoved(String name) {
    return '« $name » retiré';
  }

  @override
  String webShareNewPhone(String name) {
    return '« $name » enregistré';
  }

  @override
  String webShareNotListening(String error) {
    return 'Impossible de démarrer l’écoute : $error';
  }

  @override
  String get webSharePortFallback =>
      'Le port habituel est occupé, un port temporaire est donc utilisé. Les adresses enregistrées ne s’ouvriront pas tant que les téléphones n’auront pas scanné à nouveau.';

  @override
  String get webShareNoAddress =>
      'Aucune adresse sur le réseau local. Connectez-vous d’abord à un Wi-Fi ou à un réseau filaire.';

  @override
  String get webShareCantOpen =>
      'Si la page ne s’ouvre pas sur le téléphone, vérifiez que les deux appareils sont sur le même réseau (les réseaux invités ne fonctionnent généralement pas). Sous Windows, PasteFerry doit aussi être autorisé dans le pare-feu.';

  @override
  String get mTabRecords => 'Historique';

  @override
  String get mTabSend => 'Envoyer';

  @override
  String get mThisPhone => 'Ce téléphone';

  @override
  String get mThisPhoneInText => 'ce téléphone';

  @override
  String mThisPhoneName(String name) {
    return 'Ce téléphone : $name';
  }

  @override
  String get mSendTitle => 'Envoyer à votre ordinateur';

  @override
  String get mSendHint => 'Saisissez ou collez du texte';

  @override
  String get mPaste => 'Coller';

  @override
  String get mPhotosFiles => 'Photos ou fichiers';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Envoyer $n fichier(s) ?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fichiers envoyés à votre ordinateur',
      one: '$n fichier envoyé à votre ordinateur',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Le presse-papiers ne contient pas de texte';

  @override
  String get mSendAction => 'Envoyer';

  @override
  String mSendTo(String names) {
    return 'Destinataire : $names';
  }

  @override
  String get mNoOnlineDevices => 'Aucun appareil en ligne à proximité';

  @override
  String get mNoPairedDevices => 'Jumelez d’abord un ordinateur';

  @override
  String get mSent => 'Envoyé';

  @override
  String get mSendFootnote =>
      'Le texte et les fichiers arrivent dans l’historique de l’ordinateur et, selon son réglage, dans son presse-papiers. Ce que vous copiez sur le téléphone n’est pas envoyé automatiquement.';

  @override
  String get mSentRecords => 'Envoyés';

  @override
  String get mSentRetention => 'Conserver les envois';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Envoyés affiche ce que ce téléphone a envoyé au cours des $d derniers jours';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d jours';
  }

  @override
  String get mViewAll => 'Tout afficher';

  @override
  String get mClearCache => 'Vider';

  @override
  String get mCheckUpdate => 'Rechercher des mises à jour';

  @override
  String get mUpdateFailed => 'Impossible de rechercher des mises à jour';

  @override
  String get mUpToDate => 'Vous avez la dernière version';

  @override
  String mNewVersion(Object v) {
    return 'La version $v est disponible';
  }

  @override
  String get mDownloadInstall => 'Télécharger la nouvelle version';

  @override
  String mSendFailed(String detail) {
    return 'Envoi impossible : $detail';
  }

  @override
  String get mCopy => 'Copier';

  @override
  String get mCopied => 'Copié dans le presse-papiers de ce téléphone';

  @override
  String get mShare => 'Partager';

  @override
  String get mSaved => 'Enregistré dans Photos ou Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Échec : $detail';
  }

  @override
  String get mDownloading => 'Téléchargement…';

  @override
  String get mNotDownloaded => 'Pas encore téléchargé';

  @override
  String get mDownloadHint =>
      'Le téléchargement a lieu quand vous touchez Copier, Enregistrer ou Partager.';

  @override
  String get mFullTextLoading => 'Chargement…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Affichage des $shown premiers caractères sur $total. Copier copie tout le texte.';
  }

  @override
  String get mNotOnLanTitle => 'Pas de Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Pour l’instant, PasteFerry synchronise uniquement sur le réseau local. Connectez-vous au même Wi-Fi que votre ordinateur.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry n’a pas pu démarrer : $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Sur votre ordinateur, ouvrez PasteFerry → Appareils → Ajouter un appareil, puis saisissez ici le code affiché. Sur le même Wi-Fi, vous pouvez aussi ouvrir « Rechercher à proximité » sur les deux.';

  @override
  String get mSectionSync => 'Synchronisation';

  @override
  String get mSectionBackground => 'Arrière-plan';

  @override
  String get mAutoApplyDesc =>
      'Le texte copié sur votre ordinateur va directement dans le presse-papiers de ce téléphone. Les images et les fichiers attendent que vous touchiez Copier.';

  @override
  String get mKeepAlive => 'Rester connecté en arrière-plan';

  @override
  String get mKeepAliveDesc =>
      'Recevez du texte même quand PasteFerry n’est pas ouvert. Une notification permanente s’affiche.';

  @override
  String get mNotifications => 'Notifications';

  @override
  String get mNotificationsDesc =>
      'Nécessaires pour la notification permanente. PasteFerry fonctionne sans.';

  @override
  String get mBattery => 'Exécution en arrière-plan';

  @override
  String get mBatteryDesc =>
      'Désactivez l’optimisation de la batterie pour que le système n’arrête pas PasteFerry quand l’écran est verrouillé. Sur certains téléphones, il faut aussi ajouter PasteFerry à la liste de démarrage automatique ou d’exécution en arrière-plan dans les paramètres.';

  @override
  String get mAllowed => 'Autorisé';

  @override
  String get mAllow => 'Autoriser';

  @override
  String mVersion(String version) {
    return 'Version $version';
  }

  @override
  String get mDeleteConfirm => 'Supprimer cet élément ?';

  @override
  String get mDelete => 'Supprimer';

  @override
  String get webShareFirewallPreparing =>
      'Vérification du Pare-feu Windows. Si Windows demande l’accord d’un administrateur, choisissez Oui pour que votre téléphone puisse se connecter.';

  @override
  String get webShareFirewallReady =>
      'Les règles du Pare-feu Windows sont prêtes. Connectez votre téléphone au même réseau et scannez le code QR. S’il ne parvient toujours pas à se connecter, vérifiez à nouveau le pare-feu ci-dessous.';

  @override
  String get webShareFirewallFailed =>
      'La configuration du pare-feu n’a pas abouti. Votre téléphone ne pourra peut-être pas ouvrir la page. Réessayez et acceptez la demande d’administrateur de Windows.';

  @override
  String get webShareFirewallAllow => 'Vérifier et autoriser le téléphone';

  @override
  String get mCopyMediaFailed =>
      'Impossible de copier cette image ou ce fichier. Essayez de l’enregistrer d’abord.';

  @override
  String get mShareMediaFailed =>
      'Impossible d’ouvrir le partage pour cette image ou ce fichier. Essayez de l’enregistrer d’abord.';

  @override
  String get mSaveMediaFailed =>
      'Impossible d’enregistrer cette image ou ce fichier. Vérifiez l’accès au stockage et l’espace libre, puis réessayez.';

  @override
  String get noticeFilesUnreadable =>
      'Les fichiers que vous venez de copier n’ont pas pu être lus : rien n’a été synchronisé';

  @override
  String get mAddMore => 'Ajouter';

  @override
  String get mChoosePhotos => 'Choisir des photos…';

  @override
  String get mMultiSelectHint =>
      'Vous pouvez sélectionner plusieurs photos à la fois. Dans Fichiers, maintenez le doigt sur un élément pour en sélectionner d’autres.';

  @override
  String get webSendFiles => 'Envoyer des fichiers';

  @override
  String get webFilesQueued =>
      'Ajouté aux transferts web. Ouvrez Envoi de fichiers sur votre téléphone pour télécharger.';

  @override
  String get webFilesLimit =>
      'Les téléchargements web acceptent jusqu’à 200 Mo par fichier et 64 fichiers par lot.';

  @override
  String get appearance => 'Apparence';

  @override
  String get settingsAppearanceSummary => 'Thème, clair et sombre';

  @override
  String get themeTitle => 'Thème';

  @override
  String get themeDefault => 'Par défaut';

  @override
  String get themePixel => 'Pixel';

  @override
  String get themeMode => 'Clair et sombre';

  @override
  String get themeModeSystem => 'Comme le système';

  @override
  String get themeModeLight => 'Clair';

  @override
  String get themeModeDark => 'Sombre';

  @override
  String get themeCustom => 'Personnalisé';

  @override
  String get themeDelete => 'Supprimer le thème';

  @override
  String themeDeleteConfirm(String name) {
    return 'Supprimer le thème « $name » ?';
  }

  @override
  String get themeLowContrast =>
      'Certains textes de ce thème risquent d’être difficiles à lire';

  @override
  String get themeFootnote =>
      'Les thèmes s’appliquent uniquement à cet appareil, y compris au collage rapide. Ils ne sont pas synchronisés avec les autres appareils.';

  @override
  String get themeBuiltinGroup => 'Intégrés';

  @override
  String get themeCustomGroup => 'Personnalisés';

  @override
  String get themeUse => 'Utiliser';

  @override
  String get themeDuplicate => 'Dupliquer';

  @override
  String themeCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String get themeExport => 'Exporter…';

  @override
  String get themeImport => 'Importer un thème…';

  @override
  String themeImported(String name) {
    return '« $name » importé';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count couleurs de texte risquent d’être difficiles à lire.',
      one: '$count couleur de texte risque d’être difficile à lire.',
    );
    return '« $name » importé. $_temp0';
  }

  @override
  String get themeExported => 'Thème exporté';

  @override
  String get themeCustomEmpty =>
      'Aucun thème personnalisé. Dupliquez un thème intégré, importez-en un ou demandez à une IA d’en créer un.';

  @override
  String get themeAskAi => 'Demander un thème à une IA';

  @override
  String get themeAskAiBody =>
      'Ajoutez ce serveur MCP à une app d’IA comme Claude ou Cursor, puis demandez un thème, par exemple « Crée-moi un thème cyberpunk ». L’IA lit le format des thèmes, choisit les couleurs, vérifie le contraste et applique le thème.';

  @override
  String get themeAskAiCopy => 'Copier la configuration';

  @override
  String get themeAskAiCopied => 'Configuration copiée';

  @override
  String get themeScanlines => 'Lignes de balayage';

  @override
  String get themeScanlinesDesc =>
      'Superpose de légères lignes de balayage CRT sur la fenêtre. Thèmes pixel uniquement.';

  @override
  String get themeBackground => 'Image de fond';

  @override
  String get themeBackgroundDesc =>
      'Remplit la fenêtre derrière la barre latérale et les pages. Un voile par-dessus garde le texte lisible.';

  @override
  String get themeBackgroundChoose => 'Choisir une image…';

  @override
  String get themeBackgroundChange => 'Modifier…';

  @override
  String get themeBackgroundRemove => 'Retirer';

  @override
  String get themeBlur => 'Flou';

  @override
  String get themeBlurNone => 'Aucun';

  @override
  String get themeBlurLight => 'Léger';

  @override
  String get themeBlurStrong => 'Fort';

  @override
  String get themeScrim => 'Voile';

  @override
  String get themeScrimDesc =>
      'Une couleur posée sur l’image pour garder le texte lisible. Elle n’est jamais plus légère que nécessaire.';

  @override
  String get themeScrimAuto => 'Auto';

  @override
  String get themeScrimMore => 'Plus dense';

  @override
  String get themeScrimMost => 'Très dense';

  @override
  String get themePanels => 'Panneaux';

  @override
  String get themePanelsDesc =>
      'Quantité d’image visible à travers la barre latérale et les listes.';

  @override
  String get themePanelsClear => 'Transparents';

  @override
  String get themePanelsMedium => 'Moyens';

  @override
  String get themePanelsSolid => 'Opaques';

  @override
  String get themeAccentFromImage => 'Utiliser les couleurs de l’image';

  @override
  String get themeAccentFromImageDesc =>
      'Prend la couleur d’accentuation dans l’image.';

  @override
  String get themeBackgroundPicker => 'Afficher aussi dans le collage rapide';

  @override
  String get themeScenery => 'Afficher les décors';

  @override
  String get themeSceneryDesc =>
      'Les images en haut des pages et en bas de la barre latérale.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Les thèmes intégrés ne peuvent pas être modifiés : une copie nommée « $name » a été créée et appliquée';
  }

  @override
  String get themeBackgroundFootnote =>
      'L’image de fond appartient au thème actuel. Les thèmes intégrés ne peuvent pas être modifiés : la première modification crée une copie. Les images restent sur cet appareil ; les formats JPEG, PNG et GIF sont pris en charge.';

  @override
  String get themeSceneGroup => 'Décors';

  @override
  String get themeSceneHeader => 'En-tête de page';

  @override
  String get themeSceneHeaderDesc =>
      'Une image large derrière les titres des pages ; son bas se fond dans la page. Le thème pixel y dessine un paysage en pixels.';

  @override
  String get themeSceneSidebar => 'Bas de la barre latérale';

  @override
  String get themeSceneSidebarDesc =>
      'Une petite image en bas de la barre latérale. Le thème pixel y dessine un petit campement.';

  @override
  String get themeSceneReset => 'Réinitialiser';

  @override
  String get themeSceneFootnote =>
      'Tous les thèmes peuvent afficher vos propres images ici. Un voile garde le titre de la page lisible. Les décors sont masqués quand une image de fond remplit la fenêtre.';

  @override
  String get starTitle => 'Que pensez-vous de PasteFerry ?';

  @override
  String get starBody =>
      'Si PasteFerry vous plaît, une étoile sur GitHub nous ferait très plaisir.';

  @override
  String get starAction => 'Ajouter une étoile sur GitHub';

  @override
  String get starLater => 'Plus tard';

  @override
  String get starDismiss => 'Ne plus afficher';
}
