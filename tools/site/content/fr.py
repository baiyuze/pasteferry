"""Website copy: French. Translation-assisted; key product copy and app terminology reviewed."""

C = {'brand': 'PasteFerry',
 'brand_alt': ['隔空贴', 'CopySync'],
 'title': 'PasteFerry: presse-papiers multi-appareils, historique et transfert de fichiers',
 'description': "Copiez et collez entre ordinateurs, recherchez l'historique de votre presse-papiers et "
                'envoyez des photos et des fichiers entre ordinateurs et Android. Mac, Windows, Linux, '
                'Android et une page Web de téléphone. Android et Web fonctionnent sur le même réseau. '
                'Gratuit et open source.',
 'og_title': 'PasteFerry: presse-papiers multi-appareils, historique et transfert de fichiers',
 'og_description': "Copiez et collez entre ordinateurs, recherchez l'historique de votre presse-papiers et "
                   'envoyez des photos et des fichiers entre ordinateurs et Android. Mac, Windows, Linux, '
                   'Android et une page Web de téléphone. Android et Web fonctionnent sur le même réseau. '
                   'Gratuit et open source.',
 'og_image': 'og-fr.png',
 'skip': 'Passer au contenu',
 'home_label': 'Accueil PasteFerry',
 'nav_label': 'Pages',
 'nav_start': 'Démarrage rapide',
 'nav_how': 'Comment ça marche',
 'nav_faq': 'FAQ',
 'nav_server': 'Façons de se connecter',
 'nav_download': 'Télécharger',
 'lang_label': 'Langue',
 'h1': 'Copiez ici.<br>Collez ailleurs.',
 'lede': 'Synchronisez le presse-papiers, gardez un historique et envoyez des fichiers.',
 'dl_button': 'Télécharger PasteFerry',
 'dl_mac': 'Télécharger pour Mac',
 'dl_win': 'Télécharger pour Windows',
 'dl_linux': 'Télécharger pour Linux',
 'dl_note': 'Gratuit et open source · Mac / Windows / Linux / Android',
 'start_link': 'Démarrage rapide →',
 'stage_label': 'Démo\xa0: la commande C sur un MacBook transforme un fichier en une feuille qui survole une '
                'connexion directe à un ordinateur portable Windows , où Ctrl V pastes it',
 'stage_file': 'Bilan du troisième trimestre - final.pptx',
 'stage_win': 'Ordinateur portable Windows',
 'stage_arc': 'Chiffrement direct de bout en bout',
 'replay': 'Rejouer',
 'paths_h2': 'Modes de connexion',
 'paths_intro': 'Associez les appareils sur le même réseau, ou utilisez le Service, votre serveur ou Tailscale.',
 'paths_after': 'Nouveau ici ? Suivez le démarrage rapide <a href="{start}#server"></a>. Le service est '
                'gratuit : 100 Mo de relais par jour, connexions directes illimitées.',
 'plans_label': 'Façons de se connecter',
 'plans': {'lan': {'name': 'Même réseau',
                   'fit': 'Sans serveur',
                   'summary': 'Associez par code sur le même réseau Wi-Fi ou filaire.',
                   'go': 'Même guide réseau →',
                   'facts': [('Idéal pour',
                              'À la maison ou au bureau, avec les deux ordinateurs sur le même réseau Wi-Fi '
                              'ou filaire.'),
                             ('Vous avez besoin', "Rien que l'application sur chaque ordinateur."),
                             ("Gardez à l'esprit",
                              "La synchronisation s'arrête lorsque vous quittez le réseau et reprend à votre "
                              'retour. Si les réseaux filaire et Wi-Fi se trouvent sur des sous-réseaux '
                              'différents, vous saisissez une adresse supplémentaire lors du couplage.')],
                   'steps': ['Connectez les deux ordinateurs au même réseau Wi-Fi ou filaire.'],
                   'address': 'Aucune adresse de serveur à saisir.'},
           'cloud': {'name': 'Votre propre serveur public',
                     'fit': 'Votre serveur, relais illimité',
                     'summary': 'Hébergez-le sur votre serveur Linux.',
                     'go': 'Guide du serveur public →',
                     'facts': [('Idéal pour', 'Exécuter le serveur vous-même ou relayer beaucoup de trafic.'),
                               ('Vous avez besoin',
                                'Une VM Linux avec une adresse IP publique et un accès root.'),
                               ("Gardez à l'esprit",
                                "La VM coûte de l'argent et la vitesse du relais est limitée par sa bande "
                                "passante. En Chine continentale, saisissez l'adresse IP, sauf si le domaine "
                                "dispose d'un dépôt ICP.")],
                     'steps': ['Installez le serveur en suivant le <a href="{cloud}">guide</a>.',
                               'Saisissez l’adresse générée dans Paramètres → Connexion.'],
                     'address': "Ouvrez <code>http://PUBLIC_IP:8787/healthz</code> dans un navigateur. S'il "
                                'dit ok, il fonctionne.'},
           'ts': {'name': 'Tailscale',
                  'fit': 'Sur les réseaux, pas de serveur',
                  'summary': 'Associez via votre réseau Tailscale.',
                  'go': 'Guide Tailscale →',
                  'facts': [('Idéal pour',
                             "Vous utilisez déjà Tailscale ou ne souhaitez dépendre d'aucun serveur."),
                            ('Vous avez besoin', 'Tailscale sur chaque ordinateur, connecté au même compte.'),
                            ("Gardez à l'esprit",
                             "Tailscale doit rester connecté. Lorsqu'il ne peut pas connecter directement "
                             'deux ordinateurs, il effectue le relais via ses propres serveurs, ce qui peut '
                             'être lent.')],
                  'steps': ['Installez Tailscale sur chaque ordinateur et connectez-vous au même compte.',
                            "Sur l'autre ordinateur, exécutez <code>tailscale ip -4</code> et notez l'adresse commençant par 100."],
                  'address': "Aucun serveur n'est nécessaire. Une adresse Tailscale ne change pas, vous la "
                             "saisissez donc une fois, lors de l'appairage."}},
 'flow_h2': 'Que se passe-t-il lorsque vous copiez',
 'flow_intro': 'Le texte, les images et les fichiers empruntent tous le même chemin.',
 'flow': [('Avis', 'Le service en arrière-plan voit que le presse-papiers a changé.'),
          ('Envoyer',
           "Les textes et fichiers jusqu'à 50 Mo sont immédiatement transmis. Les plus grands sont d'abord "
           "envoyés sous forme d'enregistrement."),
          ('Coller',
           "L'autre ordinateur l'enregistre localement et le place dans le presse-papiers. Vous collez un "
           'vrai fichier.')],
 'why_h2': 'Pourquoi ne pas utiliser ce que vous avez déjà',
 'why_intro': 'Universal Clipboard a besoin du même Apple ID, AirDrop vous fait accepter à chaque fois, et '
              'aucun ne fonctionne entre un Mac et un PC Windows .',
 'compare_caption': 'PasteFerry par rapport aux autres options',
 'compare_cols': ['PasteFerry', 'Presse-papiers universel', 'AirDrop', 'Applications de chat'],
 'compare_rows': [('Aucun compte requis',
                   [('yes', 'Oui'),
                    ('no', 'Idem Apple ID'),
                    ('partial', 'Appareils Apple uniquement'),
                    ('no', 'Connexion nécessaire')]),
                  ('Entre Mac, Windows, Linux et Android',
                   [('yes', 'Oui'), ('no', 'Non'), ('no', 'Non'), ('yes', 'Oui')]),
                  ('Entre la maison et le bureau',
                   [('yes', 'Oui'), ('no', 'Non'), ('no', 'Non'), ('yes', 'Oui')]),
                  ('Sur un réseau local sans Internet',
                   [('yes', 'Oui'), ('partial', 'A proximité seulement'), ('yes', 'Oui'), ('no', 'Non')]),
                  ('Coller juste après la copie, rien à accepter',
                   [('yes', 'Oui'), ('yes', 'Oui'), ('no', 'Non'), ('no', 'Non')]),
                  ('Fichiers et dossiers entiers, de toute taille',
                   [('yes', 'Oui'),
                    ('partial', 'Peu fiable'),
                    ('yes', 'Oui'),
                    ('partial', "Zip d'abord, limites de taille")]),
                  ('Trouvez quelque chose que vous avez copié plus tôt',
                   [('yes', 'Oui'),
                    ('no', 'Non'),
                    ('no', 'Non'),
                    ('partial', "Faire défiler vers l'arrière")]),
                  ('Seuls vos appareils peuvent décrypter',
                   [('yes', 'Oui'),
                    ('yes', 'Oui'),
                    ('yes', 'Oui'),
                    ('some', "Cela dépend de l'application")])],
 'tour_compare_rows': [('Différents identifiants Apple',
                        [('yes', 'Oui'), ('no', 'Non'), ('partial', 'Il faut accepter'), ('yes', 'Oui')]),
                       ('Entre Mac, Windows et Linux',
                        [('yes', 'Oui'), ('no', 'Non'), ('no', 'Non'), ('yes', 'Oui')]),
                       ('Entre la maison et le bureau',
                        [('yes', 'Oui'), ('no', 'Non'), ('no', 'Non'), ('yes', 'Oui')]),
                       ('Coller juste après la copie',
                        [('yes', 'Oui'), ('yes', 'Oui'), ('no', 'Non'), ('no', 'Non')]),
                       ('Fichiers et dossiers entiers',
                        [('yes', 'Oui'),
                         ('partial', 'Peu fiable'),
                         ('yes', 'Oui'),
                         ('partial', "Zippez d'abord")]),
                       ('Trouvez quelque chose que vous avez copié plus tôt',
                        [('yes', 'Oui'),
                         ('no', 'Non'),
                         ('no', 'Non'),
                         ('partial', "Faire défiler vers l'arrière")]),
                       ('Seuls vos appareils peuvent décrypter',
                        [('yes', 'Oui'),
                         ('yes', 'Oui'),
                         ('yes', 'Oui'),
                         ('some', "Cela dépend de l'application")])],
 'how_h2': 'Comment ça marche',
 'how_intro': 'Sur un même réseau, les ordinateurs se retrouvent directement. Sur différents réseaux, un '
              "serveur les introduit afin qu'ils puissent essayer de se connecter directement, et les relaye "
              "uniquement en cas d'échec. Le contenu est toujours crypté.",
 'diagram': {'title': 'Comment PasteFerry se connecte',
             'desc': "L'ordinateur A et l'ordinateur B se connectent directement via WebRTC. Les deux se "
                     'connectent au serveur pour la signalisation. Si la connexion directe échoue, les '
                     'données sont relayées via le service TURN du serveur.',
             'server': 'Service de signalisation et de relais',
             'server_sub': 'Signalisation, STUN, relais TOUR',
             'sig_note': 'Signalisation\xa0: détails de connexion',
             'relay_note': "Relais\xa0: uniquement en cas d'échec direct",
             'copy_here': 'Tu copies ici',
             'other': 'Mac, Windows ou Linux',
             'paste_here': 'Tu colles ici',
             'direct': 'Direct WebRTC, DTLS crypté',
             'direct_note': 'Les données se déplacent uniquement entre vos ordinateurs',
             'legend_direct': 'Données (directes)',
             'legend_relay': 'Données (relais, secours)',
             'legend_sig': 'Signalisation'},
 'uplink_h2': 'Directement sur les réseaux de bureau également',
 'uplink_intro': 'Les réseaux de bureau avec plusieurs liaisons montantes passaient par le relais. '
                 "PasteFerry trouve chaque liaison montante et permet à l'autre côté de les essayer chacune.",
 'uplink_changed': 'Ce que ça fait',
 'uplink_points': [('Un port partagé.', 'Toutes les connexions utilisent le même port UDP .'),
                   ('Chaque liaison montante a été sondée.',
                    'Il demande sept serveurs à la fois et obtient une adresse par liaison montante.'),
                   ('Tous envoyés de l’autre côté.',
                    "L'autre ordinateur essaie chacun d'eux jusqu'à ce que l'un d'entre eux réussisse."),
                   ('Réessayez directement en mode inactif.',
                    "Le relais maintient le fonctionnement et passe en mode direct lorsqu'il est inactif.")],
 'lab_h3': 'Testé sur des configurations réseau réelles',
 'lab_intro': 'Chaque commit est testé automatiquement sur des réseaux simulés.',
 'lab_cols': ['Scénario', 'Résultat'],
 'lab_rows': [('Liaison montante unique ↔ routeur domestique', 'Direct'),
              ('Deux liaisons montantes, version précédente (contrôle)', 'Relais'),
              ('Quatre liaisons montantes ↔ routeur domestique', 'Direct'),
              ('Deux liaisons montantes ↔ deux liaisons montantes', 'Direct'),
              ('Deux liaisons montantes ↔ NAT qui randomise les ports', 'Relais'),
              ('Bloqué au début, le réseau récupère plus tard', 'Relais, puis direct'),
              ('Pas de serveur, même sous-réseau', 'Direct'),
              ('Pas de serveur, sous-réseaux isolés les uns des autres', 'Aucune connexion')],
 'uplink_measured': 'Mesuré : un Mac sur un réseau de bureau à 4 liaisons montantes et un à la maison relayé '
                    'à 0,6 Mo/s auparavant. Désormais, ils se connectent directement.',
 'uplink_doc': 'Les détails figurent dans le document de conception <a href="{doc}"></a> (en chinois).',
 'security_h2': 'Le serveur ne peut pas voir ce que vous copiez',
 'security_points': [('Pas de compte, pas de contenu stocké.',
                      "L'identité d'un périphérique est une clé, le serveur n'a donc pas besoin de table "
                      'utilisateur.'),
                     ('Vérifiez les empreintes digitales lors du couplage.',
                      "Les deux écrans affichent la même empreinte digitale ; si quelqu'un échange une clé, "
                      'ils ne correspondront pas.'),
                     ('Chaque message est signé,',
                      'le serveur ne peut donc pas se faire passer pour votre appareil.'),
                     ('Le relais transmet uniquement le texte chiffré.',
                      'Les identifiants de relais expirent après 12 heures.'),
                     ('Privé sur le réseau local également.',
                      'Un appareil diffuse un jeton anonyme qui change quotidiennement, afin que personne ne '
                      'puisse savoir de qui il s’agit.')],
 'verify_alt': 'La vérification des empreintes digitales lors du couplage affiche R8NF-2WTC-QL5J et vous '
               "demande de confirmer qu'elle correspond exactement à l'autre ordinateur",
 'fallback_h2': 'Quand les choses tournent mal',
 'fallback_intro': 'Les cas courants sont traités.',
 'fallbacks': [("Impossible de trouver l'autre ordinateur sur le réseau",
                "Entrez son adresse lors de l'appairage\xa0; on s'en souvient après."),
               ('Pas de connexion directe', 'Les données sont relayées via le serveur, toujours cryptées.'),
               ("L'autre ordinateur se met en veille ou s'éteint",
                'Il se reconnecte tout seul à son retour.'),
               ("Déconnecté lors de l'envoi de fichiers", "Le transfert reprend là où il s'était arrêté."),
               ('Un nom de fichier Windows ne permet pas',
                'Les mauvais caractères deviennent des caractères pleine chasse, donc le nom se lit toujours '
                'de la même manière.'),
               ('Copier un mot de passe',
                "Sur Windows, tout ce qui est copié à partir d'un gestionnaire de mots de passe est "
                'ignoré.')],
 'install_h2': 'Installer',
 'install_intro': "Installez l'application sur chaque ordinateur. Première fois ? Suivez le démarrage rapide "
                  '<a href="{start}"></a>.',
 'server_intro': 'Sur le même réseau, installez et associez. Sur différents réseaux, activez le service. Si '
                 'vous souhaitez un contrôle total, exécutez votre propre serveur ou utilisez Tailscale.',
 'copy': 'Copier',
 'copied': 'Copié',
 'pairing': "Affichez un code d'appairage sur un ordinateur, saisissez-le sur l'autre et vérifiez que les "
            "deux lignes d'empreintes digitales correspondent avant de confirmer. Avec Service, vous n'avez "
            "pas besoin de l'adresse de l'autre ordinateur ; vous en entrez un uniquement sur les "
            'sous-réseaux ou avec Tailscale.',
 'specs_h2': 'Spécifications',
 'specs': [('Version', '2.14.0, publié <time datetime="2026-11-26">le 26 novembre 2026</time>'),
           ('Application Mac',
            'macOS 13 Ventura ou version ultérieure\xa0; téléchargements séparés pour Apple Silicon et '
            'Intel, environ 25 Mo chacun, pas de Rosetta ; une version universelle pour les deux fait '
            'environ 47 Mo'),
           ('Application Windows',
            "Windows 10 et Windows 11, x64; installations par utilisateur, aucun droit d'administrateur\xa0; "
            'environ 23 Mo de téléchargement'),
           ('Application Linux',
            'x64 et ARM64; .deb (Debian, Ubuntu et similaires) ou tar.gz (autres distributions), environ 22 '
            'Mo\xa0; nécessite un bureau X11 ou un bureau Wayland avec XWayland (GNOME, KDE et autres '
            "l'incluent par défaut)\xa0; GTK3"),
           ('Serveur',
            'Non nécessaire avec le service ou sur le même réseau. Pour exécuter le vôtre\xa0: Linux '
            'x86_64/ARM64, macOS ou Windows 10/11 x64.'),
           ('Langues',
            '18 langues : anglais, chinois simplifié et traditionnel (Taiwan et Hong Kong), japonais, '
            'coréen, arabe (de droite à gauche), allemand, français, espagnol, portugais (Brésil), italien, '
            'russe, ukrainien, polonais, turc, vietnamien et indonésien ; suit le système par défaut, '
            'commutable dans Paramètres'),
           ('Contenu',
            "Texte brut, texte enrichi, images et captures d'écran, fichiers, dossiers\xa0; chaque type peut "
            'être désactivé'),
           ('Transports',
            'Canaux de données WebRTC , directs en premier avec repli du relais TURN\xa0; sur le même '
            'réseau, découverte mDNS et détails de connexion sur UDP 8788\xa0; chaque liaison montante '
            'sondée sur des réseaux multi-liaison montante\xa0; fichiers diffusés au format tar + zstd'),
           ('Chiffrement et identité',
            'De bout en bout DTLS;  Clés de périphérique Ed25519 ; chaque message de signalisation signé'),
           ('Couplage',
            'Code à 6 caractères valable 5 minutes, utilisant un alphabet sans sosies tels que 0/O et 1/I\xa0'
            '; empreintes digitales vérifiées par vos soins'),
           ('Limite de synchronisation auto', '50 Mo par défaut, réglable de 1 Mo à 1 Go'),
           ('Envoi de fichiers',
            'Vers un appareil, n’importe quelle taille, fichiers ou dossiers entiers\xa0; sur le réseau '
            'local via une liaison cryptée TCP (les deux parties ont besoin de 2.5.1), en revenant à WebRTC '
            "lorsque celle-ci n'est pas disponible\xa0; WebRTC via Internet et relais\xa0; reprend après une "
            'déconnexion\xa0; SHA-256 par fichier. Mac mesuré sur VM Linux , 1 Go\xa0: 144,3\xa0Mo/s\xa0; la '
            'vitesse réelle dépend du réseau et des disques.'),
           ('Contacts',
            'Code de contact à 7 caractères commençant par F, échangé sur le réseau local ou le Service, '
            "avec vérification optionnelle du code de sécurité\xa0; les contacts ne peuvent s'envoyer que "
            'des fichiers et des images, avec une note de 200 caractères maximum, et chaque lot doit être '
            'accepté ; les contacts ne voient jamais votre presse-papiers, votre historique ou vos '
            'appareils\xa0; les fichiers reçus perdent le bit exécutable et sont mis en quarantaine sur un '
            'Mac\xa0; les deux côtés ont besoin de 2.6 ou version ultérieure'),
           ('Historique',
            '3 jours par défaut, réglable de 1 heure à 30 jours ; éléments expirés supprimés '
            'automatiquement'),
           ('Vitesse mesurée',
            'Un fichier de 20 Mo est transféré en 330 ms environ via une connexion LAN directe, les sommes '
            'de contrôle correspondant'),
           ('Construit avec',
            "Optez pour le service et le serveur d'arrière-plan (Go pur appelant Win32 sur Windows et "
            "parlant le protocole X11 sur Linux), Flutter pour l'application (une base de code pour les "
            'trois systèmes), des tampons de protocole pour les messages'),
           ('Licence',
            '<a href="https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md">GNU AGPL-3.0</a>')],
 'faq_h2': 'Questions',
 'faq': [('En quoi est-ce différent du Presse-papiers universel\xa0?',
          ["Le Presse-papiers universel ne fonctionne qu'entre les appareils Apple à proximité sur le même "
           'Apple ID. PasteFerry ne se soucie pas des comptes, fonctionne sur Mac, Windows et Linux, et '
           'entre la maison et le bureau.']),
         ('En quoi est-ce différent de AirDrop?',
          ["AirDrop fonctionne uniquement entre les appareils Apple à proximité.  L'envoi de fichiers de "
           'PasteFerry fonctionne entre Mac, Windows et Linux, également sur les réseaux. Il ne parle pas à '
           'AirDrop; les deux côtés ont besoin de PasteFerry.']),
         ('Ai-je besoin de mon propre serveur ?',
          ['Non. Sur le même réseau, installez et associez ; sur différents réseaux, activez le service <a '
           'href="{official}"></a>. Vous pouvez également utiliser <a href="{cloud}">votre propre '
           'serveur</a> ou <a href="{ts}">Tailscale</a>.']),
         ("Pas d'IP publique à la maison. Puis-je synchroniser entre la maison et le bureau ?",
          ['Oui, activez le service <a href="{official}"></a>.']),
         ('Le serveur peut-il voir ce que je copie ?',
          ["Non, le contenu est chiffré de bout en bout. Consultez l'avis de confidentialité <a "
           'href="{privacy}"></a>.']),
         ('Combien de relais ai-je ?',
          ["100\xa0Mo par ordinateur et par jour\xa0; les connexions directes ne comptent pas. Lorsqu'il est "
           'épuisé, Direct fonctionne toujours. Sans limite, <a href="{cloud}">exécutez votre propre '
           'serveur</a>.']),
         ('Les deux ordinateurs sont sur le même réseau. Pourquoi ne parviennent-ils pas à se retrouver ?',
          ['Ils se trouvent généralement sur des sous-réseaux différents ou un pare-feu les bloque. Lors du '
           "couplage, cliquez sur Sur un autre sous-réseau ? et entrez l'autre adresse. Plus d'informations "
           'dans le même guide réseau <a href="{lan}#faq"></a>.']),
         ('Puis-je envoyer des fichiers vers l’ordinateur de quelqu’un d’autre ?',
          ["Oui. À partir de la version 2.6, ajoutez-les en tant que contact, aucun couplage n'est "
           "nécessaire\xa0; le transfert commence une fois qu'ils ont accepté. Les contacts ne peuvent pas "
           'voir votre presse-papiers ni votre historique.']),
         ('Qu’en est-il des gros fichiers ?',
          ["Jusqu'à 50 Mo sont envoyés lors de la copie. Les fichiers plus volumineux sont récupérés lorsque "
           "vous en avez besoin ou utilisez Envoyer des fichiers, qui n'a pas de limite de taille."]),
         ('Windows? Linux? IPhone ?',
          ["Windows 10 et 11, et Linux sur x64 et ARM64. L'iPhone et l'iPad ne sont pas pris en charge\xa0: "
           'iOS ne permet pas aux applications de lire le presse-papiers en arrière-plan.']),
         ('Pourquoi le système me prévient-il la première fois\xa0?',
          ["PasteFerry n'est pas encore notarié par Apple ni signé par code pour Windows . Sur Mac, cliquez "
           'sur Ouvrir quand même dans Paramètres système → Confidentialité et sécurité\xa0; sur Windows, '
           "cliquez sur Plus d'informations → Exécuter quand même. Vous ne faites cela qu'une seule fois."]),
         ("Est-ce gratuit ? Mon entreprise peut-elle l'utiliser ?",
          ['Oui, gratuit pour les particuliers et les entreprises. PasteFerry est open source sous GNU '
           'AGPL-3.0.']),
         ('Se connecte-t-il directement sur les réseaux bureautiques avec plusieurs liaisons montantes ?',
          ['Oui. PasteFerry essaie chaque liaison montante.']),
         ("Pourquoi les fichiers .uuremote_ continuent-ils d'apparaître pendant l'exécution d'UU Remote\xa0?",
          ["C'était un bug dans les anciennes versions. Mettez à jour vers le dernier."])],
 'closing': 'Téléchargez PasteFerry.',
 'footer_license': 'PasteFerry est open source sous GNU AGPL-3.0.',
 'footer_label': 'Pied de page',
 'footer_links': [('Toutes les versions', 'https://github.com/baiyuze/pasteferry/releases'),
                  ('Journal des modifications',
                   'https://github.com/baiyuze/pasteferry/blob/main/CHANGELOG.md'),
                  ('Notes de conception (chinois)', 'https://pasteferry.cc/design/nat-traversal.html'),
                  ('Licence', 'https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md'),
                  ('Signaler un problème', 'https://github.com/baiyuze/pasteferry/issues')],
 'guide': {'title': 'Exécutez un serveur PasteFerry sur votre LAN\xa0: Windows, Mac et Linux',
           'description': "Lorsque vos ordinateurs partagent un réseau, vous n'avez pas besoin d'un serveur "
                          "cloud. Exécutez le serveur de signalisation et TURN de PasteFerry sur n'importe "
                          'quelle machine Windows, Mac ou Linux toujours active avec un seul script\xa0; ça '
                          "démarre au démarrage. Comprend la configuration et le dépannage de l'application.",
           'h1': 'Exécutez le serveur sur votre réseau local',
           'lede': "Si vos ordinateurs sont sur le même réseau domestique ou professionnel, vous n'avez pas "
                   "besoin d'un serveur cloud. Choisissez un ordinateur qui reste allumé, téléchargez et "
                   "exécutez un script, puis entrez l'adresse qu'il imprime dans PasteFerry sur chaque "
                   'ordinateur.',
           'notice': "<strong>Sur le même réseau, vous n'avez plus besoin de serveur :</strong> installez "
                     'l\'application et associez-la ; voir le même guide réseau <a href="{lan}"></a>. Ce '
                     'guide est toujours utile lorsque deux sous-réseaux ne peuvent pas se joindre et que le '
                     'trafic doit passer par un ordinateur que les deux peuvent atteindre.',
           'toc': [('prepare', 'Avant de commencer'),
                   ('install', 'Installer'),
                   ('check', 'Vérifier'),
                   ('clients', 'Configurer les applications'),
                   ('faq', 'Questions')],
           'overview_h2': 'Le serveur introduit uniquement les appareils',
           'overview_intro': "Chaque ordinateur reste connecté au serveur, c'est ainsi qu'ils se retrouvent "
                             'et échangent les détails de connexion. Une fois connecté, ce que vous copiez '
                             'passe directement entre les deux ordinateurs. Ce n’est qu’en cas d’échec qu’il '
                             'passe par le serveur, toujours crypté.',
           'diagram': {'title': 'PasteFerry sur un réseau local',
                       'desc': 'Sur un réseau local, un Mac et un PC Windows se connectent au serveur à '
                               '192.168.1.20 pour la signalisation. Le contenu copié circule directement '
                               'entre les deux ordinateurs et via le relais TURN du serveur uniquement en '
                               "cas d'échec d'une connexion directe.",
                       'lan': 'Votre LAN\xa0: le même réseau Wi‑Fi ou filaire',
                       'server': 'Serveur',
                       'sig_note': 'Signalisation, TCP 8787',
                       'relay_note': 'Relais, UDP 3478, en cas de défaillance directe',
                       'client': 'Exécution de PasteFerry',
                       'direct': 'Chiffrement direct de bout en bout',
                       'direct_note': 'Le contenu reste entre les deux ordinateurs',
                       'legend_direct': 'Données (directes)',
                       'legend_relay': 'Données (relais, secours)',
                       'legend_sig': 'Signalisation'},
           'overview_points': ['Signalisation<strong>, TCP 8787.</strong> Chaque ordinateur y reste connecté '
                               "pour trouver les autres, s'associer et échanger les détails de connexion.",
                               '<strong>Direct.</strong> Sur un réseau local, le contenu passe presque '
                               'toujours directement entre les deux ordinateurs, à la vitesse de votre '
                               'réseau.',
                               'Relais<strong>, UDP 3478.</strong> Utilisé uniquement lorsque les appareils '
                               'ne peuvent pas se joindre : réseaux invités, Wi-Fi avec isolation client, '
                               'sous-réseaux séparés.'],
           'prep_h2': 'Avant de commencer',
           'prep': [('Un ordinateur qui reste allumé',
                     "Windows 10 ou 11, macOS 13 ou version ultérieure, ou n'importe quel Linux, y compris "
                     "l'un des deux ordinateurs que vous synchronisez. La synchronisation s'interrompt "
                     "lorsqu'il est éteint ou endormi et reprend lorsqu'il se réveille. Un NAS, un routeur "
                     'domestique ou un Mac mini est idéal ; le serveur utilise environ 15 Mo de RAM.'),
                    ('Une adresse fixe',
                     'Réservez-lui une adresse dans les paramètres DHCP de votre routeur (souvent appelé '
                     'réservation DHCP ou bail statique). Sinon, lorsque le routeur distribue une nouvelle '
                     'adresse, chaque ordinateur doit être mis à jour.'),
                    ('Le même réseau',
                     'Les appareils doivent simplement être sur le même réseau Wi-Fi ou filaire. Les réseaux '
                     'invités et le Wi‑Fi avec isolation client (AP) empêchent les appareils de se '
                     'joindre\xa0; utilisez un autre réseau ou désactivez l’isolation.'),
                    ('Aucune synchronisation loin de là',
                     "Le serveur n'est accessible que sur votre réseau local, donc un ordinateur portable "
                     'emporté ailleurs rattrape son retard à son retour.')],
           'install_h2': 'Installer le serveur',
           'install_intro': "Choisissez le système de l'ordinateur qui exécutera le serveur. Le script "
                            "trouve l'adresse LAN de l'ordinateur, configure le serveur pour qu'il démarre "
                            "automatiquement et imprime l'adresse à saisir dans les applications.",
           'os_label': "Système de l'ordinateur serveur",
           'manage_caption': 'Pour plus tard',
           'win': {'steps': ['Téléchargez <a '
                             'href="https://github.com/baiyuze/pasteferry/releases/latest/download/pasteferry-server-windows-amd64.zip">pasteferry-server-windows-amd64.zip</a> '
                             'et choisissez Extraire tout.',
                             'Ouvrez le dossier extrait et double-cliquez sur <code>install.cmd</code>.<span '
                             'class="aside">Si vous voyez «Windows a protégé votre PC », cliquez sur Plus '
                             "d'informations, puis sur Exécuter quand même ; lorsque le contrôle de compte "
                             "d'utilisateur vous le demande, cliquez sur Oui. Le serveur n'est pas encore "
                             "signé par code, c'est pourquoi Windows le demande une fois.</span>",
                             "L'installation continue dans une nouvelle fenêtre. L'adresse "
                             '<code>ws://…/signal</code> à la fin est celle que vous saisissez dans les '
                             'applications.'],
                   'download': 'Téléchargez le serveur Windows',
                   'notes': ['<strong>Fonctionne en tant que service Windows :</strong> commence par '
                             'Windows, aucune connexion requise, aucune fenêtre. Il apparaît sous le nom de '
                             'serveur PasteFerry dans Services.',
                             '<strong>Pare-feu déjà autorisé\xa0:</strong> le script ajoute une règle '
                             "entrante pour pastaferry-server.exe uniquement, il n'y a donc aucun port à "
                             'ouvrir.',
                             '<strong>Mauvaise adresse sélectionnée</strong> (plusieurs cartes réseau, par '
                             "exemple à partir d'une VM ou d'un VPN) : tapez <code>cmd</code> dans la barre "
                             "d'adresse du dossier extrait, appuyez sur Entrée et exécutez <code>install.cmd "
                             '192.168.1.20</code> avec votre adresse.',
                             'Windows 10 et 11, x64.'],
                   'double_click': 'Double-cliquez',
                   'explorer_label': 'Le dossier extrait contient Pasteferry-server.exe, install.cmd, '
                                     'install.ps1, README.md et uninstall.cmd\xa0; double-cliquez sur '
                                     'install.cmd',
                   'term_title': 'Administrateur\xa0: Windows PowerShell',
                   'term_label': "La fenêtre après la fin de install.cmd\xa0: elle arrête l'ancienne "
                                 "version, installe, enregistre le service, l'autorise à travers le pare-feu "
                                 "et le démarre, puis imprime l'adresse ws://192.168.1.20:8787/signal",
                   'manage': [('Statut',
                               '<code>Get-Service PasteFerryServer</code> dans un administrateur PowerShell, '
                               'ou recherchez le serveur PasteFerry dans les services'),
                              ('Journaux', '<code>C:\\ProgramData\\PasteFerry Server\\server.log</code>'),
                              ('Redémarrer',
                               '<code>Restart-Service PasteFerryServer</code> dans un administrateur '
                               'PowerShell'),
                              ('Mise à niveau',
                               'Téléchargez la nouvelle version, extrayez-la et double-cliquez à nouveau sur '
                               '<code>install.cmd</code> ; vos paramètres sont conservés'),
                              ('Désinstaller',
                               'Double-cliquez sur <code>uninstall.cmd</code>; il supprime le service, la '
                               'règle de pare-feu et les fichiers')]},
           'mac': {'steps': ['Ouvrez Terminal et exécutez ces lignes\xa0:',
                             "L'adresse <code>ws://…/signal</code> à la fin est celle que vous saisissez "
                             'dans les applications.'],
                   'notes': ["<strong>Aucun droit d’administrateur requis.</strong> Il s'exécute en "
                             "arrière-plan chaque fois que vous êtes connecté et macOS le redémarre s'il se "
                             'ferme.',
                             '<strong>Gardez ce Mac éveillé\xa0:</strong> dans Paramètres système → Énergie '
                             "(Batterie → Options sur un ordinateur portable), activez l'option qui empêche "
                             'la mise en veille automatique.',
                             '<strong>Si le pare-feu macOS est activé,</strong> le script se termine par la '
                             "commande permettant d'autoriser le serveur Pasteferry.",
                             'Silicium Intel et Apple, macOS 13 ou version ultérieure.'],
                   'term_label': 'Sortie de ./install.sh dans Terminal\xa0: il installe, écrit le '
                                 "LaunchAgent et démarre le serveur, puis imprime l'adresse "
                                 'ws://192.168.1.20:8787/signal',
                   'manage': [('Journaux', '<code>~/Library/Logs/PasteFerry/server.log</code>'),
                              ('Redémarrer',
                               '<code>launchctl kickstart -k gui/$(id -u)/com.pasteferry.server</code>'),
                              ('Mise à niveau',
                               'Téléchargez la nouvelle version, extrayez-la et exécutez à nouveau '
                               '<code>./install.sh</code> ; vos paramètres sont conservés'),
                              ('Désinstaller', '<code>./install.sh uninstall</code>')]},
           'linux': {'steps': ['Sur la machine elle-même, ou via ssh, exécutez ces lignes\xa0:<span '
                               'class="aside">Sur ARM, comme un Raspberry Pi avec un système d\'exploitation '
                               '64 bits, remplacez <code>amd64</code> par <code>arm64</code>.</span>',
                               "L'adresse <code>ws://…/signal</code> à la fin est celle que vous saisissez "
                               'dans les applications.'],
                     'notes': ['<strong>Enregistre un service systemd</strong> qui démarre au démarrage. A '
                               'besoin de racine.',
                               '<strong>Si ufw ou firewalld est actif,</strong> le script se termine par les '
                               "commandes d'ouverture des ports.",
                               '<strong>Docker fonctionne également\xa0:</strong> copie '
                               '<code>env.example</code> dans <code>.env</code>, définissez '
                               "<code>TURN_IP</code> sur l'adresse LAN de la machine et exécutez "
                               '<code>docker compose up -d</code>. Il nécessite un réseau hôte, donc Linux '
                               'uniquement.'],
                     'term_label': "Sortie de sudo ./install.sh\xa0: il installe, écrit l'unité systemd et "
                                   "la configuration et démarre le serveur, puis imprime l'adresse "
                                   'ws://192.168.1.20:8787/signal',
                     'manage': [('Statut', '<code>systemctl status pasteferry-server</code>'),
                                ('Journaux', '<code>journalctl -u pasteferry-server -f</code>'),
                                ('Redémarrer', '<code>sudo systemctl restart pasteferry-server</code>'),
                                ('Configuration',
                                 '<code>/etc/pasteferry/server.env</code>; redémarrer le service après '
                                 "l'édition"),
                                ('Mise à niveau',
                                 'Téléchargez la nouvelle version, extrayez-la et exécutez à nouveau '
                                 '<code>sudo ./install.sh</code> ; ta config est conservée'),
                                ('Désinstaller', '<code>sudo ./install.sh uninstall</code>')]},
           'check_h2': "Vérifiez que d'autres ordinateurs peuvent y accéder",
           'check_intro': 'Sur un autre ordinateur, ouvrez <code>http://192.168.1.20:8787/healthz</code> '
                          'dans un navigateur (avec votre adresse). Si vous voyez cette ligne, le chemin '
                          'réseau fonctionne.',
           'check_label': 'Un navigateur affichant http://192.168.1.20:8787/healthz, avec le statut du '
                          'serveur ok et sa version',
           'check_after': 'S\'il ne se charge pas, consultez les questions <a href="#faq"></a> ci-dessous.',
           'clients_h2': "Entrez l'adresse sur chaque ordinateur",
           'clients_steps': [('Ouvrir les paramètres',
                              'Ouvrez PasteFerry sur chaque ordinateur, y compris celui qui exécute le '
                              'serveur, et accédez à Paramètres → Connexion.'),
                             ("Entrez l'adresse",
                              'Sous Serveur personnalisé, saisissez '
                              '<code>ws://192.168.1.20:8787/signal</code> avec votre adresse et appuyez sur '
                              'Retour ou Entrée.'),
                             ("Vérifier l'état",
                              'Lorsque Connection affiche un vert Connecté, vous êtes prêt. Associez vos '
                              'appareils sous Appareils et la copie démarre la synchronisation.')],
           'clients_alt': 'Paramètres PasteFerry → Connexion\xa0: Le serveur personnalisé est '
                          "ws://192.168.1.20:8787/signal et l'état de la connexion indique Connecté",
           'clients_after': "Vous n'avez pas encore installé l'application ? Voir le démarrage rapide <a "
                            'href="{start}"></a>.',
           'faq_h2': 'Questions',
           'faq': [('Le statut reste à Non connecté',
                    ["Vérifiez d'abord l'adresse\xa0: elle commence par <code>ws://</code>, utilise le port "
                     "8787, se termine par <code>/signal</code>et vous avez appuyé sur Retour après l'avoir "
                     'saisie.',
                     'Ensuite, ouvrez <code>http://server-address:8787/healthz</code> dans un navigateur sur '
                     "cet ordinateur. S'il ne se charge pas, le chemin réseau est interrompu : le serveur ne "
                     'fonctionne pas, son ordinateur est en veille, un pare-feu le bloque ou son adresse a '
                     'changé.',
                     'Le script Windows autorise déjà le serveur à traverser le pare-feu. Sur un Mac avec le '
                     'pare-feu activé, exécutez la commande indiquée dans le script à la fin\xa0; il en va '
                     'de même pour ufw et firewalld sur Linux.']),
                   ('Les appareils affichent Relay au lieu de Direct',
                    ['Sur un réseau local, les connexions sont presque toujours directes. Le relais signifie '
                     "que UDP ne peut pas passer entre les deux ordinateurs, généralement en raison d'un "
                     "réseau invité, d'une isolation du client Wi-Fi ou de sous-réseaux séparés avec un "
                     "pare-feu entre les deux. Le contenu relayé est toujours crypté\xa0; c'est simplement "
                     "limité par le réseau de l'ordinateur serveur."]),
                   ("L'adresse du serveur a changé",
                    ['Exécutez à nouveau le script avec la nouvelle adresse\xa0: <code>install.cmd '
                     'new-address</code> sur Windows, <code>./install.sh new-address</code> sur un Mac. Sur '
                     'Linux, modifiez <code>-turn-ip</code> dans <code>/etc/pasteferry/server.env</code> et '
                     "redémarrez le service. Mettez ensuite à jour l'adresse sur chaque ordinateur.",
                     "Réserver l'adresse dans votre routeur évite cela."]),
                   ("Est-ce qu'il se synchronise loin du LAN ?",
                    ["Non, le serveur n'est accessible que sur votre réseau local. Pour synchroniser sur les "
                     'réseaux, activez le service <a href="{official}"></a>ou utilisez un serveur public <a '
                     'href="{cloud}"></a> ou <a href="{ts}">Tailscale</a>.']),
                   ("L'ordinateur serveur exécute également PasteFerry. Quelle adresse ?",
                    ['La même adresse LAN fonctionne, tout comme <code>ws://127.0.0.1:8787/signal</code>. Le '
                     "serveur et l'application n'interfèrent pas."])],
           'closing': 'Un ordinateur qui reste allumé suffit.',
           'source': 'Guide complet du serveur, y compris les serveurs publics et Docker'},
 'cloud': {'title': 'Exécutez le serveur PasteFerry sur un serveur public\xa0: guide des VM cloud',
           'description': 'Un script installe le serveur de signalisation et TURN de PasteFerry sur une VM '
                          "Linux avec une adresse IP publique. Chaque ordinateur s'y connecte directement, "
                          'de sorte que le presse-papiers se synchronise à la maison, au bureau et partout '
                          'ailleurs. Couvre le groupe de sécurité, la vérification, la configuration des '
                          'applications et les domaines en Chine continentale.',
           'h1': 'Exécutez-le sur un serveur public',
           'lede': "Une VM Linux avec une IP publique\xa0; le plus petit suffit. Chaque ordinateur s'y "
                   'connecte directement et se synchronise à la maison, au bureau ou ailleurs, sans rien de '
                   'plus à installer.',
           'toc': [('prepare', 'Avant de commencer'),
                   ('ports', 'Ports ouverts'),
                   ('install', 'Installer'),
                   ('check', 'Vérifier'),
                   ('clients', 'Configurer les applications'),
                   ('faq', 'Questions')],
           'step': 'Étape {n}',
           'overview_h2': "Chaque ordinateur s'y connecte",
           'overview_intro': 'Le serveur est sur Internet public, donc chaque ordinateur peut y accéder '
                             "depuis n'importe quel réseau sur lequel il se trouve. Ce que vous copiez va "
                             'directement entre les deux ordinateurs lorsque cela est possible\xa0; lorsque '
                             'cela échoue, il est relayé via le serveur, toujours crypté.',
           'diagram': {'title': 'PasteFerry avec un serveur public',
                       'desc': 'Le serveur public se trouve à 203.0.113.10. Un Mac sur un réseau de bureau '
                               "et un PC Windows sur un réseau domestique s'y connectent tous deux pour la "
                               'signalisation\xa0; le contenu copié passe directement entre eux et passe par '
                               "le relais du serveur en cas d'échec.",
                       'server': 'Serveur public',
                       'server_sub': 'VM cloud avec une adresse IP publique',
                       'office': 'Réseau de bureau',
                       'home': 'Réseau domestique',
                       'client': 'Exécution de PasteFerry',
                       'sig_note': 'Signalisation, TCP 8787',
                       'relay_note': "Relais sur UDP, en cas d'échec direct",
                       'direct': 'Direct'},
           'overview_points': ['Signalisation<strong>, TCP 8787.</strong> Chaque ordinateur y reste connecté '
                               "pour trouver les autres, s'associer et échanger les détails de connexion.",
                               '<strong>Direct.</strong> Les ordinateurs sur différents réseaux se '
                               'connectent directement via la perforation NAT, qui fonctionne sur la plupart '
                               'des réseaux domestiques et professionnels.',
                               "Relais<strong>, UDP 3478 et ports relais.</strong> Lorsqu'un chemin direct "
                               'échoue, le serveur transmet le trafic, toujours chiffré et limité par sa '
                               'bande passante.'],
           'prep': [('Une VM cloud',
                     'Linux sur x86_64 ou ARM64; la plus petite taille suffit, car le serveur utilise '
                     'environ 15 Mo de RAM. Vous avez besoin de root.'),
                    ('Une IP publique',
                     'La propre adresse IP publique de la VM fonctionne\xa0; un statique (élastique) est le '
                     'meilleur. Si cela change, chaque ordinateur doit être mis à jour.'),
                    ("Un moyen d'entrer", 'ssh, ou le terminal Web dans la console de votre fournisseur.'),
                    ('Machines virtuelles en Chine continentale',
                     "Sans dépôt ICP pour le domaine, entrez l'adresse IP dans les applications, pas le "
                     'domaine\xa0; voir les questions <a href="#faq"></a>.')],
           'ports_h2': 'Ouvrez les ports dans le groupe de sécurité',
           'ports_intro': 'Dans la console de votre fournisseur cloud, ajoutez ces trois règles entrantes au '
                          'groupe de sécurité de la VM.',
           'rules_url': 'Cloud\xa0Console\xa0>\xa0Groupe de sécurité\xa0>\xa0Règles entrantes',
           'rules_cols': ['Protocole', 'Plage de ports', 'Source', 'Objectif'],
           'rules': [('TCP', '8787', '0.0.0.0/0', 'Signalisation'),
                     ('UDP', '3478', '0.0.0.0/0', 'STUN et TOUR'),
                     ('UDP', '32768-60999', '0.0.0.0/0', 'Ports relais')],
           'rules_label': 'Règles entrantes dans un groupe de sécurité cloud (illustration) : TCP 8787 pour '
                          'la signalisation, UDP 3478 pour STUN et TURN, UDP 32768-60999 pour les ports '
                          'relais, toutes à partir de 0.0.0.0/0',
           'ports_notes': ["<strong>Différents noms :</strong> certains fournisseurs l'appellent un pare-feu "
                           "ou une ACL réseau ; c'est le même réglage.",
                           '<strong>Les ports relais</strong> sont attribués par le système '
                           "d'exploitation\xa0; la plage dépend du serveur. Exécutez <code>cat "
                           '/proc/sys/net/ipv4/ip_local_port_range</code> pour le voir\xa0; le script '
                           "d'installation l'imprime également.",
                           '<strong>Pare-feu système\xa0:</strong> si ufw ou firewalld est actif, ouvrez-y '
                           "les mêmes ports\xa0; le script d'installation imprime les commandes."],
           'install_h2': "Exécutez le script d'installation",
           'install_intro': "Donnez au script l'adresse IP publique. Il installe le serveur, enregistre un "
                            "service systemd qui démarre au démarrage et imprime l'adresse à saisir dans les "
                            'applications.',
           'install_steps': ['Connectez-vous avec ssh, par exemple <code>ssh root@203.0.113.10</code> avec '
                             'votre IP publique.',
                             'Exécutez ces lignes, avec votre IP publique sur la dernière :<span '
                             'class="aside">Sur ARM, remplacez <code>amd64</code> par '
                             '<code>arm64</code>.</span>',
                             "L'adresse <code>ws://203.0.113.10:8787/signal</code> à la fin est celle que "
                             'vous saisissez dans les applications.'],
           'install_notes': ['<strong>Enregistre un service systemd</strong> qui démarre au démarrage\xa0; '
                             'la configuration est <code>/etc/pasteferry/server.env</code>.',
                             'Mise à niveau<strong>:</strong> téléchargez la nouvelle version, extrayez-la '
                             'et exécutez à nouveau <code>sudo ./install.sh</code> ; votre config est '
                             'conservée.',
                             '<strong>Docker fonctionne également :</strong> consultez le guide de '
                             'déploiement du serveur <a href="{deploy}"></a>.'],
           'term_label': "Sortie de sudo ./install.sh 203.0.113.10\xa0: il installe, écrit l'unité systemd "
                         "et la configuration et démarre le serveur, puis imprime l'adresse "
                         'ws://203.0.113.10:8787/signal',
           'check_h2': "Vérifiez qu'il est accessible",
           'check_intro': 'Ouvrez <code>http://203.0.113.10:8787/healthz</code> (avec votre adresse IP '
                          "publique) dans un navigateur sur n'importe quel ordinateur. Si vous voyez cette "
                          'ligne, cela fonctionne.',
           'check_label': 'Un navigateur affichant http://203.0.113.10:8787/healthz, avec le statut du '
                          'serveur ok et sa version',
           'clients_steps': [('Ouvrir les paramètres',
                              'Ouvrez PasteFerry sur chaque ordinateur et accédez à Paramètres → Connexion.'),
                             ("Entrez l'adresse publique",
                              'Sous Serveur personnalisé, saisissez '
                              '<code>ws://203.0.113.10:8787/signal</code> avec votre adresse IP publique et '
                              'appuyez sur Retour ou Entrée.'),
                             ("Vérifier l'état",
                              "Lorsque Connection affiche un vert Connecté, vous êtes prêt. Si vous n'avez "
                              "pas encore effectué l'association, effectuez l'association sous Appareils.")],
           'clients_alt': 'Paramètres PasteFerry → Connexion\xa0: Le serveur personnalisé est '
                          "ws://203.0.113.10:8787/signal et l'état de la connexion indique Connecté",
           'faq': [('Cela fonctionne par IP mais pas par domaine',
                    ['Les fournisseurs de cloud en Chine continentale interceptent les requêtes simples HTTP '
                     'pour des domaines sans dépôt ICP et répondent par une redirection vers une page de '
                     'blocage ; dans nos tests qui incluaient des ports non standard tels que 8787. La '
                     'poignée de main WebSocket est également une requête HTTP , elle est donc interceptée '
                     "et l'application affiche Non connecté.",
                     "Saisissez plutôt l'adresse IP du serveur, comme dans "
                     '<code>ws://server-ip:8787/signal</code>, ou enregistrez le domaine.']),
                   ('De quelle taille de serveur ai-je besoin ?',
                    ['Le plus petit. Le serveur utilise environ 15 Mo de RAM et ne transmet normalement que '
                     'quelques messages de signalisation. Le contenu passe directement entre les ordinateurs '
                     'lorsque cela est possible\xa0; seuls les transferts relayés sont limités par la bande '
                     'passante du serveur.']),
                   ('Les appareils affichent Relay au lieu de Direct',
                    ["Relayer juste après la connexion, puis Direct un peu plus tard, c'est normal : le "
                     'relais vous lance et le chemin direct prend le relais au repos. Rester sur Relay '
                     'signifie que les deux ordinateurs ne peuvent pas se joindre directement, généralement '
                     "à cause d'un NAT qui randomise les ports ou d'un pare-feu strict. C'est toujours "
                     'crypté, juste limité par la bande passante du serveur.']),
                   ('Puis-je utiliser HTTPS (wss://)\xa0?',
                    ['Oui, derrière un proxy inverse HTTPS prenant en charge les mises à niveau WebSocket ; '
                     'saisissez une adresse commençant par <code>wss://</code>. Les domaines en Chine '
                     'continentale nécessitent un dépôt ICP. STUN et TURN utilisent UDP et contournent le '
                     'proxy, alors gardez ces ports ouverts.']),
                   ('Ma connexion domestique a une IP publique. Puis-je utiliser ça ?',
                    ["Oui, mais c'est plus de travail qu'une VM\xa0: transférez TCP 8787, UDP 3478 et une "
                     'large gamme de ports relais UDP vers cet ordinateur, et une adresse IP domestique peut '
                     "changer. Si tous vos ordinateurs sont à la maison, ils n'ont besoin d'aucun serveur "
                     'sur le même réseau <a href="{lan}"></a>; pour synchroniser sur les réseaux sans '
                     'redirection de port, voir <a href="{ts}">Tailscale</a>.'])],
           'closing': "Une VM cloud,<br>, synchronisée depuis n'importe où.",
           'source': 'Guide complet du serveur, comprenant Docker et toutes les options'},
 'start': {'title': 'Démarrage rapide\xa0: configurez PasteFerry en trois étapes',
           'description': "Nouveau sur PasteFerry? Installez l'application sur chaque ordinateur. Sur le "
                          'même réseau, associez-le simplement\xa0; sur différents réseaux, activez le '
                          "service. Copiez ensuite sur un ordinateur et collez sur l'autre.",
           'h1': 'Démarrage rapide',
           'lede': 'Installez l’application, connectez les appareils et associez-les par code.',
           'toc': [('app', "Installez l'application"),
                   ('server', 'Choisissez un moyen de vous connecter'),
                   ('pair', 'Paire'),
                   ('phone', 'Utiliser un téléphone')],
           'step': 'Étape {n}',
           'app_h2': "Installez l'application sur chaque ordinateur",
           'app_intro': 'Un sur chaque ordinateur que vous souhaitez synchroniser. Mac, Windows et Linux se '
                        'mélangent librement.',
           'mac': ['Téléchargez le DMG, ouvrez-le et faites glisser PasteFerry dans Applications.<span '
                   'class="aside">Il y en a un pour le silicium Apple et un pour Intel ; la page de '
                   'téléchargement vous aide à choisir.</span>',
                   'Ouvrez-le depuis Applications.<span class="aside">La première fois, macOS indique qu\'il '
                   'ne peut pas vérifier le développeur\xa0: accédez à Paramètres système → Confidentialité '
                   'et sécurité et cliquez sur Ouvrir quand même en bas.</span>',
                   'Cliquez sur Activer la synchronisation en arrière-plan. Lorsque macOS vous demande '
                   'comment accéder au presse-papiers et rechercher des appareils sur votre réseau local, '
                   'autorisez les deux.'],
           'win': ["Exécutez PasteFerry-Setup.exe\xa0; aucun droit d'administrateur n'est nécessaire.<span "
                   'class="aside">Si vous voyez «Windows a protégé votre PC », cliquez sur Plus '
                   "d'informations, puis sur Exécuter quand même.</span>",
                   'Ouvrez PasteFerry et cliquez sur Activer la synchronisation en arrière-plan. '
                   'Autorisez-le si le pare-feu Windows le demande. Après avoir fermé la fenêtre, elle '
                   "continue de s'exécuter dans la zone de notification."],
           'linux': ["Sur Ubuntu, Debian et similaires, installez le .deb\xa0; sur d'autres distributions, "
                     "extrayez le tar.gz et exécutez le <code>install.sh</code> à l'intérieur.",
                     "Ouvrez PasteFerry dans le menu de l'application et cliquez sur Activer la "
                     'synchronisation en arrière-plan.'],
           'app_alt': "PasteFerry à la première ouverture, vous demandant d'activer la synchronisation en "
                      'arrière-plan',
           'server_h2': 'Choisissez un moyen de vous connecter',
           'server_intro': 'Connectez en local ou choisissez le Service, votre serveur ou Tailscale à distance.',
           'pair_h2': 'Associez vos ordinateurs',
           'pair_intro': "Associez deux ordinateurs une fois, et c'est tout.",
           'pair_steps': ['Sur un ordinateur, ouvrez Appareils et cliquez sur Ajouter un appareil. Il '
                          "affiche un code à 6 caractères, valable 5 minutes, et l'adresse de cet ordinateur "
                          'en dessous.',
                          "Sur l'autre ordinateur, choisissez Ajouter un appareil → Entrez un code. Avec "
                          "Service, il n'y a pas d'adresse IP à saisir\xa0; ce n'est que sur les "
                          "sous-réseaux ou avec Tailscale que vous ouvrez le champ d'adresse et saisissez "
                          "l'adresse de l'autre ordinateur.",
                          'Les deux écrans affichent les deux mêmes lignes d’empreintes digitales. '
                          'Vérifiez-les caractère par caractère, puis confirmez.<span class="aside">Cela '
                          'empêche toute personne intermédiaire de se faire passer pour votre appareil. Ne '
                          'le sautez pas.</span>'],
           'pair_alt': "Ajouter un appareil\xa0: le code d'appairage K7MP2X, avec l'adresse de cet "
                       'ordinateur 192.168.1.20 en dessous',
           'done_h2': 'Maintenant, copiez quelque chose.',
           'done_text': 'Copiez du texte, une image ou un fichier sur un ordinateur et appuyez sur ⌘V or '
                        "Ctrl+V on the other. Tout ce qui est copié de part et d'autre est dans "
                        "l'historique.",
           'help': 'Besoin d\'aide ? <a href="{lan}#faq">Mêmes questions sur le réseau</a> · <a '
                   'href="{ts}#faq">Questions sur Tailscale</a> · <a href="{cloud}#faq">Questions sur le '
                   'serveur public</a> · <a href="{issues}">Signaler un problème</a>',
           'phone_h2': 'Utiliser un téléphone',
           'phone_intro': 'Une fois les ordinateurs couplés ci-dessus, un téléphone peut se connecter à tout '
                          "moment : scannez un code pour la page Web ou installez l'application Android .",
           'phone_toc': 'Utiliser un téléphone',
           'web_h': 'La page web : rien à installer',
           'web_steps': ['Ordinateur\xa0: ouvrez Appareils > Transfert Web du téléphone, allumez '
                         "l'interrupteur et un code apparaît.",
                         "Téléphone\xa0: scannez le code avec l'appareil photo ou un navigateur et donnez un "
                         'nom au téléphone.',
                         "Le navigateur du téléphone affiche ensuite les enregistrements de l'ordinateur\xa0"
                         ': appuyez sur Copier pour envoyer un texte sur le téléphone ou utilisez Envoyer '
                         "pour envoyer du texte, des photos et des fichiers vers l'ordinateur."],
           'apk_h': "L'application Android : s'associe comme un autre ordinateur",
           'apk_steps': ['Téléphone : <a href="{android}">téléchargez l\'APK</a> et installez-le (autorisez '
                         "l'installation à partir de sources inconnues lorsque cela vous est demandé).",
                         'Ordinateur\xa0: Appareils → Ajouter un appareil → Afficher un code.',
                         'Téléphone : saisissez le code et confirmez lorsque les deux empreintes '
                         'correspondent.',
                         'Ce que vous copiez sur l’ordinateur apparaît ensuite dans les enregistrements et '
                         'le presse-papiers du téléphone.']},
 'lan': {'title': 'Utilisez PasteFerry sur un seul réseau\xa0: pas de serveur, associez-le simplement',
         'description': "Lorsque vos ordinateurs partagent un réseau Wi‑Fi ou filaire, le PasteFerry n'a "
                        "besoin d'aucun serveur\xa0: installez l'application, saisissez un code d'appairage "
                        'à 6\xa0caractères et synchronisez le presse-papiers et les fichiers entre Mac et '
                        'Windows. Sur un sous-réseau différent, vous entrez une adresse lors du couplage.',
         'h1': 'Sur le même réseau',
         'lede': "Les ordinateurs derrière le même routeur n'ont pas besoin de serveur. Installez "
                 "l'application, entrez un code de couplage et copiez les synchronisations à partir de là.",
         'toc': [('prepare', 'Avant de commencer'),
                 ('pair', 'Paire'),
                 ('subnet', 'Différents sous-réseaux'),
                 ('faq', 'Questions')],
         'step': 'Étape {n}',
         'overview_h2': 'Pas de serveur',
         'overview_intro': 'Deux ordinateurs sur le même réseau se trouvent via mDNS, échangent directement '
                           'les détails de connexion et ouvrent une connexion directe cryptée. Pas de '
                           "serveur et pas d'ordinateur qui doit rester allumé.",
         'diagram': {'title': 'PasteFerry sur un réseau',
                     'desc': 'Sur un réseau local, un Mac (192.168.1.20) et un PC Windows (192.168.1.35) se '
                             'retrouvent via mDNS et échangent les détails de connexion via UDP 8788. Le '
                             "contenu copié passe directement entre eux ; il n'y a pas de serveur.",
                     'lan': 'LAN\xa0: le même réseau Wi‑Fi ou filaire',
                     'client': 'Exécution de PasteFerry',
                     'find_note': 'Trouvé via mDNS, détails de connexion via UDP 8788',
                     'direct': 'Chiffrement direct de bout en bout',
                     'direct_note': 'Le contenu reste entre les deux ordinateurs'},
         'overview_points': ["<strong>Trouvé automatiquement.</strong> Chaque ordinateur s'annonce sur le "
                             'réseau local via mDNS, avec seulement un jeton anonyme qui change '
                             "quotidiennement, afin que personne ne puisse savoir de qui il s'agit. Son nom "
                             'est ajouté uniquement lorsque la recherche à proximité est ouverte.',
                             '<strong>Direct.</strong> Le contenu circule directement entre les deux '
                             'ordinateurs, à la vitesse de votre réseau.',
                             "<strong>Même sécurité.</strong> Vous comparez deux lignes d'empreintes "
                             'digitales lors du couplage, et chaque message ultérieur est signé, de sorte '
                             'que les autres utilisateurs du réseau ne peuvent pas se faire passer pour '
                             'votre appareil.'],
         'prep': [('Le même réseau',
                   'Les deux ordinateurs derrière le même routeur\xa0; Wi‑Fi et filaire peuvent se mélanger. '
                   'Les réseaux invités et le Wi-Fi avec isolation client séparent les appareils, et dans de '
                   'nombreux bureaux, le filaire et le Wi-Fi constituent des sous-réseaux distincts\xa0: '
                   'voir <a href="#subnet">différents sous-réseaux</a> ci-dessous.'),
                  ('Pare-feu Windows',
                   'Lors de la première exécution, Windows demande si PasteFerry peut passer à travers le '
                   'pare-feu\xa0; permettez-le. Si vous avez cliqué sur Annuler, cliquez sur Autoriser sous '
                   "Paramètres → Connexion dans PasteFerry, qui demande une fois l'approbation de "
                   "l'administrateur."),
                  ('Réseau local sur macOS',
                   "À partir de macOS 15, la première fois qu'il atteint un appareil sur votre réseau, macOS "
                   'demande si le démon PasteFerry peut trouver des appareils sur votre réseau local\xa0; '
                   'permettez-le. Si vous avez refusé, activez-le dans Paramètres système → Confidentialité '
                   'et sécurité → Réseau local.'),
                  ('Aucune adresse de serveur',
                   'Laissez le champ du serveur dans Paramètres → Connexion vide. Pour synchroniser '
                   'ultérieurement sur les réseaux, activez le service\xa0; les appareils couplés restent '
                   'couplés.')],
         'pair_h2': 'Associez vos ordinateurs',
         'pair_intro': "Associez deux ordinateurs une fois. Si l'application n'est pas encore installée, "
                       'consultez le démarrage rapide <a href="{start}#app"></a>.',
         'pair_steps': ['Sur un ordinateur, ouvrez Appareils et cliquez sur Ajouter un appareil. Il affiche '
                        'un code à 6 caractères, valable 5 minutes.',
                        "De l'autre, cliquez également sur Ajouter un appareil, passez à Entrer un code, "
                        'saisissez-le et cliquez sur Continuer.',
                        'Les deux écrans affichent les deux mêmes lignes d’empreintes digitales. '
                        'Vérifiez-les caractère par caractère, puis confirmez. La copie est désormais '
                        'synchronisée.'],
         'pair_alt': "Ajouter un appareil\xa0: le code d'appairage K7MP2X, avec l'adresse de cet ordinateur "
                     '192.168.1.20 en dessous',
         'nearby_h3': 'Sans code\xa0: recherchez à proximité',
         'nearby_steps': ['Sur les deux ordinateurs, ouvrez Appareils et cliquez sur Rechercher à proximité. '
                          "Ce n'est que lorsque cette fenêtre est ouverte que les appareils du réseau "
                          'peuvent voir le nom de cet ordinateur.',
                          "Lorsque l'autre apparaît sur le radar, cliquez dessus. Les deux écrans affichent "
                          'les deux mêmes lignes d’empreintes digitales\xa0; vérifiez-les, puis confirmez '
                          'sur chacun.',
                          "Cela fonctionne dans un seul sous-réseau. Si l'autre ordinateur n'apparaît pas, "
                          'utilisez un code de couplage comme ci-dessus.'],
         'nearby_alt': 'Appareils à proximité\xa0: cet ordinateur au milieu, avec Design PC et Meeting room '
                       'iMac autour, plus le MacBook Air déjà couplé',
         'subnet_h2': 'Différents sous-réseaux',
         'subnet_intro': "La découverte locale n'atteint qu'un seul sous-réseau. Lorsque vos ordinateurs se "
                         'trouvent sur différents sous-réseaux qui peuvent toujours se joindre, comme dans '
                         'de nombreux bureaux, vous saisissez une seule adresse lors du couplage.',
         'subnet_steps': ["L'ordinateur affichant le code indique son adresse en dessous, par exemple "
                          '<code>192.168.1.20</code>.',
                          "Sur l'ordinateur qui saisit le code, cliquez sur Sur un autre sous-réseau ?, "
                          'saisissez cette adresse et cliquez sur Continuer.',
                          "Après le couplage, chaque ordinateur mémorise l'adresse de l'autre. Si l’un "
                          'change d’adresse, l’autre la retrouve tout seul ; si les deux changent, ouvrez le '
                          "menu… de l'appareil sous Appareils et choisissez Entrer son adresse."],
         'subnet_alt': "Entrez un code : le code K7MP2X, avec le champ d'adresse ouvert en dessous contenant "
                       '192.168.1.20',
         'subnet_after': "Si les sous-réseaux ne peuvent pas du tout se joindre, comme dans le cas d'un "
                         'réseau invité séparé du réseau du bureau, le trafic doit passer par un ordinateur '
                         'que les deux peuvent atteindre\xa0: voir <a href="{server}">exécuter un serveur '
                         'sur votre réseau local</a>.',
         'faq': [("L'autre ordinateur est introuvable",
                  ['Assurez-vous que les deux sont sur le réseau avec la synchronisation en arrière-plan '
                   "activée. Essayez ensuite de saisir l'adresse de l'autre ordinateur sur celui qui saisit "
                   'le code : si cela fonctionne, ils sont sur des sous-réseaux différents, ou le réseau '
                   'bloque mDNS.',
                   "Toujours rien ? Vérifiez le pare-feu de l'autre ordinateur. Sur Windows, cliquez sur "
                   'Autoriser sous Paramètres → Connexion\xa0; sur un Mac, assurez-vous que le démon '
                   'PasteFerry est activé sous Paramètres système → Confidentialité et sécurité → Réseau '
                   'local et que le pare-feu macOS ne le bloque pas.']),
                 ("Est-ce qu'il se synchronise loin de ce réseau ?",
                  ['Non, ça reprend à votre retour. Pour synchroniser sur les réseaux, activez le service <a '
                   'href="{official}"></a>ou utilisez un serveur public <a href="{cloud}"></a> ou <a '
                   'href="{ts}">Tailscale</a>; les appareils couplés restent couplés.']),
                 ('Et si une adresse change ?',
                  ["Généralement rien à faire. Sur un sous-réseau, mDNS retrouve l'ordinateur à tout "
                   "moment\xa0; à travers les sous-réseaux, il se reconnecte tant que l'un des deux conserve "
                   "son adresse. Si les deux changent, saisissez à nouveau l'adresse sous Appareils.",
                   'Pour un bureau qui ne bouge jamais, vous pouvez réserver son adresse dans les paramètres '
                   'DHCP de votre routeur.']),
                 ('Les autres utilisateurs du réseau peuvent-ils voir mon ordinateur\xa0?',
                  ["Ils peuvent voir qu'un appareil PasteFerry est là, mais pas de qui : la diffusion porte "
                   "un jeton anonyme qui change quotidiennement, sans nom ni identifiant d'appareil. Le nom "
                   'est ajouté uniquement lorsque la recherche à proximité est ouverte et supprimé lorsque '
                   "vous la fermez. Les messages provenant d'appareils avec lesquels vous n'avez pas été "
                   'couplés sont supprimés et le couplage nécessite de comparer les empreintes digitales sur '
                   'les deux écrans.']),
                 ('Quels ports utilise-t-il ?',
                  ['UDP 8788 pour les détails de connexion (un port aléatoire si celui-ci est pris), UDP '
                   '5353 pour mDNS et un autre port aléatoire UDP pour les données une fois connectées. Rien '
                   'à configurer sur votre routeur.'])],
         'closing': 'Un réseau,<br>rien à mettre en place.',
         'source': 'Notes de conception sur le mode réseau local (en chinois)'},
 'ts': {'title': 'Utilisez PasteFerry sur les réseaux avec Tailscale: aucun serveur, maison et bureau '
                 'synchronisés',
        'description': "Installez Tailscale sur chaque ordinateur sous un compte et entrez l'adresse "
                       "Tailscale de l'autre ordinateur lors du couplage\xa0: pas d'adresse IP publique, pas "
                       "de serveur et pas d'ordinateur qui doit rester allumé. Le presse-papiers se "
                       "synchronise depuis le bureau ou n'importe où ailleurs.",
        'h1': 'Sur les réseaux avec Tailscale',
        'lede': "Vous n'avez pas d'adresse IP publique et vous ne souhaitez pas gérer de serveur\xa0? "
                "Installez Tailscale sur chaque ordinateur et entrez l'adresse Tailscale de l'autre "
                'ordinateur lors du couplage. Synchronisation à la maison et au bureau.',
        'toc': [('join', 'Installer Tailscale'),
                ('address', "Trouver l'adresse"),
                ('pair', 'Paire'),
                ('faq', 'Questions')],
        'step': 'Étape {n}',
        'overview_h2': 'Comme sur un seul LAN',
        'overview_intro': 'Tailscale connecte vos appareils à un réseau privé : chaque appareil connecté au '
                          'même compte obtient une adresse fixe commençant par 100, accessible depuis les '
                          "autres où qu'ils se trouvent. PasteFerry mémorise l'adresse de l'autre ordinateur "
                          'lors du couplage et se connecte comme si les deux étaient sur le même réseau.',
        'diagram': {'title': 'PasteFerry sur Tailscale',
                    'desc': 'Un Mac au bureau et un PC Windows à la maison exécutent tous deux Tailscale et '
                            'chacun possède une adresse commençant par 100 sur le même réseau privé. Le '
                            "contenu copié va directement entre eux\xa0; il n'y a pas de serveur.",
                    'net': 'Réseau Tailscale : chaque appareil possède une adresse 100.x',
                    'mac_place': 'Au bureau',
                    'win_place': 'À la maison',
                    'direct': 'Direct, crypté deux fois',
                    'direct_note': 'Le contenu reste entre les deux ordinateurs'},
        'overview_points': ['<strong>Aucun serveur,</strong> et aucun ordinateur devant rester allumé\xa0: '
                            'deux ordinateurs allumés et connectés à la synchronisation Tailscale .',
                            "<strong>Entrez l'adresse une fois.</strong> Une adresse Tailscale ne change "
                            "pas\xa0; vous le saisissez lors de l'appairage et les deux ordinateurs se "
                            'retrouvent désormais.',
                            "<strong>Chiffré deux fois.</strong> À l'intérieur du tunnel WireGuard de "
                            "Tailscale s'exécute la propre connexion cryptée de bout en bout de PasteFerry. "
                            'Tailscale ne peut pas voir le contenu.'],
        'prep': [('Un compte Tailscale',
                  'Gratuit pour un usage personnel\xa0; connectez-vous avec Google, Microsoft, GitHub ou '
                  'Apple. Utilisez le même compte sur chaque appareil.'),
                 ('Tailscale sur chaque ordinateur',
                  'Il existe des clients pour Windows, macOS et Linux. Chaque ordinateur qui exécute '
                  'PasteFerry en a besoin, connecté.'),
                 ('PasteFerry installé',
                  "L'application sur chaque ordinateur avec synchronisation en arrière-plan activée\xa0; "
                  'voir le démarrage rapide <a href="{start}#app"></a>. Laissez l\'adresse du serveur vide.'),
                 ('ZeroTier fonctionne aussi',
                  'Il en va de même pour tout outil qui donne à chaque appareil une adresse virtuelle '
                  'fixe\xa0: saisissez cette adresse lors du couplage. Ce guide utilise Tailscale.')],
        'join_h2': 'Installez Tailscale sur chaque ordinateur',
        'join_intro': 'Sur chaque ordinateur que vous synchronisez, installez-le et connectez-vous au même '
                      'compte.',
        'join_steps': ['Téléchargez le client pour votre système à partir du site Web Tailscale et '
                       'installez-le.<span class="aside">Sur Linux, exécutez <code>curl -fsSL '
                       'https://tailscale.com/install.sh | sh</code>, puis <code>sudo tailscale up</code>et '
                       "ouvrez le lien qu'il imprime pour vous connecter.</span>",
                       'Ouvrez Tailscale et connectez-vous en utilisant le même compte sur chaque '
                       'ordinateur.',
                       "La console d'administration Tailscale répertorie ensuite tous vos appareils, chacun "
                       'avec une adresse commençant par 100.'],
        'join_download': 'Télécharger Tailscale',
        'machines_cols': ['Machine', 'Adresse Tailscale', "Système d'exploitation"],
        'machines_label': "Liste des machines de la console d'administration Tailscale (illustration) : "
                          'macbook-pro est 100.88.20.5 et home-pc est 100.92.41.17',
        'join_notes_h3': 'Gardez Tailscale connecté',
        'join_notes': ["<strong>Windows:</strong> cliquez avec le bouton droit sur l'icône Tailscale dans la "
                       'zone de notification et cochez Exécuter sans surveillance sous Préférences, afin '
                       "qu'il reste connecté après votre déconnexion.",
                       "<strong>Mac\xa0:</strong> assurez-vous que Tailscale s'ouvre lors de la connexion.",
                       "<strong>Désactiver l'expiration de la clé\xa0:</strong> par défaut, Tailscale "
                       'demande aux appareils de se reconnecter tous les 180 jours. Pour un ordinateur qui '
                       'change rarement, ouvrez le menu à la fin de sa ligne sur la page Machines et '
                       "choisissez Désactiver l'expiration des clés."],
        'address_h2': "Rechercher l'adresse Tailscale de l'autre ordinateur",
        'address_intro': "Sur l'ordinateur avec lequel vous allez vous associer, cliquez sur l'icône "
                         'Tailscale (dans la barre de menu sur un Mac, dans la zone de notification sur '
                         'Windows) pour voir son adresse, ou exécutez <code>tailscale ip -4</code> dans un '
                         'terminal.',
        'address_label': 'L’exécution de tailscale ip -4 dans PowerShell imprime l’adresse Tailscale de '
                         'l’ordinateur, 100.92.41.17',
        'address_after': 'Les étapes ci-dessous utilisent <code>100.92.41.17</code>, le PC Windows à la '
                         'maison. Utilisez votre propre adresse.',
        'pair_h2': "Entrez l'adresse lors de l'appairage",
        'pair_intro': 'Tout comme le couplage sur un seul réseau, avec une adresse supplémentaire.',
        'pair_steps': ['Sur le PC Windows à la maison, ouvrez Appareils, cliquez sur Ajouter un appareil et '
                       'notez le code à 6 caractères.',
                       'Sur le Mac au bureau, cliquez sur Ajouter un appareil, passez à Saisir un code et '
                       'saisissez-le\xa0; puis cliquez sur Sur un autre sous-réseau ?, saisissez '
                       '<code>100.92.41.17</code> et cliquez sur Continuer.',
                       'Les deux écrans affichent les deux mêmes lignes d’empreintes digitales. '
                       'Vérifiez-les, puis confirmez. Les deux ordinateurs se synchronisent désormais où '
                       "qu'ils se trouvent."],
        'pair_alt': "Saisissez un code : le code K7MP2X, avec l'adresse Tailscale 100.92.41.17 dans le champ "
                    'adresse',
        'pair_after': "Lorsque les deux ordinateurs sont à la maison, PasteFerry trouve également l'autre "
                      'directement sur le réseau local, afin que les données ne fassent aucun détour.',
        'faq': [("Les appareils affichent Direct, mais c'est lent",
                 ['Direct dans PasteFerry signifie que les deux ordinateurs se connectent directement sur le '
                  'réseau Tailscale . Lorsque Tailscale ne peut pas les connecter peer to peer, il effectue '
                  'le relais via ses serveurs DERP, qui peuvent être éloignés.',
                  'Exécutez <code>tailscale ping other-address</code> dans un terminal\xa0: via DERP '
                  "signifie que Tailscale assure le relais\xa0; via une IP et un port signifie que c'est "
                  'peer to peer. Les réseaux de bureaux et de campus se relayent plus souvent\xa0; vous '
                  'pouvez exécuter votre propre serveur DERP ou essayer un autre VPN maillé.']),
                ("Le couplage ne parvient pas à trouver l'autre ordinateur",
                 ["Assurez-vous d'abord que Tailscale est connecté sur les deux\xa0: exécutez "
                  "<code>tailscale ping other-address</code> et réessayez une fois qu'il répond.",
                  "Si le ping fonctionne mais pas le couplage, le pare-feu de l'autre ordinateur le bloque "
                  'probablement. Sur Windows, cliquez sur Autoriser sous Paramètres → Connexion dans '
                  'PasteFerry; sur un Mac, activez le démon PasteFerry sous Paramètres système → '
                  'Confidentialité et sécurité → Réseau local.']),
                ('Est-ce que chaque ordinateur a besoin de Tailscale?',
                 ['Oui, un ordinateur sans celui-ci ne peut pas atteindre les adresses 100.x. Les '
                  'ordinateurs sur le même réseau n’en ont pas besoin ; voir le même guide réseau <a '
                  'href="{lan}"></a>.']),
                ("J'ai installé un serveur chez moi avec l'ancien guide. En ai-je encore besoin ?",
                 ['Non. Effacez l’adresse du serveur dans Paramètres → Connexion sur chaque ordinateur et '
                  'désinstallez le serveur chez vous ; les appareils couplés restent couplés. Le garder ne '
                  'fait pas de mal non plus : un serveur et Tailscale fonctionnent ensemble.']),
                ('Tailscale peut-il voir ce que je copie\xa0?',
                 ["Les connexions Tailscale sont cryptées de bout en bout avec WireGuard, et à l'intérieur "
                  "s'exécute la propre connexion cryptée DTLS de PasteFerry; seuls vos deux ordinateurs "
                  "peuvent ouvrir l'une ou l'autre couche.  Les serveurs de Tailscale échangent uniquement "
                  'les clés et adresses des appareils, et ses relais transmettent les paquets cryptés.']),
                ('Une adresse Tailscale changera-t-elle\xa0?',
                 ["Généralement non. L'adresse appartient à l'appareil et survit aux redémarrages et aux "
                  'modifications du réseau\xa0; cela ne change que si vous supprimez le périphérique de '
                  "Tailscale et que vous l'ajoutez à nouveau. Si tel est le cas, saisissez-le à nouveau sous "
                  'Appareils.']),
                ("J'ai un serveur public. Ai-je besoin de Tailscale?",
                 ["Non. Exécutez le serveur sur la machine avec l'adresse IP publique et entrez cette "
                  'adresse sur chaque ordinateur\xa0; consultez le guide du serveur public <a '
                  'href="{cloud}"></a>.'])],
        'closing': 'Pas de serveur.<br>Votre presse-papiers vous accompagne.',
        'source': 'Retour au même guide réseau'},
 'download': {'phone': {'title': 'Téléphone (application Android ou page Web)',
                        'apk': 'Télécharger pour Android (APK)',
                        'apk_note': 'Android 9 ou ultérieur · ARM64',
                        'web_h': 'La page web (rien à installer)',
                        'web_note': "Allumez Appareils › Transfert Web par téléphone sur l'ordinateur et "
                                    'scannez le code avec votre téléphone.',
                        'steps': ["Après avoir installé l'application, associez le téléphone à partir des "
                                  "appareils sur l'ordinateur, de la même manière que vous associez un autre "
                                  'ordinateur.',
                                  'Ou utilisez la page Web\xa0: activez Appareils > Transfert Web par '
                                  "téléphone sur l'ordinateur et scannez le code.",
                                  'Sur le téléphone, collez ce que vous avez copié et envoyez-le ; ce que '
                                  'vous copiez sur l’ordinateur apparaît dans les enregistrements du '
                                  'téléphone.'],
                        'notes': ['Le téléphone et l’ordinateur doivent être sur le même réseau.',
                                  'Sur iPhone et iPad, utilisez la version web.'],
                        'tab': 'Téléphone / web'},
              'title': 'Télécharger PasteFerry: Mac (Apple Silicon, Intel), Windows et Linux',
              'description': 'PasteFerry pour chaque système\xa0: versions Apple Silicon et Intel pour macOS '
                             "13 ou version ultérieure, un programme d'installation et un zip portable pour "
                             'Windows 10 et 11, ainsi que des packages .deb et tar.gz pour Linux sur x64 et '
                             'ARM64. Gratuit et open source.',
              'h1': 'Télécharger PasteFerry',
              'lede': 'Gratuit et open source · Version {version}',
              'os_label': 'Choisissez votre système',
              'win': {'setup': "Téléchargez le programme d'installation",
                      'portable': '<a href="{portable}">Version portable</a>, sans installation',
                      'steps': ["Exécutez PasteFerry-Setup.exe. Il s'installe pour l'utilisateur actuel, "
                                'aucun droit d\'administrateur n\'est requis.<span class="aside">Si vous '
                                "voyez «Windows a protégé votre PC », cliquez sur Plus d'informations, puis "
                                'sur Exécuter quand même.</span>',
                                'Ouvrez PasteFerry et cliquez sur Activer la synchronisation en '
                                'arrière-plan. Autorisez-le si le pare-feu Windows le demande.'],
                      'notes': ['Windows 10 et Windows 11, x64.',
                                "Le programme d'installation fait environ 23 Mo, le zip portable environ 29 "
                                'Mo.',
                                "Après avoir fermé la fenêtre, PasteFerry continue de s'exécuter dans la "
                                'zone de notification.']},
              'mac': {'apple': 'Puces Apple (M1+)',
                      'intel': 'Intel',
                      'universal': 'Une <a href="{universal}">version universelle</a> est aussi disponible.',
                      'homebrew': (('Homebrew : <code>brew install --cask baiyuze/tap/pasteferry</code>. <a href="{homebrew}">Installation et '
                                    'mise à jour</a>')),
                      'steps': ['Ouvrez le DMG que vous avez téléchargé et faites glisser PasteFerry dans '
                                'Applications.',
                                'Ouvrez-le depuis Applications.<span class="aside">La première fois, macOS '
                                "indique qu'il ne peut pas vérifier le développeur\xa0: accédez à Paramètres "
                                'système → Confidentialité et sécurité et cliquez sur Ouvrir quand même en '
                                'bas.</span>',
                                'Cliquez sur Activer la synchronisation en arrière-plan. Lorsque macOS vous '
                                'demande comment accéder au presse-papiers et rechercher des appareils sur '
                                'votre réseau local, autorisez les deux.'],
                      'chip_h': 'Vous ne savez pas quelle puce ?',
                      'chip': ["Cliquez sur le menu Pomme dans le coin supérieur gauche de l'écran et "
                               'choisissez À propos de ce Mac.',
                               '« Puce : Apple M1 » (ou M2, M3, M4…) désigne le silicium Apple ; « '
                               'Processeur : … Intel Core … » signifie Intel.',
                               'Presque tous les Mac achetés depuis fin 2020 sont équipés de silicium Apple. '
                               "Si vous choisissez la mauvaise, téléchargez simplement l'autre\xa0: sur un "
                               'Mac Apple Silicon, la version Intel nécessite que Rosetta soit installée en '
                               "premier, et la version Apple Silicon ne s'ouvrira pas sur un Mac Intel.",
                               'Nécessite macOS 13 Ventura ou version ultérieure.']},
              'linux': {'deb_h': 'Ubuntu, Debian et dérivés',
                        'tar_h': 'Autres distributions',
                        'x64': 'x64',
                        'arm64': 'ARM64',
                        'notes': ['Nécessite GTK 3 et un bureau X11 ou Wayland avec XWayland.',
                                  'Exécutez <code>uname -m</code> : <code>x86_64</code> = x64 ; <code>aarch64</code> = ARM64.']},
              'more_h2': 'Plus',
              'more': [('Serveur',
                        "Deux ordinateurs sur le même réseau n'ont pas besoin de serveur. Les moyens de se "
                        'connecter à travers les réseaux figurent dans le démarrage rapide <a '
                        'href="{server}"></a>; chaque guide a son propre serveur de téléchargement.'),
                       ('Sommes de contrôle',
                        'Les sommes de contrôle SHA-256 de chaque fichier se trouvent dans <a '
                        'href="{sums}">SHA256SUMS</a>.'),
                       ('Quoi de neuf et anciennes versions',
                        'Consultez les notes de version <a href="{notes}"></a> pour connaître les '
                        'modifications apportées à cette version\xa0; les anciennes versions se trouvent sur '
                        '<a href="{releases}">GitHub publie</a>.')]},
 'ld_description': "Copiez et collez entre ordinateurs, recherchez l'historique de votre presse-papiers et "
                   'envoyez des photos et des fichiers entre ordinateurs et Android. Mac, Windows, Linux, '
                   'Android et une page Web de téléphone. Android et Web fonctionnent sur le même réseau. '
                   'Gratuit et open source.',
 'ld_os': 'macOS 13 ou version ultérieure (silicium Intel et Apple) ; Windows 10, Windows 11 (x64); Linux '
          '(x64, ARM64)',
 'ld_currency': 'USD',
 'ld_features': ['Synchronise le texte brut, le texte enrichi, les images, les fichiers et les dossiers',
                 'Fonctionne entre Mac, Windows et Linux, sans compte partagé, sur les réseaux',
                 "Aucun serveur n'est nécessaire sur le même réseau, avec découverte automatique mDNS",
                 'Connexion directe WebRTC avec repli automatique du relais TURN',
                 "Cryptage DTLS de bout en bout avec empreintes digitales vérifiées par l'homme lors du "
                 'couplage',
                 'Éléments de moins de 50\xa0Mo transférés lors de la copie, fichiers plus volumineux '
                 'extraits à la demande',
                 "Historique des 3 derniers jours, avec aperçus d'images",
                 "Interface en 18 langues, dont l'arabe (de droite à gauche)"]}

