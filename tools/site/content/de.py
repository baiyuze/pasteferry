"""Website copy: German. Translation-assisted; key product copy and app terminology reviewed."""

C = {'brand': 'PasteFerry',
 'brand_alt': ['隔空贴', 'CopySync'],
 'title': 'PasteFerry: geräteübergreifende Zwischenablage, Verlauf und Dateiübertragung',
 'description': 'Kopieren und Einfügen zwischen Computern, Durchsuchen des Verlaufs Ihrer Zwischenablage und '
                'Senden von Fotos und Dateien zwischen Computern und Android. Mac, Windows, Linux, Android '
                'und eine Telefon-Webseite. Android und Web funktionieren im selben Netzwerk. Kostenlos und '
                'Open Source.',
 'og_title': 'PasteFerry: geräteübergreifende Zwischenablage, Verlauf und Dateiübertragung',
 'og_description': 'Kopieren und Einfügen zwischen Computern, Durchsuchen des Verlaufs Ihrer Zwischenablage '
                   'und Senden von Fotos und Dateien zwischen Computern und Android. Mac, Windows, Linux, '
                   'Android und eine Telefon-Webseite. Android und Web funktionieren im selben Netzwerk. '
                   'Kostenlos und Open Source.',
 'og_image': 'og-en.png',
 'skip': 'Zum Inhalt springen',
 'home_label': 'PasteFerry Startseite',
 'nav_label': 'Seite',
 'nav_start': 'Schnellstart',
 'nav_how': 'Wie es funktioniert',
 'nav_faq': 'FAQ',
 'nav_server': 'Möglichkeiten zur Verbindung',
 'nav_download': 'Download',
 'lang_label': 'Sprache',
 'h1': 'Ihre Computer. Ihr Smartphone.<br>Alles in Reichweite.',
 'lede': 'Auf einem Computer kopieren, auf einem anderen einfügen. Frühere Einträge wiederfinden und Fotos '
         'und Dateien zwischen Mac, Windows, Linux und Android übertragen – ohne gemeinsames Konto. Auf dem '
         'Smartphone lässt sich die Webversion per Code öffnen. Android und die Webversion funktionieren im '
         'selben Netzwerk.',
 'dl_button': 'PasteFerry herunterladen',
 'dl_mac': 'Für Mac herunterladen',
 'dl_win': 'Herunterladen für Windows',
 'dl_linux': 'Herunterladen für Linux',
 'dl_note': 'Version 2.13.1, kostenlos und Open Source. Für macOS 13 oder neuer, Windows 10 und 11, Linux '
            '(x64 und ARM64) sowie Android 9 oder neuer. Mit der neuen Oberflächengröße lassen sich Text, '
            'Symbole und Abstände gemeinsam vergrößern oder verkleinern.',
 'start_link': 'Neu hier? Richten Sie es in drei Schritten ein →',
 'stage_label': 'Demo: Befehl C auf einem MacBook verwandelt eine Datei in ein Blatt, das über eine direkte '
                'Verbindung zu einem Windows -Laptop fliegt, wo Ctrl V pastes it',
 'stage_file': 'Q3-Überprüfung – final.pptx',
 'stage_win': 'Windows Laptop',
 'stage_arc': 'Direkt, Ende-zu-Ende-verschlüsselt',
 'replay': 'Spielen Sie noch einmal',
 'paths_h2': 'So verbinden sich Ihre Computer',
 'paths_intro': 'Im selben Netzwerk installieren und koppeln. Aktivieren Sie in verschiedenen Netzwerken den '
                'Dienst oder führen Sie Ihren eigenen Server oder Tailscale aus.',
 'paths_after': 'Neu hier? Befolgen Sie die Kurzanleitung <a href="{start}#server"></a>. Der Service ist '
                'kostenlos: 100 MB Relay pro Tag, Direktverbindungen unbegrenzt.',
 'plans_label': 'Möglichkeiten zur Verbindung',
 'plans': {'lan': {'name': 'Gleiches Netzwerk',
                   'fit': 'Nichts einzurichten',
                   'summary': 'Zwei Computer am selben Router: App installieren, Pairing-Code eingeben, '
                              'fertig. Kein Server erforderlich.',
                   'go': 'Gleicher Netzwerkführer →',
                   'facts': [('Am besten für',
                              'Zu Hause oder im Büro, wobei beide Computer im selben Wi-Fi- oder '
                              'kabelgebundenen Netzwerk sind.'),
                             ('Du brauchst', 'Nichts als die App auf jedem Computer.'),
                             ('Denken Sie daran',
                              'Die Synchronisierung stoppt, wenn Sie das Netzwerk verlassen, und wird '
                              'fortgesetzt, wenn Sie zurückkommen. Wenn sich Kabel und WLAN in '
                              'unterschiedlichen Subnetzen befinden, geben Sie beim Pairing eine zusätzliche '
                              'Adresse ein.')],
                   'steps': ['Installieren Sie die App auf jedem Computer und klicken Sie auf '
                             'Hintergrundsynchronisierung aktivieren.',
                             'Lassen Sie PasteFerry zu, wenn die Windows Firewall oder macOS nach dem '
                             'lokalen Netzwerk fragt.',
                             'Zeigen Sie einen Code auf einem Computer vor, geben Sie ihn auf dem anderen '
                             'ein und vergleichen Sie Fingerabdrücke. Geben Sie in einem anderen Subnetz '
                             'auch die unter dem Code angezeigte Adresse ein; Weitere Informationen finden '
                             'Sie im <a href="{lan}#subnet">-Netzwerkhandbuch</a>.'],
                   'address': 'Es muss keine Serveradresse eingegeben werden.'},
           'cloud': {'name': 'Ihr eigener öffentlicher Server',
                     'fit': 'Ihr Server, unbegrenztes Relay',
                     'summary': 'Eine Linux -VM mit einer öffentlichen IP; die kleinste Größe reicht aus. '
                                'Jeder Computer verbindet sich damit und synchronisiert von überall aus.',
                     'go': 'Leitfaden für öffentliche Server →',
                     'facts': [('Am besten für',
                                'Betreiben Sie den Server selbst oder leiten Sie viel Datenverkehr weiter.'),
                               ('Du brauchst', 'Eine Linux -VM mit öffentlicher IP und Root-Zugriff.'),
                               ('Denken Sie daran',
                                'Die VM kostet Geld und die Relay-Geschwindigkeit wird durch ihre Bandbreite '
                                'begrenzt. Geben Sie auf dem chinesischen Festland die IP ein, es sei denn, '
                                'die Domain verfügt über eine ICP-Einreichung.')],
                     'steps': ['Öffnen Sie in der Sicherheitsgruppe Ihres Cloud-Anbieters TCP 8787, UDP 3478 '
                               'und UDP 32768–60999.',
                               'Melden Sie sich mit ssh an, laden Sie das Installationsskript herunter und '
                               'führen Sie es aus: <code>sudo ./install.sh PUBLIC_IP</code>.',
                               'Geben Sie unter Einstellungen → Verbindung auf jedem Computer '
                               '<code>ws://PUBLIC_IP:8787/signal</code>ein, drücken Sie die Eingabetaste und '
                               'koppeln Sie dann.'],
                     'address': 'Öffnen Sie <code>http://PUBLIC_IP:8787/healthz</code> in einem Browser. '
                                'Wenn dort „OK“ steht, läuft es.'},
           'ts': {'name': 'Tailscale',
                  'fit': 'Über Netzwerke hinweg, kein Server',
                  'summary': 'Installieren Sie Tailscale auf jedem Computer, melden Sie sich bei demselben '
                             'Konto an und geben Sie beim Koppeln die Tailscale -Adresse des anderen '
                             'Computers ein.',
                  'go': 'Tailscale -Anleitung →',
                  'facts': [('Am besten für',
                             'Sie verwenden Tailscale bereits oder möchten nicht auf einen Server angewiesen '
                             'sein.'),
                            ('Du brauchst', 'Tailscale auf jedem Computer, angemeldet bei demselben Konto.'),
                            ('Denken Sie daran',
                             'Tailscale muss verbunden bleiben. Wenn zwei Computer nicht direkt verbunden '
                             'werden können, erfolgt die Weiterleitung über eigene Server, was langsam sein '
                             'kann.')],
                  'steps': ['Installieren Sie Tailscale auf jedem Computer und melden Sie sich bei demselben '
                            'Konto an.',
                            'Führen Sie auf dem anderen Computer <code>tailscale ip -4</code> aus und '
                            'notieren Sie sich die Adresse, die mit 100 beginnt.',
                            'Klicken Sie beim Koppeln auf In einem anderen Subnetz? und geben Sie diese '
                            'Adresse ein.'],
                  'address': 'Kein Server erforderlich. Eine Tailscale -Adresse ändert sich nicht, Sie '
                             'müssen sie also beim Pairing einmal eingeben.'}},
 'flow_h2': 'Was passiert beim Kopieren?',
 'flow_intro': 'Texte, Bilder und Dateien nehmen alle denselben Weg.',
 'flow': [('Hinweis', 'Der Hintergrunddienst erkennt, dass sich die Zwischenablage geändert hat.'),
          ('Senden',
           'Texte und Dateien bis zu 50 MB werden sofort übernommen. Größere Exemplare werden zunächst als '
           'Datensatz versendet.'),
          ('Einfügen',
           'Der andere Computer speichert es lokal und legt es in der Zwischenablage ab. Sie fügen eine '
           'echte Datei ein.')],
 'why_h2': 'Warum nicht das nutzen, was Sie bereits haben?',
 'why_intro': 'Universal Clipboard benötigt dasselbe Apple ID, AirDrop lässt Sie jedes Mal akzeptieren, und '
              'keines von beiden funktioniert zwischen einem Mac und einem Windows PC.',
 'compare_caption': 'PasteFerry im Vergleich zu anderen Optionen',
 'compare_cols': ['PasteFerry', 'Universelle Zwischenablage', 'AirDrop', 'Chat-Apps'],
 'compare_rows': [('Kein Konto erforderlich',
                   [('yes', 'Ja'),
                    ('no', 'Gleiches Apple ID'),
                    ('partial', 'Nur Apple-Geräte'),
                    ('no', 'Anmeldung erforderlich')]),
                  ('Zwischen Mac, Windows, Linux und Android',
                   [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('yes', 'Ja')]),
                  ('Zwischen Zuhause und Büro',
                   [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('yes', 'Ja')]),
                  ('In einem lokalen Netzwerk ohne Internet',
                   [('yes', 'Ja'), ('partial', 'Nur in der Nähe'), ('yes', 'Ja'), ('no', 'Nein')]),
                  ('Direkt nach dem Kopieren einfügen, nichts zu akzeptieren',
                   [('yes', 'Ja'), ('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein')]),
                  ('Dateien und ganze Ordner jeder Größe',
                   [('yes', 'Ja'),
                    ('partial', 'Unzuverlässig'),
                    ('yes', 'Ja'),
                    ('partial', 'Reißverschluss zuerst, Größenbeschränkungen')]),
                  ('Finden Sie etwas, das Sie zuvor kopiert haben',
                   [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('partial', 'Scrollen Sie zurück')]),
                  ('Nur Ihre Geräte können entschlüsseln',
                   [('yes', 'Ja'), ('yes', 'Ja'), ('yes', 'Ja'), ('some', 'Hängt von der App ab')])],
 'tour_compare_rows': [('Verschiedene Apple-IDs',
                        [('yes', 'Ja'),
                         ('no', 'Nein'),
                         ('partial', 'Muss akzeptiert werden'),
                         ('yes', 'Ja')]),
                       ('Zwischen Mac, Windows und Linux',
                        [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('yes', 'Ja')]),
                       ('Zwischen Zuhause und Büro',
                        [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('yes', 'Ja')]),
                       ('Direkt nach dem Kopieren einfügen',
                        [('yes', 'Ja'), ('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein')]),
                       ('Dateien und ganze Ordner',
                        [('yes', 'Ja'),
                         ('partial', 'Unzuverlässig'),
                         ('yes', 'Ja'),
                         ('partial', 'Zuerst zippen')]),
                       ('Finden Sie etwas, das Sie zuvor kopiert haben',
                        [('yes', 'Ja'), ('no', 'Nein'), ('no', 'Nein'), ('partial', 'Scrollen Sie zurück')]),
                       ('Nur Ihre Geräte können entschlüsseln',
                        [('yes', 'Ja'), ('yes', 'Ja'), ('yes', 'Ja'), ('some', 'Hängt von der App ab')])],
 'how_h2': 'Wie es funktioniert',
 'how_intro': 'Im selben Netzwerk finden sich die Computer direkt zueinander. In verschiedenen Netzwerken '
              'stellt ein Server sie vor, sodass sie versuchen können, eine direkte Verbindung herzustellen, '
              'und leitet sie nur weiter, wenn dies fehlschlägt. Inhalte werden immer verschlüsselt.',
 'diagram': {'title': 'Wie PasteFerry eine Verbindung herstellt',
             'desc': 'Computer A und Computer B verbinden sich direkt über WebRTC. Beide stellen zur '
                     'Signalisierung eine Verbindung zum Server her. Wenn die direkte Verbindung '
                     'fehlschlägt, werden die Daten über den TURN-Dienst des Servers weitergeleitet.',
             'server': 'Signalisierungs- und Relaisdienst',
             'server_sub': 'Signalisierung, STUN, TURN-Relais',
             'sig_note': 'Signalisierung: Verbindungsdetails',
             'relay_note': 'Relais: nur bei direktem Ausfall',
             'copy_here': 'Du kopierst hierher',
             'other': 'Mac, Windows oder Linux',
             'paste_here': 'Sie fügen hier ein',
             'direct': 'Direkte WebRTC-, DTLS -Verschlüsselung',
             'direct_note': 'Daten werden nur zwischen Ihren Computern übertragen',
             'legend_direct': 'Daten (direkt)',
             'legend_relay': 'Daten (Relay, Fallback)',
             'legend_sig': 'Signalisierung'},
 'uplink_h2': 'Auch direkt in Büronetzwerken',
 'uplink_intro': 'Früher liefen Büronetzwerke mit mehreren Uplinks über das Relay. PasteFerry findet jeden '
                 'Uplink und lässt die andere Seite jeden einzelnen ausprobieren.',
 'uplink_changed': 'Was es bewirkt',
 'uplink_points': [('Ein gemeinsamer Port.', 'Alle Verbindungen verwenden denselben UDP -Port.'),
                   ('Jeder Uplink wurde untersucht.',
                    'Es fragt sieben Server gleichzeitig an und erhält eine Adresse pro Uplink.'),
                   ('Alle wurden auf die andere Seite geschickt.',
                    'Der andere Computer probiert jeden aus, bis einer durchkommt.'),
                   ('Im Leerlauf direkt erneut versuchen.',
                    'Das Relais sorgt dafür, dass alles funktioniert, und schaltet im Leerlauf auf '
                    'Direktbetrieb.')],
 'lab_h3': 'Getestet an realen Netzwerk-Setups',
 'lab_intro': 'Jeder Commit wird automatisch in simulierten Netzwerken getestet.',
 'lab_cols': ['Szenario', 'Ergebnis'],
 'lab_rows': [('Einzelner Uplink ↔ Heimrouter', 'Direkt'),
              ('Zwei Uplinks, Vorgängerversion (Steuerung)', 'Relay'),
              ('Vier Uplinks ↔ Heimrouter', 'Direkt'),
              ('Zwei Uplinks ↔ zwei Uplinks', 'Direkt'),
              ('Zwei Uplinks ↔ NAT, das Ports randomisiert', 'Relay'),
              ('Zunächst blockiert, das Netzwerk wird später wiederhergestellt', 'Weiterleiten, dann direkt'),
              ('Kein Server, dasselbe Subnetz', 'Direkt'),
              ('Kein Server, voneinander isolierte Subnetze', 'Keine Verbindung')],
 'uplink_measured': 'Gemessen: ein Mac in einem 4-Uplink-Büronetzwerk und einer zu Hause, zuvor mit 0,6 MB/s '
                    'weitergeleitet. Jetzt verbinden sie sich direkt.',
 'uplink_doc': 'Einzelheiten finden Sie im <a href="{doc}">-Designdokument</a> (auf Chinesisch).',
 'security_h2': 'Der Server kann nicht sehen, was Sie kopieren',
 'security_points': [('Keine Konten, keine gespeicherten Inhalte.',
                      'Die Identität eines Geräts ist ein Schlüssel, daher benötigt der Server keine '
                      'Benutzertabelle.'),
                     ('Überprüfen Sie beim Koppeln die Fingerabdrücke.',
                      'Auf beiden Bildschirmen wird derselbe Fingerabdruck angezeigt; Wenn jemand einen '
                      'Schlüssel austauscht, stimmt er nicht überein.'),
                     ('Jede Nachricht ist signiert,',
                      'Daher kann sich der Server nicht als Ihr Gerät ausgeben.'),
                     ('Das Relay leitet nur Chiffretext weiter.',
                      'Relay-Zugangsdaten verfallen nach 12 Stunden.'),
                     ('Privat auch im lokalen Netzwerk.',
                      'Ein Gerät sendet ein anonymes Token, das sich täglich ändert, sodass niemand erkennen '
                      'kann, um welchen Computer es sich handelt.')],
 'verify_alt': 'Die Fingerabdruckprüfung während der Kopplung zeigt R8NF-2WTC-QL5J an und fordert Sie auf, '
               'zu bestätigen, dass er genau mit dem anderen Computer übereinstimmt',
 'fallback_h2': 'Wenn etwas schief geht',
 'fallback_intro': 'Die häufigsten Fälle werden behandelt.',
 'fallbacks': [('Der andere Computer im Netzwerk kann nicht gefunden werden',
                'Geben Sie beim Pairing die Adresse ein. man erinnert sich später daran.'),
               ('Keine direkte Verbindung',
                'Die Daten werden weiterhin verschlüsselt über den Server weitergeleitet.'),
               ('Der andere Computer geht in den Ruhezustand oder bricht ab',
                'Es stellt die Verbindung von selbst wieder her, wenn es zurück ist.'),
               ('Beim Senden von Dateien wurde die Verbindung unterbrochen',
                'Die Übertragung wird dort fortgesetzt, wo sie gestoppt wurde.'),
               ('Ein Dateiname, der Windows nicht zulässt',
                'Schlechte Zeichen werden zu Zeichen voller Breite, sodass der Name immer noch derselbe '
                'lautet.'),
               ('Ein Passwort kopieren',
                'Bei Windows wird alles, was von einem Passwort-Manager kopiert wird, übersprungen.')],
 'install_h2': 'Installieren',
 'install_intro': 'Installieren Sie die App auf jedem Computer. Zum ersten Mal? Befolgen Sie die '
                  'Kurzanleitung <a href="{start}"></a>.',
 'server_intro': 'Im selben Netzwerk installieren und koppeln. Aktivieren Sie in verschiedenen Netzwerken '
                 'den Dienst. Wenn Sie die volle Kontrolle wünschen, betreiben Sie Ihren eigenen Server oder '
                 'verwenden Sie Tailscale.',
 'copy': 'Kopieren',
 'copied': 'Kopiert',
 'pairing': 'Zeigen Sie einen Kopplungscode auf einem Computer an, geben Sie ihn auf dem anderen ein und '
            'prüfen Sie, ob beide Fingerabdruckzeilen übereinstimmen, bevor Sie bestätigen. Mit Service '
            'benötigen Sie nicht die Adresse des anderen Computers; Sie geben einen nur subnetzübergreifend '
            'oder mit Tailscale ein.',
 'specs_h2': 'Spezifikationen',
 'specs': [('Version', '2.13.1, veröffentlicht <time datetime="2026-11-20">20. November 2026</time>'),
           ('Mac-App',
            'macOS 13 Ventura oder höher; separate Downloads für Apple Silicon und Intel, jeweils ca. 25 MB, '
            'kein Rosetta; eine Universalversion für beide ist etwa 47 MB groß'),
           ('Windows -App',
            'Windows 10 und Windows 11, x64; Installation pro Benutzer, keine Administratorrechte; ca. 23 MB '
            'Download'),
           ('Linux -App',
            'x64 und ARM64; .deb (Debian, Ubuntu und ähnlich) oder tar.gz (andere Distributionen), ca. 22 '
            'MB; benötigt einen X11-Desktop oder einen Wayland-Desktop mit XWayland (GNOME, KDE und andere '
            'enthalten ihn standardmäßig); GTK 3'),
           ('Server',
            'Beim Service oder im selben Netzwerk nicht erforderlich. So führen Sie Ihr eigenes aus: Linux '
            'x86_64/ARM64, macOS oder Windows 10/11 x64.'),
           ('Sprachen',
            '18 Sprachen: Englisch, vereinfachtes und traditionelles Chinesisch (Taiwan und Hongkong), '
            'Japanisch, Koreanisch, Arabisch (von rechts nach links), Deutsch, Französisch, Spanisch, '
            'Portugiesisch (Brasilien), Italienisch, Russisch, Ukrainisch, Polnisch, Türkisch, Vietnamesisch '
            'und Indonesisch; folgt standardmäßig dem System und kann in den Einstellungen umgeschaltet '
            'werden'),
           ('Inhalt',
            'Nur-Text, Rich-Text, Bilder und Screenshots, Dateien, Ordner; Jeder Typ kann ausgeschaltet '
            'werden'),
           ('Transport',
            'WebRTC Datenkanäle, direkt zuerst mit TURN-Relais-Fallback; im selben Netzwerk, mDNS-Erkennung '
            'und Verbindungsdetails über UDP 8788; jeder in Multi-Uplink-Netzwerken untersuchte Uplink; '
            'Dateien werden als tar + zstd gestreamt'),
           ('Verschlüsselung und Identität',
            'End-to-End DTLS; Ed25519 Geräteschlüssel; Jede Signalisierungsnachricht wird signiert'),
           ('Paarung',
            '6-stelliger Code, gültig für 5 Minuten, unter Verwendung eines Alphabets ohne Doppelgänger wie '
            '0/O und 1/I; von Ihnen überprüfte Fingerabdrücke'),
           ('Auto-Sync-Limit', 'Standardmäßig 50 MB, einstellbar von 1 MB bis 1 GB'),
           ('Dateien senden',
            'Auf ein Gerät, jede Größe, Dateien oder ganze Ordner; im lokalen Netzwerk über eine '
            'verschlüsselte TCP -Verbindung (beide Seiten benötigen 2.5.1), wobei auf WebRTC zurückgegriffen '
            'wird, wenn diese nicht verfügbar ist; WebRTC über das Internet und Relay; wird nach einer '
            'Verbindungsunterbrechung fortgesetzt; SHA-256 pro Datei. Gemessener Mac an Linux VM, 1 GB: '
            '144,3 MB/s; Die tatsächliche Geschwindigkeit hängt vom Netzwerk und den Festplatten ab.'),
           ('Kontakte',
            '7-stelliger Kontaktcode, der mit F beginnt und über das lokale Netzwerk oder den Dienst '
            'ausgetauscht wird, mit optionaler Sicherheitscodeprüfung; Kontakte können sich gegenseitig nur '
            'Dateien und Bilder mit einer Notiz von bis zu 200 Zeichen senden, und jeder Stapel muss '
            'akzeptiert werden; Kontakte sehen nie Ihre Zwischenablage, Ihren Verlauf oder Ihre Geräte; '
            'Empfangene Dateien verlieren das ausführbare Bit und werden auf einem Mac unter Quarantäne '
            'gestellt. beide Seiten benötigen 2.6 oder höher'),
           ('Verlauf',
            'Standardmäßig 3 Tage, einstellbar von 1 Stunde bis 30 Tagen; Abgelaufene Artikel werden '
            'automatisch entfernt'),
           ('Gemessene Geschwindigkeit',
            'Eine 20-MB-Datei wird in etwa 330 ms über eine direkte LAN-Verbindung übertragen, wobei die '
            'Prüfsummen übereinstimmen'),
           ('Gebaut mit',
            'Entscheiden Sie sich für den Hintergrunddienst und Server (reines Go, das Win32 auf Windows '
            'aufruft und das X11-Protokoll auf Linux spricht), Flutter für die App (eine Codebasis für alle '
            'drei Systeme), Protokollpuffer für Nachrichten'),
           ('Lizenz',
            '<a href="https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md">GNU AGPL-3.0</a>')],
 'faq_h2': 'Fragen',
 'faq': [('Wie unterscheidet sich das von der universellen Zwischenablage?',
          ['Die universelle Zwischenablage funktioniert nur zwischen nahegelegenen Apple-Geräten auf '
           'demselben Apple ID. PasteFerry kümmert sich nicht um Konten, funktioniert auf Mac, Windows und '
           'Linux sowie zwischen Zuhause und dem Büro.']),
         ('Wie unterscheidet sich das von AirDrop?',
          ['AirDrop funktioniert nur zwischen Apple-Geräten in der Nähe.  „Dateien senden“ von PasteFerry '
           'funktioniert zwischen Mac, Windows und Linux, auch über Netzwerke hinweg. Es kommuniziert nicht '
           'mit AirDrop; beide Seiten benötigen PasteFerry.']),
         ('Brauche ich einen eigenen Server?',
          ['Nein. Im selben Netzwerk installieren und koppeln; Aktivieren Sie in verschiedenen Netzwerken '
           'den <a href="{official}">-Dienst</a>. Sie können <a href="{cloud}">auch Ihren eigenen Server</a> '
           'oder <a href="{ts}">Tailscale</a>verwenden.']),
         ('Keine öffentliche IP zu Hause. Kann ich zwischen Zuhause und dem Büro synchronisieren?',
          ['Ja, aktivieren Sie den <a href="{official}">-Dienst</a>.']),
         ('Kann der Server sehen, was ich kopiere?',
          ['Nein, der Inhalt ist Ende-zu-Ende-verschlüsselt. Weitere Informationen finden Sie in der '
           'Datenschutzerklärung <a href="{privacy}"></a>.']),
         ('Wie viel Staffel bekomme ich?',
          ['100 MB pro Computer und Tag; Direktverbindungen zählen nicht. Wenn es aufgebraucht ist, '
           'funktioniert Direct immer noch. Ohne Limit betreiben Sie mit <a href="{cloud}">Ihren eigenen '
           'Server</a>.']),
         ('Beide Computer befinden sich im selben Netzwerk. Warum können sie sich nicht finden?',
          ['Normalerweise befinden sie sich in unterschiedlichen Subnetzen oder werden von einer Firewall '
           'blockiert. Klicken Sie beim Koppeln auf In einem anderen Subnetz? und geben Sie die andere '
           'Adresse ein. Mehr im <a href="{lan}#faq">gleichen Netzwerkhandbuch</a>.']),
         ('Kann ich Dateien an den Computer einer anderen Person senden?',
          ['Ja. Fügen Sie sie ab 2.6 als Kontakt hinzu, keine Kopplung erforderlich; Die Übertragung '
           'beginnt, sobald sie akzeptiert haben. Kontakte können Ihre Zwischenablage oder Ihren Verlauf '
           'nicht sehen.']),
         ('Was ist mit großen Dateien?',
          ['Beim Kopieren werden bis zu 50 MB gesendet. Größere Dateien werden abgerufen, wenn Sie sie '
           'benötigen, oder verwenden Sie „Dateien senden“, für das es keine Größenbeschränkung gibt.']),
         ('Windows? Linux? iPhone?',
          ['Windows 10 und 11 und Linux auf x64 und ARM64. iPhone und iPad werden nicht unterstützt: iOS '
           'lässt nicht zu, dass Apps die Zwischenablage im Hintergrund lesen.']),
         ('Warum warnt mich das System beim ersten Mal?',
          ['PasteFerry ist noch nicht von Apple notariell beglaubigt oder für Windows codesigniert. Klicken '
           'Sie auf einem Mac in den Systemeinstellungen → Datenschutz und Sicherheit auf „Trotzdem öffnen“; '
           'Klicken Sie unter Windows auf Weitere Informationen → Trotzdem ausführen. Dies machen Sie nur '
           'einmal.']),
         ('Ist es kostenlos? Kann mein Unternehmen es nutzen?',
          ['Ja, kostenlos für Privatpersonen und Unternehmen. PasteFerry ist Open Source unter der GNU '
           'AGPL-3.0.']),
         ('Verbindet es sich direkt mit Büronetzwerken mit mehreren Uplinks?',
          ['Ja. PasteFerry versucht jeden Uplink.']),
         ('Warum werden .uuremote_-Dateien weiterhin angezeigt, während UU Remote ausgeführt wird?',
          ['Das war ein Fehler in älteren Versionen. Aktualisieren Sie auf die neueste Version.'])],
 'closing': 'Ihre Geräte. Ihre Inhalte. In Reichweite.',
 'footer_license': 'PasteFerry ist Open Source unter der GNU AGPL-3.0.',
 'footer_label': 'Fußzeile',
 'footer_links': [('Alle Veröffentlichungen', 'https://github.com/baiyuze/pasteferry/releases'),
                  ('Änderungsprotokoll', 'https://github.com/baiyuze/pasteferry/blob/main/CHANGELOG.md'),
                  ('Designhinweise (Chinesisch)', 'https://pasteferry.cc/design/nat-traversal.html'),
                  ('Lizenz', 'https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md'),
                  ('Melden Sie ein Problem', 'https://github.com/baiyuze/pasteferry/issues')],
 'guide': {'title': 'Führen Sie einen PasteFerry -Server in Ihrem LAN aus: Windows, Mac und Linux',
           'description': 'Wenn Ihre Computer ein Netzwerk teilen, benötigen Sie keinen Cloud-Server. Führen '
                          'Sie den Signalisierungs- und TURN-Server von PasteFerry auf jedem ständig aktiven '
                          'Windows-, Mac- oder Linux -Computer mit einem Skript aus. es startet beim Booten. '
                          'Beinhaltet App-Einrichtung und Fehlerbehebung.',
           'h1': 'Führen Sie den Server in Ihrem LAN aus',
           'lede': 'Wenn sich Ihre Computer im selben Heim- oder Büronetzwerk befinden, benötigen Sie keinen '
                   'Cloud-Server. Wählen Sie einen Computer aus, der eingeschaltet bleibt, laden Sie ein '
                   'Skript herunter, führen Sie es aus und geben Sie dann auf jedem Computer die Adresse '
                   'ein, die gedruckt wird, in PasteFerry .',
           'notice': '<strong>Im selben Netzwerk benötigen Sie keinen Server mehr:</strong> App installieren '
                     'und koppeln; Weitere Informationen finden Sie im <a '
                     'href="{lan}">-Netzwerkhandbuch</a>. Diese Anleitung hilft immer noch, wenn zwei '
                     'Subnetze einander nicht erreichen können und der Datenverkehr über einen Computer '
                     'geleitet werden muss, den beide erreichen können.',
           'toc': [('prepare', 'Bevor Sie beginnen'),
                   ('install', 'Installieren'),
                   ('check', 'Überprüfen'),
                   ('clients', 'Richten Sie die Apps ein'),
                   ('faq', 'Fragen')],
           'overview_h2': 'Der Server führt nur Geräte ein',
           'overview_intro': 'Jeder Computer bleibt mit dem Server verbunden, sodass er sich gegenseitig '
                             'findet und Verbindungsdetails austauscht. Sobald die Verbindung hergestellt '
                             'ist, wird das, was Sie kopieren, direkt zwischen den beiden Computern '
                             'übertragen. Erst wenn dies fehlschlägt, passiert es weiterhin verschlüsselt '
                             'den Server.',
           'diagram': {'title': 'PasteFerry in einem LAN',
                       'desc': 'In einem LAN verbinden sich ein Mac und ein Windows -PC zur Signalisierung '
                               'mit dem Server unter 192.168.1.20. Kopierte Inhalte werden direkt zwischen '
                               'den beiden Computern und nur dann über das TURN-Relay des Servers '
                               'übertragen, wenn eine direkte Verbindung fehlschlägt.',
                       'lan': 'Ihr LAN: dasselbe WLAN oder kabelgebundene Netzwerk',
                       'server': 'Server',
                       'sig_note': 'Signalisierung, TCP 8787',
                       'relay_note': 'Relais, UDP 3478, wenn direkt ausfällt',
                       'client': 'Ausführen von PasteFerry',
                       'direct': 'Direkt, Ende-zu-Ende-verschlüsselt',
                       'direct_note': 'Der Inhalt bleibt zwischen den beiden Computern',
                       'legend_direct': 'Daten (direkt)',
                       'legend_relay': 'Daten (Relay, Fallback)',
                       'legend_sig': 'Signalisierung'},
           'overview_points': ['<strong>Signalisierung, TCP 8787.</strong> Jeder Computer bleibt mit ihm '
                               'verbunden, um die anderen zu finden, zu koppeln und Verbindungsdetails '
                               'auszutauschen.',
                               '<strong>Direkt.</strong> In einem LAN werden Inhalte fast immer direkt '
                               'zwischen den beiden Computern übertragen, und zwar mit der Geschwindigkeit '
                               'Ihres Netzwerks.',
                               '<strong>Relay, UDP 3478.</strong> Wird nur verwendet, wenn Geräte einander '
                               'nicht erreichen können: Gastnetzwerke, WLAN mit Client-Isolation, separate '
                               'Subnetze.'],
           'prep_h2': 'Bevor Sie beginnen',
           'prep': [('Ein Computer, der eingeschaltet bleibt',
                     'Windows 10 oder 11, macOS 13 oder höher oder ein beliebiger Linux, einschließlich '
                     'eines der beiden Computer, die Sie synchronisieren. Die Synchronisierung pausiert, '
                     'während es ausgeschaltet ist oder schläft, und wird fortgesetzt, wenn es aufwacht. '
                     'Ideal ist ein NAS, Heimrouter oder Mac mini; Der Server benötigt etwa 15 MB RAM.'),
                    ('Eine feste Adresse',
                     'Reservieren Sie eine Adresse dafür in den DHCP-Einstellungen Ihres Routers (häufig als '
                     'DHCP-Reservierung oder statisches Lease bezeichnet). Andernfalls muss jeder Computer '
                     'aktualisiert werden, wenn der Router eine neue Adresse vergibt.'),
                    ('Das gleiche Netzwerk',
                     'Die Geräte müssen sich lediglich im selben WLAN oder kabelgebundenen Netzwerk '
                     'befinden. Gastnetzwerke und WLAN mit Client (AP)-Isolierung verhindern, dass Geräte '
                     'einander erreichen; Verwenden Sie ein anderes Netzwerk oder schalten Sie die Isolation '
                     'aus.'),
                    ('Keine Synchronisierung entfernt',
                     'Der Server ist nur in Ihrem LAN erreichbar, sodass ein woanders mitgenommener Laptop '
                     'aufholen kann, wenn er zurück ist.')],
           'install_h2': 'Installieren Sie den Server',
           'install_intro': 'Wählen Sie das System des Computers aus, auf dem der Server ausgeführt wird. '
                            'Das Skript findet die LAN-Adresse des Computers, stellt den Server so ein, dass '
                            'er automatisch startet, und druckt die Adresse aus, um sie in die Apps '
                            'einzugeben.',
           'os_label': 'System des Servercomputers',
           'manage_caption': 'Für später',
           'win': {'steps': ['Laden Sie <a '
                             'href="https://github.com/baiyuze/pasteferry/releases/latest/download/pasteferry-server-windows-amd64.zip">pasteferry-server-windows-amd64.zip</a> '
                             'herunter und wählen Sie „Alle extrahieren“.',
                             'Öffnen Sie den extrahierten Ordner und doppelklicken Sie auf '
                             '<code>install.cmd</code>.<span class="aside">Wenn die Meldung „Windows hat '
                             'Ihren PC geschützt“ angezeigt wird, klicken Sie auf „Weitere Informationen“ '
                             'und dann auf „Trotzdem ausführen“; Wenn Sie von der Benutzerkontensteuerung '
                             'dazu aufgefordert werden, klicken Sie auf „Ja“. Der Server ist noch nicht '
                             'codesigniert, weshalb Windows einmal nachfragt.</span>',
                             'Die Installation wird in einem neuen Fenster fortgesetzt. Die '
                             '<code>ws://…/signal</code> -Adresse am Ende ist die Adresse, die Sie in den '
                             'Apps eingeben.'],
                   'download': 'Laden Sie den Windows -Server herunter',
                   'notes': ['<strong>Läuft als Windows -Dienst:</strong> startet mit Windows, keine '
                             'Anmeldung erforderlich, kein Fenster. Es erscheint als PasteFerry Server in '
                             'den Diensten.',
                             '<strong>Firewall bereits zugelassen:</strong> Das Skript fügt eine '
                             'Eingangsregel nur für pasteferry-server.exe hinzu, sodass keine Ports geöffnet '
                             'werden müssen.',
                             '<strong>Falsche Adresse ausgewählt</strong> (mehrere Netzwerkadapter, '
                             'beispielsweise von einer VM oder einem VPN): Geben Sie <code>cmd</code> in die '
                             'Adressleiste des extrahierten Ordners ein, drücken Sie die Eingabetaste und '
                             'führen Sie <code>install.cmd 192.168.1.20</code> mit Ihrer Adresse aus.',
                             'Windows 10 und 11, x64.'],
                   'double_click': 'Doppelklicken',
                   'explorer_label': 'Der extrahierte Ordner enthält pasteferry-server.exe, install.cmd, '
                                     'install.ps1, README.md und uninstall.cmd; Doppelklicken Sie auf '
                                     'install.cmd',
                   'term_title': 'Administrator: Windows PowerShell',
                   'term_label': 'Das Fenster nach install.cmd endet: Es stoppt die alte Version, '
                                 'installiert, registriert den Dienst, lässt ihn durch die Firewall zu, '
                                 'startet ihn und gibt dann die Adresse ws://192.168.1.20:8787/signal aus',
                   'manage': [('Status',
                               '<code>Get-Service PasteFerryServer</code> in einer Administrator-PowerShell '
                               'oder suchen Sie den PasteFerry -Server in den Diensten'),
                              ('Protokolle', '<code>C:\\ProgramData\\PasteFerry Server\\server.log</code>'),
                              ('Neu starten',
                               '<code>Restart-Service PasteFerryServer</code> in einer '
                               'Administrator-PowerShell'),
                              ('Upgrade',
                               'Laden Sie die neue Version herunter, extrahieren Sie sie und doppelklicken '
                               'Sie erneut auf <code>install.cmd</code> . Ihre Einstellungen bleiben '
                               'erhalten'),
                              ('Deinstallieren',
                               'Doppelklicken Sie auf <code>uninstall.cmd</code>. Es entfernt den Dienst, '
                               'die Firewall-Regel und die Dateien')]},
           'mac': {'steps': ['Öffnen Sie das Terminal und führen Sie diese Zeilen aus:',
                             'Die <code>ws://…/signal</code> -Adresse am Ende ist die Adresse, die Sie in '
                             'den Apps eingeben.'],
                   'notes': ['<strong>Keine Administratorrechte erforderlich.</strong> Es wird im '
                             'Hintergrund ausgeführt, wenn Sie angemeldet sind, und macOS startet es neu, '
                             'wenn es beendet wird.',
                             '<strong>Halten Sie diesen Mac wach:</strong> aktivieren Sie unter '
                             'Systemeinstellungen → Energie (Akku → Optionen auf einem Laptop) die Option, '
                             'die den automatischen Ruhezustand verhindert.',
                             '<strong>Wenn die Firewall macOS eingeschaltet ist, endet das Skript</strong> '
                             'mit dem Befehl, Pasteferry-Server zuzulassen.',
                             'Intel- und Apple-Silizium, macOS 13 oder höher.'],
                   'term_label': 'Ausgabe von ./install.sh im Terminal: Es wird installiert, schreibt den '
                                 'LaunchAgent und startet den Server, dann gibt es die Adresse '
                                 'ws://192.168.1.20:8787/signal aus',
                   'manage': [('Protokolle', '<code>~/Library/Logs/PasteFerry/server.log</code>'),
                              ('Neu starten',
                               '<code>launchctl kickstart -k gui/$(id -u)/com.pasteferry.server</code>'),
                              ('Upgrade',
                               'Laden Sie die neue Version herunter, extrahieren Sie sie und führen Sie '
                               '<code>./install.sh</code> erneut aus; Ihre Einstellungen bleiben erhalten'),
                              ('Deinstallieren', '<code>./install.sh uninstall</code>')]},
           'linux': {'steps': ['Führen Sie auf der Maschine selbst oder über SSH die folgenden Zeilen '
                               'aus:<span class="aside">Ersetzen Sie auf ARM, beispielsweise einem Raspberry '
                               'Pi mit einem 64-Bit-Betriebssystem, <code>amd64</code> durch '
                               '<code>arm64</code>.</span>',
                               'Die <code>ws://…/signal</code> -Adresse am Ende ist die Adresse, die Sie in '
                               'den Apps eingeben.'],
                     'notes': ['<strong>Registriert einen Systemdienst</strong> , der beim Booten startet. '
                               'Benötigt Root.',
                               '<strong>Wenn ufw oder firewalld aktiv ist, endet das Skript</strong> mit den '
                               'Befehlen zum Öffnen der Ports.',
                               '<strong>Docker funktioniert auch:</strong> kopiert <code>env.example</code> '
                               'nach <code>.env</code>, setzt <code>TURN_IP</code> auf die LAN-Adresse des '
                               'Computers und führt <code>docker compose up -d</code>aus. Es benötigt '
                               'Host-Netzwerk, also nur Linux .'],
                     'term_label': 'Ausgabe von sudo ./install.sh: Es wird installiert, schreibt die '
                                   'systemd-Einheit und -Konfiguration, startet den Server und gibt dann die '
                                   'Adresse ws://192.168.1.20:8787/signal aus',
                     'manage': [('Status', '<code>systemctl status pasteferry-server</code>'),
                                ('Protokolle', '<code>journalctl -u pasteferry-server -f</code>'),
                                ('Neu starten', '<code>sudo systemctl restart pasteferry-server</code>'),
                                ('Konfig',
                                 '<code>/etc/pasteferry/server.env</code>; Starten Sie den Dienst nach der '
                                 'Bearbeitung neu'),
                                ('Upgrade',
                                 'Laden Sie die neue Version herunter, extrahieren Sie sie und führen Sie '
                                 '<code>sudo ./install.sh</code> erneut aus; Ihre Konfiguration bleibt '
                                 'erhalten'),
                                ('Deinstallieren', '<code>sudo ./install.sh uninstall</code>')]},
           'check_h2': 'Überprüfen Sie, ob andere Computer darauf zugreifen können',
           'check_intro': 'Öffnen Sie auf einem anderen Computer '
                          '<code>http://192.168.1.20:8787/healthz</code> in einem Browser (mit Ihrer '
                          'Adresse). Wenn Sie diese Zeile sehen, funktioniert der Netzwerkpfad.',
           'check_label': 'Ein Browser zeigt http://192.168.1.20:8787/healthz, mit dem Serverstatus „OK“ und '
                          'seiner Version an',
           'check_after': 'Wenn es nicht geladen wird, lesen Sie unten die <a href="#faq">-Fragen</a> .',
           'clients_h2': 'Geben Sie die Adresse auf jedem Computer ein',
           'clients_steps': [('Öffnen Sie Einstellungen',
                              'Öffnen Sie PasteFerry auf jedem Computer, einschließlich dem Computer, auf '
                              'dem der Server läuft, und gehen Sie zu Einstellungen → Verbindung.'),
                             ('Geben Sie die Adresse ein',
                              'Geben Sie unter „Benutzerdefinierter Server“ '
                              '<code>ws://192.168.1.20:8787/signal</code> mit Ihrer Adresse ein und drücken '
                              'Sie die Eingabetaste oder die Eingabetaste.'),
                             ('Überprüfen Sie den Status',
                              'Wenn Connection ein grünes Connected (Verbunden) anzeigt, sind Sie bereit. '
                              'Koppeln Sie Ihre Geräte unter Geräte und der Kopiervorgang beginnt mit der '
                              'Synchronisierung.')],
           'clients_alt': 'PasteFerry Einstellungen → Verbindung: Der benutzerdefinierte Server ist '
                          'ws://192.168.1.20:8787/signal und der Verbindungsstatus zeigt Verbunden an',
           'clients_after': 'Sie haben die App noch nicht installiert? Sehen Sie sich die Kurzanleitung <a '
                            'href="{start}"></a>an.',
           'faq_h2': 'Fragen',
           'faq': [('Der Status bleibt bei Nicht verbunden',
                    ['Überprüfen Sie zuerst die Adresse: Sie beginnt mit <code>ws://</code>, verwendet Port '
                     '8787, endet mit <code>/signal</code>und Sie haben nach der Eingabe die Eingabetaste '
                     'gedrückt.',
                     'Öffnen Sie dann <code>http://server-address:8787/healthz</code> in einem Browser auf '
                     'diesem Computer. Wenn es nicht geladen wird, ist der Netzwerkpfad unterbrochen: Der '
                     'Server läuft nicht, sein Computer befindet sich im Ruhezustand, eine Firewall '
                     'blockiert ihn oder seine Adresse hat sich geändert.',
                     'Das Windows -Skript lässt den Server bereits durch die Firewall zu. Führen Sie auf '
                     'einem Mac mit aktivierter Firewall den Befehl aus, den das Skript am Ende ausgegeben '
                     'hat. Das Gleiche gilt für ufw und firewalld auf Linux.']),
                   ('Geräte zeigen Relay statt Direct an',
                    ['In einem LAN sind Verbindungen fast immer direkt. Relay bedeutet, dass UDP nicht '
                     'zwischen den beiden Computern kommunizieren kann, normalerweise aufgrund eines '
                     'Gastnetzwerks, einer Wi-Fi-Client-Isolation oder separater Subnetze mit einer Firewall '
                     'dazwischen. Weitergegebene Inhalte sind weiterhin verschlüsselt; Es ist nur durch das '
                     'Netzwerk des Servercomputers begrenzt.']),
                   ('Die Adresse des Servers hat sich geändert',
                    ['Führen Sie das Skript erneut mit der neuen Adresse aus: <code>install.cmd '
                     'new-address</code> auf Windows, <code>./install.sh new-address</code> auf einem Mac. '
                     'Bearbeiten Sie unter Linux <code>-turn-ip</code> in '
                     '<code>/etc/pasteferry/server.env</code> und starten Sie den Dienst neu. Aktualisieren '
                     'Sie dann die Adresse auf jedem Computer.',
                     'Durch die Reservierung der Adresse in Ihrem Router können Sie dies vermeiden.']),
                   ('Wird es außerhalb des LAN synchronisiert?',
                    ['Nein, der Server ist nur in Ihrem LAN erreichbar. Um netzwerkübergreifend zu '
                     'synchronisieren, aktivieren Sie den <a href="{official}">-Dienst</a>oder verwenden Sie '
                     'einen öffentlichen <a href="{cloud}">-Server</a> oder <a href="{ts}">Tailscale</a>.']),
                   ('Auf dem Servercomputer wird auch PasteFerry ausgeführt. Welche Adresse?',
                    ['Die gleiche LAN-Adresse funktioniert, ebenso wie '
                     '<code>ws://127.0.0.1:8787/signal</code>. Der Server und die App stören nicht.'])],
           'closing': 'Ein Computer, der eingeschaltet bleibt, reicht aus.',
           'source': 'Vollständige Serveranleitung, einschließlich öffentlicher Server und Docker'},
 'cloud': {'title': 'Führen Sie den PasteFerry -Server auf einem öffentlichen Server aus: Cloud-VM-Leitfaden',
           'description': 'Ein Skript installiert den Signalisierungs- und TURN-Server von PasteFerry auf '
                          'einer Linux -VM mit einer öffentlichen IP. Jeder Computer verbindet sich direkt '
                          'damit, sodass die Zwischenablage zu Hause, im Büro und überall synchronisiert '
                          'wird. Deckt die Sicherheitsgruppe, Überprüfung, App-Einrichtung und Domänen auf '
                          'dem chinesischen Festland ab.',
           'h1': 'Führen Sie es auf einem öffentlichen Server aus',
           'lede': 'Eine Linux -VM mit einer öffentlichen IP; das kleinste reicht. Jeder Computer verbindet '
                   'sich direkt damit und synchronisiert sich zu Hause, im Büro oder anderswo, ohne dass '
                   'zusätzliche Installationen erforderlich sind.',
           'toc': [('prepare', 'Bevor Sie beginnen'),
                   ('ports', 'Offene Ports'),
                   ('install', 'Installieren'),
                   ('check', 'Überprüfen'),
                   ('clients', 'Richten Sie die Apps ein'),
                   ('faq', 'Fragen')],
           'step': 'Schritt {n}',
           'overview_h2': 'Jeder Computer verbindet sich damit',
           'overview_intro': 'Der Server befindet sich im öffentlichen Internet, sodass jeder Computer ihn '
                             'von jedem Netzwerk aus erreichen kann. Was Sie kopieren, wird nach Möglichkeit '
                             'direkt zwischen den beiden Computern übertragen. Wenn dies fehlschlägt, wird '
                             'es weiterhin verschlüsselt über den Server weitergeleitet.',
           'diagram': {'title': 'PasteFerry mit einem öffentlichen Server',
                       'desc': 'Der öffentliche Server befindet sich unter 203.0.113.10. Sowohl ein Mac in '
                               'einem Büronetzwerk als auch ein Windows -PC in einem Heimnetzwerk stellen '
                               'zur Signalisierung eine Verbindung her; kopierte Inhalte werden direkt '
                               'zwischen ihnen übertragen und über das Relay des Servers, falls dies '
                               'fehlschlägt.',
                       'server': 'Öffentlicher Server',
                       'server_sub': 'Cloud-VM mit einer öffentlichen IP',
                       'office': 'Büronetzwerk',
                       'home': 'Heimnetzwerk',
                       'client': 'Ausführen von PasteFerry',
                       'sig_note': 'Signalisierung, TCP 8787',
                       'relay_note': 'Weiterleiten über UDP, wenn die Direktübertragung fehlschlägt',
                       'direct': 'Direkt'},
           'overview_points': ['<strong>Signalisierung, TCP 8787.</strong> Jeder Computer bleibt mit ihm '
                               'verbunden, um die anderen zu finden, zu koppeln und Verbindungsdetails '
                               'auszutauschen.',
                               '<strong>Direkt.</strong> Computer in verschiedenen Netzwerken verbinden sich '
                               'direkt über NAT-Hole-Punching, was in den meisten Heim- und Büronetzwerken '
                               'funktioniert.',
                               '<strong>Relay, UDP 3478 und Relay-Ports.</strong> Wenn ein direkter Pfad '
                               'ausfällt, leitet der Server den Datenverkehr weiter, weiterhin verschlüsselt '
                               'und durch seine Bandbreite begrenzt.'],
           'prep': [('Eine Cloud-VM',
                     'Linux auf x86_64 oder ARM64; Die kleinste Größe reicht aus, da der Server etwa 15 MB '
                     'RAM benötigt. Du brauchst root.'),
                    ('Eine öffentliche IP',
                     'Die eigene öffentliche IP der VM funktioniert; Am besten ist eine statische '
                     '(elastische) Variante. Wenn es sich ändert, muss jeder Computer aktualisiert werden.'),
                    ('Ein Weg hinein', 'ssh oder das Webterminal in der Konsole Ihres Anbieters.'),
                    ('VMs auf dem chinesischen Festland',
                     'Ohne eine ICP-Anmeldung für die Domäne geben Sie in den Apps die IP ein, nicht die '
                     'Domäne; siehe die <a href="#faq">-Fragen</a>.')],
           'ports_h2': 'Öffnen Sie die Ports in der Sicherheitsgruppe',
           'ports_intro': 'Fügen Sie in der Konsole Ihres Cloud-Anbieters diese drei eingehenden Regeln zur '
                          'Sicherheitsgruppe der VM hinzu.',
           'rules_url': 'Cloud-Konsole › Sicherheitsgruppe › Eingehende Regeln',
           'rules_cols': ['Protokoll', 'Portbereich', 'Quelle', 'Zweck'],
           'rules': [('TCP', '8787', '0.0.0.0/0', 'Signalisierung'),
                     ('UDP', '3478', '0.0.0.0/0', 'STUN und TURN'),
                     ('UDP', '32768-60999', '0.0.0.0/0', 'Relais-Ports')],
           'rules_label': 'Eingehende Regeln in einer Cloud-Sicherheitsgruppe (Abbildung): TCP 8787 für '
                          'Signalisierung, UDP 3478 für STUN und TURN, UDP 32768-60999 für Relay-Ports, alle '
                          'von 0.0.0.0/0',
           'ports_notes': ['<strong>Verschiedene Namen:</strong> Einige Anbieter nennen es eine Firewall '
                           'oder eine Netzwerk-ACL; es ist die gleiche Einstellung.',
                           '<strong>Relay-Ports</strong> werden vom Betriebssystem zugewiesen; Der Bereich '
                           'hängt vom Server ab. Führen Sie <code>cat '
                           '/proc/sys/net/ipv4/ip_local_port_range</code> aus, um es anzuzeigen. Das '
                           'Installationsskript druckt es auch.',
                           '<strong>System-Firewall:</strong> wenn ufw oder firewalld aktiv ist, öffnen Sie '
                           'dort die gleichen Ports; Das Installationsskript gibt die Befehle aus.'],
           'install_h2': 'Führen Sie das Installationsskript aus',
           'install_intro': 'Geben Sie dem Skript die öffentliche IP. Es installiert den Server, registriert '
                            'einen systemd-Dienst, der beim Booten startet, und gibt die Adresse aus, die in '
                            'die Apps eingegeben werden soll.',
           'install_steps': ['Melden Sie sich mit ssh an, zum Beispiel <code>ssh root@203.0.113.10</code> '
                             'mit Ihrer öffentlichen IP.',
                             'Führen Sie diese Zeilen aus, mit Ihrer öffentlichen IP auf der letzten:<span '
                             'class="aside">Ersetzen Sie auf ARM <code>amd64</code> durch '
                             '<code>arm64</code>.</span>',
                             'Die <code>ws://203.0.113.10:8787/signal</code> -Adresse am Ende ist die '
                             'Adresse, die Sie in den Apps eingeben.'],
           'install_notes': ['<strong>Registriert einen Systemdienst</strong> , der beim Booten startet; Die '
                             'Konfiguration ist <code>/etc/pasteferry/server.env</code>.',
                             '<strong>Upgrade:</strong> Laden Sie die neue Version herunter, extrahieren Sie '
                             'sie und führen Sie <code>sudo ./install.sh</code> erneut aus. Ihre '
                             'Konfiguration bleibt erhalten.',
                             '<strong>Docker funktioniert auch:</strong> siehe <a '
                             'href="{deploy}">Serverbereitstellungshandbuch</a>.'],
           'term_label': 'Ausgabe von sudo ./install.sh 203.0.113.10: Es wird installiert, schreibt die '
                         'Systemd-Einheit und -Konfiguration, startet den Server und gibt dann die Adresse '
                         'ws://203.0.113.10:8787/signal aus',
           'check_h2': 'Überprüfen Sie, ob es erreichbar ist',
           'check_intro': 'Öffnen Sie <code>http://203.0.113.10:8787/healthz</code> (mit Ihrer öffentlichen '
                          'IP) in einem Browser auf einem beliebigen Computer. Wenn Sie diese Zeile sehen, '
                          'funktioniert es.',
           'check_label': 'Ein Browser zeigt http://203.0.113.10:8787/healthz, mit dem Serverstatus „OK“ und '
                          'seiner Version an',
           'clients_steps': [('Öffnen Sie Einstellungen',
                              'Öffnen Sie PasteFerry auf jedem Computer und gehen Sie zu Einstellungen → '
                              'Verbindung.'),
                             ('Geben Sie die öffentliche Adresse ein',
                              'Geben Sie unter „Benutzerdefinierter Server“ '
                              '<code>ws://203.0.113.10:8787/signal</code> mit Ihrer öffentlichen IP ein und '
                              'drücken Sie die Eingabetaste oder die Eingabetaste.'),
                             ('Überprüfen Sie den Status',
                              'Wenn Connection ein grünes Connected (Verbunden) anzeigt, sind Sie bereit. '
                              'Wenn Sie noch keine Kopplung durchgeführt haben, führen Sie die Kopplung '
                              'unter „Geräte“ durch.')],
           'clients_alt': 'PasteFerry Einstellungen → Verbindung: Der benutzerdefinierte Server ist '
                          'ws://203.0.113.10:8787/signal und der Verbindungsstatus zeigt Verbunden an',
           'faq': [('Es funktioniert nach IP, aber nicht nach Domäne',
                    ['Cloud-Anbieter auf dem chinesischen Festland fangen einfache HTTP -Anfragen für '
                     'Domains ohne ICP-Einreichung ab und antworten mit einer Weiterleitung auf eine '
                     'Blockierungsseite; In unseren Tests wurden nicht standardmäßige Ports wie 8787 '
                     'verwendet. Der WebSocket -Handshake ist ebenfalls eine HTTP -Anfrage, daher wird er '
                     'abgefangen und die App zeigt „Nicht verbunden“ an.',
                     'Geben Sie stattdessen die IP des Servers ein, wie in '
                     '<code>ws://server-ip:8787/signal</code>, oder hinterlegen Sie die Domäne.']),
                   ('Wie groß benötige ich einen Server?',
                    ['Der Kleinste. Der Server benötigt etwa 15 MB RAM und leitet normalerweise nur wenige '
                     'Signalisierungsnachrichten weiter. Inhalte werden nach Möglichkeit direkt zwischen '
                     'Computern übertragen; Nur weitergeleitete Übertragungen sind durch die Bandbreite des '
                     'Servers begrenzt.']),
                   ('Geräte zeigen Relay statt Direct an',
                    ['Das Relais direkt nach dem Anschließen und etwas später „Direct“ ist normal: Das Relay '
                     'bringt Sie in Gang und der direkte Pfad übernimmt im Leerlauf. Wenn Sie auf Relay '
                     'bleiben, können die beiden Computer einander nicht direkt erreichen, was normalerweise '
                     'auf ein NAT zurückzuführen ist, das die Ports zufällig verteilt, oder auf eine strenge '
                     'Firewall. Es ist immer noch verschlüsselt, nur durch die Bandbreite des Servers '
                     'begrenzt.']),
                   ('Kann ich HTTPS (wss://) verwenden?',
                    ['Ja, hinter einem HTTPS -Reverse-Proxy, der WebSocket -Upgrades unterstützt; Geben Sie '
                     'eine Adresse ein, die mit <code>wss://</code>beginnt. Für Domains auf dem chinesischen '
                     'Festland ist eine ICP-Einreichung erforderlich. STUN und TURN verwenden UDP und '
                     'umgehen den Proxy. Halten Sie diese Ports also offen.']),
                   ('Mein Heimanschluss hat eine öffentliche IP. Kann ich das verwenden?',
                    ['Ja, aber es ist arbeitsintensiver als eine VM: Leiten Sie TCP 8787, UDP 3478 und eine '
                     'große Auswahl an UDP -Relay-Ports an diesen Computer weiter, und eine Heim-IP kann '
                     'sich ändern. Wenn alle Ihre Computer zu Hause stehen, benötigen sie überhaupt keinen '
                     'Server <a href="{lan}">gleiches Netzwerk</a>; Informationen zur netzwerkübergreifenden '
                     'Synchronisierung ohne Portweiterleitung finden Sie unter <a '
                     'href="{ts}">Tailscale</a>.'])],
           'closing': 'Eine Cloud-VM,<br>-Synchronisierung von überall.',
           'source': 'Vollständige Serveranleitung, einschließlich Docker und allen Optionen'},
 'start': {'title': 'Schnellstart: Richten Sie PasteFerry in drei Schritten ein',
           'description': 'Neu bei PasteFerry? Installieren Sie die App auf jedem Computer. Im selben '
                          'Netzwerk einfach koppeln; Aktivieren Sie in verschiedenen Netzwerken den Dienst. '
                          'Dann auf einen Computer kopieren und auf dem anderen einfügen.',
           'h1': 'Schnellstart',
           'lede': 'Installieren Sie die App, wählen Sie eine Verbindungsmethode und koppeln Sie Ihre '
                   'Computer. Im selben Netzwerk dauert es einige Minuten.',
           'toc': [('app', 'Installieren Sie die App'),
                   ('server', 'Wählen Sie eine Möglichkeit zur Verbindung'),
                   ('pair', 'Paar'),
                   ('phone', 'Mit einem Telefon')],
           'step': 'Schritt {n}',
           'app_h2': 'Installieren Sie die App auf jedem Computer',
           'app_intro': 'Eines auf jedem Computer, den Sie synchronisieren möchten. Mac, Windows und Linux '
                        'können frei gemischt werden.',
           'mac': ['Laden Sie die DMG herunter, öffnen Sie sie und ziehen Sie PasteFerry in '
                   '„Anwendungen“.<span class="aside">Es gibt eines für Apple-Silizium und eines für Intel; '
                   'Die Download-Seite hilft Ihnen bei der Auswahl.</span>',
                   'Öffnen Sie es über Anwendungen.<span class="aside">Beim ersten Mal sagt macOS , dass der '
                   'Entwickler nicht überprüft werden kann: Gehen Sie zu Systemeinstellungen → Datenschutz '
                   'und Sicherheit und klicken Sie unten auf Trotzdem öffnen.</span>',
                   'Klicken Sie auf Hintergrundsynchronisierung aktivieren. Wenn macOS nach dem Zugriff auf '
                   'die Zwischenablage und der Suche nach Geräten in Ihrem lokalen Netzwerk fragt, lassen '
                   'Sie beides zu.'],
           'win': ['Führen Sie PasteFerry-Setup.exe aus; Es sind keine Administratorrechte '
                   'erforderlich.<span class="aside">Wenn die Meldung „Windows hat Ihren PC geschützt“ '
                   'angezeigt wird, klicken Sie auf „Weitere Informationen“ und dann auf „Trotzdem '
                   'ausführen“.</span>',
                   'Öffnen Sie PasteFerry und klicken Sie auf Hintergrundsynchronisierung aktivieren. Lassen '
                   'Sie es zu, wenn die Windows Firewall danach fragt. Nachdem Sie das Fenster geschlossen '
                   'haben, läuft es im Benachrichtigungsbereich weiter.'],
           'linux': ['Installieren Sie auf Ubuntu, Debian und ähnlichem die .deb; Extrahieren Sie bei '
                     'anderen Distributionen die Datei tar.gz und führen Sie darin <code>install.sh</code> '
                     'aus.',
                     'Öffnen Sie PasteFerry im App-Menü und klicken Sie auf Hintergrundsynchronisierung '
                     'aktivieren.'],
           'app_alt': 'PasteFerry beim ersten Öffnen und fordert Sie auf, die Hintergrundsynchronisierung zu '
                      'aktivieren',
           'server_h2': 'Wählen Sie eine Möglichkeit zur Verbindung',
           'server_intro': 'Im selben Netzwerk installieren und koppeln. Aktivieren Sie in verschiedenen '
                           'Netzwerken den Dienst. Wenn Sie die volle Kontrolle wünschen, betreiben Sie '
                           'Ihren eigenen Server oder verwenden Sie Tailscale.',
           'pair_h2': 'Koppeln Sie Ihre Computer',
           'pair_intro': 'Einmal zwei beliebige Computer koppeln, fertig.',
           'pair_steps': ['Öffnen Sie auf einem Computer Geräte und klicken Sie auf Gerät hinzufügen. Es '
                          'zeigt einen 6-stelligen Code, der 5 Minuten gültig ist, und darunter die Adresse '
                          'dieses Computers.',
                          'Wählen Sie auf dem anderen Computer Gerät hinzufügen → Code eingeben. Beim '
                          'Service muss keine IP eingegeben werden; Nur über Subnetze hinweg oder mit '
                          'Tailscale öffnen Sie das Adressfeld und geben die Adresse des anderen Computers '
                          'ein.',
                          'Auf beiden Bildschirmen werden die gleichen zwei Fingerabdrucklinien angezeigt. '
                          'Überprüfen Sie sie Zeichen für Zeichen und bestätigen Sie dann.<span '
                          'class="aside">Dadurch wird verhindert, dass jemand in der Mitte sich als Ihr '
                          'Gerät ausgibt. Überspringen Sie es nicht.</span>'],
           'pair_alt': 'Gerät hinzufügen: den Kopplungscode K7MP2X, mit der Adresse dieses Computers '
                       '192.168.1.20 darunter',
           'done_h2': 'Kopieren Sie jetzt etwas.',
           'done_text': 'Kopieren Sie Text, ein Bild oder eine Datei auf einen Computer und drücken Sie ⌘V '
                        'or Ctrl+V on the other. Alles, was auf beiden Seiten kopiert wurde, steht in der '
                        'Geschichte.',
           'help': 'Brauchen Sie Hilfe? <a href="{lan}#faq">Fragen zum gleichen Netzwerk</a> · <a '
                   'href="{ts}#faq">Tailscale Fragen</a> · <a href="{cloud}#faq">Fragen zum öffentlichen '
                   'Server</a> · <a href="{issues}">Problem melden</a>',
           'phone_h2': 'Mit einem Telefon',
           'phone_intro': 'Sobald die Computer wie oben beschrieben gekoppelt sind, kann ein Telefon '
                          'jederzeit beitreten: Scannen Sie einen Code für die Webseite oder installieren '
                          'Sie die Android -App.',
           'phone_toc': 'Mit einem Telefon',
           'web_h': 'Die Webseite: nichts zu installieren',
           'web_steps': ['Computer: Öffnen Sie Geräte › Telefon-Webübertragung, schalten Sie den Schalter '
                         'ein und ein Code wird angezeigt.',
                         'Telefon: Scannen Sie den Code mit der Kamera oder einem Browser und geben Sie dem '
                         'Telefon einen Namen.',
                         'Der Browser des Telefons zeigt dann die Aufzeichnungen des Computers an: Tippen '
                         'Sie auf „Kopieren“, um eine Textnachricht auf das Telefon zu übertragen, oder '
                         'verwenden Sie „Senden“, um Text, Fotos und Dateien auf den Computer zu '
                         'übertragen.'],
           'apk_h': 'Die Android -App: Pairing wie ein anderer Computer',
           'apk_steps': ['Telefon: <a href="{android}">Laden Sie die APK</a> herunter und installieren Sie '
                         'sie (erlauben Sie die Installation von unbekannten Quellen, wenn Sie dazu '
                         'aufgefordert werden).',
                         'Computer: Geräte → Gerät hinzufügen → Code anzeigen.',
                         'Telefon: Geben Sie den Code ein und bestätigen Sie, wenn die beiden Fingerabdrücke '
                         'übereinstimmen.',
                         'Was Sie auf dem Computer kopieren, erscheint dann in den Aufzeichnungen und in der '
                         'Zwischenablage des Telefons.']},
 'lan': {'title': 'Verwenden Sie PasteFerry in einem Netzwerk: kein Server, nur koppeln',
         'description': 'Wenn Ihre Computer ein Wi-Fi- oder kabelgebundenes Netzwerk teilen, benötigt '
                        'PasteFerry keinen Server: Installieren Sie die App, geben Sie einen 6-stelligen '
                        'Kopplungscode ein und synchronisieren Sie die Zwischenablage und Dateien zwischen '
                        'Mac und Windows. In einem anderen Subnetz geben Sie beim Pairing eine Adresse ein.',
         'h1': 'Im selben Netzwerk',
         'lede': 'Computer hinter demselben Router benötigen keinen Server. Installieren Sie die App, geben '
                 'Sie einen Kopplungscode ein und kopieren Sie die Synchronisierungen von da an.',
         'toc': [('prepare', 'Bevor Sie beginnen'),
                 ('pair', 'Paar'),
                 ('subnet', 'Verschiedene Subnetze'),
                 ('faq', 'Fragen')],
         'step': 'Schritt {n}',
         'overview_h2': 'Kein Server',
         'overview_intro': 'Zwei Computer im selben Netzwerk finden sich über mDNS, tauschen '
                           'Verbindungsdetails direkt aus und öffnen eine verschlüsselte Direktverbindung. '
                           'Kein Server und kein Computer, der eingeschaltet bleiben muss.',
         'diagram': {'title': 'PasteFerry in einem Netzwerk',
                     'desc': 'In einem LAN finden sich ein Mac (192.168.1.20) und ein Windows PC '
                             '(192.168.1.35) über mDNS und tauschen Verbindungsdetails über UDP 8788 aus. '
                             'Kopierte Inhalte werden direkt zwischen ihnen übertragen; Es gibt keinen '
                             'Server.',
                     'lan': 'LAN: dasselbe WLAN oder kabelgebundene Netzwerk',
                     'client': 'Ausführen von PasteFerry',
                     'find_note': 'Gefunden über mDNS, Verbindungsdetails über UDP 8788',
                     'direct': 'Direkt, Ende-zu-Ende-verschlüsselt',
                     'direct_note': 'Der Inhalt bleibt zwischen den beiden Computern'},
         'overview_points': ['<strong>Automatisch gefunden.</strong> Jeder Computer meldet sich im LAN über '
                             'mDNS an, mit nur einem anonymen Token, der sich täglich ändert, sodass niemand '
                             'erkennen kann, um welchen Computer es sich handelt. Sein Name wird nur '
                             'hinzugefügt, während „Suche in der Nähe“ geöffnet ist.',
                             '<strong>Direkt.</strong> Inhalte werden direkt zwischen den beiden Computern '
                             'übertragen, mit der Geschwindigkeit Ihres Netzwerks.',
                             '<strong>Gleiche Sicherheit.</strong> Sie vergleichen beim Koppeln zwei '
                             'Fingerabdruckzeilen und jede Nachricht danach wird signiert, sodass andere im '
                             'Netzwerk sich nicht als Ihr Gerät ausgeben können.'],
         'prep': [('Das gleiche Netzwerk',
                   'Beide Computer hinter demselben Router; WLAN und Kabel können kombiniert werden. '
                   'Gastnetzwerke und WLAN mit Client-Isolierung halten die Geräte voneinander getrennt, und '
                   'in vielen Büros sind kabelgebundene und WLAN separate Subnetze: siehe <a '
                   'href="#subnet">verschiedene Subnetze</a> unten.'),
                  ('Windows-Firewall',
                   'Beim ersten Durchlauf fragt Windows , ob PasteFerry die Firewall passieren darf; erlaube '
                   'es. Wenn Sie auf „Abbrechen“ geklickt haben, klicken Sie unter „Einstellungen“ → '
                   '„Verbindung“ in „ PasteFerry“ auf „Zulassen“, wodurch Sie einmal um die Genehmigung des '
                   'Administrators gebeten werden.'),
                  ('Lokales Netzwerk auf macOS',
                   'Ab macOS 15 fragt der macOS -Daemon beim ersten Erreichen eines Geräts in Ihrem '
                   'Netzwerk, ob der PasteFerry -Daemon Geräte in Ihrem lokalen Netzwerk finden darf. '
                   'erlaube es. Wenn Sie dies abgelehnt haben, aktivieren Sie es unter Systemeinstellungen → '
                   'Datenschutz und Sicherheit → Lokales Netzwerk.'),
                  ('Keine Serveradresse',
                   'Lassen Sie das Serverfeld unter Einstellungen → Verbindung leer. Um später '
                   'netzwerkübergreifend zu synchronisieren, aktivieren Sie den Dienst. Gekoppelte Geräte '
                   'bleiben gekoppelt.')],
         'pair_h2': 'Koppeln Sie Ihre Computer',
         'pair_intro': 'Koppeln Sie zwei beliebige Computer einmal. Wenn die App noch nicht installiert ist, '
                       'lesen Sie die Kurzanleitung <a href="{start}#app"></a>.',
         'pair_steps': ['Öffnen Sie auf einem Computer Geräte und klicken Sie auf Gerät hinzufügen. Es zeigt '
                        'einen 6-stelligen Code, der 5 Minuten lang gültig ist.',
                        'Klicken Sie andererseits auf „Auch Gerät hinzufügen“, wechseln Sie zu „Code '
                        'eingeben“, geben Sie ihn ein und klicken Sie auf „Weiter“.',
                        'Auf beiden Bildschirmen werden die gleichen zwei Fingerabdrucklinien angezeigt. '
                        'Überprüfen Sie sie Zeichen für Zeichen und bestätigen Sie dann. Synchronisierungen '
                        'werden von nun an kopiert.'],
         'pair_alt': 'Gerät hinzufügen: den Kopplungscode K7MP2X, mit der Adresse dieses Computers '
                     '192.168.1.20 darunter',
         'nearby_h3': 'Ohne Code: In der Nähe suchen',
         'nearby_steps': ['Öffnen Sie auf beiden Computern „Geräte“ und klicken Sie auf „In der Nähe '
                          'suchen“. Nur solange dieses Fenster geöffnet ist, können Geräte im Netzwerk den '
                          'Namen dieses Computers sehen.',
                          'Wenn das andere auf dem Radar erscheint, klicken Sie darauf. Beide Bildschirme '
                          'zeigen die gleichen zwei Fingerabdrucklinien; Überprüfen Sie sie und bestätigen '
                          'Sie sie dann jeweils.',
                          'Dies funktioniert nur innerhalb eines Subnetzes. Wenn der andere Computer nicht '
                          'angezeigt wird, verwenden Sie einen Kopplungscode wie oben.'],
         'nearby_alt': 'Geräte in der Nähe: dieser Computer in der Mitte, umgeben von einem Design-PC und '
                       'einem Besprechungsraum-iMac sowie dem bereits gekoppelten MacBook Air',
         'subnet_h2': 'Verschiedene Subnetze',
         'subnet_intro': 'Die lokale Erkennung erreicht nur ein Subnetz. Wenn sich Ihre Computer in '
                         'verschiedenen Subnetzen befinden, die sich weiterhin gegenseitig erreichen können, '
                         'wie es in vielen Büros der Fall ist, geben Sie beim Pairing eine Adresse ein.',
         'subnet_steps': ['Der Computer, der den Code anzeigt, listet seine Adresse darunter auf, z. B. '
                          '<code>192.168.1.20</code>.',
                          'Klicken Sie auf dem Computer, der den Code eingibt, auf „In einem anderen '
                          'Subnetz?“, geben Sie die Adresse ein und klicken Sie auf „Weiter“.',
                          'Nach der Kopplung merkt sich jeder Computer die Adresse des anderen. Ändert der '
                          'eine die Adresse, findet der andere sie selbstständig wieder; Wenn sich beides '
                          'ändert, öffnen Sie das Menü … des Geräts unter Geräte und wählen Sie Adresse '
                          'eingeben.'],
         'subnet_alt': 'Geben Sie einen Code ein: den Code K7MP2X, wobei das darunter geöffnete Adressfeld '
                       '192.168.1.20 enthält',
         'subnet_after': 'Wenn die Subnetze einander überhaupt nicht erreichen können, beispielsweise ein '
                         'vom Büronetzwerk getrenntes Gastnetzwerk, muss der Datenverkehr über einen '
                         'Computer geleitet werden, den beide erreichen können: siehe <a href="{server}">. '
                         'Führen Sie einen Server in Ihrem LAN aus.</a>.',
         'faq': [('Der andere Computer kann nicht gefunden werden',
                  ['Stellen Sie sicher, dass beide mit dem Netzwerk verbunden sind und die '
                   'Hintergrundsynchronisierung aktiviert ist. Versuchen Sie dann, die Adresse des anderen '
                   'Computers auf dem Computer einzugeben, der den Code eingibt: Wenn das funktioniert, '
                   'befinden sie sich in unterschiedlichen Subnetzen oder das Netzwerk blockiert mDNS.',
                   'Immer noch nichts? Überprüfen Sie die Firewall des anderen Computers. Klicken Sie auf '
                   'Windows unter Einstellungen → Verbindung auf Zulassen. Stellen Sie auf einem Mac sicher, '
                   'dass der PasteFerry -Daemon unter Systemeinstellungen → Datenschutz und Sicherheit → '
                   'Lokales Netzwerk aktiviert ist und die macOS -Firewall ihn nicht blockiert.']),
                 ('Wird es außerhalb dieses Netzwerks synchronisiert?',
                  ['Nein, es wird fortgesetzt, wenn Sie zurück sind. Um netzwerkübergreifend zu '
                   'synchronisieren, aktivieren Sie den <a href="{official}">-Dienst</a>oder verwenden Sie '
                   'einen öffentlichen <a href="{cloud}">-Server</a> oder <a href="{ts}">Tailscale</a>. '
                   'Gekoppelte Geräte bleiben gekoppelt.']),
                 ('Was passiert, wenn sich eine Adresse ändert?',
                  ['Normalerweise gibt es nichts zu tun. In einem Subnetz findet mDNS den Computer jederzeit '
                   'wieder; Über Subnetze hinweg stellt es die Verbindung wieder her, solange eines der '
                   'beiden seine Adresse behält. Wenn sich beides ändert, geben Sie unter Geräte die Adresse '
                   'noch einmal ein.',
                   'Für einen Desktop, der sich nie bewegt, können Sie seine Adresse in den '
                   'DHCP-Einstellungen Ihres Routers reservieren.']),
                 ('Können andere im Netzwerk meinen Computer sehen?',
                  ['Sie können sehen, dass ein PasteFerry -Gerät vorhanden ist, aber nicht, wessen: Die '
                   'Übertragung trägt ein anonymes Token, das sich täglich ändert, ohne Gerätenamen oder ID. '
                   'Der Name wird nur hinzugefügt, wenn Sie „In der Nähe suchen“ geöffnet haben, und '
                   'entfernt, wenn Sie die Funktion schließen. Nachrichten von Geräten, mit denen Sie nicht '
                   'gekoppelt sind, werden verworfen und für die Kopplung ist ein Vergleich der '
                   'Fingerabdrücke auf beiden Bildschirmen erforderlich.']),
                 ('Welche Ports werden verwendet?',
                  ['UDP 8788 für Verbindungsdetails (ein zufälliger Port, falls dieser belegt ist), UDP 5353 '
                   'für mDNS und ein weiterer zufälliger UDP -Port für die Daten nach der Verbindung. Auf '
                   'Ihrem Router müssen Sie nichts konfigurieren.'])],
         'closing': 'Ein Netzwerk,<br>, nichts einzurichten.',
         'source': 'Designhinweise zum lokalen Netzwerkmodus (auf Chinesisch)'},
 'ts': {'title': 'Verwenden Sie PasteFerry netzwerkübergreifend mit Tailscale: kein Server, Zuhause und Büro '
                 'synchron',
        'description': 'Installieren Sie Tailscale auf jedem Computer unter einem Konto und geben Sie beim '
                       'Pairing die Tailscale -Adresse des anderen Computers ein: keine öffentliche IP, kein '
                       'Server und kein Computer, der eingeschaltet bleiben muss. Die Zwischenablage wird '
                       'vom Büro oder von einem anderen Ort aus synchronisiert.',
        'h1': 'Netzwerkübergreifend mit Tailscale',
        'lede': 'Keine öffentliche IP und keine Lust, einen Server zu betreiben? Installieren Sie Tailscale '
                'auf jedem Computer und geben Sie beim Pairing die Tailscale -Adresse des anderen Computers '
                'ein. Synchronisiert zu Hause und im Büro.',
        'toc': [('join', 'Installieren Sie Tailscale'),
                ('address', 'Finden Sie die Adresse'),
                ('pair', 'Paar'),
                ('faq', 'Fragen')],
        'step': 'Schritt {n}',
        'overview_h2': 'Wie in einem LAN',
        'overview_intro': 'Tailscale verbindet Ihre Geräte mit einem privaten Netzwerk: Jedes Gerät, das bei '
                          'demselben Konto angemeldet ist, erhält eine feste Adresse, beginnend mit 100, die '
                          'von den anderen Geräten aus erreichbar ist, egal wo sie sich befinden. PasteFerry '
                          'merkt sich beim Koppeln die Adresse des anderen Computers und stellt eine '
                          'Verbindung her, als ob beide in einem Netzwerk wären.',
        'diagram': {'title': 'PasteFerry über Tailscale',
                    'desc': 'Auf einem Mac im Büro und einem Windows -PC zu Hause wird jeweils Tailscale '
                            'ausgeführt und jeder hat eine Adresse, die mit 100 beginnt, im selben privaten '
                            'Netzwerk. Kopierte Inhalte werden direkt zwischen ihnen übertragen; Es gibt '
                            'keinen Server.',
                    'net': 'Tailscale Netzwerk: Jedes Gerät hat eine 100.x-Adresse',
                    'mac_place': 'Im Büro',
                    'win_place': 'Zu Hause',
                    'direct': 'Direkt, doppelt verschlüsselt',
                    'direct_note': 'Der Inhalt bleibt zwischen den beiden Computern'},
        'overview_points': ['<strong>Kein Server,</strong> und kein Computer, der eingeschaltet bleiben '
                            'muss: zwei Computer, die eingeschaltet und mit der Tailscale -Synchronisierung '
                            'verbunden sind.',
                            '<strong>Geben Sie die Adresse einmal ein.</strong> Eine Tailscale -Adresse '
                            'ändert sich nicht; Sie geben es beim Pairing ein und die beiden Computer finden '
                            'sich fortan.',
                            '<strong>Doppelt verschlüsselt.</strong> Im WireGuard-Tunnel von Tailscale läuft '
                            'die eigene Ende-zu-Ende-verschlüsselte Verbindung von PasteFerry. Tailscale '
                            'kann den Inhalt nicht sehen.'],
        'prep': [('Ein Tailscale -Konto',
                  'Kostenlos für den persönlichen Gebrauch; Melden Sie sich mit Google, Microsoft, GitHub '
                  'oder Apple an. Verwenden Sie auf jedem Gerät dasselbe Konto.'),
                 ('Tailscale auf jedem Computer',
                  'Es gibt Clients für Windows, macOS und Linux. Jeder Computer, auf dem PasteFerry '
                  'ausgeführt wird, muss angeschlossen sein.'),
                 ('PasteFerry installiert',
                  'Die App auf jedem Computer mit aktivierter Hintergrundsynchronisierung; Weitere '
                  'Informationen finden Sie in der Kurzanleitung <a href="{start}#app"></a>. Lassen Sie die '
                  'Serveradresse leer.'),
                 ('ZeroTier funktioniert auch',
                  'Dies gilt auch für jedes Tool, das jedem Gerät eine feste virtuelle Adresse zuweist: '
                  'Geben Sie diese Adresse beim Pairing ein. In diesem Handbuch wird Tailscale verwendet.')],
        'join_h2': 'Installieren Sie Tailscale auf jedem Computer',
        'join_intro': 'Installieren Sie es auf jedem Computer, den Sie synchronisieren, und melden Sie sich '
                      'bei demselben Konto an.',
        'join_steps': ['Laden Sie den Client für Ihr System von der Tailscale -Website herunter und '
                       'installieren Sie ihn.<span class="aside">Führen Sie auf Linux <code>curl -fsSL '
                       'https://tailscale.com/install.sh | sh</code>und dann <code>sudo tailscale '
                       'up</code>aus und öffnen Sie den Link, der gedruckt wird, um sich anzumelden.</span>',
                       'Öffnen Sie Tailscale und melden Sie sich mit demselben Konto auf jedem Computer an.',
                       'Die Admin-Konsole Tailscale listet dann alle Ihre Geräte auf, jedes mit einer '
                       'Adresse, die mit 100 beginnt.'],
        'join_download': 'Laden Sie Tailscale herunter',
        'machines_cols': ['Maschine', 'Tailscale -Adresse', 'Betriebssystem'],
        'machines_label': 'Die Maschinenliste der Admin-Konsole Tailscale (Abbildung): MacBook-Pro ist '
                          '100.88.20.5 und Home-PC ist 100.92.41.17',
        'join_notes_h3': 'Halten Sie Tailscale verbunden',
        'join_notes': ['<strong>Windows:</strong> Klicken Sie mit der rechten Maustaste auf das Symbol '
                       'Tailscale im Benachrichtigungsbereich und aktivieren Sie unter „Einstellungen“ die '
                       'Option „Unbeaufsichtigt ausführen“, damit die Verbindung auch nach der Abmeldung '
                       'bestehen bleibt.',
                       '<strong>Mac:</strong> Stellen Sie sicher, dass Tailscale beim Anmelden geöffnet '
                       'wird.',
                       '<strong>Schlüsselablauf deaktivieren:</strong> standardmäßig. Tailscale fordert '
                       'Geräte alle 180 Tage erneut auf, sich anzumelden. Öffnen Sie bei einem Computer, der '
                       'sich selten ändert, das Menü am Ende der Zeile auf der Seite „Maschinen“ und wählen '
                       'Sie „Schlüsselablauf deaktivieren“.'],
        'address_h2': 'Suchen Sie die Tailscale -Adresse des anderen Computers',
        'address_intro': 'Klicken Sie auf dem Computer, mit dem Sie die Verbindung herstellen möchten, auf '
                         'das Symbol Tailscale (in der Menüleiste auf einem Mac, im Benachrichtigungsbereich '
                         'auf Windows), um die Adresse anzuzeigen, oder führen Sie <code>tailscale ip '
                         '-4</code> in einem Terminal aus.',
        'address_label': 'Wenn Sie tailscale ip -4 in PowerShell ausführen, wird die Tailscale -Adresse des '
                         'Computers, 100.92.41.17, gedruckt',
        'address_after': 'Die folgenden Schritte verwenden <code>100.92.41.17</code>, den Windows -PC zu '
                         'Hause. Verwenden Sie Ihre eigene Adresse.',
        'pair_h2': 'Geben Sie beim Pairing die Adresse ein',
        'pair_intro': 'Genau wie das Pairing in einem Netzwerk, mit einer zusätzlichen Adresse.',
        'pair_steps': ['Öffnen Sie auf dem Windows -PC zu Hause „Geräte“, klicken Sie auf „Gerät hinzufügen“ '
                       'und notieren Sie sich den 6-stelligen Code.',
                       'Klicken Sie auf dem Mac im Büro auf Gerät hinzufügen, wechseln Sie zu Code eingeben '
                       'und geben Sie ihn ein; Klicken Sie dann auf „In einem anderen Subnetz?“, geben Sie '
                       '<code>100.92.41.17</code> ein und klicken Sie auf „Weiter“.',
                       'Auf beiden Bildschirmen werden die gleichen zwei Fingerabdrucklinien angezeigt. '
                       'Überprüfen Sie sie und bestätigen Sie sie. Die beiden Computer werden jetzt '
                       'synchronisiert, egal wo sie sich befinden.'],
        'pair_alt': 'Geben Sie einen Code ein: den Code K7MP2X, mit der Tailscale -Adresse 100.92.41.17 im '
                    'Adressfeld',
        'pair_after': 'Wenn beide Computer zu Hause sind, findet PasteFerry auch den anderen direkt im LAN, '
                      'sodass die Daten keinen Umweg nehmen müssen.',
        'faq': [('Auf den Geräten wird Direct angezeigt, aber es ist langsam',
                 ['Direkt in PasteFerry bedeutet, dass die beiden Computer direkt mit dem Tailscale '
                  '-Netzwerk verbunden sind. Wenn Tailscale sie nicht Peer-to-Peer verbinden kann, erfolgt '
                  'die Weiterleitung über seine DERP-Server, die weit entfernt sein können.',
                  'Führen Sie <code>tailscale ping other-address</code> in einem Terminal aus: über DERP '
                  'bedeutet, dass Tailscale weiterleitet; Über eine IP und einen Port bedeutet es '
                  'Peer-to-Peer. Büro- und Campusnetzwerke werden häufiger weitergeleitet; Sie können Ihren '
                  'eigenen DERP-Server betreiben oder ein anderes Mesh-VPN ausprobieren.']),
                ('Beim Pairing kann der andere Computer nicht gefunden werden',
                 ['Stellen Sie zunächst sicher, dass Tailscale mit beiden verbunden ist: Führen Sie '
                  '<code>tailscale ping other-address</code> aus und versuchen Sie es erneut, sobald es '
                  'antwortet.',
                  'Wenn der Ping-Vorgang funktioniert, das Pairing jedoch nicht, wird er wahrscheinlich von '
                  'der Firewall des anderen Computers blockiert. Klicken Sie auf Windows unter Einstellungen '
                  '→ Verbindung in PasteFerry auf Zulassen. Aktivieren Sie auf einem Mac den PasteFerry '
                  '-Daemon unter Systemeinstellungen → Datenschutz und Sicherheit → Lokales Netzwerk.']),
                ('Benötigt jeder Computer Tailscale?',
                 ['Ja, ein Computer ohne sie kann die 100.x-Adressen nicht erreichen. Computer im selben '
                  'Netzwerk benötigen es nicht; Weitere Informationen finden Sie im <a '
                  'href="{lan}">-Netzwerkhandbuch</a>.']),
                ('Ich habe zu Hause einen Server mit der alten Anleitung eingerichtet. Brauche ich es noch?',
                 ['Nein. Löschen Sie die Serveradresse unter Einstellungen → Verbindung auf jedem Computer '
                  'und deinstallieren Sie den Server zu Hause. Gekoppelte Geräte bleiben gekoppelt. Auch das '
                  'Behalten kann nicht schaden: Ein Server und Tailscale arbeiten zusammen.']),
                ('Kann Tailscale sehen, was ich kopiere?',
                 ['Nein. Tailscale -Verbindungen sind Ende-zu-Ende-verschlüsselt mit WireGuard und im '
                  'Inneren läuft PasteFerry s eigene DTLS-verschlüsselte Verbindung; Nur Ihre beiden '
                  'Computer können jede Ebene öffnen.  Die Server von Tailscale tauschen nur Geräteschlüssel '
                  'und -adressen aus und ihre Relays leiten verschlüsselte Pakete weiter.']),
                ('Wird sich eine Tailscale -Adresse ändern?',
                 ['Normalerweise nicht. Die Adresse gehört zum Gerät und übersteht Neustarts und '
                  'Netzwerkänderungen; es ändert sich nur, wenn Sie das Gerät aus Tailscale entfernen und '
                  'erneut hinzufügen. Wenn dies der Fall ist, geben Sie es unter Geräte noch einmal ein.']),
                ('Ich habe einen öffentlichen Server. Benötige ich Tailscale?',
                 ['Nein. Führen Sie den Server auf dem Computer mit der öffentlichen IP aus und geben Sie '
                  'diese Adresse auf jedem Computer ein. Weitere Informationen finden Sie im Leitfaden für '
                  'öffentliche Server <a href="{cloud}"></a>.'])],
        'closing': 'Kein Server.<br>Ihre Zwischenablage ist im Lieferumfang enthalten.',
        'source': 'Zurück zum gleichen Netzwerkführer'},
 'download': {'phone': {'title': 'Telefon (Android -App oder die Webseite)',
                        'apk': 'Herunterladen für Android (APK)',
                        'apk_note': 'Android 9 oder höher, arm64 Telefone. Android fragt vor der '
                                    'Installation einmal nach.',
                        'web_h': 'Die Webseite (nichts zu installieren)',
                        'web_note': 'Aktivieren Sie „Geräte › Telefon-Webübertragung“ auf dem Computer und '
                                    'scannen Sie den Code mit Ihrem Telefon.',
                        'steps': ['Koppeln Sie das Telefon nach der Installation der App über Geräte auf dem '
                                  'Computer, genauso wie Sie einen anderen Computer koppeln.',
                                  'Oder nutzen Sie die Webseite: Aktivieren Sie Geräte › '
                                  'Telefon-Webübertragung auf dem Computer und scannen Sie den Code.',
                                  'Fügen Sie auf dem Telefon ein, was Sie kopiert haben, und senden Sie es. '
                                  'Was Sie auf dem Computer kopieren, erscheint in den '
                                  'Telefonaufzeichnungen.'],
                        'notes': ['Text, Screenshots und Dateien gehen in beide Richtungen.',
                                  'Es gibt keine iPhone- oder iPad-App: iOS lässt nicht zu, dass Apps die '
                                  'Zwischenablage im Hintergrund lesen, und für die Verteilung ist ein '
                                  'Zertifikat erforderlich. Verwenden Sie stattdessen die Webseite.',
                                  'Inhalte werden zwischen dem Telefon und dem Computer verschlüsselt; '
                                  'Verwenden Sie es zu Hause oder in einem Netzwerk, dem Sie vertrauen.'],
                        'tab': 'Smartphone / Web'},
              'title': 'Laden Sie PasteFerry herunter: Mac (Apple Silicon, Intel), Windows und Linux',
              'description': 'PasteFerry für jedes System: Apple-Silicon- und Intel-Versionen für macOS 13 '
                             'oder höher, ein Installationsprogramm und eine tragbare Zip-Datei für Windows '
                             '10 und 11 sowie .deb- und tar.gz-Pakete für Linux auf x64 und ARM64. Kostenlos '
                             'und Open Source.',
              'h1': 'Laden Sie PasteFerry herunter',
              'lede': 'Kostenlos und Open Source, Version {version}. Installieren Sie es auf jedem Computer, '
                      'den Sie synchronisieren möchten. Mac, Windows und Linux können frei gemischt werden.',
              'os_label': 'Wählen Sie Ihr System',
              'win': {'setup': 'Laden Sie das Installationsprogramm herunter',
                      'portable': 'Möchten Sie lieber kein Installationsprogramm ausführen? Holen Sie sich '
                                  'die tragbare Zip-Datei <a href="{portable}"></a>, extrahieren Sie sie und '
                                  'führen Sie von dort aus PasteFerry aus.',
                      'steps': ['Führen Sie PasteFerry-Setup.exe aus. Die Installation erfolgt für den '
                                'aktuellen Benutzer, es sind keine Administratorrechte erforderlich.<span '
                                'class="aside">Wenn die Meldung „Windows hat Ihren PC geschützt“ angezeigt '
                                'wird, klicken Sie auf „Weitere Informationen“ und dann auf „Trotzdem '
                                'ausführen“.</span>',
                                'Öffnen Sie PasteFerry und klicken Sie auf Hintergrundsynchronisierung '
                                'aktivieren. Lassen Sie es zu, wenn die Windows Firewall danach fragt.'],
                      'notes': ['Windows 10 und Windows 11, x64.',
                                'Das Installationsprogramm ist ca. 23 MB groß, die portable Zip-Datei ca. 29 '
                                'MB.',
                                'Nachdem Sie das Fenster geschlossen haben, wird PasteFerry weiterhin im '
                                'Benachrichtigungsbereich ausgeführt.']},
              'mac': {'apple': 'Apple-Chip (M1+)',
                      'intel': 'Intel',
                      'universal': 'Eine universelle Version <a href="{universal}"></a> , die auf beiden '
                                   'läuft, ist ebenfalls in doppelter Größe erhältlich.',
                      'homebrew': 'Sie können auch die Desktop-App und die gebündelte CLI mit <code>brew '
                                  'install --cask baiyuze/tap/pasteferry</code>installieren. Wenn die App '
                                  'bereits manuell installiert wurde, beenden und verschieben Sie zunächst '
                                  'die vorhandene App. Bewahren Sie Ihre Bewerbungsdaten auf. Weitere '
                                  'Informationen finden Sie im Installations- und Upgrade-Handbuch <a '
                                  'href="{homebrew}"></a>.',
                      'steps': ['Öffnen Sie die heruntergeladene DMG und ziehen Sie PasteFerry in '
                                '„Anwendungen“.',
                                'Öffnen Sie es über Anwendungen.<span class="aside">Beim ersten Mal sagt '
                                'macOS , dass der Entwickler nicht überprüft werden kann: Gehen Sie zu '
                                'Systemeinstellungen → Datenschutz und Sicherheit und klicken Sie unten auf '
                                'Trotzdem öffnen.</span>',
                                'Klicken Sie auf Hintergrundsynchronisierung aktivieren. Wenn macOS nach dem '
                                'Zugriff auf die Zwischenablage und der Suche nach Geräten in Ihrem lokalen '
                                'Netzwerk fragt, lassen Sie beides zu.'],
                      'chip_h': 'Nicht sicher, welcher Chip?',
                      'chip': ['Klicken Sie auf das Apple-Menü in der oberen linken Ecke des Bildschirms und '
                               'wählen Sie „Über diesen Mac“.',
                               '„Chip: Apple M1“ (oder M2, M3, M4…) bedeutet Apple-Silizium; „Prozessor: … '
                               'Intel Core …“ bedeutet Intel.',
                               'Fast jeder Mac, der seit Ende 2020 gekauft wurde, verfügt über '
                               'Apple-Silizium. Wenn Sie sich für die falsche Version entscheiden, laden Sie '
                               'einfach die andere herunter: Auf einem Apple-Silicon-Mac muss zuerst Rosetta '
                               'für die Intel-Version installiert werden, und die Apple-Silicon-Version '
                               'lässt sich auf einem Intel-Mac nicht öffnen.',
                               'Erfordert macOS 13 Ventura oder höher.']},
              'linux': {'deb_h': 'Ubuntu, Debian und Derivate',
                        'tar_h': 'Andere Distributionen',
                        'x64': 'x64',
                        'arm64': 'ARM64',
                        'notes': ['Benötigt einen grafischen Desktop: X11 oder Wayland mit XWayland, das '
                                  'GNOME, KDE und andere wichtige Desktops standardmäßig enthalten.',
                                  'Sie sind sich nicht sicher, ob Sie x64 oder ARM64haben? Führen Sie '
                                  '<code>uname -m</code> in einem Terminal aus: <code>x86_64</code> bedeutet '
                                  'x64, <code>aarch64</code> bedeutet ARM64.',
                                  'Die .deb-Datei wird unter /opt/PasteFerry installiert und fügt PasteFerry '
                                  'zum App-Menü hinzu. Das tar.gz wird überall dort ausgeführt, wo Sie es '
                                  'extrahieren, und <code>install.sh</code> fügt es dem App-Menü hinzu.',
                                  'Sobald es geöffnet ist, klicken Sie auf Hintergrundsynchronisierung '
                                  'aktivieren. Von da an startet es, wenn Sie sich anmelden. GNOME zeigt '
                                  'standardmäßig kein Taskleistensymbol an, öffnen Sie das Fenster also über '
                                  'das App-Menü.',
                                  'Benötigt GTK 3. Getestet auf Ubuntu 24.04 mit GNOME (Wayland).']},
              'more_h2': 'Mehr',
              'more': [('Server',
                        'Zwei Computer im selben Netzwerk benötigen keinen Server. Die Möglichkeiten zum '
                        'Herstellen einer netzwerkübergreifenden Verbindung finden Sie in der Kurzanleitung '
                        '<a href="{server}"></a>; Jeder Leitfaden verfügt über einen eigenen '
                        'Server-Download.'),
                       ('Prüfsummen',
                        'SHA-256-Prüfsummen jeder Datei befinden sich in <a href="{sums}">SHA256SUMS</a>.'),
                       ('Was gibt es Neues und ältere Versionen?',
                        'Informationen zu den Änderungen in dieser Version finden Sie in den '
                        'Versionshinweisen <a href="{notes}"></a> . Ältere Versionen sind auf <a '
                        'href="{releases}">GitHub Releases</a>.')]},
 'ld_description': 'Kopieren und Einfügen zwischen Computern, Durchsuchen des Verlaufs Ihrer Zwischenablage '
                   'und Senden von Fotos und Dateien zwischen Computern und Android. Mac, Windows, Linux, '
                   'Android und eine Telefon-Webseite. Android und Web funktionieren im selben Netzwerk. '
                   'Kostenlos und Open Source.',
 'ld_os': 'macOS 13 oder höher (Intel- und Apple-Silizium); Windows 10, Windows 11 (x64); Linux (x64, ARM64)',
 'ld_currency': 'USD',
 'ld_features': ['Synchronisiert einfachen Text, Rich Text, Bilder, Dateien und Ordner',
                 'Funktioniert zwischen Mac, Windows und Linux, ohne gemeinsames Konto, über Netzwerke '
                 'hinweg',
                 'Kein Server im selben Netzwerk erforderlich, mit automatischer mDNS-Erkennung',
                 'Direkte WebRTC -Verbindung mit automatischem TURN-Relais-Fallback',
                 'End-to-End- DTLS -Verschlüsselung mit vom Menschen verifizierten Fingerabdrücken beim '
                 'Pairing',
                 'Elemente unter 50 MB werden beim Kopieren übertragen, größere Dateien werden bei Bedarf '
                 'abgerufen',
                 'Verlauf der letzten 3 Tage, mit Bildvorschauen',
                 'Schnittstelle in 18 Sprachen, einschließlich Arabisch (von rechts nach links)']}

