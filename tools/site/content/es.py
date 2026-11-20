"""Website copy: Spanish. Translation-assisted; key product copy and app terminology reviewed."""

C = {'brand': 'PasteFerry',
 'brand_alt': ['隔空贴', 'CopySync'],
 'title': 'PasteFerry: portapapeles, historial y transferencia de archivos entre dispositivos',
 'description': 'Copie y pegue entre computadoras, busque el historial del portapapeles y envíe fotos y '
                'archivos entre computadoras y Android. Mac, Windows, Linux, Android y una página web de '
                'teléfono. Android y web funcionan en la misma red. Gratis y de código abierto.',
 'og_title': 'PasteFerry: portapapeles, historial y transferencia de archivos entre dispositivos',
 'og_description': 'Copie y pegue entre computadoras, busque el historial del portapapeles y envíe fotos y '
                   'archivos entre computadoras y Android. Mac, Windows, Linux, Android y una página web de '
                   'teléfono. Android y web funcionan en la misma red. Gratis y de código abierto.',
 'og_image': 'og-es.png',
 'skip': 'Saltar al contenido',
 'home_label': 'PasteFerry casa',
 'nav_label': 'Página',
 'nav_start': 'Inicio rápido',
 'nav_how': 'como funciona',
 'nav_faq': 'Preguntas frecuentes',
 'nav_server': 'Formas de conectarse',
 'nav_download': 'Descargar',
 'lang_label': 'Idioma',
 'h1': 'Copia aquí.<br>Pega allí.',
 'lede': 'Sincroniza el portapapeles, guarda el historial y envía fotos y archivos.',
 'dl_button': 'Descargar PasteFerry',
 'dl_mac': 'Descargar para Mac',
 'dl_win': 'Descargar para Windows',
 'dl_linux': 'Descargar para Linux',
 'dl_note': 'Gratis y de código abierto · Mac / Windows / Linux / Android',
 'start_link': 'Inicio rápido →',
 'stage_label': 'Demostración: el comando C en una MacBook convierte un archivo en una hoja que sobrevuela '
                'una conexión directa a una computadora portátil Windows , donde Ctrl V pastes it',
 'stage_file': 'Revisión del tercer trimestre - final.pptx',
 'stage_win': 'portátil Windows',
 'stage_arc': 'Cifrado directo de extremo a extremo',
 'replay': 'jugar de nuevo',
 'paths_h2': 'Formas de conexión',
 'paths_intro': 'Empareja en la misma red o usa el Servicio, tu servidor o Tailscale entre redes.',
 'paths_after': '¿Nuevo aquí? Siga el inicio rápido de <a href="{start}#server"></a>. El servicio es '
                'gratuito: 100 MB de retransmisión al día, conexiones directas ilimitadas.',
 'plans_label': 'Formas de conectarse',
 'plans': {'lan': {'name': 'Misma red',
                   'fit': 'Sin servidor',
                   'summary': 'Empareja con un código en la misma red Wi-Fi o por cable.',
                   'go': 'Misma guía de red →',
                   'facts': [('Lo mejor para',
                              'Casa u oficina, con ambos ordenadores en la misma red Wi‑Fi o cableada.'),
                             ('necesitas', 'Nada más que la aplicación en cada computadora.'),
                             ('tener en cuenta',
                              'La sincronización se detiene cuando sales de la red y se reanuda cuando '
                              'regresas. Si la conexión por cable y Wi‑Fi están en subredes diferentes, '
                              'ingresa una dirección adicional al realizar el emparejamiento.')],
                   'steps': ['Conecta ambos ordenadores a la misma red Wi-Fi o por cable.'],
                   'address': 'No hay dirección de servidor para ingresar.'},
           'cloud': {'name': 'Tu propio servidor público',
                     'fit': 'Tu servidor, retransmisión ilimitada',
                     'summary': 'Alójalo en tu propio servidor Linux.',
                     'go': 'Guía del servidor público →',
                     'facts': [('Lo mejor para',
                                'Ejecute el servidor usted mismo o transmita una gran cantidad de tráfico.'),
                               ('necesitas', 'Una máquina virtual Linux con una IP pública y acceso raíz.'),
                               ('tener en cuenta',
                                'La VM cuesta dinero y la velocidad de retransmisión está limitada por su '
                                'ancho de banda. En China continental, ingrese la IP a menos que el dominio '
                                'tenga una presentación ICP.')],
                     'steps': ['Instala el servidor siguiendo la <a href="{cloud}">guía</a>.',
                               'Introduce la dirección generada en Ajustes → Conexión.'],
                     'address': 'Abra <code>http://PUBLIC_IP:8787/healthz</code> en un navegador. Si dice '
                                'ok, está funcionando.'},
           'ts': {'name': 'Tailscale',
                  'fit': 'A través de redes, sin servidor',
                  'summary': 'Empareja a través de tu red Tailscale.',
                  'go': 'Guía Tailscale →',
                  'facts': [('Lo mejor para',
                             'Ya utilizas Tailscale o no quieres depender de ningún servidor.'),
                            ('necesitas',
                             'Tailscale en cada computadora, iniciando sesión en la misma cuenta.'),
                            ('tener en cuenta',
                             'Tailscale tiene que permanecer conectado. Cuando no puede conectar dos '
                             'computadoras directamente, las transmite a través de sus propios servidores, '
                             'lo que puede ser lento.')],
                  'steps': ['Instale Tailscale en cada computadora e inicie sesión en la misma cuenta.',
                            'En la otra computadora, ejecute <code>tailscale ip -4</code> y anote la dirección que comienza con 100.'],
                  'address': 'No se necesita servidor. Una dirección Tailscale no cambia, por lo que la '
                             'ingresa una vez al realizar el emparejamiento.'}},
 'flow_h2': '¿Qué pasa cuando copias?',
 'flow_intro': 'El texto, las imágenes y los archivos toman el mismo camino.',
 'flow': [('Aviso', 'El servicio en segundo plano ve que el portapapeles cambió.'),
          ('Enviar',
           'Los textos y archivos de hasta 50 MB se envían de inmediato. Los más grandes se envían primero '
           'como registro.'),
          ('Pegar',
           'La otra computadora lo guarda localmente y lo coloca en el portapapeles. Pegas un archivo '
           'real.')],
 'why_h2': '¿Por qué no usar lo que ya tienes?',
 'why_intro': 'Universal Clipboard necesita el mismo Apple ID, AirDrop te hace aceptar siempre y ninguno '
              'funciona entre una Mac y una PC Windows .',
 'compare_caption': 'PasteFerry comparado con otras opciones',
 'compare_cols': ['PasteFerry', 'Portapapeles universal', 'AirDrop', 'Aplicaciones de chat'],
 'compare_rows': [('No se necesita cuenta',
                   [('yes', 'si'),
                    ('no', 'Mismo Apple ID'),
                    ('partial', 'Solo dispositivos Apple'),
                    ('no', 'Es necesario iniciar sesión')]),
                  ('Entre Mac, Windows, Linux y Android',
                   [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('yes', 'si')]),
                  ('Entre casa y la oficina', [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('yes', 'si')]),
                  ('En una red local sin internet',
                   [('yes', 'si'), ('partial', 'Sólo cerca'), ('yes', 'si'), ('no', 'No')]),
                  ('Pegar inmediatamente después de copiar, no hay nada que aceptar.',
                   [('yes', 'si'), ('yes', 'si'), ('no', 'No'), ('no', 'No')]),
                  ('Archivos y carpetas completas, de cualquier tamaño.',
                   [('yes', 'si'),
                    ('partial', 'poco confiable'),
                    ('yes', 'si'),
                    ('partial', 'Zip primero, límites de tamaño')]),
                  ('Encuentra algo que copiaste antes',
                   [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('partial', 'Desplazarse hacia atrás')]),
                  ('Sólo tus dispositivos pueden descifrar',
                   [('yes', 'si'), ('yes', 'si'), ('yes', 'si'), ('some', 'Depende de la aplicación')])],
 'tour_compare_rows': [('Diferentes ID de Apple',
                        [('yes', 'si'), ('no', 'No'), ('partial', 'Necesita aceptación'), ('yes', 'si')]),
                       ('Entre Mac, Windows y Linux',
                        [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('yes', 'si')]),
                       ('Entre casa y la oficina',
                        [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('yes', 'si')]),
                       ('Pegar inmediatamente después de copiar',
                        [('yes', 'si'), ('yes', 'si'), ('no', 'No'), ('no', 'No')]),
                       ('Archivos y carpetas completas.',
                        [('yes', 'si'),
                         ('partial', 'poco confiable'),
                         ('yes', 'si'),
                         ('partial', 'Zip primero')]),
                       ('Encuentra algo que copiaste antes',
                        [('yes', 'si'), ('no', 'No'), ('no', 'No'), ('partial', 'Desplazarse hacia atrás')]),
                       ('Sólo tus dispositivos pueden descifrar',
                        [('yes', 'si'), ('yes', 'si'), ('yes', 'si'), ('some', 'Depende de la aplicación')])],
 'how_h2': 'como funciona',
 'how_intro': 'En la misma red, los ordenadores se encuentran directamente. En diferentes redes, un servidor '
              'los presenta para que puedan intentar conectarse directamente y los retransmite sólo si eso '
              'falla. El contenido siempre está cifrado.',
 'diagram': {'title': 'Cómo se conecta PasteFerry',
             'desc': 'La computadora A y la computadora B se conectan directamente a través de WebRTC. Ambos '
                     'se conectan al servidor para señalización. Si falla la conexión directa, los datos se '
                     'transmiten a través del servicio TURN del servidor.',
             'server': 'Servicio de señalización y retransmisión.',
             'server_sub': 'Señalización, STUN, relé de GIRO',
             'sig_note': 'Señalización: detalles de conexión',
             'relay_note': 'Relé: sólo si falla el directo',
             'copy_here': 'Copias aquí',
             'other': 'Mac, Windows o Linux',
             'paste_here': 'Pegas aquí',
             'direct': 'Directo WebRTC, DTLS cifrado',
             'direct_note': 'Los datos se mueven solo entre sus computadoras',
             'legend_direct': 'Datos (directos)',
             'legend_relay': 'Datos (retransmisión, reserva)',
             'legend_sig': 'Señalización'},
 'uplink_h2': 'Directo en redes de oficina también',
 'uplink_intro': 'Las redes de oficinas con varios enlaces ascendentes solían pasar por el relevo. '
                 'PasteFerry encuentra cada enlace ascendente y deja que la otra parte pruebe cada uno.',
 'uplink_changed': 'que hace',
 'uplink_points': [('Un puerto compartido.', 'Todas las conexiones utilizan el mismo puerto UDP .'),
                   ('Se sondearon todos los enlaces ascendentes.',
                    'Solicita siete servidores a la vez y obtiene una dirección por enlace ascendente.'),
                   ('Todos ellos enviados al otro lado.',
                    'La otra computadora prueba cada uno hasta que uno logra pasar.'),
                   ('Vuelva a intentarlo directamente mientras está inactivo.',
                    'El relé mantiene todo funcionando y cambia a directo cuando está inactivo.')],
 'lab_h3': 'Probado en configuraciones de red reales',
 'lab_intro': 'Cada confirmación se prueba automáticamente en redes simuladas.',
 'lab_cols': ['Escenario', 'Resultado'],
 'lab_rows': [('Enlace ascendente único ↔ enrutador doméstico', 'Directa'),
              ('Dos enlaces ascendentes, versión anterior (control)', 'Retransmisión'),
              ('Cuatro enlaces ascendentes ↔ enrutador doméstico', 'Directa'),
              ('Dos enlaces ascendentes ↔ dos enlaces ascendentes', 'Directa'),
              ('Dos enlaces ascendentes ↔ NAT que aleatoriza los puertos', 'Retransmisión'),
              ('Bloqueado al principio, la red se recupera más tarde', 'Relevo, luego directo'),
              ('Sin servidor, misma subred', 'Directa'),
              ('Sin servidor, subredes aisladas entre sí', 'Sin conexión')],
 'uplink_measured': 'Medido: una Mac en una red de oficina de 4 enlaces ascendentes y una en casa '
                    'transmitían a 0,6 MB/s antes. Ahora se conectan directamente.',
 'uplink_doc': 'Los detalles se encuentran en el documento de diseño <a href="{doc}"></a> (en chino).',
 'security_h2': 'El servidor no puede ver lo que copias.',
 'security_points': [('Sin cuentas, sin contenido almacenado.',
                      'La identidad de un dispositivo es una clave, por lo que el servidor no necesita una '
                      'tabla de usuarios.'),
                     ('Verifique las huellas digitales al emparejar.',
                      'Ambas pantallas muestran la misma huella digital; si alguien intercambia una clave, '
                      'no coincidirá.'),
                     ('Cada mensaje está firmado,',
                      'para que el servidor no pueda hacerse pasar por su dispositivo.'),
                     ('El relé sólo reenvía texto cifrado.',
                      'Las credenciales de retransmisión caducan después de 12 horas.'),
                     ('Privado en la red local también.',
                      'Un dispositivo transmite un token anónimo que cambia diariamente, por lo que nadie '
                      'puede saber de quién es la computadora.')],
 'verify_alt': 'La verificación de huellas dactilares durante el emparejamiento muestra R8NF-2WTC-QL5J y le '
               'pide que confirme que coincide exactamente con la otra computadora',
 'fallback_h2': 'Cuando las cosas van mal',
 'fallback_intro': 'Se manejan los casos comunes.',
 'fallbacks': [('No puedo encontrar la otra computadora en la red',
                'Ingrese su dirección al emparejar; se recuerda después.'),
               ('Sin conexión directa', 'Los datos se transmiten a través del servidor, aún encriptados.'),
               ('La otra computadora duerme o se apaga', 'Se vuelve a conectar por sí solo cuando regresa.'),
               ('Desconectado al enviar archivos', 'La transferencia se reanuda donde se detuvo.'),
               ('Un nombre de archivo Windows no permite',
                'Los caracteres incorrectos se convierten en caracteres de ancho completo, por lo que el '
                'nombre sigue siendo el mismo.'),
               ('Copiar una contraseña',
                'En Windows, se omite todo lo copiado de un administrador de contraseñas.')],
 'install_h2': 'Instalar',
 'install_intro': 'Instale la aplicación en cada computadora. ¿Primer tiempo? Siga el inicio rápido de <a '
                  'href="{start}"></a>.',
 'server_intro': 'En la misma red, instale y empareje. En diferentes redes, active Servicio. Si desea un '
                 'control total, ejecute su propio servidor o utilice Tailscale.',
 'copy': 'Copiar',
 'copied': 'Copiado',
 'pairing': 'Muestre un código de emparejamiento en una computadora, ingréselo en la otra y verifique que '
            'ambas líneas de huellas digitales coincidan antes de confirmar. Con el Servicio no necesita la '
            'dirección de la otra computadora; ingresa uno solo entre subredes o con Tailscale.',
 'specs_h2': 'Especificaciones',
 'specs': [('Versión', '2.13.1, lanzado <time datetime="2026-11-20">el 20 de noviembre de 2026</time>'),
           ('aplicación para mac',
            'macOS 13 Ventura o posterior; descargas separadas para Apple Silicon e Intel, aproximadamente '
            '25 MB cada una, sin Rosetta; una versión universal para ambos pesa aproximadamente 47 MB'),
           ('Aplicación Windows',
            'Windows 10 y Windows 11, x64; instalaciones por usuario, sin derechos de administrador; '
            'aproximadamente 23 MB de descarga'),
           ('Aplicación Linux',
            'x64 y ARM64; .deb (Debian, Ubuntu y similares) o tar.gz (otras distribuciones), unos 22 MB; '
            'necesita un escritorio X11, o un escritorio Wayland con XWayland (GNOME, KDE y otros lo '
            'incluyen por defecto); GTK 3'),
           ('Servidor',
            'No es necesario con el Servicio o en la misma red. Para ejecutar el suyo propio: Linux '
            'x86_64/ARM64, macOS o Windows 10/11 x64.'),
           ('Idiomas',
            '18 idiomas: inglés, chino simplificado y tradicional (Taiwán y Hong Kong), japonés, coreano, '
            'árabe (de derecha a izquierda), alemán, francés, español, portugués (Brasil), italiano, ruso, '
            'ucraniano, polaco, turco, vietnamita e indonesio; sigue el sistema de forma predeterminada, '
            'conmutable en Configuración'),
           ('Contenido',
            'Texto sin formato, texto enriquecido, imágenes y capturas de pantalla, archivos, carpetas; cada '
            'tipo se puede desactivar'),
           ('Transporte',
            'Canales de datos WebRTC , primero directo con respaldo de relé TURN; en la misma red, '
            'descubrimiento de mDNS y detalles de conexión a través de UDP 8788; cada enlace ascendente '
            'sondeado en redes de múltiples enlaces ascendentes; archivos transmitidos como tar + zstd'),
           ('Cifrado e identidad',
            'De extremo a extremo DTLS;  Teclas del dispositivo Ed25519 ; cada mensaje de señalización '
            'firmado'),
           ('Emparejamiento',
            'Código de 6 caracteres válido durante 5 minutos, utilizando un alfabeto sin dobles como 0/O y '
            '1/I; huellas dactilares revisadas por usted'),
           ('Límite de sincronización automática', '50 MB por defecto, ajustable de 1 MB a 1 GB'),
           ('Enviar archivos',
            'A un dispositivo, cualquier tamaño, archivos o carpetas completas; en la red local a través de '
            'un enlace TCP cifrado (ambos lados necesitan 2.5.1), recurriendo a WebRTC cuando no esté '
            'disponible; WebRTC a través de Internet y retransmisión; se reanuda después de una desconexión; '
            'SHA-256 por archivo. Mac medido a Linux VM, 1 GB: 144,3 MB/s; La velocidad real depende de la '
            'red y los discos.'),
           ('Contactos',
            'Código de contacto de 7 caracteres que comienza con F, intercambiado a través de la red local o '
            'Servicio, con verificación de código de seguridad opcional; los contactos sólo pueden enviarse '
            'archivos e imágenes, con una nota de hasta 200 caracteres, y cada lote debe ser aceptado; los '
            'contactos nunca ven su portapapeles, historial o dispositivos; los archivos recibidos pierden '
            'el bit ejecutable y se ponen en cuarentena en una Mac; ambos lados necesitan 2.6 o posterior'),
           ('Historial',
            '3 días por defecto, ajustable de 1 hora a 30 días; artículos caducados eliminados '
            'automáticamente'),
           ('Velocidad medida',
            'Un archivo de 20 MB se transfiere en aproximadamente 330 ms a través de una conexión LAN '
            'directa, con sumas de comprobación coincidentes.'),
           ('Construido con',
            'Elija el servicio y el servidor en segundo plano (Go puro llamando a Win32 en Windows y '
            'hablando el protocolo X11 en Linux), Flutter para la aplicación (una base de código para los '
            'tres sistemas), búferes de protocolo para mensajes'),
           ('Licencia',
            '<a href="https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md">GNU AGPL-3.0</a>')],
 'faq_h2': 'Preguntas',
 'faq': [('¿En qué se diferencia del Portapapeles universal?',
          ['El Portapapeles universal solo funciona entre dispositivos Apple cercanos en el mismo Apple ID.  '
           'A PasteFerry no le importan las cuentas, funciona en Mac, Windows y Linux, y entre el hogar y la '
           'oficina.']),
         ('¿En qué se diferencia de AirDrop?',
          ['AirDrop solo funciona entre dispositivos Apple cercanos.  Enviar archivos de PasteFerry funciona '
           'entre Mac, Windows y Linux, y también en redes. No habla con AirDrop; ambos lados necesitan '
           'PasteFerry.']),
         ('¿Necesito mi propio servidor?',
          ['No. En la misma red, instale y empareje; en diferentes redes, active el servicio <a '
           'href="{official}"></a>. También puede utilizar <a href="{cloud}">su propio servidor</a> o <a '
           'href="{ts}">Tailscale</a>.']),
         ('No hay IP pública en casa. ¿Puedo sincronizar entre casa y la oficina?',
          ['Sí, active el servicio <a href="{official}"></a>.']),
         ('¿Puede el servidor ver lo que copio?',
          ['No, el contenido está cifrado de extremo a extremo. Consulte el aviso de privacidad <a '
           'href="{privacy}"></a>.']),
         ('¿Cuánto relevo obtengo?',
          ['100 MB por computadora por día; las conexiones directas no cuentan. Cuando se acaba, el directo '
           'sigue funcionando. Sin límite, <a href="{cloud}">ejecute su propio servidor</a>.']),
         ('Ambas computadoras están en la misma red. ¿Por qué no pueden encontrarse?',
          ['Por lo general, están en subredes diferentes o un firewall los está bloqueando. Al realizar el '
           'emparejamiento, haga clic en ¿En una subred diferente? e ingrese la otra dirección. Más en la '
           'misma guía de red <a href="{lan}#faq"></a>.']),
         ('¿Puedo enviar archivos a la computadora de otra persona?',
          ['Sí. Desde 2.6, agréguelos como contacto, no es necesario emparejarlos; la transferencia comienza '
           'una vez que aceptan. Los contactos no pueden ver su portapapeles ni su historial.']),
         ('¿Qué pasa con los archivos grandes?',
          ['Se envían hasta 50 MB al copiar. Los archivos más grandes se recuperan cuando los necesita, o '
           'utilice Enviar archivos, que no tiene límite de tamaño.']),
         ('¿Windows?  ¿ Linux? iPhone?',
          ['Windows 10 y 11, y Linux en x64 y ARM64. iPhone y iPad no son compatibles: iOS no permite que '
           'las aplicaciones lean el portapapeles en segundo plano.']),
         ('¿Por qué el sistema me avisa la primera vez?',
          ['PasteFerry aún no está certificado ante notario por Apple ni firmado en código para Windows . En '
           'Mac, haga clic en Abrir de todos modos en Configuración del sistema → Privacidad y seguridad; en '
           'Windows, haga clic en Más información → Ejecutar de todos modos. Sólo haces esto una vez.']),
         ('¿Es gratis? ¿Mi empresa puede utilizarlo?',
          ['Sí, gratis para particulares y empresas. PasteFerry es de código abierto bajo GNU AGPL-3.0.']),
         ('¿Se conecta directamente a las redes de la oficina con varios enlaces ascendentes?',
          ['Sí. PasteFerry prueba todos los enlaces ascendentes.']),
         ('¿Por qué siguen apareciendo archivos .uuremote_ mientras se ejecuta UU Remote?',
          ['Eso era un error en versiones anteriores. Actualice a la última.'])],
 'closing': 'Descarga PasteFerry.',
 'footer_license': 'PasteFerry es de código abierto bajo GNU AGPL-3.0.',
 'footer_label': 'Pie de página',
 'footer_links': [('Todos los lanzamientos', 'https://github.com/baiyuze/pasteferry/releases'),
                  ('Registro de cambios', 'https://github.com/baiyuze/pasteferry/blob/main/CHANGELOG.md'),
                  ('Notas de diseño (chino)', 'https://pasteferry.cc/design/nat-traversal.html'),
                  ('Licencia', 'https://github.com/baiyuze/pasteferry/blob/main/LICENSING.md'),
                  ('Informar un problema', 'https://github.com/baiyuze/pasteferry/issues')],
 'guide': {'title': 'Ejecute un servidor PasteFerry en su LAN: Windows, Mac y Linux',
           'description': 'Cuando sus computadoras comparten una red, no necesita un servidor en la nube. '
                          'Ejecute el servidor TURN y de señalización de PasteFerry en cualquier máquina '
                          'Windows, Mac o Linux siempre activa con un script; comienza en el arranque. '
                          'Incluye configuración de aplicaciones y solución de problemas.',
           'h1': 'Ejecute el servidor en su LAN',
           'lede': 'Si sus computadoras están en la misma red doméstica o de oficina, no necesita un '
                   'servidor en la nube. Elija una computadora que permanezca encendida, descargue y ejecute '
                   'un script, luego ingrese la dirección que imprime en PasteFerry en cada computadora.',
           'notice': '<strong>En la misma red ya no necesitas un servidor:</strong> instala la aplicación y '
                     'vincula; consulte la misma guía de red <a href="{lan}"></a>. Esta guía sigue siendo '
                     'útil cuando dos subredes no pueden comunicarse entre sí y el tráfico tiene que pasar a '
                     'través de una computadora a la que ambas puedan llegar.',
           'toc': [('prepare', 'Antes de empezar'),
                   ('install', 'Instalar'),
                   ('check', 'comprobar'),
                   ('clients', 'Configurar las aplicaciones'),
                   ('faq', 'Preguntas')],
           'overview_h2': 'El servidor sólo introduce dispositivos',
           'overview_intro': 'Cada computadora permanece conectada al servidor, que es la forma en que se '
                             'encuentran e intercambian detalles de conexión. Una vez conectado, lo que '
                             'copias va directamente entre las dos computadoras. Sólo cuando eso falla pasa '
                             'a través del servidor, aún encriptado.',
           'diagram': {'title': 'PasteFerry en una LAN',
                       'desc': 'En una LAN, una Mac y una PC Windows se conectan al servidor en 192.168.1.20 '
                               'para señalización. El contenido copiado viaja directamente entre las dos '
                               'computadoras y a través del relé TURN del servidor solo si falla la conexión '
                               'directa.',
                       'lan': 'Tu LAN: la misma red Wi‑Fi o cableada',
                       'server': 'Servidor',
                       'sig_note': 'Señalización, TCP 8787',
                       'relay_note': 'Relé, UDP 3478, si falla el directo',
                       'client': 'Ejecutando PasteFerry',
                       'direct': 'Cifrado directo de extremo a extremo',
                       'direct_note': 'El contenido permanece entre las dos computadoras.',
                       'legend_direct': 'Datos (directos)',
                       'legend_relay': 'Datos (retransmisión, reserva)',
                       'legend_sig': 'Señalización'},
           'overview_points': ['Señalización<strong>, TCP 8787.</strong> Cada computadora permanece '
                               'conectada a ella para encontrar las demás, emparejarlas e intercambiar '
                               'detalles de conexión.',
                               '<strong>Directo.</strong> En una LAN, el contenido casi siempre va '
                               'directamente entre las dos computadoras, a la velocidad de su red.',
                               '<strong>Relé, UDP 3478.</strong> Solo se usa cuando los dispositivos no '
                               'pueden comunicarse entre sí: redes de invitados, Wi-Fi con aislamiento de '
                               'cliente, subredes separadas.'],
           'prep_h2': 'Antes de empezar',
           'prep': [('Una computadora que permanece encendida',
                     'Windows 10 u 11, macOS 13 o posterior, o cualquier Linux, incluida una de las dos '
                     'computadoras que sincroniza. La sincronización se detiene mientras está apagado o '
                     'dormido y se reanuda cuando se despierta. Lo ideal es un NAS, un enrutador doméstico o '
                     'un Mac mini; el servidor utiliza alrededor de 15 MB de RAM.'),
                    ('una dirección fija',
                     'Reserve una dirección para él en la configuración DHCP de su enrutador (a menudo '
                     'llamada reserva DHCP o arrendamiento estático). De lo contrario, cuando el enrutador '
                     'proporcione una nueva dirección, todas las computadoras deberán actualizarse.'),
                    ('la misma red',
                     'Los dispositivos solo necesitan estar en la misma red Wi-Fi o cableada. Las redes de '
                     'invitados y Wi‑Fi con aislamiento de cliente (AP) impiden que los dispositivos se '
                     'comuniquen entre sí; utilice otra red o desactive el aislamiento.'),
                    ('No hay sincronización fuera de él',
                     'Solo se puede acceder al servidor en su LAN, por lo que una computadora portátil '
                     'llevada a otro lugar se pone al día cuando regresa.')],
           'install_h2': 'Instalar el servidor',
           'install_intro': 'Elija el sistema de la computadora que ejecutará el servidor. El script '
                            'encuentra la dirección LAN de la computadora, configura el servidor para que se '
                            'inicie automáticamente e imprime la dirección para ingresar en las '
                            'aplicaciones.',
           'os_label': 'Sistema de la computadora servidor',
           'manage_caption': 'Para más tarde',
           'win': {'steps': ['Descargue <a '
                             'href="https://github.com/baiyuze/pasteferry/releases/latest/download/pasteferry-server-windows-amd64.zip">pasteferry-server-windows-amd64.zip</a> '
                             'y elija Extraer todo.',
                             'Abra la carpeta extraída y haga doble clic en <code>install.cmd</code>.<span '
                             'class="aside">Si ve "Windows protegió su PC", haga clic en Más información y '
                             'luego en Ejecutar de todos modos; Cuando el Control de cuentas de usuario lo '
                             'solicite, haga clic en Sí. El servidor aún no tiene el código firmado, por lo '
                             'que Windows pregunta una vez.</span>',
                             'La instalación continúa en una nueva ventana. La dirección '
                             '<code>ws://…/signal</code> al final es la que ingresas en las aplicaciones.'],
                   'download': 'Descargue el servidor Windows',
                   'notes': ['<strong>Se ejecuta como un servicio Windows :</strong> comienza con Windows, '
                             'no es necesario iniciar sesión ni abrir ventanas. Aparece como Servidor '
                             'PasteFerry en Servicios.',
                             '<strong>Firewall ya permitido:</strong> el script agrega una regla de entrada '
                             'solo para pasteferry-server.exe, por lo que no hay puertos para abrir.',
                             '<strong>Dirección incorrecta seleccionada</strong> (varios adaptadores de red, '
                             'digamos de una VM o VPN): escriba <code>cmd</code> en la barra de direcciones '
                             'de la carpeta extraída, presione Entrar y ejecute <code>install.cmd '
                             '192.168.1.20</code> con su dirección.',
                             'Windows 10 y 11, x64.'],
                   'double_click': 'Haga doble clic',
                   'explorer_label': 'La carpeta extraída contiene pasteferry-server.exe, install.cmd, '
                                     'install.ps1, README.md y uninstall.cmd; haga doble clic en '
                                     'instalar.cmd',
                   'term_title': 'Administrador: Windows PowerShell',
                   'term_label': 'La ventana después de install.cmd finaliza: detiene la versión anterior, '
                                 'la instala, registra el servicio, lo permite a través del firewall y lo '
                                 'inicia, luego imprime la dirección ws://192.168.1.20:8787/signal',
                   'manage': [('Estado',
                               '<code>Get-Service PasteFerryServer</code> en un administrador PowerShell, o '
                               'busque el servidor PasteFerry en Servicios'),
                              ('Registros', '<code>C:\\ProgramData\\PasteFerry Server\\server.log</code>'),
                              ('Reiniciar',
                               '<code>Restart-Service PasteFerryServer</code> en un administrador '
                               'PowerShell'),
                              ('Actualizar',
                               'Descargue la nueva versión, extráigala y haga doble clic en '
                               '<code>install.cmd</code> nuevamente; Tus configuraciones se mantienen.'),
                              ('Desinstalar',
                               'Haga doble clic en <code>uninstall.cmd</code>; elimina el servicio, la regla '
                               'de firewall y los archivos')]},
           'mac': {'steps': ['Abra Terminal y ejecute estas líneas:',
                             'La dirección <code>ws://…/signal</code> al final es la que ingresas en las '
                             'aplicaciones.'],
                   'notes': ['<strong>No se necesitan derechos de administrador.</strong> Se ejecuta en '
                             'segundo plano cada vez que inicia sesión y macOS lo reinicia si sale.',
                             '<strong>Mantenga esta Mac despierta:</strong> en Configuración del sistema → '
                             'Energía (Batería → Opciones en una computadora portátil), active la opción que '
                             'evita la suspensión automática.',
                             '<strong>Si el firewall macOS está activado,</strong> el script termina con el '
                             'comando para permitir el servidor Pasterferry.',
                             'Intel y Apple Silicon, macOS 13 o posterior.'],
                   'term_label': 'Salida de ./install.sh en Terminal: instala, escribe LaunchAgent e inicia '
                                 'el servidor, luego imprime la dirección ws://192.168.1.20:8787/signal',
                   'manage': [('Registros', '<code>~/Library/Logs/PasteFerry/server.log</code>'),
                              ('Reiniciar',
                               '<code>launchctl kickstart -k gui/$(id -u)/com.pasteferry.server</code>'),
                              ('Actualizar',
                               'Descargue la nueva versión, extráigala y ejecute <code>./install.sh</code> '
                               'nuevamente; Tus configuraciones se mantienen.'),
                              ('Desinstalar', '<code>./install.sh uninstall</code>')]},
           'linux': {'steps': ['En la propia máquina, o a través de ssh, ejecute estas líneas:<span '
                               'class="aside">En ARM, como una Raspberry Pi con un sistema operativo de 64 '
                               'bits, reemplace <code>amd64</code> con <code>arm64</code>.</span>',
                               'La dirección <code>ws://…/signal</code> al final es la que ingresas en las '
                               'aplicaciones.'],
                     'notes': ['<strong>Registra un servicio systemd</strong> que se inicia al arrancar. '
                               'Necesita raíz.',
                               '<strong>Si ufw o firewalld están activos,</strong> el script finaliza con '
                               'los comandos para abrir los puertos.',
                               '<strong>Docker también funciona:</strong> copie <code>env.example</code> a '
                               '<code>.env</code>, configure <code>TURN_IP</code> en la dirección LAN de la '
                               'máquina y ejecute <code>docker compose up -d</code>. Necesita una red de '
                               'host, por lo que solo Linux .'],
                     'term_label': 'Salida de sudo ./install.sh: instala, escribe la unidad systemd y la '
                                   'configuración e inicia el servidor, luego imprime la dirección '
                                   'ws://192.168.1.20:8787/signal',
                     'manage': [('Estado', '<code>systemctl status pasteferry-server</code>'),
                                ('Registros', '<code>journalctl -u pasteferry-server -f</code>'),
                                ('Reiniciar', '<code>sudo systemctl restart pasteferry-server</code>'),
                                ('configuración',
                                 '<code>/etc/pasteferry/server.env</code>; reiniciar el servicio después de '
                                 'editar'),
                                ('Actualizar',
                                 'Descargue la nueva versión, extráigala y ejecute <code>sudo '
                                 './install.sh</code> nuevamente; tu configuración se mantiene'),
                                ('Desinstalar', '<code>sudo ./install.sh uninstall</code>')]},
           'check_h2': 'Compruebe que otras computadoras puedan alcanzarlo.',
           'check_intro': 'En otra computadora, abra <code>http://192.168.1.20:8787/healthz</code> en un '
                          'navegador (con su dirección). Si ve esta línea, la ruta de red funciona.',
           'check_label': 'Un navegador que muestra http://192.168.1.20:8787/healthz, con el estado del '
                          'servidor ok y su versión.',
           'check_after': 'Si no se carga, consulte las preguntas <a href="#faq"></a> a continuación.',
           'clients_h2': 'Ingrese la dirección en cada computadora',
           'clients_steps': [('Abrir configuración',
                              'Abra PasteFerry en cada computadora, incluida la que ejecuta el servidor, y '
                              'vaya a Configuración → Conexión.'),
                             ('Introduzca la dirección',
                              'En Servidor personalizado, ingrese <code>ws://192.168.1.20:8787/signal</code> '
                              'con su dirección y presione Retorno o Intro.'),
                             ('comprobar el estado',
                              'Cuando Conexión muestra un Conectado verde, estás listo. Empareje sus '
                              'dispositivos en Dispositivos y la copia comenzará a sincronizarse.')],
           'clients_alt': 'Configuración de PasteFerry → Conexión: El servidor personalizado es '
                          'ws://192.168.1.20:8787/signal y el estado de la conexión muestra Conectado',
           'clients_after': '¿Aún no has instalado la aplicación? Consulte el inicio rápido de <a '
                            'href="{start}"></a>.',
           'faq_h2': 'Preguntas',
           'faq': [('El estado permanece en No conectado',
                    ['Primero verifique la dirección: comienza con <code>ws://</code>, usa el puerto 8787, '
                     'termina en <code>/signal</code>y presionó Retorno después de escribirla.',
                     'Luego abra <code>http://server-address:8787/healthz</code> en un navegador en esa '
                     'computadora. Si no se carga, la ruta de la red está rota: el servidor no está '
                     'funcionando, su computadora está inactiva, un firewall la bloquea o su dirección '
                     'cambió.',
                     'El script Windows ya permite que el servidor atraviese el firewall. En una Mac con el '
                     'firewall activado, ejecute el comando que el script imprimió al final; lo mismo ocurre '
                     'con ufw y firewalld en Linux.']),
                   ('Los dispositivos muestran Retransmisión en lugar de Directo',
                    ['En una LAN las conexiones casi siempre son directas. La retransmisión significa que '
                     'UDP no puede comunicarse entre las dos computadoras, generalmente debido a una red de '
                     'invitados, aislamiento del cliente Wi-Fi o subredes separadas con un firewall en el '
                     'medio. El contenido transmitido todavía está cifrado; simplemente está limitado por la '
                     'red de la computadora servidor.']),
                   ('La dirección del servidor cambió.',
                    ['Ejecute el script nuevamente con la nueva dirección: <code>install.cmd '
                     'new-address</code> en Windows, <code>./install.sh new-address</code> en una Mac. En '
                     'Linux, edite <code>-turn-ip</code> en <code>/etc/pasteferry/server.env</code> y '
                     'reinicie el servicio. Luego actualice la dirección en cada computadora.',
                     'Reservar la dirección en su enrutador evita esto.']),
                   ('¿Se sincroniza fuera de la LAN?',
                    ['No, solo se puede acceder al servidor en su LAN. Para sincronizar entre redes, active '
                     'el servicio <a href="{official}"></a>o utilice un servidor público <a '
                     'href="{cloud}"></a> o <a href="{ts}">Tailscale</a>.']),
                   ('La computadora servidor también ejecuta PasteFerry. ¿Qué dirección?',
                    ['La misma dirección LAN funciona, al igual que <code>ws://127.0.0.1:8787/signal</code>. '
                     'El servidor y la aplicación no interfieren.'])],
           'closing': 'Una computadora que permanece encendida es suficiente.',
           'source': 'Guía completa de servidores, incluidos servidores públicos y Docker'},
 'cloud': {'title': 'Ejecute el servidor PasteFerry en un servidor público: guía de VM en la nube',
           'description': 'Un script instala el servidor TURN y de señalización de PasteFerry en una máquina '
                          'virtual Linux con una IP pública. Cada computadora se conecta directamente a él, '
                          'por lo que el portapapeles se sincroniza en casa, en la oficina y en cualquier '
                          'otro lugar. Cubre el grupo de seguridad, verificación, configuración de '
                          'aplicaciones y dominios en China continental.',
           'h1': 'Ejecútelo en un servidor público.',
           'lede': 'Una máquina virtual Linux con una IP pública; el más pequeño es suficiente. Cada '
                   'computadora se conecta directamente y se sincroniza en casa, en la oficina o en '
                   'cualquier otro lugar, sin necesidad de instalar nada adicional.',
           'toc': [('prepare', 'Antes de empezar'),
                   ('ports', 'Puertos abiertos'),
                   ('install', 'Instalar'),
                   ('check', 'comprobar'),
                   ('clients', 'Configurar las aplicaciones'),
                   ('faq', 'Preguntas')],
           'step': 'Paso {n}',
           'overview_h2': 'Cada computadora se conecta a él.',
           'overview_intro': 'El servidor está en la Internet pública, por lo que todas las computadoras '
                             'pueden acceder a él desde cualquier red en la que se encuentre. Lo que copias '
                             'va directamente entre las dos computadoras cuando es posible; cuando eso '
                             'falla, se transmite a través del servidor, aún encriptado.',
           'diagram': {'title': 'PasteFerry con un servidor público',
                       'desc': 'El servidor público está en 203.0.113.10. Una Mac en una red de oficina y '
                               'una PC Windows en una red doméstica se conectan a ella para realizar '
                               'señales; el contenido copiado va directamente entre ellos y a través del '
                               'relé del servidor si eso falla.',
                       'server': 'servidor publico',
                       'server_sub': 'VM en la nube con una IP pública',
                       'office': 'Red de oficinas',
                       'home': 'Red doméstica',
                       'client': 'Ejecutando PasteFerry',
                       'sig_note': 'Señalización, TCP 8787',
                       'relay_note': 'Retransmisión sobre UDP, si falla el directo',
                       'direct': 'Directa'},
           'overview_points': ['Señalización<strong>, TCP 8787.</strong> Cada computadora permanece '
                               'conectada a ella para encontrar las demás, emparejarlas e intercambiar '
                               'detalles de conexión.',
                               '<strong>Directo.</strong> Las computadoras en diferentes redes se conectan '
                               'directamente a través de perforación NAT, que funciona en la mayoría de las '
                               'redes domésticas y de oficina.',
                               'Relé<strong>, UDP 3478 y puertos de relé.</strong> Cuando falla una ruta '
                               'directa, el servidor reenvía el tráfico, aún cifrado y limitado por su ancho '
                               'de banda.'],
           'prep': [('Una máquina virtual en la nube',
                     'Linux en x86_64 o ARM64; el tamaño más pequeño es suficiente, ya que el servidor '
                     'utiliza unos 15 MB de RAM. Necesitas raíz.'),
                    ('Una IP pública',
                     'La propia IP pública del VM funciona; lo mejor es uno estático (elástico). Si cambia, '
                     'todas las computadoras deben actualizarse.'),
                    ('una manera de entrar', 'ssh, o el terminal web en la consola de su proveedor.'),
                    ('Máquinas virtuales en China continental',
                     'Sin una presentación ICP para el dominio, ingrese la IP en las aplicaciones, no el '
                     'dominio; consulte las preguntas <a href="#faq"></a>.')],
           'ports_h2': 'Abra los puertos en el grupo de seguridad.',
           'ports_intro': 'En la consola de su proveedor de nube, agregue estas tres reglas de entrada al '
                          'grupo de seguridad de la VM.',
           'rules_url': 'Consola en la nube › Grupo de seguridad › Reglas de entrada',
           'rules_cols': ['Protocolo', 'Rango de puertos', 'Fuente', 'Propósito'],
           'rules': [('TCP', '8787', '0.0.0.0/0', 'Señalización'),
                     ('UDP', '3478', '0.0.0.0/0', 'STUN y GIRAR'),
                     ('UDP', '32768-60999', '0.0.0.0/0', 'Puertos de retransmisión')],
           'rules_label': 'Reglas de entrada en un grupo de seguridad en la nube (ilustración): TCP 8787 '
                          'para señalización, UDP 3478 para STUN y TURN, UDP 32768-60999 para puertos de '
                          'retransmisión, todos desde 0.0.0.0/0',
           'ports_notes': ['<strong>Diferentes nombres:</strong> algunos proveedores lo llaman firewall o '
                           'ACL de red; es la misma configuración.',
                           '<strong>Los puertos de retransmisión</strong> los asigna el sistema operativo; '
                           'el rango depende del servidor. Ejecute <code>cat '
                           '/proc/sys/net/ipv4/ip_local_port_range</code> para verlo; el script de '
                           'instalación también lo imprime.',
                           '<strong>Firewall del sistema:</strong> si ufw o firewalld están activos, abra '
                           'los mismos puertos allí; el script de instalación imprime los comandos.'],
           'install_h2': 'Ejecute el script de instalación',
           'install_intro': 'Dale al script la IP pública. Instala el servidor, registra un servicio systemd '
                            'que se inicia al arrancar e imprime la dirección para ingresar en las '
                            'aplicaciones.',
           'install_steps': ['Inicia sesión con ssh, por ejemplo <code>ssh root@203.0.113.10</code> con tu '
                             'IP pública.',
                             'Ejecute estas líneas, con su IP pública en la última:<span class="aside">En '
                             'ARM, reemplace <code>amd64</code> con <code>arm64</code>.</span>',
                             'La dirección <code>ws://203.0.113.10:8787/signal</code> al final es la que '
                             'ingresas en las aplicaciones.'],
           'install_notes': ['<strong>Registra un servicio systemd</strong> que se inicia en el arranque; la '
                             'configuración es <code>/etc/pasteferry/server.env</code>.',
                             'Actualización<strong>:</strong> descargue la nueva versión, extráigala y '
                             'ejecute <code>sudo ./install.sh</code> nuevamente; su configuración se '
                             'mantiene.',
                             '<strong>Docker también funciona:</strong> consulte la guía de implementación '
                             'del servidor <a href="{deploy}"></a>.'],
           'term_label': 'Salida de sudo ./install.sh 203.0.113.10: instala, escribe la unidad systemd y la '
                         'configuración e inicia el servidor, luego imprime la dirección '
                         'ws://203.0.113.10:8787/signal',
           'check_h2': 'Comprueba que sea accesible',
           'check_intro': 'Abra <code>http://203.0.113.10:8787/healthz</code> (con su IP pública) en un '
                          'navegador en cualquier computadora. Si ve esta línea, funciona.',
           'check_label': 'Un navegador que muestra http://203.0.113.10:8787/healthz, con el estado del '
                          'servidor ok y su versión.',
           'clients_steps': [('Abrir configuración',
                              'Abra PasteFerry en cada computadora y vaya a Configuración → Conexión.'),
                             ('Introduzca la dirección pública',
                              'En Servidor personalizado, ingrese <code>ws://203.0.113.10:8787/signal</code> '
                              'con su IP pública y presione Retorno o Intro.'),
                             ('comprobar el estado',
                              'Cuando Conexión muestra un Conectado verde, estás listo. Si aún no lo has '
                              'emparejado, hazlo en Dispositivos.')],
           'clients_alt': 'Configuración de PasteFerry → Conexión: El servidor personalizado es '
                          'ws://203.0.113.10:8787/signal y el estado de la conexión muestra Conectado',
           'faq': [('Funciona por IP pero no por dominio',
                    ['Los proveedores de nube en China continental interceptan solicitudes simples HTTP para '
                     'dominios sin presentación ICP y responden con una redirección a una página de bloqueo; '
                     'en nuestras pruebas se incluyeron puertos no estándar como 8787. El protocolo de '
                     'enlace WebSocket también es una solicitud HTTP , por lo que se intercepta y la '
                     'aplicación muestra No conectado.',
                     'En su lugar, ingrese la IP del servidor, como en '
                     '<code>ws://server-ip:8787/signal</code>, o archive el dominio.']),
                   ('¿Qué tamaño de servidor necesito?',
                    ['El más pequeño. El servidor utiliza unos 15 MB de RAM y normalmente sólo reenvía unos '
                     'pocos mensajes de señalización. El contenido pasa directamente entre computadoras '
                     'cuando es posible; sólo las transferencias retransmitidas están limitadas por el ancho '
                     'de banda del servidor.']),
                   ('Los dispositivos muestran Retransmisión en lugar de Directo',
                    ['El relé justo después de conectarse y luego el directo un poco más tarde es normal: el '
                     'relé lo pone en marcha y la ruta directa toma el control mientras está inactivo. '
                     'Permanecer en Relay significa que las dos computadoras no pueden comunicarse entre sí '
                     'directamente, generalmente debido a una NAT que aleatoriza los puertos o a un firewall '
                     'estricto. Todavía está cifrado, sólo que limitado por el ancho de banda del '
                     'servidor.']),
                   ('¿Puedo usar HTTPS (wss://)?',
                    ['Sí, detrás de un proxy inverso HTTPS que admite actualizaciones de WebSocket ; ingrese '
                     'una dirección que comience con <code>wss://</code>. Los dominios en China continental '
                     'necesitan una presentación ICP. STUN y TURN usan UDP y omiten el proxy, así que '
                     'mantenga esos puertos abiertos.']),
                   ('La conexión de mi casa tiene una IP pública. ¿Puedo usar eso?',
                    ['Sí, pero es más trabajo que una máquina virtual: reenvíe TCP 8787, UDP 3478 y una '
                     'amplia gama de puertos de retransmisión UDP a esa computadora, y la IP de su hogar '
                     'puede cambiar. Si todas sus computadoras están en casa, no necesitan ningún servidor '
                     'en la misma red <a href="{lan}"></a>; para sincronizar entre redes sin reenvío de '
                     'puertos, consulte <a href="{ts}">Tailscale</a>.'])],
           'closing': 'Una máquina virtual en la nube, sincronización<br>desde cualquier lugar.',
           'source': 'Guía completa del servidor, incluido Docker y todas las opciones'},
 'start': {'title': 'Inicio rápido: configure PasteFerry en tres pasos',
           'description': '¿Nuevo en PasteFerry? Instale la aplicación en cada computadora. En la misma red, '
                          'simplemente empareje; en diferentes redes, active Servicio. Luego copie en una '
                          'computadora y péguela en la otra.',
           'h1': 'Inicio rápido',
           'lede': 'Instala la aplicación, conecta los dispositivos y empareja con un código.',
           'toc': [('app', 'Instalar la aplicación'),
                   ('server', 'Elige una forma de conectarte'),
                   ('pair', 'par'),
                   ('phone', 'usando un teléfono')],
           'step': 'Paso {n}',
           'app_h2': 'Instale la aplicación en cada computadora',
           'app_intro': 'Uno en cada computadora que quieras sincronizar. Mac, Windows y Linux se mezclan '
                        'libremente.',
           'mac': ['Descargue el DMG, ábralo y arrastre PasteFerry a Aplicaciones.<span class="aside">Hay '
                   'uno para Apple Silicon y otro para Intel; la página de descarga te ayuda a '
                   'elegir.</span>',
                   'Ábrelo desde Aplicaciones.<span class="aside">La primera vez, macOS dice que no puede '
                   'verificar al desarrollador: vaya a Configuración del sistema → Privacidad y seguridad y '
                   'haga clic en Abrir de todos modos cerca de la parte inferior.</span>',
                   'Haga clic en Activar sincronización en segundo plano. Cuando macOS le pregunte sobre el '
                   'acceso al portapapeles y la búsqueda de dispositivos en su red local, permita ambos.'],
           'win': ['Ejecute PasteFerry-Setup.exe; no se necesitan derechos de administrador.<span '
                   'class="aside">Si ve "Windows protegió su PC", haga clic en Más información y luego en '
                   'Ejecutar de todos modos.</span>',
                   'Abra PasteFerry y haga clic en Activar sincronización en segundo plano. Permítalo si '
                   'Windows Firewall lo solicita. Después de cerrar la ventana, sigue ejecutándose en el '
                   'área de notificación.'],
           'linux': ['En Ubuntu, Debian y similares, instale el .deb; en otras distribuciones, extraiga el '
                     'archivo tar.gz y ejecute <code>install.sh</code> dentro.',
                     'Abra PasteFerry desde el menú de la aplicación y haga clic en Activar sincronización '
                     'en segundo plano.'],
           'app_alt': 'PasteFerry la primera vez que se abre, le pide que active la sincronización en '
                      'segundo plano',
           'server_h2': 'Elige una forma de conectarte',
           'server_intro': 'Conecta en local o elige el Servicio, tu servidor o Tailscale para dispositivos remotos.',
           'pair_h2': 'Empareja tus computadoras',
           'pair_intro': 'Empareje dos computadoras cualesquiera una vez y listo.',
           'pair_steps': ['En una computadora, abra Dispositivos y haga clic en Agregar dispositivo. Muestra '
                          'un código de 6 caracteres, válido por 5 minutos, y la dirección de esta '
                          'computadora debajo.',
                          'En la otra computadora, elija Agregar dispositivo → Ingrese un código. Con el '
                          'Servicio no hay IP para ingresar; solo a través de subredes o con Tailscale abre '
                          'el campo de dirección e ingresa la dirección de la otra computadora.',
                          'Ambas pantallas muestran las mismas dos líneas de huellas dactilares. '
                          'Verifíquelos carácter por carácter y luego confírmelo.<span class="aside">Esto '
                          'evita que cualquier persona en el medio se haga pasar por su dispositivo. No te '
                          'lo saltes.</span>'],
           'pair_alt': 'Agregar dispositivo: el código de emparejamiento K7MP2X, con la dirección de esta '
                       'computadora 192.168.1.20 debajo',
           'done_h2': 'Ahora copia algo.',
           'done_text': 'Copie texto, una imagen o un archivo en una computadora y presione ⌘V or Ctrl+V on '
                        'the other. Todo lo copiado de ambos lados queda en la historia.',
           'help': '¿Necesitas ayuda? <a href="{lan}#faq">Preguntas sobre la misma red</a> · <a '
                   'href="{ts}#faq">Preguntas sobre Tailscale</a> · <a href="{cloud}#faq">Preguntas sobre el '
                   'servidor público</a> · <a href="{issues}">Informar un problema</a>',
           'phone_h2': 'usando un teléfono',
           'phone_intro': 'Una vez que las computadoras estén emparejadas arriba, un teléfono puede unirse '
                          'en cualquier momento: escanee un código para la página web o instale la '
                          'aplicación Android .',
           'phone_toc': 'usando un teléfono',
           'web_h': 'La página web: nada que instalar',
           'web_steps': ['Computadora: abra Dispositivos › Transferencia web del teléfono, encienda el '
                         'interruptor y aparecerá un código.',
                         'Teléfono: escanea el código con la cámara o un navegador y dale un nombre al '
                         'teléfono.',
                         'Luego, el navegador del teléfono muestra los registros de la computadora: toque '
                         'Copiar para enviar un mensaje de texto al teléfono, o use Enviar para enviar '
                         'texto, fotos y archivos a la computadora.'],
           'apk_h': 'La aplicación Android : se empareja como otro ordenador',
           'apk_steps': ['Teléfono: <a href="{android}">descargue el APK</a> e instálelo (permita la '
                         'instalación desde fuentes desconocidas cuando se le solicite).',
                         'Computadora: Dispositivos → Agregar dispositivo → Mostrar un código.',
                         'Teléfono: introduce el código y confirma cuando las dos huellas coincidan.',
                         'Lo que copias en la computadora aparece en los registros y en el portapapeles del '
                         'teléfono.']},
 'lan': {'title': 'Utilice PasteFerry en una red: sin servidor, solo empareje',
         'description': 'Cuando sus computadoras comparten una red Wi-Fi o cableada, PasteFerry no necesita '
                        'servidor: instale la aplicación, ingrese un código de emparejamiento de 6 '
                        'caracteres y sincronice el portapapeles y los archivos entre Mac y Windows. En una '
                        'subred diferente, ingresa una dirección al realizar el emparejamiento.',
         'h1': 'En la misma red',
         'lede': 'Las computadoras detrás del mismo enrutador no necesitan un servidor. Instale la '
                 'aplicación, ingrese un código de emparejamiento y copie las sincronizaciones a partir de '
                 'ese momento.',
         'toc': [('prepare', 'Antes de empezar'),
                 ('pair', 'par'),
                 ('subnet', 'Diferentes subredes'),
                 ('faq', 'Preguntas')],
         'step': 'Paso {n}',
         'overview_h2': 'Sin servidor',
         'overview_intro': 'Dos computadoras en la misma red se encuentran a través de mDNS, intercambian '
                           'detalles de conexión directamente y abren una conexión directa cifrada. Sin '
                           'servidor ni computadora que deba permanecer encendida.',
         'diagram': {'title': 'PasteFerry en una red',
                     'desc': 'En una LAN, una Mac (192.168.1.20) y una PC Windows (192.168.1.35) se '
                             'encuentran a través de mDNS e intercambian detalles de conexión a través de '
                             'UDP 8788. El contenido copiado va directamente entre ellos; no hay servidor.',
                     'lan': 'LAN: la misma red Wi-Fi o cableada',
                     'client': 'Ejecutando PasteFerry',
                     'find_note': 'Encontrado a través de mDNS, detalles de conexión a través de UDP 8788',
                     'direct': 'Cifrado directo de extremo a extremo',
                     'direct_note': 'El contenido permanece entre las dos computadoras.'},
         'overview_points': ['<strong>Encontrado automáticamente.</strong> Cada computadora se anuncia en la '
                             'LAN a través de mDNS, con solo un token anónimo que cambia diariamente, por lo '
                             'que nadie puede saber de quién es la computadora. Su nombre se agrega solo '
                             'mientras la Búsqueda cercana está abierta.',
                             '<strong>Directo.</strong> El contenido va directamente entre las dos '
                             'computadoras, a la velocidad de su red.',
                             '<strong>Misma seguridad.</strong> Compara dos líneas de huellas dactilares al '
                             'realizar el emparejamiento y cada mensaje posterior está firmado, por lo que '
                             'otras personas en la red no pueden hacerse pasar por su dispositivo.'],
         'prep': [('la misma red',
                   'Ambas computadoras detrás del mismo enrutador; Wi-Fi y cableado pueden combinarse. Las '
                   'redes de invitados y Wi-Fi con aislamiento de cliente mantienen los dispositivos '
                   'separados y, en muchas oficinas, las redes cableadas y Wi-Fi son subredes separadas: '
                   'consulte <a href="#subnet">diferentes subredes</a> a continuación.'),
                  ('Firewall de Windows',
                   'En la primera ejecución, Windows pregunta si PasteFerry puede atravesar el firewall; '
                   'permitirlo. Si hizo clic en Cancelar, haga clic en Permitir en Configuración → Conexión '
                   'en PasteFerry, que solicita la aprobación del administrador una vez.'),
                  ('Red local en macOS',
                   'Desde macOS 15, la primera vez que llega a un dispositivo en su red, macOS pregunta si '
                   'PasteFerry Daemon puede encontrar dispositivos en su red local; permitirlo. Si lo '
                   'rechazó, actívelo en Configuración del sistema → Privacidad y seguridad → Red local.'),
                  ('Sin dirección de servidor',
                   'Deje el campo del servidor en Configuración → Conexión vacío. Para sincronizar entre '
                   'redes más tarde, active Servicio; Los dispositivos emparejados permanecen emparejados.')],
         'pair_h2': 'Empareja tus computadoras',
         'pair_intro': 'Empareje dos computadoras cualesquiera una vez. Si la aplicación aún no está '
                       'instalada, consulte el inicio rápido de <a href="{start}#app"></a>.',
         'pair_steps': ['En una computadora, abra Dispositivos y haga clic en Agregar dispositivo. Muestra '
                        'un código de 6 caracteres, válido por 5 minutos.',
                        'Por otro lado, haga clic en Agregar dispositivo también, cambie a Ingresar un '
                        'código, escríbalo y haga clic en Continuar.',
                        'Ambas pantallas muestran las mismas dos líneas de huellas dactilares. Verifíquelos '
                        'carácter por carácter y luego confírmelo. Copiando sincronizaciones a partir de '
                        'ahora.'],
         'pair_alt': 'Agregar dispositivo: el código de emparejamiento K7MP2X, con la dirección de esta '
                     'computadora 192.168.1.20 debajo',
         'nearby_h3': 'Sin código: Buscar cerca',
         'nearby_steps': ['En ambas computadoras, abra Dispositivos y haga clic en Buscar cerca. Solo '
                          'mientras esta ventana esté abierta los dispositivos de la red pueden ver el '
                          'nombre de esta computadora.',
                          'Cuando el otro aparezca en el radar, haz clic en él. Ambas pantallas muestran las '
                          'mismas dos líneas de huellas dactilares; verifíquelos y luego confirme en cada '
                          'uno.',
                          'Esto funciona solo dentro de una subred. Si la otra computadora no aparece, use '
                          'un código de emparejamiento como se indica arriba.'],
         'nearby_alt': 'Dispositivos cercanos: esta computadora en el medio, con Design PC y Meeting room '
                       'iMac a su alrededor, además de la MacBook Air ya emparejada',
         'subnet_h2': 'Diferentes subredes',
         'subnet_intro': 'El descubrimiento local solo llega a una subred. Cuando sus computadoras están en '
                         'diferentes subredes que aún pueden comunicarse entre sí, como en muchas oficinas, '
                         'ingresa una dirección al realizar el emparejamiento.',
         'subnet_steps': ['La computadora que muestra el código muestra su dirección debajo, como '
                          '<code>192.168.1.20</code>.',
                          'En la computadora que ingresa el código, haga clic en ¿En una subred diferente?, '
                          'ingrese esa dirección y haga clic en Continuar.',
                          'Después del emparejamiento, cada computadora recuerda la dirección de la otra. Si '
                          'uno cambia de dirección, el otro la vuelve a encontrar por sí solo; Si ambos '
                          'cambian, abra el menú... del dispositivo en Dispositivos y elija Ingresar su '
                          'dirección.'],
         'subnet_alt': 'Ingrese un código: el código K7MP2X, con el campo de dirección abierto debajo con '
                       '192.168.1.20',
         'subnet_after': 'Si las subredes no pueden comunicarse entre sí, como en el caso de una red de '
                         'invitados separada de la red de la oficina, el tráfico debe pasar a través de una '
                         'computadora a la que ambas puedan llegar: consulte <a href="{server}">ejecutar un '
                         'servidor en su LAN</a>.',
         'faq': [('No se puede encontrar la otra computadora',
                  ['Asegúrese de que ambos estén en la red con la sincronización en segundo plano activada. '
                   'Luego intente ingresar la dirección de la otra computadora en la que ingresa el código: '
                   'si eso funciona, están en subredes diferentes o la red bloquea mDNS.',
                   '¿Aún nada? Verifique el firewall de la otra computadora. En Windows, haga clic en '
                   'Permitir en Configuración → Conexión; en una Mac, asegúrese de que PasteFerry Daemon '
                   'esté activado en Configuración del sistema → Privacidad y seguridad → Red local y que el '
                   'firewall macOS no lo esté bloqueando.']),
                 ('¿Se sincroniza fuera de esta red?',
                  ['No, se reanuda cuando regresas. Para sincronizar entre redes, active el servicio <a '
                   'href="{official}"></a>o utilice un servidor público <a href="{cloud}"></a> o <a '
                   'href="{ts}">Tailscale</a>; Los dispositivos emparejados permanecen emparejados.']),
                 ('¿Qué pasa si una dirección cambia?',
                  ['Normalmente no hay nada que hacer. En una subred, mDNS vuelve a encontrar la computadora '
                   'en cualquier momento; a través de subredes, se vuelve a conectar siempre que una de las '
                   'dos mantenga su dirección. Si ambos cambian, ingrese la dirección una vez más en '
                   'Dispositivos.',
                   'Para una computadora de escritorio que nunca se mueve, puede reservar su dirección en la '
                   'configuración DHCP de su enrutador.']),
                 ('¿Pueden otros usuarios de la red ver mi computadora?',
                  ['Pueden ver que hay un dispositivo PasteFerry allí, pero no de quién: la transmisión '
                   'lleva un token anónimo que cambia diariamente, sin nombre ni ID del dispositivo. El '
                   'nombre se agrega solo mientras tiene abierta la Búsqueda cercana y se elimina cuando la '
                   'cierra. Los mensajes de dispositivos con los que no se ha vinculado se eliminan y el '
                   'emparejamiento requiere comparar las huellas digitales en ambas pantallas.']),
                 ('¿Qué puertos utiliza?',
                  ['UDP 8788 para detalles de conexión (un puerto aleatorio si se toma), UDP 5353 para mDNS '
                   'y otro puerto aleatorio UDP para los datos una vez conectados. No hay nada que '
                   'configurar en su enrutador.'])],
         'closing': 'Una red,<br>, nada que configurar.',
         'source': 'Notas de diseño sobre el modo de red local (en chino)'},
 'ts': {'title': 'Utilice PasteFerry en redes con Tailscale: sin servidor, hogar y oficina sincronizados',
        'description': 'Instale Tailscale en cada computadora bajo una cuenta e ingrese la dirección '
                       'Tailscale de la otra computadora al realizar el emparejamiento: sin IP pública, sin '
                       'servidor y sin computadora que deba permanecer encendida. El portapapeles se '
                       'sincroniza desde la oficina o desde cualquier otro lugar.',
        'h1': 'A través de redes con Tailscale',
        'lede': '¿No tienes una IP pública y no deseas ejecutar un servidor? Instale Tailscale en cada '
                'computadora e ingrese la dirección Tailscale de la otra computadora al realizar el '
                'emparejamiento. Se sincroniza en casa y en la oficina.',
        'toc': [('join', 'Instalar Tailscale'),
                ('address', 'Encuentra la dirección'),
                ('pair', 'par'),
                ('faq', 'Preguntas')],
        'step': 'Paso {n}',
        'overview_h2': 'Como si estuviera en una LAN',
        'overview_intro': 'Tailscale conecta sus dispositivos a una red privada: cada dispositivo que inicia '
                          'sesión en la misma cuenta obtiene una dirección fija que comienza con 100, '
                          'accesible desde los demás dondequiera que estén. PasteFerry recuerda la dirección '
                          'de la otra computadora cuando se empareja y se conecta como si ambas estuvieran '
                          'en una red.',
        'diagram': {'title': 'PasteFerry sobre Tailscale',
                    'desc': 'Una Mac en la oficina y una PC Windows en casa ejecutan Tailscale y cada una '
                            'tiene una dirección que comienza con 100 en la misma red privada. El contenido '
                            'copiado va directamente entre ellos; no hay servidor.',
                    'net': 'Red Tailscale : cada dispositivo tiene una dirección 100.x',
                    'mac_place': 'en la oficina',
                    'win_place': 'en casa',
                    'direct': 'Directo, cifrado dos veces',
                    'direct_note': 'El contenido permanece entre las dos computadoras.'},
        'overview_points': ['<strong>Sin servidor,</strong> y sin computadora que deba permanecer encendida: '
                            'dos computadoras que están encendidas y conectadas a Tailscale se sincronizan.',
                            '<strong>Introduzca la dirección una vez.</strong> Una dirección Tailscale no '
                            'cambia; lo ingresa al emparejar y las dos computadoras se encuentran a partir '
                            'de ese momento.',
                            '<strong>Cifrado dos veces.</strong> Dentro del túnel WireGuard de Tailscale se '
                            'ejecuta la propia conexión cifrada de extremo a extremo de PasteFerry. '
                            'Tailscale no puede ver el contenido.'],
        'prep': [('Una cuenta Tailscale',
                  'Gratis para uso personal; inicie sesión con Google, Microsoft, GitHub o Apple. Utilice la '
                  'misma cuenta en todos los dispositivos.'),
                 ('Tailscale en cada computadora',
                  'Hay clientes para Windows, macOS y Linux. Cada computadora que ejecuta PasteFerry lo '
                  'necesita, conectado.'),
                 ('PasteFerry instalado',
                  'La aplicación en cada computadora con sincronización en segundo plano activada; consulte '
                  'el inicio rápido de <a href="{start}#app"></a>. Deje la dirección del servidor vacía.'),
                 ('ZeroTier también funciona',
                  'Lo mismo ocurre con cualquier herramienta que proporcione a cada dispositivo una '
                  'dirección virtual fija: ingrese esa dirección al realizar el emparejamiento. Esta guía '
                  'utiliza Tailscale.')],
        'join_h2': 'Instale Tailscale en cada computadora',
        'join_intro': 'En cada computadora que sincronices, instálala e inicia sesión en la misma cuenta.',
        'join_steps': ['Descargue el cliente para su sistema desde el sitio web Tailscale e instálelo.<span '
                       'class="aside">En Linux, ejecute <code>curl -fsSL https://tailscale.com/install.sh | '
                       'sh</code>, entonces <code>sudo tailscale up</code>y abra el enlace que imprime para '
                       'iniciar sesión.</span>',
                       'Abra Tailscale e inicie sesión con la misma cuenta en todas las computadoras.',
                       'Luego, la consola de administración Tailscale enumera todos sus dispositivos, cada '
                       'uno con una dirección que comienza con 100.'],
        'join_download': 'Descargar Tailscale',
        'machines_cols': ['maquina', 'Dirección Tailscale', 'SO'],
        'machines_label': 'Lista de máquinas de la consola de administración Tailscale (ilustración): '
                          'macbook-pro es 100.88.20.5 y home-pc es 100.92.41.17',
        'join_notes_h3': 'Mantenga Tailscale conectado',
        'join_notes': ['<strong>Windows:</strong> , haga clic derecho en el ícono Tailscale en el área de '
                       'notificación y marque Ejecutar desatendido en Preferencias, para que permanezca '
                       'conectado después de cerrar sesión.',
                       '<strong>Mac:</strong> asegúrese de que Tailscale se abra al iniciar sesión.',
                       '<strong>Deshabilitar la caducidad de la clave:</strong> de forma predeterminada '
                       'Tailscale solicita a los dispositivos que inicien sesión nuevamente cada 180 días. '
                       'Para una computadora que rara vez cambia, abra el menú al final de su fila en la '
                       'página Máquinas y elija Desactivar la caducidad de la clave.'],
        'address_h2': 'Encuentre la dirección Tailscale de la otra computadora',
        'address_intro': 'En la computadora con la que se emparejará, haga clic en el ícono Tailscale (en la '
                         'barra de menú en una Mac, en el área de notificación en Windows) para ver su '
                         'dirección, o ejecute <code>tailscale ip -4</code> en una terminal.',
        'address_label': 'Al ejecutar tailscale ip -4 en PowerShell se imprime la dirección Tailscale de la '
                         'computadora, 100.92.41.17',
        'address_after': 'Los pasos siguientes utilizan <code>100.92.41.17</code>, la PC Windows en casa. '
                         'Utilice su propia dirección.',
        'pair_h2': 'Ingrese la dirección al emparejar',
        'pair_intro': 'Es como emparejar en una red, con una dirección adicional.',
        'pair_steps': ['En la PC Windows de su hogar, abra Dispositivos, haga clic en Agregar dispositivo y '
                       'anote el código de 6 caracteres.',
                       'En la Mac de la oficina, haga clic en Agregar dispositivo, cambie a Ingresar un '
                       'código y escríbalo; luego haga clic en ¿En una subred diferente?, ingrese '
                       '<code>100.92.41.17</code> y haga clic en Continuar.',
                       'Ambas pantallas muestran las mismas dos líneas de huellas dactilares. Compruébelos y '
                       'luego confirme. Las dos computadoras ahora se sincronizan dondequiera que estén.'],
        'pair_alt': 'Ingrese un código: el código K7MP2X, con la dirección Tailscale 100.92.41.17 en el '
                    'campo de dirección',
        'pair_after': 'Cuando ambas computadoras están en casa, PasteFerry también encuentra la otra en la '
                      'LAN directamente, por lo que los datos no se desvían.',
        'faq': [('Los dispositivos muestran Direct, pero es lento',
                 ['Directo en PasteFerry significa que las dos computadoras se conectan directamente en la '
                  'red Tailscale . Cuando Tailscale no puede conectarlos de igual a igual, los transmite a '
                  'través de sus servidores DERP, que pueden estar muy lejos.',
                  'Ejecute <code>tailscale ping other-address</code> en una terminal: a través de DERP '
                  'significa que Tailscale está retransmitiendo; a través de una IP y un puerto significa '
                  'que es de igual a igual. Las redes de oficinas y campus se transmiten con mayor '
                  'frecuencia; puede ejecutar su propio servidor DERP o probar con otra VPN de malla.']),
                ('El emparejamiento no puede encontrar la otra computadora',
                 ['Primero asegúrese de que Tailscale esté conectado en ambos: ejecute <code>tailscale ping '
                  'other-address</code> e inténtelo nuevamente una vez que responda.',
                  'Si el ping funciona pero el emparejamiento no, es probable que el firewall de la otra '
                  'computadora lo esté bloqueando. En Windows, haga clic en Permitir en Configuración → '
                  'Conexión en PasteFerry; en una Mac, active PasteFerry Daemon en Configuración del sistema '
                  '→ Privacidad y seguridad → Red local.']),
                ('¿Todas las computadoras necesitan Tailscale?',
                 ['Sí, una computadora sin él no puede alcanzar las direcciones 100.x. Las computadoras en '
                  'la misma red no lo necesitan; consulte la misma guía de red <a href="{lan}"></a>.']),
                ('Configuré un servidor en casa con la guía anterior. ¿Aún lo necesito?',
                 ['No. Borre la dirección del servidor en Configuración → Conexión en cada computadora y '
                  'desinstale el servidor en casa; Los dispositivos emparejados permanecen emparejados. '
                  'Conservarlo tampoco hace daño: un servidor y Tailscale trabajan juntos.']),
                ('¿Puede Tailscale ver lo que copio?',
                 ['No. Las conexiones Tailscale están cifradas de extremo a extremo con WireGuard y en su '
                  'interior se ejecuta la conexión cifrada PasteFerry propia de DTLS; sólo sus dos '
                  'computadoras pueden abrir cualquiera de las capas.  Los servidores de Tailscale solo '
                  'intercambian claves y direcciones de dispositivos, y sus retransmisiones reenvían '
                  'paquetes cifrados.']),
                ('¿Cambiará una dirección Tailscale ?',
                 ['Generalmente no. La dirección pertenece al dispositivo y sobrevive a reinicios y cambios '
                  'de red; solo cambia si elimina el dispositivo de Tailscale y lo agrega nuevamente. Si es '
                  'así, ingréselo una vez más en Dispositivos.']),
                ('Tengo un servidor público. ¿Necesito Tailscale?',
                 ['No. Ejecute el servidor en la máquina con la IP pública e ingrese esa dirección en cada '
                  'computadora; consulte la guía del servidor público <a href="{cloud}"></a>.'])],
        'closing': 'Sin servidor.<br>Su portapapeles viene con usted.',
        'source': 'Volver a la misma guía de red'},
 'download': {'phone': {'title': 'Teléfono (aplicación Android o página web)',
                        'apk': 'Descargar para Android (APK)',
                        'apk_note': 'Android 9 o posterior · ARM64',
                        'web_h': 'La página web (nada que instalar)',
                        'web_note': 'Active Dispositivos › Transferencia web telefónica en la computadora y '
                                    'escanee el código con su teléfono.',
                        'steps': ['Después de instalar la aplicación, empareje el teléfono desde '
                                  'Dispositivos en la computadora, de la misma manera que empareja otra '
                                  'computadora.',
                                  'O utilice la página web: active Dispositivos > Transferencia web del '
                                  'teléfono en la computadora y escanee el código.',
                                  'En el teléfono pega lo que copiaste y envíalo; lo que copias en la '
                                  'computadora aparece en los registros del teléfono.'],
                        'notes': ['Conecta el teléfono y el ordenador a la misma red.', 'En iPhone y iPad, usa la versión web.'],
                        'tab': 'Teléfono / web'},
              'title': 'Descargar PasteFerry: Mac (Apple Silicon, Intel), Windows y Linux',
              'description': 'PasteFerry para cada sistema: versiones Apple Silicon e Intel para macOS 13 o '
                             'posterior, un instalador y un zip portátil para Windows 10 y 11, y paquetes '
                             '.deb y tar.gz para Linux en x64 y ARM64. Gratis y de código abierto.',
              'h1': 'Descargar PasteFerry',
              'lede': 'Gratis y de código abierto · Versión {version}',
              'os_label': 'Elige tu sistema',
              'win': {'setup': 'Descarga el instalador',
                      'portable': '<a href="{portable}">Versión portátil</a>, sin instalación',
                      'steps': ['Ejecute PasteFerry-Setup.exe. Se instala para el usuario actual, no se '
                                'necesitan derechos de administrador.<span class="aside">Si ve "Windows '
                                'protegió su PC", haga clic en Más información y luego en Ejecutar de todos '
                                'modos.</span>',
                                'Abra PasteFerry y haga clic en Activar sincronización en segundo plano. '
                                'Permítalo si Windows Firewall lo solicita.'],
                      'notes': ['Windows 10 y Windows 11, x64.',
                                'El instalador pesa unos 23 MB, el zip portátil unos 29 MB.',
                                'Después de cerrar la ventana, PasteFerry sigue ejecutándose en el área de '
                                'notificación.']},
              'mac': {'apple': 'Chip Apple (M1+)',
                      'intel': 'Intel',
                      'universal': 'También hay una <a href="{universal}">versión universal</a>.',
                      'homebrew': (('Homebrew: <code>brew install --cask baiyuze/tap/pasteferry</code>. <a href="{homebrew}">Instalación y '
                                    'actualización</a>')),
                      'steps': ['Abra el DMG que descargó y arrastre PasteFerry a Aplicaciones.',
                                'Ábrelo desde Aplicaciones.<span class="aside">La primera vez, macOS dice '
                                'que no puede verificar al desarrollador: vaya a Configuración del sistema → '
                                'Privacidad y seguridad y haga clic en Abrir de todos modos cerca de la '
                                'parte inferior.</span>',
                                'Haga clic en Activar sincronización en segundo plano. Cuando macOS le '
                                'pregunte sobre el acceso al portapapeles y la búsqueda de dispositivos en '
                                'su red local, permita ambos.'],
                      'chip_h': '¿No estás seguro de qué chip?',
                      'chip': ['Haga clic en el menú Apple en la esquina superior izquierda de la pantalla y '
                               'elija Acerca de esta Mac.',
                               '"Chip: Apple M1" (o M2, M3, M4…) significa Apple Silicon; "Procesador:... '
                               'Intel Core..." significa Intel.',
                               'Casi todos los Mac comprados desde finales de 2020 tienen silicio de Apple. '
                               'Si elige el incorrecto, simplemente descargue el otro: en una Mac Apple '
                               'Silicon, la versión Intel necesita que Rosetta esté instalada primero, y la '
                               'versión Apple Silicon no se abre en una Mac Intel.',
                               'Requiere macOS 13 Ventura o posterior.']},
              'linux': {'deb_h': 'Ubuntu, Debian y derivados',
                        'tar_h': 'Otras distribuciones',
                        'x64': 'x64',
                        'arm64': 'ARM64',
                        'notes': ['Requiere GTK 3 y un escritorio X11 o Wayland con XWayland.',
                                  'Ejecuta <code>uname -m</code>: <code>x86_64</code> es x64; <code>aarch64</code> es ARM64.']},
              'more_h2': 'Más',
              'more': [('Servidor',
                        'Dos computadoras en la misma red no necesitan servidor. Las formas de conectarse a '
                        'través de redes se encuentran en el inicio rápido <a href="{server}"></a>; Cada '
                        'guía tiene su propio servidor de descarga.'),
                       ('sumas de control',
                        'Las sumas de comprobación SHA-256 de cada archivo están en <a '
                        'href="{sums}">SHA256SUMS</a>.'),
                       ('Novedades y versiones anteriores',
                        'Consulte las notas de la versión <a href="{notes}"></a> para conocer los cambios en '
                        'esta versión; Las versiones anteriores están en <a href="{releases}">GitHub '
                        'Versiones</a>.')]},
 'ld_description': 'Copie y pegue entre computadoras, busque el historial del portapapeles y envíe fotos y '
                   'archivos entre computadoras y Android. Mac, Windows, Linux, Android y una página web de '
                   'teléfono. Android y web funcionan en la misma red. Gratis y de código abierto.',
 'ld_os': 'macOS 13 o posterior (Intel y Apple Silicon); Windows 10, Windows 11 (x64); Linux (x64, ARM64)',
 'ld_currency': 'USD',
 'ld_features': ['Sincroniza texto sin formato, texto enriquecido, imágenes, archivos y carpetas',
                 'Funciona entre Mac, Windows y Linux, sin cuenta compartida, a través de redes',
                 'No se necesita servidor en la misma red, con descubrimiento automático de mDNS',
                 'Conexión directa WebRTC con retroceso automático del relé TURN',
                 'Cifrado DTLS de extremo a extremo con huellas dactilares verificadas por humanos en el '
                 'emparejamiento',
                 'Los elementos de menos de 50 MB se envían mediante copia, los archivos más grandes se '
                 'obtienen según demanda',
                 'Historial de los últimos 3 días, con vistas previas de imágenes.',
                 'Interfaz en 18 idiomas, incluido árabe (de derecha a izquierda)']}