FEATURES = {'nav_features': 'Caractéristiques',
 'nav_more': 'Plus',
 'nav_security': 'Sécurité',
 'nav_changelog': 'Journal des modifications',
 'nav_more_label': 'Plus de pages',
 'gh_aria': 'Étoile PasteFerry sur GitHub',
 'star_ask': 'Vous aimez ça ? Mettez-le en vedette sur GitHub.',
 'star_button': 'Ajouter une étoile sur GitHub',
 'demo_where': 'Où sont les deux ordinateurs ?',
 'demo_wan': 'Maison ↔ bureau',
 'demo_lan': 'Même Wi-Fi',
 'net_home': 'Accueil',
 'net_office': 'Bureau',
 'net_wifi': 'Wi-Fi domestique',
 'demo_server': 'Le serveur ne fait que les présenter',
 'demo_no_server': 'Trouvé sur le réseau local, pas de serveur',
 'demo_hint': "Cliquez sur n'importe quoi sur le Mac pour le copier",
 'demo_image': "Capture d'écran.png",
 'demo_text': 'Réunion déplacée à 15h30, salle 4B',
 'demo_folder': 'actifs de marque',
 'demo_copy': 'Copier {item}',
 'demo_pasted': '{item} collé sur {device}',
 'demo_pause': 'Mettre la démo en pause',
 'demo_resume': 'Lire la démo',
 'theme_menu': 'Apparence',
 'theme_system': 'Suivre le système',
 'theme_light': 'Clair',
 'theme_dark': 'Sombre',
 'badge': '{version} : plus de connexions directes →',
 'home_phone_h2': 'Votre téléphone participe.',
 'home_phone_intro': 'Échangez avec votre ordinateur sur le même réseau, via Android ou un QR code dans le navigateur.',
 'home_phone_points': ["<b>Utilisez le navigateur</b> pour l'historique et les transferts de fichiers "
                       'séparés.',
                       '<b>Android envoie et reçoit des lots</b> , avec sauvegarde et partage.',
                       '<b>Même réseau</b>; garder la page Web ouverte.'],
 'home_phone_link': 'Comment utiliser le téléphone →',
 'home_send_h2': "Faites-le glisser.<br>C'est là.",
 'home_send_intro': 'Glissez les fichiers ou dossiers sur l’appareil destinataire.',
 'home_send_link': "En savoir plus sur l'envoi de fichiers →",
 'home_qp_h2': 'Retrouvez<br>vos copies.',
 'home_qp_intro': "Appuyez dessus dans n'importe quelle application, choisissez un élément et il est collé.",
 'home_qp_link': 'En savoir plus sur le collage rapide →',
 'home_qp_alt': 'La fenêtre de collage rapide\xa0: un champ de recherche et six onglets (Tous, Texte, Liens, '
                "Images, Fichiers, Favoris), des éléments d'historique numérotés et des astuces clés en bas",
 'grid_h2': "Plus qu'un presse-papiers partagé.",
 'grid_more': 'Voir toutes les fonctionnalités →',
 'grid': [('send',
           'Envoi de fichiers',
           "Déposez des fichiers ou des dossiers sur un autre ordinateur ou un contact. N'importe quelle "
           'taille.',
           True),
          ('keys',
           'Collage rapide',
           'Appuyez sur {key} pour votre historique\xa0; choisissez un élément et il est collé.',
           False),
          ('folder',
           'Fichiers et dossiers',
           'Les petits fichiers se synchronisent au fur et à mesure que vous copiez, les gros lorsque vous '
           'en avez besoin.',
           False),
          ('clock', 'Histoire et favoris', 'Tout est copié sur chaque appareil, consultable.', False),
          ('globe',
           'À travers les réseaux',
           'Activez le service pour synchroniser entre la maison et le travail.',
           False),
          ('lock',
           'Chiffré de bout en bout',
           'Direct d’abord. Le serveur ne peut pas voir ce que vous copiez.',
           False)],
 'new_tag': 'Nouveautés',
 'kicker_new': 'Nouveau en 2.6',
 'title': 'Fonctionnalités\xa0: envoi de fichiers, collage rapide, favoris, historique sur tous les '
          'appareils\xa0– PasteFerry',
 'description': 'PasteFerry synchronise le presse-papiers entre Mac, Windows et Linux: copiez du texte, des '
                "images, des fichiers ou des dossiers et collez-les sur l'autre ordinateur. Appuyez sur ⌥V "
                'or Alt+V for quick paste, conservez vos favoris, recherchez ou filtrez votre historique et '
                "envoyez des fichiers de n'importe quelle taille directement vers un autre ordinateur.",
 'eyebrow': 'Caractéristiques du PasteFerry',
 'h1': 'Copiez et collez<br>comme il se doit.',
 'lede': 'Presse-papiers synchronisé, historique et transfert de fichiers.',
 'hero_alt': "Historique de PasteFerry: une barre latérale avec l'historique, les favoris, l'envoi de "
             "fichiers, les appareils et les paramètres, ainsi qu'une liste de textes, d'images, de fichiers "
             'et de liens provenant de différents ordinateurs.',
 'sync_h2': 'Copiez ici.<br>Collez-y.',
 'sync_intro': 'Copiez-collez du texte, des images, des fichiers et des dossiers.',
 'sync_facts': [('Texte, images, fichiers, dossiers', 'Se colle proprement dans les champs de texte brut.'),
                ("Jusqu'à 50 Mo sont envoyés lors de la copie",
                 'Articles plus grands sur demande. La limite est réglable.'),
                ('Faites une pause à tout moment', 'Mettez tout en pause, ou juste un ordinateur.')],
 'send_h2': "N'importe quelle taille.<br>Faites-le simplement glisser.",
 'send_intro': 'Glissez les fichiers ou dossiers sur l’appareil destinataire.',
 'send_points': [("N'importe quelle taille",
                  'Vidéos de plusieurs Go ou dossiers contenant des milliers de fichiers.'),
                 ("Reprend là où il s'est arrêté",
                  'Reprise après une interruption de connexion ou une mise en veille. Chaque fichier est '
                  'vérifié.'),
                 ('Fichiers reçus en un seul endroit',
                  'Enregistré dans les téléchargements par défaut, un clic pour afficher.')],
 'send_note': 'Transferts directs illimités ; relais du Service : 100 Mo par ordinateur et par jour.',
 'send_alt': 'La page Envoyer des fichiers : un radar avec ce Mac au milieu et des appareils sur le même '
             'réseau et ailleurs autour de lui ; à droite, les fichiers reçus, avec un dossier arrivant et '
             'son avancement et sa rapidité',
 'theme_kicker': 'Nouveau dans 2.10',
 'theme_h2': 'Faites-le vôtre.<br>Même en pixels.',
 'theme_intro': 'Neuf thèmes intégrés. Personnalisez-les ou créez-en avec l’IA.',
 'theme_points': [('Thème des pixels',
                   'Type bitmap, blocs crantés et boutons biseautés. Une scène de nuit ou de jour en haut, '
                   "un avion en papier lors de l'envoi et un éclat d'étoiles une fois terminé."),
                  ('Thèmes personnalisés',
                   'Dupliquez un thème intégré, importez ou exportez des fichiers de thème. Vous êtes averti '
                   'lorsque le texte est difficile à lire.'),
                  ('Demandez à une IA',
                   'Ajoutez <code>pasteferry-cli mcp</code> à Claude, Cursor et autres, puis dites « '
                   'faites-moi un thème cyberpunk ». Il est créé et appliqué.')],
 'theme_note': 'Les thèmes sont enregistrés sur cet appareil uniquement.',
 'theme_alt': 'La page Apparence dans Paramètres (thème Pixel, sombre) : vignettes des thèmes intégrés par '
              "défaut et Pixel et deux thèmes personnalisés, puis Importer le thème, Demander à l'IA de "
              'créer un thème, clair et sombre, et lignes de balayage.',
 'theme_alt_light': "Histoire dans le thème Pixel (lumière) : nuages et collines dans l'en-tête, et une "
                    'petite maison en bas de la barre latérale',
 'theme_alt_send': 'Envoyer des fichiers dans le thème Pixel (sombre) : montagnes nocturnes et lune dans '
                   "l'en-tête, radar en pointillés et appareils de blocage de pixels",
 'home_theme_h2': 'Faites-le vôtre.<br>Même en pixels.',
 'home_theme_intro': 'Les thèmes sont ici\xa0: un look pixel intégré, vos propres thèmes ou un thème conçu '
                     "par l'IA pour vous.",
 'home_theme_alt': 'Histoire dans le thème Pixel (sombre)\xa0: montagnes nocturnes, pins et lune dans '
                   "l'en-tête, une tente et un feu de camp en bas de la barre latérale et type bitmap",
 'home_theme_link': 'En savoir plus sur les thèmes →',
 'friends_h2': "L'ordinateur d'un ami,<br>, tout aussi simple.",
 'friends_intro': 'Ajoutez un ami et envoyez-lui des fichiers.',
 'friends_points': [('Ils décident de ce qui entre',
                     "Découvrez qui a envoyé quoi avant d'accepter ou acceptez automatiquement les personnes "
                     'en qui vous avez confiance.'),
                    ('Vous décidez qui peut envoyer',
                     'Personne, contacts uniquement ou tout le monde sur votre réseau pendant 10 minutes.'),
                    ('Des fichiers, pas du chat',
                     'Les contacts ne voient jamais votre presse-papiers, votre historique ou vos '
                     'appareils.')],
 'friends_note': 'À distance, activez le Service des deux côtés.',
 'friends_alt': 'La page Envoyer des fichiers\xa0: les avatars des contacts sous le radar et une demande au '
                'milieu\xa0: un contact sur un MacBook Air souhaite vous envoyer des fichiers, avec une '
                'note\xa0- que vous pouvez refuser ou accepter',
 'home_friends_link': "En savoir plus sur l'envoi aux contacts →",
 'phone_kicker': 'Nouveau en 2.8',
 'phone_alt': 'La page des appareils transfert web téléphone : le code et les téléphones enregistrés',
 'phone_h2': 'Votre téléphone participe.',
 'phone_intro': 'Échangez avec votre ordinateur sur le même réseau, via Android ou un QR code dans le navigateur.',
 'phone_points': [('Utilisez le navigateur', "pour l'historique et les transferts de fichiers séparés."),
                  ('Android envoie et reçoit', 'lots, avec sauvegarde et partage.'),
                  ('Même réseau', '; garder la page Web ouverte.')],
 'phone_note': 'Sur iPhone et iPad, gardez la version web ouverte.',
 'qp_h2': 'Appuyez sur {key}.<br>Choisissez et collez.',
 'qp_intro': 'Cherchez dans l’historique et collez un élément.',
 'qp_steps': [('Appuyez sur {key}', "Fonctionne dans n'importe quelle application."),
              ('Tapez quelques lettres',
               'Recherchez du texte et des noms de fichiers ou appuyez sur {index}.'),
              ('Appuyez sur {enter}. Fait.',
               '{plain} pour le texte brut, {copyonly} pour la copie uniquement.')],
 'qp_note': 'Vous pouvez modifier ou désactiver le raccourci. Le collage pour vous sur un Mac nécessite une '
            "autorisation d'accessibilité.",
 'qp_label': "Démo : lors de la rédaction d'un email, appuyez sur ⌥V; la fenêtre de collage rapide s'ouvre, "
             "en tapant «\xa0réunion\xa0» trouve le lien de la réunion et Retour le colle dans l'e-mail",
 'mail_window': 'Nouveau message',
 'mail_to_label': 'Pour\xa0:',
 'mail_to': 'Équipe',
 'mail_subject_label': 'Sujet\xa0:',
 'mail_subject': 'Synchronisation hebdomadaire déplacée',
 'mail_body': ['Salut à tous,', 'La synchronisation hebdomadaire se déplace au jeudi 15h. Lien :'],
 'qp_typing': [('m', False), ('moi', False), ('moi', False), ('rencontrer', False), ('réunion', False)],
 'qp_rows': [('text', 'Envoyez-moi le deck avant 19h', 'À l’instant', False, False),
             ('link', 'https://github.com/baiyuze/pasteferry', 'il y a 2 minutes', False, False),
             ('image', 'Image', 'Windows PC · il y a 5 minutes', True, False),
             ('files', 'contrat-signé.pdf et 2 de plus', 'il y a 52 minutes', False, False),
             ('text',
              'Lien de la réunion\xa0: https://meeting.example.com/j/8823',
              'il y a 1 heure',
              True,
              True),
             ('text', 'docker compose up -d --build', 'il y a 1 heure', False, False),
             ('text', 'Les notes de réunion sont dans le dossier partagé', 'Hier', False, True),
             ('text', 'pnpm install', 'Hier', False, False)],
 'fav_h2': 'Gardez ce que vous réutilisez.',
 'fav_intro': 'Les favoris restent enregistrés, avec une copie distincte des fichiers.',
 'fav_points': [('Jamais nettoyé', "L'historique expire\xa0; les favoris restent."),
                ('Une copie à elle seule',
                 'La modification ou la suppression de l’original ne l’affecte pas.'),
                ('En pâte rapide aussi', 'Également en pâte rapide\xa0; appuyez sur {fav} pour ajouter.')],
 'fav_alt': 'La page Favoris\xa0: cinq éléments enregistrés, dont un modèle de rapport, une réponse '
            'standard, un lien de téléchargement et un PDF, chacun avec une étoile bleue',
 'details_h2': 'Autres fonctions',
 'filter_title': 'Les liens ont leur propre onglet',
 'filter_text': 'Textes, liens, images, fichiers : un clic pour filtrer.',
 'filter_rows': [('text', 'Réunion déplacée au jeudi 15h', False),
                 ('link', 'https://github.com/baiyuze/pasteferry', False),
                 ('image', 'Image · 2,4 Mo', False),
                 ('file', 'Bilan du troisième trimestre - final.key', False),
                 ('link', 'https://pasteferry.cc/download/', True),
                 ('text', 'Rapport hebdomadaire\xa0: terminé / la semaine prochaine', True)],
 'hover_title': 'Survolez pour tout voir',
 'hover_text': "Passez la souris pour voir l'ensemble de l'article.",
 'hover_alt': 'Le pointeur repose sur des notes de réunion et une carte affiche le texte intégral\xa0: '
              'propriétaires, fenêtre de publication et suivi.',
 'search_title': 'Recherchez ce que vous avez copié',
 'search_text': "Recherchez par texte ou par nom de fichier. Conservé 3 jours par défaut, jusqu'à 30.",
 'search_query': 'contrat',
 'search_hits': ['contrat-signé.pdf', 'Clause 3 du contrat : passage aux paiements trimestriels'],
 'big_title': 'Des fichiers volumineux, quand vous en avez besoin',
 'big_text': "Plus de 50\xa0Mo sont d'abord synchronisés sous forme d'enregistrement\xa0; cliquez sur "
             'Recevoir pour transférer.',
 'big_file': 'lancement-demo.mov',
 'big_meta': 'Depuis Mac mini · 1,3 Go',
 'big_button': 'Recevoir',
 'folder_title': 'Des dossiers entiers aussi',
 'folder_text': 'Copiez un dossier, collez le même dossier.',
 'names_from': 'Notes 10h30?.md',
 'names_to': 'Notes 10：30？.md',
 'names_title': 'Des noms qui fonctionnent partout',
 'names_text': 'Les caractères Windows ne permettent pas de se ressembler en pleine largeur.',
 'net_h2': 'Maison et bureau,<br>connecté directement.',
 'net_intro': 'Associez les appareils sur le même réseau, ou utilisez le Service, votre serveur ou Tailscale.',
 'net_points': [('Même réseau', "Pas de serveur. Entrez un code d'appairage et vous avez terminé."),
                ('À travers les réseaux', 'Service, votre propre serveur ou Tailscale.'),
                ('Chiffré de bout en bout',
                 'Vérifiez les empreintes digitales lors du couplage\xa0; le serveur ne voit jamais votre '
                 'contenu.')],
 'net_links': 'Choisissez comment vous connecter →',
 'net_how': 'Comment ça marche →',
 'net_label': 'Schéma\xa0: deux ordinateurs sur un réseau domestique et un ordinateur de bureau se trouvent '
              'via le service, puis se connectent directement',
 'net_service': 'Service',
 'net_direct': 'Direct · chiffré de bout en bout',
 'numbers_h2': 'Par les chiffres.',
 'numbers': [('3', 'systèmes', 'macOS, Windows, Linux'),
             ('50 MB', '', 'envoyé pendant que vous copiez'),
             ('≈330 ms', '', 'pour un fichier de 20\xa0Mo sur un réseau local'),
             ('0', 'comptes', "pas d'inscription, juste une paire")],
 'closing': 'Essayez-le maintenant.',
 'how_title': 'Comment fonctionne le PasteFerry : connexions directes, sondages multi-liaison montante et '
              'gestion des pannes',
 'how_lede': 'Que se passe-t-il lorsque vous copiez, comment les ordinateurs se connectent et que se '
             "passe-t-il lorsqu'ils ne le peuvent pas.",
 'security_title': 'Sécurité et confidentialité\xa0: cryptage de bout en bout et vérification du couplage — '
                   'PasteFerry',
 'security_lede': 'Chiffrement de bout en bout et vérification des empreintes à l’association.',
 'privacy_link': 'Politique de confidentialité →',
 'faq_title': 'FAQ — PasteFerry',
 'faq_lede': 'Vous ne trouvez pas de réponse ? Faites-le-nous savoir.',
 'faq_more': 'Signaler un problème →'}