FEATURES = {'nav_features': 'Funktionen',
 'nav_more': 'Mehr',
 'nav_security': 'Sicherheit',
 'nav_changelog': 'Änderungsprotokoll',
 'nav_more_label': 'Weitere Seiten',
 'gh_aria': 'Stern PasteFerry auf GitHub',
 'star_ask': 'Gefällt es Ihnen? Markieren Sie es auf GitHub.',
 'star_button': 'Stern auf GitHub geben',
 'demo_where': 'Wo sind die beiden Computer?',
 'demo_wan': 'Zuhause ↔ Büro',
 'demo_lan': 'Gleiches WLAN',
 'net_home': 'Zuhause',
 'net_office': 'Büro',
 'net_wifi': 'Heim-WLAN',
 'demo_server': 'Der Server stellt sie nur vor',
 'demo_no_server': 'Im lokalen Netzwerk gefunden, kein Server',
 'demo_hint': 'Klicken Sie auf eine beliebige Stelle auf dem Mac, um sie zu kopieren',
 'demo_image': 'Screenshot.png',
 'demo_text': 'Die Sitzung wurde auf 15:30 Uhr in Raum 4B verschoben',
 'demo_folder': 'Markenwerte',
 'demo_copy': '{item} kopieren',
 'demo_pasted': '{item} wurde auf {device} eingefügt',
 'theme_menu': 'Erscheinungsbild',
 'theme_system': 'Systemeinstellung folgen',
 'theme_light': 'Hell',
 'theme_dark': 'Dunkel',
 'badge': '{version}: Oberflächengröße für größere Texte und Symbole →',
 'home_phone_h2': 'Ihr Telefon schaltet sich ein.',
 'home_phone_intro': 'Verwenden Sie die Android -App, um Stapel von Fotos und Dateien mit einem Computer zu '
                     'senden und zu empfangen und diese anschließend zu speichern oder zu teilen. Bevorzugen '
                     'Sie keine Installation? Scannen Sie einen Code für den Verlauf der Zwischenablage, das '
                     'Senden von Inhalten und separate Dateiübertragungen im Browser.',
 'home_phone_points': ['<b>Verwenden Sie den Browser</b> für Verlauf und separate Dateiübertragungen.',
                       '<b>Android sendet und empfängt</b> -Batches mit Speichern und Teilen.',
                       '<b>Gleiches Netzwerk</b>; Lassen Sie die Webseite geöffnet.'],
 'home_phone_link': 'So nutzen Sie das Telefon →',
 'home_send_h2': 'Ziehen Sie es rüber.<br>Es ist da.',
 'home_send_intro': 'Legen Sie Dateien auf einem Computer ab oder wählen Sie einen Stapel auf Android aus. '
                    'Fotos und Dateien werden direkt auf ein anderes Gerät übertragen; App-Übertragungen '
                    'werden nach einer Unterbrechung wieder aufgenommen.',
 'home_send_link': 'Weitere Informationen zum Senden von Dateien →',
 'home_qp_h2': 'Drücken Sie {key}.<br>Alles, was Sie kopiert haben, genau dort.',
 'home_qp_intro': 'Drücken Sie in einer beliebigen App darauf, wählen Sie ein Element aus und es wird '
                  'eingefügt.',
 'home_qp_link': 'Mehr zum Thema Quick Paste →',
 'home_qp_alt': 'Das Fenster zum schnellen Einfügen: ein Suchfeld und sechs Registerkarten (Alle, Text, '
                'Links, Bilder, Dateien, Favoriten), nummerierte Verlaufselemente und wichtige Hinweise '
                'unten',
 'grid_h2': 'Mehr als eine gemeinsame Zwischenablage.',
 'grid_more': 'Alle Funktionen anzeigen →',
 'grid': [('send',
           'Dateien senden',
           'Legen Sie Dateien oder Ordner auf einem anderen Computer oder einem Kontakt ab. Jede Größe.',
           True),
          ('keys',
           'Schnelleinfügen',
           'Drücken Sie {key} für Ihren Verlauf. Wählen Sie ein Element aus und es wird eingefügt.',
           False),
          ('folder',
           'Dateien und Ordner',
           'Kleine Dateien werden beim Kopieren synchronisiert, große bei Bedarf.',
           False),
          ('clock', 'Geschichte und Favoriten', 'Alles auf jedes Gerät kopiert, durchsuchbar.', False),
          ('globe',
           'Über Netzwerke hinweg',
           'Aktivieren Sie den Dienst, um zwischen Zuhause und der Arbeit zu synchronisieren.',
           False),
          ('lock',
           'Ende-zu-Ende verschlüsselt',
           'Zuerst direkt. Der Server kann nicht sehen, was Sie kopieren.',
           False)],
 'new_tag': 'Neu',
 'kicker_new': 'Neu in 2.6',
 'title': 'Funktionen: Dateien senden, schnelles Einfügen, Favoriten, geräteübergreifender Verlauf – '
          'PasteFerry',
 'description': 'PasteFerry synchronisiert die Zwischenablage zwischen Mac, Windows und Linux: Kopieren Sie '
                'Text, Bilder, Dateien oder Ordner und fügen Sie sie auf dem anderen Computer ein. Drücken '
                'Sie ⌥V or Alt+V for quick paste, behalten Sie Ihre Favoriten, durchsuchen oder filtern Sie '
                'Ihren Verlauf und senden Sie Dateien beliebiger Größe direkt an einen anderen Computer.',
 'eyebrow': 'PasteFerry -Funktionen',
 'h1': 'Kopieren Sie<br>und fügen Sie es so ein, wie es sein sollte.',
 'lede': 'Eine Zwischenablage für Ihren Mac, Windows - und Linux -Computer.',
 'hero_alt': 'Der Verlauf von PasteFerry: eine Seitenleiste mit Verlauf, Favoriten, Sendedateien, Geräten '
             'und Einstellungen sowie eine Liste mit Texten, Bildern, Dateien und Links von verschiedenen '
             'Computern',
 'sync_h2': 'Hier kopieren.<br>Dort einfügen.',
 'sync_intro': '{copy} hier, {paste} dort. Kein gemeinsames Konto erforderlich.',
 'sync_facts': [('Texte, Bilder, Dateien, Ordner', 'Lässt sich sauber in Nur-Text-Felder einfügen.'),
                ('Beim Kopieren werden bis zu 50 MB gesendet',
                 'Größere Artikel auf Anfrage. Der Grenzwert ist einstellbar.'),
                ('Jederzeit pausieren', 'Pausieren Sie alles oder nur einen Computer.')],
 'send_h2': 'Jede Größe.<br>Ziehen Sie es einfach rüber.',
 'send_intro': 'Computer in der Nähe und in der Ferne sind auf dem Radar. Ziehen Sie Dateien auf eine, um '
               'sie zu senden. Kein Cloud-Laufwerk und Ihr Verlauf bleibt sauber.',
 'send_points': [('Jede Größe', 'Multi-GB-Videos oder Ordner mit Tausenden von Dateien.'),
                 ('Macht dort weiter, wo es aufgehört hat',
                  'Wird nach einer unterbrochenen Verbindung oder einem Ruhezustand fortgesetzt. Jede Datei '
                  'wird überprüft.'),
                 ('Erhalten Sie Dateien an einem Ort',
                  'Standardmäßig unter „Downloads“ gespeichert, nur ein Klick zum Anzeigen.')],
 'send_note': 'Funktioniert netzwerkübergreifend; Die Weiterleitung über den Dienst ist auf 100 MB pro Tag '
              'begrenzt. Beide Computer benötigen 2.5 oder höher.',
 'send_alt': 'Die Seite „Dateien senden“: ein Radar mit diesem Mac in der Mitte und Geräten im selben '
             'Netzwerk und anderswo in der Nähe; auf der rechten Seite empfangene Dateien mit einem '
             'ankommenden Ordner sowie dessen Fortschritt und Geschwindigkeit',
 'theme_kicker': 'Neu in 2.10',
 'theme_h2': 'Machen Sie es zu Ihrem.<br>Auch in Pixel.',
 'theme_intro': 'Wählen Sie unter „Einstellungen“ > „Erscheinungsbild“ ein Thema aus: „Standard“ und „Pixel“ '
                'sind integriert. Duplizieren Sie eines und machen Sie es zu Ihrem eigenen oder bitten Sie '
                'eine KI, eines zu entwerfen. Hell, dunkel oder passend zum System.',
 'theme_points': [('Pixel-Thema',
                   'Bitmap-Typ, gekerbte Blöcke und abgeschrägte Schaltflächen. Eine Nacht- oder Tagesszene '
                   'oben, ein Papierflieger beim Versenden und eine Explosion von Sternen, wenn es fertig '
                   'ist.'),
                  ('Benutzerdefinierte Themen',
                   'Duplizieren Sie ein integriertes Theme, importieren oder exportieren Sie Theme-Dateien. '
                   'Sie werden gewarnt, wenn der Text schwer lesbar ist.'),
                  ('Fragen Sie eine KI',
                   'Fügen Sie <code>pasteferry-cli mcp</code> zu Claude, Cursor und anderen hinzu und sagen '
                   'Sie dann „Mach mir ein Cyberpunk-Thema“. Es wird erstellt und angewendet.')],
 'theme_note': 'Designs gelten nur für das Gerät, auf dem Sie sie festlegen (auf einem Computer, im '
               'Hauptfenster und beim schnellen Einfügen). Sie sind nicht synchronisiert. Die Android -App '
               'verfügt über eigene Einstellungen › Erscheinungsbild. Pixelthemen können CRT-Scanlines '
               'hinzufügen. Die KI kann nur Themen lesen und schreiben, niemals Ihren Verlauf oder Ihre '
               'Geräte.',
 'theme_alt': 'Die Seite „Darstellung“ in den Einstellungen (Pixel-Design, dunkel): Miniaturansichten der '
              'integrierten Standard- und Pixel-Designs sowie zweier benutzerdefinierter Designs, dann Thema '
              'importieren, AI bitten, ein Design zu erstellen, hell und dunkel und Scanlines',
 'theme_alt_light': 'Geschichte im Pixel-Thema (hell): Wolken und Hügel in der Kopfzeile und ein kleines '
                    'Haus am unteren Rand der Seitenleiste',
 'theme_alt_send': 'Senden Sie Dateien im Pixel-Design (dunkel): Nachtberge und ein Mond im Header, ein '
                   'gepunktetes Radar und Pixelblock-Geräte',
 'home_theme_h2': 'Machen Sie es zu Ihrem.<br>Auch in Pixel.',
 'home_theme_intro': 'Es gibt Themen: einen integrierten Pixel-Look, Ihre eigenen Themen oder eines, das '
                     'eine KI für Sie entwirft.',
 'home_theme_alt': 'Geschichte im Pixel-Design (dunkel): Nachtberge, Kiefern und ein Mond in der Kopfzeile, '
                   'ein Zelt und Lagerfeuer am unteren Rand der Seitenleiste und Bitmap-Typ',
 'home_theme_link': 'Mehr zu Themen →',
 'friends_h2': 'Der Computer eines Freundes,<br>, ist genauso einfach.',
 'friends_intro': 'Fügen Sie sie als Kontakt hinzu, keine Kopplung erforderlich. Die Dateien kommen an, '
                  'sobald sie angenommen wurden, mit einer optionalen Notiz.',
 'friends_points': [('Sie entscheiden, was reinkommt',
                     'Sehen Sie, wer was gesendet hat, bevor Sie es annehmen, oder akzeptieren Sie Personen, '
                     'denen Sie vertrauen, automatisch.'),
                    ('Sie entscheiden, wer senden darf',
                     'Niemand, nur Kontakte oder alle in Ihrem Netzwerk für 10 Minuten.'),
                    ('Dateien, kein Chat',
                     'Kontakte sehen niemals Ihre Zwischenablage, Ihren Verlauf oder Ihre Geräte.')],
 'friends_note': 'In verschiedenen Netzwerken aktivieren beide den Dienst. Beide benötigen 2.6 oder höher.',
 'friends_alt': 'Die Seite „Dateien senden“: Avatare der Kontakte unter dem Radar und eine Anfrage in der '
                'Mitte – ein Kontakt auf einem MacBook Air möchte Ihnen Dateien senden, mit einer Notiz – '
                'die Sie ablehnen oder annehmen können',
 'home_friends_link': 'Mehr zum Senden an Kontakte →',
 'phone_kicker': 'Neu in 2.8',
 'phone_alt': 'Die Geräteseite Telefon-Webübertragung: der Code und die registrierten Telefone',
 'phone_h2': 'Ihr Telefon schaltet sich ein.',
 'phone_intro': 'Verwenden Sie die Android -App, um Stapel von Fotos und Dateien mit einem Computer zu '
                'senden und zu empfangen und diese anschließend zu speichern oder zu teilen. Bevorzugen Sie '
                'keine Installation? Scannen Sie einen Code für den Verlauf der Zwischenablage, das Senden '
                'von Inhalten und separate Dateiübertragungen im Browser.',
 'phone_points': [('Benutzen Sie den Browser', 'für Verlauf und separate Dateiübertragungen.'),
                  ('Android sendet und empfängt', 'Stapel, mit Speichern und Teilen.'),
                  ('Gleiches Netzwerk', '; Lassen Sie die Webseite geöffnet.')],
 'phone_note': 'Es gibt keine iPhone- oder iPad-App: iOS lässt nicht zu, dass Apps die Zwischenablage im '
               'Hintergrund lesen, und für die Verteilung ist ein Zertifikat erforderlich. Diese Geräte '
               'nutzen die Webseite.',
 'qp_h2': 'Drücken Sie {key}.<br>Ihr Verlauf, genau dort, wo Sie tippen.',
 'qp_intro': 'Drücken Sie in einer beliebigen App die Tastenkombination, wählen Sie ein Element aus und es '
             'wird am Cursor eingefügt.',
 'qp_steps': [('Drücken Sie {key}', 'Funktioniert in jeder App.'),
              ('Geben Sie ein paar Buchstaben ein',
               'Suchen Sie nach Text und Dateinamen oder drücken Sie {index}.'),
              ('Drücken Sie {enter}. Erledigt.', '{plain} für Klartext, {copyonly} nur zum Kopieren.')],
 'qp_note': 'Sie können die Verknüpfung ändern oder deaktivieren. Das Einfügen für Sie auf einem Mac '
            'erfordert die Berechtigung zur Barrierefreiheit.',
 'qp_label': 'Demo: Drücken Sie beim Schreiben einer E-Mail ⌥V; Das Fenster zum schnellen Einfügen wird '
             'geöffnet. Wenn Sie „Besprechung“ eingeben, wird der Besprechungslink gefunden und mit der '
             'Eingabetaste in die E-Mail eingefügt',
 'mail_window': 'Neue Nachricht',
 'mail_to_label': 'An:',
 'mail_to': 'Team',
 'mail_subject_label': 'Betreff:',
 'mail_subject': 'Wöchentliche Synchronisierung verschoben',
 'mail_body': ['Hallo zusammen,',
               'Die wöchentliche Synchronisierung wird auf Donnerstag 15:00 Uhr verschoben. Link:'],
 'qp_typing': [('m', False), ('ich', False), ('mee', False), ('treffen', False), ('Treffen', False)],
 'qp_rows': [('text', 'Schicken Sie mir das Deck bis 19 Uhr', 'Gerade eben', False, False),
             ('link', 'https://github.com/baiyuze/pasteferry', 'Vor 2 Minuten', False, False),
             ('image', 'Bild', 'Windows PC · Vor 5 Minuten', True, False),
             ('files', 'unterschriebener-vertrag.pdf und 2 weitere', 'Vor 52 Minuten', False, False),
             ('text', 'Besprechungslink: https://meeting.example.com/j/8823', 'Vor 1 Stunde', True, True),
             ('text', 'docker compose up -d --build', 'Vor 1 Stunde', False, False),
             ('text', 'Besprechungsnotizen befinden sich im freigegebenen Ordner', 'Gestern', False, True),
             ('text', 'pnpm install', 'Gestern', False, False)],
 'fav_h2': 'Behalten Sie, was Sie wiederverwenden.',
 'fav_intro': 'Markieren Sie die Dinge, die Sie wiederverwenden. Sie werden als separate Kopie aufbewahrt '
              'und laufen nie ab.',
 'fav_points': [('Nie aufgeräumt', 'Der Verlauf läuft ab; Favoriten bleiben.'),
                ('Eine eigene Kopie', 'Das Ändern oder Löschen des Originals hat keine Auswirkungen darauf.'),
                ('Auch im Schnellklebeverfahren',
                 'Auch in Schnellpaste; Drücken Sie zum Hinzufügen {fav} .')],
 'fav_alt': 'Die Favoritenseite: fünf gespeicherte Elemente, darunter eine Berichtsvorlage, eine '
            'Aktienantwort, ein Download-Link und ein PDF, jeweils mit einem blauen Stern',
 'details_h2': 'Für die Details hat sich<br>gekümmert.',
 'filter_title': 'Links erhalten einen eigenen Tab',
 'filter_text': 'Text, Links, Bilder, Dateien: Ein Klick zum Filtern.',
 'filter_rows': [('text', 'Die Sitzung wurde auf Donnerstag, 15 Uhr, verschoben', False),
                 ('link', 'https://github.com/baiyuze/pasteferry', False),
                 ('image', 'Bild · 2,4 MB', False),
                 ('file', 'Q3-Überprüfung – final.key', False),
                 ('link', 'https://pasteferry.cc/download/', True),
                 ('text', 'Wochenbericht: erledigt / nächste Woche', True)],
 'hover_title': 'Bewegen Sie den Mauszeiger, um alles zu sehen',
 'hover_text': 'Bewegen Sie den Mauszeiger, um den gesamten Artikel anzuzeigen.',
 'hover_alt': 'Der Zeiger ruht auf Besprechungsnotizen und eine Karte zeigt den vollständigen Text: '
              'Eigentümer, Freigabefenster und Überwachung',
 'search_title': 'Suchen Sie, was Sie kopiert haben',
 'search_text': 'Suchen Sie nach Text oder Dateinamen. Wird standardmäßig 3 Tage lang aufbewahrt, bis zu 30.',
 'search_query': 'Vertrag',
 'search_hits': ['unterschriebener-vertrag.pdf',
                 'Vertragsklausel 3: Umstellung auf vierteljährliche Zahlungen'],
 'big_title': 'Große Dateien, wenn Sie sie brauchen',
 'big_text': 'Über 50 MB werden zuerst als Datensatz synchronisiert; Klicken Sie zum Übertragen auf '
             '„Empfangen“.',
 'big_file': 'launch-demo.mov',
 'big_meta': 'Ab Mac mini · 1,3 GB',
 'big_button': 'Empfangen',
 'folder_title': 'Auch ganze Ordner',
 'folder_text': 'Kopieren Sie einen Ordner und fügen Sie denselben Ordner ein.',
 'names_from': 'Notizen 10:30?.md',
 'names_to': 'Anmerkungen 10:30？.md',
 'names_title': 'Namen, die überall funktionieren',
 'names_text': 'Charaktere Windows lassen nicht zu, dass sie zu Doppelgängern in voller Breite werden.',
 'net_h2': 'Zuhause und Büro,<br>direkt verbunden.',
 'net_intro': 'Gleiches Netzwerk: installieren und koppeln. Verschiedene Netzwerke: Aktivieren Sie den '
              'Dienst.',
 'net_points': [('Gleiches Netzwerk',
                 'Kein Server. Geben Sie einen Pairing-Code ein und schon sind Sie fertig.'),
                ('Über Netzwerke hinweg', 'Dienst, Ihr eigener Server oder Tailscale.'),
                ('Ende-zu-Ende verschlüsselt',
                 'Beim Koppeln Fingerabdrücke überprüfen; Der Server sieht Ihren Inhalt nie.')],
 'net_links': 'Wählen Sie, wie Sie eine Verbindung herstellen möchten →',
 'net_how': 'So funktioniert es →',
 'net_label': 'Diagramm: Zwei Computer in einem Heim- und einem Büronetzwerk finden einander über den Dienst '
              'und stellen dann eine direkte Verbindung her',
 'net_service': 'Dienst',
 'net_direct': 'Direkt · Ende-zu-Ende-verschlüsselt',
 'numbers_h2': 'Anhand der Zahlen.',
 'numbers': [('3', 'Systeme', 'macOS, Windows, Linux'),
             ('50 MB', '', 'wird beim Kopieren gesendet'),
             ('≈330 ms', '', 'für eine 20-MB-Datei über ein LAN'),
             ('0', 'Konten', 'Keine Anmeldung, einfach koppeln')],
 'closing': 'Probieren Sie es jetzt aus.',
 'how_title': 'So funktioniert PasteFerry : Direktverbindungen, Multi-Uplink-Prüfung und Fehlerbehandlung',
 'how_lede': 'Was passiert beim Kopieren, wie verbinden sich Computer und was passiert, wenn dies nicht '
             'möglich ist?',
 'security_title': 'Sicherheit und Datenschutz: End-to-End-Verschlüsselung und Paarungsüberprüfung – '
                   'PasteFerry',
 'security_lede': 'Nur Ihre Geräte können das, was Sie kopieren, entschlüsseln. Der Server kann nicht.',
 'privacy_link': 'Datenschutzerklärung →',
 'faq_title': 'FAQ – PasteFerry',
 'faq_lede': 'Sie können keine Antwort finden? Lassen Sie es uns wissen.',
 'faq_more': 'Ein Problem melden →'}