FEATURES = {'nav_features': 'Características',
 'nav_more': 'Más',
 'nav_security': 'Seguridad',
 'nav_changelog': 'Registro de cambios',
 'nav_more_label': 'Más páginas',
 'gh_aria': 'Estrella PasteFerry en GitHub',
 'star_ask': '¿Te gusta? Destacalo en GitHub.',
 'star_button': 'Dar una estrella en GitHub',
 'demo_where': '¿Dónde están las dos computadoras?',
 'demo_wan': 'Hogar ↔ oficina',
 'demo_lan': 'Mismo wifi',
 'net_home': 'Inicio',
 'net_office': 'Oficina',
 'net_wifi': 'Wi‑Fi doméstico',
 'demo_server': 'El servidor solo los presenta.',
 'demo_no_server': 'Encontrado en la red local, sin servidor.',
 'demo_hint': 'Haga clic en cualquier cosa en Mac para copiarlo',
 'demo_image': 'Captura de pantalla.png',
 'demo_text': 'La reunión se trasladó a las 3:30, salón 4B',
 'demo_folder': 'activos de marca',
 'demo_copy': 'Copiar {item}',
 'demo_pasted': '{item} pegado en {device}',
 'theme_menu': 'Apariencia',
 'theme_system': 'Seguir el sistema',
 'theme_light': 'Claro',
 'theme_dark': 'Oscuro',
 'badge': '{version}: ajusta el tamaño del texto y los iconos a la vez →',
 'home_phone_h2': 'Tu teléfono se une.',
 'home_phone_intro': 'Intercambia contenido con el ordenador en la misma red, por Android o con un QR en el navegador.',
 'home_phone_points': ['<b>Utilice el navegador</b> para el historial y transferencias de archivos '
                       'separados.',
                       '<b>Android envía y recibe lotes</b> , con guardar y compartir.',
                       '<b>Misma red</b>; mantenga la página web abierta.'],
 'home_phone_link': 'Cómo usar el teléfono →',
 'home_send_h2': 'Arrástrelo.<br>Está ahí.',
 'home_send_intro': 'Arrastra archivos o carpetas al dispositivo de destino.',
 'home_send_link': 'Más sobre Enviar archivos →',
 'home_qp_h2': 'Recupera<br>lo que copiaste.',
 'home_qp_intro': 'Presiónelo en cualquier aplicación, elija un elemento y se pegará.',
 'home_qp_link': 'Más sobre pegado rápido →',
 'home_qp_alt': 'La ventana de pegado rápido: un campo de búsqueda y seis pestañas (Todos, Texto, Enlaces, '
                'Imágenes, Archivos, Favoritos), elementos del historial numerados y sugerencias clave en la '
                'parte inferior.',
 'grid_h2': 'Más que un portapapeles compartido.',
 'grid_more': 'Ver todas las funciones →',
 'grid': [('send',
           'Enviar archivos',
           'Suelte archivos o carpetas en otra computadora o en un contacto. Cualquier tamaño.',
           True),
          ('keys',
           'Pegado rápido',
           'Presione {key} para ver su historial; Elija un elemento y se pegará.',
           False),
          ('folder',
           'Archivos y carpetas',
           'Los archivos pequeños se sincronizan a medida que los copia y los grandes cuando los necesita.',
           False),
          ('clock',
           'Historia y favoritos',
           'Todo copiado en cada dispositivo, con capacidad de búsqueda.',
           False),
          ('globe',
           'A través de redes',
           'Active el Servicio para sincronizar entre el hogar y el trabajo.',
           False),
          ('lock',
           'Cifrado de extremo a extremo',
           'Directo primero. El servidor no puede ver lo que copias.',
           False)],
 'new_tag': 'Novedades',
 'kicker_new': 'Nuevo en 2.6',
 'title': 'Funciones: Enviar archivos, pegar rápidamente, favoritos, historial en todos los dispositivos — '
          'PasteFerry',
 'description': 'PasteFerry sincroniza el portapapeles entre Mac, Windows y Linux: copie texto, imágenes, '
                'archivos o carpetas y péguelos en la otra computadora. Presione ⌥V or Alt+V for quick '
                'paste, mantenga favoritos, busque o filtre su historial y envíe archivos de cualquier '
                'tamaño directamente a otra computadora.',
 'eyebrow': 'Características de PasteFerry',
 'h1': 'Copie y pegue,<br>como debería ser.',
 'lede': 'Portapapeles sincronizado, historial y transferencia de archivos.',
 'hero_alt': 'Historial de PasteFerry: una barra lateral con Historial, Favoritos, Enviar archivos, '
             'Dispositivos y Configuraciones, y una lista de texto, imágenes, archivos y enlaces de '
             'diferentes computadoras',
 'sync_h2': 'Copia aquí.<br>Pegar allí.',
 'sync_intro': 'Copia y pega texto, imágenes, archivos y carpetas.',
 'sync_facts': [('Texto, imágenes, archivos, carpetas.', 'Pega limpiamente en campos de texto sin formato.'),
                ('Se envían hasta 50 MB al copiar',
                 'Artículos más grandes bajo demanda. El límite es ajustable.'),
                ('Pausa en cualquier momento', 'Pausa todo, o solo una computadora.')],
 'send_h2': 'Cualquier tamaño.<br>Simplemente arrástrelo.',
 'send_intro': 'Arrastra archivos o carpetas al dispositivo de destino.',
 'send_points': [('Cualquier tamaño', 'Vídeos de varios GB o carpetas con miles de archivos.'),
                 ('Continúa donde se detuvo',
                  'Se reanuda después de una caída de la conexión o de una suspensión. Cada archivo está '
                  'verificado.'),
                 ('Archivos recibidos en un solo lugar',
                  'Guardado en Descargas de forma predeterminada, un clic para mostrar.')],
 'send_note': 'Transferencias directas ilimitadas; retransmisión del Servicio: 100 MB por ordenador al día.',
 'send_alt': 'La página Enviar archivos: un radar con esta Mac en el medio y dispositivos en la misma red y '
             'en otros lugares a su alrededor; a la derecha, archivos recibidos, con una carpeta que llega y '
             'su progreso y velocidad',
 'theme_kicker': 'Nuevo en 2.10',
 'theme_h2': 'Hazlo tuyo.<br>Incluso en píxeles.',
 'theme_intro': 'Nueve temas incluidos. Personalízalos o créalos con IA.',
 'theme_points': [('Tema de píxeles',
                   'Tipo mapa de bits, bloques con muescas y botones biselados. Una escena nocturna o diurna '
                   'arriba, un avión de papel mientras envía y una explosión de estrellas cuando termina.'),
                  ('Temas personalizados',
                   'Duplica un tema integrado, importa o exporta archivos de temas. Se le advierte cuando el '
                   'texto será difícil de leer.'),
                  ('Pregúntale a una IA',
                   'Agrega <code>pasteferry-cli mcp</code> a Claude, Cursor y otros, luego di "hazme un tema '
                   'cyberpunk". Está creado y aplicado.')],
 'theme_note': 'Los temas se guardan solo en este dispositivo.',
 'theme_alt': 'La página Apariencia en Configuración (tema de píxeles, oscuro): miniaturas de los temas '
              'predeterminados y de píxeles integrados y dos temas personalizados, luego importar tema, '
              'pedirle a AI que cree un tema, claro y oscuro, y líneas de exploración.',
 'theme_alt_light': 'Historia en el tema Pixel (claro): nubes y colinas en el encabezado y una pequeña casa '
                    'en la parte inferior de la barra lateral',
 'theme_alt_send': 'Enviar archivos en el tema Pixel (oscuro): montañas nocturnas y una luna en el '
                   'encabezado, un radar punteado y dispositivos de bloques de píxeles',
 'home_theme_h2': 'Hazlo tuyo.<br>Incluso en píxeles.',
 'home_theme_intro': 'Los temas están aquí: una apariencia de píxeles incorporada, sus propios temas o uno '
                     'que una IA diseña para usted.',
 'home_theme_alt': 'Historia en el tema Pixel (oscuro): montañas nocturnas, pinos y una luna en el '
                   'encabezado, una tienda de campaña y una fogata en la parte inferior de la barra lateral '
                   'y tipo de mapa de bits',
 'home_theme_link': 'Más sobre temas →',
 'friends_h2': 'La computadora de un amigo,<br>, igual de fácil.',
 'friends_intro': 'Añade a un amigo y envíale archivos.',
 'friends_points': [('Ellos deciden lo que entra.',
                     'Vea quién envió qué antes de aceptarlo o acepte automáticamente a personas de su '
                     'confianza.'),
                    ('Tú decides quién puede enviar',
                     'Nadie, solo contactos o todos en tu red durante 10 minutos.'),
                    ('Archivos, no chat',
                     'Los contactos nunca ven su portapapeles, historial o dispositivos.')],
 'friends_note': 'Entre redes, activad el Servicio en ambos lados.',
 'friends_alt': 'La página Enviar archivos: los avatares de los contactos debajo del radar y una solicitud '
                'en el medio (un contacto en una MacBook Air quiere enviarle archivos, con una nota) que '
                'puede rechazar o aceptar.',
 'home_friends_link': 'Más sobre enviar a contactos →',
 'phone_kicker': 'Nuevo en 2.8',
 'phone_alt': 'La página de dispositivos transferencia web telefónica: el código y los teléfonos registrados',
 'phone_h2': 'Tu teléfono se une.',
 'phone_intro': 'Intercambia contenido con el ordenador en la misma red, por Android o con un QR en el navegador.',
 'phone_points': [('Usa el navegador', 'para historial y transferencias de archivos separados.'),
                  ('Android envía y recibe', 'lotes, con guardar y compartir.'),
                  ('Misma red', '; mantenga la página web abierta.')],
 'phone_note': 'En iPhone y iPad, mantén abierta la versión web.',
 'qp_h2': 'Pulsa {key}.<br>Elige y pega.',
 'qp_intro': 'Busca en el historial y pega un elemento.',
 'qp_steps': [('Presione {key}', 'Funciona en cualquier aplicación.'),
              ('Escribe algunas letras', 'Busque texto y nombres de archivos, o presione {index}.'),
              ('Presione {enter}. Hecho.',
               '{plain} para texto sin formato, {copyonly} para copiar únicamente.')],
 'qp_note': 'Puede cambiar o desactivar el acceso directo. Pegar en una Mac necesita permiso de '
            'Accesibilidad.',
 'qp_label': 'Demostración: mientras escribe un correo electrónico, presione ⌥V; Se abre la ventana de '
             'pegado rápido, al escribir "reunión" se encuentra el enlace de la reunión y Volver lo pega en '
             'el correo electrónico.',
 'mail_window': 'Nuevo mensaje',
 'mail_to_label': 'Para:',
 'mail_to': 'equipo',
 'mail_subject_label': 'Asunto:',
 'mail_subject': 'Se movió la sincronización semanal',
 'mail_body': ['Hola a todos,', 'La sincronización semanal pasa al jueves a las 3 p.m. Enlace:'],
 'qp_typing': [('m', False), ('yo', False), ('yo', False), ('reunirse', False), ('reunión', False)],
 'qp_rows': [('text', 'Envíame la baraja antes de las 7 pm', 'Ahora mismo', False, False),
             ('link', 'https://github.com/baiyuze/pasteferry', 'hace 2 minutos', False, False),
             ('image', 'Imagen', 'Windows PC · Hace 5 minutos', True, False),
             ('files', 'contrato-firmado.pdf y 2 más', 'Hace 52 minutos', False, False),
             ('text', 'Enlace de reunión: https://meeting.example.com/j/8823', 'Hace 1 hora', True, True),
             ('text', 'docker compose up -d --build', 'Hace 1 hora', False, False),
             ('text', 'Las notas de la reunión están en la carpeta compartida.', 'ayer', False, True),
             ('text', 'pnpm install', 'ayer', False, False)],
 'fav_h2': 'Conserva lo que reutilizas.',
 'fav_intro': 'Los favoritos se conservan, con una copia separada de los archivos.',
 'fav_points': [('Nunca limpiado', 'La historia expira; Los favoritos se quedan.'),
                ('Una copia propia', 'Cambiar o eliminar el original no lo afecta.'),
                ('En pasta rápida también', 'También en pasta rápida; presione {fav} para agregar.')],
 'fav_alt': 'La página de Favoritos: cinco elementos guardados que incluyen una plantilla de informe, una '
            'respuesta de stock, un enlace de descarga y un PDF, cada uno con una estrella azul',
 'details_h2': 'Más funciones',
 'filter_title': 'Los enlaces tienen su propia pestaña',
 'filter_text': 'Texto, enlaces, imágenes, archivos: un clic para filtrar.',
 'filter_rows': [('text', 'La reunión se trasladó al jueves a las 3 p.m.', False),
                 ('link', 'https://github.com/baiyuze/pasteferry', False),
                 ('image', 'Imagen · 2,4 MB', False),
                 ('file', 'Revisión del tercer trimestre: final.key', False),
                 ('link', 'https://pasteferry.cc/download/', True),
                 ('text', 'Informe semanal: terminado / la próxima semana', True)],
 'hover_title': 'Coloca el cursor para verlo todo',
 'hover_text': 'Pase el cursor para ver el artículo completo.',
 'hover_alt': 'El puntero se apoya en las notas de la reunión y una tarjeta muestra el texto completo: '
              'propietarios, ventana de lanzamiento y seguimiento.',
 'search_title': 'Busca lo que copiaste',
 'search_text': 'Busque por texto o nombre de archivo. Se mantiene 3 días por defecto, hasta 30.',
 'search_query': 'contrato',
 'search_hits': ['contrato-firmado.pdf', 'Cláusula 3 del contrato: cambio a pagos trimestrales'],
 'big_title': 'Archivos grandes, cuando los necesita',
 'big_text': 'Más de 50 MB se sincronizan primero como registro; haga clic en Recibir para transferir.',
 'big_file': 'lanzamiento-demo.mov',
 'big_meta': 'Desde Mac mini · 1,3 GB',
 'big_button': 'Recibir',
 'folder_title': 'Carpetas enteras también',
 'folder_text': 'Copie una carpeta, pegue la misma carpeta.',
 'names_from': 'Notas 10:30?.md',
 'names_to': 'Notas 10：30？.md',
 'names_title': 'Nombres que funcionan en todas partes',
 'names_text': 'Los personajes Windows no permiten convertirse en dobles de ancho completo.',
 'net_h2': 'Hogar y oficina,<br>conectados directamente.',
 'net_intro': 'Empareja en la misma red o usa el Servicio, tu servidor o Tailscale entre redes.',
 'net_points': [('Misma red', 'Sin servidor. Ingrese un código de emparejamiento y listo.'),
                ('A través de redes', 'Servicio, su propio servidor o Tailscale.'),
                ('Cifrado de extremo a extremo',
                 'Verifique las huellas dactilares al emparejar; el servidor nunca ve su contenido.')],
 'net_links': 'Elige cómo conectarte →',
 'net_how': 'Cómo funciona →',
 'net_label': 'Diagrama: dos computadoras en una red doméstica y otra de oficina se encuentran a través del '
              'Servicio y luego se conectan directamente',
 'net_service': 'Servicio',
 'net_direct': 'Directo · cifrado de extremo a extremo',
 'numbers_h2': 'Por los números.',
 'numbers': [('3', 'sistemas', 'macOS, Windows, Linux'),
             ('50 MB', '', 'enviado como copia'),
             ('≈330 ms', '', 'para un archivo de 20 MB a través de una LAN'),
             ('0', 'cuentas', 'sin registrarse, solo emparejar')],
 'closing': 'Pruébalo ahora.',
 'how_title': 'Cómo funciona PasteFerry : conexiones directas, sondeo de múltiples enlaces ascendentes y '
              'manejo de fallas',
 'how_lede': 'Qué sucede cuando copias, cómo se conectan las computadoras y qué sucede cuando no pueden '
             'hacerlo.',
 'security_title': 'Seguridad y privacidad: cifrado de extremo a extremo y verificación de emparejamiento — '
                   'PasteFerry',
 'security_lede': 'Cifrado de extremo a extremo y verificación de huellas al emparejar.',
 'privacy_link': 'Política de privacidad →',
 'faq_title': 'Preguntas frecuentes: PasteFerry',
 'faq_lede': '¿No encuentras una respuesta? Háganoslo saber.',
 'faq_more': 'Informar un problema →'}