TOUR = {'opening_1': 'Copie entre deux ordinateurs',
 'opening_2': 'cela ne devrait pas représenter autant de travail.',
 'pain_chat': "Vous l'envoyer",
 'pain_chat_detail': 'Envoyez, ouvrez, téléchargez, puis recherchez le fichier',
 'airdrop': 'AirDrop',
 'pain_airdrop_detail': 'Acceptez à chaque fois. Toujours pas de synchronisation du presse-papiers.',
 'universal': 'Presse-papiers universel',
 'pain_universal_detail': 'Idem Apple ID, et les appareils doivent être proches',
 'pain_cross_platform': 'Entre Mac et Windows',
 'pain_cross_platform_detail': 'Aucune des options intégrées ne fonctionne',
 'simpler': 'Cela peut être beaucoup plus simple.',
 'tagline': 'Copiez sur cet ordinateur. Collez sur celui-là.',
 'notes': 'Remarques',
 'decision_1': 'Déploiement à 10 % mardi.',
 'decision_2': 'Tous les usagers jeudi si tout va bien.',
 'screenshot': "Capture d'écran.png",
 'notepad': 'Notes de réunion.txt - Bloc-notes',
 'word': 'Rapport hebdomadaire.docx - Word',
 'demo_file': 'Copiez un fichier sur Mac. Collez-le sur Windows.',
 'demo_text': 'Et retour\xa0: copiez sur Windows, collez sur Mac.',
 'demo_image': "Des captures d'écran aussi. Ils collent sous forme d'images.",
 'types': 'Ce que vous copiez est ce que vous collez',
 'text': 'Texte',
 'rich_text': 'Texte enrichi',
 'images': 'Images',
 'files': 'Fichiers',
 'folders': 'Dossiers entiers',
 'small_files': 'Moins de 50 Mo ? Le transfert commence au fur et à mesure que vous copiez.',
 'large_files': 'Les fichiers plus volumineux arrivent sur demande, en un seul clic.',
 'history_1': 'Tout ce que tu as copié,',
 'history_2': 'tout en un seul endroit',
 'retention': "3 jours d'historique par défaut",
 'restore': 'Cliquez pour le copier à nouveau',
 'preview': 'Aperçu des images en place',
 'pull': 'Extrayez des fichiers volumineux lorsque vous en avez besoin',
 'pairing': 'Associez-le une fois et vous êtes prêt',
 'nearby': 'Sur le même réseau, recherchez un ordinateur à proximité et associez-le',
 'fingerprints': 'Vérifiez les empreintes digitales sur les deux écrans avant de confirmer',
 'networks': 'Un réseau ou plusieurs. Votre choix.',
 'home': 'A la maison ou au bureau,',
 'lan_detail': 'pas de serveur à configurer',
 'cloud_detail': 'Héberger une petite VM cloud,',
 'anywhere': "synchroniser depuis n'importe où",
 'across': 'À travers les réseaux,',
 'tailscale_detail': 'sans votre propre serveur',
 'encrypted': 'Une connexion directe lorsque cela est possible. Chiffré de bout en bout.',
 'relay': "En mode serveur, votre serveur relaie les données cryptées en cas d'échec d'un lien direct.",
 'comparison': 'Comment ça se compare',
 'free': 'Gratuit et open source',
 'download': 'Réception',
 'source': 'Source',
 'closing': 'Moins d’envoi de choses. Plus de choses à faire.'}

