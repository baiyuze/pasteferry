"""Localized public-service privacy notice. No installation analytics."""

COPY = {
    "zh": ("隐私与必要数据", [
        ("你决定是否使用官方服务", "新安装默认只使用局域网。开启官方公网后才连接官方信令并记录必要接入统计；自建服务器模式不向官方上报。先尝试直连，失败后才申请中转授权和读取机器额度摘要。"),
        ("仅保留服务所需数据", "官方网关保留脱敏设备编号、首次及最近接入时间、每日中转用量、必要额度绑定和累计汇总。每日设备明细保留 90 天。统计表示官方服务设备数，不能代表真实人数或全部安装量。"),
        ("内容与机器标识", "剪贴板、文件内容与真实设备名通过设备间加密通道传输。网关不收集文件名、路径、用户名、MAC、UA 或行为轨迹；原始系统标识不上传，机器摘要仅用于中转额度归组，不能保证不可伪造。"),
        ("网络可见性和额度", "联网端点必然能看到临时网络地址和路由信息，但官方统计库及普通代理日志不保存这些信息。默认每日 100 MB 中转额度，上下行合计，北京时间零点重置；直连不消耗额度。开启后客户端只凭设备签名查询自己的额度，不申请中转，也不读取机器标识。关闭官方服务会停止其请求、轮询与中转通道。"),
        ("检查更新", "2.3.0 起，App 启动一分钟后和之后每天检查一次新版本：从 GitHub 和 Gitee 下载签过名的更新清单，请求里不带设备 ID、账号或其他标识，这些服务只能看到一次普通的下载和网络地址。可以在「设置 → 关于」关掉自动检查。新版本只有在你确认后才会安装，而且安装包必须与隔空贴发布密钥签名的清单里的校验值一致。"),
        ("网站与可审计边界", "本站使用既有的 Cloudflare Web Analytics，网站访问不等于软件用户统计。客户端、信令和 TURN 保持开源，公开所有官方网关协议与字段；私有生产后台的实际存储行为仍需要部署审计。"),
    ]),
    "zh-tw": ("隱私與必要資料", [
        ("由你決定使用官方服務", "新安裝預設僅使用區域網路。啟用官方公網後才連線官方信令並記錄必要連線統計；自訂伺服器不向官方回報。先嘗試直連，失敗才申請中繼並讀取機器額度摘要。"),
        ("最少必要資料", "網關保留去識別化裝置編號、首次與最近連線時間、每日中繼用量、必要額度綁定和累計彙總。每日裝置明細保留 90 天。這是官方服務裝置數，不是人數或全部安裝量。"),
        ("內容與機器識別碼", "內容與真實裝置名稱透過裝置間加密通道傳送。不收集檔名、路徑、使用者名稱、MAC、UA 或行為軌跡。原始系統識別碼不上傳；摘要只用於額度分組，並非不可偽造。"),
        ("網路資訊與額度", "網路端點暫時可見路由和網路位址，官方統計庫及一般代理日誌不保存這些資訊。每日 100 MB 中繼額度，含上下行，北京時間午夜重設；直連不計入。啟用後用戶端只憑裝置簽章查詢自己的額度，不申請中繼，也不讀取機器識別碼。關閉官方服務會停止其請求、輪詢及通道。"),
        ("檢查更新", "2.3.0 起，App 啟動一分鐘後和之後每天檢查一次新版本：從 GitHub 和 Gitee 下載簽過章的更新清單，請求裡不帶裝置 ID、帳號或其他識別資訊，這些服務只能看到一次普通的下載和網路位址。可以在「設定 → 關於」關閉自動檢查。新版本只有在你確認後才會安裝，而且安裝檔必須與隔空貼發布金鑰簽章的清單裡的校驗值一致。"),
        ("網站與稽核", "本站使用既有的 Cloudflare Web Analytics，瀏覽量不代表軟體使用者數。用戶端、信令及 TURN 持續開源，網關協定和欄位公開；私有正式環境的儲存行為仍需部署稽核。"),
    ]),
    "zh-hk": ("私隱與必要資料", [
        ("由你決定使用官方服務", "新安裝預設只使用區域網絡。啟用官方公網後才連接官方信令並記錄必要連線統計；自訂伺服器不向官方回報。先嘗試直連，失敗才申請中轉並讀取機器額度摘要。"),
        ("最少必要資料", "網關保留去識別化裝置編號、首次與最近連線時間、每日中轉用量、必要額度綁定和累計彙總。每日裝置明細保留 90 天。這是官方服務裝置數，不是人數或全部安裝量。"),
        ("內容與機器識別碼", "內容與真實裝置名稱透過裝置間加密通道傳送。不收集檔案名稱、路徑、用戶名稱、MAC、UA 或行為軌跡。原始系統識別碼不上傳；摘要只用於額度分組，並非不可偽造。"),
        ("網絡資料與額度", "網絡端點暫時可見路由和網絡地址，官方統計庫及一般代理日誌不保存這些資料。每日 100 MB 中轉額度，含上下行，北京時間午夜重設；直連不計入。啟用後用戶端只憑裝置簽署查詢自己的額度，不申請中轉，也不讀取機器識別碼。關閉官方服務會停止其請求、輪詢及通道。"),
        ("檢查更新", "2.3.0 起，App 啟動一分鐘後和之後每天檢查一次新版本：從 GitHub 和 Gitee 下載簽署過的更新清單，請求裏不帶裝置 ID、帳號或其他識別資料，這些服務只能看到一次普通的下載和網絡地址。可以在「設定 → 關於」關閉自動檢查。新版本只有在你確認後才會安裝，而且安裝檔必須與隔空貼發佈密鑰簽署的清單裏的校驗值一致。"),
        ("網站與審計", "本站使用既有的 Cloudflare Web Analytics，瀏覽量不代表軟件用戶數。用戶端、信令及 TURN 持續開源，網關協定和欄位公開；私有正式環境的儲存行為仍需部署審計。"),
    ]),
    "en": ("Privacy and essential data", [
        ("Official service is optional", "Fresh installs use LAN mode. Official access and essential connection statistics begin only when enabled. Custom servers do not report to the official service. Direct connections are attempted first; machine quota identification and relay authorization happen only after direct failure."),
        ("Minimal service records", "The gateway retains pseudonymous device numbers, first/last access times, daily relay usage, essential quota bindings and cumulative totals. Daily device detail is retained for 90 days. Official device counts are not people or total installations."),
        ("Content and identifiers", "Content and real device names travel through the encrypted device channel. The gateway does not collect filenames, paths, usernames, MAC addresses, UA or behavior trails. Raw system identifiers are not uploaded; the application-specific digest groups relay quota and can be forged by a modified client."),
        ("Network visibility and allowance", "Network endpoints necessarily see transient routing/address metadata; official statistics and ordinary proxy logs do not retain it. The default allowance is 100 MB/day, upload plus download, reset at midnight Beijing time. Direct traffic is not charged. Once enabled, the client checks its own allowance with its device signature only; this neither requests relay nor reads a machine identifier. Disabling official access stops its requests, polling and tunnels."),
        ("Update checks", "Since 2.3.0 the app checks for a new version a minute after it starts and then daily. It downloads the signed update list from GitHub and Gitee with no device ID, account or other identifier, so those services see only an ordinary download from your network address. Automatic checks can be turned off in Settings → About. Updates install only after you confirm, and only if the package matches the checksum in a list signed with the PasteFerry release key."),
        ("Website and audit boundary", "This website uses its existing Cloudflare Web Analytics beacon. Visits are not software-user counts. The client and signaling/TURN server remain open source, with gateway fields and protocol published. Actual private production retention still requires deployment audit."),
    ]),
    "ja": ("プライバシーと必要なデータ", [
        ("公式サービスは任意です", "新規インストールではLANのみを使用します。有効にした場合のみ公式シグナリングに接続し、必要な接続統計を記録します。独自サーバーは公式へ報告しません。まず直接接続を試し、失敗した場合のみ中継の認証と端末の残量識別を行います。"),
        ("最小限の記録", "仮名化した端末番号、初回・最終接続時刻、日別中継使用量、必要な上限の紐付けと累計を保持します。端末の日別明細は90日間保持します。公式端末数は人数や全インストール数ではありません。"),
        ("内容と識別子", "内容と実際の端末名は端末間の暗号化通信で送信します。ファイル名、パス、ユーザー名、MAC、UA、行動履歴を収集しません。元のシステム識別子は送信せず、専用ダイジェストを中継上限の分類にのみ使います。改変クライアントによる偽装は防ぎきれません。"),
        ("ネットワークと残量", "通信先は一時的な経路・アドレスを認識しますが、公式統計と通常のプロキシログには保存しません。中継上限は送受信合計100 MB/日で、北京時間午前0時にリセットします。直接接続は消費しません。有効にするとクライアントは端末の署名だけで自分の残量を照会します。中継の申請や端末識別子の読み取りは行いません。無効化すると公式の要求、照会とトンネルを停止します。"),
        ("アップデートの確認", "2.3.0 以降、アプリは起動 1 分後とその後 1 日 1 回、新しいバージョンを確認します。GitHub と Gitee から署名付きのアップデート一覧をダウンロードするだけで、端末 ID、アカウントなどの識別情報は送らず、相手には通常のダウンロードとネットワークアドレスしか見えません。自動確認は「設定 → このアプリについて」でオフにできます。アップデートは確認後にのみインストールし、PasteFerry のリリース鍵で署名された一覧のチェックサムと一致するパッケージだけを使います。"),
        ("ウェブサイトと監査", "当サイトは既存のCloudflare Web Analyticsを使います。閲覧数はソフトの利用者数ではありません。クライアント、シグナリングとTURNはオープンソースを維持し、ゲートウェイの仕様と項目を公開します。非公開の本番環境の保持実態には配備監査が必要です。"),
    ]),
}
