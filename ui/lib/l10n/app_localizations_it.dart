// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navDevices => 'Dispositivi';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navFavorites => 'Preferiti';

  @override
  String get linkConnecting => 'Connessione…';

  @override
  String get linkServiceNotRunning => 'Servizio non attivo';

  @override
  String get linkLanMode => 'Ricerca di dispositivi su questa rete';

  @override
  String get linkServerUnreachable =>
      'Server non raggiungibile; sincronizzazione su questa rete';

  @override
  String get linkNothingOn =>
      'Il rilevamento in rete locale è disattivato e non è impostato alcun server';

  @override
  String get linkLanBlocked => 'macOS sta bloccando la rete locale';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivi online',
      one: '1 dispositivo online',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Connesso al server';

  @override
  String linkConnectionLost(String detail) {
    return 'Connessione persa: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Servizio disconnesso';

  @override
  String get linkServiceDisabled =>
      'La sincronizzazione in background è disattivata';

  @override
  String get errServiceNotConnected => 'Non connesso al servizio in background';

  @override
  String get errUnimplemented => 'Non ancora disponibile';

  @override
  String get errUnavailable =>
      'Impossibile raggiungere il servizio in background';

  @override
  String errServiceStart(String detail) {
    return 'Impossibile avviare il servizio in background: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Impossibile riavviare il servizio in background: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Impossibile impostare l\'avvio di PasteFerry al login: $detail';
  }

  @override
  String get thisMacTitle => 'Questo Mac';

  @override
  String get thisPcTitle => 'Questo computer';

  @override
  String get thisMacInText => 'questo Mac';

  @override
  String get thisPcInText => 'questo computer';

  @override
  String get bothMacs => 'entrambi i Mac';

  @override
  String get bothDevices => 'entrambi i dispositivi';

  @override
  String get thisDeviceShort => 'Questo dispositivo';

  @override
  String fromDevice(String name) {
    return 'Da $name';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get close => 'Chiudi';

  @override
  String get save => 'Salva';

  @override
  String get retry => 'Riprova';

  @override
  String get continueAction => 'Continua';

  @override
  String get justNow => 'Adesso';

  @override
  String secondsAgo(int n) {
    return '$n s fa';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minuti fa',
      one: '1 minuto fa',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ore fa',
      one: '1 ora fa',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giorni fa',
      one: 'Ieri',
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
      other: '$n ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Copia su uno qualsiasi dei tuoi dispositivi e lo troverai qui';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi, conservati',
      one: '1 elemento, conservato',
    );
    return '$_temp0 per $ttl';
  }

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterText => 'Testo';

  @override
  String get filterImage => 'Immagini';

  @override
  String get filterFile => 'File';

  @override
  String get filterLink => 'Link';

  @override
  String get historyClearTooltip => 'Cancella cronologia';

  @override
  String get historyEmptyTitle => 'Ancora niente qui';

  @override
  String get historyEmptyFilteredTitle => 'Niente di questo tipo';

  @override
  String get historyEmptyBody =>
      'Copia testo, un\'immagine o un file su qualsiasi dispositivo abbinato e comparirà qui.';

  @override
  String get clearConfirmTitle => 'Cancellare tutta la cronologia?';

  @override
  String clearConfirmBody(String device) {
    return 'Tutto ciò che è stato sincronizzato dai tuoi dispositivi e i file in cache verranno rimossi da $device. I file originali non vengono toccati.';
  }

  @override
  String get clear => 'Cancella';

  @override
  String get historyCleared => 'Cronologia cancellata';

  @override
  String get permDeniedTitle => 'PasteFerry non può leggere gli appunti';

  @override
  String get permAskTitle => 'Consenti a PasteFerry di leggere gli appunti';

  @override
  String get permDeniedBody =>
      'Ciò che copi su questo Mac non verrà sincronizzato. In Impostazioni di Sistema, imposta PasteFerry Daemon su Consenti.';

  @override
  String get permAskBody =>
      'Altrimenti macOS te lo chiede ogni volta. In Impostazioni di Sistema, imposta PasteFerry Daemon su Consenti.';

  @override
  String get openSystemSettings => 'Apri Impostazioni di Sistema';

  @override
  String get fetch => 'Ricevi';

  @override
  String get fetchStarted => 'Ricezione… L\'avanzamento è in Cronologia';

  @override
  String get transferFailed => 'Trasferimento non riuscito';

  @override
  String get expired => 'Scaduto';

  @override
  String get putOnClipboard => 'Copia negli appunti';

  @override
  String get putOnClipboardDone => 'Negli appunti';

  @override
  String get deleteRecord => 'Elimina questo elemento';

  @override
  String get deleted => 'Eliminato';

  @override
  String get emptyRecord => '(vuoto)';

  @override
  String get imageRecord => 'Immagine';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: 'altri $others',
      one: 'un altro',
    );
    return '$name e $_temp0';
  }

  @override
  String get searchHint => 'Cerca testo e nomi di file';

  @override
  String get searchClear => 'Cancella ricerca';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count risultati',
      one: '1 risultato',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'Nessun risultato per “$query”';
  }

  @override
  String get searchEmptyBody =>
      'La ricerca esamina il testo copiato e i nomi dei file copiati.';

  @override
  String get favoriteAction => 'Aggiungi ai preferiti';

  @override
  String get unfavoriteAction => 'Rimuovi dai preferiti';

  @override
  String get favoritedToast => 'Aggiunto ai Preferiti';

  @override
  String get unfavoritedToast => 'Riportato in Cronologia';

  @override
  String get undo => 'Annulla';

  @override
  String get favoriteSaving => 'Salvataggio…';

  @override
  String favoritedAt(String date) {
    return 'Salvato il $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '1 elemento',
    );
    return '$_temp0 · senza pulizia automatica · fino a $size';
  }

  @override
  String get favoritesEmptyTitle => 'Ancora nessun preferito';

  @override
  String get favoritesEmptyBody =>
      'Contrassegna con la stella un elemento in Cronologia per conservarne una copia qui. I preferiti non vengono mai eliminati automaticamente.';

  @override
  String get favoritesSearchHint => 'Cerca nei preferiti';

  @override
  String favoriteLargeTitle(String size) {
    return 'Salvare una copia di $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Un preferito conserva una copia propria, quindi modificare o eliminare i file originali non lo influenza. Occupa $size su $device.';
  }

  @override
  String get saveCopy => 'Salva copia';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'I tuoi $count preferiti restano.',
      one: 'Il tuo preferito resta.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Preferiti';

  @override
  String get favoritesUsageDesc =>
      'I preferiti non vengono mai eliminati, indipendentemente dalle impostazioni qui sopra';

  @override
  String upToSize(String size) {
    return 'Fino a $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caratteri',
      one: '1 carattere',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    return '… $count caratteri in totale';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'altri $count',
      one: '1 altro',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Selezionalo per scaricarlo prima';

  @override
  String detailTotalSize(String size) {
    return '$size in totale';
  }

  @override
  String get quickPaste => 'Incolla rapido';

  @override
  String get quickPasteWindow => 'Finestra Incolla rapido';

  @override
  String get quickPasteWindowDesc =>
      'Premi la scorciatoia in qualsiasi app per aprire la cronologia; scegli un elemento e viene incollato';

  @override
  String get quickPasteShortcut => 'Scorciatoia';

  @override
  String get quickPasteRecord => 'Fai clic per cambiare';

  @override
  String get quickPasteRecording => 'Premi la nuova scorciatoia…';

  @override
  String get quickPasteUseDefault => 'Usa predefinita';

  @override
  String get quickPasteNeedsModifier =>
      'Includi ⌃, ⌥, ⇧ o ⌘, oppure usa un tasto funzione';

  @override
  String get quickPasteNeedsModifierPc =>
      'Includi Ctrl, Alt, Maiusc o il tasto Windows, oppure usa un tasto funzione';

  @override
  String get quickPasteAfterPick => 'Dopo aver scelto un elemento';

  @override
  String get quickPastePasteIt => 'Incollalo';

  @override
  String get quickPasteCopyIt => 'Copialo soltanto';

  @override
  String get quickPasteIndexKey => 'Scegli uno dei primi 9';

  @override
  String get quickPasteIndexKeyDesc =>
      'Nella finestra Incolla rapido, tieni premuto questo tasto e premi 1–9';

  @override
  String get quickPasteAccessibility => 'Accessibilità';

  @override
  String get quickPasteAccessibilityDesc =>
      'Serve per incollare al posto tuo. Senza, gli elementi vengono copiati e premi tu ⌘V.';

  @override
  String get quickPasteAllowed => 'Consentito';

  @override
  String get quickPasteAllow => 'Consenti…';

  @override
  String get quickPasteNotRunning => 'La finestra Incolla rapido non è attiva';

  @override
  String quickPasteInUse(String key) {
    return '$key è usata da un\'altra app. Scegli un\'altra scorciatoia.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Impossibile impostare $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Impostala nelle scorciatoie di sistema';

  @override
  String get quickPasteWaylandDesc =>
      'Su Wayland, aggiungi la scorciatoia nelle impostazioni della tastiera del desktop. Gli elementi scelti vengono copiati; premi Ctrl+V per incollare.';

  @override
  String get quickPasteAddShortcut => 'Aggiungi scorciatoia di sistema';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Aggiunta. Premi $key per provarla.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Nelle impostazioni della tastiera del desktop, aggiungi una scorciatoia personalizzata che esegua: $command';
  }

  @override
  String get pickerSearch => 'Cerca';

  @override
  String get pickerPaste => 'Incolla';

  @override
  String get pickerPlainText => 'Testo semplice';

  @override
  String get pickerCopyOnly => 'Copia soltanto';

  @override
  String get pickerUnfavoriteHint => 'Rimuovi (torna in Cronologia)';

  @override
  String pickerPasteManually(String key) {
    return 'Gli elementi scelti vengono copiati: premi $key per incollare';
  }

  @override
  String get pickerGrantHint =>
      'Consenti Accessibilità per incollare direttamente';

  @override
  String pickerElevated(String key) {
    return 'Questa finestra è eseguita come amministratore: dopo la scelta premi $key per incollare';
  }

  @override
  String get pickerDownloading =>
      'Download in corso: verrà incollato al termine';

  @override
  String get imagePreviewTitle => 'Anteprima immagine';

  @override
  String get closePreview => 'Chiudi anteprima';

  @override
  String get previousImage => 'Immagine precedente';

  @override
  String get nextImage => 'Immagine successiva';

  @override
  String get previewHint =>
      'Scorri o pizzica per lo zoom, trascina per spostarti';

  @override
  String get fitWindow => 'Adatta alla finestra';

  @override
  String get previewDeleted =>
      'Questa immagine è stata eliminata dalla cronologia';

  @override
  String get previewExpired =>
      'Questa immagine è scaduta e non può essere visualizzata';

  @override
  String get previewDownloading => 'Download dell\'immagine…';

  @override
  String get previewDownloadFailed => 'Download non riuscito. Riprova.';

  @override
  String get previewNotDownloaded =>
      'Questa immagine non è ancora su questo computer';

  @override
  String get downloadAndPreview => 'Scarica e visualizza';

  @override
  String get previewUnavailable =>
      'Al momento non è possibile visualizzare questa immagine';

  @override
  String get imageSemantic => 'Immagine dalla cronologia';

  @override
  String get previewUnreadable =>
      'Impossibile leggere l\'immagine. Il file potrebbe essere stato eliminato o danneggiato.';

  @override
  String get devicesSubtitleEmpty =>
      'Una volta abbinati, i tuoi dispositivi condividono gli stessi appunti';

  @override
  String devicesSubtitle(int paired, int online) {
    String _temp0 = intl.Intl.pluralLogic(
      paired,
      locale: localeName,
      other: '$paired abbinati',
      one: '1 abbinato',
    );
    return '$_temp0, $online online';
  }

  @override
  String get addDevice => 'Aggiungi dispositivo';

  @override
  String thisDeviceFootnote(String both) {
    return 'Durante l\'abbinamento, $both mostrano le stesse due righe di impronte di sicurezza, una per ogni dispositivo. Conferma solo se corrispondono carattere per carattere.';
  }

  @override
  String get noDevicesTitle => 'Ancora nessun dispositivo abbinato';

  @override
  String get noDevicesBody =>
      'Apri PasteFerry sull\'altro computer e collegali con un codice di abbinamento di 6 caratteri. Sulla stessa rete puoi anche aprire Cerca nelle vicinanze su entrambi e fare clic sull\'altro.';

  @override
  String get pairedDevices => 'Dispositivi abbinati';

  @override
  String get pairedFootnote =>
      'Diretta: i dati passano direttamente tra i due dispositivi. Inoltro: quando la rete blocca il collegamento diretto, i dati passano dal tuo server e restano crittografati end-to-end.';

  @override
  String get offline => 'Offline';

  @override
  String get direct => 'Diretta';

  @override
  String get relay => 'Inoltro';

  @override
  String get online => 'Online';

  @override
  String get moreActions => 'Altro';

  @override
  String get copyFingerprint => 'Copia impronta';

  @override
  String get unpairEllipsis => 'Dissocia…';

  @override
  String get fingerprintCopied => 'Impronta copiata';

  @override
  String unpairTitle(String name) {
    return 'Dissociare “$name”?';
  }

  @override
  String get unpairBody =>
      'I due dispositivi smetteranno di sincronizzarsi. Per sincronizzarli di nuovo dovrai abbinarli e verificare di nuovo le impronte.';

  @override
  String get unpair => 'Dissocia';

  @override
  String get unpaired => 'Dissociato';

  @override
  String get enterAddressEllipsis => 'Inserisci il suo indirizzo…';

  @override
  String setAddressTitle(String name) {
    return 'Indirizzo di “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Usalo quando i due dispositivi sono su sottoreti diverse o hanno entrambi cambiato indirizzo. Inserisci l\'indirizzo mostrato su “$name” in Aggiungi dispositivo → Mostra un codice.';
  }

  @override
  String get addressSaved => 'Ricerca a quell\'indirizzo';

  @override
  String get lanBlockedTitle => 'macOS sta bloccando la rete locale';

  @override
  String lanBlockedBody(String device) {
    return 'Attiva PasteFerry Daemon in Impostazioni di Sistema → Privacy e sicurezza → Rete locale. Fino ad allora, $device non può connettersi ai dispositivi su questa rete.';
  }

  @override
  String get searchNearby => 'Cerca nelle vicinanze';

  @override
  String get nearbyTitle => 'Dispositivi vicini';

  @override
  String get nearbySearching => 'Ricerca di dispositivi vicini…';

  @override
  String get nearbyHint =>
      'Apri Cerca nelle vicinanze anche sull\'altro computer e comparirà qui. Fai clic per abbinarlo.';

  @override
  String nearbyVisible(String device) {
    return 'Finché questa finestra è aperta, i dispositivi su questa rete possono vedere il nome di $device.';
  }

  @override
  String get nearbyPaired => 'Abbinato';

  @override
  String nearbyRequesting(String name) {
    return 'Contatto con “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” non ha risposto. Verifica che Cerca nelle vicinanze sia ancora aperto.';
  }

  @override
  String get nearbyLanOffTitle => 'Il rilevamento in rete locale è disattivato';

  @override
  String get nearbyLanOffBody =>
      'Attiva “Trova dispositivi su questa rete” in Impostazioni → Connessione per vedere i dispositivi vicini, oppure abbina con un codice.';

  @override
  String get generateCode => 'Mostra un codice';

  @override
  String get enterCode => 'Inserisci un codice';

  @override
  String get codeFailedTitle => 'Impossibile creare un codice di abbinamento';

  @override
  String get enterOnOther => 'Inserisci questo codice sull\'altro dispositivo';

  @override
  String get codeCopied => 'Codice copiato';

  @override
  String get codeHint => 'Fai clic per copiare. Valido per 5 minuti.';

  @override
  String afterEnterFootnote(String both) {
    return 'Una volta inserito, $both mostrano le stesse due righe di impronte di sicurezza. Conferma solo se corrispondono.';
  }

  @override
  String get codeInvalid =>
      'Un codice di abbinamento è composto da 6 lettere o cifre';

  @override
  String get localAddress => 'Indirizzo';

  @override
  String get addressHint =>
      'Su una sottorete diversa? Inserisci questo indirizzo anche sull\'altro dispositivo.';

  @override
  String get addressCopied => 'Indirizzo copiato';

  @override
  String get differentSubnet => 'Su una sottorete diversa?';

  @override
  String get peerAddress => 'Indirizzo mostrato sotto il codice';

  @override
  String get pairNotFound =>
      'Dispositivo non trovato. Se è su una sottorete diversa, inserisci l\'indirizzo mostrato sotto il suo codice.';

  @override
  String get pairNotFoundAddress =>
      'Nessuna risposta a quell\'indirizzo. Controlla l\'indirizzo e che l\'altro dispositivo stia ancora mostrando il codice. Potrebbe bloccarlo anche un firewall su quel dispositivo.';

  @override
  String get codeWrong => 'Il codice non è corretto o è scaduto';

  @override
  String get codeExpired =>
      'Questo codice è scaduto. Mostrane uno nuovo sull\'altro dispositivo.';

  @override
  String get addressInvalid =>
      'Indirizzo non valido. Inserisci qualcosa come 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Prima attiva il rilevamento in rete locale o imposta un server in Impostazioni → Connessione.';

  @override
  String get enterCodeShown =>
      'Inserisci il codice mostrato sull\'altro dispositivo';

  @override
  String get pairingDone => 'Abbinato';

  @override
  String get pairingRejected => 'Abbinamento rifiutato';

  @override
  String get verifyTitle => 'Verifica le impronte di sicurezza';

  @override
  String pairingWith(String name) {
    return 'Abbinamento con “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'Le due righe su $both devono essere identiche. Se anche un solo carattere è diverso, qualcuno potrebbe manomettere la connessione: rifiuta.';
  }

  @override
  String get rejectMismatch => 'Diverse, rifiuta';

  @override
  String get confirmMatch => 'Corrispondono, abbina';

  @override
  String get server => 'Server (facoltativo)';

  @override
  String get signalingUrl => 'Server di segnalazione';

  @override
  String get signalingUrlDesc =>
      'Lascia vuoto per sincronizzare solo in locale';

  @override
  String get signalingUrlPlaceholder => 'ws://indirizzo-server:8787/signal';

  @override
  String get publicStun => 'Migliora le connessioni dirette';

  @override
  String get publicStunDesc =>
      'I server pubblici possono vedere il tuo IP pubblico';

  @override
  String get connectionStatus => 'Connessione';

  @override
  String get disconnectedDesc =>
      'Controlla l\'indirizzo del server e la sua disponibilità';

  @override
  String get connected => 'Connesso';

  @override
  String get notConnected => 'Non connesso';

  @override
  String get notSet => 'Non impostato';

  @override
  String get serverCleared =>
      'Server rimosso. Sincronizzazione solo su questa rete.';

  @override
  String get localNetwork => 'Rete locale';

  @override
  String get lanDiscovery => 'Trova dispositivi su questa rete';

  @override
  String get lanDiscoveryDesc =>
      'Rilevamento anonimo; i nomi sono visibili solo durante Cerca nelle vicinanze';

  @override
  String get macLocalNetwork => 'Accesso alla rete locale';

  @override
  String get macLocalNetworkDesc =>
      'Consenti PasteFerry Daemon in Impostazioni di Sistema';

  @override
  String get allowLan => 'Windows Firewall';

  @override
  String get allowLanDesc =>
      'Consente le connessioni bloccate; richiede l\'approvazione di un amministratore';

  @override
  String get allow => 'Consenti';

  @override
  String get allowLanDone =>
      'Consentito. Ora gli altri dispositivi possono raggiungere questo.';

  @override
  String get deviceName => 'Nome dispositivo';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get sync => 'Sincronizzazione';

  @override
  String get autoSyncLimit => 'Limite di sincronizzazione automatica';

  @override
  String get autoSyncLimitDesc =>
      'Gli elementi più grandi si ricevono manualmente dalla Cronologia';

  @override
  String get autoApply => 'Metti negli appunti gli elementi ricevuti';

  @override
  String get whatToSync => 'Cosa sincronizzare';

  @override
  String get syncFiles => 'File e cartelle';

  @override
  String get syncText => 'Testo semplice';

  @override
  String get syncRich => 'Testo formattato';

  @override
  String get syncImages => 'Immagini e screenshot';

  @override
  String get storage => 'Spazio';

  @override
  String get storageFootnote =>
      'La cronologia scaduta e i file in cache vengono eliminati automaticamente.';

  @override
  String get keepHistory => 'Conserva cronologia per';

  @override
  String get keepCache => 'Conserva file in cache per';

  @override
  String get keepCacheDesc => 'Non oltre la durata della cronologia';

  @override
  String get cacheUsage => 'Dimensione cache';

  @override
  String get backgroundSync => 'Sincronizzazione in background';

  @override
  String get backgroundService => 'Servizio in background';

  @override
  String get backgroundServiceDesc =>
      'Si avvia al login; sincronizza anche a finestra chiusa';

  @override
  String get restart => 'Riavvia';

  @override
  String get restarted => 'Servizio in background riavviato';

  @override
  String get disableEllipsis => 'Disattiva…';

  @override
  String get about => 'Informazioni';

  @override
  String get aboutDesc => 'Open source con licenza AGPL-3.0';

  @override
  String get homepage => 'Sito web';

  @override
  String get feedback => 'Segnala un problema';

  @override
  String get disableTitle => 'Disattivare la sincronizzazione in background?';

  @override
  String disableBody(String device) {
    return 'PasteFerry su $device smetterà di sincronizzare e non si avvierà al login. Cronologia e abbinamenti vengono conservati.';
  }

  @override
  String get disable => 'Disattiva';

  @override
  String get disabled => 'La sincronizzazione in background è disattivata';

  @override
  String get urlMustBeWs => 'L\'indirizzo deve iniziare con ws:// o wss://';

  @override
  String get serverUpdated => 'Server aggiornato. Riconnessione…';

  @override
  String get deviceNameUpdated => 'Nome dispositivo aggiornato';

  @override
  String get diagIntro =>
      'Questo rapporto contiene la versione dell\'app, il sistema, le impostazioni, i dispositivi e i log recenti. Nomi dei dispositivi, indirizzo del server, indirizzi IP pubblici, cartella utente e nomi dei file vengono sostituiti, e ciò che copi non viene mai scritto nei log. Le segnalazioni su GitHub sono pubbliche: rileggilo prima di pubblicarlo.';

  @override
  String get diagVerboseTitle => 'Log dettagliati';

  @override
  String get diagVerboseDesc =>
      'Per i problemi di connessione: attivali, riproduci il problema, poi torna qui per il rapporto. Si disattivano da soli dopo 30 minuti.';

  @override
  String get diagVerboseOn => 'Attiva per 30 minuti';

  @override
  String diagVerboseUntil(String time) {
    return 'Attivi fino alle $time';
  }

  @override
  String get diagVerboseOff => 'Disattiva';

  @override
  String get diagRefresh => 'Rigenera';

  @override
  String get diagSave => 'Salva come file';

  @override
  String diagSaved(String name) {
    return 'Salvato nella cartella Download: $name';
  }

  @override
  String get diagCopy => 'Copia rapporto';

  @override
  String get diagCopied => 'Rapporto copiato';

  @override
  String get diagNewIssue => 'Nuova segnalazione su GitHub';

  @override
  String get diagIssueHint =>
      'Rapporto copiato. Incollalo nel campo “Diagnostics report” della segnalazione.';

  @override
  String diagFailed(String detail) {
    return 'Impossibile creare il rapporto: $detail';
  }

  @override
  String get svcExtractTitle => 'Prima installa o estrai PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry è in esecuzione direttamente dallo zip e la sua cartella temporanea sparisce quando lo chiudi. Esegui il programma di installazione, oppure estrai l\'intera cartella e aprilo da lì, per attivare la sincronizzazione in background.';

  @override
  String get svcMoveTitle => 'Prima sposta PasteFerry in Applicazioni';

  @override
  String get svcMoveBody =>
      'PasteFerry è in esecuzione direttamente dall\'immagine disco. Trascinalo in Applicazioni, espelli l\'immagine disco e aprilo da Applicazioni per attivare la sincronizzazione in background.';

  @override
  String get svcStartTitle => 'Inizia a usare PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry esegue un piccolo processo in background per sincronizzare gli appunti. Chiudendo la finestra resta attivo. L\'avvio al login è un\'impostazione separata ed è disattivato nelle nuove installazioni.';

  @override
  String get svcEnable => 'Attiva sincronizzazione in background';

  @override
  String get svcStaleTitle => 'Riattiva la sincronizzazione in background';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry è stato spostato, ma l\'avvio al login punta ancora alla vecchia posizione. Riattivala perché il processo in background usi questa copia. Cronologia e abbinamenti vengono conservati.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry è stato spostato o installato con un vecchio script. Riattivala perché il processo in background usi questa app. Cronologia e abbinamenti vengono conservati.';

  @override
  String get svcReenable => 'Riattiva';

  @override
  String get svcStoppedTitle => 'Il servizio in background non è attivo';

  @override
  String get svcStoppedBody =>
      'Il servizio in background è fermo. Avvialo con il pulsante qui sotto; l\'avvio al login si imposta separatamente in Impostazioni.';

  @override
  String get svcDevBodyWin =>
      'Questa è una build di sviluppo senza pasteferryd.exe accanto. Esegui scripts\\build-windows.ps1 nella cartella dei sorgenti per creare una versione completa.';

  @override
  String get svcDevBodyLinux =>
      'Questa è una build di sviluppo senza pasteferryd accanto. Esegui ./scripts/package-linux.sh nella cartella dei sorgenti per creare una versione completa.';

  @override
  String get svcDevBodyMac =>
      'Questa è una build di sviluppo senza il servizio in background. Esegui ./scripts/install-macos.sh nella cartella dei sorgenti per installarlo.';

  @override
  String svcLogPath(String path) {
    return 'Log: $path';
  }

  @override
  String get svcCanDisable =>
      'Puoi disattivare la sincronizzazione in background in qualsiasi momento in Impostazioni.';

  @override
  String get officialService => 'Servizio';

  @override
  String get useOfficialService => 'Usa il servizio';

  @override
  String get officialServiceDesc =>
      'Sincronizza tra reti diverse, preferendo le connessioni dirette';

  @override
  String get officialPrivacy =>
      'Si connette al servizio solo se attivato e registra le informazioni di connessione essenziali. Prima si tentano le connessioni dirette; l\'inoltro viene richiesto solo se falliscono. Contenuti, nomi reali dei dispositivi e identificatori di sistema non vengono caricati.';

  @override
  String get officialEnableTitle => 'Attivare il servizio?';

  @override
  String get officialSwitchConfirm =>
      'Smetterai di usare il tuo server personalizzato. Il suo indirizzo salvato verrà conservato.';

  @override
  String get customServer => 'Server personalizzato';

  @override
  String get saveAndConnect => 'Salva e connetti';

  @override
  String get officialLoading => 'Verifica della quota…';

  @override
  String get officialFetchFailed =>
      'Impossibile ottenere la quota al momento. Verrà ritentato automaticamente.';

  @override
  String get officialUnavailable =>
      'Utilizzo non disponibile; i dati esistenti potrebbero non essere aggiornati';

  @override
  String get officialQuotaTitle => 'Quota giornaliera di inoltro esaurita';

  @override
  String get officialQuotaBody =>
      'L\'inoltro del servizio è sospeso fino al ripristino giornaliero a mezzanotte, ora di Pechino. Le connessioni in rete locale e quelle dirette via Internet restano disponibili. I trasferimenti non riusciti si possono ritentare più tardi.';

  @override
  String get officialPeerQuota =>
      'L\'altro dispositivo ha esaurito la quota di inoltro. Le connessioni dirette restano disponibili.';

  @override
  String get officialPaused =>
      'L\'inoltro del servizio non è disponibile. Le connessioni dirette restano disponibili.';

  @override
  String get officialViewUsage => 'Vedi utilizzo';

  @override
  String get officialAcknowledge => 'OK';

  @override
  String get officialToday => 'Quota di inoltro di oggi';

  @override
  String get officialUsed => 'Usata';

  @override
  String get officialRemaining => 'Rimanente';

  @override
  String get officialDailyLimit => 'Quota giornaliera';

  @override
  String get officialUpload => 'Upload';

  @override
  String get officialDownload => 'Download';

  @override
  String get officialReset => 'Ripristino (ora di Pechino)';

  @override
  String get officialUpdated => 'Ultimo aggiornamento';

  @override
  String get officialRoutes => 'Come si connettono i dispositivi';

  @override
  String get officialRoutesFootnote =>
      'Le connessioni dirette non passano dall\'inoltro del servizio e non consumano la quota.';

  @override
  String get officialDeviceID => 'ID dispositivo';

  @override
  String get officialWarning =>
      'È stato usato il 90% della quota giornaliera di inoltro. Le connessioni dirette non la consumano.';

  @override
  String get updateCheck => 'Controlla aggiornamenti';

  @override
  String get updateCheckEllipsis => 'Controlla aggiornamenti…';

  @override
  String get updateAuto => 'Controlla aggiornamenti automaticamente';

  @override
  String get updateChecking => 'Controllo degli aggiornamenti…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version è la versione più recente.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'È disponibile PasteFerry $version';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Hai la versione $current. Dimensioni del download: $size.';
  }

  @override
  String get updateNew => 'Novità';

  @override
  String get updateFixed => 'Correzioni';

  @override
  String get updateSkip => 'Salta questa versione';

  @override
  String get updateLater => 'Più tardi';

  @override
  String get updateInstall => 'Scarica e installa';

  @override
  String updateDownloading(String done, String total) {
    return 'Download: $done di $total';
  }

  @override
  String get updateVerifying => 'Verifica del download…';

  @override
  String get updateInstalling =>
      'Installazione in corso. PasteFerry si riaprirà da solo.';

  @override
  String get updateInstallingPassword =>
      'Installazione in corso. Il sistema ti chiederà la password, perché /opt richiede i diritti di amministratore; poi PasteFerry si riaprirà da solo.';

  @override
  String get updateCheckFailed =>
      'Impossibile raggiungere GitHub o Gitee. Riprova più tardi.';

  @override
  String get updateDownloadFailed =>
      'Il download non è stato completato. Riprova o scarica la nuova versione dal sito web.';

  @override
  String updateInstallFailed(String error) {
    return 'Impossibile avviare l\'installazione: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Questa build non può controllare gli aggiornamenti.';

  @override
  String get updateBlockedDev =>
      'Questa è una build di sviluppo, quindi non può aggiornarsi da sola.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry è in esecuzione dall\'immagine disco. Trascinalo in Applicazioni e aprilo da lì per gli aggiornamenti automatici.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry non può scrivere nella cartella in cui è installato. Scarica invece la nuova versione dal sito web.';

  @override
  String get updateBlockedUnsupported =>
      'Non c\'è un aggiornamento automatico per questo computer. Scarica la nuova versione dal sito web.';

  @override
  String get updateOpenDownload => 'Apri pagina di download';

  @override
  String updateSidebar(String version) {
    return 'È disponibile la versione $version';
  }

  @override
  String updatedTo(String version) {
    return 'Aggiornato alla versione $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'L\'aggiornamento non è stato completato. Hai ancora la versione $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'L\'aggiornamento non è stato completato. Hai ancora la versione $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'UI $uiVersion · Servizio $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Non ricevuto: ricevilo prima di incollare';

  @override
  String get receivedPreserved =>
      'Ricevuto; usa Copia negli appunti quando vuoi';

  @override
  String get clipboardWriteFailed =>
      'Ricevuto, ma non è stato possibile aggiornare gli appunti';

  @override
  String get receivingStatus => 'Ricezione…';

  @override
  String get largeFileNotifications => 'Promemoria file grandi';

  @override
  String get notificationsAllowed =>
      'Le notifiche sono attive. L\'avanzamento è in Cronologia.';

  @override
  String get notificationsNotRequested =>
      'Attiva le notifiche perché i file grandi non restino in attesa senza avviso. Puoi sempre riceverli dalla Cronologia.';

  @override
  String get notificationsDenied =>
      'Le notifiche sono bloccate nelle impostazioni di sistema. Ricevi gli elementi in attesa dalla Cronologia.';

  @override
  String get notificationsUnknown =>
      'Il desktop gestisce la consegna delle notifiche e la modalità Non disturbare. Se non compare alcun promemoria, ricevi gli elementi dalla Cronologia.';

  @override
  String get notificationsUnavailable =>
      'Le notifiche di sistema non sono disponibili. Ricevi i file grandi dalla Cronologia.';

  @override
  String get enableNotifications => 'Attiva promemoria';

  @override
  String get notificationSettings => 'Impostazioni notifiche';

  @override
  String get notifyPendingTitle => 'Ricevi per incollare';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nRicevi questo elemento prima di incollarlo. Puoi riceverlo anche dalla Cronologia.';
  }

  @override
  String get notifyReceivingTitle => 'Ricezione…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nL\'avanzamento è in Cronologia.';
  }

  @override
  String get notifyReadyTitle => 'Pronto da incollare';

  @override
  String notifyReadyBody(String name) {
    return '$name\nRicevuto e messo negli appunti.';
  }

  @override
  String get notifyReceivedTitle => 'Ricevuto';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nI tuoi appunti sono stati mantenuti. Usa Copia negli appunti quando vuoi; puoi farlo anche dalla Cronologia.';
  }

  @override
  String get notifyFailedTitle => 'Ricezione non riuscita';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nRiprova da questa notifica o dalla Cronologia.';
  }

  @override
  String get notifyClipboardFailedTitle => 'Ricevuto; appunti non aggiornati';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUsa Copia negli appunti per riprovare, qui o in Cronologia.';
  }

  @override
  String get reconnect => 'Riconnetti';

  @override
  String get reconnecting => 'Connessione…';

  @override
  String get reconnectDirect => 'Connesso direttamente';

  @override
  String get reconnectRelay =>
      'Connessione diretta non riuscita, si continua con l\'inoltro';

  @override
  String reconnectOffline(String name) {
    return '“$name” è offline. Verifica che PasteFerry sia aperto su quel dispositivo.';
  }

  @override
  String get reconnectPending =>
      'Connessione ancora in corso, ricontrolla tra poco';

  @override
  String get renameAction => 'Rinomina';

  @override
  String get renameFavoriteTitle => 'Rinomina preferito';

  @override
  String get renameFavoriteHint =>
      'Viene mostrato in Preferiti e in Incolla rapido, e puoi cercarlo. Lascialo vuoto per mostrare di nuovo il contenuto.';

  @override
  String get renamedToast => 'Rinominato';

  @override
  String get aliasClearedToast => 'Viene mostrato di nuovo il contenuto';

  @override
  String get navSend => 'Invia file';

  @override
  String get sendSubtitle =>
      'Trascina i file su un dispositivo per inviarli direttamente';

  @override
  String get sendNoDevicesTitle => 'Ancora nessun dispositivo abbinato';

  @override
  String get sendNoDevicesBody =>
      'Prima abbina un altro computer, poi potrai inviargli file da qui.';

  @override
  String get sendDropHint => 'Rilascia su un dispositivo per inviare';

  @override
  String sendReleaseTo(String name) {
    return 'Rilascia per inviare a $name';
  }

  @override
  String get sendLan => 'Rete locale';

  @override
  String sendRelayLeft(String left) {
    return 'Inoltro · $left rimanenti oggi';
  }

  @override
  String get sendNeedsUpdate => 'Aggiornamento necessario';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name potrà ricevere file dopo l\'aggiornamento a PasteFerry 2.5 o versioni successive.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Connessione a $name. Potrai inviare appena sarà connesso.';
  }

  @override
  String get sendNotReceiving => 'Non riceve file';

  @override
  String get sendDelivered => 'Consegnato';

  @override
  String sendToTitle(String name) {
    return 'Invia a $name';
  }

  @override
  String get sendDropHere => 'Trascina qui file o cartelle';

  @override
  String get sendDropStarts => 'L\'invio inizia appena li rilasci';

  @override
  String get sendChooseFiles => 'Scegli file…';

  @override
  String get sendChooseFolder => 'Scegli cartella…';

  @override
  String get sendDropMore => 'Rilascia altri file per inviarli dopo';

  @override
  String sendSavedWhere(String name) {
    return 'I file vengono salvati dove sceglie $name: per impostazione predefinita, la cartella Download.';
  }

  @override
  String get sendCloseKeeps =>
      'Chiudere questa finestra non interrompe l\'invio';

  @override
  String get sendRemoveQueued => 'Rimuovi';

  @override
  String get sendCannotDrop =>
      'Questo elemento non si può inviare trascinandolo. Salvalo prima come file, oppure usa Scegli file….';

  @override
  String sendErrOffline(String name) {
    return '$name è offline.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name non riceve file.';
  }

  @override
  String get sendErrMissing => 'Alcuni di questi file non esistono più.';

  @override
  String get relayConfirmTitle => 'Inviare tramite l\'inoltro del servizio?';

  @override
  String relayConfirmBody(String name, String left) {
    return 'Al momento $name non ha una connessione diretta con questo computer, quindi i file passano dall\'inoltro del servizio a circa 0,25 MB/s. Della quota di inoltro di oggi restano $left.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Questi file ($size) superano la quota rimanente. L\'invio si ferma quando la quota finisce e riprende quando i due computer si connettono direttamente o domani, al ripristino della quota.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Userà circa $size della quota di oggi.';
  }

  @override
  String get relayExhausted =>
      'La quota di inoltro di oggi è esaurita. Si ripristina a mezzanotte, ora di Pechino. Due computer connessi direttamente non hanno limiti.';

  @override
  String get relayDontAskToday =>
      'Non chiedere più oggi per questo dispositivo';

  @override
  String get relaySendAnyway => 'Invia comunque';

  @override
  String get relayOwnServer => 'Inoltro: la velocità dipende dal tuo server';

  @override
  String get transfersReceived => 'Ricevuti';

  @override
  String get transfersSent => 'Inviati';

  @override
  String get transfersClearAll => 'Cancella tutto';

  @override
  String get transfersClearTitle => 'Cancellare questo elenco?';

  @override
  String get transfersClearBody =>
      'Viene cancellato solo l\'elenco. I file restano dove sono.';

  @override
  String get transfersEmptyReceived =>
      'Qui compaiono i file che ti inviano gli altri dispositivi';

  @override
  String get transfersEmptySent => 'Qui compaiono i file che invii';

  @override
  String transferFrom(String name) {
    return 'Da $name';
  }

  @override
  String transferTo(String name) {
    return 'A $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: 'altri $others',
      one: 'un altro',
    );
    return '$name e $_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'In coda';

  @override
  String transferScanning(String count) {
    return 'Conteggio… $count file trovati';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'In attesa di $name…';
  }

  @override
  String get transferSending => 'Invio in corso';

  @override
  String get transferReceiving => 'Ricezione in corso';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'In corso: $file ($index di $total)';
  }

  @override
  String transferLeft(String time) {
    return '$time rimanenti';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n secondi',
      one: '1 secondo',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String etaHours(int h, int m) {
    return '$h h $m min';
  }

  @override
  String get transferPaused =>
      'In pausa: la quota di inoltro di oggi è esaurita';

  @override
  String get transferInterrupted => 'Interrotto: riprende alla riconnessione';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Interrotto: in attesa che $name riprenda';
  }

  @override
  String get transferCancelled => 'Annullato';

  @override
  String transferPeerCancelled(String name) {
    return 'Annullato da $name';
  }

  @override
  String get transferExpired => 'Scaduto';

  @override
  String get transferMissing => 'Spostato o eliminato';

  @override
  String transferNotSent(String reason) {
    return 'Non inviato: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Non ricevuto: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name non ha abbastanza spazio su disco (mancano $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'spazio su disco insufficiente (mancano $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'la posizione di salvataggio di $name non è disponibile';
  }

  @override
  String get reasonDestUnavailable =>
      'la posizione di salvataggio non è disponibile: controllala in Impostazioni';

  @override
  String get reasonFileTooLarge =>
      'la posizione di salvataggio è su un\'unità FAT32, che non può contenere file oltre 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name non riceve file';
  }

  @override
  String get reasonSourceChanged =>
      'un file è stato modificato durante l\'invio';

  @override
  String get reasonSourceMissing => 'un file non esiste più';

  @override
  String get reasonReadError => 'impossibile leggere un file';

  @override
  String get reasonWriteFailed => 'impossibile scrivere i file';

  @override
  String get reasonHashMismatch =>
      'un file si è danneggiato durante il trasferimento';

  @override
  String reasonUnsupported(String name) {
    return '$name deve aggiornarsi per ricevere file';
  }

  @override
  String get reasonOther => 'si è verificato un problema';

  @override
  String get revealInFinder => 'Mostra nel Finder';

  @override
  String get revealInFolder => 'Mostra nella cartella';

  @override
  String get revealOpenFolder => 'Apri cartella';

  @override
  String get transferResend => 'Invia di nuovo';

  @override
  String get transferRemove => 'Rimuovi dall\'elenco';

  @override
  String get transferCopyPath => 'Copia percorso';

  @override
  String get transferPathCopied => 'Percorso copiato';

  @override
  String sendingTo(String name, String percent) {
    return 'Invio a $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Ricezione da $name · $percent';
  }

  @override
  String get receiveFiles => 'Ricevi file da altri dispositivi';

  @override
  String get saveTo => 'Salva in';

  @override
  String get saveToChange => 'Cambia…';

  @override
  String get saveToDefault => 'Download (predefinita)';

  @override
  String get saveToUseDefault => 'Usa Download';

  @override
  String get receiveNotify => 'Notifica quando arrivano file';

  @override
  String receiveFootnote(String device) {
    return 'Solo i dispositivi abbinati possono inviare file a $device. Durante il trasferimento dei file, $device non andrà in stop da solo.';
  }

  @override
  String get saveDirNotFound => 'Questa cartella non esiste.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry non può salvare file in questa cartella.';

  @override
  String get saveDirPermission =>
      'PasteFerry non ha il permesso di usare questa cartella. Consentilo in Impostazioni di Sistema → Privacy e sicurezza → File e cartelle.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count nomi di file contenevano caratteri non ammessi da Windows; sono stati sostituiti con caratteri a larghezza piena simili',
      one:
          '1 nome di file conteneva caratteri non ammessi da Windows; sono stati sostituiti con caratteri a larghezza piena simili',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Stessa rete';

  @override
  String get sendRingOther => 'Altre reti';

  @override
  String sendOfflineList(String names) {
    return 'Offline: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Elenco trasferimenti';

  @override
  String get sendLayoutSide => 'Accanto al radar';

  @override
  String get sendLayoutBelow => 'Sotto il radar';

  @override
  String get general => 'Generali';

  @override
  String get launchAtLogin => 'Apri al login';

  @override
  String get launchAtLoginDesc =>
      'Si avvia in background quando accedi. Cambiare questa opzione non interrompe la sessione in corso.';

  @override
  String get realtimeSync => 'Sincronizzazione appunti in tempo reale';

  @override
  String get realtimeSyncDesc =>
      'Condivide automaticamente le nuove copie con i dispositivi abbinati. Se disattivata, restano disponibili la cronologia locale e Invia file.';

  @override
  String get syncBacklog => 'Recupera dopo la riconnessione';

  @override
  String get syncBacklogDesc =>
      'Disattivata per impostazione predefinita: le copie perse vengono saltate. Se attivata, fino a 20 copie delle ultime 24 ore entrano nella cronologia senza sostituire gli appunti.';

  @override
  String get peerRealtimeSync => 'Sincronizza con questo computer';

  @override
  String get syncPaused => 'Sincronizzazione appunti in pausa';

  @override
  String get quitApp => 'Esci da PasteFerry';

  @override
  String get quitAppDesc =>
      'Termina tutti i processi di PasteFerry. La preferenza di apertura al login viene mantenuta.';

  @override
  String get quitTransfersWarning =>
      'Alcuni file sono ancora in trasferimento. Uscire e interrompere questi trasferimenti?';

  @override
  String get backgroundRunningTitle => 'PasteFerry resterà attivo';

  @override
  String get backgroundRunningBody =>
      'Chiudendo la finestra, la sincronizzazione e Incolla rapido restano attivi. Per fermare tutto, scegli Esci da PasteFerry in Impostazioni o nel menu dell\'app.';

  @override
  String get displayAs => 'Mostrato come';

  @override
  String get editName => 'Cambia nome';

  @override
  String get nameHint => 'Il nome che vedono i tuoi contatti';

  @override
  String get nameDefaultHint =>
      'Lascia vuoto per usare il nome del tuo account.';

  @override
  String get avatarTitle => 'Immagine del profilo';

  @override
  String get avatarChoose => 'Scegli immagine…';

  @override
  String get avatarPaste => 'Incolla immagine';

  @override
  String get avatarReset => 'Usa immagine predefinita';

  @override
  String get avatarZoom => 'Zoom';

  @override
  String get avatarDragHint => 'Trascina per spostare l\'immagine.';

  @override
  String get avatarNoImage => 'Negli appunti non c\'è nessuna immagine.';

  @override
  String get avatarBad =>
      'Questa immagine non si può usare. Scegli un PNG, JPEG o GIF.';

  @override
  String get done => 'Fine';

  @override
  String get friendsTitle => 'Contatti';

  @override
  String get addFriend => 'Aggiungi contatto';

  @override
  String get friendsEmpty => 'Ancora nessun contatto';

  @override
  String get friendsEmptyBody =>
      'Aggiungi qualcuno che usa PasteFerry per scambiarvi file senza abbinamento. I contatti possono solo inviare file; non vedono mai i tuoi appunti.';

  @override
  String get friendSendAction => 'Invia…';

  @override
  String get friendHistory => 'Trasferimenti';

  @override
  String friendHistoryTitle(String name) {
    return 'Trasferimenti con $name';
  }

  @override
  String get friendHistoryEmpty => 'Ancora nessun trasferimento.';

  @override
  String get friendAutoAccept => 'Accetta file automaticamente';

  @override
  String get friendRemove => 'Rimuovi contatto';

  @override
  String friendRemoveTitle(String name) {
    return 'Rimuovere $name?';
  }

  @override
  String get friendRemoveBody =>
      'Verrete rimossi dai contatti l\'uno dell\'altro e non potrete più scambiarvi file. I trasferimenti passati restano su questo computer.';

  @override
  String friendLastActivity(String time) {
    return 'Ultimo trasferimento: $time';
  }

  @override
  String get friendNoActivity => 'Ancora nessun trasferimento';

  @override
  String get friendCodeShare =>
      'Invia questo codice al tuo contatto. Quando lo inserirà in PasteFerry, sarete aggiunti ai contatti l\'uno dell\'altro.';

  @override
  String friendCodeExpires(String time) {
    return 'Scade tra $time';
  }

  @override
  String get friendCodeOr => 'oppure';

  @override
  String get friendCodeEnter => 'Inserisci il suo codice contatto';

  @override
  String get friendCodeAdd => 'Aggiungi';

  @override
  String get friendCodeWaiting => 'In attesa che lo inserisca…';

  @override
  String friendConfirmBody(String name) {
    return 'Aggiungere $name ai contatti?';
  }

  @override
  String get friendSafetyCode =>
      'Verifica il codice di sicurezza (facoltativo)';

  @override
  String get friendSafetyHint =>
      'Quando siete insieme, confrontate queste due righe. Se corrispondono su entrambi i computer, nessuno si è intromesso.';

  @override
  String get friendWaitingPeer => 'In attesa che ti aggiunga…';

  @override
  String friendAdded(String name) {
    return '$name è stato aggiunto ai contatti';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name ha annullato';
  }

  @override
  String get friendErrFriendCode =>
      'Questo è un codice contatto. Inseriscilo in Aggiungi contatto nella pagina Invia file.';

  @override
  String get friendErrDeviceCode =>
      'Questo è un codice di abbinamento. Inseriscilo in Dispositivi → Aggiungi dispositivo.';

  @override
  String get friendErrOutdated =>
      'Serve PasteFerry 2.6.0 o versioni successive sul suo computer.';

  @override
  String get friendErrAlreadyPaired =>
      'Quel computer è già uno dei tuoi dispositivi.';

  @override
  String get friendErrNoChannel =>
      'Non siete sulla stessa rete. Attivate Servizio su entrambi i computer per aggiungervi.';

  @override
  String get openService => 'Attiva Servizio…';

  @override
  String get noteLabel => 'Nota (facoltativa)';

  @override
  String get noteHintEmpty => 'Prima scegli i file';

  @override
  String get noteHint => 'Ad esempio: firma la pagina 3';

  @override
  String noteLine(String note) {
    return 'Nota: $note';
  }

  @override
  String get sendAction => 'Invia';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count elementi · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Rilascia qui file o immagini, oppure incolla ($key)';
  }

  @override
  String get sendDropMorePaste => 'Rilascia o incolla altro';

  @override
  String get sendPasteNothing =>
      'Niente da incollare. Prima copia dei file o un\'immagine.';

  @override
  String get sendRemoveItem => 'Rimuovi';

  @override
  String sendFriendSaved(String name) {
    return '$name accetta ogni gruppo di file prima dell\'invio.';
  }

  @override
  String transferAskingOut(String name) {
    return 'In attesa che $name accetti…';
  }

  @override
  String get transferAskingIn => 'In attesa che tu accetti';

  @override
  String reasonDeclined(String name) {
    return '$name ha rifiutato';
  }

  @override
  String reasonTimeout(String name) {
    return '$name non ha risposto';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name non accetta file';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name al momento non accetta i tuoi file';
  }

  @override
  String get reasonYouDeclined => 'Rifiutato';

  @override
  String get reasonYouIgnored => 'Ignorato';

  @override
  String get sendAgain => 'Invia di nuovo';

  @override
  String incomingTitle(String name) {
    return '$name vuole inviarti dei file';
  }

  @override
  String get incomingAlways => 'Accetta sempre i file da questo contatto';

  @override
  String get incomingDecline => 'Rifiuta';

  @override
  String get incomingAccept => 'Accetta';

  @override
  String incomingCountdown(String seconds) {
    return 'Rifiuto automatico tra $seconds s';
  }

  @override
  String get incomingStranger => 'Nelle vicinanze';

  @override
  String get friendsStrip => 'Contatti';

  @override
  String get strangersStrip => 'Nelle vicinanze con Tutti attivo';

  @override
  String get strangerNearby => 'Nelle vicinanze';

  @override
  String get friendNeedService => 'Attiva Servizio';

  @override
  String get friendCantReach => 'Impossibile connettersi';

  @override
  String reachSelfNoService(String name) {
    return 'Tu e $name non siete sulla stessa rete. Attiva Servizio per inviare file; se la connessione diretta non è possibile, passano dall\'inoltro del Servizio.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name non ha attivato Servizio, quindi puoi inviare file solo sulla stessa rete. Chiedigli di attivare Servizio in PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Non usate lo stesso server. Per inviare file, attivate Servizio su entrambi i computer o usate lo stesso server.';

  @override
  String get receiveFromLabel => 'Chi può inviarmi file:';

  @override
  String get receiveFromOff => 'Nessuno';

  @override
  String get receiveFromFriends => 'Solo contatti';

  @override
  String get receiveFromEveryone => 'Tutti';

  @override
  String everyoneLeft(String minutes) {
    return 'Tutti · $minutes min rimanenti';
  }

  @override
  String get receiveFromOffDesc =>
      'Solo i tuoi computer abbinati possono inviarti file.';

  @override
  String get receiveFromFriendsDesc =>
      'I tuoi contatti possono inviarti file. Accetti tu ogni gruppo.';

  @override
  String get receiveFromEveryoneDesc =>
      'Chiunque sulla stessa rete può inviarti file per 10 minuti. Accetti tu ogni gruppo.';

  @override
  String get everyoneEnded => 'Tutti è disattivato; si torna a Solo contatti.';

  @override
  String get friendsCountTooltip => 'Contatti';

  @override
  String get waitingAccept => 'In attesa…';

  @override
  String get settingsConnection => 'Connessione';

  @override
  String get settingsGeneralSummary =>
      'Apertura al login, nome dispositivo, lingua';

  @override
  String get settingsConnectionSummary =>
      'Servizio, server personale, rete locale';

  @override
  String get settingsSyncSummary =>
      'Sincronizzazione in tempo reale, limite di dimensione, cosa sincronizzare';

  @override
  String get settingsQuickPasteSummary =>
      'Scorciatoia e cosa succede dopo la scelta';

  @override
  String get settingsSendSummary => 'Ricezione file, posizione di salvataggio';

  @override
  String get settingsStorageSummary =>
      'Durata della cronologia, spazio occupato';

  @override
  String get settingsAboutSummary => 'Versione, aggiornamenti, feedback';

  @override
  String get friendsSubtitle =>
      'Invia file ai computer di altre persone, senza abbinamento';

  @override
  String get friendsSearch => 'Cerca contatti';

  @override
  String get friendsNoMatch => 'Nessun contatto corrispondente';

  @override
  String get friendsPick =>
      'Scegli un contatto per vedere i trasferimenti o inviare file';

  @override
  String friendDropHint(String name) {
    return 'Rilascia qui i file per inviarli a $name';
  }

  @override
  String get webShareTitle => 'Trasferimento web dal telefono';

  @override
  String get webShareFootnote =>
      'Scansiona un codice QR con il telefono per scambiare testo, foto e file con questo computer dal browser, senza app. Telefono e computer devono essere sulla stessa rete.';

  @override
  String get webShareSwitch =>
      'Consenti ai telefoni di connettersi dal browser';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Attivo, $count telefoni',
      one: 'Attivo, 1 telefono',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'Disattivato';

  @override
  String get webShareShowQr => 'Mostra codice QR';

  @override
  String get webShareDialogTitle => 'Scansiona con il telefono';

  @override
  String get webShareDialogBody =>
      'Scansiona con la fotocamera o il browser del telefono e apri il link nel browser. Ogni codice QR registra un telefono e viene sostituito dopo l\'uso.';

  @override
  String get webShareAddress => 'Indirizzo';

  @override
  String get webShareSecurity =>
      'I contenuti sono crittografati nella pagina, quindi gli altri sulla rete non possono leggerli. Però la pagina stessa è in http e non può fermare chi la manomette di proposito. Usala a casa o su una rete d\'ufficio affidabile, non su un Wi‑Fi pubblico.';

  @override
  String get webSharePhones => 'Telefoni registrati';

  @override
  String get webShareNoPhones => 'Ancora nessun telefono';

  @override
  String webShareLastUsed(String time) {
    return 'Ultimo utilizzo: $time';
  }

  @override
  String get webShareRemove => 'Rimuovi';

  @override
  String webShareRemoved(String name) {
    return '“$name” rimosso';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name” registrato';
  }

  @override
  String webShareNotListening(String error) {
    return 'Impossibile avviare l\'ascolto: $error';
  }

  @override
  String get webSharePortFallback =>
      'La porta abituale è occupata, quindi ne viene usata una temporanea. Gli indirizzi salvati non si apriranno finché i telefoni non scansionano di nuovo.';

  @override
  String get webShareNoAddress =>
      'Nessun indirizzo di rete locale. Prima connettiti a una rete Wi‑Fi o cablata.';

  @override
  String get webShareCantOpen =>
      'Se la pagina non si apre sul telefono, verifica che entrambi siano sulla stessa rete (di solito le reti ospiti non funzionano). Su Windows, PasteFerry deve anche essere consentito nel firewall.';

  @override
  String get mTabRecords => 'Cronologia';

  @override
  String get mTabSend => 'Invia';

  @override
  String get mThisPhone => 'Questo telefono';

  @override
  String get mThisPhoneInText => 'questo telefono';

  @override
  String mThisPhoneName(String name) {
    return 'Questo telefono: $name';
  }

  @override
  String get mSendTitle => 'Invia al computer';

  @override
  String get mSendHint => 'Scrivi o incolla del testo';

  @override
  String get mPaste => 'Incolla';

  @override
  String get mPhotosFiles => 'Foto o file';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Inviare $n file?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n file inviati al computer',
      one: '1 file inviato al computer',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Negli appunti non c\'è testo';

  @override
  String get mSendAction => 'Invia';

  @override
  String mSendTo(String names) {
    return 'Verrà inviato a $names';
  }

  @override
  String get mNoOnlineDevices => 'Nessun dispositivo online nelle vicinanze';

  @override
  String get mNoPairedDevices => 'Prima abbina un computer';

  @override
  String get mSent => 'Inviato';

  @override
  String get mSendFootnote =>
      'Testo e file finiscono nella cronologia del computer e, in base alle sue impostazioni, nei suoi appunti. Ciò che copi sul telefono non viene inviato da solo.';

  @override
  String get mSentRecords => 'Inviati';

  @override
  String get mSentRetention => 'Conserva elementi inviati';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Inviati mostra ciò che questo telefono ha inviato negli ultimi $d giorni';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d giorni';
  }

  @override
  String get mViewAll => 'Vedi tutto';

  @override
  String get mClearCache => 'Cancella';

  @override
  String get mCheckUpdate => 'Controlla aggiornamenti';

  @override
  String get mUpdateFailed => 'Impossibile controllare gli aggiornamenti';

  @override
  String get mUpToDate => 'Hai la versione più recente';

  @override
  String mNewVersion(Object v) {
    return 'È disponibile la versione $v';
  }

  @override
  String get mDownloadInstall => 'Scarica la nuova versione';

  @override
  String mSendFailed(String detail) {
    return 'Invio non riuscito: $detail';
  }

  @override
  String get mCopy => 'Copia';

  @override
  String get mCopied => 'Copiato negli appunti del telefono';

  @override
  String get mShare => 'Condividi';

  @override
  String get mSaved => 'Salvato in Foto o in Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Non è stato possibile: $detail';
  }

  @override
  String get mDownloading => 'Download…';

  @override
  String get mNotDownloaded => 'Non ancora scaricato';

  @override
  String get mDownloadHint =>
      'Viene scaricato prima, quando tocchi Copia, Salva o Condividi.';

  @override
  String get mFullTextLoading => 'Caricamento…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Sono mostrati i primi $shown caratteri su $total. Copia prende tutto il testo.';
  }

  @override
  String get mNotOnLanTitle => 'Non connesso al Wi‑Fi';

  @override
  String get mNotOnLanBody =>
      'Per ora PasteFerry sincronizza solo sulla rete locale. Connettiti allo stesso Wi‑Fi del computer.';

  @override
  String mStartFailed(String detail) {
    return 'Impossibile avviare PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'Sul computer apri PasteFerry → Dispositivi → Aggiungi dispositivo, poi inserisci qui il codice mostrato. Sullo stesso Wi‑Fi puoi anche aprire “Cerca nelle vicinanze” su entrambi.';

  @override
  String get mSectionSync => 'Sincronizzazione';

  @override
  String get mSectionBackground => 'Background';

  @override
  String get mAutoApplyDesc =>
      'Il testo copiato sul computer va direttamente negli appunti del telefono. Immagini e file attendono finché non tocchi Copia.';

  @override
  String get mKeepAlive => 'Resta connesso in background';

  @override
  String get mKeepAliveDesc =>
      'Ricevi testo anche quando PasteFerry non è aperto. Mostra una notifica permanente.';

  @override
  String get mNotifications => 'Notifiche';

  @override
  String get mNotificationsDesc =>
      'Servono per la notifica permanente. PasteFerry funziona anche senza.';

  @override
  String get mBattery => 'Esecuzione in background';

  @override
  String get mBatteryDesc =>
      'Disattiva l\'ottimizzazione della batteria perché il sistema non fermi PasteFerry a schermo bloccato. Su alcuni telefoni bisogna anche aggiungere PasteFerry all\'elenco di avvio automatico o di esecuzione in background nelle Impostazioni.';

  @override
  String get mAllowed => 'Consentito';

  @override
  String get mAllow => 'Consenti';

  @override
  String mVersion(String version) {
    return 'Versione $version';
  }

  @override
  String get mDeleteConfirm => 'Eliminare questo elemento?';

  @override
  String get mDelete => 'Elimina';

  @override
  String get webShareFirewallPreparing =>
      'Verifica di Windows Firewall. Se Windows chiede l\'approvazione dell\'amministratore, scegli Sì così il telefono potrà connettersi.';

  @override
  String get webShareFirewallReady =>
      'Le regole di Windows Firewall sono pronte. Connetti il telefono alla stessa rete e scansiona il codice QR. Se ancora non si connette, ricontrolla il firewall qui sotto.';

  @override
  String get webShareFirewallFailed =>
      'La configurazione del firewall non è stata completata. Il telefono potrebbe non riuscire ad aprire la pagina. Riprova e approva la richiesta di amministratore di Windows.';

  @override
  String get webShareFirewallAllow =>
      'Verifica e consenti connessioni dal telefono';

  @override
  String get mCopyMediaFailed =>
      'Impossibile copiare questa immagine o questo file. Prova prima a salvarlo.';

  @override
  String get mShareMediaFailed =>
      'Impossibile aprire la condivisione per questa immagine o questo file. Prova prima a salvarlo.';

  @override
  String get mSaveMediaFailed =>
      'Impossibile salvare questa immagine o questo file. Controlla l\'accesso alla memoria e lo spazio libero, poi riprova.';

  @override
  String get noticeFilesUnreadable =>
      'Impossibile leggere i file appena copiati, quindi non è stato sincronizzato nulla';

  @override
  String get mAddMore => 'Aggiungi altro';

  @override
  String get mChoosePhotos => 'Scegli foto…';

  @override
  String get mMultiSelectHint =>
      'Puoi selezionare più foto insieme. In File, tocca e tieni premuto un elemento per selezionarne altri.';

  @override
  String get webSendFiles => 'Invia file';

  @override
  String get webFilesQueued =>
      'Aggiunti ai trasferimenti web. Apri Invia file sul telefono per scaricarli.';

  @override
  String get webFilesLimit =>
      'I download dal web supportano fino a 200 MB per file e 64 file per volta.';

  @override
  String get appearance => 'Aspetto';

  @override
  String get settingsAppearanceSummary => 'Tema, chiaro e scuro';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeDefault => 'Predefinito';

  @override
  String get themePixel => 'Pixel';

  @override
  String get themeMode => 'Chiaro e scuro';

  @override
  String get themeModeSystem => 'Come il sistema';

  @override
  String get themeModeLight => 'Chiaro';

  @override
  String get themeModeDark => 'Scuro';

  @override
  String get themeCustom => 'Personalizzato';

  @override
  String get themeDelete => 'Elimina tema';

  @override
  String themeDeleteConfirm(String name) {
    return 'Eliminare il tema “$name”?';
  }

  @override
  String get themeLowContrast =>
      'Parte del testo di questo tema potrebbe essere difficile da leggere';

  @override
  String get themeFootnote =>
      'I temi valgono solo per questo dispositivo, Incolla rapido compreso. Non vengono sincronizzati con gli altri dispositivi.';

  @override
  String get themeBuiltinGroup => 'Integrati';

  @override
  String get themeCustomGroup => 'Personalizzati';

  @override
  String get themeUse => 'Usa';

  @override
  String get themeDuplicate => 'Duplica';

  @override
  String themeCopyName(String name) {
    return '$name copia';
  }

  @override
  String get themeExport => 'Esporta…';

  @override
  String get themeImport => 'Importa tema…';

  @override
  String themeImported(String name) {
    return '“$name” importato';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colori del testo potrebbero essere difficili da leggere.',
      one: '1 colore del testo potrebbe essere difficile da leggere.',
    );
    return '“$name” importato. $_temp0';
  }

  @override
  String get themeExported => 'Tema esportato';

  @override
  String get themeCustomEmpty =>
      'Ancora nessun tema personalizzato. Duplica un tema integrato, importane uno o chiedi a un\'AI di crearne uno.';

  @override
  String get themeAskAi => 'Chiedi a un\'AI di creare un tema';

  @override
  String get themeAskAiBody =>
      'Aggiungi questo server MCP a un\'app di AI come Claude o Cursor, poi chiedi un tema, ad esempio “Creami un tema cyberpunk”. L\'AI legge il formato dei temi, sceglie i colori, verifica il contrasto e applica il tema.';

  @override
  String get themeAskAiCopy => 'Copia configurazione';

  @override
  String get themeAskAiCopied => 'Configurazione copiata';

  @override
  String get themeScanlines => 'Linee di scansione';

  @override
  String get themeScanlinesDesc =>
      'Sovrappone alla finestra delle tenui linee di scansione CRT. Solo per i temi pixel.';

  @override
  String get themeBackground => 'Immagine di sfondo';

  @override
  String get themeBackgroundDesc =>
      'Riempie la finestra dietro la barra laterale e le pagine. Un velo sovrapposto mantiene leggibile il testo.';

  @override
  String get themeBackgroundChoose => 'Scegli immagine…';

  @override
  String get themeBackgroundChange => 'Cambia…';

  @override
  String get themeBackgroundRemove => 'Rimuovi';

  @override
  String get themeBlur => 'Sfocatura';

  @override
  String get themeBlurNone => 'Nessuna';

  @override
  String get themeBlurLight => 'Leggera';

  @override
  String get themeBlurStrong => 'Forte';

  @override
  String get themeScrim => 'Velo';

  @override
  String get themeScrimDesc =>
      'Un colore steso sull\'immagine per mantenere leggibile il testo. Non è mai più chiaro di quanto l\'immagine richieda.';

  @override
  String get themeScrimAuto => 'Automatico';

  @override
  String get themeScrimMore => 'Più denso';

  @override
  String get themeScrimMost => 'Il più denso';

  @override
  String get themePanels => 'Pannelli';

  @override
  String get themePanelsDesc =>
      'Quanto l\'immagine traspare attraverso la barra laterale e gli elenchi.';

  @override
  String get themePanelsClear => 'Trasparenti';

  @override
  String get themePanelsMedium => 'Medi';

  @override
  String get themePanelsSolid => 'Opachi';

  @override
  String get themeAccentFromImage => 'Usa i colori dell\'immagine';

  @override
  String get themeAccentFromImageDesc =>
      'Prende il colore di evidenziazione dall\'immagine.';

  @override
  String get themeBackgroundPicker => 'Mostra anche in Incolla rapido';

  @override
  String get themeScenery => 'Mostra paesaggi';

  @override
  String get themeSceneryDesc =>
      'Le immagini in cima alle pagine e in fondo alla barra laterale.';

  @override
  String themeCopiedForEdit(String name) {
    return 'I temi integrati non si possono modificare, quindi è stata creata e applicata una copia chiamata “$name”';
  }

  @override
  String get themeBackgroundFootnote =>
      'Lo sfondo appartiene al tema attuale. I temi integrati non si possono modificare: la prima modifica crea una copia. Le immagini restano su questo dispositivo; sono supportati JPEG, PNG e GIF.';

  @override
  String get themeSceneGroup => 'Paesaggi';

  @override
  String get themeSceneHeader => 'Intestazione pagina';

  @override
  String get themeSceneHeaderDesc =>
      'Un\'immagine larga dietro i titoli delle pagine, che sfuma nella pagina verso il basso. Il tema pixel qui disegna un paesaggio pixel.';

  @override
  String get themeSceneSidebar => 'Fondo barra laterale';

  @override
  String get themeSceneSidebarDesc =>
      'Una piccola immagine in fondo alla barra laterale. Il tema pixel qui disegna un piccolo accampamento.';

  @override
  String get themeSceneReset => 'Ripristina';

  @override
  String get themeSceneFootnote =>
      'Qualsiasi tema può mostrare qui le tue immagini. Un velo mantiene leggibile il titolo della pagina. I paesaggi sono nascosti quando un\'immagine di sfondo riempie la finestra.';

  @override
  String get starTitle => 'Ti piace PasteFerry?';

  @override
  String get starBody =>
      'Se ti piace, una stella su GitHub significherebbe molto.';

  @override
  String get starAction => 'Metti una stella su GitHub';

  @override
  String get starLater => 'Più tardi';

  @override
  String get starDismiss => 'Non mostrare più';
}