TOUR_UI = {'watch': 'Regardez la tournée complète',
 'title': 'Découvrez PasteFerry en 85 secondes',
 'play': 'Jouer',
 'pause': 'Pause',
 'replay': 'Rejouer',
 'progress': 'Position de lecture',
 'chapters': 'Choisissez un chapitre',
 'fullscreen': 'Plein écran',
 'exit_fullscreen': 'Quitter le plein écran',
 'close': 'Fermer la visite',
 'back': 'Retour au site',
 'summary': 'Points forts de la tournée',
 'silent': 'Visite silencieuse'}

TOUR_CHAPTERS = ["Trop d'étapes",
 'Rencontrez PasteFerry',
 'Copier et coller',
 'Ce que vous pouvez synchroniser',
 'Historique du presse-papiers',
 'Appairage sécurisé',
 'Façons de se connecter',
 'Comparez les options',
 'Commencez']

THEMES = {'name': 'Guide des thèmes',
 'title': 'Guide des thèmes — PasteFerry',
 'summary': "Modifiez les thèmes dans PasteFerry, changez de clair et d'obscur, créez votre propre thème et "
            "laissez des applications d'IA telles que Claude et Cursor concevoir et appliquer des thèmes sur "
            'MCP.',
 'fit': 'Thèmes et apparence',
 'lede': 'Neuf thèmes intégrés, modes clair et sombre, couleurs et fonds personnalisés.',
 'download': 'Télécharger 2.12.1',
 'jump_ai': "Passer aux thèmes créés par l'IA ↓",
 'switch_title': 'Changer le thème',
 'switch_steps': ['Ouvrez PasteFerry et accédez à Paramètres <b>› Apparence</b>.',
                  'Cliquez sur un thème sous Intégré ou Personnalisé. La fenêtre change immédiatement, tout '
                  'comme Quick Paste.',
                  'Sous Clair et sombre, choisissez <b>Match system</b>, <b>Light</b> ou <b>Dark</b>.',
                  'Avec un thème de pixels, vous pouvez également activer les lignes de balayage <b></b>, de '
                  'faibles lignes CRT sur toute la fenêtre.',
                  "Sur Android, choisissez dans les paramètres <b>de l'application › Apparence</b>; les "
                  'ordinateurs et les téléphones ne s’influencent pas.'],
 'switch_alt': 'Paramètres › Apparence\xa0: les thèmes intégrés par défaut et Pixel, deux thèmes '
               "personnalisés, Importer un thème, Demander à l'IA de créer un thème, clair et sombre, et des "
               'lignes de balayage.',
 'builtin_title': 'Neuf thèmes intégrés',
 'builtin': [('Par défaut', 'Le look silencieux et de style système que le PasteFerry a toujours eu.'),
             ('Pixel',
              'Type bitmap, bordures crantées et boutons biseautés, palettes graphite et papier avec pixel '
              "vert. Une scène de nuit ou de jour en haut, un avion en papier lors de l'envoi et un éclat "
              "d'étoiles à son arrivée."),
             ('Disques de Jazz',
              'Géométrie de pochette de disque, bleu cobalt, papier chaud et titres condensés.'),
             ("L'ère spatiale",
              'Émail orange, tons argentés, illustrations orbitales et commandes de capsules.'),
             ('Memphis', 'Rose et jaune, collage géométrique et contours forts.'),
             ("L'avenir de l'an 2000",
              'Bleu électrique, étoiles chromées et commandes numériques arrondies.'),
             ('Impression vintage', 'Crème et rouge chaud, points demi-teintes et illustrations de billets.'),
             ('Arcade de pixels', 'Vert portable, type bitmap et contrôles de type inventaire crantés.'),
             ('Bureau rétro',
              'Bleu sarcelle et gris, boutons carrés biseautés et illustrations de fenêtres classiques.')],
 'builtin_alt_default': 'Historique dans le thème par défaut (clair)',
 'builtin_alt_pixel': "Histoire dans le thème Pixel (sombre)\xa0: des montagnes et une lune dans l'en-tête, "
                      'une tente et un feu de camp en bas de la barre latérale',
 'custom_title': 'Créez votre propre thème',
 'custom_intro': 'Le moyen le plus simple consiste à dupliquer un thème intégré et à le modifier\xa0:',
 'custom_steps': ['Dans Paramètres <b>› Apparence</b>, survolez un thème, cliquez sur <b>⋯</b> et choisissez '
                  '<b>Dupliquer</b>. La copie apparaît sous Personnalisé.',
                  'Dans le menu <b>⋯</b> de la copie, choisissez <b>Exporter…</b> pour enregistrer un '
                  'fichier <code>.pasteferry-theme.json</code> .',
                  "Modifiez les couleurs, le nom, etc. dans n'importe quel éditeur de texte (le format est "
                  'décrit ci-dessous).',
                  'De retour sur la page Apparence, cliquez sur <b>Importer le thème…</b> et choisissez le '
                  'fichier. Un thème avec le même identifiant est remplacé et le thème importé est appliqué.',
                  'Pour supprimer un thème personnalisé, choisissez <b>Supprimer le thème</b> dans son menu '
                  '<b>⋯</b> . Les thèmes intégrés ne peuvent pas être supprimés.'],
 'custom_note': 'Exportez un thème pour le partager.',
 'bg_title': "Utiliser une image d'arrière-plan",
 'bg_steps': ["Ouvrez Paramètres <b>› Apparence</b>, faites défiler jusqu'à <b>Image d'arrière-plan</b>, "
              'cliquez sur <b>Choisir une image…</b> et choisissez un JPEG, PNG ou GIF.',
              "L'image remplit la fenêtre derrière la barre latérale et les pages, et la barre latérale et "
              "les listes deviennent translucides. Si un thème intégré est utilisé, une copie est d'abord "
              'effectuée\xa0; le thème intégré lui-même reste le même.',
              '<b>Flou</b>, <b>Scrim</b> et <b>Les panneaux</b> comportent chacun trois étapes. <b>Utiliser '
              "les couleurs de l'image</b> prend la couleur d'accent de l'image et <b>Afficher également "
              "dans le collage rapide</b> l'affiche également ici.",
              'Cliquez sur <b>Supprimer</b> pour revenir en arrière. Sur Android, choisissez une photo sous '
              "Paramètres <b>› Apparence › Image d'arrière-plan</b>."],
 'bg_note': 'Le texte reste toujours lisible\xa0: PasteFerry détermine la force du canevas pour les couleurs '
            'du texte du thème sur cette image et ne le montre jamais plus clair. Les images sombres avec le '
            "mode sombre et les images claires avec le mode clair affichent la meilleure partie de l'image.",
 'bg_alt': 'Thème pixel en mode sombre avec un fond de collines au coucher du soleil\xa0: la barre latérale '
           "et la liste sont translucides et l'image transparaît",
 'bg_alt2': "Paramètres › Apparence › Image d'arrière-plan\xa0: modifier, supprimer, trois étapes pour le "
            "flou, le canevas et les panneaux, utiliser les couleurs de l'image, également afficher dans "
            'Quick Paste',
 'scene_title': 'Changer de décor',
 'scene_steps': ['Le décor est la grande image en haut des pages et la petite en bas de la barre latérale. '
                 'Le thème des pixels y dessine un paysage de pixels et un petit camp\xa0; les autres thèmes '
                 "n'en ont pas.",
                 'Sous Paramètres <b>› Apparence › Paysage</b>, cliquez sur <b>Choisir une image…</b> à côté '
                 'de <b>En-tête de page</b> ou <b>Barre latérale inférieure</b> pour utiliser la vôtre des '
                 "images, avec n'importe quel thème. Un canevas est ajouté sous le titre de la page pour "
                 "qu'il reste lisible.",
                 "<b>Réinitialiser</b> ramène l'original\xa0; désactivez <b>Afficher la scène</b> pour "
                 "masquer les deux. Le paysage est masqué tandis qu'une image d'arrière-plan remplit la "
                 'fenêtre.'],
 'scene_alt': "Thème pixel en mode sombre avec l'en-tête de page et le bas de la barre latérale remplacés "
              'par une image de collines au coucher du soleil',
 'file_title': 'À quoi ressemble un fichier de thème',
 'file_intro': 'Les thèmes utilisent JSON. Cet exemple modifie les couleurs du thème Pixel :',
 'file_fields_title': 'Champs communs',
 'file_fields': [('<code>id</code>',
                  "L'identifiant du thème : lettres minuscules, chiffres et <code>-</code>. Il ne peut pas "
                  "s'agir de <code>default</code> ou de <code>pixel</code>."),
                 ('<code>name</code>',
                  'Le nom dans chaque langue, par exemple <code>zh-Hans</code>, <code>zh-Hant-TW</code>, '
                  '<code>zh-Hant-HK</code>, <code>en</code> et <code>ja</code>.'),
                 ('<code>base</code>',
                  'Le thème de départ\xa0: <code>default</code>, <code>pixel</code> ou un autre thème '
                  'personnalisé.'),
                 ('<code>modes.light</code> / <code>modes.dark</code>',
                  'Couleurs pour le clair et le foncé, comme <code>#RRGGBB</code> ou <code>#AARRGGBB</code> '
                  'avec alpha. Les plus courants\xa0: <code>accent</code>, <code>background</code> (zone de '
                  'contenu), <code>sidebar</code>, <code>surface</code> (groupes et boîtes de dialogue), '
                  '<code>border</code>, <code>text</code>, <code>textDim</code>, <code>textFaint</code> et '
                  "<code>onAccent</code> (texte sur l'accent)."),
                 ('<code>typography</code>',
                  'Polices\xa0: <code>family</code> est <code>system</code> ou la police de pixels intégrée '
                  '<code>FusionPixel</code>.'),
                 ('<code>shape</code>',
                  'Formes\xa0: <code>corner</code> correspond à <code>round</code> ou <code>pixel</code> '
                  "(encoché), plus les rayons, la largeur de la bordure et le style d'ombre."),
                 ('<code>motion</code>, <code>icons</code>',
                  'Mouvement <code>smooth</code> / <code>stepped</code> / <code>reduced</code>; icônes '
                  '<code>system</code> / <code>pixel</code>.'),
                 ('<code>background</code>',
                  "Image d'arrière-plan de la fenêtre\xa0: <code>image</code> "
                  "(<code>user:&lt;sha256&gt;</code> après l'importation), <code>blur</code>, "
                  '<code>scrim</code>, <code>surfaceOpacity</code> (opacité du panneau), <code>scope</code> '
                  "(quelles fenêtres l'affichent), <code>accentFromImage</code>."),
                 ('<code>scenery</code>, <code>scene</code>',
                  'Paysage activé/désactivé et vos propres images\xa0: <code>scene.header</code> (en-tête de '
                  'page) et <code>scene.sidebar</code> (en bas de la barre latérale), avec '
                  '<code>headerDark</code> et <code>sidebarDark</code> en option pour le mode sombre.')],
 'file_more': 'Le format complet et où chaque couleur est utilisée\xa0:',
 'ai_title': 'Laissez une IA créer un thème',
 'ai_intro': 'Connectez via MCP pour créer et appliquer des thèmes avec Claude, Cursor ou une autre IA.',
 'ai_step1': '1. Trouver Pasteferry-cli',
 'ai_paths': [('Mac',
               '<code>/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli</code> (avec Homebrew, '
               'juste <code>pasteferry-cli</code>)'),
              ('Windows', '<code>%LOCALAPPDATA%\\Programs\\PasteFerry\\pasteferry-cli.exe</code>'),
              ('Linux',
               'deb\xa0: <code>/usr/bin/pasteferry-cli</code>; tar.gz\xa0: '
               '<code>PasteFerry/pasteferry-cli</code> dans le dossier extrait')],
 'ai_paths_note': "Ou copiez la configuration prête à l'emploi pour cet ordinateur à partir de Paramètres "
                  "<b>› Apparence › Demander à l'IA de créer un thème</b>.",
 'ai_step2': '2. Ajoutez-le à votre application IA',
 'ai_desktop': 'Claude Desktop (Paramètres › Développeur › Modifier la configuration) et Curseur '
               '(<code>~/.cursor/mcp.json</code>) utilisent la même configuration. Sur un Mac\xa0:',
 'ai_code': 'Pour Claude Code, exécutez dans un terminal\xa0:',
 'ai_restart': 'Enregistrez, puis redémarrez l’application IA. Gardez PasteFerry ouvert.',
 'ai_step3': '3. Dites ce que vous voulez',
 'ai_prompts': ['Créez-moi un thème cyberpunk avec du rose fluo et du violet foncé, puis appliquez-le.',
                'Commencez par le thème Pixel et créez une version coucher de soleil avec un fond sombre '
                'plus chaud.',
                'Le texte gris de mon thème actuel est difficile à lire. Rendez-le plus léger.',
                'Exportez mon thème pour que je puisse le voir, puis créez une version allégée.',
                'Utilisez ~/Pictures/beach.jpg comme arrière-plan et faites correspondre les couleurs à la '
                'photo.',
                "Remplacez le paysage d'en-tête du thème de pixels par ~/Pictures/mountains.png."],
 'ai_does_title': "Ce que l'IA peut faire",
 'ai_does': ['lister les thèmes et lire un thème dans son intégralité\xa0;',
             'lire le format du thème : où chaque couleur est utilisée et le contraste dont elle a besoin ;',
             "vérifier un thème sans l'enregistrer, pour trouver des couleurs avec trop peu de contraste ;",
             'enregistrez, appliquez et supprimez des thèmes personnalisés, et passez du clair au foncé\xa0;',
             'Importez une image depuis cet ordinateur comme fond de fenêtre ou décor, et analysez sa '
             'luminosité et ses couleurs principales.'],
 'ai_safe_title': "Ce qu'il ne peut pas faire",
 'ai_safe': 'Accès limité aux thèmes et fonds locaux, sans accès à l’historique ni aux appareils.',
 'faq_title': 'Questions',
 'faq': [('Les thèmes sont-ils synchronisés avec mes autres appareils\xa0?',
          'Non. Un thème s’applique uniquement à l’appareil sur lequel vous l’avez défini. Pour utiliser le '
          'même thème ailleurs, exportez-le et importez-le là-bas.'),
         ("L'IA a gâché mon thème. Comment puis-je revenir ?",
          'Choisissez Par défaut ou Pixel dans Paramètres > Apparence. Supprimez les thèmes personnalisés '
          'dont vous ne voulez pas.'),
         ("L'importation indique que certains textes peuvent être difficiles à lire.",
          'Certaines couleurs de texte et d’arrière-plan présentent un faible contraste. Éclaircissez ou '
          "assombrir ces couleurs comme suggéré, ou demandez à l'IA de les corriger."),
         ('Les anciennes versions prennent-elles en charge les thèmes\xa0?',
          "Vous avez besoin de la version 2.10 ou ultérieure. Le protocole de l'appareil reste inchangé, les "
          'anciennes et les nouvelles versions fonctionnent toujours ensemble.'),
         ('Le texte sera-t-il difficile à lire sur ma photo ?',
          "Non. La force du canevas est déterminée à partir des couleurs du texte du thème et n'est jamais "
          'plus claire que nécessaire. Pour une image chargée, augmentez le flou ou l’opacité du panneau.')],
 'more_title': 'Plus',
 'more_links': [('Laissez une IA créer un thème (guide complet)', 'guide/ai-themes.md'),
                ('Format et conception du thème', 'design/themes.md'),
                ('Outils MCP', 'design/mcp.md')]}

