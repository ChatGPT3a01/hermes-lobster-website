# 💚 LINE 官方原生方案（2026/5 起推薦）

> **重大更新**：HermesAgent 在 2026 年 5 月起**官方內建 LINE adapter**！
> 不再需要 Node.js Bridge、不再需要 ngrok（可改用 Cloudflare Tunnel 固定 URL），整個架構從「3 個視窗」簡化成「2 個視窗」。
> 這一頁教你走官方原生路線。

---

## 為什麼推薦官方原生方案？

| 比較項目 | 🥇 官方原生（這一頁）| 📜 Bridge 方案（07_line.md）|
|---------|--------------------|---------------------------|
| 維護者 | NousResearch 工程團隊 + 60k+ GitHub stars 社群 | 阿亮老師個人 |
| 要不要 Bridge | ❌ 不要 | ✅ Node.js Bridge（port 3000）|
| 啟動視窗數 | **2 個**（Gateway + 隧道） | **3 個**（Gateway + Bridge + 隧道） |
| Webhook URL 路徑 | `/line/webhook`（**雙段**） | `/webhook`（單段） |
| 慢 LLM 機制 | ✅ **postback 按鈕**自動省 Push API 費用 | ❌ 直接 push 燒錢 |
| 多媒體（圖／音／影） | ✅ 內建 `LINE_PUBLIC_URL` | ❌ 只能純文字 |
| 群組／房間支援 | ✅ 內建白名單 | ❌ 沒提 |
| Cron 排程通知 | ✅ `LINE_HOME_CHANNEL` | ❌ |
| 健康檢查 | `curl /line/webhook/health` | ❌ |
| 適合什麼人 | **新手 / 想穩 / 想用語音圖片** | 想客製 humanizer / 已經跑得好的 Bridge 學員 |

> [!IMPORTANT]
> **⚠️ Webhook URL 路徑不要混！**
> | 走哪條路線 | Webhook URL 後面要接 |
> |-----------|--------------------|
> | 官方原生（這一頁）| `https://<隧道網址>/line/webhook` ← **/line/webhook 雙段** |
> | Bridge 方案 | `https://<隧道網址>/webhook` ← /webhook 單段 |
>
> 同一個 LINE Channel 只能綁一條路線。混了就連不上。

---

## 整體架構

```
📱 LINE App
     ↓（使用者傳訊）
LINE 伺服器
     ↓（Webhook 推送）
🌩️ Cloudflare Tunnel（或 ngrok）
     ↓（轉發到本機）
HermesAgent Gateway（內建 LINE adapter）
     ├ Webhook listener: Port 8646（接 LINE 推送）
     └ Hermes Gateway: Port 8642（內部主程式）
     ↓（AI 回覆）
LINE 伺服器 → 使用者
```

跟 Bridge 方案不同的關鍵：**Hermes 自己處理 webhook**，沒有中間轉發層。

---

## Step 1：建立 LINE Messaging API Channel

跟 Bridge 方案完全一樣，請看 **「2️⃣ 申請 LINE Messaging API」**那一頁拿到這 4 樣：

| 項目 | 樣子 | 之後用在 |
|------|------|---------|
| Channel ID | 10 位數字 | 僅備存 |
| Channel Secret | 32 位英數 | 貼到 `~/.hermes/.env` |
| Channel Access Token | 170+ 字結尾有 `=` | 貼到 `~/.hermes/.env` |
| 你的 LINE User ID | `U` 開頭 32 字 | 貼到 `LINE_ALLOWED_USERS` 白名單 |

> [!WARNING]
> **務必先做這幾件事**（不做 Bot 會亂回話）：
> 1. **關掉** Auto-reply messages（Edit → 跳到 LINE Official Account Manager → 自動回應訊息：停用）
> 2. **啟用** Webhook 開關
> 3. **Webhook URL 先留空**，Step 4 才填

---

## Step 2：暴露 Webhook 埠口（隧道）

HermesAgent 預設把 LINE webhook 監聽在 `8646` 埠口（可用 `LINE_PORT` 覆寫）。要讓 LINE 伺服器戳得到你的電腦，需要一條公開 HTTPS 隧道。

### 路線 A：🌩️ Cloudflare Tunnel（**推薦**）