TOUR = {'opening_1': 'Copiar entre dos computadoras',
 'opening_2': 'No debería ser tanto trabajo.',
 'pain_chat': 'Enviándotelo a ti mismo',
 'pain_chat_detail': 'Envíe, abra, descargue y luego busque el archivo',
 'airdrop': 'AirDrop',
 'pain_airdrop_detail': 'Acepta cada vez. Aún no hay sincronización del portapapeles.',
 'universal': 'Portapapeles universal',
 'pain_universal_detail': 'Mismo Apple ID, y los dispositivos deben estar cerca',
 'pain_cross_platform': 'Entre Mac y Windows',
 'pain_cross_platform_detail': 'Ninguna de las opciones integradas funciona.',
 'simpler': 'Puede ser mucho más sencillo.',
 'tagline': 'Copie en esta computadora. Pega ese.',
 'notes': 'Notas',
 'decision_1': 'Lanzamiento al 10% el martes.',
 'decision_2': 'Todos los usuarios el jueves si todo va bien.',
 'screenshot': 'Captura de pantalla.png',
 'notepad': 'Notas de reunión.txt - Bloc de notas',
 'word': 'Informe semanal.docx - Word',
 'demo_file': 'Copie un archivo en Mac. Pégalo en Windows.',
 'demo_text': 'Y viceversa: copiar en Windows, pegar en Mac.',
 'demo_image': 'Capturas de pantalla también. Se pegan como imágenes.',
 'types': 'Lo que copias es lo que pegas',
 'text': 'Texto',
 'rich_text': 'Texto con formato',
 'images': 'Imágenes',
 'files': 'Archivos',
 'folders': 'Carpetas enteras',
 'small_files': '¿Menos de 50 MB? La transferencia comienza a medida que copia.',
 'large_files': 'Los archivos más grandes llegan a pedido, con un solo clic.',
 'history_1': 'Todo lo que copiaste,',
 'history_2': 'todo en un solo lugar',
 'retention': '3 días de historial por defecto',
 'restore': 'Haga clic para copiarlo nuevamente',
 'preview': 'Vista previa de imágenes en su lugar',
 'pull': 'Extraiga archivos grandes cuando los necesite',
 'pairing': 'Empareja una vez y listo',
 'nearby': 'En la misma red, busque una computadora cercana y emparéjela',
 'fingerprints': 'Comprueba las huellas dactilares en ambas pantallas antes de confirmar.',
 'networks': 'Una red o muchas. Tu elección.',
 'home': 'En casa o en la oficina,',
 'lan_detail': 'no hay servidor para configurar',
 'cloud_detail': 'Aloje una pequeña máquina virtual en la nube,',
 'anywhere': 'sincronizar desde cualquier lugar',
 'across': 'A través de redes,',
 'tailscale_detail': 'sin tu propio servidor',
 'encrypted': 'Una conexión directa cuando sea posible. Cifrado de extremo a extremo.',
 'relay': 'En el modo servidor, su servidor transmite datos cifrados si falla un enlace directo.',
 'comparison': 'como se compara',
 'free': 'Gratis y de código abierto',
 'download': 'Descarga',
 'source': 'Fuente',
 'closing': 'Menos enviar cosas. Más hacer las cosas.'}