TOUR = {'opening_1': 'Kopieren zwischen zwei Computern',
 'opening_2': 'sollte nicht so viel Arbeit sein.',
 'pain_chat': 'Senden Sie es an sich selbst',
 'pain_chat_detail': 'Senden, öffnen, herunterladen und dann die Datei suchen',
 'airdrop': 'AirDrop',
 'pain_airdrop_detail': 'Akzeptiere jedes Mal. Immer noch keine Synchronisierung der Zwischenablage.',
 'universal': 'Universelle Zwischenablage',
 'pain_universal_detail': 'Gleiches Apple ID und die Geräte müssen in der Nähe sein',
 'pain_cross_platform': 'Zwischen Mac und Windows',
 'pain_cross_platform_detail': 'Keine der integrierten Optionen funktioniert',
 'simpler': 'Es kann viel einfacher sein.',
 'tagline': 'Auf diesen Computer kopieren. Fügen Sie das ein.',
 'notes': 'Notizen',
 'decision_1': 'Einführung auf 10\xa0% am Dienstag.',
 'decision_2': 'Alle Benutzer am Donnerstag, wenn alles gut geht.',
 'screenshot': 'Screenshot.png',
 'notepad': 'Besprechungsnotizen.txt – Notizblock',
 'word': 'Wochenbericht.docx – Word',
 'demo_file': 'Kopieren Sie eine Datei auf den Mac. Fügen Sie es auf Windows ein.',
 'demo_text': 'Und zurück: auf Windows kopieren, auf Mac einfügen.',
 'demo_image': 'Auch Screenshots. Sie werden als Bilder eingefügt.',
 'types': 'Was Sie kopieren, ist das, was Sie einfügen',
 'text': 'Text',
 'rich_text': 'Formatierter Text',
 'images': 'Bilder',
 'files': 'Dateien',
 'folders': 'Ganze Ordner',
 'small_files': 'Unter 50 MB? Die Übertragung beginnt, während Sie kopieren.',
 'large_files': 'Größere Dateien kommen bei Bedarf mit einem Klick an.',
 'history_1': 'Alles, was du kopiert hast,',
 'history_2': 'alles an einem Ort',
 'retention': 'Standardmäßig 3 Tage Verlauf',
 'restore': 'Klicken Sie, um es erneut zu kopieren',
 'preview': 'Vorschau der Bilder an Ort und Stelle',
 'pull': 'Rufen Sie große Dateien ab, wenn Sie sie benötigen',
 'pairing': 'Einmal koppeln und schon kann es losgehen',
 'nearby': 'Suchen Sie im selben Netzwerk einen Computer in der Nähe und koppeln Sie ihn',
 'fingerprints': 'Überprüfen Sie vor der Bestätigung die Fingerabdrücke auf beiden Bildschirmen',
 'networks': 'Ein Netzwerk oder mehrere. Ihre Wahl.',
 'home': 'Zu Hause oder im Büro,',
 'lan_detail': 'Kein Server zum Einrichten',
 'cloud_detail': 'Hosten Sie eine kleine Cloud-VM,',
 'anywhere': 'Von überall aus synchronisieren',
 'across': 'Über Netzwerke hinweg,',
 'tailscale_detail': 'ohne eigenen Server',
 'encrypted': 'Wenn möglich eine direkte Verbindung. Ende-zu-Ende verschlüsselt.',
 'relay': 'Im Servermodus leitet Ihr Server verschlüsselte Daten weiter, wenn eine direkte Verbindung '
          'fehlschlägt.',
 'comparison': 'Wie es im Vergleich aussieht',
 'free': 'Kostenlos und Open Source',
 'download': 'Download',
 'source': 'Quelle',
 'closing': 'Weniger herumschicken. Mehr Dinge erledigen.'}

