"""各版本更新日志的唯一来源，写进更新清单 updates/latest.json，App 在「检查更新」里按界面语言显示。

每一条是 (英文, 简体中文, 日文, 繁体中文（台湾）, 繁体中文（香港）)，五种语言写在一起，改一条时不会漏掉别的。
台湾与香港的用词按当地写法：台湾写網路、中繼、軟體，香港写網絡、中轉、軟件。
英文与 CHANGELOG.md、GitHub Release 正文的 Changes / Fixes 一致。

从新到旧排列；清单里只放最近 10 个版本（MAX_RELEASES）。2.3.0 是第一个能自动更新的版本，
更早的版本没有更新功能，不需要写在这里。
"""

MAX_RELEASES = 10

RELEASES = [
    {
        "version": "2.3.0",
        "date": "2026-10-19",
        "changes": [
            ("Check for updates in Settings → About. After you confirm, PasteFerry downloads, verifies and installs the new version and reopens by itself; your devices, history and settings stay.",
             "在「设置 → 关于」里检查更新。确认后，隔空贴会自动下载、校验并安装新版本，然后自己重新打开；配对、记录和设置都保留。",
             "「設定 → このアプリについて」でアップデートを確認できます。確認すると PasteFerry が新しいバージョンをダウンロード・検証・インストールし、自動的に開き直します。ペアリング、履歴、設定はそのままです。",
             "在「設定 → 關於」裡檢查更新。確認後，隔空貼會自動下載、驗證並安裝新版本，然後自己重新開啟；配對、記錄和設定都保留。",
             "在「設定 → 關於」裏檢查更新。確認後，隔空貼會自動下載、校驗並安裝新版本，然後自己重新開啟；配對、記錄和設定都保留。"),
            ("Release notes appear in your interface language. If you are several versions behind, each version is listed.",
             "更新日志按界面语言显示；落后好几个版本时，每一版的变化都会列出来。",
             "更新内容は表示言語で表示されます。複数のバージョンが空いている場合は、バージョンごとに表示します。",
             "更新日誌依介面語言顯示；落後好幾個版本時，每一版的變化都會列出來。",
             "更新日誌按介面語言顯示；落後好幾個版本時，每個版本的變化都會列出來。"),
            ("A daily check shows a quiet hint in the sidebar when a new version is out. You can skip a version or turn automatic checks off; the check only reads the update list on GitHub and Gitee and sends nothing that identifies you.",
             "每天自动检查一次，有新版本时在侧边栏底部提示，不弹窗打扰。可以跳过某个版本，也可以关掉自动检查；检查只读取 GitHub 和 Gitee 上的更新清单，不发送任何能识别你的信息。",
             "1 日 1 回自動で確認し、新しいバージョンがあるとサイドバーに控えめに表示します。特定のバージョンをスキップしたり、自動確認をオフにしたりできます。確認は GitHub と Gitee のアップデート一覧を読むだけで、あなたを識別できる情報は送信しません。",
             "每天自動檢查一次，有新版本時在側邊欄底部提示，不跳出視窗打擾。可以略過某個版本，也可以關閉自動檢查；檢查只讀取 GitHub 和 Gitee 上的更新清單，不傳送任何能識別你的資訊。",
             "每天自動檢查一次，有新版本時在側邊欄底部提示，不彈出視窗打擾。可以略過某個版本，也可以關閉自動檢查；檢查只讀取 GitHub 和 Gitee 上的更新清單，不傳送任何能識別你的資料。"),
            ("Updates are signed: the app only installs a package whose checksum appears in an update list signed by the PasteFerry release key.",
             "更新经过签名：只有出现在隔空贴发布密钥签过名的更新清单里、校验值也对得上的安装包才会被安装。",
             "アップデートは署名されています。PasteFerry のリリース鍵で署名された一覧にあり、チェックサムも一致するパッケージだけをインストールします。",
             "更新經過簽章：只有出現在隔空貼發布金鑰簽過章的更新清單裡、校驗值也對得上的安裝檔才會被安裝。",
             "更新經過簽署：只有出現在隔空貼發佈密鑰簽署過的更新清單裏、校驗值也對得上的安裝檔才會被安裝。"),
            ("In mainland China, installers are also mirrored on Gitee, linked from the Chinese download pages; updates download from whichever of GitHub and Gitee answers first.",
             "在中国大陆，安装包同时放在 Gitee 镜像上，中文下载页有链接；自动更新会从 GitHub 和 Gitee 中先响应的那个下载。",
             "中国本土向けに、インストーラーを Gitee にもミラーしています（中国語のダウンロードページにリンクがあります）。アップデートは GitHub と Gitee のうち先に応答した方からダウンロードします。",
             "在中國大陸，安裝檔同時放在 Gitee 鏡像上，中文下載頁有連結；自動更新會從 GitHub 和 Gitee 中先回應的那個下載。",
             "在內地，安裝檔同時放在 Gitee 鏡像上，中文下載頁有連結；自動更新會從 GitHub 和 Gitee 中先回應的那個下載。"),
        ],
        "fixes": [
            ("On Linux, restarting the background service with the window open, as the app does after it is upgraded by hand, could leave the service stopped until PasteFerry was opened again. The service now stops within two seconds, so the restart goes through.",
             "在 Linux 上，窗口开着时重新启动后台服务（手动升级后 App 会自动这样做），后台服务可能一直停着，直到下次打开隔空贴。现在后台服务两秒内就会退出，重启能顺利完成。",
             "Linux で、ウィンドウを開いたままバックグラウンドサービスを再起動すると（手動でアップグレードした後はアプリが自動で再起動します）、次に PasteFerry を開くまでサービスが止まったままになることがありました。サービスが 2 秒以内に終了するようになり、再起動が正しく完了します。",
             "在 Linux 上，視窗開著時重新啟動背景服務（手動升級後 App 會自動這樣做），背景服務可能一直停著，直到下次開啟隔空貼。現在背景服務兩秒內就會結束，重新啟動能順利完成。",
             "在 Linux 上，視窗開着時重新啟動背景服務（手動升級後 App 會自動這樣做），背景服務可能一直停着，直到下次開啟隔空貼。現在背景服務兩秒內就會結束，重新啟動能順利完成。"),
            ("A device that closes Search nearby now disappears from the other devices' lists right away, instead of sometimes lingering for up to seven seconds.",
             "一台设备关掉「搜索附近设备」后，会立即从其他设备的列表里消失，不再偶尔多停留最长七秒。",
             "「近くを検索」を閉じたデバイスは、ほかのデバイスの一覧からすぐに消えるようになりました。以前は最大 7 秒残ることがありました。",
             "一台裝置關閉「搜尋附近裝置」後，會立即從其他裝置的列表中消失，不再偶爾多停留最長七秒。",
             "一部裝置關閉「搜尋附近裝置」後，會立即從其他裝置的列表中消失，不再偶爾多停留最長七秒。"),
        ],
    },
]