TOUR_UI = {'watch': 'Mira el recorrido completo',
 'title': 'Conozca PasteFerry en 85 segundos',
 'play': 'Jugar',
 'pause': 'Pausa',
 'replay': 'Reproducir',
 'progress': 'Posición de reproducción',
 'chapters': 'Elige un capítulo',
 'fullscreen': 'Pantalla completa',
 'exit_fullscreen': 'Salir de pantalla completa',
 'close': 'Cerrar recorrido',
 'back': 'Volver al sitio',
 'summary': 'Lo más destacado del tour',
 'silent': 'Gira silenciosa'}

TOUR_CHAPTERS = ['demasiados pasos',
 'Conoce a PasteFerry',
 'Copiar y pegar',
 'Qué puedes sincronizar',
 'Historial del portapapeles',
 'Emparejamiento seguro',
 'Formas de conectarse',
 'Comparar opciones',
 'empezar']

THEMES = {'name': 'guía de temas',
 'title': 'Guía de temas — PasteFerry',
 'summary': 'Cambie temas en PasteFerry, cambie claro y oscuro, cree su propio tema y permita que '
            'aplicaciones de inteligencia artificial como Claude y Cursor diseñen y apliquen temas sobre '
            'MCP.',
 'fit': 'Temas y apariencia',
 'lede': 'Nueve temas incluidos, modos claro y oscuro, colores y fondos personalizados.',
 'download': 'Descargar 2.12.1',
 'jump_ai': 'Saltar a temas creados por IA ↓',
 'switch_title': 'cambiar el tema',
 'switch_steps': ['Abra PasteFerry y vaya a Configuración <b>› Apariencia</b>.',
                  'Haga clic en un tema en Integrado o Personalizado. La ventana cambia de inmediato, al '
                  'igual que Quick Paste.',
                  'En Claro y oscuro, elija <b>Sistema de coincidencia</b>, <b>Claro</b> o <b>Oscuro</b>.',
                  'Con un tema de píxeles también puede activar <b>Scanlines</b>, líneas CRT tenues en toda '
                  'la ventana.',
                  'En Android, elija en la configuración <b>› Apariencia</b>de la aplicación; Las '
                  'computadoras y los teléfonos no se afectan entre sí.'],
 'switch_alt': 'Configuración › Apariencia: los temas predeterminados y de píxeles integrados, dos temas '
               'personalizados, importar tema, pedirle a AI que cree un tema, claro y oscuro, y líneas de '
               'escaneo',
 'builtin_title': 'Nueve temas integrados',
 'builtin': [('Predeterminado',
              'El aspecto silencioso y estilo sistema que siempre ha tenido el PasteFerry .'),
             ('Píxel',
              'Tipo de mapa de bits, bordes con muescas y botones biselados, paletas de grafito y papel con '
              'píxeles verdes. Una escena nocturna o diurna arriba, un avión de papel mientras envía y una '
              'ráfaga de estrellas cuando llega.'),
             ('Discos de jazz',
              'Geometría de funda de disco, azul cobalto, papel cálido y títulos condensados.'),
             ('Era espacial',
              'Esmalte naranja, tonos plateados, ilustraciones orbitales y controles de cápsula.'),
             ('Menfis', 'Rosa y amarillo, collage geométrico y contornos fuertes.'),
             ('Futuro Y2K', 'Azul eléctrico, estrellas cromadas y controles digitales redondeados.'),
             ('Impresión vintage', 'Crema y rojo cálido, puntos de semitono e ilustraciones de billetes.'),
             ('Arcade de píxeles',
              'Controles portátiles tipo inventario de color verde, tipo mapa de bits y con muescas.'),
             ('Escritorio retro',
              'Verde azulado y gris, botones cuadrados biselados e ilustraciones clásicas de ventanas.')],
 'builtin_alt_default': 'Historia en el tema predeterminado (claro)',
 'builtin_alt_pixel': 'Historia en el tema Pixel (oscuro): montañas y una luna en el encabezado, una tienda '
                      'de campaña y una fogata en la parte inferior de la barra lateral',
 'custom_title': 'Haz tu propio tema',
 'custom_intro': 'La forma más sencilla es duplicar un tema integrado y cambiarlo:',
 'custom_steps': ['En Configuración <b>› Apariencia</b>, coloque el cursor sobre un tema, haga clic en '
                  '<b>⋯</b> y elija <b>Duplicar</b>. La copia aparece en Personalizado.',
                  'En el menú <b>⋯</b> de la copia, elija <b>Exportar…</b> para guardar un archivo '
                  '<code>.pasteferry-theme.json</code> .',
                  'Cambie los colores, el nombre, etc. en cualquier editor de texto (el formato se describe '
                  'a continuación).',
                  'De vuelta en la página Apariencia, haga clic en <b>Importar tema…</b> y elija el archivo. '
                  'Se reemplaza un tema con la misma identificación y se aplica el tema importado.',
                  'Para eliminar un tema personalizado, elija <b>Eliminar tema</b> en su menú <b>⋯</b> . Los '
                  'temas integrados no se pueden eliminar.'],
 'custom_note': 'Exporta un tema para compartirlo.',
 'bg_title': 'Usa una imagen de fondo',
 'bg_steps': ['Abra Configuración de <b>› Apariencia</b>, desplácese hasta <b>Imagen de fondo</b>, haga clic '
              'en <b>Elegir imagen…</b> y elija un JPEG, PNG o GIF.',
              'La imagen llena la ventana detrás de la barra lateral y las páginas, y la barra lateral y las '
              'listas se vuelven translúcidas. Si se utiliza un tema integrado, primero se realiza una '
              'copia; el tema incorporado en sí sigue siendo el mismo.',
              '<b>Blur</b>, <b>Scrim</b> y <b>Los paneles</b> tienen tres pasos cada uno. <b>Usar colores de '
              'imagen</b> toma el color de acento de la imagen y <b>Mostrar también en Pegado rápido</b> '
              'también lo muestra allí.',
              'Haga clic en <b>Eliminar</b> para regresar. En Android, elija una foto en Configuración <b>› '
              'Apariencia › Imagen de fondo</b>.'],
 'bg_note': 'El texto siempre permanece legible: PasteFerry determina qué tan fuerte debe ser la malla para '
            'los colores del texto del tema en esta imagen y nunca la muestra más clara. Las imágenes '
            'oscuras con el modo oscuro y las imágenes claras con el modo claro muestran la mayor parte de '
            'la imagen.',
 'bg_alt': 'Tema de píxeles en modo oscuro con un fondo de colinas al atardecer: la barra lateral y la lista '
           'son translúcidas y la imagen se muestra',
 'bg_alt2': 'Configuración › Apariencia › Imagen de fondo: cambiar, eliminar, tres pasos para desenfocar, '
            'malla y paneles, usar colores de imagen, mostrar también en Pegado rápido',
 'scene_title': 'cambiar el escenario',
 'scene_steps': ['El escenario es la imagen ancha en la parte superior de las páginas y la pequeña en la '
                 'parte inferior de la barra lateral. El tema de píxeles dibuja un paisaje de píxeles y un '
                 'pequeño campamento allí; otros temas no tienen ninguno.',
                 'En <b>Configuración › Apariencia › Paisaje</b>, haga clic en <b>Elegir imagen...</b> al '
                 'lado de <b>Encabezado de página</b> o <b>Parte inferior de la barra lateral</b> para usar '
                 'sus propias imágenes. con cualquier tema. Se agrega una malla debajo del título de la '
                 'página para que siga siendo legible.',
                 '<b>Restablecer</b> recupera el original; Desactive <b>Mostrar escenario</b> para ocultar '
                 'ambos. El paisaje está oculto mientras una imagen de fondo llena la ventana.'],
 'scene_alt': 'Tema de píxeles en modo oscuro con el encabezado de la página y la parte inferior de la barra '
              'lateral reemplazados por una imagen de las colinas al atardecer',
 'file_title': 'Cómo se ve un archivo de tema',
 'file_intro': 'Los temas usan JSON. Este ejemplo cambia los colores del tema Píxel:',
 'file_fields_title': 'Campos comunes',
 'file_fields': [('<code>id</code>',
                  'El identificador del tema: letras minúsculas, dígitos y <code>-</code>. No puede ser '
                  '<code>default</code> o <code>pixel</code>.'),
                 ('<code>name</code>',
                  'El nombre en cada idioma, como <code>zh-Hans</code>, <code>zh-Hant-TW</code>, '
                  '<code>zh-Hant-HK</code>, <code>en</code> y <code>ja</code>.'),
                 ('<code>base</code>',
                  'El tema desde el que comenzar: <code>default</code>, <code>pixel</code> u otro tema '
                  'personalizado.'),
                 ('<code>modes.light</code> / <code>modes.dark</code>',
                  'Colores para claros y oscuros, como <code>#RRGGBB</code> o <code>#AARRGGBB</code> con '
                  'alfa. Los más comunes: <code>accent</code>, <code>background</code> (área de contenido), '
                  '<code>sidebar</code>, <code>surface</code> (grupos y cuadros de diálogo), '
                  '<code>border</code>, <code>text</code>, <code>textDim</code>, <code>textFaint</code> y '
                  '<code>onAccent</code> (texto sobre el acento).'),
                 ('<code>typography</code>',
                  'Fuentes: <code>family</code> es <code>system</code> o la fuente de píxeles incorporada '
                  '<code>FusionPixel</code>.'),
                 ('<code>shape</code>',
                  'Formas: <code>corner</code> es <code>round</code> o <code>pixel</code> (con muescas), '
                  'además de radios, ancho de borde y estilo de sombra.'),
                 ('<code>motion</code>, <code>icons</code>',
                  'Movimiento <code>smooth</code> / <code>stepped</code> / <code>reduced</code>; iconos '
                  '<code>system</code> / <code>pixel</code>.'),
                 ('<code>background</code>',
                  'Imagen de fondo de la ventana: <code>image</code> (<code>user:&lt;sha256&gt;</code> '
                  'después de importar), <code>blur</code>, <code>scrim</code>, <code>surfaceOpacity</code> '
                  '(opacidad del panel), <code>scope</code> (qué ventanas lo muestran), '
                  '<code>accentFromImage</code>.'),
                 ('<code>scenery</code>, <code>scene</code>',
                  'Activación/desactivación de paisajes y sus propias imágenes: <code>scene.header</code> '
                  '(encabezado de página) y <code>scene.sidebar</code> (parte inferior de la barra lateral), '
                  'con <code>headerDark</code> y <code>sidebarDark</code> opcionales para modo oscuro.')],
 'file_more': 'El formato completo y dónde se utiliza cada color:',
 'ai_title': 'Deja que una IA cree un tema',
 'ai_intro': 'Conecta por MCP para crear y aplicar temas con Claude, Cursor u otra aplicación de IA.',
 'ai_step1': '1. Encuentra pastferry-cli',
 'ai_paths': [('Mac',
               '<code>/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli</code> (con Homebrew, '
               'solo <code>pasteferry-cli</code>)'),
              ('Windows', '<code>%LOCALAPPDATA%\\Programs\\PasteFerry\\pasteferry-cli.exe</code>'),
              ('Linux',
               'deb: <code>/usr/bin/pasteferry-cli</code>; tar.gz: <code>PasteFerry/pasteferry-cli</code> en '
               'la carpeta extraída')],
 'ai_paths_note': 'O copie la configuración preparada para esta computadora desde <b>Configuración › '
                  'Apariencia › Pídale a AI que cree un tema</b>.',
 'ai_step2': '2. Agréguelo a su aplicación de IA',
 'ai_desktop': 'Claude Desktop (Configuración › Desarrollador › Editar configuración) y Cursor '
               '(<code>~/.cursor/mcp.json</code>) usan la misma configuración. En una Mac:',
 'ai_code': 'Para Claude Code, ejecute en una terminal:',
 'ai_restart': 'Guarda y reinicia la aplicación de IA. Mantén PasteFerry abierto.',
 'ai_step3': '3. Di lo que quieras',
 'ai_prompts': ['Hazme un tema cyberpunk con rosa neón y morado intenso y luego aplícalo.',
                'Comienza con el tema Pixel y crea una versión del atardecer con un fondo oscuro más cálido.',
                'El texto gris de mi tema actual es difícil de leer. Hazlo más ligero.',
                'Exporta mi tema para que pueda verlo y luego haz una versión ligera.',
                'Utilice ~/Pictures/beach.jpg como fondo y haga coincidir los colores con la foto.',
                'Reemplace el paisaje del encabezado del tema de píxeles con ~/Pictures/mountains.png.'],
 'ai_does_title': 'Qué puede hacer la IA',
 'ai_does': ['enumerar temas y leer un tema completo;',
             'lee el formato del tema: dónde se utiliza cada color y el contraste que necesita;',
             'comprobar un tema sin guardarlo para encontrar colores con muy poco contraste;',
             'guarde, aplique y elimine temas personalizados y cambie entre claro y oscuro;',
             'Importe una imagen desde esta computadora como fondo de ventana o escenario y analice su '
             'brillo y colores principales.'],
 'ai_safe_title': 'lo que no puede hacer',
 'ai_safe': 'Solo accede a temas y fondos locales, sin acceso al historial ni a los dispositivos.',
 'faq_title': 'Preguntas',
 'faq': [('¿Están los temas sincronizados con mis otros dispositivos?',
          'No. Un tema se aplica solo al dispositivo en el que lo configuras. Para utilizar el mismo tema en '
          'otro lugar, expórtelo e impórtelo allí.'),
         ('La IA arruinó mi tema. ¿Cómo vuelvo?',
          'Elija Predeterminado o Píxel en Configuración>Apariencia. Elimina los temas personalizados que no '
          'quieras.'),
         ('La importación indica que algunos textos pueden ser difíciles de leer.',
          'Algunos colores de texto y de fondo tienen poco contraste. Aclara u oscurece esos colores como se '
          'sugiere, o pídele a la IA que los arregle.'),
         ('¿Las versiones anteriores admiten temas?',
          'Necesitas 2.10 o posterior. El protocolo del dispositivo no ha cambiado, por lo que las versiones '
          'antiguas y nuevas siguen funcionando juntas.'),
         ('¿Será difícil leer el texto en mi imagen?',
          'No. La fuerza de la malla se calcula a partir de los colores del texto del tema y nunca es más '
          'clara de lo necesario. Para una imagen ocupada, aumente el desenfoque o la opacidad del panel.')],
 'more_title': 'Más',
 'more_links': [('Deja que una IA cree un tema (guía completa)', 'guía/ai-themes.md'),
                ('Formato y diseño del tema.', 'design/themes.md'),
                ('herramientas MCP', 'design/mcp.md')]}