TOUR_UI = {'watch': 'Sehen Sie sich die komplette Tour an',
 'title': 'Lernen Sie PasteFerry in 85 Sekunden kennen',
 'play': 'Spielen',
 'pause': 'Pause',
 'replay': 'Wiederholung',
 'progress': 'Wiedergabeposition',
 'chapters': 'Wählen Sie ein Kapitel',
 'fullscreen': 'Vollbild',
 'exit_fullscreen': 'Verlassen Sie den Vollbildmodus',
 'close': 'Rundgang schließen',
 'back': 'Zurück zur Website',
 'summary': 'Tour-Highlights',
 'silent': 'Stille Tour'}

TOUR_CHAPTERS = ['Zu viele Schritte',
 'Lernen Sie PasteFerry kennen',
 'Kopieren und einfügen',
 'Was Sie synchronisieren können',
 'Verlauf der Zwischenablage',
 'Sicheres Pairing',
 'Möglichkeiten zur Verbindung',
 'Vergleichen Sie Optionen',
 'Fangen Sie an']

THEMES = {'name': 'Themenführer',
 'title': 'Themenführer – PasteFerry',
 'summary': 'Ändern Sie Themen in PasteFerry, schalten Sie hell und dunkel um, erstellen Sie Ihr eigenes '
            'Thema und lassen Sie KI-Apps wie Claude und Cursor Themen entwerfen und über MCP anwenden.',
 'fit': 'Ändern Sie es, machen Sie es,<br>oder lassen Sie es von einer KI machen.',
 'lede': 'PasteFerry 2.12.1 umfasst neun Themen: Default, Pixel, Jazz Records, Space Age, Memphis, Y2K '
         'Future, Vintage Print, Pixel Arcade und Retro Desktop. Jeder unterstützt den Hell- und '
         'Dunkelmodus. Kopieren Sie eines, um es anzupassen, oder lassen Sie sich von der KI beim Entwerfen '
         'eines Themas unterstützen. Die Designs bleiben auf jedem Gerät lokal.',
 'download': 'Laden Sie 2.12.1herunter',
 'jump_ai': 'Springe zu den von KI erstellten Themen ↓',
 'switch_title': 'Ändern Sie das Thema',
 'switch_steps': ['Öffnen Sie PasteFerry und gehen Sie zu <b>Einstellungen › Aussehen</b>.',
                  'Klicken Sie unter „Integriert“ oder „Benutzerdefiniert“ auf ein Thema. Das Fenster ändert '
                  'sich sofort, ebenso wie Quick Paste.',
                  'Wählen Sie unter Hell und Dunkel die Option <b>System anpassen</b>, <b>Hell</b> oder '
                  '<b>Dunkel</b>aus.',
                  'Bei einem Pixelthema können Sie auch <b>Scanlines</b>aktivieren, schwache CRT-Linien über '
                  'das gesamte Fenster.',
                  'Wählen Sie auf Android in den App-eigenen <b>-Einstellungen › Aussehen</b>; Computer und '
                  'Telefone beeinflussen sich nicht gegenseitig.'],
 'switch_alt': 'Einstellungen › Darstellung: die integrierten Standard- und Pixel-Designs, zwei '
               'benutzerdefinierte Designs, Import-Thema, Bitten Sie die KI, ein Design zu erstellen, hell '
               'und dunkel und Scanlines',
 'builtin_title': 'Neun integrierte Themen',
 'builtin': [('Standard', 'Der ruhige, systemartige Look, den PasteFerry schon immer hatte.'),
             ('Pixel',
              'Bitmap-Typ, eingekerbte Ränder und abgeschrägte Schaltflächen, Graphit- und Papierpaletten '
              'mit Pixelgrün. Oben eine Nacht- oder Tagesszene, ein Papierflieger beim Senden und eine '
              'Explosion von Sternen, wenn er ankommt.'),
             ('Jazzaufzeichnungen',
              'Plattenhüllengeometrie, Kobaltblau, warmes Papier und komprimierte Überschriften.'),
             ('Weltraumzeitalter',
              'Orangefarbene Emaille, Silbertöne, Orbitalillustrationen und Kapselsteuerung.'),
             ('Memphis', 'Rosa und Gelb, geometrische Collage und starke Konturen.'),
             ('Y2K-Zukunft', 'Elektrisches Blau, verchromte Sterne und abgerundete digitale Bedienelemente.'),
             ('Vintage-Druck', 'Creme und warmes Rot, Rasterpunkte und Ticketillustrationen.'),
             ('Pixel-Arcade', 'Handheld-grüne, bitmapartige und gekerbte, inventarähnliche Steuerelemente.'),
             ('Retro-Desktop',
              'Blaugrüne und graue, quadratische, abgeschrägte Knöpfe und klassische '
              'Fensterillustrationen.')],
 'builtin_alt_default': 'Verlauf im Standardthema (leicht)',
 'builtin_alt_pixel': 'Geschichte im Pixel-Thema (dunkel): Berge und ein Mond in der Kopfzeile, ein Zelt und '
                      'ein Lagerfeuer unten in der Seitenleiste',
 'custom_title': 'Erstellen Sie Ihr eigenes Thema',
 'custom_intro': 'Der einfachste Weg besteht darin, ein integriertes Design zu duplizieren und zu ändern:',
 'custom_steps': ['Bewegen Sie in <b>Settings › Appearance</b>den Mauszeiger über ein Thema, klicken Sie auf '
                  '<b>⋯</b> und wählen Sie <b>Duplicate</b>aus. Die Kopie wird unter „Benutzerdefiniert“ '
                  'angezeigt.',
                  'Wählen Sie im Menü <b>⋯</b> der Kopie die Option <b>Export…</b> , um eine '
                  '<code>.pasteferry-theme.json</code> -Datei zu speichern.',
                  'Ändern Sie die Farben, den Namen usw. in einem beliebigen Texteditor (das Format wird '
                  'unten beschrieben).',
                  'Klicken Sie auf der Seite „Darstellung“ auf <b>Thema importieren…</b> und wählen Sie die '
                  'Datei aus. Ein Theme mit derselben ID wird ersetzt und das importierte Theme wird '
                  'angewendet.',
                  'Um ein benutzerdefiniertes Design zu entfernen, wählen Sie <b>Thema löschen</b> im Menü '
                  '<b>⋯</b> . Integrierte Designs können nicht gelöscht werden.'],
 'custom_note': 'Der Textkontrast wird überprüft, wenn ein Design gespeichert wird. Auf schwer lesbare '
                'Farben wird hingewiesen, Sie können aber trotzdem sparen. Theme-Dateien können geteilt '
                'werden: Die andere Person importiert sie einfach.',
 'bg_title': 'Verwenden Sie ein Hintergrundbild',
 'bg_steps': ['Öffnen Sie <b>Settings › Appearance</b>, scrollen Sie zu <b>Background image</b>, klicken Sie '
              'auf <b>. Wählen Sie Bild…</b> und wählen Sie ein JPEG, PNG oder GIF.',
              'Das Bild füllt das Fenster hinter der Seitenleiste und den Seiten aus und die Seitenleiste '
              'und die Listen werden durchscheinend. Wenn ein integriertes Theme verwendet wird, wird '
              'zunächst eine Kopie erstellt; Das integrierte Thema selbst bleibt gleich.',
              '<b>Blur</b>, <b>Scrim</b> und <b>Panels</b> haben jeweils drei Schritte. <b>Bildfarben '
              'verwenden.</b> übernimmt die Akzentfarbe aus dem Bild und <b>wird auch in Quick Paste '
              'angezeigt.</b> zeigt sie auch dort an.',
              'Klicken Sie auf <b>. Entfernen Sie</b> , um zurückzugehen. Wählen Sie auf Android unter '
              '<b>Einstellungen › Darstellung › Hintergrundbild</b>ein Foto aus.'],
 'bg_note': 'Der Text bleibt immer lesbar: PasteFerry berechnet, wie stark der Stoff für die Textfarben des '
            'Themas auf diesem Bild sein muss und zeigt ihn nie heller an. Dunkle Bilder im Dunkelmodus und '
            'helle Bilder im Hellmodus zeigen den größten Teil des Bildes.',
 'bg_alt': 'Pixelthema im dunklen Modus mit einem Hintergrund mit Hügeln bei Sonnenuntergang: Die '
           'Seitenleiste und die Liste sind durchscheinend und das Bild scheint durch',
 'bg_alt2': 'Einstellungen › Aussehen › Hintergrundbild: ändern, entfernen, drei Schritte für Unschärfe, '
            'Scrim und Panels, Bildfarben verwenden, auch in Quick Paste anzeigen',
 'scene_title': 'Ändern Sie die Szenerie',
 'scene_steps': ['Die Szenerie besteht aus dem breiten Bild oben auf den Seiten und dem kleinen Bild unten '
                 'in der Seitenleiste. Das Pixelthema zeichnet dort eine Pixellandschaft und ein kleines '
                 'Lager; andere Themen haben keine.',
                 'Unter <b>Einstellungen › Aussehen › Landschaft</b>, klicken <b>Bild auswählen…</b> neben '
                 '<b>Seitenkopf</b> oder <b>Seitenleiste unten</b> um Ihre eigenen Bilder zu jedem '
                 'beliebigen Thema zu verwenden. Unter dem Seitentitel wird ein Gitterstoff hinzugefügt, '
                 'damit er lesbar bleibt.',
                 '<b>Zurücksetzen</b> bringt das Original zurück; Deaktivieren Sie <b>Szenerie anzeigen</b> '
                 ', um beide auszublenden. Die Landschaft wird ausgeblendet, während ein Hintergrundbild das '
                 'Fenster ausfüllt.'],
 'scene_alt': 'Pixel-Design im dunklen Modus, wobei der Seitenkopf und der untere Rand der Seitenleiste '
              'durch ein Bild von Hügeln bei Sonnenuntergang ersetzt werden',
 'file_title': 'Wie eine Theme-Datei aussieht',
 'file_intro': 'Ein Thema ist eine JSON -Datei. Schreiben Sie nur das, was Sie ändern möchten; Alles andere '
               'stammt aus dem in <code>base</code>genannten Thema. Dieses beginnt mit Pixel und ändert den '
               'Akzent und einige Hintergründe:',
 'file_fields_title': 'Gemeinsame Felder',
 'file_fields': [('<code>id</code>',
                  'Die Kennung des Themas: Kleinbuchstaben, Ziffern und <code>-</code>. Es kann nicht '
                  '<code>default</code> oder <code>pixel</code>sein.'),
                 ('<code>name</code>',
                  'Der Name in jeder Sprache, z. B. <code>zh-Hans</code>, <code>zh-Hant-TW</code>, '
                  '<code>zh-Hant-HK</code>, <code>en</code> und <code>ja</code>.'),
                 ('<code>base</code>',
                  'Das Thema, mit dem Sie beginnen möchten: <code>default</code>, <code>pixel</code> oder '
                  'ein anderes benutzerdefiniertes Thema.'),
                 ('<code>modes.light</code> / <code>modes.dark</code>',
                  'Farben für hell und dunkel, als <code>#RRGGBB</code> oder <code>#AARRGGBB</code> mit '
                  'Alpha. Gemeinsame: <code>accent</code>, <code>background</code> (Inhaltsbereich), '
                  '<code>sidebar</code>, <code>surface</code> (Gruppen und Dialoge), <code>border</code>, '
                  '<code>text</code>, <code>textDim</code>, <code>textFaint</code> und <code>onAccent</code> '
                  '(Text mit Akzent).'),
                 ('<code>typography</code>',
                  'Schriftarten: <code>family</code> ist <code>system</code> oder die integrierte '
                  'Pixelschrift <code>FusionPixel</code>.'),
                 ('<code>shape</code>',
                  'Formen: <code>corner</code> ist <code>round</code> oder <code>pixel</code> (gekerbt), '
                  'plus Radien, Rahmenbreite und Schattenstil.'),
                 ('<code>motion</code>, <code>icons</code>',
                  'Bewegung <code>smooth</code> / <code>stepped</code> / <code>reduced</code>; Symbole '
                  '<code>system</code> / <code>pixel</code>.'),
                 ('<code>background</code>',
                  'Fensterhintergrundbild: <code>image</code> (<code>user:&lt;sha256&gt;</code> nach dem '
                  'Import), <code>blur</code>, <code>scrim</code>, <code>surfaceOpacity</code> '
                  '(Panel-Deckkraft), <code>scope</code> (welche Fenster es anzeigen), '
                  '<code>accentFromImage</code>.'),
                 ('<code>scenery</code>, <code>scene</code>',
                  'Landschaft ein/aus und Ihre eigenen Bilder: <code>scene.header</code> (Seitenkopf) und '
                  '<code>scene.sidebar</code> (Seitenleiste unten), optional mit <code>headerDark</code> und '
                  '<code>sidebarDark</code> für den Dunkelmodus.')],
 'file_more': 'Das vollständige Format und wo jede Farbe verwendet wird:',
 'ai_title': 'Lassen Sie eine KI ein Thema erstellen',
 'ai_intro': 'PasteFerry enthält einen MCP-Server, <code>pasteferry-cli mcp</code>. Fügen Sie es einer '
             'KI-App hinzu, die MCP unterstützt, wie z. B. Claude Desktop, Claude Code oder Cursor, und '
             'beschreiben Sie das gewünschte Aussehen in einem Satz. Die KI liest das Theme-Format, wählt '
             'Farben aus, prüft den Kontrast, speichert dann das Theme und wendet es an.',
 'ai_step1': '1. Finden Sie pasteferry-cli',
 'ai_paths': [('Mac',
               '<code>/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli</code> (mit Homebrew, nur '
               '<code>pasteferry-cli</code>)'),
              ('Windows', '<code>%LOCALAPPDATA%\\Programs\\PasteFerry\\pasteferry-cli.exe</code>'),
              ('Linux',
               'deb: <code>/usr/bin/pasteferry-cli</code>; tar.gz: <code>PasteFerry/pasteferry-cli</code> im '
               'extrahierten Ordner')],
 'ai_paths_note': 'Oder kopieren Sie die vorgefertigte Konfiguration für diesen Computer aus '
                  '<b>Einstellungen › Aussehen › AI bitten, ein Thema zu erstellen</b>.',
 'ai_step2': '2. Fügen Sie es Ihrer KI-App hinzu',
 'ai_desktop': 'Claude Desktop (Einstellungen › Entwickler › Konfiguration bearbeiten) und Cursor '
               '(<code>~/.cursor/mcp.json</code>) verwenden dieselbe Konfiguration. Auf einem Mac:',
 'ai_code': 'Führen Sie für Claude Code Folgendes in einem Terminal aus:',
 'ai_restart': 'Starten Sie die AI-App neu, nachdem Sie ihre Konfiguration geändert haben. Lassen Sie '
               'PasteFerry laufen: Die KI ändert Themen über ihren Hintergrunddienst auf diesem Computer.',
 'ai_step3': '3. Sagen Sie, was Sie wollen',
 'ai_prompts': ['Machen Sie mir ein Cyberpunk-Thema mit Neonrosa und tiefem Lila und wenden Sie es dann an.',
                'Beginnen Sie mit dem Pixel-Thema und erstellen Sie eine Sonnenuntergangsversion mit einem '
                'wärmeren dunklen Hintergrund.',
                'Der graue Text in meinem aktuellen Theme ist schwer lesbar. Machen Sie es leichter.',
                'Exportieren Sie mein Design, damit ich es sehen kann, und erstellen Sie dann eine '
                'Light-Version.',
                'Verwenden Sie ~/Pictures/beach.jpg als Hintergrund und passen Sie die Farben an das Foto '
                'an.',
                'Ersetzen Sie die Header-Landschaft des Pixel-Themes durch ~/Pictures/mountains.png.'],
 'ai_does_title': 'Was die KI kann',
 'ai_does': ['Themen auflisten und ein Thema vollständig lesen;',
             'Lesen Sie das Themenformat: Wo jede Farbe verwendet wird und welchen Kontrast sie benötigt;',
             'Überprüfen Sie ein Thema, ohne es zu speichern, um Farben mit zu geringem Kontrast zu finden.',
             'Benutzerdefinierte Designs speichern, anwenden und löschen sowie hell und dunkel wechseln;',
             'Importieren Sie ein Bild von diesem Computer als Fensterhintergrund oder Szenerie und '
             'analysieren Sie dessen Helligkeit und Hauptfarben.'],
 'ai_safe_title': 'Was es nicht kann',
 'ai_safe': 'Der MCP-Server läuft nur auf diesem Computer und öffnet keinen Netzwerkport. Es kann nur Themen '
            'und Hintergrundbilder lesen und schreiben. Es kann Ihren Verlauf, Ihre Geräte oder Freunde '
            'nicht sehen oder andere Einstellungen ändern. Hintergrundbilder müssen lokale Dateien sein; Es '
            'wird nichts aus dem Internet heruntergeladen.',
 'faq_title': 'Fragen',
 'faq': [('Werden Themes mit meinen anderen Geräten synchronisiert?',
          'Nein. Ein Design gilt nur für das Gerät, auf dem Sie es festlegen. Um dasselbe Thema an anderer '
          'Stelle zu verwenden, exportieren Sie es und importieren Sie es dort.'),
         ('Die KI hat mein Thema durcheinander gebracht. Wie komme ich zurück?',
          'Wählen Sie „Standard“ oder „Pixel“ unter „Einstellungen“ > „Darstellung“. Löschen Sie '
          'benutzerdefinierte Designs, die Sie nicht benötigen.'),
         ('Beim Importieren wird angezeigt, dass einige Texte möglicherweise schwer lesbar sind.',
          'Einige Text- und Hintergrundfarben weisen einen geringen Kontrast auf. Erhellen oder verdunkeln '
          'Sie diese Farben wie vorgeschlagen, oder bitten Sie die KI, sie zu korrigieren.'),
         ('Unterstützen ältere Versionen Themes?',
          'Sie benötigen 2.10 oder höher. Das Geräteprotokoll bleibt unverändert, sodass alte und neue '
          'Versionen weiterhin zusammenarbeiten.'),
         ('Wird der Text auf meinem Bild schwer lesbar sein?',
          'Nein. Die Scrim-Stärke ergibt sich aus den Textfarben des Themas und ist niemals heller als '
          'nötig. Erhöhen Sie für ein unruhiges Bild die Unschärfe oder die Deckkraft des Bedienfelds.')],
 'more_title': 'Mehr',
 'more_links': [('Lassen Sie eine KI ein Thema erstellen (vollständige Anleitung)', 'guide/ai-themes.md'),
                ('Themenformat und Design', 'design/themes.md'),
                ('MCP-Tools', 'design/mcp.md')]}

