# ✈️ 手動安裝 Telegram 分支（Polling 模式，不需 ngrok）

> 預估時間：10 分鐘
> 目標：在 Telegram 有另一個 Bot，走 Polling（主動拉取）模式，**不需 ngrok**、**不需公開 IP**

---

## 為什麼 Telegram 比 LINE 簡單？

| 平台 | 模式 | 需要 ngrok？ | URL 會變？ |
|------|------|-------------|-----------|
| **Telegram Polling** | Hermes 主動去 Telegram 伺服器「拿」新訊息 | ❌ 不需要 | — |
| LINE Webhook | LINE 伺服器「推」訊息到你電腦 | ✅ 必須 | 免費版每次重啟都變 |

所以 Telegram 部署最輕鬆，只要 **Bot Token + 你的 User ID** 兩樣東西。

---

## T-1. 建立 Telegram Bot（找 @BotFather）

1. 打開**手機 Telegram app**（或電腦版）
2. 搜尋：**`@BotFather`**（官方，藍色驗證勾）
   - 或直接點 <https://t.me/BotFather>
3. 點 **Start** → 傳：
   ```
   /newbot
   ```
4. BotFather 問 Bot 名字（顯示名，可中文）：
   ```
   愛馬仕助理
   ```
5. 問 Username（必須英文、必須以 `bot` 結尾）：
   ```
   myhermes_bot
   ```
   若重複它會叫你換一個。
6. 成功後 BotFather 會給你：
   ```
   Done! Congratulations on your new bot. ...
   Use this token to access the HTTP API:
   1234567890:ABCDEFghijKLMNOpqrsTUVWXYZ...
   ```
   **紅字那行就是 Bot Token**，複製整段。

📝 記到「龍蝦資料.txt」：
```
Telegram Bot Token : 1234567890:ABCDEFghijKLMN...
```

---

## T-2. 取得你自己的 Telegram User ID

Hermes 只回訊給特定 User ID（安全白名單）。

1. 在 Telegram 搜尋：**`@userinfobot`**（或 `@getmyid_bot`）
2. 點 Start → 傳任何訊息（例如 `hi`）
3. 它回：
   ```
   Id: 123456789
   First: 你的名字
   ...
   ```
4. 記下 **Id** 那個純數字

📝 記到「龍蝦資料.txt」：
```
Telegram User ID : 123456789
```

---

## T-3. 填入 Hermes 設定

打開 Hermes 的 `.env`：

```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

**搜尋（Ctrl+F）**：`TELEGRAM_BOT_TOKEN`

找到這兩行（若被註解 `#` 開頭，移除註解 `#`）：
```env
TELEGRAM_BOT_TOKEN=
TELEGRAM_ALLOWED_USERS=
```

**改成**：
```env
TELEGRAM_BOT_TOKEN=1234567890:ABCDEFghijKLMN...
TELEGRAM_ALLOWED_USERS=123456789
```

> **若有多個使用者**用逗號分隔：`TELEGRAM_ALLOWED_USERS=123456789,987654321`

存檔。

---

## T-4. 啟動 Hermes Gateway（Telegram Polling 模式）

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" gateway run
```

看到類似：
```
[hermes] Gateway starting...
[telegram] Polling enabled, bot username: @myhermes_bot
[telegram] Listening for messages from allowed users: 123456789
```

就是通了。

> [!WARNING]
> **這個 PowerShell 視窗不要關！** Gateway 靠它跑。

---

## T-5. 在 Telegram 找 Bot 並設 /sethome

1. 手機 Telegram app 搜尋你剛取的 Bot username（例 `@myhermes_bot`）
2. 點進去 → **Start**
3. ⭐ **第一件事**：傳 `/sethome`
   - 這告訴 Hermes：「我就是你預設要回話的對象」
   - Bot 會回一個確認訊息
4. 接下來傳任何訊息，Bot 就會以 AI 回你

---

## T-6. 常用 Telegram 指令（在 Bot 對話框傳）

| 指令 | 功能 |
|------|------|
| `/sethome` | 設定預設回話頻道（⭐ 必做第一次） |
| `/new` | 開新對話（清除上下文）|
| `/skills` | 瀏覽已啟用的 skill |
| `/usage` | 看 Token 用量與費用 |
| `/voice on` | 開啟語音模式（若啟用 TTS） |

---

## T-7. Telegram vs LINE：一個電腦同時跑兩個嗎？

**可以！** Hermes 的 Gateway 一次可以同時支援 Telegram Polling + LINE Webhook。
- Telegram 走 `hermes gateway run` 主程式
- LINE 走 bridge 的 Node.js 服務（連接同一個 AI 大腦）
- 兩個 Bot 可以有**獨立人格**（看 Step 6 副人格設定）

---

## 🎉 Telegram 分支完成！

沒有 ngrok、沒有 Webhook、沒有外部 URL — Telegram Polling 是最省事的部署方式。

**想試更多功能**回去看：
- Step 6：進階功能（記憶、副人格、自拍生圖）
- Step 7：安裝 75 個 Skill