完全免費、URL 可固定（綁自己網域）、生產等級穩定。詳細教學在「🌩️ Cloudflare Tunnel」那一頁，這裡只給快速指令：

```powershell
# Windows（PowerShell）
winget install --id Cloudflare.cloudflared
cloudflared tunnel --url http://localhost:8646
```

```bash
# Mac
brew install cloudflared
cloudflared tunnel --url http://localhost:8646
```

成功後會看到類似訊息：

```text
Your quick Tunnel has been created! Visit it at:
https://random-words-abc123.trycloudflare.com
```

**複製這個 URL**，Step 4 會用。

### 路線 B：🚇 ngrok（開發測試用）

跟 Bridge 方案的做法相同，但 **port 換成 8646**：

```powershell
ngrok http 8646
```

> [!WARNING]
> **免費版 ngrok 每次重啟 URL 會變**，Cloudflare Tunnel 沒這問題。長期用建議走 Cloudflare Tunnel。

### 路線 C：devtunnel（VS Code 出品，Microsoft 帳號）

```bash
devtunnel create hermes-line --allow-anonymous
devtunnel port create hermes-line -p 8646 --protocol https
devtunnel host hermes-line
```

> [!TIP]
> **隧道視窗不要關**，關了 LINE 就連不上。建議放背景或開機自啟（看「🌩️ Cloudflare Tunnel」進階段落）。

---

## Step 3：設定 Hermes（兩個檔案）

### 3-1：編 `~/.hermes/.env`

```powershell
# Windows 快速打開
notepad "$env:USERPROFILE\.hermes\.env"
```

```bash
# Mac / Linux
nano ~/.hermes/.env
```

把這些加進去（把 `<你的...>` 換掉）：

```env
# ──── LINE 官方原生設定 ────
LINE_CHANNEL_ACCESS_TOKEN=<你的 Channel Access Token 170+ 字>
LINE_CHANNEL_SECRET=<你的 Channel Secret 32 字>
LINE_ALLOWED_USERS=<你的 LINE User ID, U 開頭 32 字>
LINE_PUBLIC_URL=https://<你的隧道網址>

# 想開放群組？加這行：
# LINE_ALLOWED_GROUPS=<C 開頭的群組 ID>

# 想開放多人房間？加這行：
# LINE_ALLOWED_ROOMS=<R 開頭的房間 ID>
```

### 3-2：編 `~/.hermes/config.yaml` 開啟 LINE platform

```powershell
notepad "$env:USERPROFILE\.hermes\config.yaml"
```

確認檔案內有這段（沒有就加進去）：

```yaml
gateway:
  platforms:
    line:
      enabled: true
```

> [!NOTE]
> 不用手動編 `Platform.LINE` enum 或註冊 `_create_adapter`。**Hermes 啟動時插件掃描自動偵測**，只要 `enabled: true` 就會載入 LINE adapter。

---

## Step 4：設定 LINE Webhook URL