OFFICIAL = {'badge': 'In verschiedenen Netzwerken? Schalten Sie „Dienst“ ein und synchronisieren Sie →',
 'title': 'Dienst: Synchronisierung zwischen Zuhause und Büro ohne eigenen Server – PasteFerry',
 'name': 'Dienst',
 'fit': 'Funktioniert zwischen Zuhause und Büro',
 'go': 'Schalten Sie den Dienst ein →',
 'summary': 'Schalten Sie einen Schalter ein und Ihre Heim- und Bürocomputer werden synchronisiert, ohne '
            'dass Sie einen Server kaufen müssen.',
 'lede': 'Wenn sich zwei Computer nicht im selben Netzwerk befinden, aktivieren Sie den Dienst und sie '
         'werden synchronisiert.',
 'steps_title': 'So schalten Sie es ein',
 'steps': ['Installieren Sie die neueste Version auf jedem Computer und klicken Sie auf '
           'Hintergrundsynchronisierung aktivieren.',
           'Aktivieren Sie „Dienst verwenden“ unter „Einstellungen“ → „Verbindung“.',
           'Koppeln Sie die beiden Computer. Computer, die Sie bereits gekoppelt haben, müssen nicht erneut '
           'gekoppelt werden.'],
 'routing_title': 'Direkt wann immer möglich',
 'routing': 'Die Computer stellen eine direkte Verbindung her, wenn sie können, und nutzen den Server nur, '
            'wenn dies nicht möglich ist. Der Inhalt ist verschlüsselt und der Server kann ihn nicht '
            'entschlüsseln.',
 'quota_title': '100 MB Relay pro Tag, direkt unbegrenzt',
 'quota': 'Die Weiterleitung ist auf 100 MB pro Computer und Tag begrenzt. direkt ist unbegrenzt. Auf der '
          'Verbrauchsseite wird angezeigt, wie viel noch übrig ist.',
 'privacy_title': 'Standardmäßig deaktiviert',
 'privacy': 'Der Dienst ist bei einer Neuinstallation deaktiviert. Der Server erhält niemals das, was Sie '
            'kopieren; siehe Datenschutzerklärung.',
 'self_title': 'Sie müssen es nicht verwenden',
 'self': 'Im selben Netzwerk benötigen Sie es nicht. Sie können auch Ihren eigenen Server betreiben oder '
         'Tailscale verwenden.',
 'settings_alt': 'Verwenden Sie den Dienstschalter unter Einstellungen → Verbindung',
 'usage_alt': 'Demo-Nutzungsseite für den Dienst mit einem täglichen Kontingent von 100,00 MB und einem '
              'verbleibenden Rest von 80,00 MB',
 'privacy_link': 'Datenschutzhinweis',
 'self_link': 'Leitfaden für Selbsthosting',
 'download': 'Laden Sie die neueste Version herunter'}