OFFICIAL = {'badge': '¿En diferentes redes? Activar servicio y sincronizar →',
 'title': 'Servicio: sincronización entre casa y oficina sin servidor propio — PasteFerry',
 'name': 'Servicio',
 'fit': 'Funciona entre casa y oficina.',
 'go': 'Activar servicio →',
 'summary': 'Activa el Servicio para conectar ordenadores entre redes.',
 'lede': 'Cuando dos computadoras no estén en la misma red, active el Servicio y se sincronizarán.',
 'steps_title': 'Cómo encenderlo',
 'steps': ['Instale la última versión en cada computadora y haga clic en Activar sincronización en segundo '
           'plano.',
           'Active Usar el servicio en Configuración → Conexión.',
           'Empareje las dos computadoras. Las computadoras que ya ha vinculado no necesitan volver a '
           'vincularse.'],
 'routing_title': 'Transferencias',
 'routing': 'Conexión directa cuando sea posible; si no, retransmisión cifrada.',
 'quota_title': 'Cuota de datos',
 'quota': '100 MB de retransmisión por ordenador al día. Transferencias directas ilimitadas.',
 'privacy_title': 'Activación',
 'privacy': 'Desactivado por defecto. Actívalo en cada ordenador.',
 'self_title': 'Otras opciones',
 'self': 'En la misma red no lo necesitas. También puede ejecutar su propio servidor o utilizar Tailscale.',
 'settings_alt': 'El interruptor Usar el servicio en Configuración → Conexión',
 'usage_alt': 'Página de uso de demostración para el Servicio que muestra una asignación diaria de 100,00 MB '
              'y 80,00 MB restantes',
 'privacy_link': 'Aviso de privacidad',
 'self_link': 'Guía de autohospedaje',
 'download': 'Descarga la última versión'}

