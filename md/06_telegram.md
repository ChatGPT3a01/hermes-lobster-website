# ✈️ Telegram 機器人完整設定

> Telegram 是 **HermesAgent 最容易整合**的訊息平台——原生支援、不需要 ngrok、隨開即用。
> 但官方 Telegram adapter **功能極多**，本頁從零基礎到進階一次寫完。

---

## 為什麼 Telegram 是首選？

| 特色 | 說明 |
|------|------|
| ✅ **不需要 ngrok / Cloudflare Tunnel** | Polling 模式自動向 Telegram 拉訊息 |
| ✅ **官方原生內建**（無中間層）| 不像 LINE 早期需要 Bridge |
| ✅ **支援語音輸入** | 對 Bot 講話自動 STT |
| ✅ **支援語音輸出** | Bot 也能用語音回你 |
| ✅ **支援圖／音／影／檔案** | 統一語法 `MEDIA:/path/to/file` |
| ✅ **內建 22 個斜線指令** | `/new`、`/model`、`/memory`、`/topic`… |
| ✅ **群組/論壇話題完整支援** | 不同話題綁不同 SKILL |
| ✅ **Webhook 模式可選** | 雲端 24/7 用更省錢 |

---

## 架構說明

```
📱 Telegram App  ←──→  Telegram 伺服器
                              ↕（Polling 輪詢，預設）
                        HermesAgent Gateway
                        （Port 8642，內建 Telegram adapter）
```

HermesAgent 主動向 Telegram 伺服器拉取訊息（每 1 秒），**不需要公開 URL**。

> [!NOTE]
> 也支援 **Webhook 模式**（部署到 Fly.io / Railway 雲端時更省錢），看本頁下方「進階：Webhook 模式」段落。

---

## Step 1：建立 Bot 拿 Token

