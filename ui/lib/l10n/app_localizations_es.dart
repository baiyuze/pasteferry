// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Historial';

  @override
  String get navDevices => 'Dispositivos';

  @override
  String get navSettings => 'Configuración';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get linkConnecting => 'Conectando…';

  @override
  String get linkServiceNotRunning => 'El servicio no está activo';

  @override
  String get linkLanMode => 'Buscando dispositivos en esta red';

  @override
  String get linkServerUnreachable =>
      'No se puede conectar con el servidor; sincronizando en esta red';

  @override
  String get linkNothingOn =>
      'La detección en la red local está desactivada y no hay ningún servidor configurado';

  @override
  String get linkLanBlocked => 'macOS está bloqueando la red local';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivos en línea',
      one: '1 dispositivo en línea',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Conectado al servidor';

  @override
  String linkConnectionLost(String detail) {
    return 'Conexión perdida: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Servicio desconectado';

  @override
  String get linkServiceDisabled =>
      'La sincronización en segundo plano está desactivada';

  @override
  String get errServiceNotConnected =>
      'Sin conexión con el servicio en segundo plano';

  @override
  String get errUnimplemented => 'Esta función aún no está disponible';

  @override
  String get errUnavailable =>
      'No se puede conectar con el servicio en segundo plano';

  @override
  String errServiceStart(String detail) {
    return 'No se pudo iniciar el servicio en segundo plano: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'No se pudo reiniciar el servicio en segundo plano: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'No se pudo configurar PasteFerry para que se abra al iniciar sesión: $detail';
  }

  @override
  String get thisMacTitle => 'Esta Mac';

  @override
  String get thisPcTitle => 'Esta computadora';

  @override
  String get thisMacInText => 'esta Mac';

  @override
  String get thisPcInText => 'esta computadora';

  @override
  String get bothMacs => 'ambas Mac';

  @override
  String get bothDevices => 'ambos dispositivos';

  @override
  String get thisDeviceShort => 'Este dispositivo';

  @override
  String fromDevice(String name) {
    return 'De $name';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get save => 'Guardar';

  @override
  String get retry => 'Reintentar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String secondsAgo(int n) {
    return 'Hace $n s';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hace $n minutos',
      one: 'Hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hace $n horas',
      one: 'Hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Hace $n días',
      one: 'Ayer',
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
      other: '$n horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Copia algo en cualquiera de tus dispositivos y aparecerá aquí';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0, retención: $ttl';
  }

  @override
  String get filterAll => 'Todo';

  @override
  String get filterText => 'Texto';

  @override
  String get filterImage => 'Imágenes';

  @override
  String get filterFile => 'Archivos';

  @override
  String get filterLink => 'Enlaces';

  @override
  String get historyClearTooltip => 'Borrar historial';

  @override
  String get historyEmptyTitle => 'Aún no hay nada';

  @override
  String get historyEmptyFilteredTitle => 'No hay nada de este tipo';

  @override
  String get historyEmptyBody =>
      'Copia texto, una imagen o un archivo en cualquier dispositivo vinculado y aparecerá aquí.';

  @override
  String get clearConfirmTitle => '¿Borrar todo el historial?';

  @override
  String clearConfirmBody(String device) {
    return 'Todo lo sincronizado desde tus dispositivos y los archivos en caché se eliminarán de $device. Los archivos originales no se ven afectados.';
  }

  @override
  String get clear => 'Borrar';

  @override
  String get historyCleared => 'Historial borrado';

  @override
  String get permDeniedTitle => 'PasteFerry no puede leer el portapapeles';

  @override
  String get permAskTitle => 'Permite que PasteFerry lea el portapapeles';

  @override
  String get permDeniedBody =>
      'Lo que copies en esta Mac no se sincronizará. En Configuración del Sistema, cambia PasteFerry Daemon a Permitir.';

  @override
  String get permAskBody =>
      'De lo contrario, macOS te preguntará cada vez. En Configuración del Sistema, cambia PasteFerry Daemon a Permitir.';

  @override
  String get openSystemSettings => 'Abrir Configuración del Sistema';

  @override
  String get fetch => 'Recibir';

  @override
  String get fetchStarted => 'Recibiendo… Consulta el progreso en el Historial';

  @override
  String get transferFailed => 'Error en la transferencia';

  @override
  String get expired => 'Caducado';

  @override
  String get putOnClipboard => 'Copiar';

  @override
  String get putOnClipboardDone => 'En el portapapeles';

  @override
  String get deleteRecord => 'Eliminar este elemento';

  @override
  String get deleted => 'Eliminado';

  @override
  String get emptyRecord => '(vacío)';

  @override
  String get imageRecord => 'Imagen';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others más',
      one: '1 más',
    );
    return '$name y $_temp0';
  }

  @override
  String get searchHint => 'Buscar texto y nombres de archivo';

  @override
  String get searchClear => 'Borrar búsqueda';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String searchEmptyTitle(String query) {
    return 'No hay resultados para “$query”';
  }

  @override
  String get searchEmptyBody =>
      'La búsqueda abarca el texto copiado y los nombres de los archivos copiados.';

  @override
  String get favoriteAction => 'Agregar a favoritos';

  @override
  String get unfavoriteAction => 'Quitar de favoritos';

  @override
  String get favoritedToast => 'Agregado a Favoritos';

  @override
  String get unfavoritedToast => 'Devuelto al Historial';

  @override
  String get undo => 'Deshacer';

  @override
  String get favoriteSaving => 'Guardando…';

  @override
  String favoritedAt(String date) {
    return 'Guardado: $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0 · nunca se borran · hasta $size';
  }

  @override
  String get favoritesEmptyTitle => 'Aún no hay favoritos';

  @override
  String get favoritesEmptyBody =>
      'Marca con una estrella un elemento del Historial para guardar una copia aquí. Los favoritos nunca se borran automáticamente.';

  @override
  String get favoritesSearchHint => 'Buscar en favoritos';

  @override
  String favoriteLargeTitle(String size) {
    return '¿Guardar una copia de $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Un favorito guarda su propia copia, así que modificar o eliminar los archivos originales no le afecta. Esto ocupa $size en $device.';
  }

  @override
  String get saveCopy => 'Guardar copia';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tus $count favoritos se conservan.',
      one: 'Tu favorito se conserva.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favoritos';

  @override
  String get favoritesUsageDesc =>
      'Los favoritos nunca se borran, independientemente de la configuración anterior';

  @override
  String upToSize(String size) {
    return 'Hasta $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres',
      one: '1 carácter',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres en total',
      one: '1 carácter en total',
    );
    return '… $_temp0';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count más',
      one: '1 más',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Selecciónalo para descargarlo primero';

  @override
  String detailTotalSize(String size) {
    return '$size en total';
  }

  @override
  String get quickPaste => 'Pegado rápido';

  @override
  String get quickPasteWindow => 'Ventana de pegado rápido';

  @override
  String get quickPasteWindowDesc =>
      'Presiona el atajo en cualquier app para abrir tu historial; elige un elemento y se pegará';

  @override
  String get quickPasteShortcut => 'Atajo';

  @override
  String get quickPasteRecord => 'Haz clic para cambiar';

  @override
  String get quickPasteRecording => 'Presiona el nuevo atajo…';

  @override
  String get quickPasteUseDefault => 'Usar predeterminado';

  @override
  String get quickPasteNeedsModifier =>
      'Incluye ⌃, ⌥, ⇧ o ⌘, o usa una tecla de función';

  @override
  String get quickPasteNeedsModifierPc =>
      'Incluye Ctrl, Alt, Mayús o la tecla Windows, o usa una tecla de función';

  @override
  String get quickPasteAfterPick => 'Al elegir un elemento';

  @override
  String get quickPastePasteIt => 'Pegarlo';

  @override
  String get quickPasteCopyIt => 'Solo copiarlo';

  @override
  String get quickPasteIndexKey => 'Elegir uno de los 9 primeros';

  @override
  String get quickPasteIndexKeyDesc =>
      'En la ventana de pegado rápido, mantén presionada esta tecla y presiona 1–9';

  @override
  String get quickPasteAccessibility => 'Accesibilidad';

  @override
  String get quickPasteAccessibilityDesc =>
      'Necesario para pegar por ti. Sin este permiso, los elementos se copian y tú presionas ⌘V.';

  @override
  String get quickPasteAllowed => 'Permitido';

  @override
  String get quickPasteAllow => 'Permitir…';

  @override
  String get quickPasteNotRunning =>
      'La ventana de pegado rápido no está en ejecución';

  @override
  String quickPasteInUse(String key) {
    return 'Otra app ya usa $key. Elige otro atajo.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'No se pudo configurar $key: $detail';
  }

  @override
  String get quickPastePortalKey =>
      'Se configura en los atajos de teclado del sistema';

  @override
  String get quickPasteWaylandDesc =>
      'En Wayland, agrega el atajo en la configuración de teclado de tu escritorio. Los elementos elegidos se copian; presiona Ctrl+V para pegar.';

  @override
  String get quickPasteAddShortcut => 'Agregar atajo del sistema';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Agregado. Presiona $key para probarlo.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Agrega en la configuración de teclado de tu escritorio un atajo personalizado que ejecute: $command';
  }

  @override
  String get pickerSearch => 'Buscar';

  @override
  String get pickerPaste => 'Pegar';

  @override
  String get pickerPlainText => 'Texto sin formato';

  @override
  String get pickerCopyOnly => 'Solo copiar';

  @override
  String get pickerUnfavoriteHint => 'Quitar (vuelve al Historial)';

  @override
  String pickerPasteManually(String key) {
    return 'Los elementos elegidos se copian: presiona $key para pegar';
  }

  @override
  String get pickerGrantHint =>
      'Concede el permiso de Accesibilidad para pegar directamente';

  @override
  String pickerElevated(String key) {
    return 'Esta ventana se ejecuta como administrador: presiona $key para pegar después de elegir';
  }

  @override
  String get pickerDownloading => 'Descargando; se pegará al terminar';

  @override
  String get imagePreviewTitle => 'Vista previa de imagen';

  @override
  String get closePreview => 'Cerrar vista previa';

  @override
  String get previousImage => 'Imagen anterior';

  @override
  String get nextImage => 'Imagen siguiente';

  @override
  String get previewHint =>
      'Desplaza o pellizca para hacer zoom; arrastra para moverte';

  @override
  String get fitWindow => 'Ajustar a la ventana';

  @override
  String get previewDeleted => 'Esta imagen se eliminó del historial';

  @override
  String get previewExpired => 'Esta imagen caducó y no se puede previsualizar';

  @override
  String get previewDownloading => 'Descargando la imagen…';

  @override
  String get previewDownloadFailed =>
      'No se pudo descargar. Inténtalo de nuevo.';

  @override
  String get previewNotDownloaded =>
      'Esta imagen aún no está en esta computadora';

  @override
  String get downloadAndPreview => 'Descargar y ver';

  @override
  String get previewUnavailable =>
      'Esta imagen no se puede previsualizar ahora';

  @override
  String get imageSemantic => 'Imagen del historial';

  @override
  String get previewUnreadable =>
      'No se puede leer la imagen. Es posible que el archivo se haya borrado o esté dañado.';

  @override
  String get devicesSubtitleEmpty =>
      'Una vez vinculados, tus dispositivos comparten un mismo portapapeles';

  @override
  String devicesSubtitle(int paired, int online) {
    String _temp0 = intl.Intl.pluralLogic(
      paired,
      locale: localeName,
      other: '$paired vinculados',
      one: '1 vinculado',
    );
    return '$_temp0, $online en línea';
  }

  @override
  String get addDevice => 'Agregar dispositivo';

  @override
  String thisDeviceFootnote(String both) {
    return 'Al vincular, $both muestran las mismas dos líneas de huellas de seguridad, una por cada dispositivo. Confirma solo si coinciden carácter por carácter.';
  }

  @override
  String get noDevicesTitle => 'Aún no hay dispositivos vinculados';

  @override
  String get noDevicesBody =>
      'Abre PasteFerry en tu otra computadora y vincula ambas con un código de vinculación de 6 caracteres. Si están en la misma red, también puedes abrir “Buscar cerca” en las dos y hacer clic en la otra.';

  @override
  String get pairedDevices => 'Dispositivos vinculados';

  @override
  String get pairedFootnote =>
      'Directa: los datos van directamente entre los dos dispositivos. Retransmisión: si la red bloquea la conexión directa, los datos pasan por tu servidor y siguen cifrados de extremo a extremo.';

  @override
  String get offline => 'Sin conexión';

  @override
  String get direct => 'Directa';

  @override
  String get relay => 'Retransmisión';

  @override
  String get online => 'En línea';

  @override
  String get moreActions => 'Más';

  @override
  String get copyFingerprint => 'Copiar huella';

  @override
  String get unpairEllipsis => 'Desvincular…';

  @override
  String get fingerprintCopied => 'Huella copiada';

  @override
  String unpairTitle(String name) {
    return '¿Desvincular “$name”?';
  }

  @override
  String get unpairBody =>
      'Los dos dispositivos dejarán de sincronizarse. Para volver a sincronizarlos, tendrás que vincularlos y comprobar las huellas de nuevo.';

  @override
  String get unpair => 'Desvincular';

  @override
  String get unpaired => 'Desvinculado';

  @override
  String get enterAddressEllipsis => 'Escribir su dirección…';

  @override
  String setAddressTitle(String name) {
    return 'Dirección de “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Úsalo cuando los dos dispositivos estén en subredes distintas o ambos hayan cambiado de dirección. Escribe la dirección que aparece en “$name” en Agregar dispositivo → Mostrar un código.';
  }

  @override
  String get addressSaved => 'Buscándolo en esa dirección';

  @override
  String get lanBlockedTitle => 'macOS está bloqueando la red local';

  @override
  String lanBlockedBody(String device) {
    return 'Activa PasteFerry Daemon en Configuración del Sistema → Privacidad y seguridad → Red local. Hasta entonces, $device no podrá conectarse con los dispositivos de esta red.';
  }

  @override
  String get searchNearby => 'Buscar cerca';

  @override
  String get nearbyTitle => 'Dispositivos cercanos';

  @override
  String get nearbySearching => 'Buscando dispositivos cercanos…';

  @override
  String get nearbyHint =>
      'Abre también “Buscar cerca” en la otra computadora y aparecerá aquí. Haz clic en ella para vincular.';

  @override
  String nearbyVisible(String device) {
    return 'Mientras esta ventana esté abierta, los dispositivos de esta red pueden ver el nombre de $device.';
  }

  @override
  String get nearbyPaired => 'Vinculado';

  @override
  String nearbyRequesting(String name) {
    return 'Contactando con “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” no respondió. Asegúrate de que “Buscar cerca” siga abierto en ese dispositivo.';
  }

  @override
  String get nearbyLanOffTitle =>
      'La detección en la red local está desactivada';

  @override
  String get nearbyLanOffBody =>
      'Activa “Buscar dispositivos en esta red” en Configuración → Conexión para ver los dispositivos cercanos, o vincula con un código.';

  @override
  String get generateCode => 'Mostrar un código';

  @override
  String get enterCode => 'Escribir un código';

  @override
  String get codeFailedTitle => 'No se pudo crear un código de vinculación';

  @override
  String get enterOnOther => 'Escribe este código en tu otro dispositivo';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get codeHint => 'Haz clic para copiar. Válido durante 5 minutos.';

  @override
  String afterEnterFootnote(String both) {
    return 'Una vez escrito, $both muestran las mismas dos líneas de huellas de seguridad. Confirma solo si coinciden.';
  }

  @override
  String get codeInvalid => 'El código de vinculación tiene 6 letras o dígitos';

  @override
  String get localAddress => 'Dirección';

  @override
  String get addressHint =>
      '¿En otra subred? Escribe también esta dirección en el otro dispositivo.';

  @override
  String get addressCopied => 'Dirección copiada';

  @override
  String get differentSubnet => '¿En otra subred?';

  @override
  String get peerAddress => 'Dirección que aparece bajo el código';

  @override
  String get pairNotFound =>
      'No se encontró ese dispositivo. Si está en otra subred, escribe la dirección que aparece bajo su código.';

  @override
  String get pairNotFoundAddress =>
      'Nadie respondió en esa dirección. Comprueba la dirección y que el otro dispositivo siga mostrando su código. También puede que un firewall en ese dispositivo esté bloqueando la conexión.';

  @override
  String get codeWrong => 'Ese código no es correcto o ya caducó';

  @override
  String get codeExpired =>
      'Este código caducó. Muestra uno nuevo en el otro dispositivo.';

  @override
  String get addressInvalid =>
      'Esa dirección no es válida. Escribe algo como 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Primero activa la detección en la red local o configura un servidor en Configuración → Conexión.';

  @override
  String get enterCodeShown =>
      'Escribe el código que aparece en tu otro dispositivo';

  @override
  String get pairingDone => 'Vinculado';

  @override
  String get pairingRejected => 'Vinculación rechazada';

  @override
  String get verifyTitle => 'Comprueba las huellas de seguridad';

  @override
  String pairingWith(String name) {
    return 'Vinculando con “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'Las dos líneas en $both deben ser idénticas. Si difiere aunque sea un carácter, alguien podría estar manipulando la conexión, así que recházala.';
  }

  @override
  String get rejectMismatch => 'No coinciden, rechazar';

  @override
  String get confirmMatch => 'Coinciden, vincular';

  @override
  String get server => 'Servidor (opcional)';

  @override
  String get signalingUrl => 'Servidor de señalización';

  @override
  String get signalingUrlDesc =>
      'Déjalo en blanco para sincronizar solo en la red local';

  @override
  String get signalingUrlPlaceholder =>
      'ws://direccion-del-servidor:8787/signal';

  @override
  String get publicStun => 'Mejorar conexiones directas';

  @override
  String get publicStunDesc =>
      'Los servidores públicos pueden ver tu IP pública';

  @override
  String get connectionStatus => 'Conexión';

  @override
  String get disconnectedDesc =>
      'Comprueba la dirección del servidor y su disponibilidad';

  @override
  String get connected => 'Conectado';

  @override
  String get notConnected => 'No conectado';

  @override
  String get notSet => 'Sin configurar';

  @override
  String get serverCleared =>
      'Servidor eliminado. Sincronizando solo en esta red.';

  @override
  String get localNetwork => 'Red local';

  @override
  String get lanDiscovery => 'Buscar dispositivos en esta red';

  @override
  String get lanDiscoveryDesc =>
      'Detección anónima; los nombres solo se ven durante “Buscar cerca”';

  @override
  String get macLocalNetwork => 'Acceso a la red local';

  @override
  String get macLocalNetworkDesc =>
      'Permite PasteFerry Daemon en Configuración del Sistema';

  @override
  String get allowLan => 'Firewall de Windows';

  @override
  String get allowLanDesc =>
      'Permite las conexiones bloqueadas; requiere aprobación de administrador';

  @override
  String get allow => 'Permitir';

  @override
  String get allowLanDone =>
      'Permitido. Otros dispositivos ya pueden conectarse a este.';

  @override
  String get deviceName => 'Nombre del dispositivo';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Del sistema';

  @override
  String get sync => 'Sincronización';

  @override
  String get autoSyncLimit => 'Límite de sincronización automática';

  @override
  String get autoSyncLimitDesc =>
      'Los elementos más grandes se reciben manualmente desde el Historial';

  @override
  String get autoApply => 'Copiar lo recibido al portapapeles';

  @override
  String get whatToSync => 'Qué sincronizar';

  @override
  String get syncFiles => 'Archivos y carpetas';

  @override
  String get syncText => 'Texto sin formato';

  @override
  String get syncRich => 'Texto con formato';

  @override
  String get syncImages => 'Imágenes y capturas de pantalla';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get storageFootnote =>
      'El historial caducado y los archivos en caché se eliminan automáticamente.';

  @override
  String get keepHistory => 'Conservar historial durante';

  @override
  String get keepCache => 'Conservar archivos en caché durante';

  @override
  String get keepCacheDesc => 'No más que el historial';

  @override
  String get cacheUsage => 'Tamaño de la caché';

  @override
  String get backgroundSync => 'Sincronización en segundo plano';

  @override
  String get backgroundService => 'Servicio en segundo plano';

  @override
  String get backgroundServiceDesc =>
      'Se abre al iniciar sesión; sincroniza con la ventana cerrada';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restarted => 'Servicio en segundo plano reiniciado';

  @override
  String get disableEllipsis => 'Desactivar…';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDesc => 'Código abierto con licencia AGPL-3.0';

  @override
  String get homepage => 'Sitio web';

  @override
  String get feedback => 'Informar un problema';

  @override
  String get disableTitle => '¿Desactivar la sincronización en segundo plano?';

  @override
  String disableBody(String device) {
    return 'PasteFerry dejará de sincronizar en $device y no se abrirá al iniciar sesión. El historial y las vinculaciones se conservan.';
  }

  @override
  String get disable => 'Desactivar';

  @override
  String get disabled => 'La sincronización en segundo plano está desactivada';

  @override
  String get urlMustBeWs => 'La dirección debe comenzar con ws:// o wss://';

  @override
  String get serverUpdated => 'Servidor actualizado. Reconectando…';

  @override
  String get deviceNameUpdated => 'Nombre del dispositivo actualizado';

  @override
  String get diagIntro =>
      'Este informe incluye la versión de la app, tu sistema, la configuración, los dispositivos y los registros recientes. Los nombres de dispositivo, la dirección del servidor, las IP públicas, tu carpeta de usuario y los nombres de archivo se reemplazan, y lo que copias nunca se escribe en los registros. Las incidencias de GitHub son públicas, así que revísalo antes de publicarlo.';

  @override
  String get diagVerboseTitle => 'Registro detallado';

  @override
  String get diagVerboseDesc =>
      'Para problemas de conexión: actívalo, haz que el problema vuelva a ocurrir y regresa aquí para generar el informe. Se desactiva solo a los 30 minutos.';

  @override
  String get diagVerboseOn => 'Activar durante 30 minutos';

  @override
  String diagVerboseUntil(String time) {
    return 'Activado hasta $time';
  }

  @override
  String get diagVerboseOff => 'Desactivar';

  @override
  String get diagRefresh => 'Volver a generar';

  @override
  String get diagSave => 'Guardar como archivo';

  @override
  String diagSaved(String name) {
    return 'Guardado en la carpeta Descargas: $name';
  }

  @override
  String get diagCopy => 'Copiar informe';

  @override
  String get diagCopied => 'Informe copiado';

  @override
  String get diagNewIssue => 'Nueva incidencia en GitHub';

  @override
  String get diagIssueHint =>
      'Informe copiado. Pégalo en el campo “Diagnostics report” de la incidencia.';

  @override
  String diagFailed(String detail) {
    return 'No se pudo crear el informe: $detail';
  }

  @override
  String get svcExtractTitle => 'Primero instala o extrae PasteFerry';

  @override
  String get svcExtractBody =>
      'PasteFerry se está ejecutando directamente desde el zip, y su carpeta temporal desaparece al cerrarlo. Ejecuta el instalador, o extrae la carpeta completa y ábrelo desde ahí, para activar la sincronización en segundo plano.';

  @override
  String get svcMoveTitle => 'Primero mueve PasteFerry a Aplicaciones';

  @override
  String get svcMoveBody =>
      'PasteFerry se está ejecutando directamente desde la imagen de disco. Arrástralo a Aplicaciones, expulsa la imagen de disco y ábrelo desde Aplicaciones para activar la sincronización en segundo plano.';

  @override
  String get svcStartTitle => 'Comienza a usar PasteFerry';

  @override
  String get svcStartBody =>
      'PasteFerry ejecuta un pequeño proceso en segundo plano para sincronizar el portapapeles. Cerrar la ventana no lo detiene. Abrir al iniciar sesión es una opción aparte y está desactivada en las instalaciones nuevas.';

  @override
  String get svcEnable => 'Activar sincronización en segundo plano';

  @override
  String get svcStaleTitle =>
      'Vuelve a activar la sincronización en segundo plano';

  @override
  String get svcStaleBodyWin =>
      'PasteFerry cambió de ubicación, pero el inicio automático aún apunta a la anterior. Vuelve a activarla para que el proceso en segundo plano use esta copia. El historial y las vinculaciones se conservan.';

  @override
  String get svcStaleBodyMac =>
      'PasteFerry cambió de ubicación o se instaló con un script antiguo. Vuelve a activarla para que el proceso en segundo plano use esta app. El historial y las vinculaciones se conservan.';

  @override
  String get svcReenable => 'Volver a activar';

  @override
  String get svcStoppedTitle =>
      'El servicio en segundo plano no está en ejecución';

  @override
  String get svcStoppedBody =>
      'El servicio en segundo plano está detenido. Inícialo con el botón de abajo; abrir al iniciar sesión se controla aparte en Configuración.';

  @override
  String get svcDevBodyWin =>
      'Esta es una compilación de desarrollo sin pasteferryd.exe a su lado. Ejecuta scripts\\build-windows.ps1 en la carpeta del código fuente para compilar una versión completa.';

  @override
  String get svcDevBodyLinux =>
      'Esta es una compilación de desarrollo sin pasteferryd a su lado. Ejecuta ./scripts/package-linux.sh en la carpeta del código fuente para compilar una versión completa.';

  @override
  String get svcDevBodyMac =>
      'Esta es una compilación de desarrollo sin el servicio en segundo plano. Ejecuta ./scripts/install-macos.sh en la carpeta del código fuente para instalarlo.';

  @override
  String svcLogPath(String path) {
    return 'Registro: $path';
  }

  @override
  String get svcCanDisable =>
      'Puedes desactivar la sincronización en segundo plano cuando quieras en Configuración.';

  @override
  String get officialService => 'Servicio';

  @override
  String get useOfficialService => 'Usar el servicio';

  @override
  String get officialServiceDesc =>
      'Sincroniza entre redes, con prioridad a las conexiones directas';

  @override
  String get officialPrivacy =>
      'Solo se conecta al servicio cuando está activado y registra la información de conexión imprescindible. Primero se intentan las conexiones directas; la retransmisión solo se solicita si fallan. No se suben contenidos, nombres reales de dispositivos ni identificadores del sistema sin procesar.';

  @override
  String get officialEnableTitle => '¿Activar el servicio?';

  @override
  String get officialSwitchConfirm =>
      'Esto deja de usar tu servidor personalizado. Su dirección guardada se conservará.';

  @override
  String get customServer => 'Servidor personalizado';

  @override
  String get saveAndConnect => 'Guardar y conectar';

  @override
  String get officialLoading => 'Consultando la cuota…';

  @override
  String get officialFetchFailed =>
      'No se puede obtener la cuota ahora. Se volverá a intentar automáticamente.';

  @override
  String get officialUnavailable =>
      'El uso no está disponible; los datos actuales pueden estar desactualizados';

  @override
  String get officialQuotaTitle => 'Cuota diaria de retransmisión agotada';

  @override
  String get officialQuotaBody =>
      'La retransmisión del servicio está en pausa hasta el reinicio diario a medianoche, hora de Pekín. Las conexiones por red local y las directas por Internet siguen disponibles. Las transferencias fallidas se pueden reintentar más tarde.';

  @override
  String get officialPeerQuota =>
      'El otro dispositivo no tiene cuota de retransmisión. Las conexiones directas siguen disponibles.';

  @override
  String get officialPaused =>
      'La retransmisión del servicio no está disponible. Las conexiones directas siguen disponibles.';

  @override
  String get officialViewUsage => 'Ver uso';

  @override
  String get officialAcknowledge => 'Entendido';

  @override
  String get officialToday => 'Cuota de retransmisión de hoy';

  @override
  String get officialUsed => 'Usado';

  @override
  String get officialRemaining => 'Restante';

  @override
  String get officialDailyLimit => 'Cuota diaria';

  @override
  String get officialUpload => 'Subida';

  @override
  String get officialDownload => 'Descarga';

  @override
  String get officialReset => 'Hora de reinicio (Pekín)';

  @override
  String get officialUpdated => 'Última actualización';

  @override
  String get officialRoutes => 'Cómo se conectan los dispositivos';

  @override
  String get officialRoutesFootnote =>
      'Las conexiones directas no pasan por la retransmisión del servicio ni consumen la cuota.';

  @override
  String get officialDeviceID => 'ID del dispositivo';

  @override
  String get officialWarning =>
      'Se usó el 90 % de la cuota diaria de retransmisión. Las conexiones directas no la consumen.';

  @override
  String get updateCheck => 'Buscar actualizaciones';

  @override
  String get updateCheckEllipsis => 'Buscar actualizaciones…';

  @override
  String get updateAuto => 'Buscar actualizaciones automáticamente';

  @override
  String get updateChecking => 'Buscando actualizaciones…';

  @override
  String updateUpToDate(String version) {
    return 'PasteFerry $version es la versión más reciente.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version está disponible';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Tienes la versión $current. Tamaño de la descarga: $size.';
  }

  @override
  String get updateNew => 'Novedades';

  @override
  String get updateFixed => 'Correcciones';

  @override
  String get updateSkip => 'Omitir esta versión';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get updateInstall => 'Descargar e instalar';

  @override
  String updateDownloading(String done, String total) {
    return 'Descargando $done de $total';
  }

  @override
  String get updateVerifying => 'Comprobando la descarga…';

  @override
  String get updateInstalling =>
      'Instalando. PasteFerry se volverá a abrir solo.';

  @override
  String get updateInstallingPassword =>
      'Instalando. El sistema te pedirá la contraseña porque /opt requiere permisos de administrador; después, PasteFerry se volverá a abrir solo.';

  @override
  String get updateCheckFailed =>
      'No se pudo conectar con GitHub ni con Gitee. Inténtalo más tarde.';

  @override
  String get updateDownloadFailed =>
      'La descarga no terminó. Inténtalo de nuevo o descarga la nueva versión desde el sitio web.';

  @override
  String updateInstallFailed(String error) {
    return 'No se pudo iniciar la instalación: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Esta compilación no puede buscar actualizaciones.';

  @override
  String get updateBlockedDev =>
      'Esta es una compilación de desarrollo, así que no puede actualizarse sola.';

  @override
  String get updateBlockedMustMove =>
      'PasteFerry se está ejecutando desde la imagen de disco. Arrástralo a Aplicaciones y ábrelo desde ahí para que se actualice automáticamente.';

  @override
  String get updateBlockedReadOnly =>
      'PasteFerry no puede escribir en la carpeta donde está instalado. Descarga la nueva versión desde el sitio web.';

  @override
  String get updateBlockedUnsupported =>
      'No hay actualización automática para esta computadora. Descarga la nueva versión desde el sitio web.';

  @override
  String get updateOpenDownload => 'Abrir la página de descarga';

  @override
  String updateSidebar(String version) {
    return 'Versión $version disponible';
  }

  @override
  String updatedTo(String version) {
    return 'Actualizado a $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'La actualización no terminó. Sigues con la versión $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'La actualización no terminó. Sigues con la versión $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Interfaz $uiVersion · Servicio $serviceVersion · Compilación $build';
  }

  @override
  String get notReceived => 'No recibido: recíbelo antes de pegar';

  @override
  String get receivedPreserved =>
      'Recibido; usa Copiar al portapapeles cuando quieras';

  @override
  String get clipboardWriteFailed =>
      'Recibido, pero no se pudo actualizar el portapapeles';

  @override
  String get receivingStatus => 'Recibiendo…';

  @override
  String get largeFileNotifications => 'Avisos de archivos grandes';

  @override
  String get notificationsAllowed =>
      'Las notificaciones están activadas. El progreso se muestra en el Historial.';

  @override
  String get notificationsNotRequested =>
      'Activa las notificaciones para que los archivos grandes no esperen sin avisar. Siempre puedes recibirlos desde el Historial.';

  @override
  String get notificationsDenied =>
      'Las notificaciones están bloqueadas en la configuración del sistema. Recibe los elementos pendientes desde el Historial.';

  @override
  String get notificationsUnknown =>
      'Tu escritorio controla la entrega de notificaciones y el modo No molestar. Si no aparece ningún aviso, recibe los elementos desde el Historial.';

  @override
  String get notificationsUnavailable =>
      'Las notificaciones del sistema no están disponibles. Recibe los archivos grandes desde el Historial.';

  @override
  String get enableNotifications => 'Activar avisos';

  @override
  String get notificationSettings => 'Configuración de notificaciones';

  @override
  String get notifyPendingTitle => 'Recibe para pegar';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nRecibe este elemento antes de pegarlo. También puedes recibirlo desde el Historial.';
  }

  @override
  String get notifyReceivingTitle => 'Recibiendo…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nConsulta el progreso en el Historial.';
  }

  @override
  String get notifyReadyTitle => 'Listo para pegar';

  @override
  String notifyReadyBody(String name) {
    return '$name\nRecibido y copiado al portapapeles.';
  }

  @override
  String get notifyReceivedTitle => 'Recibido';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nSe conservó tu portapapeles. Usa Copiar al portapapeles cuando quieras; también está disponible en el Historial.';
  }

  @override
  String get notifyFailedTitle => 'No se pudo recibir';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nVuelve a intentarlo desde esta notificación o desde el Historial.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Recibido; no se actualizó el portapapeles';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUsa Copiar al portapapeles para volver a intentarlo, aquí o en el Historial.';
  }

  @override
  String get reconnect => 'Reconectar';

  @override
  String get reconnecting => 'Conectando…';

  @override
  String get reconnectDirect => 'Conectado directamente';

  @override
  String get reconnectRelay =>
      'No se pudo conectar directamente; se sigue usando la retransmisión';

  @override
  String reconnectOffline(String name) {
    return '“$name” no está en línea. Asegúrate de que PasteFerry esté abierto en ese dispositivo.';
  }

  @override
  String get reconnectPending => 'Aún conectando; vuelve a mirar en un momento';

  @override
  String get renameAction => 'Cambiar nombre';

  @override
  String get renameFavoriteTitle => 'Cambiar nombre del favorito';

  @override
  String get renameFavoriteHint =>
      'Se muestra en Favoritos y en Pegado rápido, y puedes buscarlo. Déjalo vacío para volver a mostrar el contenido.';

  @override
  String get renamedToast => 'Nombre cambiado';

  @override
  String get aliasClearedToast => 'Se muestra de nuevo el contenido';

  @override
  String get navSend => 'Enviar archivos';

  @override
  String get sendSubtitle =>
      'Arrastra archivos a un dispositivo para enviárselos directamente';

  @override
  String get sendNoDevicesTitle => 'Aún no hay dispositivos vinculados';

  @override
  String get sendNoDevicesBody =>
      'Primero vincula otra computadora y luego envíale archivos desde aquí.';

  @override
  String get sendDropHint => 'Suelta sobre un dispositivo para enviar';

  @override
  String sendReleaseTo(String name) {
    return 'Suelta para enviar a $name';
  }

  @override
  String get sendLan => 'Red local';

  @override
  String sendRelayLeft(String left) {
    return 'Retransmisión · quedan $left hoy';
  }

  @override
  String get sendNeedsUpdate => 'Requiere actualización';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name podrá recibir archivos cuando se actualice a PasteFerry 2.5 o posterior.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Conectando con $name. Podrás enviar en cuanto se conecte.';
  }

  @override
  String get sendNotReceiving => 'No recibe archivos';

  @override
  String get sendDelivered => 'Entregado';

  @override
  String sendToTitle(String name) {
    return 'Enviar a $name';
  }

  @override
  String get sendDropHere => 'Arrastra archivos o carpetas aquí';

  @override
  String get sendDropStarts => 'El envío comienza en cuanto los sueltas';

  @override
  String get sendChooseFiles => 'Elegir archivos…';

  @override
  String get sendChooseFolder => 'Elegir carpeta…';

  @override
  String get sendDropMore =>
      'Suelta más archivos para enviarlos a continuación';

  @override
  String sendSavedWhere(String name) {
    return 'Los archivos se guardan donde elija $name; de forma predeterminada, en la carpeta Descargas.';
  }

  @override
  String get sendCloseKeeps => 'Cerrar esta ventana no detiene el envío';

  @override
  String get sendRemoveQueued => 'Quitar';

  @override
  String get sendCannotDrop =>
      'Este elemento no se puede enviar arrastrándolo. Guárdalo primero como archivo o usa Elegir archivos….';

  @override
  String sendErrOffline(String name) {
    return '$name no está en línea.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name no está recibiendo archivos.';
  }

  @override
  String get sendErrMissing => 'Algunos de estos archivos ya no existen.';

  @override
  String get relayConfirmTitle => '¿Enviar por la retransmisión del servicio?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name no tiene conexión directa con esta computadora en este momento, así que los archivos pasan por la retransmisión del servicio a unos 0,25 MB/s. Quedan $left de la cuota de retransmisión de hoy.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Estos archivos ($size) superan la cuota restante. El envío se pausa cuando se agota y continúa cuando las dos computadoras se conecten directamente o la cuota se reinicie mañana.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Esto usa unos $size de la cuota de hoy.';
  }

  @override
  String get relayExhausted =>
      'La cuota de retransmisión de hoy se agotó. Se reinicia a medianoche, hora de Pekín. Dos computadoras conectadas directamente no tienen límite.';

  @override
  String get relayDontAskToday =>
      'No volver a preguntar hoy para este dispositivo';

  @override
  String get relaySendAnyway => 'Enviar de todos modos';

  @override
  String get relayOwnServer =>
      'Retransmitido: la velocidad depende de tu servidor';

  @override
  String get transfersReceived => 'Recibidos';

  @override
  String get transfersSent => 'Enviados';

  @override
  String get transfersClearAll => 'Borrar todo';

  @override
  String get transfersClearTitle => '¿Borrar esta lista?';

  @override
  String get transfersClearBody =>
      'Solo se borra la lista. Los archivos se quedan donde están.';

  @override
  String get transfersEmptyReceived =>
      'Los archivos que te envíen otros dispositivos aparecerán aquí';

  @override
  String get transfersEmptySent => 'Los archivos que envíes aparecerán aquí';

  @override
  String transferFrom(String name) {
    return 'De $name';
  }

  @override
  String transferTo(String name) {
    return 'Para $name';
  }

  @override
  String transferItems(String name, int total, int others) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others más',
      one: '1 más',
    );
    return '$name y $_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos',
      one: '1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'En cola';

  @override
  String transferScanning(String count) {
    return 'Contando… archivos encontrados: $count';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Esperando a $name…';
  }

  @override
  String get transferSending => 'Enviando';

  @override
  String get transferReceiving => 'Recibiendo';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Ahora: $file ($index de $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Quedan $time';
  }

  @override
  String etaSeconds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n segundos',
      one: '1 segundo',
    );
    return '$_temp0';
  }

  @override
  String etaMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minutos',
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
      'En pausa: la cuota de retransmisión de hoy se agotó';

  @override
  String get transferInterrupted => 'Interrumpido: continuará al reconectarse';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Interrumpido: esperando a que $name continúe';
  }

  @override
  String get transferCancelled => 'Cancelado';

  @override
  String transferPeerCancelled(String name) {
    return 'Cancelado por $name';
  }

  @override
  String get transferExpired => 'Caducado';

  @override
  String get transferMissing => 'Movido o eliminado';

  @override
  String transferNotSent(String reason) {
    return 'No enviado: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'No recibido: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name no tiene suficiente espacio en disco (faltan $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'no hay suficiente espacio en disco (faltan $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'la ubicación de guardado de $name no está disponible';
  }

  @override
  String get reasonDestUnavailable =>
      'la ubicación de guardado no está disponible; revísala en Configuración';

  @override
  String get reasonFileTooLarge =>
      'la ubicación de guardado está en una unidad FAT32, que no admite archivos de más de 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name no está recibiendo archivos';
  }

  @override
  String get reasonSourceChanged => 'un archivo cambió mientras se enviaba';

  @override
  String get reasonSourceMissing => 'un archivo ya no existe';

  @override
  String get reasonReadError => 'no se pudo leer un archivo';

  @override
  String get reasonWriteFailed => 'no se pudieron escribir los archivos';

  @override
  String get reasonHashMismatch =>
      'un archivo se dañó durante la transferencia';

  @override
  String reasonUnsupported(String name) {
    return '$name debe actualizarse para recibir archivos';
  }

  @override
  String get reasonOther => 'algo salió mal';

  @override
  String get revealInFinder => 'Mostrar en Finder';

  @override
  String get revealInFolder => 'Mostrar en la carpeta';

  @override
  String get revealOpenFolder => 'Abrir carpeta';

  @override
  String get transferResend => 'Volver a enviar';

  @override
  String get transferRemove => 'Quitar de la lista';

  @override
  String get transferCopyPath => 'Copiar ruta';

  @override
  String get transferPathCopied => 'Ruta copiada';

  @override
  String sendingTo(String name, String percent) {
    return 'Enviando a $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Recibiendo de $name · $percent';
  }

  @override
  String get receiveFiles => 'Recibir archivos de otros dispositivos';

  @override
  String get saveTo => 'Guardar en';

  @override
  String get saveToChange => 'Cambiar…';

  @override
  String get saveToDefault => 'Descargas (predeterminada)';

  @override
  String get saveToUseDefault => 'Usar Descargas';

  @override
  String get receiveNotify => 'Avisar cuando lleguen archivos';

  @override
  String receiveFootnote(String device) {
    return 'Solo los dispositivos vinculados pueden enviar archivos a $device. Mientras se transfieren archivos, $device no entrará en reposo por sí sola.';
  }

  @override
  String get saveDirNotFound => 'Esta carpeta no existe.';

  @override
  String get saveDirNotWritable =>
      'PasteFerry no puede guardar archivos en esta carpeta.';

  @override
  String get saveDirPermission =>
      'PasteFerry no tiene permiso para usar esta carpeta. Permítelo en Configuración del Sistema → Privacidad y seguridad → Archivos y carpetas.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count nombres de archivo tenían caracteres que Windows no admite; se reemplazaron por caracteres de ancho completo similares',
      one:
          '1 nombre de archivo tenía caracteres que Windows no admite; se reemplazaron por caracteres de ancho completo similares',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Misma red';

  @override
  String get sendRingOther => 'Otras redes';

  @override
  String sendOfflineList(String names) {
    return 'Sin conexión: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Lista de transferencias';

  @override
  String get sendLayoutSide => 'Junto al radar';

  @override
  String get sendLayoutBelow => 'Debajo del radar';

  @override
  String get general => 'General';

  @override
  String get launchAtLogin => 'Abrir al iniciar sesión';

  @override
  String get launchAtLoginDesc =>
      'Se inicia en segundo plano al iniciar sesión. Cambiar esta opción no detiene la sesión actual.';

  @override
  String get realtimeSync => 'Sincronizar el portapapeles en tiempo real';

  @override
  String get realtimeSyncDesc =>
      'Comparte automáticamente lo que copies con los dispositivos vinculados. Si se desactiva, el historial local y Enviar archivos siguen disponibles.';

  @override
  String get syncBacklog => 'Ponerse al día al reconectar';

  @override
  String get syncBacklogDesc =>
      'Desactivado de forma predeterminada: lo copiado mientras no había conexión se omite. Si se activa, hasta 20 elementos de las últimas 24 horas entran en el historial sin reemplazar el portapapeles.';

  @override
  String get peerRealtimeSync => 'Sincronizar con esta computadora';

  @override
  String get syncPaused => 'Sincronización del portapapeles en pausa';

  @override
  String get quitApp => 'Salir de PasteFerry';

  @override
  String get quitAppDesc =>
      'Cierra todos los procesos de PasteFerry. Tu preferencia de abrir al iniciar sesión se conserva.';

  @override
  String get quitTransfersWarning =>
      'Todavía se están transfiriendo archivos. ¿Salir e interrumpir estas transferencias?';

  @override
  String get backgroundRunningTitle => 'PasteFerry seguirá en ejecución';

  @override
  String get backgroundRunningBody =>
      'Al cerrar la ventana, la sincronización y el pegado rápido siguen funcionando. Para detenerlo todo, elige Salir de PasteFerry en Configuración o en el menú de la app.';

  @override
  String get displayAs => 'Se muestra como';

  @override
  String get editName => 'Cambiar nombre';

  @override
  String get nameHint => 'El nombre que ven tus contactos';

  @override
  String get nameDefaultHint =>
      'Déjalo vacío para usar el nombre de tu cuenta.';

  @override
  String get avatarTitle => 'Foto de perfil';

  @override
  String get avatarChoose => 'Elegir imagen…';

  @override
  String get avatarPaste => 'Pegar imagen';

  @override
  String get avatarReset => 'Usar foto predeterminada';

  @override
  String get avatarZoom => 'Zoom';

  @override
  String get avatarDragHint => 'Arrastra para mover la imagen.';

  @override
  String get avatarNoImage => 'No hay ninguna imagen en el portapapeles.';

  @override
  String get avatarBad =>
      'No se puede usar esta imagen. Elige un PNG, JPEG o GIF.';

  @override
  String get done => 'Listo';

  @override
  String get friendsTitle => 'Contactos';

  @override
  String get addFriend => 'Agregar contacto';

  @override
  String get friendsEmpty => 'Aún no hay contactos';

  @override
  String get friendsEmptyBody =>
      'Agrega a alguien que también use PasteFerry para enviarse archivos sin vincular dispositivos. Los contactos solo pueden enviar archivos; nunca ven tu portapapeles.';

  @override
  String get friendSendAction => 'Enviar…';

  @override
  String get friendHistory => 'Transferencias';

  @override
  String friendHistoryTitle(String name) {
    return 'Transferencias con $name';
  }

  @override
  String get friendHistoryEmpty => 'Aún no hay transferencias.';

  @override
  String get friendAutoAccept => 'Aceptar archivos automáticamente';

  @override
  String get friendRemove => 'Eliminar contacto';

  @override
  String friendRemoveTitle(String name) {
    return '¿Eliminar a $name?';
  }

  @override
  String get friendRemoveBody =>
      'Se eliminarán mutuamente de sus contactos y ya no podrán enviarse archivos. Las transferencias anteriores se quedan en esta computadora.';

  @override
  String friendLastActivity(String time) {
    return 'Última transferencia: $time';
  }

  @override
  String get friendNoActivity => 'Aún no hay transferencias';

  @override
  String get friendCodeShare =>
      'Envía este código a tu contacto. Cuando lo escriba en PasteFerry, quedarán agregados como contactos mutuamente.';

  @override
  String friendCodeExpires(String time) {
    return 'Caduca en $time';
  }

  @override
  String get friendCodeOr => 'o';

  @override
  String get friendCodeEnter => 'Escribe su código de contacto';

  @override
  String get friendCodeAdd => 'Agregar';

  @override
  String get friendCodeWaiting => 'Esperando a que lo escriba…';

  @override
  String friendConfirmBody(String name) {
    return '¿Agregar a $name a tus contactos?';
  }

  @override
  String get friendSafetyCode => 'Comprobar código de seguridad (opcional)';

  @override
  String get friendSafetyHint =>
      'Cuando estén juntos, comparen estas dos líneas. Si coinciden en ambas computadoras, nadie ha interferido.';

  @override
  String get friendWaitingPeer => 'Esperando a que te agregue…';

  @override
  String friendAdded(String name) {
    return '$name se agregó a tus contactos';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name canceló';
  }

  @override
  String get friendErrFriendCode =>
      'Este es un código de contacto. Escríbelo en Agregar contacto, en la página Enviar archivos.';

  @override
  String get friendErrDeviceCode =>
      'Este es un código de vinculación. Escríbelo en Dispositivos → Agregar dispositivo.';

  @override
  String get friendErrOutdated =>
      'Tu contacto necesita PasteFerry 2.6.0 o posterior.';

  @override
  String get friendErrAlreadyPaired =>
      'Esa computadora ya es uno de tus dispositivos.';

  @override
  String get friendErrNoChannel =>
      'No están en la misma red. Activen Servicio en ambas computadoras para agregarse.';

  @override
  String get openService => 'Activar Servicio…';

  @override
  String get noteLabel => 'Nota (opcional)';

  @override
  String get noteHintEmpty => 'Primero elige los archivos';

  @override
  String get noteHint => 'Por ejemplo: firma la página 3, por favor';

  @override
  String noteLine(String note) {
    return 'Nota: $note';
  }

  @override
  String get sendAction => 'Enviar';

  @override
  String sendItemsSummary(String count, String size) {
    return 'Elementos: $count · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Suelta archivos o imágenes aquí, o pega ($key)';
  }

  @override
  String get sendDropMorePaste => 'Suelta o pega más';

  @override
  String get sendPasteNothing =>
      'No hay nada que pegar. Primero copia archivos o una imagen.';

  @override
  String get sendRemoveItem => 'Quitar';

  @override
  String sendFriendSaved(String name) {
    return '$name acepta cada envío antes de que se transfiera.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Esperando a que $name acepte…';
  }

  @override
  String get transferAskingIn => 'Esperando a que aceptes';

  @override
  String reasonDeclined(String name) {
    return '$name lo rechazó';
  }

  @override
  String reasonTimeout(String name) {
    return '$name no respondió';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name no acepta archivos';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name no acepta tus archivos en este momento';
  }

  @override
  String get reasonYouDeclined => 'Rechazado';

  @override
  String get reasonYouIgnored => 'Ignorado';

  @override
  String get sendAgain => 'Enviar de nuevo';

  @override
  String incomingTitle(String name) {
    return '$name quiere enviarte archivos';
  }

  @override
  String get incomingAlways => 'Aceptar siempre archivos de este contacto';

  @override
  String get incomingDecline => 'Rechazar';

  @override
  String get incomingAccept => 'Aceptar';

  @override
  String incomingCountdown(String seconds) {
    return 'Se rechazará automáticamente en $seconds s';
  }

  @override
  String get incomingStranger => 'Cercano';

  @override
  String get friendsStrip => 'Contactos';

  @override
  String get strangersStrip => 'Cercanos con “Todos” activado';

  @override
  String get strangerNearby => 'Cercano';

  @override
  String get friendNeedService => 'Activa Servicio';

  @override
  String get friendCantReach => 'No se puede conectar';

  @override
  String reachSelfNoService(String name) {
    return 'Tú y $name no están en la misma red. Activa Servicio para enviar archivos; si no es posible una conexión directa, pasarán por la retransmisión del servicio.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name no ha activado Servicio, así que solo puedes enviarle archivos en la misma red. Pídele que active Servicio en PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'No usan el mismo servidor. Activen Servicio en ambas computadoras o usen el mismo servidor para enviar archivos.';

  @override
  String get receiveFromLabel => 'Permitir que me envíen archivos:';

  @override
  String get receiveFromOff => 'Nadie';

  @override
  String get receiveFromFriends => 'Solo contactos';

  @override
  String get receiveFromEveryone => 'Todos';

  @override
  String everyoneLeft(String minutes) {
    return 'Todos · quedan $minutes min';
  }

  @override
  String get receiveFromOffDesc =>
      'Solo tus propias computadoras vinculadas pueden enviarte archivos.';

  @override
  String get receiveFromFriendsDesc =>
      'Tus contactos pueden enviarte archivos. Tú aceptas cada envío.';

  @override
  String get receiveFromEveryoneDesc =>
      'Cualquier persona en la misma red puede enviarte archivos durante 10 minutos. Tú aceptas cada envío.';

  @override
  String get everyoneEnded =>
      '“Todos” se desactivó; se volvió a Solo contactos.';

  @override
  String get friendsCountTooltip => 'Contactos';

  @override
  String get waitingAccept => 'Esperando…';

  @override
  String get settingsConnection => 'Conexión';

  @override
  String get settingsGeneralSummary =>
      'Abrir al iniciar sesión, nombre del dispositivo, idioma';

  @override
  String get settingsConnectionSummary =>
      'Servicio, tu propio servidor, red local';

  @override
  String get settingsSyncSummary =>
      'Sincronización en tiempo real, límite de tamaño, qué sincronizar';

  @override
  String get settingsQuickPasteSummary =>
      'Atajo y qué pasa al elegir un elemento';

  @override
  String get settingsSendSummary =>
      'Recepción de archivos, ubicación de guardado';

  @override
  String get settingsStorageSummary =>
      'Cuánto tiempo se conserva el historial, espacio usado';

  @override
  String get settingsAboutSummary => 'Versión, actualizaciones, comentarios';

  @override
  String get friendsSubtitle =>
      'Envía archivos a las computadoras de otras personas, sin vincular';

  @override
  String get friendsSearch => 'Buscar contactos';

  @override
  String get friendsNoMatch => 'No hay contactos que coincidan';

  @override
  String get friendsPick =>
      'Elige un contacto para ver sus transferencias o enviarle archivos';

  @override
  String friendDropHint(String name) {
    return 'Suelta archivos aquí para enviárselos a $name';
  }

  @override
  String get webShareTitle => 'Transferencia web con el teléfono';

  @override
  String get webShareFootnote =>
      'Escanea un código QR con un teléfono para intercambiar texto, fotos y archivos con esta computadora desde el navegador, sin instalar ninguna app. El teléfono y la computadora deben estar en la misma red.';

  @override
  String get webShareSwitch =>
      'Permitir que los teléfonos se conecten desde el navegador';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teléfonos',
      one: '1 teléfono',
    );
    return 'Activado, $_temp0';
  }

  @override
  String get webShareOff => 'Desactivado';

  @override
  String get webShareShowQr => 'Mostrar código QR';

  @override
  String get webShareDialogTitle => 'Escanea con tu teléfono';

  @override
  String get webShareDialogBody =>
      'Escanéalo con la cámara o el navegador del teléfono y ábrelo en el navegador. Cada código QR registra un teléfono y se reemplaza después de usarse.';

  @override
  String get webShareAddress => 'Dirección';

  @override
  String get webShareSecurity =>
      'El contenido se cifra en la página, así que otras personas de la red no pueden leerlo. Pero la página en sí es http y no puede impedir que alguien la manipule a propósito. Úsala en casa o en una red de oficina de confianza, no en una Wi-Fi pública.';

  @override
  String get webSharePhones => 'Teléfonos registrados';

  @override
  String get webShareNoPhones => 'Aún no hay teléfonos';

  @override
  String webShareLastUsed(String time) {
    return 'Último uso: $time';
  }

  @override
  String get webShareRemove => 'Quitar';

  @override
  String webShareRemoved(String name) {
    return 'Se quitó “$name”';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name” registrado';
  }

  @override
  String webShareNotListening(String error) {
    return 'No se pudo empezar a escuchar: $error';
  }

  @override
  String get webSharePortFallback =>
      'El puerto habitual está ocupado, así que se usa uno temporal. Las direcciones guardadas no se abrirán hasta que los teléfonos vuelvan a escanear.';

  @override
  String get webShareNoAddress =>
      'No hay dirección de red local. Conéctate primero a una Wi-Fi o a una red cableada.';

  @override
  String get webShareCantOpen =>
      'Si la página no se abre en el teléfono, comprueba que ambos estén en la misma red (las redes de invitados no suelen funcionar). En Windows, además hay que permitir PasteFerry en el firewall.';

  @override
  String get mTabRecords => 'Historial';

  @override
  String get mTabSend => 'Enviar';

  @override
  String get mThisPhone => 'Este teléfono';

  @override
  String get mThisPhoneInText => 'este teléfono';

  @override
  String mThisPhoneName(String name) {
    return 'Este teléfono: $name';
  }

  @override
  String get mSendTitle => 'Enviar a tu computadora';

  @override
  String get mSendHint => 'Escribe o pega texto';

  @override
  String get mPaste => 'Pegar';

  @override
  String get mPhotosFiles => 'Fotos o archivos';

  @override
  String mSendConfirmTitle(Object n) {
    return '¿Enviar $n archivo(s)?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n archivos enviados a tu computadora',
      one: '1 archivo enviado a tu computadora',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'No hay texto en el portapapeles';

  @override
  String get mSendAction => 'Enviar';

  @override
  String mSendTo(String names) {
    return 'Se enviará a $names';
  }

  @override
  String get mNoOnlineDevices => 'No hay dispositivos en línea cerca';

  @override
  String get mNoPairedDevices => 'Primero vincula una computadora';

  @override
  String get mSent => 'Enviado';

  @override
  String get mSendFootnote =>
      'El texto y los archivos van al historial de la computadora y, según su configuración, a su portapapeles. Lo que copias en el teléfono no se envía solo.';

  @override
  String get mSentRecords => 'Enviados';

  @override
  String get mSentRetention => 'Conservar enviados';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Enviados muestra lo que este teléfono envió en los últimos $d días';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d días';
  }

  @override
  String get mViewAll => 'Ver todo';

  @override
  String get mClearCache => 'Borrar';

  @override
  String get mCheckUpdate => 'Buscar actualizaciones';

  @override
  String get mUpdateFailed => 'No se pudo buscar actualizaciones';

  @override
  String get mUpToDate => 'Tienes la versión más reciente';

  @override
  String mNewVersion(Object v) {
    return 'La versión $v está disponible';
  }

  @override
  String get mDownloadInstall => 'Descargar la nueva versión';

  @override
  String mSendFailed(String detail) {
    return 'No se pudo enviar: $detail';
  }

  @override
  String get mCopy => 'Copiar';

  @override
  String get mCopied => 'Copiado al portapapeles de este teléfono';

  @override
  String get mShare => 'Compartir';

  @override
  String get mSaved => 'Guardado en Fotos o en Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'No funcionó: $detail';
  }

  @override
  String get mDownloading => 'Descargando…';

  @override
  String get mNotDownloaded => 'Aún no se ha descargado';

  @override
  String get mDownloadHint =>
      'Se descarga primero al tocar Copiar, Guardar o Compartir.';

  @override
  String get mFullTextLoading => 'Cargando…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Se muestran los primeros $shown de $total caracteres. Copiar copia todo el texto.';
  }

  @override
  String get mNotOnLanTitle => 'Sin Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Por ahora, PasteFerry solo sincroniza en la red local. Conéctate a la misma Wi-Fi que tu computadora.';

  @override
  String mStartFailed(String detail) {
    return 'PasteFerry no pudo iniciarse: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'En tu computadora, abre PasteFerry → Dispositivos → Agregar dispositivo y escribe aquí el código que muestra. En la misma Wi-Fi también puedes abrir “Buscar cerca” en los dos.';

  @override
  String get mSectionSync => 'Sincronización';

  @override
  String get mSectionBackground => 'Segundo plano';

  @override
  String get mAutoApplyDesc =>
      'El texto copiado en tu computadora va directamente al portapapeles de este teléfono. Las imágenes y los archivos esperan a que toques Copiar.';

  @override
  String get mKeepAlive => 'Mantener la conexión en segundo plano';

  @override
  String get mKeepAliveDesc =>
      'Recibe texto aunque PasteFerry no esté abierto. Muestra una notificación permanente.';

  @override
  String get mNotifications => 'Notificaciones';

  @override
  String get mNotificationsDesc =>
      'Necesarias para la notificación permanente. PasteFerry funciona sin ellas.';

  @override
  String get mBattery => 'Ejecutar en segundo plano';

  @override
  String get mBatteryDesc =>
      'Desactiva la optimización de batería para que el sistema no detenga PasteFerry con la pantalla bloqueada. En algunos teléfonos también hay que agregar PasteFerry a la lista de inicio automático o de ejecución en segundo plano en Ajustes.';

  @override
  String get mAllowed => 'Permitido';

  @override
  String get mAllow => 'Permitir';

  @override
  String mVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get mDeleteConfirm => '¿Eliminar este elemento?';

  @override
  String get mDelete => 'Eliminar';

  @override
  String get webShareFirewallPreparing =>
      'Comprobando el Firewall de Windows. Si Windows pide aprobación de administrador, elige Sí para que tu teléfono pueda conectarse.';

  @override
  String get webShareFirewallReady =>
      'Las reglas del Firewall de Windows están listas. Conecta tu teléfono a la misma red y escanea el código QR. Si aún no puede conectarse, vuelve a comprobar el firewall abajo.';

  @override
  String get webShareFirewallFailed =>
      'La configuración del firewall no terminó. Es posible que tu teléfono no pueda abrir la página. Inténtalo de nuevo y acepta el aviso de administrador de Windows.';

  @override
  String get webShareFirewallAllow =>
      'Comprobar y permitir conexiones del teléfono';

  @override
  String get mCopyMediaFailed =>
      'No se pudo copiar esta imagen o archivo. Intenta guardarlo primero.';

  @override
  String get mShareMediaFailed =>
      'No se pudo abrir el menú para compartir esta imagen o archivo. Intenta guardarlo primero.';

  @override
  String get mSaveMediaFailed =>
      'No se pudo guardar esta imagen o archivo. Comprueba el acceso al almacenamiento y el espacio libre, y vuelve a intentarlo.';

  @override
  String get noticeFilesUnreadable =>
      'No se pudieron leer los archivos que acabas de copiar, así que no se sincronizó nada';

  @override
  String get mAddMore => 'Agregar más';

  @override
  String get mChoosePhotos => 'Elegir fotos…';

  @override
  String get mMultiSelectHint =>
      'Selecciona varias fotos a la vez. En Archivos, mantén presionado un elemento para seleccionar más.';

  @override
  String get webSendFiles => 'Enviar archivos';

  @override
  String get webFilesQueued =>
      'Agregado a las transferencias web. Abre Enviar archivos en tu teléfono para descargarlo.';

  @override
  String get webFilesLimit =>
      'Las descargas web admiten hasta 200 MB por archivo y 64 archivos por envío.';

  @override
  String get appearance => 'Apariencia';

  @override
  String get settingsAppearanceSummary => 'Tema, claro y oscuro';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeDefault => 'Predeterminado';

  @override
  String get themePixel => 'Píxel';

  @override
  String get themeMode => 'Claro y oscuro';

  @override
  String get themeModeSystem => 'Según el sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get themeCustom => 'Personalizado';

  @override
  String get themeDelete => 'Eliminar tema';

  @override
  String themeDeleteConfirm(String name) {
    return '¿Eliminar el tema “$name”?';
  }

  @override
  String get themeLowContrast =>
      'Algunos textos de este tema pueden ser difíciles de leer';

  @override
  String get themeFootnote =>
      'Los temas se aplican solo a este dispositivo, incluido el pegado rápido. No se sincronizan con otros dispositivos.';

  @override
  String get themeBuiltinGroup => 'Integrados';

  @override
  String get themeCustomGroup => 'Personalizados';

  @override
  String get themeUse => 'Usar';

  @override
  String get themeDuplicate => 'Duplicar';

  @override
  String themeCopyName(String name) {
    return '$name (copia)';
  }

  @override
  String get themeExport => 'Exportar…';

  @override
  String get themeImport => 'Importar tema…';

  @override
  String themeImported(String name) {
    return 'Se importó “$name”';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colores de texto pueden ser difíciles de leer.',
      one: '1 color de texto puede ser difícil de leer.',
    );
    return 'Se importó “$name”. $_temp0';
  }

  @override
  String get themeExported => 'Tema exportado';

  @override
  String get themeCustomEmpty =>
      'Aún no hay temas personalizados. Duplica un tema integrado, importa uno o pide a una IA que cree uno.';

  @override
  String get themeAskAi => 'Pedir a una IA que cree un tema';

  @override
  String get themeAskAiBody =>
      'Agrega este servidor MCP a una app de IA como Claude o Cursor y pide un tema, por ejemplo “Hazme un tema cyberpunk”. La IA lee el formato del tema, elige los colores, comprueba el contraste y aplica el tema.';

  @override
  String get themeAskAiCopy => 'Copiar configuración';

  @override
  String get themeAskAiCopied => 'Configuración copiada';

  @override
  String get themeScanlines => 'Líneas de escaneo';

  @override
  String get themeScanlinesDesc =>
      'Superpone tenues líneas de escaneo de CRT en la ventana. Solo en temas de píxeles.';

  @override
  String get themeBackground => 'Imagen de fondo';

  @override
  String get themeBackgroundDesc =>
      'Llena la ventana detrás de la barra lateral y las páginas. Una capa encima mantiene el texto legible.';

  @override
  String get themeBackgroundChoose => 'Elegir imagen…';

  @override
  String get themeBackgroundChange => 'Cambiar…';

  @override
  String get themeBackgroundRemove => 'Quitar';

  @override
  String get themeBlur => 'Desenfoque';

  @override
  String get themeBlurNone => 'Ninguno';

  @override
  String get themeBlurLight => 'Suave';

  @override
  String get themeBlurStrong => 'Intenso';

  @override
  String get themeScrim => 'Capa';

  @override
  String get themeScrimDesc =>
      'Un color sobre la imagen para que el texto siga siendo legible. Nunca es más claro de lo que la imagen necesita.';

  @override
  String get themeScrimAuto => 'Automática';

  @override
  String get themeScrimMore => 'Más densa';

  @override
  String get themeScrimMost => 'La más densa';

  @override
  String get themePanels => 'Paneles';

  @override
  String get themePanelsDesc =>
      'Cuánto se ve la imagen a través de la barra lateral y las listas.';

  @override
  String get themePanelsClear => 'Transparentes';

  @override
  String get themePanelsMedium => 'Intermedios';

  @override
  String get themePanelsSolid => 'Opacos';

  @override
  String get themeAccentFromImage => 'Usar colores de la imagen';

  @override
  String get themeAccentFromImageDesc =>
      'Toma el color de énfasis de la imagen.';

  @override
  String get themeBackgroundPicker => 'Mostrar también en Pegado rápido';

  @override
  String get themeScenery => 'Mostrar paisaje';

  @override
  String get themeSceneryDesc =>
      'Las imágenes de la parte superior de las páginas y de la parte inferior de la barra lateral.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Los temas integrados no se pueden modificar, así que se creó y aplicó una copia llamada “$name”';
  }

  @override
  String get themeBackgroundFootnote =>
      'El fondo pertenece al tema actual. Los temas integrados no se pueden modificar: el primer cambio crea una copia. Las imágenes se quedan en este dispositivo; se admiten JPEG, PNG y GIF.';

  @override
  String get themeSceneGroup => 'Paisaje';

  @override
  String get themeSceneHeader => 'Encabezado de página';

  @override
  String get themeSceneHeaderDesc =>
      'Una imagen ancha detrás de los títulos de las páginas; su parte inferior se funde con la página. El tema Píxel dibuja aquí un paisaje pixelado.';

  @override
  String get themeSceneSidebar => 'Parte inferior de la barra lateral';

  @override
  String get themeSceneSidebarDesc =>
      'Una imagen pequeña en la parte inferior de la barra lateral. El tema Píxel dibuja aquí un pequeño campamento.';

  @override
  String get themeSceneReset => 'Restablecer';

  @override
  String get themeSceneFootnote =>
      'Cualquier tema puede mostrar aquí tus propias imágenes. Una capa mantiene legible el título de la página. El paisaje se oculta mientras una imagen de fondo llena la ventana.';

  @override
  String get starTitle => '¿Qué te parece PasteFerry?';

  @override
  String get starBody =>
      'Si te gusta, una estrella en GitHub significaría mucho.';

  @override
  String get starAction => 'Dar una estrella en GitHub';

  @override
  String get starLater => 'Más tarde';

  @override
  String get starDismiss => 'No volver a mostrar';
}