OFFICIAL = {'badge': 'Sur différents réseaux ? Activer le service et synchroniser →',
 'title': 'Service\xa0: synchronisation entre la maison et le bureau sans votre propre serveur — PasteFerry',
 'name': 'Service',
 'fit': 'Fonctionne entre la maison et le bureau',
 'go': 'Activer le service →',
 'summary': 'Activez le Service pour connecter des ordinateurs entre réseaux.',
 'lede': 'Lorsque deux ordinateurs ne sont pas sur le même réseau, activez le service et ils se '
         'synchronisent.',
 'steps_title': "Comment l'allumer",
 'steps': ['Installez la dernière version sur chaque ordinateur et cliquez sur Activer la synchronisation en '
           'arrière-plan.',
           'Activez Utiliser le service dans Paramètres → Connexion.',
           "Associez les deux ordinateurs. Les ordinateurs que vous avez déjà couplés n'ont pas besoin "
           "d'être à nouveau couplés."],
 'routing_title': 'Transferts',
 'routing': 'Connexion directe si possible, sinon relais du contenu chiffré.',
 'quota_title': 'Quota de données',
 'quota': '100 Mo de relais par ordinateur et par jour. Transferts directs illimités.',
 'privacy_title': 'Activation',
 'privacy': 'Désactivé par défaut. À activer sur chaque ordinateur.',
 'self_title': 'Autres options',
 'self': "Sur le même réseau, vous n'en avez pas besoin. Vous pouvez également exécuter votre propre serveur "
         'ou utiliser Tailscale.',
 'settings_alt': 'Le commutateur Utiliser le service dans Paramètres → Connexion',
 'usage_alt': "Page d'utilisation de démonstration pour le service affichant une allocation quotidienne de "
              '100,00\xa0Mo et 80,00\xa0Mo restants',
 'privacy_link': 'Avis de confidentialité',
 'self_link': "Guide d'auto-hébergement",
 'download': 'Téléchargez la dernière version'}