1. 回 [LINE Developers Console](https://developers.line.biz/console/) → 你的 Channel → **Messaging API**
2. 找 **Webhook settings**
3. **Webhook URL** 填：

   ```text
   https://<你的隧道網址>/line/webhook
   ```

   ⚠️ **是 `/line/webhook`（雙段），不是 Bridge 方案的 `/webhook`**

4. 點 **Verify** → 應回 `Success`（200 OK）
5. **Use webhook** 切到 **On**

---

## Step 5：跑 Gateway

```bash
hermes gateway
```

成功會看到類似日誌：

```text
[Hermes] gateway started
LINE: webhook listening on 0.0.0.0:8646/line/webhook (public: https://my-tunnel.example.com)
Telegram polling started   ← 如果你也設了 Telegram
```

從 LINE App 掃 Channel 的 QR Code 加為好友，傳訊息 → Bot 回覆。

### 健康檢查（除錯神器）

任何時候都可以跑這個確認隧道是否通：

```powershell
curl -i https://<你的隧道網址>/line/webhook/health
```

**成功應回 200**：

```json
{"status":"ok","platform":"line"}
```

LINE Console 的 Verify 按不通時，這個指令會告訴你是隧道掛了 / Hermes 沒跑 / port 沒對。

---

## 🌟 殺手級功能 1：postback 按鈕（慢 LLM 救星）

LINE 給的 **Reply Token** 約 **60 秒**會過期。慢 LLM 來不及回覆時，傳統做法只能改用 **Push API**（收費，每月超過 200 則就收錢）。

Hermes 官方原生想到一招：**LLM 跑超過 45 秒時**，自動發一個按鈕氣泡：

> 🤔 Still thinking. Tap below to fetch the answer when it's ready.
> [ Get answer ]

使用者點按鈕 → LINE 給一個**新 Reply Token** → Hermes 把答案發過去 → **仍然是 Reply API（免費）**。

### 預設 45 秒，可調

```env
# 改成 30 秒就跳按鈕（適合用 Gemini 等較慢模型）
LINE_SLOW_RESPONSE_THRESHOLD=30

# 完全停用（強制全部走 Push API，超過免費額度會收錢）
LINE_SLOW_RESPONSE_THRESHOLD=0
```

### 按鈕文字客製

```env
LINE_PENDING_TEXT=🤔 還在思考中...
LINE_BUTTON_LABEL=取回答案
LINE_DELIVERED_TEXT=已經回覆囉 ✅
LINE_INTERRUPTED_TEXT=任務被中斷了
```

### 抑制工具進度搶 Token

如果其他訊息（工具進度、串流字幕）會搶 reply token，按鈕不出來：

```yaml
display:
  interim_assistant_messages: false
platforms:
  line:
    tool_progress: off
```

---

## 🌟 殺手級功能 2：多媒體回覆（圖／音／影）

LINE Messaging API **不接受二進位上傳**，所有圖片／語音／影片都要先變成「可被 LINE 伺服器下載的 HTTPS URL」。

Hermes 自動處理這個：

1. 你在 `.env` 設 `LINE_PUBLIC_URL=https://<你的隧道網址>`
2. Hermes 內部把媒體檔暫存到 `~/.hermes/media/`，並掛載成 `/line/media/<token>/<filename>`
3. AI 要發圖 → Hermes 自動生 URL → LINE 伺服器去下載 → 推送給使用者

### 注意事項

- `LINE_PUBLIC_URL` 一定要設，**不然 `send_image` 會報「LINE_PUBLIC_URL must be set」**
- 隧道 URL 改變時，記得同步更新 `LINE_PUBLIC_URL`
- 媒體檔有效期由 token 決定，看完 / 過期後 LINE 端 URL 就失效

---

## 🌟 殺手級功能 3：Cron 排程通知

想讓 Hermes 排程任務跑完自動 push 結果到 LINE？

```env
LINE_HOME_CHANNEL=<你的 User ID 或群組 ID>
```

在 `config.yaml` 或 cron 任務裡指定：

```yaml
deliver: line
```

無論排程跑在主進程還是獨立進程，Hermes 都會把結果 push 到 `LINE_HOME_CHANNEL`。

---

## 環境變數完整參考（15 個 `LINE_*`）

| 變數 | 必填 | 預設 | 說明 |
|------|------|------|------|
| `LINE_CHANNEL_ACCESS_TOKEN` | ✅ | — | 長期 Channel Access Token |
| `LINE_CHANNEL_SECRET` | ✅ | — | Channel Secret（HMAC-SHA256 簽章驗證）|
| `LINE_HOST` | — | `0.0.0.0` | Webhook 綁定主機 |
| `LINE_PORT` | — | `8646` | Webhook 監聽埠口 |
| `LINE_PUBLIC_URL` | 媒體必填 | — | 隧道公開 HTTPS URL（圖／音／影必要）|
| `LINE_ALLOWED_USERS` | 三選一 | — | 逗號分隔 User ID（`U` 開頭）|
| `LINE_ALLOWED_GROUPS` | 三選一 | — | 逗號分隔群組 ID（`C` 開頭）|
| `LINE_ALLOWED_ROOMS` | 三選一 | — | 逗號分隔房間 ID（`R` 開頭）|
| `LINE_ALLOW_ALL_USERS` | 開發用 | `false` | 略過白名單（測試用，**生產別開**）|
| `LINE_HOME_CHANNEL` | — | — | 排程通知預設目標 |
| `LINE_SLOW_RESPONSE_THRESHOLD` | — | `45` | postback 觸發秒數（`0` = 停用） |
| `LINE_PENDING_TEXT` | — | `"🤔 Still thinking…"` | 按鈕旁文字 |
| `LINE_BUTTON_LABEL` | — | `"Get answer"` | 按鈕標籤 |
| `LINE_DELIVERED_TEXT` | — | `"Already replied ✅"` | 重複點擊回覆 |
| `LINE_INTERRUPTED_TEXT` | — | `"Run was interrupted before completion."` | `/stop` 後回覆 |

---

## 5 個官方 Troubleshooting

### Q1：LINE Console Verify 失敗，顯示 "invalid signature"

**檢查順序**：
1. `LINE_CHANNEL_SECRET` 有沒有複製錯（前後空白、漏字）
2. 隧道有沒有改寫請求 body（一般 ngrok / Cloudflare Tunnel 不會，但企業 proxy 會）
3. 跑健康檢查：`curl -i https://<隧道>/line/webhook/health` → 應回 `{"status":"ok","platform":"line"}`

### Q2：Bot 在群組沒回應

**症狀**：私訊 OK，但拉進群組就裝死。

**原因**：群組 ID 沒在白名單。

**解法**：
1. 看 log：`tail -f ~/.hermes/logs/gateway.log | grep "rejecting unauthorized source"`
2. log 會告訴你那個 `C...` 群組 ID
3. 把它加進 `LINE_ALLOWED_GROUPS`
4. `hermes gateway restart`

### Q3：`send_image` 失敗，訊息「LINE_PUBLIC_URL must be set」

**原因**：你沒設 `LINE_PUBLIC_URL`，所以 Hermes 無法生公開的媒體 URL 給 LINE 抓。

**解法**：在 `.env` 補上：

```env
LINE_PUBLIC_URL=https://<你的隧道網址>
```

→ `hermes gateway restart`

### Q4：postback 按鈕沒出現

**可能原因**：
- LLM 回應太快（< `LINE_SLOW_RESPONSE_THRESHOLD` 秒），不需要按鈕
- 其他氣泡（工具進度、串流）先消耗 reply token → 加 `tool_progress: off` 跟 `interim_assistant_messages: false`

### Q5：報錯 "already in use by another profile"

**原因**：同一個 Channel Access Token 被另一個正在跑的 Hermes profile 綁定。

**解法**：
- 停掉另一個 Gateway（`hermes gateway stop`）
- 或開新的 LINE Channel 給這個 profile 用

---

## 已知限制（LINE Messaging API 本身）

| 限制 | 細節 |
|------|------|
| 單氣泡 **5000 字元**上限 | 一次 reply 最多 5 個氣泡，超長回應會被截斷 |
| **無原生訊息編輯** | 串流回應總是發新氣泡，不會編輯舊訊息 |
| **Markdown 不渲染** | `**粗體**`、`*斜體*`、` ``` 程式碼` 都是字面顯示。URL 會保留：`[label](url)` 變成 `label (url)` |
| **輸入指示器（typing...）限私訊** | 群組／房間不顯示 chat/loading 動畫 |

---

## 跟 Bridge 方案並存（不建議，但可以）

兩條路線**用同一個 `~/.hermes/.env`**，所以**不能同時啟用同一個 LINE Channel**。

但你可以：
- **官方原生**綁 LINE Channel A
- **Bridge 方案**綁 LINE Channel B

各自跑各自的 Webhook URL，互不衝突。但**正常人沒必要這樣搞**——挑一條走就好。

---

## 接下來看哪一頁？

| 你的下一步 | 看這一頁 |
|----------|---------|
| 要設 Cloudflare Tunnel 固定 URL | 「🌩️ Cloudflare Tunnel」 |
| 要 Bot 同時開 Telegram | 「✈️ Telegram 機器人設定」 |
| 想接 Webhook 之外的訊息平台 | 「💡 使用情境」 |
| 已有 Bridge 在跑、不想轉移 | 「💚 LINE Bridge 進階方案」 |
| 要重啟流程 | 「▶️ 每次啟動愛馬仕龍蝦」 |
