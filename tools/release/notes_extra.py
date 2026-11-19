"""Additional release-note translations for the 13 interface languages added in 2.11.

The original five languages remain in notes.py. Each version here must provide
all EXTRA_LANGS, with the same change/fix counts and order as its notes.py entry.
Older releases without these translations continue to fall back to English.
"""

EXTRA_LANGS = ["ar", "de", "es", "fr", "id", "it", "ko", "pl", "pt-BR", "ru", "tr", "uk", "vi"]

EXTRA_NOTES = {
    "2.13.0": {'ar': {'changes': ['اتصال مباشر عبر شبكات الجوال: يمكن الآن للأجهزة خلف شبكات المشغّلين التي '
                    'توزّع المنافذ بالتسلسل، كما في أجهزة Wi-Fi المحمولة وبيانات الجوال، أن تتصل '
                    'مباشرة بدل الاعتماد على الترحيل وحده. يكفي تحديث الجهاز الموجود على تلك '
                    'الشبكة.',
                    'اتصال مباشر عبر IPv6: عندما يملك الجهازان عناوين IPv6 عامة، يتصلان مباشرة عبر '
                    'IPv6 دون عبور أي NAT.'],
        'fixes': ['لم تعد اتصالات الترحيل تنقطع بعد ثوانٍ من ازدحام الشبكة، وهو ما كان يُبقي '
                  'الأجهزة على Wi-Fi المحمول عالقة عند «جارٍ الاتصال…» ويوقف نقل الملفات. يُمنح '
                  'الترحيل المتعطل الآن حتى 35 ثانية ليتعافى، ويسجّل التشخيص سبب انتهاء الترحيل.']},
 'de': {'changes': ['Direkte Verbindungen in Mobilfunknetzen: Geräte hinter Providernetzen, die '
                    'Ports der Reihe nach vergeben – typisch für mobile WLAN-Router und mobile '
                    'Daten –, verbinden sich jetzt direkt statt nur über das Relay. Aktualisiert '
                    'werden muss nur das Gerät in diesem Netz.',
                    'Direkte Verbindungen über IPv6: Haben beide Geräte öffentliche IPv6-Adressen, '
                    'verbinden sie sich direkt über IPv6, ohne NAT zu durchqueren.'],
        'fixes': ['Relay-Verbindungen brechen bei kurz überlastetem Netz nicht mehr nach wenigen '
                  'Sekunden ab; über mobile WLAN-Router blieben Geräte bisher bei „Verbinden…“ '
                  'hängen und Dateiübertragungen stoppten. Ein stockendes Relay hat jetzt bis zu '
                  '35 Sekunden Zeit, sich zu erholen, und die Diagnose hält fest, warum ein Relay '
                  'endete.']},
 'es': {'changes': ['Conexión directa en redes móviles: los dispositivos detrás de redes de '
                    'operador que asignan puertos de forma secuencial, habituales en el Wi-Fi '
                    'portátil y los datos móviles, ahora pueden conectarse directamente en lugar '
                    'de depender solo de la retransmisión. Solo hay que actualizar el dispositivo '
                    'que está en esa red.',
                    'Conexión directa por IPv6: cuando ambos dispositivos tienen direcciones IPv6 '
                    'públicas, se conectan directamente por IPv6 sin atravesar ningún NAT.'],
        'fixes': ['Las conexiones por retransmisión ya no se cortan tras unos segundos de '
                  'congestión de la red; con Wi-Fi portátil, los dispositivos se quedaban en '
                  '«Conectando…» y las transferencias de archivos se detenían. Una retransmisión '
                  'atascada ahora dispone de hasta 35 segundos para recuperarse, y el diagnóstico '
                  'registra por qué terminó.']},
 'fr': {'changes': ['Connexion directe sur les réseaux mobiles : les appareils derrière des '
                    "réseaux d'opérateur qui attribuent les ports dans l'ordre, courants avec le "
                    'Wi-Fi de poche et les données mobiles, se connectent désormais directement au '
                    "lieu de passer uniquement par le relais. Seul l'appareil sur ce réseau doit "
                    'être mis à jour.',
                    'Connexion directe en IPv6 : lorsque les deux appareils ont une adresse IPv6 '
                    'publique, ils se connectent directement en IPv6, sans traverser de NAT.'],
        'fixes': ['Les connexions par relais ne tombent plus après quelques secondes de congestion '
                  'du réseau ; avec un Wi-Fi de poche, les appareils restaient bloqués sur « '
                  "Connexion… » et les transferts de fichiers s'arrêtaient. Un relais bloqué "
                  'dispose désormais de 35 secondes pour se rétablir, et le diagnostic indique '
                  "pourquoi un relais s'est terminé."]},
 'id': {'changes': ['Koneksi langsung di jaringan seluler: Perangkat di balik jaringan operator '
                    'yang membagikan port secara berurutan, umum pada Wi-Fi portabel dan data '
                    'seluler, kini dapat terhubung langsung, tidak hanya lewat relai. Hanya '
                    'perangkat di jaringan tersebut yang perlu diperbarui.',
                    'Koneksi langsung lewat IPv6: Jika kedua perangkat memiliki alamat IPv6 '
                    'publik, keduanya terhubung langsung lewat IPv6 tanpa melewati NAT.'],
        'fixes': ['Koneksi lewat relai tidak lagi terputus setelah jaringan padat selama beberapa '
                  'detik; pada Wi-Fi portabel, perangkat sebelumnya tertahan di "Menghubungkan…" '
                  'dan transfer file terhenti. Relai yang tersendat kini diberi waktu hingga 35 '
                  'detik untuk pulih, dan diagnostik mencatat alasan relai berakhir.']},
 'it': {'changes': ['Connessione diretta sulle reti mobili: i dispositivi dietro reti di operatore '
                    'che assegnano le porte in sequenza, comuni con il Wi-Fi portatile e i dati '
                    'mobili, ora possono connettersi direttamente invece di passare solo per '
                    "l'inoltro. Basta aggiornare il dispositivo che si trova su quella rete.",
                    'Connessione diretta via IPv6: se entrambi i dispositivi hanno un indirizzo '
                    'IPv6 pubblico, si connettono direttamente via IPv6 senza attraversare alcun '
                    'NAT.'],
        'fixes': ['Le connessioni tramite inoltro non cadono più dopo pochi secondi di congestione '
                  'della rete; con il Wi-Fi portatile i dispositivi restavano fermi su '
                  '«Connessione…» e i trasferimenti di file si interrompevano. Un inoltro bloccato '
                  'ha ora fino a 35 secondi per riprendersi e la diagnostica registra il motivo '
                  'per cui è terminato.']},
 'ko': {'changes': ['모바일 네트워크에서도 직접 연결: 포켓 와이파이나 모바일 데이터처럼 포트를 순서대로 할당하는 통신사 네트워크에 있는 기기도 이제 중계에만 '
                    '의존하지 않고 직접 연결할 수 있습니다. 해당 네트워크에 있는 기기만 업데이트하면 됩니다.',
                    'IPv6 직접 연결: 두 기기 모두 공인 IPv6 주소가 있으면 NAT를 거치지 않고 IPv6로 직접 연결합니다.'],
        'fixes': ["네트워크가 몇 초 동안 혼잡해져도 중계 연결이 더 이상 끊기지 않습니다. 이전에는 포켓 와이파이에서 '연결 중…'에 머물며 파일 전송이 멈추곤 "
                  '했습니다. 이제 중계가 멈추면 최대 35초까지 복구를 기다리며, 중계가 끝난 이유를 진단에 기록합니다.']},
 'pl': {'changes': ['Bezpośrednie połączenia w sieciach komórkowych: urządzenia w sieciach '
                    'operatorów, które przydzielają porty po kolei – typowe dla mobilnych routerów '
                    'Wi-Fi i danych komórkowych – mogą teraz łączyć się bezpośrednio, a nie tylko '
                    'przez przekaźnik. Wystarczy zaktualizować urządzenie w tej sieci.',
                    'Bezpośrednie połączenia przez IPv6: gdy oba urządzenia mają publiczne adresy '
                    'IPv6, łączą się bezpośrednio przez IPv6, bez przechodzenia przez NAT.'],
        'fixes': ['Połączenia przez przekaźnik nie zrywają się już po kilku sekundach przeciążenia '
                  'sieci; przy mobilnym routerze Wi-Fi urządzenia zatrzymywały się na „Łączenie…”, '
                  'a przesyłanie plików stawało. Zablokowany przekaźnik ma teraz do 35 sekund na '
                  'powrót, a diagnostyka zapisuje, dlaczego się zakończył.']},
 'pt-BR': {'changes': ['Conexão direta em redes móveis: dispositivos atrás de redes de operadora '
                       'que atribuem portas em sequência, comuns em Wi-Fi portátil e dados móveis, '
                       'agora podem se conectar diretamente, em vez de depender só da '
                       'retransmissão. Basta atualizar o dispositivo que está nessa rede.',
                       'Conexão direta por IPv6: quando os dois dispositivos têm endereços IPv6 '
                       'públicos, eles se conectam diretamente por IPv6, sem atravessar NAT.'],
           'fixes': ['Conexões por retransmissão não caem mais após alguns segundos de '
                     'congestionamento da rede; no Wi-Fi portátil, os dispositivos ficavam parados '
                     'em "Conectando…" e as transferências de arquivos paravam. Uma retransmissão '
                     'travada agora tem até 35 segundos para se recuperar, e o diagnóstico '
                     'registra por que ela terminou.']},
 'ru': {'changes': ['Прямое подключение в мобильных сетях: устройства в сетях операторов, которые '
                    'выдают порты по порядку (это типично для карманных роутеров Wi-Fi и '
                    'мобильного интернета), теперь подключаются напрямую, а не только через '
                    'ретрансляцию. Обновить нужно только устройство в такой сети.',
                    'Прямое подключение по IPv6: если у обоих устройств есть публичные адреса '
                    'IPv6, они подключаются напрямую по IPv6, не проходя через NAT.'],
        'fixes': ['Подключения через ретрансляцию больше не обрываются после нескольких секунд '
                  'перегрузки сети; с карманным роутером Wi-Fi устройства раньше зависали на '
                  '«Подключение…», а передача файлов останавливалась. Теперь у зависшей '
                  'ретрансляции есть до 35 секунд на восстановление, а диагностика записывает, '
                  'почему она завершилась.']},
 'tr': {'changes': ['Mobil ağlarda doğrudan bağlantı: Taşınabilir Wi-Fi ve mobil veride sık '
                    'görülen, portları sırayla atayan operatör ağlarının arkasındaki cihazlar '
                    'artık yalnızca aktarmaya bağlı kalmadan doğrudan bağlanabiliyor. Yalnızca o '
                    'ağdaki cihazın güncellenmesi yeterli.',
                    'IPv6 ile doğrudan bağlantı: İki cihazın da genel IPv6 adresi varsa hiçbir '
                    "NAT'tan geçmeden IPv6 üzerinden doğrudan bağlanır."],
        'fixes': ['Aktarma bağlantıları, ağ birkaç saniye yoğunlaştığında artık kopmuyor; '
                  'taşınabilir Wi-Fi\'de cihazlar "Bağlanıyor…" durumunda kalıyor ve dosya '
                  'aktarımları duruyordu. Takılan bir aktarma artık toparlanmak için 35 saniyeye '
                  'kadar bekliyor ve tanılama, aktarmanın neden sona erdiğini kaydediyor.']},
 'uk': {'changes': ['Пряме підключення в мобільних мережах: пристрої в мережах операторів, які '
                    'видають порти по черзі (це типово для кишенькових роутерів Wi-Fi і мобільного '
                    'інтернету), тепер підключаються напряму, а не лише через ретрансляцію. '
                    'Оновити потрібно лише пристрій у такій мережі.',
                    'Пряме підключення через IPv6: якщо обидва пристрої мають публічні адреси '
                    'IPv6, вони підключаються напряму через IPv6, не проходячи через NAT.'],
        'fixes': ['Підключення через ретрансляцію більше не обриваються після кількох секунд '
                  'перевантаження мережі; з кишеньковим роутером Wi-Fi пристрої раніше зависали на '
                  '«Підключення…», а передавання файлів зупинялося. Тепер ретрансляція, що '
                  'зависла, має до 35 секунд на відновлення, а діагностика записує, чому вона '
                  'завершилася.']},
 'vi': {'changes': ['Kết nối trực tiếp trên mạng di động: Các thiết bị sau mạng nhà mạng cấp cổng '
                    'theo thứ tự, thường gặp với Wi-Fi bỏ túi và dữ liệu di động, nay có thể kết '
                    'nối trực tiếp thay vì chỉ qua chuyển tiếp. Chỉ cần cập nhật thiết bị ở trong '
                    'mạng đó.',
                    'Kết nối trực tiếp qua IPv6: Khi cả hai thiết bị đều có địa chỉ IPv6 công '
                    'cộng, chúng kết nối trực tiếp qua IPv6 mà không phải đi qua NAT.'],
        'fixes': ['Kết nối chuyển tiếp không còn bị ngắt sau vài giây mạng nghẽn; trước đây, trên '
                  'Wi-Fi bỏ túi, thiết bị bị kẹt ở "Đang kết nối…" và việc truyền tệp bị dừng. Nay '
                  'chuyển tiếp bị nghẽn có tối đa 35 giây để phục hồi, và phần chẩn đoán ghi lại '
                  'lý do chuyển tiếp kết thúc.']}},
    "2.12.2": {'ar': {'changes': ['مشاركة الملفات من لوحة Android وخدمات Finder والقائمة التقليدية في Windows؛ '
                    'في Windows 11 اختر إظهار المزيد من الخيارات. ثبّت قوائم Nautilus وDolphin من '
                    'الإعدادات > إرسال الملفات.',
                    'راجع الملفات واختر جهازًا مقترنًا واحدًا ثم أكّد الإرسال. تبقى الدفعات '
                    'المعلقة بعد إعادة فتح التطبيق، وتُحفظ المرفقات للتحويلات المتوقفة.',
                    'المشاركة بلغات متعددة: تتبع قوائم المشاركة لغة النظام وشاشات التأكيد لغة '
                    'التطبيق، مع دعم اللغات الـ18 كلها.'],
        'fixes': ['إصلاح اللصق السريع على Mac: لا يعني تسجيل المساعد أنه جاهز. ينتظر التطبيق '
                  'اتصاله، ويحدّ المحاولات التلقائية، ويعرض إصلاحًا يدويًا وتفاصيل الخطأ عند '
                  'الفشل.',
                  ('تُغلق أدوات تثبيت Windows التطبيق الجاري بصورة صحيحة بدل إخفاء نافذته وإلغاء الترقية. '
                   'تستمر إعادة التثبيت دون إغلاق مستكشف Windows حتى عند تحميل إضافة المشاركة.')]},
 'de': {'changes': ['Dateien über Androids Teilen-Menü, Finder-Dienste und das klassische '
                    'Windows-Kontextmenü senden (Weitere Optionen anzeigen unter Windows 11). '
                    'Nautilus- und Dolphin-Menüs unter Einstellungen > Dateien senden '
                    'installieren.',
                    'Geteilte Dateien prüfen, ein gekoppeltes Empfangsgerät wählen und das Senden '
                    'bestätigen. Ausstehende Stapel bleiben nach erneutem Öffnen erhalten, '
                    'importierte Anhänge für pausierte Übertragungen verfügbar.',
                    'Mehrsprachiges Teilen: Freigabemenüs folgen der Systemsprache, '
                    'Bestätigungsdialoge der App-Sprache. Alle 18 unterstützten Sprachen sind '
                    'abgedeckt.'],
        'fixes': ['Mac-Schnelleinfügen: Registrierte, nicht gestartete Helfer gelten nicht mehr '
                  'als bereit. Begrenzte automatische Wiederholungen, Sitzungsprüfung und manuelle '
                  'Reparatur mit Fehlerdetails.',
                  ('Windows-Installer beenden eine laufende App korrekt, statt ihr Fenster auszublenden und '
                   'das Upgrade abzubrechen. Auch bei geladenem Freigabe-Plugin bleibt Windows Explorer '
                   'während einer erneuten Installation geöffnet.')]},
 'es': {'changes': ['Envía archivos desde Compartir de Android, Servicios de Finder y el menú '
                    'clásico de Windows (Mostrar más opciones en Windows 11). Instala los menús de '
                    'Nautilus y Dolphin en Ajustes > Enviar archivos.',
                    'Revisa los archivos, elige un único dispositivo vinculado y confirma el '
                    'envío. Los lotes pendientes se conservan al reabrir la aplicación y los '
                    'adjuntos importados siguen disponibles para transferencias pausadas.',
                    'Compartir en varios idiomas: los menús siguen el idioma del sistema y las '
                    'pantallas de confirmación el de la aplicación, con los 18 idiomas '
                    'disponibles.'],
        'fixes': ['Pegado rápido en Mac: un auxiliar registrado que no arranca ya no se considera '
                  'listo. Se espera su sesión, se limitan los reintentos y se ofrece reparación '
                  'manual con detalles del error.',
                  ('El instalador de Windows cierra correctamente la aplicación abierta en lugar de ocultar '
                   'su ventana y cancelar la actualización. La reinstalación mantiene abierto el Explorador '
                   'de Windows aunque haya cargado la extensión para compartir.')]},
 'fr': {'changes': ['Envoyez depuis le partage Android, les Services du Finder et le menu '
                    'classique Windows (Afficher plus d’options sous Windows 11). Installez les '
                    'menus Nautilus et Dolphin dans Réglages > Envoi de fichiers.',
                    'Vérifiez les fichiers, choisissez un seul appareil jumelé et confirmez. Les '
                    'lots en attente restent après réouverture, et les pièces importées sont '
                    'conservées pour les transferts en pause.',
                    'Partage multilingue : les menus suivent la langue du système et les écrans de '
                    'confirmation celle de l’application, dans les 18 langues prises en charge.'],
        'fixes': ['Collage rapide sur Mac : un auxiliaire enregistré mais non démarré n’est plus '
                  'considéré comme prêt. Attente de sa session, tentatives limitées et réparation '
                  'manuelle avec détails de l’erreur.',
                  ('Le programme d’installation Windows ferme correctement l’application ouverte au lieu de '
                   'masquer sa fenêtre et d’annuler la mise à niveau. La réinstallation laisse aussi '
                   'l’Explorateur Windows ouvert lorsque l’extension de partage est chargée.')]},
 'id': {'changes': ['Kirim berkas dari lembar berbagi Android, Layanan Finder, dan menu klasik '
                    'Windows (Tampilkan opsi lainnya di Windows 11). Pasang menu Nautilus dan '
                    'Dolphin di Pengaturan > Kirim Berkas.',
                    'Periksa berkas, pilih satu perangkat yang dipasangkan, lalu konfirmasi. '
                    'Antrean tetap ada setelah aplikasi dibuka kembali, dan lampiran disimpan '
                    'untuk transfer yang dijeda.',
                    'Berbagi multibahasa: menu mengikuti bahasa sistem dan layar konfirmasi '
                    'mengikuti bahasa aplikasi, mencakup seluruh 18 bahasa yang didukung.'],
        'fixes': ['Tempel cepat Mac: pembantu yang terdaftar tetapi gagal dimulai tidak lagi '
                  'dianggap siap. Aplikasi menunggu sesi, membatasi percobaan otomatis, dan '
                  'menyediakan perbaikan manual beserta detail kesalahan.',
                  ('Pemasang Windows kini menutup aplikasi yang berjalan dengan benar, bukan menyembunyikan '
                   'jendelanya dan membatalkan pembaruan. Pemasangan ulang juga membiarkan Windows Explorer '
                   'tetap berjalan saat ekstensi berbagi dimuat.')]},
 'it': {'changes': ['Invia dal menu Condividi di Android, dai Servizi del Finder e dal menu '
                    'classico Windows (Mostra altre opzioni in Windows 11). Installa i menu '
                    'Nautilus e Dolphin in Impostazioni > Invio file.',
                    'Controlla i file, scegli un solo dispositivo abbinato e conferma. I lotti in '
                    'attesa restano dopo la riapertura e gli allegati importati vengono conservati '
                    'per i trasferimenti in pausa.',
                    'Condivisione multilingue: i menu seguono la lingua del sistema e le schermate '
                    'di conferma quella dell’app, in tutte le 18 lingue supportate.'],
        'fixes': ['Incolla rapido su Mac: un helper registrato che non si avvia non è più '
                  'considerato pronto. Attesa della sessione, tentativi limitati e riparazione '
                  'manuale con dettagli errore.',
                  ('Il programma di installazione Windows chiude correttamente l’app in esecuzione invece di '
                   'nasconderne la finestra e interrompere l’aggiornamento. La reinstallazione lascia aperto '
                   'Esplora file anche quando l’estensione di condivisione è caricata.')]},
 'ko': {'changes': ['Android 공유 패널, Finder 서비스, Windows 기본 오른쪽 클릭 메뉴에서 파일을 보냅니다. Windows 11은 더 많은 '
                    '옵션 표시를 선택합니다. Linux에서는 설정 > 파일 보내기에서 Nautilus와 Dolphin 메뉴를 설치합니다.',
                    '공유 파일을 확인하고 페어링된 받는 기기 한 대를 선택한 뒤 전송을 확인합니다. 앱을 다시 열어도 대기 목록이 유지되고 일시 중지한 전송의 '
                    '첨부 파일도 보관됩니다.',
                    '다국어 공유: 공유 메뉴는 시스템 언어를, 확인 화면은 앱 언어를 따르며 지원하는 18개 언어를 모두 제공합니다.'],
        'fixes': ['Mac 빠른 붙여넣기: 등록되었지만 시작하지 못한 도우미를 준비 완료로 간주하지 않습니다. 세션을 기다리고 자동 재시도를 제한하며 수동 복구와 '
                  '오류 세부 정보를 제공합니다.',
                  ('Windows 설치 프로그램이 실행 중인 앱을 올바르게 종료하므로 창만 숨겨져 업그레이드가 취소되지 않습니다. 공유 확장 기능이 로드되어 있어도 파일 탐색기를 '
                   '종료하지 않고 다시 설치할 수 있습니다.')]},
 'pl': {'changes': ['Wysyłaj z panelu udostępniania Androida, Usług Findera i klasycznego menu '
                    'Windows (Pokaż więcej opcji w Windows 11). Menu Nautilusa i Dolphina '
                    'zainstalujesz w Ustawienia > Wysyłanie plików.',
                    'Sprawdź pliki, wybierz jedno sparowane urządzenie i potwierdź. Oczekujące '
                    'partie pozostają po ponownym otwarciu aplikacji, a załączniki są zachowywane '
                    'dla wstrzymanych transferów.',
                    'Udostępnianie w wielu językach: menu używają języka systemu, a ekrany '
                    'potwierdzenia języka aplikacji. Obsługiwane jest wszystkich 18 języków.'],
        'fixes': ['Szybkie wklejanie na Macu: zarejestrowany, nieuruchomiony pomocnik nie jest już '
                  'uznawany za gotowy. Oczekiwanie na sesję, ograniczone próby i ręczna naprawa ze '
                  'szczegółami błędu.',
                  ('Instalator Windows prawidłowo zamyka uruchomioną aplikację zamiast ukrywać jej okno i '
                   'przerywać aktualizację. Ponowna instalacja pozostawia Eksplorator Windows uruchomiony '
                   'również po załadowaniu rozszerzenia udostępniania.')]},
 'pt-BR': {'changes': ['Envie pelo compartilhamento do Android, Serviços do Finder e menu clássico '
                       'do Windows (Mostrar mais opções no Windows 11). Instale os menus do '
                       'Nautilus e Dolphin em Configurações > Enviar arquivos.',
                       'Confira os arquivos, escolha um único dispositivo pareado e confirme. Os '
                       'lotes pendentes permanecem após reabrir o app e os anexos são mantidos '
                       'para transferências pausadas.',
                       'Compartilhamento multilíngue: os menus seguem o idioma do sistema e as '
                       'telas de confirmação o do aplicativo, com suporte aos 18 idiomas.'],
           'fixes': ['Colagem rápida no Mac: um auxiliar registrado que falha ao iniciar não é '
                     'mais considerado pronto. O app espera a sessão, limita as tentativas e '
                     'oferece reparo manual com detalhes do erro.',
                     ('O instalador do Windows agora fecha corretamente o aplicativo aberto, em vez de ocultar '
                      'a janela e cancelar a atualização. A reinstalação também mantém o Explorador de Arquivos '
                      'aberto quando a extensão de compartilhamento está carregada.')]},
 'ru': {'changes': ['Отправляйте через меню Android, Службы Finder и классическое меню Windows '
                    '(Показать дополнительные параметры в Windows 11). Меню Nautilus и Dolphin '
                    'устанавливаются в Настройки > Отправка файлов.',
                    'Проверьте файлы, выберите одно сопряжённое устройство и подтвердите отправку. '
                    'Очередь сохраняется при повторном открытии приложения, вложения остаются для '
                    'приостановленных передач.',
                    'Многоязычная отправка: меню используют язык системы, а экраны подтверждения — '
                    'язык приложения. Поддерживаются все 18 языков.'],
        'fixes': ['Быстрая вставка на Mac: зарегистрированный, но не запущенный помощник больше не '
                  'считается готовым. Ожидание сеанса, ограниченные повторы и ручное '
                  'восстановление со сведениями об ошибке.',
                  ('Установщик Windows корректно завершает работающую программу, а не скрывает её окно и '
                   'прерывает обновление. Повторная установка также не закрывает Проводник Windows, если в '
                   'нём загружено расширение отправки файлов.')]},
 'tr': {'changes': ['Android paylaşım paneli, Finder Servisleri ve Windows klasik menüsünden dosya '
                    'gönderin (Windows 11: Daha fazla seçenek göster). Nautilus ve Dolphin '
                    'menülerini Ayarlar > Dosya Gönder bölümünden kurun.',
                    'Dosyaları inceleyin, eşleştirilmiş bir alıcı seçin ve onaylayın. Uygulama '
                    'yeniden açıldığında bekleyen gruplar korunur; içe aktarılan ekler '
                    'duraklatılan aktarımlar için saklanır.',
                    'Çok dilli paylaşım: menüler sistem dilini, onay ekranları uygulama dilini '
                    'izler. Desteklenen 18 dilin tamamı kullanılabilir.'],
        'fixes': ['Mac hızlı yapıştırma: kayıtlı olup başlatılamayan yardımcı artık hazır '
                  'sayılmaz. Oturum beklenir, otomatik denemeler sınırlandırılır ve hata '
                  'ayrıntılarıyla manuel onarım sunulur.',
                  ('Windows yükleyicisi artık pencereyi gizleyip yükseltmeyi iptal etmek yerine çalışan '
                   'uygulamayı doğru biçimde kapatır. Paylaşım uzantısı yüklü olsa bile yeniden kurulum '
                   'sırasında Windows Gezgini açık kalır.')]},
 'uk': {'changes': ['Надсилайте через панель Android, Служби Finder і класичне меню Windows '
                    '(Показати додаткові параметри у Windows 11). Меню Nautilus і Dolphin '
                    'встановлюються в Налаштування > Надсилання файлів.',
                    'Перевірте файли, виберіть один спарений пристрій і підтвердьте. Черга '
                    'зберігається після повторного відкриття, вкладення залишаються для '
                    'призупинених передач.',
                    'Багатомовне надсилання: меню використовують мову системи, а екрани '
                    'підтвердження — мову програми. Підтримуються всі 18 мов.'],
        'fixes': ['Швидке вставлення на Mac: зареєстрований, але не запущений помічник більше не '
                  'вважається готовим. Очікування сеансу, обмежені повтори й ручне відновлення з '
                  'відомостями про помилку.',
                  ('Інсталятор Windows належно завершує запущену програму, а не приховує її вікно та '
                   'скасовує оновлення. Повторне встановлення також не закриває Провідник Windows, якщо в '
                   'ньому завантажено розширення надсилання файлів.')]},
 'vi': {'changes': ['Gửi từ bảng chia sẻ Android, Dịch vụ Finder và menu cổ điển Windows (Hiển thị '
                    'thêm tùy chọn trên Windows 11). Cài menu Nautilus và Dolphin trong Cài đặt > '
                    'Gửi tệp.',
                    'Kiểm tra tệp, chọn một thiết bị đã ghép đôi rồi xác nhận. Các lô đang chờ vẫn '
                    'còn khi mở lại ứng dụng; tệp đính kèm được giữ cho việc truyền đang tạm dừng.',
                    'Chia sẻ đa ngôn ngữ: menu theo ngôn ngữ hệ thống, màn hình xác nhận theo ngôn '
                    'ngữ ứng dụng, hỗ trợ đủ 18 ngôn ngữ.'],
        'fixes': ['Dán nhanh trên Mac: trình trợ giúp đã đăng ký nhưng không khởi động không còn '
                  'được coi là sẵn sàng. Chờ phiên kết nối, giới hạn thử lại và cung cấp sửa thủ '
                  'công cùng chi tiết lỗi.',
                  ('Trình cài đặt Windows nay đóng đúng ứng dụng đang chạy, thay vì ẩn cửa sổ và hủy nâng '
                   'cấp. Cài đặt lại vẫn giữ Windows Explorer hoạt động ngay cả khi đã tải tiện ích chia sẻ.')]}},
    "2.12.1": {'ar': {'changes': ['سبعة سمات مدمجة جديدة: اختر أسطوانات الجاز أو عصر الفضاء أو ممفيس أو مستقبل الألفية أو '
                    'الطباعة الأمريكية القديمة أو ألعاب البكسل أو سطح المكتب الكلاسيكي من الإعدادات > '
                    'المظهر. لكل سمة ألوان فاتحة وداكنة وخطوط عناوين وأشكال عناصر تحكم ورسومات زخرفية '
                    'متناسقة. تبقى السمتان الافتراضية وبكسل متاحتين، ويمكن نسخ أي سمة جديدة وتخصيصها.'],
        'fixes': []},
 'de': {'changes': ['Sieben neue integrierte Designs: Wähle Jazzplatten, Raumfahrtära, Memphis, Y2K-Zukunft, '
                    'Retro-Druck, Pixel-Arcade oder Retro-Desktop unter Einstellungen > Erscheinungsbild. '
                    'Jedes bietet helle und dunkle Farben, passende Überschriftenschriften, '
                    'Steuerelementformen und Illustrationen. Standard und Pixel bleiben verfügbar; neue '
                    'Designs lassen sich zum Anpassen kopieren.'],
        'fixes': []},
 'es': {'changes': ['Siete temas integrados nuevos: elige Discos de jazz, Era espacial, Memphis, Futuro Y2K, '
                    'Impresión retro, Arcade de píxeles o Escritorio retro en Ajustes > Apariencia. Cada uno '
                    'incluye colores claros y oscuros, tipografías de títulos, formas de controles e '
                    'ilustraciones a juego. Los temas Predeterminado y Píxel siguen disponibles; puedes '
                    'copiar cualquier tema nuevo para personalizarlo.'],
        'fixes': []},
 'fr': {'changes': ['Sept nouveaux thèmes intégrés : choisissez Disques de jazz, Ère spatiale, Memphis, '
                    'Futur Y2K, Impression rétro, Arcade pixel ou Bureau rétro dans Réglages > Apparence. '
                    'Chacun propose des couleurs claires et sombres, des polices de titres, des formes de '
                    'contrôles et des illustrations assorties. Les thèmes Par défaut et Pixel restent '
                    'disponibles ; copiez un nouveau thème pour le personnaliser.'],
        'fixes': []},
 'id': {'changes': ['Tujuh tema bawaan baru: pilih Rekaman Jazz, Era Antariksa, Memphis, Masa Depan Y2K, '
                    'Cetakan Retro Amerika, Arkade Piksel, atau Desktop Retro di Pengaturan > Tampilan. '
                    'Masing-masing memiliki warna terang dan gelap, font judul, bentuk kontrol, dan '
                    'ilustrasi yang serasi. Tema Default dan Piksel tetap tersedia; salin tema baru untuk '
                    'menyesuaikannya.'],
        'fixes': []},
 'it': {'changes': ['Sette nuovi temi integrati: scegli Dischi jazz, Era spaziale, Memphis, Futuro Y2K, '
                    'Stampa rétro, Arcade pixel o Desktop rétro in Impostazioni > Aspetto. Ognuno include '
                    'colori chiari e scuri, caratteri per i titoli, forme dei controlli e illustrazioni '
                    'coordinati. I temi Predefinito e Pixel restano disponibili; copia un nuovo tema per '
                    'personalizzarlo.'],
        'fixes': []},
 'ko': {'changes': ['새 기본 테마 7종: 설정 > 모양에서 재즈 레코드, 스페이스 에이지, 멤피스, Y2K 퓨처, 아메리칸 빈티지 인쇄, 픽셀 아케이드, 레트로 데스크톱을 '
                    '선택하세요. 각 테마는 밝고 어두운 색상, 어울리는 제목 글꼴, 컨트롤 모양과 장식 그림을 제공합니다. 기존 기본 및 픽셀 테마도 유지되며, 새 테마를 '
                    '복사해 원하는 대로 바꿀 수 있습니다.'],
        'fixes': []},
 'pl': {'changes': ['Siedem nowych wbudowanych motywów: wybierz Płyty jazzowe, Erę kosmiczną, Memphis, '
                    'Przyszłość Y2K, Druk retro, Pikselowe arcade lub Pulpit retro w Ustawienia > Wygląd. '
                    'Każdy ma jasne i ciemne kolory, dopasowane czcionki nagłówków, kształty kontrolek i '
                    'ilustracje. Motywy Domyślny i Pikselowy pozostają dostępne; skopiuj nowy motyw, aby go '
                    'dostosować.'],
        'fixes': []},
 'pt-BR': {'changes': ['Sete novos temas integrados: escolha Discos de jazz, Era espacial, Memphis, Futuro '
                       'Y2K, Impressão retrô, Arcade pixel ou Área de trabalho retrô em Configurações > '
                       'Aparência. Cada tema inclui cores claras e escuras, fontes de títulos, formas de '
                       'controles e ilustrações combinando. Os temas Padrão e Pixel continuam disponíveis; '
                       'copie um novo tema para personalizá-lo.'],
           'fixes': []},
 'ru': {'changes': ['Семь новых встроенных тем: выберите «Джазовые пластинки», «Космическая эра», «Мемфис», '
                    '«Будущее Y2K», «Винтажная печать», «Пиксельная аркада» или «Ретро-рабочий стол» в '
                    'разделе Настройки > Оформление. У каждой темы есть светлая и тёмная палитры, подходящие '
                    'шрифты заголовков, формы элементов и иллюстрации. Темы «Стандартная» и «Пиксельная» '
                    'сохранены; любую новую тему можно скопировать и изменить.'],
        'fixes': []},
 'tr': {'changes': ['Yedi yeni yerleşik tema: Ayarlar > Görünüm bölümünden Caz Plakları, Uzay Çağı, Memphis, '
                    'Y2K Geleceği, Retro Baskı, Piksel Atari veya Retro Masaüstü seçin. Her tema açık ve '
                    'koyu renkler, uyumlu başlık yazı tipleri, kontrol biçimleri ve süslemeler içerir. '
                    'Varsayılan ve Piksel temaları korunur; yeni bir temayı kopyalayıp '
                    'özelleştirebilirsiniz.'],
        'fixes': []},
 'uk': {'changes': ['Сім нових вбудованих тем: виберіть «Джазові платівки», «Космічна ера», «Мемфіс», '
                    '«Майбутнє Y2K», «Вінтажний друк», «Піксельна аркада» або «Ретро-стільниця» у '
                    'Налаштування > Вигляд. Кожна тема має світлу й темну палітри, відповідні шрифти '
                    'заголовків, форми елементів та ілюстрації. Теми «Типова» й «Піксельна» залишаються; '
                    'нові теми можна копіювати та змінювати.'],
        'fixes': []},
 'vi': {'changes': ['Bảy chủ đề tích hợp mới: chọn Đĩa nhạc jazz, Kỷ nguyên vũ trụ, Memphis, Tương lai Y2K, '
                    'In ấn cổ điển Mỹ, Arcade điểm ảnh hoặc Máy tính để bàn cổ điển trong Cài đặt > Giao '
                    'diện. Mỗi chủ đề có màu sáng và tối, phông tiêu đề, hình dạng điều khiển và hình trang '
                    'trí đồng bộ. Chủ đề Mặc định và Pixel vẫn được giữ; bạn có thể sao chép chủ đề mới để '
                    'tùy chỉnh.'],
        'fixes': []}},
    "2.12.0": {
        "ar": {
            "changes": [
                "نوصي جميع المستخدمين بالترقية إلى 2.12.0 لتسريع النقل المباشر للملفات بين أجهزة الكمبيوتر البعيدة. حدّث جهازَي الإرسال والاستقبال للاستفادة من التسريع. يظل إرسال الملفات واستقبالها مع الإصدارات الأقدم متاحًا.",
                "تسريع النقل المباشر عن بُعد: إذا استمر بطء النقل المباشر بين شبكتين مختلفتين، يجرّب PasteFerry اتصالات متوازية تلقائيًا ويحتفظ بها فقط إذا حسّنت السرعة. لا يلزم إعداد إضافي، ويعتمد التحسن الفعلي على الشبكة.",
                "سلامة النقل: يتم التحقق من كل كتلة متوازية وإعادة تجميع الكتل بالترتيب قبل التحقق المعتاد من الملف كاملًا. تحتفظ عمليات النقل المنقطعة بنقاط الاستئناف الحالية للملفات.",
            ],
            "fixes": [],
        },
        "de": {
            "changes": [
                "Update für alle empfohlen: Mit 2.12.0 werden Dateien direkt zwischen räumlich getrennten Computern schneller übertragen. Aktualisieren Sie beide Computer, um die Beschleunigung zu nutzen. Dateien lassen sich weiterhin mit älteren Versionen senden und empfangen.",
                "Schnellere direkte Fernübertragung: Bleibt eine direkte Dateiübertragung zwischen verschiedenen Netzwerken langsam, testet PasteFerry automatisch parallele Verbindungen und behält sie nur bei, wenn sie die Geschwindigkeit erhöhen. Zusätzliche Einstellungen sind nicht nötig; die tatsächliche Verbesserung hängt vom Netzwerk ab.",
                "Übertragungsintegrität: Parallel übertragene Blöcke werden geprüft und in der richtigen Reihenfolge zusammengesetzt, bevor wie bisher die gesamte Datei geprüft wird. Unterbrochene Übertragungen behalten ihre bisherigen Dateicheckpoints.",
            ],
            "fixes": [],
        },
        "es": {
            "changes": [
                "Actualización recomendada para todos: Instala 2.12.0 para acelerar la transferencia directa de archivos entre ordenadores remotos. Actualiza ambos ordenadores para activar la mejora. Se mantiene el envío y la recepción de archivos con versiones anteriores.",
                "Transferencias directas remotas más rápidas: Si una transferencia directa entre redes distintas sigue siendo lenta, PasteFerry prueba automáticamente conexiones en paralelo y solo las mantiene si mejoran la velocidad. No hace falta configurar nada más; la mejora real depende de la red.",
                "Integridad de la transferencia: Los bloques paralelos se verifican y se reensamblan en orden antes de verificar el archivo completo como hasta ahora. Las transferencias interrumpidas conservan sus puntos de reanudación.",
            ],
            "fixes": [],
        },
        "fr": {
            "changes": [
                "Mise à jour recommandée pour tous : passez à la version 2.12.0 pour accélérer les transferts directs de fichiers entre ordinateurs distants. Mettez les deux ordinateurs à jour pour activer cette amélioration. L’envoi et la réception avec les versions précédentes restent possibles.",
                "Transferts directs à distance plus rapides : lorsqu’un transfert direct entre des réseaux différents reste lent, PasteFerry essaie automatiquement des connexions parallèles et ne les conserve que si elles améliorent le débit. Aucun réglage supplémentaire n’est nécessaire ; le gain réel dépend du réseau.",
                "Intégrité des transferts : les blocs parallèles sont vérifiés et réassemblés dans l’ordre avant la vérification habituelle du fichier complet. Les transferts interrompus conservent leurs points de reprise existants.",
            ],
            "fixes": [],
        },
        "id": {
            "changes": [
                "Disarankan untuk semua pengguna: Perbarui ke 2.12.0 untuk mempercepat transfer file langsung antarkomputer jarak jauh. Perbarui kedua komputer untuk mengaktifkan peningkatan kecepatan. Pengiriman dan penerimaan file dengan versi lama tetap didukung.",
                "Transfer langsung jarak jauh lebih cepat: Jika transfer langsung antara jaringan berbeda terus lambat, PasteFerry otomatis mencoba koneksi paralel dan hanya mempertahankannya jika kecepatannya meningkat. Tidak perlu pengaturan tambahan; peningkatan sebenarnya bergantung pada jaringan.",
                "Integritas transfer: Blok paralel diverifikasi dan disusun kembali sesuai urutan sebelum seluruh file diverifikasi seperti biasa. Transfer yang terputus tetap menyimpan titik lanjut file yang sudah ada.",
            ],
            "fixes": [],
        },
        "it": {
            "changes": [
                "Aggiornamento consigliato a tutti: passa alla versione 2.12.0 per velocizzare il trasferimento diretto di file tra computer remoti. Aggiorna entrambi i computer per attivare il miglioramento. L’invio e la ricezione di file con le versioni precedenti restano disponibili.",
                "Trasferimenti diretti remoti più veloci: se un trasferimento diretto tra reti diverse rimane lento, PasteFerry prova automaticamente connessioni parallele e le mantiene solo se migliorano la velocità. Non occorrono altre impostazioni; il miglioramento effettivo dipende dalla rete.",
                "Integrità dei trasferimenti: i blocchi paralleli vengono verificati e ricomposti nell’ordine corretto prima della consueta verifica dell’intero file. I trasferimenti interrotti conservano i punti di ripresa dei file già registrati.",
            ],
            "fixes": [],
        },
        "ko": {
            "changes": [
                "모든 사용자에게 업데이트를 권장합니다. 2.12.0은 서로 떨어진 컴퓨터 간 직접 파일 전송 속도를 개선합니다. 전송하는 컴퓨터와 받는 컴퓨터를 모두 업데이트하면 속도 개선 기능을 사용할 수 있습니다. 이전 버전과도 계속 파일을 주고받을 수 있습니다.",
                "원격 직접 전송 속도 개선: 서로 다른 네트워크 간 직접 전송이 계속 느리면 PasteFerry가 자동으로 병렬 연결을 시도하고 실제 속도가 향상될 때만 유지합니다. 별도 설정은 필요하지 않으며, 실제 개선 폭은 네트워크에 따라 달라집니다.",
                "전송 무결성: 병렬 블록을 개별 검증하고 순서대로 재조립한 뒤 기존 방식으로 전체 파일을 검증합니다. 전송이 중단되어도 기존 파일 이어받기 지점이 유지됩니다.",
            ],
            "fixes": [],
        },
        "pl": {
            "changes": [
                "Aktualizacja zalecana wszystkim: zainstaluj wersję 2.12.0, aby przyspieszyć bezpośrednie przesyłanie plików między zdalnymi komputerami. Zaktualizuj oba komputery, aby włączyć przyspieszenie. Nadal można wysyłać i odbierać pliki ze starszymi wersjami.",
                "Szybsze bezpośrednie przesyłanie na odległość: gdy transfer bezpośredni między różnymi sieciami pozostaje wolny, PasteFerry automatycznie próbuje połączeń równoległych i zachowuje je tylko wtedy, gdy poprawiają szybkość. Dodatkowa konfiguracja nie jest potrzebna; rzeczywista poprawa zależy od sieci.",
                "Integralność transferu: bloki równoległe są sprawdzane i składane we właściwej kolejności przed dotychczasową weryfikacją całego pliku. Przerwane transfery zachowują istniejące punkty wznowienia plików.",
            ],
            "fixes": [],
        },
        "pt-BR": {
            "changes": [
                "Atualização recomendada para todos: instale a versão 2.12.0 para acelerar a transferência direta de arquivos entre computadores remotos. Atualize os dois computadores para ativar a melhoria. O envio e o recebimento de arquivos com versões anteriores continuam funcionando.",
                "Transferências diretas remotas mais rápidas: quando uma transferência direta entre redes diferentes continua lenta, o PasteFerry testa automaticamente conexões paralelas e só as mantém se melhorarem a velocidade. Não é necessário configurar nada; a melhoria real depende da rede.",
                "Integridade da transferência: os blocos paralelos são verificados e remontados na ordem correta antes da verificação habitual do arquivo completo. As transferências interrompidas mantêm os pontos de retomada dos arquivos já registrados.",
            ],
            "fixes": [],
        },
        "ru": {
            "changes": [
                "Обновление рекомендуется всем: установите версию 2.12.0 для ускорения прямой передачи файлов между удалёнными компьютерами. Чтобы включить ускорение, обновите оба компьютера. Отправка и получение файлов со старыми версиями по-прежнему работают.",
                "Ускорение прямой передачи между удалёнными компьютерами: если прямая передача между разными сетями остаётся медленной, PasteFerry автоматически пробует параллельные соединения и сохраняет их только при росте скорости. Дополнительная настройка не нужна; фактический прирост зависит от сети.",
                "Целостность передачи: параллельные блоки проверяются и собираются по порядку перед обычной проверкой всего файла. При прерывании передачи сохраняются существующие точки возобновления файлов.",
            ],
            "fixes": [],
        },
        "tr": {
            "changes": [
                "Tüm kullanıcılara güncelleme önerilir: Uzak bilgisayarlar arasında doğrudan dosya aktarımını hızlandırmak için 2.12.0 sürümüne geçin. Hızlandırmayı etkinleştirmek için her iki bilgisayarı da güncelleyin. Eski sürümlerle dosya gönderme ve alma çalışmaya devam eder.",
                "Daha hızlı uzak doğrudan aktarım: Farklı ağlar arasındaki doğrudan aktarım yavaş kalırsa PasteFerry otomatik olarak paralel bağlantıları dener ve yalnızca hızı artıran bağlantıları tutar. Ek ayar gerekmez; gerçek hız artışı ağınıza bağlıdır.",
                "Aktarım bütünlüğü: Paralel bloklar doğrulanıp sırayla birleştirildikten sonra dosyanın tamamı eskisi gibi doğrulanır. Kesilen aktarımlarda dosyaların mevcut devam noktaları korunur.",
            ],
            "fixes": [],
        },
        "uk": {
            "changes": [
                "Оновлення рекомендовано всім: установіть версію 2.12.0, щоб пришвидшити пряму передачу файлів між віддаленими комп’ютерами. Для ввімкнення прискорення оновіть обидва комп’ютери. Надсилання й отримання файлів зі старими версіями й надалі працюють.",
                "Швидша пряма передача між віддаленими комп’ютерами: якщо пряма передача між різними мережами залишається повільною, PasteFerry автоматично випробовує паралельні з’єднання й залишає їх лише тоді, коли швидкість зростає. Додаткові налаштування не потрібні; фактичне покращення залежить від мережі.",
                "Цілісність передачі: паралельні блоки перевіряються та збираються за порядком перед звичайною перевіркою всього файлу. Перервані передачі зберігають наявні точки відновлення файлів.",
            ],
            "fixes": [],
        },
        "vi": {
            "changes": [
                "Khuyến nghị tất cả người dùng cập nhật: Nâng cấp lên 2.12.0 để tăng tốc truyền tệp trực tiếp giữa các máy tính ở xa. Cập nhật cả máy gửi và máy nhận để bật tính năng tăng tốc. Bạn vẫn có thể gửi và nhận tệp với các phiên bản cũ.",
                "Truyền trực tiếp từ xa nhanh hơn: Khi truyền trực tiếp giữa các mạng khác nhau vẫn chậm, PasteFerry tự động thử các kết nối song song và chỉ giữ lại nếu chúng cải thiện tốc độ. Không cần thiết lập thêm; mức cải thiện thực tế phụ thuộc vào mạng.",
                "Tính toàn vẹn khi truyền: Các khối song song được xác minh và ghép lại đúng thứ tự trước khi toàn bộ tệp được xác minh như trước. Các lượt truyền bị gián đoạn vẫn giữ các điểm tiếp tục của tệp đã có.",
            ],
            "fixes": [],
        },
    },
}