PRIVACY = ('Confidentialité',
 [('En bref',
   'Ce que vous copiez, les fichiers que vous envoyez, leurs noms et vos notes voyagent cryptés de bout en '
   'bout entre vos propres appareils. Nous ne pouvons pas les voir et ne les stockons pas.'),
  ("Service (lorsqu'il est activé)",
   'Les nouvelles installations utilisent uniquement le réseau local. Lorsque vous activez le service, vos '
   "appareils se connectent au serveur officiel afin qu'ils puissent se retrouver sur les réseaux. Nous "
   "conservons un numéro d'appareil pseudonyme, les premières et dernières heures de connexion ainsi que "
   "l'utilisation quotidienne du relais. Ce n'est que lorsqu'une connexion directe échoue et qu'un relais "
   "est nécessaire que l'application dérive un résumé de machine spécifique à PasteFerry, de sorte qu'un "
   'ordinateur partage une allocation de relais. Les vrais noms d’appareils, les identifiants bruts du '
   'système et le contenu ne sont jamais téléchargés.'),
  ('Mettre à jour les contrôles',
   "L'application vérifie les mises à jour une fois par jour, récupérant une liste de mises à jour signée "
   'sur le site Web PasteFerry , GitHub et Gitee. La demande au site Web inclut la version, le système et la '
   "langue, et s'il s'agit de la première vérification du jour, de la semaine ou du mois, pour fournir la "
   "bonne mise à jour et planifier les versions futures. Aucun identifiant d'appareil ou compte n'est inclus "
   'et les adresses IP ne sont pas stockées. Les vérifications automatiques peuvent être désactivées dans '
   "Paramètres → À propos. Les mises à jour ne s'installent qu'après confirmation et uniquement si elles "
   'correspondent à une liste signée avec la clé de version PasteFerry .'),
  ('Contacts',
   "Un contact voit le nom d'affichage et l'avatar que vous définissez, le nom et le système de l'ordinateur "
   'à partir duquel vous envoyez, et si vous utilisez le réseau local, le service ou votre propre serveur '
   '(pour votre propre serveur, seulement un résumé de son adresse). Votre presse-papiers, votre historique '
   "et vos autres appareils ne sont jamais partagés avec vos contacts, et leurs fichiers n'arrivent qu'après "
   'que vous les ayez acceptés.'),
  ('Site web',
   'Ce site Web utilise Cloudflare Web Analytics et conserve ses propres totaux de pages vues et de clics de '
   "téléchargement (date, chemin d'accès à la page, langue de la page, version et fichier téléchargé). Aucun "
   "cookie d'analyse ni identifiant de visiteur persistant n'est utilisé, et les adresses IP et les "
   'identifiants de navigateur ne sont pas stockés. Lorsque Do Not Track ou Global Privacy Control est '
   'activé, les propres compteurs du site Web ne sont pas envoyés.'),
  ('Discussion et commentaires',
   'Les surnoms et les textes que vous soumettez sont stockés sur le serveur pour examen et assistance, et '
   "deviennent publics après approbation. Lorsque l'examen par l'IA est activé, le texte nécessaire est "
   "envoyé à un service d'IA tiers tel que DeepSeek selon les conditions de traitement des données de ce "
   'fournisseur\xa0; les administrateurs peuvent également lire et gérer les soumissions. Votre navigateur '
   "enregistre les brouillons, les enregistrements de soumission et les identifiants d'accès par message "
   'pendant 30 jours maximum. La suppression des données locales ne supprime pas les messages du serveur\xa0'
   "; utilisez le navigateur d'origine pour les retirer. Le contenu non publié, retiré et masqué est "
   'supprimé après 90 jours\xa0; le contenu public demeure jusqu’à son retrait ou sa suppression. La '
   'prévention des abus utilise des résumés de sources temporaires plutôt que de stocker les adresses IP '
   'brutes. Ne soumettez pas de mots de passe, de clés API ou d’informations privées.'),
  ('Comment il est utilisé',
   'Ces informations sont utilisées pour fournir et améliorer le service, publier des mises à jour, assurer '
   'la sécurité du service et prévenir les abus, mesurer et planifier et respecter les obligations légales. '
   "Nous ne le vendons pas et ne l'utilisons pas à des fins publicitaires."),
  ('Tiers',
   'GitHub, Gitee, Cloudflare et tout serveur que vous choisissez traitent vos demandes selon leurs propres '
   'politiques de confidentialité.'),
  ('Rétention',
   'Les détails quotidiens par appareil pour le Service sont conservés pendant 90 jours\xa0; les totaux '
   'quotidiens sans identité personnelle sont conservés indéfiniment.'),
  ('Vos choix',
   'Vous pouvez utiliser uniquement le réseau local, désactiver le service, désactiver les vérifications '
   'automatiques des mises à jour ou exécuter votre propre serveur. Le client et le serveur PasteFerry sont '
   'open source.'),
  ('Avis de non-responsabilité et modifications',
   'PasteFerry et le Service sont fournis gratuitement et tels quels\xa0; Les autorisations et '
   'fonctionnalités de relais peuvent changer ou être suspendues. Nous ne sommes pas responsables de la '
   'perte de données ou des échecs de synchronisation causés par les réseaux, les appareils, les services '
   'tiers ou les serveurs auto-hébergés. Les modifications apportées à cet avis prennent effet dès leur '
   'publication sur le site Web\xa0; continuer à utiliser PasteFerry signifie que vous les acceptez.'),
  ('Contacter', 'Questions sur cet avis\xa0: ouvrez un ticket sur github.com/baiyuze/pasteferry/issues.')])

