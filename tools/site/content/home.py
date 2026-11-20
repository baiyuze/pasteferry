"""首页产品重点。各列依次为九种官网语言。"""

LANGUAGES = ("zh", "zh-tw", "zh-hk", "en", "ja", "ko", "de", "fr", "es")

COPY = {
    "hero": (
        "在 Mac、Windows、Linux 之间同步剪贴板，不用同一个账号。复制记录能搜索、收藏，文件和文件夹也能拖放互传。",
        "在 Mac、Windows、Linux 之間同步剪貼簿，不必使用同一帳號。複製記錄能搜尋、收藏，檔案和資料夾也能拖放互傳。",
        "在 Mac、Windows、Linux 之間同步剪貼簿，不必使用同一帳戶。複製記錄可搜尋、收藏，檔案和資料夾亦可拖放互傳。",
        "Sync your clipboard across Mac, Windows and Linux without a shared account. Search and save your clipboard history, or drag files and folders to another device.",
        "Mac・Windows・Linux でクリップボードを同期。同じアカウントは不要です。コピー履歴の検索・お気に入り保存、ファイルやフォルダーのドラッグ転送にも対応。",
        "같은 계정 없이 Mac, Windows, Linux의 클립보드를 동기화하세요. 복사 기록을 검색하고 즐겨찾기에 보관하거나 파일과 폴더를 끌어서 전송할 수 있습니다.",
        "Die Zwischenablage zwischen Mac, Windows und Linux synchronisieren, ohne gemeinsames Konto. Kopiertes suchen und als Favorit sichern oder Dateien und Ordner auf ein anderes Gerät ziehen.",
        "Synchronisez le presse-papiers entre Mac, Windows et Linux sans compte commun. Recherchez et conservez vos copies, ou glissez des fichiers et dossiers vers un autre appareil.",
        "Sincroniza el portapapeles entre Mac, Windows y Linux sin compartir cuenta. Busca y guarda tus copias, o arrastra archivos y carpetas a otro dispositivo.",
    ),
    "history": (
        "按 {key} 打开复制记录，搜索并选中一条，直接粘贴到当前 App。常用内容可以收藏，文件会另存副本。",
        "按 {key} 開啟複製記錄，搜尋並選取一筆，直接貼到目前 App。常用內容可以收藏，檔案會另存副本。",
        "按 {key} 開啟複製記錄，搜尋並選取一項，直接貼到目前程式。常用內容可以收藏，檔案會另存副本。",
        "Press {key} to search your clipboard history and paste into the current app. Save favorites for later, with a separate copy of each file.",
        "{key} でコピー履歴を検索し、選んだ内容を今のアプリに貼り付け。よく使う内容はお気に入りに、ファイルは別のコピーとして保存できます。",
        "{key}로 복사 기록을 검색하고 현재 앱에 붙여넣으세요. 자주 쓰는 내용은 즐겨찾기에 보관하며 파일은 별도 사본으로 저장됩니다.",
        "Mit {key} den Verlauf durchsuchen und direkt in die aktuelle App einfügen. Favoriten bleiben gespeichert, Dateien als eigene Kopie.",
        "Avec {key}, recherchez une copie et collez-la dans l’application active. Gardez vos favoris, avec une copie distincte des fichiers.",
        "Pulsa {key} para buscar en el historial y pegar en la aplicación actual. Guarda favoritos con una copia separada de los archivos.",
    ),
    "send": ('电脑之间，文件和整个文件夹都能拖放传送，支持大文件与断点续传。收到的文件集中保存在「下载」。',
             '電腦之間，檔案與整個資料夾都能拖放傳送，支援大檔案與續傳。收到的檔案集中存到「下載」。',
             '電腦之間，檔案及整個資料夾均可拖放傳送，支援大檔案及續傳。收到的檔案集中存到「下載」。',
             'Drag files and whole folders between computers. Large transfers can resume after an interruption, and '
             'received files stay together in Downloads.',
             'パソコン間でファイルやフォルダーをドラッグ転送。大容量ファイルも中断後に再開でき、受信ファイルは「ダウンロード」にまとめて保存します。',
             '컴퓨터 간에 파일이나 폴더를 끌어서 전송하세요. 대용량 전송은 중단 후 이어지고 받은 파일은 다운로드에 모입니다.',
             'Dateien und ganze Ordner zwischen Computern ziehen. Große Übertragungen lassen sich fortsetzen, empfangene '
             'Dateien landen in Downloads.',
             'Glissez fichiers ou dossiers entiers entre ordinateurs. Les gros transferts reprennent après interruption '
             'et les fichiers reçus sont regroupés dans Téléchargements.',
             'Arrastra archivos o carpetas completas entre ordenadores. Las transferencias grandes se reanudan tras una '
             'interrupción y los archivos recibidos se reúnen en Descargas.'),
    "phone": (
        "同一网络内，安卓 App 可与电脑双向发送照片和文件，支持多选、保存与分享。iPhone、iPad 可扫码用网页，查看复制记录或发送内容，网页需保持打开。",
        "同一網路內，安卓 App 可與電腦雙向傳送照片和檔案，支援多選、儲存與分享。iPhone、iPad 可掃碼使用網頁，查看複製記錄或傳送內容，網頁須保持開啟。",
        "同一網絡內，安卓 App 可與電腦雙向傳送相片及檔案，支援多選、儲存及分享。iPhone、iPad 可掃碼使用網頁，查看複製記錄或傳送內容，網頁須保持開啟。",
        "On the same network, Android can send and receive batches of photos and files, then save or share them. On iPhone and iPad, scan a QR code for clipboard history and transfers in the browser; keep the page open.",
        "同じネットワークで、Android は写真やファイルを双方向に転送し、複数選択・保存・共有も可能。iPhone・iPad は QR コードで Web 版を開き、コピー履歴や転送を利用できます。ページは開いたままにします。",
        "같은 네트워크에서 Android 앱으로 사진과 파일을 양방향 전송하고 여러 개 선택, 저장, 공유할 수 있습니다. iPhone과 iPad는 QR 코드로 웹을 열어 기록과 전송을 이용하세요. 페이지는 열어 두세요.",
        "Im selben Netzwerk mit Android Fotos und Dateien in beide Richtungen übertragen, mehrfach auswählen, speichern und teilen. Auf iPhone und iPad per QR-Code den Verlauf und die Übertragung im Browser öffnen; die Seite geöffnet lassen.",
        "Sur le même réseau, Android envoie et reçoit des lots de photos et fichiers, à enregistrer ou partager. Sur iPhone et iPad, un QR code ouvre l’historique et les transferts dans le navigateur ; gardez la page ouverte.",
        "En la misma red, Android envía y recibe lotes de fotos y archivos, que puedes guardar o compartir. En iPhone y iPad, escanea un QR para abrir el historial y las transferencias en el navegador; mantén la página abierta.",
    ),
    "extras": (
        [("给好友发文件", "添加好友后直接发送文件，由对方确认接收。好友不会看到你的剪贴板和复制记录。"),
         ("九套主题，也能自己做", "默认、像素与七套风格主题都有深浅色。可自定义配色和背景图，或让 AI 生成并应用主题。"),
         ("端到端加密", "端到端加密，配对时核对安全指纹。服务器只负责连接和转发，不能解密复制或传送的内容。")],
        [("傳檔案給好友", "加入好友後直接傳送檔案，由對方確認接收。好友不會看到你的剪貼簿與複製記錄。"),
         ("九套主題，也能自己做", "預設、像素與七套風格主題都有深淺色。可自訂配色與背景圖，或讓 AI 產生並套用主題。"),
         ("端對端加密", "端對端加密，配對時核對安全指紋。伺服器只負責連線與轉送，無法解密複製或傳送的內容。")],
        [("傳檔案給好友", "加入好友後直接傳送檔案，由對方確認接收。好友不會看到你的剪貼簿及複製記錄。"),
         ("九套主題，亦可自己做", "預設、像素及七套風格主題均有深淺色。可自訂配色及背景圖，或讓 AI 產生並套用主題。"),
         ("端對端加密", "端對端加密，配對時核對安全指紋。伺服器只負責連線及轉送，無法解密複製或傳送的內容。")],
        [("Send files to contacts", "Add a contact and send files for them to accept. Contacts cannot see your clipboard or history."),
         ("Nine themes, plus your own", "Default, Pixel and seven more styles have light and dark palettes. Customize colors and backgrounds, or create and apply a theme with AI."),
         ("Your content stays private", "End-to-end encryption, with fingerprints checked during pairing. Servers help connect devices and relay data, but cannot decrypt your content.")],
        [("友だちにファイルを送る", "友だちを追加し、相手が確認してから受信。友だちにクリップボードやコピー履歴は見えません。"),
         ("9 種のテーマとカスタマイズ", "デフォルト・ピクセルと 7 種のスタイルにライト・ダーク配色。色や背景の変更、AI によるテーマの作成・適用も可能です。"),
         ("内容は自分のデバイスだけに", "ペアリング時にフィンガープリントを確認し、内容はエンドツーエンド暗号化。サーバーは接続や中継のみを担い、復号できません。")],
        [("친구에게 파일 보내기", "친구를 추가하고 상대방이 수락하면 파일을 전송합니다. 친구에게 클립보드나 복사 기록이 공개되지 않습니다."),
         ("9가지 테마와 나만의 테마", "기본, 픽셀과 7가지 스타일 모두 밝은·어두운 모드를 지원합니다. 색상과 배경을 바꾸거나 AI로 테마를 만들고 적용하세요."),
         ("내 내용은 내 장치에만", "페어링 시 지문을 확인하고 종단 간 암호화합니다. 서버는 연결과 중계만 담당하며 내용을 복호화할 수 없습니다.")],
        [("Dateien an Kontakte senden", "Kontakt hinzufügen und Dateien nach Bestätigung des Empfängers senden. Deine Zwischenablage und dein Verlauf bleiben für Kontakte unsichtbar."),
         ("Neun Designs und eigene Ideen", "Standard, Pixel und sieben weitere Stile mit hellen und dunklen Farben. Farben und Hintergründe anpassen oder ein Design mit KI erstellen und anwenden."),
         ("Deine Inhalte bleiben privat", "Ende-zu-Ende-Verschlüsselung mit Fingerabgleich beim Koppeln. Server verbinden Geräte und leiten Daten weiter, können Inhalte aber nicht entschlüsseln.")],
        [("Envoyer des fichiers aux contacts", "Ajoutez un contact et envoyez des fichiers qu’il confirme avant réception. Votre presse-papiers et votre historique restent privés."),
         ("Neuf thèmes, et les vôtres", "Défaut, Pixel et sept autres styles ont des palettes claires et sombres. Personnalisez couleurs et fonds, ou créez et appliquez un thème avec l’IA."),
         ("Vos contenus restent privés", "Chiffrement de bout en bout et vérification des empreintes à l’association. Les serveurs connectent les appareils et relaient les données sans pouvoir les déchiffrer.")],
        [("Envía archivos a tus contactos", "Añade un contacto y envía archivos que aceptará antes de recibirlos. Tus contactos no ven el portapapeles ni el historial."),
         ("Nueve temas y los tuyos", "Predeterminado, Píxel y siete estilos más con paletas claras y oscuras. Personaliza colores y fondos, o crea y aplica un tema con IA."),
         ("Tu contenido sigue siendo privado", "Cifrado de extremo a extremo y huellas verificadas al emparejar. Los servidores conectan dispositivos y retransmiten datos, pero no pueden descifrar el contenido.")],
    ),
}


def localized(code: str) -> dict:
    i = LANGUAGES.index(code)
    return {key: translations[i] for key, translations in COPY.items()}
