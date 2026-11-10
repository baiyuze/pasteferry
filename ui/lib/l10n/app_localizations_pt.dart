// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'PasteFerry';

  @override
  String get navHistory => 'Histórico';

  @override
  String get navDevices => 'Dispositivos';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get linkConnecting => 'Conectando…';

  @override
  String get linkServiceNotRunning => 'Serviço parado';

  @override
  String get linkLanMode => 'Procurando dispositivos nesta rede';

  @override
  String get linkServerUnreachable =>
      'Servidor inacessível; sincronizando nesta rede';

  @override
  String get linkNothingOn =>
      'A descoberta na rede local está desativada e não há servidor definido';

  @override
  String get linkLanBlocked => 'O macOS está bloqueando a rede local';

  @override
  String linkOnlinePeers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivos on-line',
      one: '1 dispositivo on-line',
    );
    return '$_temp0';
  }

  @override
  String get linkServerConnected => 'Conectado ao servidor';

  @override
  String linkConnectionLost(String detail) {
    return 'Conexão perdida: $detail';
  }

  @override
  String get linkServiceDisconnected => 'Serviço desconectado';

  @override
  String get linkServiceDisabled =>
      'A sincronização em segundo plano está desativada';

  @override
  String get errServiceNotConnected =>
      'Sem conexão com o serviço em segundo plano';

  @override
  String get errUnimplemented => 'Ainda não disponível';

  @override
  String get errUnavailable =>
      'Não foi possível acessar o serviço em segundo plano';

  @override
  String errServiceStart(String detail) {
    return 'Não foi possível iniciar o serviço em segundo plano: $detail';
  }

  @override
  String errServiceRestart(String detail) {
    return 'Não foi possível reiniciar o serviço em segundo plano: $detail';
  }

  @override
  String errAutostart(String detail) {
    return 'Não foi possível abrir o PasteFerry ao iniciar a sessão: $detail';
  }

  @override
  String get thisMacTitle => 'Este Mac';

  @override
  String get thisPcTitle => 'Este computador';

  @override
  String get thisMacInText => 'este Mac';

  @override
  String get thisPcInText => 'este computador';

  @override
  String get bothMacs => 'ambos os Macs';

  @override
  String get bothDevices => 'ambos os dispositivos';

  @override
  String get thisDeviceShort => 'Este dispositivo';

  @override
  String fromDevice(String name) {
    return 'De $name';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get save => 'Salvar';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get continueAction => 'Continuar';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String secondsAgo(int n) {
    return 'Há $n s';
  }

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Há $n minutos',
      one: 'Há 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Há $n horas',
      one: 'Há 1 hora',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Há $n dias',
      one: 'Ontem',
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
      other: '$n dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get historyEmptySubtitle =>
      'Copie em qualquer um dos seus dispositivos e o conteúdo aparece aqui';

  @override
  String historyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String historyCountKept(int count, String ttl) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0 · retenção de $ttl';
  }

  @override
  String get filterAll => 'Tudo';

  @override
  String get filterText => 'Texto';

  @override
  String get filterImage => 'Imagens';

  @override
  String get filterFile => 'Arquivos';

  @override
  String get filterLink => 'Links';

  @override
  String get historyClearTooltip => 'Limpar histórico';

  @override
  String get historyEmptyTitle => 'Nada por aqui ainda';

  @override
  String get historyEmptyFilteredTitle => 'Nada deste tipo';

  @override
  String get historyEmptyBody =>
      'Copie um texto, uma imagem ou um arquivo em qualquer dispositivo pareado e ele aparece aqui.';

  @override
  String get clearConfirmTitle => 'Limpar todo o histórico?';

  @override
  String clearConfirmBody(String device) {
    return 'Tudo o que foi sincronizado dos seus dispositivos e os arquivos em cache serão removidos. Isso afeta só $device; os arquivos originais não são alterados.';
  }

  @override
  String get clear => 'Limpar';

  @override
  String get historyCleared => 'Histórico limpo';

  @override
  String get permDeniedTitle =>
      'O PasteFerry não consegue ler a área de transferência';

  @override
  String get permAskTitle =>
      'Permita que o PasteFerry leia a área de transferência';

  @override
  String get permDeniedBody =>
      'O que você copiar neste Mac não será sincronizado. Em Ajustes do Sistema, defina PasteFerry Daemon como Permitir.';

  @override
  String get permAskBody =>
      'Caso contrário, o macOS vai perguntar toda vez. Em Ajustes do Sistema, defina PasteFerry Daemon como Permitir.';

  @override
  String get openSystemSettings => 'Abrir Ajustes do Sistema';

  @override
  String get fetch => 'Receber';

  @override
  String get fetchStarted => 'Recebendo… Veja o progresso no Histórico';

  @override
  String get transferFailed => 'Falha na transferência';

  @override
  String get expired => 'Expirado';

  @override
  String get putOnClipboard => 'Copiar';

  @override
  String get putOnClipboardDone => 'Na área de transferência';

  @override
  String get deleteRecord => 'Apagar este item';

  @override
  String get deleted => 'Apagado';

  @override
  String get emptyRecord => '(vazio)';

  @override
  String get imageRecord => 'Imagem';

  @override
  String itemsSummary(String name, int others, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      others,
      locale: localeName,
      other: '$others itens',
      one: '1 item',
    );
    return '$name e mais $_temp0';
  }

  @override
  String get searchHint => 'Buscar textos e nomes de arquivos';

  @override
  String get searchClear => 'Limpar busca';

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
    return 'Nenhum resultado para “$query”';
  }

  @override
  String get searchEmptyBody =>
      'A busca procura nos textos copiados e nos nomes dos arquivos copiados.';

  @override
  String get favoriteAction => 'Adicionar aos Favoritos';

  @override
  String get unfavoriteAction => 'Remover dos Favoritos';

  @override
  String get favoritedToast => 'Adicionado aos Favoritos';

  @override
  String get unfavoritedToast => 'Devolvido ao Histórico';

  @override
  String get undo => 'Desfazer';

  @override
  String get favoriteSaving => 'Salvando…';

  @override
  String favoritedAt(String date) {
    return 'Salvo em $date';
  }

  @override
  String favoritesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0 · sem limpeza automática · até $size';
  }

  @override
  String get favoritesEmptyTitle => 'Nenhum favorito ainda';

  @override
  String get favoritesEmptyBody =>
      'Marque um item do Histórico com a estrela para guardar uma cópia aqui. Os Favoritos nunca são limpos automaticamente.';

  @override
  String get favoritesSearchHint => 'Buscar nos Favoritos';

  @override
  String favoriteLargeTitle(String size) {
    return 'Salvar uma cópia de $size?';
  }

  @override
  String favoriteLargeBody(String size, String device) {
    return 'Um favorito guarda uma cópia própria, então alterar ou apagar os arquivos originais não o afeta. Para isso, $device vai usar $size de espaço.';
  }

  @override
  String get saveCopy => 'Salvar cópia';

  @override
  String clearKeepsFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seus $count favoritos serão mantidos.',
      one: 'Seu favorito será mantido.',
    );
    return '$_temp0';
  }

  @override
  String get favoritesUsage => 'Favoritos';

  @override
  String get favoritesUsageDesc =>
      'Os Favoritos nunca são limpos, independentemente das configurações acima';

  @override
  String upToSize(String size) {
    return 'Até $size';
  }

  @override
  String detailChars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres',
      one: '1 caractere',
    );
    return '$_temp0';
  }

  @override
  String detailTruncated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caracteres no total',
      one: '1 caractere no total',
    );
    return '… $_temp0';
  }

  @override
  String detailMoreFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mais $count',
      one: 'mais 1',
    );
    return '$_temp0';
  }

  @override
  String get detailReceiveFirst => 'Selecione para baixar primeiro';

  @override
  String detailTotalSize(String size) {
    return '$size no total';
  }

  @override
  String get quickPaste => 'Colagem rápida';

  @override
  String get quickPasteWindow => 'Janela de colagem rápida';

  @override
  String get quickPasteWindowDesc =>
      'Pressione o atalho em qualquer app para abrir o histórico; escolha um item e ele é colado';

  @override
  String get quickPasteShortcut => 'Atalho';

  @override
  String get quickPasteRecord => 'Clique para alterar';

  @override
  String get quickPasteRecording => 'Pressione o novo atalho…';

  @override
  String get quickPasteUseDefault => 'Usar padrão';

  @override
  String get quickPasteNeedsModifier =>
      'Inclua ⌃, ⌥, ⇧ ou ⌘, ou use uma tecla de função';

  @override
  String get quickPasteNeedsModifierPc =>
      'Inclua Ctrl, Alt, Shift ou a tecla Windows, ou use uma tecla de função';

  @override
  String get quickPasteAfterPick => 'Ao escolher um item';

  @override
  String get quickPastePasteIt => 'Colar';

  @override
  String get quickPasteCopyIt => 'Só copiar';

  @override
  String get quickPasteIndexKey => 'Escolher um dos 9 primeiros';

  @override
  String get quickPasteIndexKeyDesc =>
      'Na janela de colagem rápida, mantenha esta tecla pressionada e pressione 1–9';

  @override
  String get quickPasteAccessibility => 'Acessibilidade';

  @override
  String get quickPasteAccessibilityDesc =>
      'Necessária para colar por você. Sem ela, os itens são copiados e você pressiona ⌘V.';

  @override
  String get quickPasteAllowed => 'Permitido';

  @override
  String get quickPasteAllow => 'Permitir…';

  @override
  String get quickPasteNotRunning =>
      'A janela de colagem rápida não está em execução';

  @override
  String quickPasteInUse(String key) {
    return '$key já é usado por outro app. Escolha outro atalho.';
  }

  @override
  String quickPasteHotkeyFailed(String key, String detail) {
    return 'Não foi possível definir $key: $detail';
  }

  @override
  String get quickPastePortalKey => 'Definido nos atalhos do sistema';

  @override
  String get quickPasteWaylandDesc =>
      'No Wayland, adicione o atalho nas configurações de teclado do seu desktop. Os itens escolhidos são copiados; pressione Ctrl+V para colar.';

  @override
  String get quickPasteAddShortcut => 'Adicionar atalho do sistema';

  @override
  String quickPasteShortcutAdded(String key) {
    return 'Adicionado. Pressione $key para testar.';
  }

  @override
  String quickPasteShortcutManual(String command) {
    return 'Adicione um atalho personalizado nas configurações de teclado do seu desktop que execute: $command';
  }

  @override
  String get pickerSearch => 'Buscar';

  @override
  String get pickerPaste => 'Colar';

  @override
  String get pickerPlainText => 'Texto simples';

  @override
  String get pickerCopyOnly => 'Só copiar';

  @override
  String get pickerUnfavoriteHint => 'Remover (volta ao Histórico)';

  @override
  String pickerPasteManually(String key) {
    return 'Os itens escolhidos são copiados — pressione $key para colar';
  }

  @override
  String get pickerGrantHint => 'Permita a Acessibilidade para colar direto';

  @override
  String pickerElevated(String key) {
    return 'Esta janela roda como administrador — pressione $key para colar depois de escolher';
  }

  @override
  String get pickerDownloading => 'Baixando — será colado ao terminar';

  @override
  String get imagePreviewTitle => 'Visualização da imagem';

  @override
  String get closePreview => 'Fechar visualização';

  @override
  String get previousImage => 'Imagem anterior';

  @override
  String get nextImage => 'Próxima imagem';

  @override
  String get previewHint =>
      'Role ou faça o gesto de pinça para ampliar; arraste para mover';

  @override
  String get fitWindow => 'Ajustar à janela';

  @override
  String get previewDeleted => 'Esta imagem foi apagada do histórico';

  @override
  String get previewExpired => 'Esta imagem expirou e não pode ser visualizada';

  @override
  String get previewDownloading => 'Baixando a imagem…';

  @override
  String get previewDownloadFailed => 'Falha no download. Tente de novo.';

  @override
  String get previewNotDownloaded =>
      'Esta imagem ainda não está neste computador';

  @override
  String get downloadAndPreview => 'Baixar e visualizar';

  @override
  String get previewUnavailable =>
      'Não é possível visualizar esta imagem agora';

  @override
  String get imageSemantic => 'Imagem do histórico';

  @override
  String get previewUnreadable =>
      'Não foi possível ler a imagem. O arquivo pode ter sido limpo ou estar danificado.';

  @override
  String get devicesSubtitleEmpty =>
      'Depois de pareados, seus dispositivos compartilham a mesma área de transferência';

  @override
  String devicesSubtitle(int paired, int online) {
    String _temp0 = intl.Intl.pluralLogic(
      paired,
      locale: localeName,
      other: '$paired pareados',
      one: '1 pareado',
    );
    return '$_temp0, $online on-line';
  }

  @override
  String get addDevice => 'Adicionar dispositivo';

  @override
  String thisDeviceFootnote(String both) {
    return 'Ao parear, $both mostram as mesmas duas linhas de impressões digitais de segurança, uma para cada dispositivo. Só confirme se forem idênticas, caractere por caractere.';
  }

  @override
  String get noDevicesTitle => 'Nenhum dispositivo pareado';

  @override
  String get noDevicesBody =>
      'Abra o PasteFerry no seu outro computador e conecte os dois com um código de pareamento de 6 caracteres. Na mesma rede, você também pode abrir Procurar por perto nos dois e clicar no outro.';

  @override
  String get pairedDevices => 'Dispositivos pareados';

  @override
  String get pairedFootnote =>
      'Direto: os dados vão diretamente de um dispositivo ao outro. Retransmissão: quando a rede bloqueia o caminho direto, os dados passam pelo seu servidor e continuam com criptografia de ponta a ponta.';

  @override
  String get offline => 'Off-line';

  @override
  String get direct => 'Direto';

  @override
  String get relay => 'Retransmissão';

  @override
  String get online => 'On-line';

  @override
  String get moreActions => 'Mais';

  @override
  String get copyFingerprint => 'Copiar impressão digital';

  @override
  String get unpairEllipsis => 'Desfazer pareamento…';

  @override
  String get fingerprintCopied => 'Impressão digital copiada';

  @override
  String unpairTitle(String name) {
    return 'Desfazer o pareamento com “$name”?';
  }

  @override
  String get unpairBody =>
      'Os dois dispositivos deixarão de sincronizar. Para voltar a sincronizar, será preciso pareá-los e conferir as impressões digitais de novo.';

  @override
  String get unpair => 'Desfazer pareamento';

  @override
  String get unpaired => 'Pareamento desfeito';

  @override
  String get enterAddressEllipsis => 'Inserir endereço…';

  @override
  String setAddressTitle(String name) {
    return 'Endereço de “$name”';
  }

  @override
  String setAddressBody(String name) {
    return 'Use quando os dois dispositivos estiverem em sub-redes diferentes ou ambos tiverem mudado de endereço. Insira o endereço mostrado em “$name”, em Adicionar dispositivo → Mostrar código.';
  }

  @override
  String get addressSaved => 'Procurando nesse endereço';

  @override
  String get lanBlockedTitle => 'O macOS está bloqueando a rede local';

  @override
  String lanBlockedBody(String device) {
    return 'Ative PasteFerry Daemon em Ajustes do Sistema → Privacidade e Segurança → Rede Local. Até lá, $device não consegue se conectar a dispositivos desta rede.';
  }

  @override
  String get searchNearby => 'Procurar por perto';

  @override
  String get nearbyTitle => 'Dispositivos próximos';

  @override
  String get nearbySearching => 'Procurando dispositivos próximos…';

  @override
  String get nearbyHint =>
      'Abra Procurar por perto também no outro computador e ele aparecerá aqui. Clique nele para parear.';

  @override
  String nearbyVisible(String device) {
    return 'Enquanto esta janela estiver aberta, os dispositivos desta rede podem ver $device pelo nome.';
  }

  @override
  String get nearbyPaired => 'Pareado';

  @override
  String nearbyRequesting(String name) {
    return 'Contatando “$name”…';
  }

  @override
  String nearbyNoReply(String name) {
    return '“$name” não respondeu. Verifique se Procurar por perto ainda está aberto nele.';
  }

  @override
  String get nearbyLanOffTitle => 'A descoberta na rede local está desativada';

  @override
  String get nearbyLanOffBody =>
      'Ative “Procurar dispositivos nesta rede” em Configurações → Conexão para ver dispositivos próximos, ou pareie com um código.';

  @override
  String get generateCode => 'Mostrar código';

  @override
  String get enterCode => 'Inserir código';

  @override
  String get codeFailedTitle =>
      'Não foi possível criar um código de pareamento';

  @override
  String get enterOnOther => 'Insira este código no seu outro dispositivo';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get codeHint => 'Clique para copiar. Válido por 5 minutos.';

  @override
  String afterEnterFootnote(String both) {
    return 'Depois que o código for inserido, $both mostram as mesmas duas linhas de impressões digitais de segurança. Só confirme se forem iguais.';
  }

  @override
  String get codeInvalid => 'O código de pareamento tem 6 letras ou números';

  @override
  String get localAddress => 'Endereço';

  @override
  String get addressHint =>
      'Em outra sub-rede? Insira também este endereço no outro dispositivo.';

  @override
  String get addressCopied => 'Endereço copiado';

  @override
  String get differentSubnet => 'Em outra sub-rede?';

  @override
  String get peerAddress => 'Endereço mostrado abaixo do código';

  @override
  String get pairNotFound =>
      'O dispositivo não foi encontrado. Se ele estiver em outra sub-rede, insira o endereço mostrado abaixo do código dele.';

  @override
  String get pairNotFoundAddress =>
      'Nada respondeu nesse endereço. Confira o endereço e se o outro dispositivo ainda está mostrando o código. Um firewall nesse dispositivo também pode estar bloqueando.';

  @override
  String get codeWrong => 'Código incorreto ou expirado';

  @override
  String get codeExpired =>
      'Este código expirou. Mostre um novo no outro dispositivo.';

  @override
  String get addressInvalid =>
      'Endereço inválido. Insira algo como 192.168.1.20.';

  @override
  String get pairNoChannel =>
      'Primeiro ative a descoberta na rede local ou defina um servidor em Configurações → Conexão.';

  @override
  String get enterCodeShown =>
      'Insira o código mostrado no seu outro dispositivo';

  @override
  String get pairingDone => 'Pareado';

  @override
  String get pairingRejected => 'Pareamento recusado';

  @override
  String get verifyTitle => 'Confira as impressões digitais de segurança';

  @override
  String pairingWith(String name) {
    return 'Pareando com “$name”';
  }

  @override
  String verifyBody(String both) {
    return 'As duas linhas em $both devem ser idênticas. Se um único caractere for diferente, alguém pode estar interferindo na conexão; nesse caso, recuse.';
  }

  @override
  String get rejectMismatch => 'Diferentes, recusar';

  @override
  String get confirmMatch => 'Iguais, parear';

  @override
  String get server => 'Servidor (opcional)';

  @override
  String get signalingUrl => 'Servidor de sinalização';

  @override
  String get signalingUrlDesc =>
      'Deixe em branco para sincronizar só na rede local';

  @override
  String get signalingUrlPlaceholder => 'ws://endereço-do-servidor:8787/signal';

  @override
  String get publicStun => 'Melhorar conexões diretas';

  @override
  String get publicStunDesc => 'Servidores públicos podem ver seu IP público';

  @override
  String get connectionStatus => 'Conexão';

  @override
  String get disconnectedDesc =>
      'Verifique o endereço e se o servidor está disponível';

  @override
  String get connected => 'Conectado';

  @override
  String get notConnected => 'Não conectado';

  @override
  String get notSet => 'Não definido';

  @override
  String get serverCleared => 'Servidor removido. Sincronizando só nesta rede.';

  @override
  String get localNetwork => 'Rede local';

  @override
  String get lanDiscovery => 'Procurar dispositivos nesta rede';

  @override
  String get lanDiscoveryDesc =>
      'Descoberta anônima; os nomes só aparecem durante Procurar por perto';

  @override
  String get macLocalNetwork => 'Acesso à Rede Local';

  @override
  String get macLocalNetworkDesc =>
      'Permita PasteFerry Daemon em Ajustes do Sistema';

  @override
  String get allowLan => 'Firewall do Windows';

  @override
  String get allowLanDesc =>
      'Libera conexões bloqueadas; requer aprovação do administrador';

  @override
  String get allow => 'Permitir';

  @override
  String get allowLanDone =>
      'Permitido. Outros dispositivos agora conseguem acessar este.';

  @override
  String get deviceName => 'Nome do dispositivo';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get sync => 'Sincronização';

  @override
  String get autoSyncLimit => 'Limite de sincronização automática';

  @override
  String get autoSyncLimitDesc =>
      'Itens maiores são recebidos manualmente pelo Histórico';

  @override
  String get autoApply => 'Colocar itens recebidos na área de transferência';

  @override
  String get whatToSync => 'O que sincronizar';

  @override
  String get syncFiles => 'Arquivos e pastas';

  @override
  String get syncText => 'Texto simples';

  @override
  String get syncRich => 'Texto formatado';

  @override
  String get syncImages => 'Imagens e capturas de tela';

  @override
  String get storage => 'Armazenamento';

  @override
  String get storageFootnote =>
      'O histórico expirado e os arquivos em cache são apagados automaticamente.';

  @override
  String get keepHistory => 'Manter histórico por';

  @override
  String get keepCache => 'Manter arquivos em cache por';

  @override
  String get keepCacheDesc => 'Não mais que a retenção do histórico';

  @override
  String get cacheUsage => 'Tamanho do cache';

  @override
  String get backgroundSync => 'Sincronização em segundo plano';

  @override
  String get backgroundService => 'Serviço em segundo plano';

  @override
  String get backgroundServiceDesc =>
      'Inicia com a sessão; sincroniza mesmo com a janela fechada';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restarted => 'Serviço em segundo plano reiniciado';

  @override
  String get disableEllipsis => 'Desativar…';

  @override
  String get about => 'Sobre';

  @override
  String get aboutDesc => 'Código aberto sob a licença AGPL-3.0';

  @override
  String get homepage => 'Site';

  @override
  String get feedback => 'Relatar um problema';

  @override
  String get disableTitle => 'Desativar a sincronização em segundo plano?';

  @override
  String disableBody(String device) {
    return 'Com isso, $device vai parar de sincronizar e o PasteFerry não abrirá mais ao iniciar a sessão. O histórico e os pareamentos são mantidos.';
  }

  @override
  String get disable => 'Desativar';

  @override
  String get disabled => 'A sincronização em segundo plano está desativada';

  @override
  String get urlMustBeWs => 'O endereço deve começar com ws:// ou wss://';

  @override
  String get serverUpdated => 'Servidor atualizado. Reconectando…';

  @override
  String get deviceNameUpdated => 'Nome do dispositivo atualizado';

  @override
  String get diagIntro =>
      'Este relatório contém a versão do app, seu sistema, configurações, dispositivos e registros recentes. Nomes de dispositivos, o endereço do servidor, endereços IP públicos, sua pasta de usuário e nomes de arquivos são substituídos, e o que você copia nunca é gravado nos registros. Os issues no GitHub são públicos, então leia tudo antes de publicar.';

  @override
  String get diagVerboseTitle => 'Registro detalhado';

  @override
  String get diagVerboseDesc =>
      'Para problemas de conexão: ative, faça o problema acontecer de novo e volte aqui para gerar o relatório. Ele se desativa sozinho após 30 minutos.';

  @override
  String get diagVerboseOn => 'Ativar por 30 minutos';

  @override
  String diagVerboseUntil(String time) {
    return 'Ativado até $time';
  }

  @override
  String get diagVerboseOff => 'Desativar';

  @override
  String get diagRefresh => 'Gerar de novo';

  @override
  String get diagSave => 'Salvar como arquivo';

  @override
  String diagSaved(String name) {
    return 'Salvo na pasta Downloads: $name';
  }

  @override
  String get diagCopy => 'Copiar relatório';

  @override
  String get diagCopied => 'Relatório copiado';

  @override
  String get diagNewIssue => 'Novo issue no GitHub';

  @override
  String get diagIssueHint =>
      'Relatório copiado. Cole-o no campo “Diagnostics report” do issue.';

  @override
  String diagFailed(String detail) {
    return 'Não foi possível criar o relatório: $detail';
  }

  @override
  String get svcExtractTitle => 'Instale ou extraia o PasteFerry primeiro';

  @override
  String get svcExtractBody =>
      'O PasteFerry está sendo executado direto do arquivo zip, e a pasta temporária dele some quando você o fecha. Execute o instalador, ou extraia a pasta inteira e abra o app a partir dela, para ativar a sincronização em segundo plano.';

  @override
  String get svcMoveTitle => 'Mova o PasteFerry para Aplicativos primeiro';

  @override
  String get svcMoveBody =>
      'O PasteFerry está sendo executado direto da imagem de disco. Arraste-o para Aplicativos, ejete a imagem de disco e abra-o a partir de Aplicativos para ativar a sincronização em segundo plano.';

  @override
  String get svcStartTitle => 'Comece a usar o PasteFerry';

  @override
  String get svcStartBody =>
      'O PasteFerry roda um pequeno processo em segundo plano para sincronizar a área de transferência. Fechar a janela não o encerra. Abrir ao iniciar a sessão é um ajuste separado, desativado em novas instalações.';

  @override
  String get svcEnable => 'Ativar sincronização em segundo plano';

  @override
  String get svcStaleTitle => 'Ative de novo a sincronização em segundo plano';

  @override
  String get svcStaleBodyWin =>
      'O PasteFerry mudou de lugar, mas a inicialização com a sessão ainda aponta para o local antigo. Ative de novo para que o processo em segundo plano use esta cópia. O histórico e os pareamentos são mantidos.';

  @override
  String get svcStaleBodyMac =>
      'O PasteFerry mudou de lugar ou foi instalado com um script antigo. Ative de novo para que o processo em segundo plano use este app. O histórico e os pareamentos são mantidos.';

  @override
  String get svcReenable => 'Ativar de novo';

  @override
  String get svcStoppedTitle =>
      'O serviço em segundo plano não está em execução';

  @override
  String get svcStoppedBody =>
      'O serviço em segundo plano está parado. Inicie-o com o botão abaixo; abrir ao iniciar a sessão é controlado separadamente nas Configurações.';

  @override
  String get svcDevBodyWin =>
      'Esta é uma versão de desenvolvimento sem o pasteferryd.exe ao lado. Execute scripts\\build-windows.ps1 na pasta do código-fonte para gerar uma versão completa.';

  @override
  String get svcDevBodyLinux =>
      'Esta é uma versão de desenvolvimento sem o pasteferryd ao lado. Execute ./scripts/package-linux.sh na pasta do código-fonte para gerar uma versão completa.';

  @override
  String get svcDevBodyMac =>
      'Esta é uma versão de desenvolvimento sem o serviço em segundo plano. Execute ./scripts/install-macos.sh na pasta do código-fonte para instalá-lo.';

  @override
  String svcLogPath(String path) {
    return 'Registro: $path';
  }

  @override
  String get svcCanDisable =>
      'Você pode desativar a sincronização em segundo plano a qualquer momento nas Configurações.';

  @override
  String get officialService => 'Serviço';

  @override
  String get useOfficialService => 'Usar o serviço';

  @override
  String get officialServiceDesc =>
      'Sincroniza entre redes, priorizando conexões diretas';

  @override
  String get officialPrivacy =>
      'Conecta-se ao serviço só quando ativado e registra as informações de conexão essenciais. As conexões diretas são tentadas primeiro; a retransmissão só é solicitada se elas falharem. Conteúdo, nomes reais de dispositivos e identificadores brutos do sistema não são enviados.';

  @override
  String get officialEnableTitle => 'Ativar o serviço?';

  @override
  String get officialSwitchConfirm =>
      'Isso deixa de usar seu servidor personalizado. O endereço salvo dele será mantido.';

  @override
  String get customServer => 'Servidor personalizado';

  @override
  String get saveAndConnect => 'Salvar e conectar';

  @override
  String get officialLoading => 'Verificando a cota…';

  @override
  String get officialFetchFailed =>
      'Não é possível obter a cota agora. Uma nova tentativa será feita automaticamente.';

  @override
  String get officialUnavailable =>
      'Uso indisponível; os dados atuais podem estar desatualizados';

  @override
  String get officialQuotaTitle => 'Cota diária de retransmissão esgotada';

  @override
  String get officialQuotaBody =>
      'A retransmissão do serviço está pausada até a renovação diária, à meia-noite no horário de Pequim. A rede local e as conexões diretas pela internet continuam disponíveis. Transferências com falha podem ser repetidas mais tarde.';

  @override
  String get officialPeerQuota =>
      'O outro dispositivo não tem mais cota de retransmissão. As conexões diretas continuam disponíveis.';

  @override
  String get officialPaused =>
      'A retransmissão do serviço está indisponível. As conexões diretas continuam disponíveis.';

  @override
  String get officialViewUsage => 'Ver uso';

  @override
  String get officialAcknowledge => 'Entendi';

  @override
  String get officialToday => 'Cota de retransmissão de hoje';

  @override
  String get officialUsed => 'Usado';

  @override
  String get officialRemaining => 'Restante';

  @override
  String get officialDailyLimit => 'Cota diária';

  @override
  String get officialUpload => 'Envio';

  @override
  String get officialDownload => 'Download';

  @override
  String get officialReset => 'Renovação (horário de Pequim)';

  @override
  String get officialUpdated => 'Última atualização';

  @override
  String get officialRoutes => 'Como os dispositivos se conectam';

  @override
  String get officialRoutesFootnote =>
      'Conexões diretas não passam pela retransmissão do serviço e não usam a cota.';

  @override
  String get officialDeviceID => 'ID do dispositivo';

  @override
  String get officialWarning =>
      '90% da cota diária de retransmissão já foi usada. Conexões diretas não a consomem.';

  @override
  String get updateCheck => 'Verificar atualizações';

  @override
  String get updateCheckEllipsis => 'Verificar atualizações…';

  @override
  String get updateAuto => 'Verificar atualizações automaticamente';

  @override
  String get updateChecking => 'Verificando atualizações…';

  @override
  String updateUpToDate(String version) {
    return 'O PasteFerry $version é a versão mais recente.';
  }

  @override
  String updateAvailableTitle(String version) {
    return 'PasteFerry $version disponível';
  }

  @override
  String updateCurrentSize(String current, String size) {
    return 'Você tem a versão $current. Tamanho do download: $size.';
  }

  @override
  String get updateNew => 'Novidades';

  @override
  String get updateFixed => 'Correções';

  @override
  String get updateSkip => 'Pular esta versão';

  @override
  String get updateLater => 'Mais tarde';

  @override
  String get updateInstall => 'Baixar e instalar';

  @override
  String updateDownloading(String done, String total) {
    return 'Baixando $done de $total';
  }

  @override
  String get updateVerifying => 'Verificando o download…';

  @override
  String get updateInstalling =>
      'Instalando. O PasteFerry vai abrir de novo sozinho.';

  @override
  String get updateInstallingPassword =>
      'Instalando. O sistema vai pedir sua senha, porque /opt exige direitos de administrador; depois o PasteFerry abre de novo sozinho.';

  @override
  String get updateCheckFailed =>
      'Não foi possível acessar o GitHub nem o Gitee. Tente de novo mais tarde.';

  @override
  String get updateDownloadFailed =>
      'O download não foi concluído. Tente de novo ou baixe a nova versão no site.';

  @override
  String updateInstallFailed(String error) {
    return 'Não foi possível iniciar a instalação: $error';
  }

  @override
  String get updateUnsupportedBuild =>
      'Esta versão não pode verificar atualizações.';

  @override
  String get updateBlockedDev =>
      'Esta é uma versão de desenvolvimento, por isso não pode se atualizar sozinha.';

  @override
  String get updateBlockedMustMove =>
      'O PasteFerry está sendo executado da imagem de disco. Arraste-o para Aplicativos e abra-o de lá para atualizar automaticamente.';

  @override
  String get updateBlockedReadOnly =>
      'O PasteFerry não consegue gravar na pasta onde está instalado. Baixe a nova versão no site.';

  @override
  String get updateBlockedUnsupported =>
      'Não há atualização automática para este computador. Baixe a nova versão no site.';

  @override
  String get updateOpenDownload => 'Abrir página de download';

  @override
  String updateSidebar(String version) {
    return 'Versão $version disponível';
  }

  @override
  String updatedTo(String version) {
    return 'Atualizado para $version';
  }

  @override
  String updateNotFinished(String version) {
    return 'A atualização não foi concluída. Você continua na versão $version.';
  }

  @override
  String updateNotFinishedWhy(String version, String detail) {
    return 'A atualização não foi concluída. Você continua na versão $version. $detail';
  }

  @override
  String buildDetails(String uiVersion, String serviceVersion, String build) {
    return 'Interface $uiVersion · Serviço $serviceVersion · Build $build';
  }

  @override
  String get notReceived => 'Não recebido — receba antes de colar';

  @override
  String get receivedPreserved =>
      'Recebido; use Copiar para a área de transferência quando quiser';

  @override
  String get clipboardWriteFailed =>
      'Recebido, mas não foi possível atualizar a área de transferência';

  @override
  String get receivingStatus => 'Recebendo…';

  @override
  String get largeFileNotifications => 'Lembretes de arquivos grandes';

  @override
  String get notificationsAllowed =>
      'As notificações estão ativadas. O progresso aparece no Histórico.';

  @override
  String get notificationsNotRequested =>
      'Ative as notificações para que arquivos grandes não fiquem esperando sem aviso. Você sempre pode recebê-los pelo Histórico.';

  @override
  String get notificationsDenied =>
      'As notificações estão bloqueadas nas configurações do sistema. Receba os itens pendentes pelo Histórico.';

  @override
  String get notificationsUnknown =>
      'Seu desktop controla a exibição de notificações e o modo Não Perturbe. Se nenhum lembrete aparecer, receba os itens pelo Histórico.';

  @override
  String get notificationsUnavailable =>
      'As notificações do sistema não estão disponíveis. Receba arquivos grandes pelo Histórico.';

  @override
  String get enableNotifications => 'Ativar lembretes';

  @override
  String get notificationSettings => 'Configurações de notificação';

  @override
  String get notifyPendingTitle => 'Receba para colar';

  @override
  String notifyPendingBody(String device, String name, String size) {
    return '$device · $name · $size\nReceba este item antes de colar. Você também pode recebê-lo pelo Histórico.';
  }

  @override
  String get notifyReceivingTitle => 'Recebendo…';

  @override
  String notifyReceivingBody(String name) {
    return '$name\nVeja o progresso no Histórico.';
  }

  @override
  String get notifyReadyTitle => 'Pronto para colar';

  @override
  String notifyReadyBody(String name) {
    return '$name\nRecebido e colocado na área de transferência.';
  }

  @override
  String get notifyReceivedTitle => 'Recebido';

  @override
  String notifyReceivedBody(String name) {
    return '$name\nSua área de transferência foi mantida. Use Copiar para a área de transferência quando quiser; isso também está disponível no Histórico.';
  }

  @override
  String get notifyFailedTitle => 'Não foi possível receber';

  @override
  String notifyFailedBody(String name, String error) {
    return '$name\n$error\nTente de novo por esta notificação ou pelo Histórico.';
  }

  @override
  String get notifyClipboardFailedTitle =>
      'Recebido; área de transferência não atualizada';

  @override
  String notifyClipboardFailedBody(String name, String error) {
    return '$name\n$error\nUse Copiar para a área de transferência para tentar de novo, aqui ou no Histórico.';
  }

  @override
  String get reconnect => 'Reconectar';

  @override
  String get reconnecting => 'Conectando…';

  @override
  String get reconnectDirect => 'Conectado diretamente';

  @override
  String get reconnectRelay =>
      'Não foi possível conectar diretamente; a retransmissão continua em uso';

  @override
  String reconnectOffline(String name) {
    return '“$name” está off-line. Verifique se o PasteFerry está aberto nele.';
  }

  @override
  String get reconnectPending =>
      'Ainda conectando; confira de novo daqui a pouco';

  @override
  String get renameAction => 'Renomear';

  @override
  String get renameFavoriteTitle => 'Renomear favorito';

  @override
  String get renameFavoriteHint =>
      'Aparece nos Favoritos e na colagem rápida, e você pode buscá-lo. Deixe em branco para voltar a mostrar o conteúdo.';

  @override
  String get renamedToast => 'Renomeado';

  @override
  String get aliasClearedToast => 'Mostrando o conteúdo de novo';

  @override
  String get navSend => 'Enviar arquivos';

  @override
  String get sendSubtitle =>
      'Arraste arquivos até um dispositivo para enviá-los diretamente';

  @override
  String get sendNoDevicesTitle => 'Nenhum dispositivo pareado';

  @override
  String get sendNoDevicesBody =>
      'Primeiro pareie outro computador; depois envie arquivos para ele aqui.';

  @override
  String get sendDropHint => 'Solte sobre um dispositivo para enviar';

  @override
  String sendReleaseTo(String name) {
    return 'Solte para enviar para $name';
  }

  @override
  String get sendLan => 'Rede local';

  @override
  String sendRelayLeft(String left) {
    return 'Retransmissão · restam $left hoje';
  }

  @override
  String get sendNeedsUpdate => 'Precisa atualizar';

  @override
  String sendNeedsUpdateTip(String name) {
    return '$name poderá receber arquivos depois de atualizar para o PasteFerry 2.5 ou mais recente.';
  }

  @override
  String sendConnectingTip(String name) {
    return 'Conectando a $name. Você poderá enviar assim que conectar.';
  }

  @override
  String get sendNotReceiving => 'Não recebe arquivos';

  @override
  String get sendDelivered => 'Entregue';

  @override
  String sendToTitle(String name) {
    return 'Enviar para $name';
  }

  @override
  String get sendDropHere => 'Arraste arquivos ou pastas para cá';

  @override
  String get sendDropStarts => 'O envio começa assim que você soltar';

  @override
  String get sendChooseFiles => 'Escolher arquivos…';

  @override
  String get sendChooseFolder => 'Escolher pasta…';

  @override
  String get sendDropMore => 'Solte mais arquivos para enviá-los em seguida';

  @override
  String sendSavedWhere(String name) {
    return 'Os arquivos são salvos onde $name definir — por padrão, na pasta Downloads.';
  }

  @override
  String get sendCloseKeeps => 'Fechar esta janela não interrompe o envio';

  @override
  String get sendRemoveQueued => 'Remover';

  @override
  String get sendCannotDrop =>
      'Este item não pode ser enviado arrastando. Salve-o como arquivo primeiro ou use Escolher arquivos….';

  @override
  String sendErrOffline(String name) {
    return '$name está off-line.';
  }

  @override
  String sendErrDisabled(String name) {
    return '$name não está recebendo arquivos.';
  }

  @override
  String get sendErrMissing => 'Alguns destes arquivos não existem mais.';

  @override
  String get relayConfirmTitle => 'Enviar pela retransmissão do serviço?';

  @override
  String relayConfirmBody(String name, String left) {
    return '$name não tem conexão direta com este computador agora, então os arquivos passam pela retransmissão do serviço a cerca de 0,25 MB/s. Restam $left da cota de retransmissão de hoje.';
  }

  @override
  String relayConfirmOver(String size) {
    return 'Estes arquivos ($size) ultrapassam a cota restante. O envio pausa quando ela acabar e continua quando os dois computadores se conectarem diretamente ou a cota for renovada amanhã.';
  }

  @override
  String relayConfirmWithin(String size) {
    return 'Isso usa cerca de $size da cota de hoje.';
  }

  @override
  String get relayExhausted =>
      'A cota de retransmissão de hoje acabou. Ela é renovada à meia-noite no horário de Pequim. Computadores conectados diretamente não têm limite.';

  @override
  String get relayDontAskToday =>
      'Não perguntar de novo hoje para este dispositivo';

  @override
  String get relaySendAnyway => 'Enviar mesmo assim';

  @override
  String get relayOwnServer =>
      'Retransmitido — a velocidade depende do seu servidor';

  @override
  String get transfersReceived => 'Recebidos';

  @override
  String get transfersSent => 'Enviados';

  @override
  String get transfersClearAll => 'Limpar tudo';

  @override
  String get transfersClearTitle => 'Limpar esta lista?';

  @override
  String get transfersClearBody =>
      'Só a lista é limpa. Os arquivos continuam onde estão.';

  @override
  String get transfersEmptyReceived =>
      'Os arquivos que outros dispositivos enviarem para você aparecem aqui';

  @override
  String get transfersEmptySent => 'Os arquivos que você enviar aparecem aqui';

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
      other: '$others itens',
      one: '1 item',
    );
    return '$name e mais $_temp0';
  }

  @override
  String transferFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos',
      one: '1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get transferQueued => 'Na fila';

  @override
  String transferScanning(String count) {
    return 'Contando… $count arquivos encontrados';
  }

  @override
  String transferWaitingPeer(String name) {
    return 'Aguardando $name…';
  }

  @override
  String get transferSending => 'Enviando';

  @override
  String get transferReceiving => 'Recebendo';

  @override
  String transferCurrent(String file, String index, String total) {
    return 'Agora: $file ($index de $total)';
  }

  @override
  String transferLeft(String time) {
    return 'Faltam $time';
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
      'Pausado: a cota de retransmissão de hoje acabou';

  @override
  String get transferInterrupted => 'Interrompido — continua ao reconectar';

  @override
  String transferInterruptedIncoming(String name) {
    return 'Interrompido — aguardando $name continuar';
  }

  @override
  String get transferCancelled => 'Cancelado';

  @override
  String transferPeerCancelled(String name) {
    return 'Cancelado por $name';
  }

  @override
  String get transferExpired => 'Expirado';

  @override
  String get transferMissing => 'Movido ou apagado';

  @override
  String transferNotSent(String reason) {
    return 'Não enviado: $reason';
  }

  @override
  String transferNotReceived(String reason) {
    return 'Não recebido: $reason';
  }

  @override
  String reasonNoSpacePeer(String name, String size) {
    return '$name está sem espaço em disco (faltam $size)';
  }

  @override
  String reasonNoSpace(String size) {
    return 'não há espaço suficiente em disco (faltam $size)';
  }

  @override
  String reasonDestUnavailablePeer(String name) {
    return 'o local para salvar de $name não está disponível';
  }

  @override
  String get reasonDestUnavailable =>
      'o local para salvar não está disponível — verifique-o nas Configurações';

  @override
  String get reasonFileTooLarge =>
      'o local para salvar fica em uma unidade FAT32, que não aceita arquivos com mais de 4 GB';

  @override
  String reasonDisabledPeer(String name) {
    return '$name não está recebendo arquivos';
  }

  @override
  String get reasonSourceChanged => 'um arquivo foi alterado durante o envio';

  @override
  String get reasonSourceMissing => 'um arquivo não existe mais';

  @override
  String get reasonReadError => 'não foi possível ler um arquivo';

  @override
  String get reasonWriteFailed => 'não foi possível gravar os arquivos';

  @override
  String get reasonHashMismatch =>
      'um arquivo foi danificado durante a transferência';

  @override
  String reasonUnsupported(String name) {
    return '$name precisa atualizar para receber arquivos';
  }

  @override
  String get reasonOther => 'algo deu errado';

  @override
  String get revealInFinder => 'Mostrar no Finder';

  @override
  String get revealInFolder => 'Mostrar na pasta';

  @override
  String get revealOpenFolder => 'Abrir pasta';

  @override
  String get transferResend => 'Enviar de novo';

  @override
  String get transferRemove => 'Remover da lista';

  @override
  String get transferCopyPath => 'Copiar caminho';

  @override
  String get transferPathCopied => 'Caminho copiado';

  @override
  String sendingTo(String name, String percent) {
    return 'Enviando para $name · $percent';
  }

  @override
  String receivingFrom(String name, String percent) {
    return 'Recebendo de $name · $percent';
  }

  @override
  String get receiveFiles => 'Receber arquivos de outros dispositivos';

  @override
  String get saveTo => 'Salvar em';

  @override
  String get saveToChange => 'Alterar…';

  @override
  String get saveToDefault => 'Downloads (padrão)';

  @override
  String get saveToUseDefault => 'Usar Downloads';

  @override
  String get receiveNotify => 'Notificar quando chegarem arquivos';

  @override
  String receiveFootnote(String device) {
    return 'Só dispositivos pareados podem enviar arquivos para $device. Enquanto houver transferências em andamento, $device não entra em repouso sozinho.';
  }

  @override
  String get saveDirNotFound => 'Esta pasta não existe.';

  @override
  String get saveDirNotWritable =>
      'O PasteFerry não consegue salvar arquivos nesta pasta.';

  @override
  String get saveDirPermission =>
      'O PasteFerry não tem permissão para usar esta pasta. Permita em Ajustes do Sistema → Privacidade e Segurança → Arquivos e Pastas.';

  @override
  String transferRenamed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count nomes de arquivo tinham caracteres que o Windows não aceita; eles foram trocados por caracteres de largura total parecidos',
      one:
          '1 nome de arquivo tinha caracteres que o Windows não aceita; eles foram trocados por caracteres de largura total parecidos',
    );
    return '$_temp0';
  }

  @override
  String get sendRingLan => 'Mesma rede';

  @override
  String get sendRingOther => 'Outras redes';

  @override
  String sendOfflineList(String names) {
    return 'Off-line: $names';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get sendLayout => 'Lista de transferências';

  @override
  String get sendLayoutSide => 'Ao lado do radar';

  @override
  String get sendLayoutBelow => 'Abaixo do radar';

  @override
  String get general => 'Geral';

  @override
  String get launchAtLogin => 'Abrir ao iniciar a sessão';

  @override
  String get launchAtLoginDesc =>
      'Inicia em segundo plano quando você entra na sessão. Alterar isto não encerra a execução atual.';

  @override
  String get realtimeSync => 'Sincronização em tempo real';

  @override
  String get realtimeSyncDesc =>
      'Compartilha automaticamente o que você copiar com os dispositivos pareados. Quando desativado, o histórico local e Enviar arquivos continuam disponíveis.';

  @override
  String get syncBacklog => 'Pôr em dia ao reconectar';

  @override
  String get syncBacklogDesc =>
      'Desativado por padrão: o que foi copiado enquanto off-line é ignorado. Quando ativado, até 20 itens das últimas 24 horas entram no histórico sem substituir a área de transferência.';

  @override
  String get peerRealtimeSync => 'Sincronizar com este computador';

  @override
  String get syncPaused => 'Sincronização da área de transferência pausada';

  @override
  String get quitApp => 'Sair do PasteFerry';

  @override
  String get quitAppDesc =>
      'Encerra todos os processos do PasteFerry. Sua preferência de abrir ao iniciar a sessão é mantida.';

  @override
  String get quitTransfersWarning =>
      'Ainda há arquivos sendo transferidos. Sair e interromper essas transferências?';

  @override
  String get backgroundRunningTitle => 'O PasteFerry continuará em execução';

  @override
  String get backgroundRunningBody =>
      'Fechar a janela mantém a sincronização e a colagem rápida funcionando. Para parar tudo, escolha Sair do PasteFerry nas Configurações ou no menu do app.';

  @override
  String get displayAs => 'Exibido como';

  @override
  String get editName => 'Alterar nome';

  @override
  String get nameHint => 'O nome que seus contatos veem';

  @override
  String get nameDefaultHint =>
      'Deixe em branco para usar o nome da sua conta.';

  @override
  String get avatarTitle => 'Foto do perfil';

  @override
  String get avatarChoose => 'Escolher imagem…';

  @override
  String get avatarPaste => 'Colar imagem';

  @override
  String get avatarReset => 'Usar foto padrão';

  @override
  String get avatarZoom => 'Zoom';

  @override
  String get avatarDragHint => 'Arraste para mover a imagem.';

  @override
  String get avatarNoImage => 'Não há imagem na área de transferência.';

  @override
  String get avatarBad =>
      'Esta imagem não pode ser usada. Escolha um PNG, JPEG ou GIF.';

  @override
  String get done => 'OK';

  @override
  String get friendsTitle => 'Contatos';

  @override
  String get addFriend => 'Adicionar contato';

  @override
  String get friendsEmpty => 'Nenhum contato ainda';

  @override
  String get friendsEmptyBody =>
      'Adicione alguém que também use o PasteFerry para trocar arquivos sem parear. Contatos só podem enviar arquivos; eles nunca veem sua área de transferência.';

  @override
  String get friendSendAction => 'Enviar…';

  @override
  String get friendHistory => 'Transferências';

  @override
  String friendHistoryTitle(String name) {
    return 'Transferências com $name';
  }

  @override
  String get friendHistoryEmpty => 'Nenhuma transferência ainda.';

  @override
  String get friendAutoAccept => 'Aceitar arquivos automaticamente';

  @override
  String get friendRemove => 'Remover contato';

  @override
  String friendRemoveTitle(String name) {
    return 'Remover $name?';
  }

  @override
  String get friendRemoveBody =>
      'Vocês serão removidos dos contatos um do outro e não poderão mais trocar arquivos. As transferências anteriores continuam neste computador.';

  @override
  String friendLastActivity(String time) {
    return 'Última transferência: $time';
  }

  @override
  String get friendNoActivity => 'Nenhuma transferência ainda';

  @override
  String get friendCodeShare =>
      'Envie este código ao seu contato. Quando ele o inserir no PasteFerry, vocês serão adicionados aos contatos um do outro.';

  @override
  String friendCodeExpires(String time) {
    return 'Expira em $time';
  }

  @override
  String get friendCodeOr => 'ou';

  @override
  String get friendCodeEnter => 'Inserir o código de contato da outra pessoa';

  @override
  String get friendCodeAdd => 'Adicionar';

  @override
  String get friendCodeWaiting => 'Aguardando a outra pessoa inserir…';

  @override
  String friendConfirmBody(String name) {
    return 'Adicionar $name aos seus contatos?';
  }

  @override
  String get friendSafetyCode => 'Conferir código de segurança (opcional)';

  @override
  String get friendSafetyHint =>
      'Quando estiverem juntos, comparem estas duas linhas. Se forem iguais nos dois computadores, ninguém interferiu.';

  @override
  String get friendWaitingPeer => 'Aguardando a outra pessoa adicionar você…';

  @override
  String friendAdded(String name) {
    return '$name foi adicionado aos seus contatos';
  }

  @override
  String friendPeerCancelled(String name) {
    return '$name cancelou';
  }

  @override
  String get friendErrFriendCode =>
      'Este é um código de contato. Insira-o em Adicionar contato, na página Enviar arquivos.';

  @override
  String get friendErrDeviceCode =>
      'Este é um código de pareamento. Insira-o em Dispositivos → Adicionar dispositivo.';

  @override
  String get friendErrOutdated =>
      'A outra pessoa precisa do PasteFerry 2.6.0 ou mais recente.';

  @override
  String get friendErrAlreadyPaired =>
      'Esse computador já é um dos seus dispositivos.';

  @override
  String get friendErrNoChannel =>
      'Vocês não estão na mesma rede. Ative o Serviço nos dois computadores para se adicionarem.';

  @override
  String get openService => 'Ativar Serviço…';

  @override
  String get noteLabel => 'Observação (opcional)';

  @override
  String get noteHintEmpty => 'Escolha os arquivos primeiro';

  @override
  String get noteHint => 'Por exemplo: assine a página 3';

  @override
  String noteLine(String note) {
    return 'Observação: $note';
  }

  @override
  String get sendAction => 'Enviar';

  @override
  String sendItemsSummary(String count, String size) {
    return '$count itens · $size';
  }

  @override
  String sendDropOrPaste(String key) {
    return 'Solte arquivos ou imagens aqui, ou cole ($key)';
  }

  @override
  String get sendDropMorePaste => 'Solte ou cole mais';

  @override
  String get sendPasteNothing =>
      'Nada para colar. Copie arquivos ou uma imagem primeiro.';

  @override
  String get sendRemoveItem => 'Remover';

  @override
  String sendFriendSaved(String name) {
    return '$name aceita cada lote antes do envio.';
  }

  @override
  String transferAskingOut(String name) {
    return 'Aguardando $name aceitar…';
  }

  @override
  String get transferAskingIn => 'Aguardando você aceitar';

  @override
  String reasonDeclined(String name) {
    return '$name recusou';
  }

  @override
  String reasonTimeout(String name) {
    return '$name não respondeu';
  }

  @override
  String reasonNotAllowed(String name) {
    return '$name não está aceitando arquivos';
  }

  @override
  String reasonRateLimited(String name) {
    return '$name não está aceitando seus arquivos no momento';
  }

  @override
  String get reasonYouDeclined => 'Recusado';

  @override
  String get reasonYouIgnored => 'Ignorado';

  @override
  String get sendAgain => 'Enviar de novo';

  @override
  String incomingTitle(String name) {
    return '$name quer enviar arquivos para você';
  }

  @override
  String get incomingAlways => 'Sempre aceitar arquivos deste contato';

  @override
  String get incomingDecline => 'Recusar';

  @override
  String get incomingAccept => 'Aceitar';

  @override
  String incomingCountdown(String seconds) {
    return 'Recusa automática em $seconds s';
  }

  @override
  String get incomingStranger => 'Por perto';

  @override
  String get friendsStrip => 'Contatos';

  @override
  String get strangersStrip => 'Por perto com Todos ativado';

  @override
  String get strangerNearby => 'Por perto';

  @override
  String get friendNeedService => 'Ative o Serviço';

  @override
  String get friendCantReach => 'Não é possível conectar';

  @override
  String reachSelfNoService(String name) {
    return 'Você e $name não estão na mesma rede. Ative o Serviço para enviar arquivos; se não houver conexão direta possível, eles passam pela retransmissão do Serviço.';
  }

  @override
  String reachPeerNoService(String name) {
    return '$name não ativou o Serviço, então você só pode enviar arquivos na mesma rede. Peça para ativar o Serviço no PasteFerry.';
  }

  @override
  String get reachDifferentServer =>
      'Vocês não estão usando o mesmo servidor. Ative o Serviço nos dois computadores, ou use o mesmo servidor, para enviar arquivos.';

  @override
  String get receiveFromLabel => 'Quem pode me enviar arquivos:';

  @override
  String get receiveFromOff => 'Ninguém';

  @override
  String get receiveFromFriends => 'Só contatos';

  @override
  String get receiveFromEveryone => 'Todos';

  @override
  String everyoneLeft(String minutes) {
    return 'Todos · restam $minutes min';
  }

  @override
  String get receiveFromOffDesc =>
      'Só seus próprios computadores pareados podem enviar arquivos para você.';

  @override
  String get receiveFromFriendsDesc =>
      'Seus contatos podem enviar arquivos para você. Você aceita cada lote.';

  @override
  String get receiveFromEveryoneDesc =>
      'Qualquer pessoa na mesma rede pode enviar arquivos para você durante 10 minutos. Você aceita cada lote.';

  @override
  String get everyoneEnded => 'Todos foi desativado; voltou para Só contatos.';

  @override
  String get friendsCountTooltip => 'Contatos';

  @override
  String get waitingAccept => 'Aguardando…';

  @override
  String get settingsConnection => 'Conexão';

  @override
  String get settingsGeneralSummary =>
      'Abrir ao iniciar a sessão, nome do dispositivo, idioma';

  @override
  String get settingsConnectionSummary =>
      'Serviço, servidor próprio, rede local';

  @override
  String get settingsSyncSummary =>
      'Sincronização em tempo real, limite de tamanho, o que sincronizar';

  @override
  String get settingsQuickPasteSummary =>
      'Atalho e o que acontece ao escolher um item';

  @override
  String get settingsSendSummary =>
      'Recebimento de arquivos, local para salvar';

  @override
  String get settingsStorageSummary =>
      'Por quanto tempo manter o histórico, espaço usado';

  @override
  String get settingsAboutSummary => 'Versão, atualizações, feedback';

  @override
  String get friendsSubtitle =>
      'Envie arquivos para o computador de outras pessoas, sem pareamento';

  @override
  String get friendsSearch => 'Buscar contatos';

  @override
  String get friendsNoMatch => 'Nenhum contato encontrado';

  @override
  String get friendsPick =>
      'Escolha um contato para ver as transferências ou enviar arquivos';

  @override
  String friendDropHint(String name) {
    return 'Solte arquivos aqui para enviá-los para $name';
  }

  @override
  String get webShareTitle => 'Transferência pelo navegador do celular';

  @override
  String get webShareFootnote =>
      'Leia um código QR com o celular para trocar textos, fotos e arquivos com este computador pelo navegador, sem instalar app. O celular e o computador precisam estar na mesma rede.';

  @override
  String get webShareSwitch =>
      'Permitir que celulares se conectem pelo navegador';

  @override
  String webShareOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ativado, $count celulares',
      one: 'Ativado, 1 celular',
    );
    return '$_temp0';
  }

  @override
  String get webShareOff => 'Desativado';

  @override
  String get webShareShowQr => 'Mostrar código QR';

  @override
  String get webShareDialogTitle => 'Leia com o celular';

  @override
  String get webShareDialogBody =>
      'Leia com a câmera ou o navegador do celular e abra no navegador. Cada código QR registra um celular e é trocado depois de usado.';

  @override
  String get webShareAddress => 'Endereço';

  @override
  String get webShareSecurity =>
      'O conteúdo é criptografado na página, então outras pessoas na rede não conseguem lê-lo. Mas a página em si usa http e não impede alguém que a adultere de propósito. Use em casa ou em uma rede de escritório confiável, não em Wi-Fi público.';

  @override
  String get webSharePhones => 'Celulares registrados';

  @override
  String get webShareNoPhones => 'Nenhum celular ainda';

  @override
  String webShareLastUsed(String time) {
    return 'Último uso: $time';
  }

  @override
  String get webShareRemove => 'Remover';

  @override
  String webShareRemoved(String name) {
    return '“$name” removido';
  }

  @override
  String webShareNewPhone(String name) {
    return '“$name” registrado';
  }

  @override
  String webShareNotListening(String error) {
    return 'Não foi possível começar a escutar: $error';
  }

  @override
  String get webSharePortFallback =>
      'A porta de sempre está ocupada, então uma porta temporária está em uso. Endereços salvos não vão abrir até os celulares lerem o código de novo.';

  @override
  String get webShareNoAddress =>
      'Sem endereço na rede local. Conecte-se primeiro a uma rede Wi-Fi ou cabeada.';

  @override
  String get webShareCantOpen =>
      'Se a página não abrir no celular, verifique se os dois estão na mesma rede (redes de convidados costumam não funcionar). No Windows, o PasteFerry também precisa ser permitido no firewall.';

  @override
  String get mTabRecords => 'Histórico';

  @override
  String get mTabSend => 'Enviar';

  @override
  String get mThisPhone => 'Este celular';

  @override
  String get mThisPhoneInText => 'este celular';

  @override
  String mThisPhoneName(String name) {
    return 'Este celular: $name';
  }

  @override
  String get mSendTitle => 'Enviar para o computador';

  @override
  String get mSendHint => 'Digite ou cole um texto';

  @override
  String get mPaste => 'Colar';

  @override
  String get mPhotosFiles => 'Fotos ou arquivos';

  @override
  String mSendConfirmTitle(Object n) {
    return 'Enviar $n arquivo(s)?';
  }

  @override
  String mFilesSent(num n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n arquivos enviados para o computador',
      one: '1 arquivo enviado para o computador',
    );
    return '$_temp0';
  }

  @override
  String get mClipboardNoText => 'Não há texto na área de transferência';

  @override
  String get mSendAction => 'Enviar';

  @override
  String mSendTo(String names) {
    return 'Vai para $names';
  }

  @override
  String get mNoOnlineDevices => 'Nenhum dispositivo on-line por perto';

  @override
  String get mNoPairedDevices => 'Pareie com um computador primeiro';

  @override
  String get mSent => 'Enviado';

  @override
  String get mSendFootnote =>
      'Textos e arquivos entram no histórico do computador e, conforme a configuração dele, na área de transferência. O que você copia no celular não é enviado sozinho.';

  @override
  String get mSentRecords => 'Enviados';

  @override
  String get mSentRetention => 'Manter enviados por';

  @override
  String mSentRetentionDesc(Object d) {
    return 'Enviados mostra o que este celular enviou nos últimos $d dias';
  }

  @override
  String mSentRetentionDays(Object d) {
    return '$d dias';
  }

  @override
  String get mViewAll => 'Ver tudo';

  @override
  String get mClearCache => 'Limpar';

  @override
  String get mCheckUpdate => 'Verificar atualizações';

  @override
  String get mUpdateFailed => 'Não foi possível verificar atualizações';

  @override
  String get mUpToDate => 'Você está com a versão mais recente';

  @override
  String mNewVersion(Object v) {
    return 'Versão $v disponível';
  }

  @override
  String get mDownloadInstall => 'Baixar a nova versão';

  @override
  String mSendFailed(String detail) {
    return 'Não foi possível enviar: $detail';
  }

  @override
  String get mCopy => 'Copiar';

  @override
  String get mCopied => 'Copiado para a área de transferência do celular';

  @override
  String get mShare => 'Compartilhar';

  @override
  String get mSaved => 'Salvo em Fotos ou em Download/PasteFerry';

  @override
  String mActionFailed(String detail) {
    return 'Não funcionou: $detail';
  }

  @override
  String get mDownloading => 'Baixando…';

  @override
  String get mNotDownloaded => 'Ainda não baixado';

  @override
  String get mDownloadHint =>
      'É baixado primeiro quando você toca em Copiar, Salvar ou Compartilhar.';

  @override
  String get mFullTextLoading => 'Carregando…';

  @override
  String mTextTruncated(int shown, int total) {
    return 'Mostrando os primeiros $shown de $total caracteres. Ao copiar, o texto vem inteiro.';
  }

  @override
  String get mNotOnLanTitle => 'Sem Wi-Fi';

  @override
  String get mNotOnLanBody =>
      'Por enquanto, o PasteFerry só sincroniza na rede local. Conecte-se à mesma rede Wi-Fi do computador.';

  @override
  String mStartFailed(String detail) {
    return 'Não foi possível iniciar o PasteFerry: $detail';
  }

  @override
  String get mNoDevicesBody =>
      'No computador, abra o PasteFerry → Dispositivos → Adicionar dispositivo e insira aqui o código que aparecer. Na mesma rede Wi-Fi, você também pode abrir “Procurar por perto” nos dois.';

  @override
  String get mSectionSync => 'Sincronização';

  @override
  String get mSectionBackground => 'Segundo plano';

  @override
  String get mAutoApplyDesc =>
      'O texto copiado no computador vai direto para a área de transferência deste celular. Imagens e arquivos esperam até você tocar em Copiar.';

  @override
  String get mKeepAlive => 'Manter conectado em segundo plano';

  @override
  String get mKeepAliveDesc =>
      'Recebe textos mesmo com o PasteFerry fechado. Mostra uma notificação permanente.';

  @override
  String get mNotifications => 'Notificações';

  @override
  String get mNotificationsDesc =>
      'Necessárias para a notificação permanente. O PasteFerry funciona sem elas.';

  @override
  String get mBattery => 'Executar em segundo plano';

  @override
  String get mBatteryDesc =>
      'Desative a otimização de bateria para que o sistema não encerre o PasteFerry com a tela bloqueada. Alguns celulares também exigem adicionar o PasteFerry à lista de inicialização automática ou de segundo plano nas Configurações.';

  @override
  String get mAllowed => 'Permitido';

  @override
  String get mAllow => 'Permitir';

  @override
  String mVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get mDeleteConfirm => 'Apagar este registro?';

  @override
  String get mDelete => 'Apagar';

  @override
  String get webShareFirewallPreparing =>
      'Verificando o Firewall do Windows. Se o Windows pedir aprovação de administrador, escolha Sim para que seu celular possa se conectar.';

  @override
  String get webShareFirewallReady =>
      'As regras do Firewall do Windows estão prontas. Conecte o celular à mesma rede e leia o código QR. Se ainda não conectar, verifique o firewall de novo abaixo.';

  @override
  String get webShareFirewallFailed =>
      'A configuração do firewall não foi concluída. Talvez o celular não consiga abrir a página. Tente de novo e aprove o pedido de administrador do Windows.';

  @override
  String get webShareFirewallAllow =>
      'Verificar e permitir conexões do celular';

  @override
  String get mCopyMediaFailed =>
      'Não foi possível copiar esta imagem ou arquivo. Tente salvá-lo primeiro.';

  @override
  String get mShareMediaFailed =>
      'Não foi possível abrir o compartilhamento desta imagem ou arquivo. Tente salvá-lo primeiro.';

  @override
  String get mSaveMediaFailed =>
      'Não foi possível salvar esta imagem ou arquivo. Verifique o acesso ao armazenamento e o espaço livre e tente de novo.';

  @override
  String get noticeFilesUnreadable =>
      'Não foi possível ler os arquivos que você acabou de copiar, então nada foi sincronizado';

  @override
  String get mAddMore => 'Adicionar mais';

  @override
  String get mChoosePhotos => 'Escolher fotos…';

  @override
  String get mMultiSelectHint =>
      'Selecione várias fotos de uma vez. Em Arquivos, toque e mantenha pressionado um item para selecionar mais.';

  @override
  String get webSendFiles => 'Enviar arquivos';

  @override
  String get webFilesQueued =>
      'Adicionado às transferências pelo navegador. Abra Enviar arquivos no celular para baixar.';

  @override
  String get webFilesLimit =>
      'Os downloads pelo navegador aceitam até 200 MB por arquivo e 64 arquivos por lote.';

  @override
  String get appearance => 'Aparência';

  @override
  String get settingsAppearanceSummary => 'Tema, claro e escuro';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeDefault => 'Padrão';

  @override
  String get themePixel => 'Pixel';

  @override
  String get themeMode => 'Claro e escuro';

  @override
  String get themeModeSystem => 'Igual ao sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get themeCustom => 'Personalizado';

  @override
  String get themeDelete => 'Apagar tema';

  @override
  String themeDeleteConfirm(String name) {
    return 'Apagar o tema “$name”?';
  }

  @override
  String get themeLowContrast =>
      'Alguns textos deste tema podem ser difíceis de ler';

  @override
  String get themeFootnote =>
      'Os temas valem só para este dispositivo, inclusive a colagem rápida. Eles não são sincronizados com outros dispositivos.';

  @override
  String get themeBuiltinGroup => 'Incluídos';

  @override
  String get themeCustomGroup => 'Personalizados';

  @override
  String get themeUse => 'Usar';

  @override
  String get themeDuplicate => 'Duplicar';

  @override
  String themeCopyName(String name) {
    return 'Cópia de $name';
  }

  @override
  String get themeExport => 'Exportar…';

  @override
  String get themeImport => 'Importar tema…';

  @override
  String themeImported(String name) {
    return '“$name” importado';
  }

  @override
  String themeImportedWarn(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '“$name” importado. $count cores de texto podem ser difíceis de ler.',
      one: '“$name” importado. 1 cor de texto pode ser difícil de ler.',
    );
    return '$_temp0';
  }

  @override
  String get themeExported => 'Tema exportado';

  @override
  String get themeCustomEmpty =>
      'Nenhum tema personalizado ainda. Duplique um tema incluído, importe um ou peça para uma IA criar um.';

  @override
  String get themeAskAi => 'Pedir um tema para a IA';

  @override
  String get themeAskAiBody =>
      'Adicione este servidor MCP a um app de IA como Claude ou Cursor e peça um tema, por exemplo “Crie um tema cyberpunk para mim”. A IA lê o formato do tema, escolhe as cores, verifica o contraste e aplica o tema.';

  @override
  String get themeAskAiCopy => 'Copiar configuração';

  @override
  String get themeAskAiCopied => 'Configuração copiada';

  @override
  String get themeScanlines => 'Linhas de varredura';

  @override
  String get themeScanlinesDesc =>
      'Sobrepõe à janela linhas de varredura de CRT bem suaves. Só nos temas pixel.';

  @override
  String get themeBackground => 'Imagem de fundo';

  @override
  String get themeBackgroundDesc =>
      'Preenche a janela atrás da barra lateral e das páginas. Uma camada por cima mantém o texto legível.';

  @override
  String get themeBackgroundChoose => 'Escolher imagem…';

  @override
  String get themeBackgroundChange => 'Alterar…';

  @override
  String get themeBackgroundRemove => 'Remover';

  @override
  String get themeBlur => 'Desfoque';

  @override
  String get themeBlurNone => 'Nenhum';

  @override
  String get themeBlurLight => 'Leve';

  @override
  String get themeBlurStrong => 'Forte';

  @override
  String get themeScrim => 'Camada';

  @override
  String get themeScrimDesc =>
      'Uma cor aplicada sobre a imagem para manter o texto legível. Nunca é mais clara do que a imagem exige.';

  @override
  String get themeScrimAuto => 'Automática';

  @override
  String get themeScrimMore => 'Mais densa';

  @override
  String get themeScrimMost => 'Máxima';

  @override
  String get themePanels => 'Painéis';

  @override
  String get themePanelsDesc =>
      'Quanto da imagem aparece através da barra lateral e das listas.';

  @override
  String get themePanelsClear => 'Transparentes';

  @override
  String get themePanelsMedium => 'Médios';

  @override
  String get themePanelsSolid => 'Sólidos';

  @override
  String get themeAccentFromImage => 'Usar cores da imagem';

  @override
  String get themeAccentFromImageDesc => 'Usa a cor de destaque da imagem.';

  @override
  String get themeBackgroundPicker => 'Mostrar também na colagem rápida';

  @override
  String get themeScenery => 'Mostrar paisagens';

  @override
  String get themeSceneryDesc =>
      'As imagens no topo das páginas e na parte de baixo da barra lateral.';

  @override
  String themeCopiedForEdit(String name) {
    return 'Temas incluídos não podem ser alterados, então foi criada e aplicada uma cópia chamada “$name”';
  }

  @override
  String get themeBackgroundFootnote =>
      'O fundo pertence ao tema atual. Temas incluídos não podem ser alterados: a primeira mudança cria uma cópia. As imagens ficam neste dispositivo; JPEG, PNG e GIF são aceitos.';

  @override
  String get themeSceneGroup => 'Paisagens';

  @override
  String get themeSceneHeader => 'Topo da página';

  @override
  String get themeSceneHeaderDesc =>
      'Uma imagem larga atrás dos títulos das páginas; a parte de baixo se funde com a página. O tema pixel desenha aqui uma paisagem em pixel art.';

  @override
  String get themeSceneSidebar => 'Base da barra lateral';

  @override
  String get themeSceneSidebarDesc =>
      'Uma imagem pequena na parte de baixo da barra lateral. O tema pixel desenha aqui um pequeno acampamento.';

  @override
  String get themeSceneReset => 'Redefinir';

  @override
  String get themeSceneFootnote =>
      'Qualquer tema pode mostrar suas próprias imagens aqui. Uma camada mantém o título da página legível. As paisagens ficam ocultas enquanto uma imagem de fundo preenche a janela.';

  @override
  String get starTitle => 'O que você está achando do PasteFerry?';

  @override
  String get starBody =>
      'Se estiver gostando, uma estrela no GitHub faria muita diferença.';

  @override
  String get starAction => 'Dar uma estrela no GitHub';

  @override
  String get starLater => 'Mais tarde';

  @override
  String get starDismiss => 'Não mostrar de novo';
}