PRIVACY = ('Privatsphäre',
 [('Kurz gesagt',
   'Was Sie kopieren, die Dateien, die Sie senden, deren Namen und Ihre Notizen werden '
   'Ende-zu-Ende-verschlüsselt zwischen Ihren eigenen Geräten übertragen. Wir können sie nicht sehen und '
   'speichern sie nicht.'),
  ('Dienst (wenn aktiviert)',
   'Bei Neuinstallationen wird ausschließlich das lokale Netzwerk verwendet. Wenn Sie den Dienst aktivieren, '
   'stellen Ihre Geräte eine Verbindung zum offiziellen Server her, sodass sie sich über Netzwerke hinweg '
   'finden können. Wir speichern eine pseudonyme Gerätenummer, die ersten und letzten Verbindungszeiten '
   'sowie die tägliche Relay-Nutzung. Nur wenn eine direkte Verbindung fehlschlägt und ein Relay '
   'erforderlich ist, leitet die App einen PasteFerry-spezifischen Maschinen-Digest ab, sodass sich ein '
   'Computer ein Relay-Kontingent teilt. Echte Gerätenamen, Rohsystemkennungen und Inhalte werden niemals '
   'hochgeladen.'),
  ('Aktualisierungsprüfungen',
   'Die App sucht einmal täglich nach Updates und ruft eine signierte Update-Liste von der Website '
   'PasteFerry , GitHub und Gitee ab. Die Anfrage an die Website umfasst die Version, das System und die '
   'Sprache sowie die Angabe, ob es sich um die erste Überprüfung des Tages, der Woche oder des Monats '
   'handelt, um das richtige Update bereitzustellen und zukünftige Versionen zu planen. Es ist keine '
   'Geräte-ID oder kein Konto enthalten und IP-Adressen werden nicht gespeichert. Automatische Prüfungen '
   'können unter Einstellungen → Info deaktiviert werden. Updates werden erst nach Ihrer Bestätigung '
   'installiert und nur, wenn sie mit einer Liste übereinstimmen, die mit dem Release-Schlüssel PasteFerry '
   'signiert ist.'),
  ('Kontakte',
   'Ein Kontakt sieht den von Ihnen festgelegten Anzeigenamen und Avatar, den Namen und das System des '
   'Computers, von dem aus Sie senden, und ob Sie das lokale Netzwerk, den Dienst oder Ihren eigenen Server '
   'verwenden (für Ihren eigenen Server nur eine Zusammenfassung seiner Adresse). Ihre Zwischenablage, Ihr '
   'Verlauf und andere Geräte werden niemals mit Kontakten geteilt und ihre Dateien kommen erst an, nachdem '
   'Sie sie akzeptiert haben.'),
  ('Website',
   'Diese Website verwendet Cloudflare Web Analytics und speichert ihre eigenen Gesamtwerte der '
   'Seitenaufrufe und Download-Klicks (Datum, Seitenpfad, Seitensprache, Version und heruntergeladene '
   'Datei). Es werden keine Analyse-Cookies oder dauerhaften Besucheridentifikatoren verwendet und '
   'IP-Adressen und Browser-Identifikatoren werden nicht gespeichert. Wenn „Do Not Track“ oder „Global '
   'Privacy Control“ aktiviert ist, werden die eigenen Zähler der Website nicht gesendet.'),
  ('Diskussion und Feedback',
   'Von Ihnen übermittelte Spitznamen und Texte werden zur Überprüfung und Unterstützung auf dem Server '
   'gespeichert und nach der Genehmigung veröffentlicht. Wenn die KI-Überprüfung aktiviert ist, wird der '
   'erforderliche Text gemäß den Datenverarbeitungsbedingungen dieses Anbieters an einen KI-Dienst eines '
   'Drittanbieters wie DeepSeek gesendet. Administratoren können auch Einreichungen lesen und bearbeiten. '
   'Ihr Browser speichert Entwürfe, Einreichungsdatensätze und Zugangsdaten pro Nachricht bis zu 30 Tage '
   'lang. Durch das Löschen lokaler Daten werden keine Servernachrichten zurückgezogen. Verwenden Sie den '
   'Originalbrowser, um sie zu entfernen. Unveröffentlichte, zurückgezogene und versteckte Inhalte werden '
   'nach 90 Tagen entfernt; Öffentliche Inhalte bleiben bestehen, bis sie zurückgezogen oder gelöscht '
   'werden. Zur Missbrauchsprävention werden temporäre Quellauszüge verwendet, anstatt rohe IP-Adressen zu '
   'speichern. Übermitteln Sie keine Passwörter, API-Schlüssel oder privaten Informationen.'),
  ('Wie es verwendet wird',
   'Diese Informationen werden zur Bereitstellung und Verbesserung des Dienstes, zur Veröffentlichung von '
   'Updates, zur Gewährleistung der Sicherheit des Dienstes und zur Verhinderung von Missbrauch, zur Messung '
   'und Planung sowie zur Erfüllung gesetzlicher Verpflichtungen verwendet. Wir verkaufen es nicht und '
   'nutzen es nicht für Werbezwecke.'),
  ('Dritte',
   'GitHub, Gitee, Cloudflare und jeder von Ihnen ausgewählte Server bearbeiten Ihre Anfragen an sie gemäß '
   'ihren eigenen Datenschutzrichtlinien.'),
  ('Aufbewahrung',
   'Die täglichen Servicedetails pro Gerät werden 90 Tage lang gespeichert. Tagessummen ohne '
   'Personenidentität werden auf unbestimmte Zeit aufbewahrt.'),
  ('Ihre Entscheidungen',
   'Sie können nur das lokale Netzwerk verwenden, den Dienst deaktivieren, automatische Update-Prüfungen '
   'deaktivieren oder Ihren eigenen Server betreiben. Der PasteFerry -Client und -Server sind Open Source.'),
  ('Haftungsausschluss und Änderungen',
   'PasteFerry und der Service werden kostenlos und im Ist-Zustand bereitgestellt; Staffelzulagen und '
   '-funktionen können sich ändern oder ausgesetzt werden. Wir haften nicht für Datenverluste oder '
   'fehlgeschlagene Synchronisierungen, die durch Netzwerke, Geräte, Dienste Dritter oder selbst gehostete '
   'Server verursacht werden. Änderungen dieser Mitteilung werden wirksam, wenn sie auf der Website '
   'veröffentlicht werden; Wenn Sie PasteFerry weiterhin verwenden, akzeptieren Sie diese.'),
  ('Kontakt',
   'Fragen zu diesem Hinweis: Öffnen Sie ein Problem unter github.com/baiyuze/pasteferry/issues.')])

