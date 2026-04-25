# LINE 機器人設定

> [!WARNING]
> LINE 整合為**阿亮老師自製 Bridge 方案**（非 HermesAgent 官方內建功能）。  
> 透過 Node.js Bridge 將 LINE Webhook 轉接至 HermesAgent API，需搭配 ngrok 運作。

LINE 需要透過「LINE Bridge」橋接程式，並搭配 ngrok 建立公開 HTTPS URL。整個架構略複雜，但阿亮老師的安裝精靈已幫你自動完成！

---

## 架構說明

```
📱 LINE App
     ↓（使用者傳訊）
LINE 伺服器
     ↓（Webhook 推送）
ngrok（公開 HTTPS URL）
     ↓（轉發）
LINE Bridge（Node.js, Port 3000）
     ↓（OpenAI 相容 API）
HermesAgent Gateway（Port 8642）
     ↓（AI 回覆）
LINE Bridge → LINE 伺服器 → 使用者
```

---

## 準備工作

### 需要申請的帳號

1. **LINE Developers 帳號**（免費）：[developers.line.biz](https://developers.line.biz/)
2. **ngrok 帳號**（免費）：[ngrok.com](https://ngrok.com/)

---

## Step 1：建立 LINE Messaging API Channel

1. 登入 [LINE Developers Console](https://developers.line.biz/)
2. 建立或選擇一個 **Provider**（可以用你的名字）
3. 建立 **Messaging API Channel**
4. 填寫：
   - Channel name：`愛馬仕助理`（或任意名稱）
   - Channel description：AI 助理機器人
   - Category：選擇適合的分類
5. 同意條款，點選建立

---

## Step 2：取得金鑰

建立完成後，在 Channel 設定頁面取得：

**Basic settings 頁面：**
- `Channel Secret`（32 位英數字串）

**Messaging API 頁面：**
- `Channel Access Token`（點選 Issue 生成長期 Token）

> [!WARNING]
> 這兩個金鑰非常重要，請妥善保管！

---

## Step 3：安裝 ngrok

### Windows（安裝精靈自動處理）

安裝精靈選項 **[4] 設定 ngrok**，會自動下載並設定。

### Mac

```bash
brew install ngrok/ngrok/ngrok
```

### 設定 ngrok Authtoken

1. 登入 [ngrok.com](https://ngrok.com/)，複製你的 Authtoken
2. 執行：

```bash
ngrok config add-authtoken 你的_Authtoken
```

---

## Step 4：設定 LINE Bridge

### 使用安裝精靈（Windows）

選擇 **[3B] 設定 LINE**，輸入 Channel Secret 和 Access Token，精靈自動建立 `.env` 檔案。

### 手動設定

複製範本並編輯：

```bash
# 進入 bridge 目錄
cd bridge

# 複製設定範本
cp .env.example .env

# 編輯設定
notepad .env   # Windows
nano .env      # Mac/Linux
```

填入以下內容：

> [!WARNING]
> **HermesAgent v0.10+ 已不提供 `localhost:8642` HTTP API！**  
> LINE Bridge 直接對接 AI 供應商，三種選擇如下：

```
LINE_CHANNEL_SECRET=你的_Channel_Secret
LINE_CHANNEL_ACCESS_TOKEN=你的_Channel_Access_Token

# ══════════════════════════════════════════
# 選擇一種 AI 大腦填入（其他行加 # 註解掉）
# ══════════════════════════════════════════

# 選項 A：Google AI Studio Gemini（完全免費 🆓）
# 申請：https://aistudio.google.com/
HERMES_API_URL=https://generativelanguage.googleapis.com/v1beta/openai/chat/completions
HERMES_API_KEY=你的_Google_AI_Studio_Key
HERMES_MODEL=gemini-2.5-flash

# 選項 B：OpenAI 直連（有 API Key 的人）
# HERMES_API_URL=https://api.openai.com/v1/chat/completions
# HERMES_API_KEY=sk-proj-你的_OpenAI_Key
# HERMES_MODEL=gpt-4o

# 選項 C：OpenRouter（支援 OpenAI / Claude / Gemini 等多種模型）
# HERMES_API_URL=https://openrouter.ai/api/v1/chat/completions
# HERMES_API_KEY=sk-or-你的_OpenRouter_Key
# HERMES_MODEL=openai/gpt-4o

BRIDGE_PORT=3000
BOT_NAME=愛馬仕助理
SYSTEM_PROMPT=你是一位聰明、親切的 AI 助理。請用繁體中文回答。
```

---

## Step 5：安裝 Node.js 相依套件

```bash
cd bridge
npm install
```

---

## Step 6：依序啟動服務

**順序非常重要！**

### 1. 啟動 HermesAgent Gateway

```powershell
# Windows
hermes gateway run
```

```bash
# Mac / Linux
hermes gateway start
```

### 2. 啟動 LINE Bridge

```bash
cd bridge
npm start
```

成功後會看到：
```
  ╔══════════════════════════════════════════════════════╗
  ║  🦞🪽  愛馬仕助理 LINE Bridge 啟動成功！            ║
  ╠══════════════════════════════════════════════════════╣
  ║  監聽 Port   : 3000                                  ║
  ╚══════════════════════════════════════════════════════╝
```

### 3. 啟動 ngrok

```bash
ngrok http 3000
```

記下輸出的 HTTPS URL，例如：
```
https://abc123.ngrok-free.app
```

---

## Step 7：設定 LINE Webhook

1. 回到 [LINE Developers Console](https://developers.line.biz/)
2. 進入你的 Channel → **Messaging API**
3. 在 **Webhook URL** 填入：
   ```
   https://abc123.ngrok-free.app/webhook
   ```
4. 點選 **Verify** 驗證（應顯示 `Success`）
5. 開啟 **Use webhook** 開關

> [!NOTE]
> **免費版 ngrok 每次重啟 URL 會改變**，每次重啟後需要更新 LINE Webhook URL。

---

## Step 8：加入機器人好友

1. 在 LINE Developers Console 的 **Messaging API** 頁面，掃描 QR Code
2. 或在 LINE App 搜尋你的機器人 ID（`@xxxxxx` 格式）
3. 加入好友後，傳送 `你好！` 測試

---

## 測試連線

在瀏覽器開啟：

```
http://localhost:3000/test?msg=你好
```

或：

```
http://localhost:3000/test?msg=Hello
```

若成功，會看到 AI 的回覆 JSON。

---

## LINE Bridge 特殊指令

| 指令 | 功能 |
|------|------|
| `/clear` 或 `清除記憶` | 清除對話歷史 |
| `/help` 或 `說明` | 顯示指令說明 |
| `/status` | 查看服務狀態 |

---

## 常見問題

**Q：LINE Console 驗證 Webhook 失敗？**

A：檢查：
1. HermesAgent Gateway 是否在執行？（`hermes gateway status`）
2. LINE Bridge 是否在執行？（`npm start`）
3. ngrok 是否在執行？
4. Webhook URL 是否為 ngrok URL + `/webhook`？

**Q：每次重開電腦都要重新設定 ngrok URL？**

A：是的，免費版 ngrok URL 每次都會變。若需要固定 URL，可以：
- 付費升級 ngrok（有固定 subdomain）
- 使用其他免費隧道服務（如 Cloudflare Tunnel）

**Q：可以讓多個人都加入機器人好友嗎？**

A：可以！LINE Bot 預設是公開的，任何人都可以加入好友（除非你設定了群組限制）。

---

> [!TIP]
> **想更省事？用 Telegram！** Telegram 不需要 ngrok，設定更簡單。如果你對 ngrok 感到麻煩，可以先從 Telegram 開始體驗 HermesAgent。
