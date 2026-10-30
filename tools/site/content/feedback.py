"""Public feedback interface copy. No moderation implementation lives here."""

KEYS = "name lede all bug idea discussion new mine mine_note nickname title body category platform version optional submit reply back more empty loading error saved storage_warning submitted uncertain withdrawn expired confirm_withdraw clear confirm_clear retry withdraw official pending manual approved rejected hidden open in_progress resolved closed notice draft privacy clearing no_topic all_languages language published failure".split()

VALUES = {
    "zh": [
        "讨论与反馈", "反馈问题、提出建议，或分享你的使用经验。", "全部", "问题反馈", "功能建议", "使用交流", "发布新话题",
        "我的提交", "仅显示当前浏览器保存的记录。清除缓存或更换设备后，可能无法找回未公开的提交。", "昵称", "标题", "正文", "分类", "系统", "App 版本", "选填", "提交审核", "参与讨论", "返回话题列表", "加载更多", "还没有公开的话题，欢迎留下你的反馈。", "正在加载……", "暂时无法连接，请稍后重试。", "草稿已保存到当前浏览器", "浏览器无法保存记录，刷新后可能无法找回草稿和提交凭证。", "已提交，审核通过后公开。", "提交结果待确认，请使用原记录重试。", "已撤回", "记录已失效", "撤回这条消息？公开内容也会停止展示。", "清除本地记录", "清除本地草稿和凭证？此操作不会撤回服务器上的消息。", "重试原提交", "撤回", "官方", "AI 审核中", "等待人工审核", "已公开", "未通过", "已下架", "待处理", "处理中", "已解决", "已关闭", "发言需审核，通过后自动公开。启用 AI 审核时，文本会提交给第三方 AI 服务（如 DeepSeek）；请勿填写密码、密钥或个人隐私。", "写下你的问题或想法……", "隐私说明", "清除本地记录不会撤回消息，请先撤回需要删除的公开内容。", "话题不存在或暂未公开。", "全部语言", "消息语言", "已发布", "内容可能包含不适当信息，请修改后重试。"
    ],
    "zh-tw": [
        "討論與回饋", "回報問題、提出建議，或分享你的使用經驗。", "全部", "問題回報", "功能建議", "使用交流", "發表新話題",
        "我的提交", "僅顯示目前瀏覽器儲存的紀錄。清除快取或更換裝置後，可能無法找回未公開的提交。", "暱稱", "標題", "內容", "分類", "系統", "App 版本", "選填", "提交審核", "參與討論", "返回話題列表", "載入更多", "還沒有公開的話題，歡迎留下你的回饋。", "載入中……", "暫時無法連線，請稍後重試。", "草稿已儲存至目前瀏覽器", "瀏覽器無法儲存紀錄，重新整理後可能無法找回草稿與提交憑證。", "已提交，審核通過後公開。", "提交結果待確認，請使用原紀錄重試。", "已撤回", "紀錄已失效", "撤回這則訊息？公開內容也會停止顯示。", "清除本機紀錄", "清除本機草稿與憑證？此操作不會撤回伺服器上的訊息。", "重試原提交", "撤回", "官方", "AI 審核中", "等待人工審核", "已公開", "未通過", "已下架", "待處理", "處理中", "已解決", "已關閉", "發言需審核，通過後自動公開。啟用 AI 審核時，文字會傳送至第三方 AI 服務（如 DeepSeek）；請勿填寫密碼、金鑰或個人隱私。", "寫下你的問題或想法……", "隱私權說明", "清除本機紀錄不會撤回訊息，請先撤回需要刪除的公開內容。", "話題不存在或尚未公開。", "所有語言", "訊息語言", "已發表", "內容可能包含不適當資訊，請修改後重試。"
    ],
    "zh-hk": [
        "討論與意見", "回報問題、提出建議，或分享你的使用經驗。", "全部", "問題回報", "功能建議", "使用交流", "發表新話題",
        "我的提交", "只顯示目前瀏覽器儲存的記錄。清除快取或更換裝置後，可能無法找回未公開的提交。", "暱稱", "標題", "內容", "分類", "系統", "App 版本", "選填", "提交審核", "參與討論", "返回話題列表", "載入更多", "暫時未有公開話題，歡迎留下你的意見。", "載入中……", "暫時無法連線，請稍後再試。", "草稿已儲存至目前瀏覽器", "瀏覽器無法儲存記錄，重新整理後可能無法找回草稿與提交憑證。", "已提交，審核通過後公開。", "提交結果待確認，請使用原記錄重試。", "已撤回", "記錄已失效", "撤回這則訊息？公開內容亦會停止顯示。", "清除本機記錄", "清除本機草稿與憑證？此操作不會撤回伺服器上的訊息。", "重試原提交", "撤回", "官方", "AI 審核中", "等待人工審核", "已公開", "未通過", "已下架", "待處理", "處理中", "已解決", "已關閉", "發言須經審核，通過後自動公開。啟用 AI 審核時，文字會傳送至第三方 AI 服務（如 DeepSeek）；請勿填寫密碼、金鑰或個人私隱。", "寫下你的問題或想法……", "私隱說明", "清除本機記錄不會撤回訊息，請先撤回需要刪除的公開內容。", "話題不存在或尚未公開。", "所有語言", "訊息語言", "已發表", "內容可能包含不適當資訊，請修改後再試。"
    ],
    "en": [
        "Discussion & feedback", "Report a problem, suggest a feature, or share your experience.", "All", "Bug report", "Feature request", "Discussion", "Start a topic",
        "My submissions", "Only records saved in this browser appear here. Clearing browser data or changing devices may make unpublished submissions inaccessible.", "Nickname", "Title", "Message", "Category", "Operating system", "App version", "Optional", "Submit for review", "Join the discussion", "Back to topics", "Load more", "No public topics yet. Your feedback is welcome.", "Loading…", "Unable to connect. Please try again later.", "Draft saved in this browser", "Browser storage is unavailable. Drafts and submission credentials may be lost after a refresh.", "Submitted. Your message will be public after approval.", "Submission status is uncertain. Retry the original submission.", "Withdrawn", "Record expired", "Withdraw this message? It will no longer be public.", "Clear local records", "Clear local drafts and credentials? This will not withdraw messages on the server.", "Retry submission", "Withdraw", "Official", "AI review in progress", "Awaiting manual review", "Public", "Not approved", "Hidden", "Open", "In progress", "Resolved", "Closed", "Messages are reviewed and published automatically after approval. When AI review is enabled, text is sent to a third-party AI service such as DeepSeek. Do not include passwords, API keys or private information.", "Describe your problem or idea…", "Privacy", "Clearing local records does not withdraw messages. Withdraw any public content first.", "This topic is unavailable or has not been published.", "All languages", "Message language", "Published", "Your message may contain inappropriate content. Please edit it and try again."
    ],
    "ja": [
        "ディスカッションとフィードバック", "不具合の報告、機能の提案、使い方の共有はこちら。", "すべて", "不具合報告", "機能の提案", "情報交換", "新しいトピック",
        "自分の投稿", "このブラウザーに保存された記録のみ表示します。閲覧データの削除や端末の変更で、未公開の投稿を確認できなくなる場合があります。", "ニックネーム", "タイトル", "本文", "カテゴリー", "OS", "App バージョン", "任意", "審査に送信", "返信する", "一覧に戻る", "もっと見る", "公開されたトピックはまだありません。ご意見をお寄せください。", "読み込み中……", "接続できません。しばらくしてから再度お試しください。", "下書きをこのブラウザーに保存しました", "ブラウザーに保存できません。再読み込みすると下書きや投稿確認用の情報が失われる場合があります。", "送信しました。審査を通過すると公開されます。", "送信結果を確認できません。元の投稿を再送してください。", "取り下げ済み", "記録の有効期限切れ", "この投稿を取り下げますか？公開も停止します。", "ローカルの記録を削除", "下書きと確認用の情報を削除しますか？サーバー上の投稿は取り下げられません。", "再送する", "取り下げる", "公式", "AI 審査中", "手動審査を待っています", "公開済み", "承認されませんでした", "非公開", "未対応", "対応中", "解決済み", "終了", "投稿は審査を通過すると自動公開されます。AI 審査を有効にしている場合、文章を DeepSeek などの外部 AI サービスに送信します。パスワード、API キー、個人情報を含めないでください。", "問題やアイデアを入力してください……", "プライバシー", "ローカルの記録を消しても投稿は取り下げられません。必要な投稿を先に取り下げてください。", "このトピックは存在しないか、まだ公開されていません。", "すべての言語", "投稿の言語", "公開済み", "不適切な内容が含まれている可能性があります。修正して再度お試しください。"
    ],
}

COPY = {}
for code, values in VALUES.items():
    assert len(values) == len(KEYS), (code, len(values), len(KEYS))
    COPY[code] = dict(zip(KEYS, values))
    COPY[code]['visitor'] = {'zh':'访客','zh-tw':'訪客','zh-hk':'訪客','en':'Visitor','ja':'ゲスト'}[code]