FEEDBACK = {'name': 'Discussions et commentaires',
 'lede': 'Signalez un problème, suggérez une fonctionnalité ou partagez votre expérience.',
 'all': 'Tout',
 'bug': 'Rapport de bug',
 'idea': 'Demande de fonctionnalité',
 'discussion': 'Discussion',
 'new': 'Démarrer un sujet',
 'mine': 'Mes soumissions',
 'mine_note': 'Seuls les enregistrements enregistrés dans ce navigateur apparaissent ici. Effacer les '
              "données du navigateur ou changer d'appareil peut rendre inaccessibles les soumissions non "
              'publiées.',
 'nickname': 'Surnom',
 'title': 'Titre',
 'body': 'Message',
 'category': 'Catégorie',
 'platform': "Système d'exploitation",
 'version': "Version de l'application",
 'optional': 'Facultatif',
 'submit': 'Soumettre',
 'reply': 'Rejoignez la discussion',
 'back': 'Retour aux sujets',
 'more': 'Charger plus',
 'empty': "Aucun sujet public pour l'instant. Vos commentaires sont les bienvenus.",
 'loading': 'Chargement…',
 'error': 'Impossible de se connecter. Veuillez réessayer plus tard.',
 'saved': 'Brouillon enregistré dans ce navigateur',
 'storage_warning': "Le stockage du navigateur n'est pas disponible. Les brouillons et les informations "
                    'd’identification de soumission peuvent être perdus après une actualisation.',
 'submitted': 'Soumis. Votre message sera public après approbation.',
 'uncertain': 'Le statut de la soumission est incertain. Réessayez la soumission originale.',
 'withdrawn': 'Retiré',
 'expired': 'Enregistrement expiré',
 'confirm_withdraw': 'Retirer ce message\xa0? Ce ne sera plus public.',
 'clear': 'Effacer les enregistrements locaux',
 'confirm_clear': "Effacer les brouillons et les informations d'identification locales\xa0? Cela ne retirera "
                  'pas les messages sur le serveur.',
 'retry': 'Réessayer la soumission',
 'withdraw': 'Se retirer',
 'official': 'Officiel',
 'pending': "Révision de l'IA en cours",
 'manual': 'En attente de révision manuelle',
 'approved': 'Publique',
 'rejected': 'Non approuvé',
 'hidden': 'Caché',
 'open': 'Ouvert',
 'in_progress': 'En cours',
 'resolved': 'Résolu',
 'closed': 'Fermé',
 'draft': 'Décrivez votre problème ou votre idée…',
 'privacy': 'Confidentialité',
 'clearing': 'La suppression des enregistrements locaux ne supprime pas les messages. Retirez d’abord tout '
             'contenu public.',
 'no_topic': "Ce sujet n'est pas disponible ou n'a pas été publié.",
 'all_languages': 'Toutes les langues',
 'language': 'Langue des messages',
 'published': 'Publié',
 'failure': 'Votre message peut contenir un contenu inapproprié. Veuillez le modifier et réessayer.',
 'visitor': 'Visiteur',
 'sending': 'Soumission…',
 'required_fields': 'Veuillez écrire votre problème ou votre idée.',
 'secure_unavailable': 'Ce navigateur ne peut pas soumettre de manière sécurisée. Ouvrez le site Web HTTPS '
                       'dans un navigateur à jour.',
 'rate_limited': 'Trop de soumissions. Veuillez réessayer sous peu. Votre texte a été conservé.',
 'unavailable': 'Les nouveaux messages ne peuvent pas être acceptés pour le moment. Veuillez essayer plus '
                'tard. Votre texte a été conservé.',
 'invalid_fields': 'Veuillez vérifier vos entrées et leur longueur, puis réessayer.',
 'extra': 'Détails supplémentaires (facultatif)'}