1. 在 Telegram 中搜尋 **@BotFather** 或開連結 [t.me/BotFather](https://t.me/BotFather)
2. 傳送 `/newbot`
3. 輸入機器人名稱（顯示給使用者看的，例：`愛馬仕助理`）
4. 輸入機器人帳號（必須以 `bot` 結尾，例：`my_hermes_bot`、`liang_hermes_2026_bot`）
5. 複製 **Bot Token**（格式：`123456789:ABCdefGHIjklMNOpqrSTUVwxyz`）

> [!WARNING]
> Bot Token 是你 Bot 的身份憑證，**洩漏等於別人能完全冒充你的 Bot**。
> 萬一外流：BotFather → `/mybots` → 選 Bot → API Token → **Revoke current token**。

### 同時客製 Bot 外觀（選做）

在 BotFather 對話框繼續輸入：

| 指令 | 用途 |
|------|------|
| `/setdescription` | 「這個 Bot 能做什麼」說明文字 |
| `/setabouttext` | Bot 個人頁面文字 |
| `/setuserpic` | 上傳大頭照 |
| `/setcommands` | 設定指令選單（按 / 跳出來那個）|
| `/setprivacy` | **群組訊息可見性（重要！見 Step 6）** |

建議的 `/setcommands` 內容：

```
start - 開始對話
new - 開新對話 session
help - 顯示說明
clear - 清除對話記憶
status - 查看 Bot 狀態
model - 切換 AI 模型
memory - 查看記憶
whoami - 看我是誰
```

---

## Step 2：取得你的 User ID

Telegram User ID 是純數字（如 `987654321`），不是 `@username`。

### 方法 A：@userinfobot（最常用）

1. Telegram 搜尋 [@userinfobot](https://t.me/userinfobot)
2. 點 Start
3. 它立刻回你「Id: 987654321」那行 → 複製數字

### 方法 B：@get_id_bot（備援）

1. Telegram 搜尋 [@get_id_bot](https://t.me/get_id_bot)
2. 點 Start，回的訊息有 `Your chat ID`

> [!TIP]
> 把 User ID 記在 `C:\OpenClaw_Auto\龍蝦資料.txt`，等下要貼到設定檔。

---

## Step 3：設定 HermesAgent（兩種方法擇一）

### 方法 A：互動式精靈（推薦新手）

開啟 PowerShell 或終端機，跑：

```bash
hermes gateway setup
```

按照提示選 Telegram → 貼 Bot Token → 貼 User ID → 確認 → 完成。

> [!NOTE]
> V6.53+ 才有 `hermes gateway setup`，舊版本要走方法 B 手動編 `.env`。

### 方法 B：直接編 `.env`（適合進階）

```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

加入：

```env
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrSTUVwxyz
TELEGRAM_ALLOWED_USERS=987654321
```

存檔。

> [!WARNING]
> **以前的「`hermes config set` 指令」已不再支援**，請直接編 `.env` 檔。

---

## Step 4：啟動 Gateway

```bash
hermes gateway
```

成功會看到：

```text
[Hermes] gateway started
Telegram: polling started (bot: @my_hermes_bot)
```

打開 Telegram → 找你的 Bot → 點 **Start** → 傳訊息 → Bot 回覆。

---

## Step 5：⭐ `/sethome` 是做什麼？（**修正過去誤導**）

> [!IMPORTANT]
> 過去教學寫「`/sethome` 是必要步驟，不做 Bot 不回」——**這是錯的**。
> `/sethome` 只在「**Hermes 排程任務自動發訊到 Telegram**」時才需要。一般聊天**不需要先做 /sethome**。

### 什麼時候需要做 `/sethome`？

只在你**有用 Hermes Cron 排程任務**時：

- 排程任務跑完想自動推訊息到「指定 Telegram 對話」
- 排程任務 YAML 寫 `deliver: telegram`

### 怎麼做？

1. 開 Telegram 跟你的 Bot 對話
2. 傳送 `/sethome`
3. Bot 回 `Home channel set ✅` → 完成

之後排程任務發訊就推到這個對話。也可以直接寫進 `.env`：

```env
TELEGRAM_HOME_CHANNEL=987654321
TELEGRAM_HOME_CHANNEL_NAME=阿亮 DM
```

---

## Step 6：⚠️ 群組使用必設（Privacy Mode）

> [!WARNING]
> **這一步不做，Bot 在群組會「看起來像壞掉」——明明拉進去卻完全不回應。**

Telegram Bot 預設啟用 **Privacy Mode**，效果是：

| Privacy Mode ON（預設）| Privacy Mode OFF |
|------------------------|------------------|
| Bot **只看得到** `/` 開頭的指令 | Bot 看得到群組所有訊息 |
| Bot 看得到「直接 reply Bot 訊息」的訊息 | |
| 其他訊息一律忽略 | |

### 群組使用三件事

1. **關掉 Privacy Mode**：BotFather → `/mybots` → 選 Bot → **Bot Settings** → **Group Privacy** → **Turn off**
2. **設群組白名單**：把群組 ID 加進 `.env`：

   ```env
   # 群組 ID 是負數，可以從 Bot log 撈，或讓 Bot 在群組執行 /whoami 看
   TELEGRAM_GROUP_ALLOWED_CHATS=-1001234567890
   ```

   或更細：只授權**特定使用者**在群組能用：

   ```env
   TELEGRAM_GROUP_ALLOWED_USERS=987654321,123456789
   ```

3. **把 Bot 從群組踢出再重新拉進去**：Privacy 設定改了**必須重新加入**才會生效。

`hermes gateway restart` 套用設定。

---

## 進階 1：語音功能（STT + TTS）

### 語音輸入（使用者對 Bot 講話）

在 `~/.hermes/config.yaml` 加：

```yaml
platforms:
  telegram:
    voice_stt: local   # 三選一：local / groq / openai
```

| STT 引擎 | 需要 | 速度 | 品質 |
|---------|------|------|------|
| `local` | 自動裝 `faster-whisper` | 中（吃本機 CPU/GPU）| 不錯 |
| `groq` | `.env` 加 `GROQ_API_KEY` | **超快** | 好 |
| `openai` | `.env` 加 `VOICE_TOOLS_OPENAI_KEY` | 中 | 最好 |

### 語音輸出（Bot 對你講話）

```yaml
platforms:
  telegram:
    voice_tts:
      engine: edge   # edge / openai / elevenlabs
```

| TTS 引擎 | 需要 | 注意 |
|---------|------|------|
| `edge` | `ffmpeg`（Opus 轉檔）| **完全免費**，Windows 內建 Edge 語音 |
| `openai` | `VOICE_TOOLS_OPENAI_KEY` | 自然但要錢 |
| `elevenlabs` | ElevenLabs API key | 最自然，按用量計費 |

Bot 講話會以**原生語音氣泡**呈現（不是檔案下載），跟真人對話一樣。

---

## 進階 2：發送多媒體（圖／音／影／檔案）

統一語法：在 AI 回覆訊息中夾 `MEDIA:/path/to/file`，Hermes 自動辨識副檔名走對應發送 API。

### 支援的副檔名

| 類型 | 副檔名 |
|------|--------|
| 圖片 | png, jpg, jpeg, gif, webp, bmp, tiff, svg |
| 音訊 | mp3, wav, ogg, m4a, opus, flac, aac |
| 影片 | mp4, mov, webm, mkv, avi |
| 文件 | pdf, txt, md, csv, json, xml, html, yaml, log |
| Office | docx, xlsx, pptx, odt, ods, odp |
| 壓縮檔 | zip, rar, 7z, tar, gz, bz2 |
| 電子書／APK | epub, apk, ipa |

### 用法範例

跟 Bot 說：

```
幫我把今天的截圖傳給我看
```

Bot 內部執行工具找到檔案後，回的訊息會像：

```
這是今天的截圖：
MEDIA:/Users/liang/Pictures/today.png
```

Telegram 端看到的就是**原生圖片氣泡**，不是路徑文字。

---

## 進階 3：多話題對話模式（`/topic`）

Bot API 9.4 起 Telegram 支援「私訊裡開多個話題」（像 forum 但只你一人）。

### 開啟方式（兩步）

1. **BotFather** 設定（必須）：
   - `/mybots` → 選 Bot → **Bot Settings** → **Threads Settings**
   - 開啟 **Threaded Mode**
   - 開啟 **allows_users_to_create_topics**

2. 對 Bot 傳 `/topic` → 啟用

### 常用 `/topic` 指令

| 指令 | 用途 |
|------|------|
| `/topic` | 開啟模式 / 顯示目前狀態 |
| `/topic <session-id>` | 切到之前的對話 |
| `/topic off` | 關掉多話題 |
| `/topic help` | 看說明 |

### 預設話題（YAML）

可以在 `config.yaml` 預先設定**自動建立的話題**，每個話題綁不同 SKILL：

```yaml
platforms:
  telegram:
    extra:
      dm_topics:
      - chat_id: 987654321   # 你的 User ID
        topics:
        - name: General
          icon_color: 7322096
        - name: 學術研究
          skill: arxiv      # 進這個話題自動載入 arxiv SKILL
        - name: 寫程式
          skill: software-development
```

---

## 進階 4：群組 Forum Topic 綁 SKILL

群組開啟 **forum mode**（在群組設定裡）後，可以把不同 topic 綁定不同 SKILL：

```yaml
platforms:
  telegram:
    extra:
      group_topics:
      - chat_id: -1001234567890     # 群組 ID
        topics:
        - name: 工程組
          thread_id: 5
          skill: software-development
        - name: 行銷組
          thread_id: 7
          skill: marketing-plan-generator
```

進該 topic 對 Bot 講話，自動載入對應 SKILL。

---

## 進階 5：權限分層（admin vs 一般使用者）

想開放給朋友用但限制他們能用的指令：

```yaml
gateway:
  platforms:
    telegram:
      extra:
        # 這些人可以用所有指令
        allow_admin_from:
          - "987654321"   # 你自己

        # 其他使用者只能用這幾個指令
        user_allowed_commands:
          - help
          - status
          - model
          - history
          - new
```

非 admin 的使用者打 `/memory` 會被擋下來，並顯示「你沒權限」。

---

## 進階 6：Mention Patterns（喚醒詞）

群組裡不想 Bot 看到每句話都回，可以設定「叫名字才回」：

```yaml
platforms:
  telegram:
    require_mention: true
    mention_patterns:
      - "^\\s*愛馬仕\\b"        # 「愛馬仕，幫我...」
      - "^\\s*hermes\\b"        # 英文也可以
      - "@my_hermes_bot"        # 標準 @ 提及
```

訊息符合任一 pattern 才會觸發。

---

## 進階 7：忽略特定話題

```yaml
platforms:
  telegram:
    ignored_threads:
      - 31    # 純閒聊話題不想被打擾
      - "42"  # 字串或數字都行
```

---

## 進階 8：Webhook 模式（雲端部署用）

部署到 Fly.io / Railway / Render 等支援 auto-wake-on-traffic 的平台時，Webhook 模式比 Polling 省錢——閒置時雲端服務睡覺，有訊息才喚醒。

```env
TELEGRAM_WEBHOOK_URL=https://my-app.fly.dev/telegram/webhook
TELEGRAM_WEBHOOK_SECRET=隨便寫一個強密碼用來驗證
TELEGRAM_WEBHOOK_PORT=8443
```

本機開發**不要用 Webhook 模式**，Polling 比較單純。

---

## 進階 9：Streaming Transport（串流回覆方式）

```yaml
platforms:
  telegram:
    streaming: auto   # auto / draft / edit / off
```

| 選項 | 行為 |
|------|------|
| `auto`（預設）| 私訊用 native drafts（最新功能），群組用 edit-based |
| `draft` | 強制全部用 native drafts |
| `edit` | 傳統做法：先發短訊再不停編輯 |
| `off` | 完全關掉串流，等 AI 答完才發整段 |

---

## 進階 10：表格與連結預覽

```yaml
platforms:
  telegram:
    pretty_tables: true   # 小表用 bullet，大表用程式碼框（預設 true）

    extra:
      disable_link_previews: true   # 不要每個 URL 都展開大預覽
```

---

## 進階 11：代理 / 翻牆設定

在中國大陸或某些 ISP 連不到 `api.telegram.org`：

```env
# SOCKS5 代理
TELEGRAM_PROXY=socks5://localhost:1080

# HTTP 代理
TELEGRAM_PROXY=http://proxy.example.com:8080

# api.telegram.org 備援 IP（DNS 被汙染時用）
TELEGRAM_FALLBACK_IPS=91.108.56.165,149.154.167.220
```

---

## 進階 12：Emoji 反應

讓 Bot 對訊息「按表情」：

```env
TELEGRAM_REACTIONS=true
```

`config.yaml` 進一步設定：

```yaml
platforms:
  telegram:
    reactions:
      processing: 👀     # 收到訊息時
      success: 👍        # 成功完成時
      error: ❗           # 出錯時
```

---

## 22 個官方斜線指令完整列表

| 指令 | 用途 |
|------|------|
| `/start` | 進入對話 |
| `/new` | 開新 session（重置上下文） |
| `/clear` | 清空目前對話 |
| `/help` | 顯示說明（所有人都能用） |
| `/whoami` | 顯示我的權限等級和可用指令 |
| `/status` | Bot 狀態 |
| `/model` | 切換 AI 模型（互動式內建鍵盤） |
| `/memory` | 看/編記憶 |
| `/history` | 看歷史對話 |
| `/sethome` | 設這個對話為排程通知目標 |
| `/topic` | 多話題模式（私訊）|
| `/background <prompt>` | 背景執行任務 |
| `/tools` | 開關工具 |
| `/skills` | 列出已裝 SKILL |
| `/persona` | 編輯 SOUL.md |
| `/fast` | 切快速模式 |
| `/compact`、`/compress` | 壓縮上下文 |
| `/undo`、`/retry` | 復原／重試 |
| `/debug` | 診斷 |
| `/version` | 看 Hermes 版本 |
| `/usage` | 看 Token 與成本 |

---

## 進階 13：Exec Approval（危險指令二次確認）

執行 `rm -rf`、`del`、`shutdown` 等危險指令時，Hermes 會在 Telegram 跳出確認：

```
🤖 確認要執行嗎？
  rm -rf ~/Downloads/temp

  回 "yes" / "y" 確認執行
```

不回確認就會超時取消。

---

## 多人使用設定

開放多人時把 User ID 用逗號連起來：

```env
TELEGRAM_ALLOWED_USERS=987654321,111222333,444555666
```

**不要有空格**。逗號分隔。

---

## 環境變數完整參考

| 變數 | 必填 | 預設 | 說明 |
|------|------|------|------|
| `TELEGRAM_BOT_TOKEN` | ✅ | — | BotFather 給的 Token |
| `TELEGRAM_ALLOWED_USERS` | ✅ | — | 私訊白名單（純數字 User ID）|
| `TELEGRAM_GROUP_ALLOWED_USERS` | — | — | 群組裡的個人白名單 |
| `TELEGRAM_GROUP_ALLOWED_CHATS` | — | — | 群組白名單（負數 chat ID）|
| `TELEGRAM_HOME_CHANNEL` | — | — | 排程通知預設目標 |
| `TELEGRAM_HOME_CHANNEL_NAME` | — | — | Home channel 顯示名稱 |
| `TELEGRAM_WEBHOOK_URL` | Webhook 用 | — | Webhook 模式的公開 URL |
| `TELEGRAM_WEBHOOK_SECRET` | Webhook 用 | — | Webhook 驗證 secret |
| `TELEGRAM_WEBHOOK_PORT` | Webhook 用 | `8443` | Webhook 本機 port |
| `TELEGRAM_PROXY` | — | — | 代理 URL（socks5/http/https）|
| `TELEGRAM_FALLBACK_IPS` | — | — | api.telegram.org 備援 IP |
| `TELEGRAM_REACTIONS` | — | `false` | 啟用 emoji 反應 |

---

## Troubleshooting

### Q1：傳訊息給 Bot 沒回應

依序檢查：

1. `hermes gateway status` → 確認 Gateway 在跑
2. `.env` 裡 `TELEGRAM_BOT_TOKEN` 沒漏字
3. 你的 User ID 真的在 `TELEGRAM_ALLOWED_USERS`（**多人開放時不要有空格**）
4. `hermes doctor` → 跑診斷

### Q2：群組裡 Bot 不講話

99% 是 Privacy Mode 沒關。回 BotFather → Group Privacy → Turn off → **重新加 Bot 進群組**。

### Q3：傳語音給 Bot 它說「不支援語音」

`config.yaml` 沒設 `voice_stt`。設了之後 `hermes gateway restart`。

### Q4：Bot 講話沒有語音氣泡，是檔案下載

`ffmpeg` 沒裝。Windows：`winget install Gyan.FFmpeg`。Mac：`brew install ffmpeg`。

### Q5：Webhook 模式沒收到 update

- HTTPS 不通：用 `curl -i https://<webhook url>` 確認
- 防火牆擋 Webhook 端口
- Webhook secret 沒對

### Q6：Bot Token 被外流了

馬上去 BotFather → `/mybots` → 選 Bot → API Token → **Revoke current token** → 拿新 Token 改 `.env` → `hermes gateway restart`。

---

## 跟 LINE 並用

兩個平台**共用同一個 HermesAgent Gateway**：

```env
# 同一個 .env 同時設兩個平台
TELEGRAM_BOT_TOKEN=...
TELEGRAM_ALLOWED_USERS=...

LINE_CHANNEL_ACCESS_TOKEN=...
LINE_CHANNEL_SECRET=...
LINE_ALLOWED_USERS=...
LINE_PUBLIC_URL=...
```

`config.yaml`：

```yaml
gateway:
  platforms:
    telegram:
      enabled: true
    line:
      enabled: true
```

**對話記憶是分開的**（兩個平台不會混）。同一個使用者在 Telegram 和 LINE 講話，Hermes 視為兩個不同 session。

---

## 安全提醒

> [!WARNING]
> **絕對不要分享 Bot Token**。Token 等同於 Bot 的密碼，任何人拿到都能完全控制你的 Bot（讀所有訊息、冒充你發訊息）。
>
> **絕對要設 `TELEGRAM_ALLOWED_USERS`**。沒設的話 Hermes 預設拒絕所有人，但也代表「設了沒就好」——任何拿到 Bot 帳號的人就能用你的 LLM 額度。

---

## 接下來看哪一頁？

| 你的下一步 | 看這一頁 |
|----------|---------|
| 設好 Telegram 想再接 LINE | 「💚 LINE 官方原生方案」 |
| 想設定排程任務（Cron）| 「🚀 一鍵安裝教學 → 進階功能」 |
| 想換 LLM 模型 | 「🪐 Google Antigravity」「🦙 Ollama 免費方案」 |
| 想看每天怎麼啟動 Bot | 「▶️ 每次啟動愛馬仕龍蝦」 |
| 想客製 Bot 人格 | 「🎭 靈魂人格設置」 |
