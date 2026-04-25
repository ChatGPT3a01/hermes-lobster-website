# Telegram 機器人設定

Telegram 是最容易整合的平台！HermesAgent 原生支援 Telegram Polling 模式，**不需要 ngrok**，隨開即用！

---

## 架構說明

```
📱 Telegram App  ←──→  Telegram 伺服器
                              ↕（Polling 輪詢）
                        HermesAgent Gateway
                        （Port 8642）
```

HermesAgent 主動向 Telegram 伺服器拉取訊息（每 1 秒），不需要公開 URL。

---

## Step 1：申請 Bot Token

1. 在 Telegram 中搜尋 **@BotFather**
2. 傳送 `/newbot`
3. 輸入機器人名稱（如：`愛馬仕助理`）
4. 輸入機器人帳號（如：`my_hermes_bot`，必須以 `bot` 結尾）
5. 複製收到的 **Bot Token**（格式：`1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`）

> [!WARNING]
> Bot Token 是你的機器人身份憑證，**請妥善保管，不要公開分享！**

---

## Step 2：取得你的 User ID

1. 在 Telegram 中搜尋 **@userinfobot**
2. 傳送任意訊息或 `/start`
3. 記下顯示的 **Id**（純數字，如：`987654321`）

這個 ID 用來讓 HermesAgent 知道哪些人可以和它對話（白名單）。

---

## Step 3：設定 HermesAgent

### 方法 A：使用安裝精靈（最簡單）

在安裝精靈中選擇 **[3A] 設定 Telegram**，輸入 Token 和 User ID，精靈自動完成設定。

### 方法 B：手動設定（Windows）

開啟 PowerShell，執行：

```powershell
hermes config set TELEGRAM_BOT_TOKEN 你的Bot Token
hermes config set TELEGRAM_ALLOWED_USERS 你的UserID
```

或直接編輯設定檔（正確路徑）：
```
C:\Users\你的名字\.hermes\.env
```

PowerShell 快速開啟：
```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

加入：
```
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_ALLOWED_USERS=987654321
```

### 方法 C：手動設定（Mac/Linux）

```bash
hermes config set TELEGRAM_BOT_TOKEN 你的Bot Token
hermes config set TELEGRAM_ALLOWED_USERS 你的UserID
```

或編輯 `~/.hermes/.env`：
```bash
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_ALLOWED_USERS=987654321
```

---

## Step 4：啟動 Gateway

### Windows

```powershell
hermes gateway run
```

### Mac / Linux

```bash
hermes gateway start
```

---

## Step 5：⭐ 關鍵步驟：設定 /sethome

這一步非常重要！沒有設定 `/sethome`，AI 不知道要回覆到哪裡！

1. 開啟 Telegram，找到你的機器人
2. 傳送 `/start`
3. 接著傳送 `/sethome`

成功後，HermesAgent 會記住這個對話視窗，之後所有 AI 回覆都會發到這裡。

> [!WARNING]
> **/sethome 是必要步驟！** 很多人設定完發現機器人沒有回應，通常就是因為忘記傳送 `/sethome`。

---

## 測試對話

設定完成後，直接在 Telegram 跟機器人說話：

```
你：你好！你是誰？
AI：你好！我是愛馬仕助理，由 HermesAgent 驅動的 AI 代理人...

你：幫我寫一首關於台灣夜市的詩
AI：（生成詩文）
```

---

## 多人使用設定

如果想讓多個使用者都能使用，在 `TELEGRAM_ALLOWED_USERS` 加入多個 User ID：

```
TELEGRAM_ALLOWED_USERS=987654321,111222333,444555666
```

用逗號分隔，不要有空格。

---

## 常見問題

**Q：傳訊息給機器人，沒有任何回應？**

A：依序檢查：
1. 是否已執行 `hermes gateway run`（或 `start`）？
2. 是否已傳送 `/sethome`？
3. 你的 User ID 是否在 `TELEGRAM_ALLOWED_USERS` 中？
4. Bot Token 是否正確？

```powershell
# Windows 診斷
hermes doctor
```

**Q：可以在群組中使用嗎？**

A：可以，但需要額外設定。將機器人加入群組，並使用 @機器人帳號 來觸發對話。

**Q：機器人回覆很慢？**

A：HermesAgent 使用 Polling 模式，延遲約 1-2 秒是正常的。若 AI 生成內容較長，等待時間會更久。

**Q：想同時設定 Telegram 和 LINE？**

A：可以！兩個平台可以同時使用，共用同一個 HermesAgent Gateway。

---

## Telegram Bot 指令

你可以在 BotFather 設定這些常用指令（可選）：

```
start - 開始對話
help - 顯示說明
clear - 清除對話記憶
status - 查看服務狀態
```

在 BotFather 中：
1. `/mybots` → 選擇你的 Bot
2. `Edit Bot` → `Edit Commands`
3. 貼上指令清單