PRIVACY = ('Privacidad',
 [('En resumen',
   'Lo que copias, los archivos que envías, sus nombres y tus notas viajan cifrados de extremo a extremo '
   'entre tus propios dispositivos. No podemos verlos y no almacenarlos.'),
  ('Servicio (cuando está activado)',
   'Las nuevas instalaciones utilizan únicamente la red local. Cuando activa el Servicio, sus dispositivos '
   'se conectan al servidor oficial para que puedan encontrarse entre sí a través de las redes. Mantenemos '
   'un número de dispositivo seudónimo, la primera y la última hora de conexión y el uso diario del relé. '
   'Solo cuando falla una conexión directa y se necesita retransmisión, la aplicación genera un resumen de '
   'máquina específico PasteFerry, de modo que una computadora comparte una asignación de retransmisión. Los '
   'nombres reales de los dispositivos, los identificadores del sistema sin procesar y el contenido nunca se '
   'cargan.'),
  ('Comprobaciones de actualización',
   'La aplicación busca actualizaciones una vez al día y obtiene una lista de actualizaciones firmadas del '
   'sitio web PasteFerry , GitHub y Gitee. La solicitud al sitio web incluye la versión, sistema e idioma, y '
   '\u200b\u200bsi es la primera verificación del día, semana o mes, para brindar la actualización adecuada '
   'y planificar futuros lanzamientos. No se incluye ninguna ID de dispositivo ni cuenta y no se almacenan '
   'direcciones IP. Las comprobaciones automáticas se pueden desactivar en Configuración → Acerca de. Las '
   'actualizaciones se instalan solo después de que usted confirme y solo si coinciden con una lista firmada '
   'con la clave de versión PasteFerry .'),
  ('Contactos',
   'Un contacto ve el nombre para mostrar y el avatar que usted configuró, el nombre y el sistema de la '
   'computadora desde donde envía, y si usa la red local, el Servicio o su propio servidor (para su propio '
   'servidor, solo un resumen de su dirección). Su portapapeles, historial y otros dispositivos nunca se '
   'comparten con sus contactos y sus archivos llegan solo después de que usted los acepta.'),
  ('Sitio web',
   'Este sitio web utiliza Cloudflare Web Analytics y mantiene sus propios totales de visitas a la página y '
   'clics de descarga (fecha, ruta de la página, idioma de la página, versión y archivo descargado). No se '
   'utilizan cookies analíticas ni identificadores persistentes de visitantes, y no se almacenan direcciones '
   'IP ni identificadores de navegador. Con Do Not Track o Global Privacy Control activados, no se envían '
   'los contadores propios del sitio web.'),
  ('Discusión y comentarios',
   'Los apodos y el texto que envíe se almacenan en el servidor para su revisión y soporte, y se vuelven '
   'públicos después de su aprobación. Cuando la revisión de IA está habilitada, el texto necesario se envía '
   'a un servicio de IA de terceros, como DeepSeek, según los términos de manejo de datos de ese proveedor; '
   'Los administradores también pueden leer y manejar los envíos. Su navegador guarda borradores, registros '
   'de envío y credenciales de acceso por mensaje por hasta 30 días. Borrar los datos locales no elimina los '
   'mensajes del servidor; utilice el navegador original para retirarlos. El contenido no publicado, '
   'retirado y oculto se elimina después de 90 días; El contenido público permanece hasta que sea retirado o '
   'eliminado. La prevención de abusos utiliza resúmenes temporales de fuentes en lugar de almacenar '
   'direcciones IP sin procesar. No envíe contraseñas, claves API o información privada.'),
  ('como se usa',
   'Esta información se utiliza para proporcionar y mejorar el servicio, publicar actualizaciones, mantener '
   'el servicio seguro y evitar abusos, medir y planificar, y cumplir con las obligaciones legales. No lo '
   'vendemos ni lo utilizamos para publicidad.'),
  ('Terceros',
   'GitHub, Gitee, Cloudflare y cualquier servidor que elija manejan sus solicitudes según sus propias '
   'políticas de privacidad.'),
  ('Retención',
   'Los detalles diarios por dispositivo para el Servicio se conservan durante 90 días; Los totales diarios '
   'sin identidad personal se mantienen indefinidamente.'),
  ('Tus elecciones',
   'Puede utilizar únicamente la red local, desactivar el Servicio, desactivar las comprobaciones de '
   'actualizaciones automáticas o ejecutar su propio servidor. El cliente y el servidor PasteFerry son de '
   'código abierto.'),
  ('Descargo de responsabilidad y cambios',
   'PasteFerry y el Servicio se proporcionan de forma gratuita y tal cual; Las asignaciones y '
   'características de retransmisión pueden cambiar o suspenderse. No somos responsables de la pérdida de '
   'datos o sincronizaciones fallidas causadas por redes, dispositivos, servicios de terceros o servidores '
   'autohospedados. Los cambios a este aviso entran en vigor cuando se publican en el sitio web; continuar '
   'usando PasteFerry significa que los acepta.'),
  ('Contacto', 'Preguntas sobre este aviso: abra un problema en github.com/baiyuze/pasteferry/issues.')])