FEEDBACK = {'name': 'Diskussion & Feedback',
 'lede': 'Melden Sie ein Problem, schlagen Sie eine Funktion vor oder teilen Sie Ihre Erfahrungen.',
 'all': 'Alle',
 'bug': 'Fehlerbericht',
 'idea': 'Funktionsanfrage',
 'discussion': 'Diskussion',
 'new': 'Starten Sie ein Thema',
 'mine': 'Meine Einsendungen',
 'mine_note': 'Hier werden nur in diesem Browser gespeicherte Datensätze angezeigt. Das Löschen von '
              'Browserdaten oder das Wechseln des Geräts kann dazu führen, dass unveröffentlichte Beiträge '
              'nicht mehr zugänglich sind.',
 'nickname': 'Spitzname',
 'title': 'Titel',
 'body': 'Nachricht',
 'category': 'Kategorie',
 'platform': 'Betriebssystem',
 'version': 'App-Version',
 'optional': 'Optional',
 'submit': 'Senden',
 'reply': 'Beteiligen Sie sich an der Diskussion',
 'back': 'Zurück zu den Themen',
 'more': 'Mehr laden',
 'empty': 'Noch keine öffentlichen Themen. Ihr Feedback ist willkommen.',
 'loading': 'Wird geladen…',
 'error': 'Es kann keine Verbindung hergestellt werden. Bitte versuchen Sie es später noch einmal.',
 'saved': 'Entwurf in diesem Browser gespeichert',
 'storage_warning': 'Der Browserspeicher ist nicht verfügbar. Entwürfe und Anmeldeinformationen für die '
                    'Einreichung können nach einer Aktualisierung verloren gehen.',
 'submitted': 'Eingereicht. Ihre Nachricht wird nach der Genehmigung öffentlich sein.',
 'uncertain': 'Der Status der Einreichung ist ungewiss. Versuchen Sie die ursprüngliche Übermittlung erneut.',
 'withdrawn': 'Zurückgezogen',
 'expired': 'Datensatz abgelaufen',
 'confirm_withdraw': 'Diese Nachricht zurückziehen? Es wird nicht mehr öffentlich sein.',
 'clear': 'Löschen Sie lokale Datensätze',
 'confirm_clear': 'Lokale Entwürfe und Anmeldeinformationen löschen? Dadurch werden keine Nachrichten auf '
                  'dem Server zurückgezogen.',
 'retry': 'Übermittlung erneut versuchen',
 'withdraw': 'Zurückziehen',
 'official': 'Offiziell',
 'pending': 'KI-Überprüfung läuft',
 'manual': 'Warten auf manuelle Überprüfung',
 'approved': 'Öffentlich',
 'rejected': 'Nicht genehmigt',
 'hidden': 'Versteckt',
 'open': 'Offen',
 'in_progress': 'In Bearbeitung',
 'resolved': 'Gelöst',
 'closed': 'Geschlossen',
 'draft': 'Beschreiben Sie Ihr Problem oder Ihre Idee ...',
 'privacy': 'Privatsphäre',
 'clearing': 'Durch das Löschen lokaler Datensätze werden keine Nachrichten zurückgezogen. Entfernen Sie '
             'zunächst alle öffentlichen Inhalte.',
 'no_topic': 'Dieses Thema ist nicht verfügbar oder wurde nicht veröffentlicht.',
 'all_languages': 'Alle Sprachen',
 'language': 'Nachrichtensprache',
 'published': 'Veröffentlicht',
 'failure': 'Ihre Nachricht enthält möglicherweise unangemessenen Inhalt. Bitte bearbeiten Sie es und '
            'versuchen Sie es erneut.',
 'visitor': 'Besucher',
 'sending': 'Einreichen…',
 'required_fields': 'Bitte schreiben Sie Ihr Problem oder Ihre Idee.',
 'secure_unavailable': 'Dieser Browser kann keine sichere Übermittlung durchführen. Öffnen Sie die Website '
                       'HTTPS in einem aktuellen Browser.',
 'rate_limited': 'Zu viele Einsendungen. Bitte versuchen Sie es in Kürze noch einmal. Ihr Text wurde '
                 'beibehalten.',
 'unavailable': 'Neue Nachrichten können derzeit nicht angenommen werden. Bitte versuchen Sie es später. Ihr '
                'Text wurde beibehalten.',
 'invalid_fields': 'Bitte überprüfen Sie Ihre Eingaben und deren Länge und versuchen Sie es dann erneut.',
 'extra': 'Zusätzliche Details (optional)'}