FEEDBACK = {'name': 'Discusión y comentarios',
 'lede': 'Informa un problema, sugiere una función o comparte tu experiencia.',
 'all': 'Todo',
 'bug': 'Informe de error',
 'idea': 'Solicitud de función',
 'discussion': 'Discusión',
 'new': 'iniciar un tema',
 'mine': 'Mis presentaciones',
 'mine_note': 'Aquí solo aparecen los registros guardados en este navegador. Borrar los datos del navegador '
              'o cambiar de dispositivo puede hacer que los envíos no publicados sean inaccesibles.',
 'nickname': 'Apodo',
 'title': 'Título',
 'body': 'Mensaje',
 'category': 'categoría',
 'platform': 'Sistema operativo',
 'version': 'Versión de la aplicación',
 'optional': 'Opcional',
 'submit': 'Enviar',
 'reply': 'Únase a la discusión',
 'back': 'Volver a temas',
 'more': 'Cargar más',
 'empty': 'Aún no hay temas públicos. Tus comentarios son bienvenidos.',
 'loading': 'Cargando…',
 'error': 'No se puede conectar. Inténtelo de nuevo más tarde.',
 'saved': 'Borrador guardado en este navegador',
 'storage_warning': 'El almacenamiento del navegador no está disponible. Los borradores y las credenciales '
                    'de envío pueden perderse después de una actualización.',
 'submitted': 'Enviado. Su mensaje será público después de la aprobación.',
 'uncertain': 'El estado de la presentación es incierto. Vuelva a intentar el envío original.',
 'withdrawn': 'Retirado',
 'expired': 'Registro caducado',
 'confirm_withdraw': '¿Retirar este mensaje? Ya no será público.',
 'clear': 'Borrar registros locales',
 'confirm_clear': '¿Borrar borradores y credenciales locales? Esto no retirará mensajes en el servidor.',
 'retry': 'Reintentar envío',
 'withdraw': 'Retirar',
 'official': 'Oficial',
 'pending': 'Revisión de IA en progreso',
 'manual': 'En espera de revisión manual',
 'approved': 'Público',
 'rejected': 'No aprobado',
 'hidden': 'Oculto',
 'open': 'Abierto',
 'in_progress': 'En progreso',
 'resolved': 'Resuelto',
 'closed': 'Cerrado',
 'draft': 'Describe tu problema o idea...',
 'privacy': 'Privacidad',
 'clearing': 'Borrar registros locales no retira mensajes. Primero retire cualquier contenido público.',
 'no_topic': 'Este tema no está disponible o no ha sido publicado.',
 'all_languages': 'Todos los idiomas',
 'language': 'Idioma del mensaje',
 'published': 'Publicado',
 'failure': 'Su mensaje puede contener contenido inapropiado. Edítelo e inténtelo de nuevo.',
 'visitor': 'visitante',
 'sending': 'Enviando…',
 'required_fields': 'Por favor escribe tu problema o idea.',
 'secure_unavailable': 'Este navegador no puede realizar envíos de forma segura. Abra el sitio web HTTPS en '
                       'un navegador actualizado.',
 'rate_limited': 'Demasiadas presentaciones. Inténtelo de nuevo en breve. Su texto se ha conservado.',
 'unavailable': 'No se pueden aceptar mensajes nuevos en este momento. Inténtelo más tarde. Su texto se ha '
                'conservado.',
 'invalid_fields': 'Verifique sus entradas y su extensión, luego inténtelo nuevamente.',
 'extra': 'Detalles adicionales (opcional)'}
