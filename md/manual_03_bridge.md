# 🌉 Step 3：部署 LINE Bridge

> 預估時間：10 分鐘
> 目標：`http://localhost:3000/` 能回應 JSON

---

## 3-0. ⚠️ 關於路徑：本教學用範例路徑，你的可能不同

本教學所有指令裡的 **`C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge`** 都是**範例路徑**，學員你的實際路徑可能是：

| 常見情境 | 實際路徑範例 |
|---------|------------|
| 解壓到下載資料夾 | `C:\Users\<你>\Downloads\HermesAgent一鍵自動安裝程式\bridge` |
| 解壓到桌面 | `C:\Users\<你>\Desktop\HermesAgent一鍵自動安裝程式\bridge` |
| 放在 D 槽 | `D:\我的資料夾\HermesAgent一鍵自動安裝程式\bridge` |

**有 3 種處理方式，選一個：**

### 方式 A：搬到跟教學一樣的位置（最簡單）

把整個 `HermesAgent一鍵自動安裝程式` 資料夾**剪下貼到** `C:\OpenClaw_Auto\` 下（沒有就建這個資料夾）。之後教學指令都能直接抄。

### 方式 B：記下你的路徑，看到範例就替換

在檔案總管找到你的 `bridge` 資料夾 → 點網址列 → Ctrl+A → Ctrl+C 複製路徑。之後每次看到教學寫 `C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\` 就換成你複製的那段。

### 方式 C：用 🛠 [生成器工具頁](generators.html)（推薦）⭐

到 <https://hermes-lobster.netlify.app/generators.html> 最上方「📂 你的 bridge 資料夾路徑」欄位**填一次你的實際路徑** → 所有生成器輸出的「貼到哪？」都會自動換成你的路徑，不用自己對應。

---

## 3-1. 取得安裝精靈檔案

本教學假設你已經解壓縮了「HermesAgent一鍵自動安裝程式」到：
```
C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\
```

如果還沒，從首頁下載 **Win 安裝精靈 ZIP**，解壓縮到 `C:\OpenClaw_Auto\`。

---

## 3-2. 安裝 Node.js 套件

開 PowerShell（一般權限即可）：

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
npm install
```

會看到：
```
added 97 packages, and audited 98 packages in Xs
0 vulnerabilities
```

> [!NOTE]
> 如果出現 `npm 無法辨識` → Node.js 沒裝好或 PATH 沒刷新，關掉 PowerShell 重開再試。

---

## 3-3. 建立 `.env` 設定檔

> [!WARNING]
> `.env` 檔案的**完整絕對路徑**是：
> ```
> C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env
> ```
> 下面所有 PowerShell 指令都用絕對路徑，**不論你 PowerShell 現在在哪個目錄都能跑**。

### 3-3-1. 複製 .env 範本

```powershell
Copy-Item "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env.example" `
          "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

看到沒有報錯就成功。確認一下檔案真的存在：

```powershell
Test-Path "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

應該回 `True`。

### 3-3-2. 用記事本打開它

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

> [!TIP]
> **路徑一定要整段帶雙引號** — 因為路徑中「HermesAgent一鍵自動安裝程式」有中文，不帶引號 PowerShell 會爆。

如果記事本跳出「找不到此檔案」對話框，代表 3-3-1 沒成功（.env.example 不在）— 先確認你已照 Step 3-1 解壓縮了安裝精靈到正確位置。

### 3-3-3. 貼入憑證

記事本打開後，**把檔案原本所有內容全部刪除**（Ctrl+A 全選、Delete 刪除），然後把下方內容整段貼進去，再把自己的憑證填到對應位置：

```env
# ─────────── LINE Bot 金鑰（Step 2 拿到的） ───────────
LINE_CHANNEL_SECRET=把你的_Channel_Secret_貼這裡
LINE_CHANNEL_ACCESS_TOKEN=把你的_很長的_Access_Token_貼這裡

# ─────────── AI 大腦：Google Gemini（免費、Step 5 會改成 Codex）───────────
# Gemini key 申請：https://aistudio.google.com/app/apikey
HERMES_API_URL=https://generativelanguage.googleapis.com/v1beta/openai/chat/completions
HERMES_API_KEY=AIzaSy...先填你的_Gemini_Key_測試用...
HERMES_MODEL=gemini-2.5-flash

# ─────────── LINE Bridge 本身 ───────────
BRIDGE_PORT=3000
BOT_NAME=愛馬仕助理
MAX_HISTORY=100
SYSTEM_PROMPT=你是一位聰明親切的 AI 助理，請用繁體中文回答。
```

> [!TIP]
> 這階段先用 **Gemini 免費 Key** 測通，Step 5 再換成 ChatGPT Plus 訂閱模式。
> Gemini 免費申請：<https://aistudio.google.com/app/apikey>

存檔關閉。

---

## 3-4. ⚠️ 修 line-bridge.js 的兩個小 bug

阿亮老師原版的 `line-bridge.js` 有兩個 bug 會影響使用。

### 3-4-0. 先打開檔案

檔案**完整路徑**：
```
C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\line-bridge.js
```

用記事本打開：
```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\line-bridge.js"
```

或用 VSCode（若已裝）：
```powershell
code "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\line-bridge.js"
```

打開後，**用 Ctrl+F 搜尋關鍵字**來快速找到要改的地方。

---

### Bug 1：model 寫死

**搜尋（Ctrl+F）**：`model: 'hermes'`

找到後，這一行原本是：
```javascript
      model: 'hermes',
```

**改成**（讓它讀 `HERMES_MODEL` env 變數）：
```javascript
      model: process.env.HERMES_MODEL || 'hermes',
```

> 💡 只改這一行！其他都不動。

---

### Bug 2：webhook 回應太慢

**搜尋（Ctrl+F）**：`Promise.all(req.body.events`

會找到類似這段：
```javascript
app.post('/webhook',
  line.middleware(config),
  (req, res) => {
    Promise.all(req.body.events.map(handleEvent))
      .then(() => res.status(200).json({ status: 'ok' }))
      .catch((err) => {
        console.error('[Webhook 錯誤]', err);
        res.status(500).end();
      });
  }
);
```

**把整個 `app.post('/webhook', ...);` 區塊取代成**：
```javascript
app.post('/webhook',
  line.middleware(config),
  (req, res) => {
    res.status(200).json({ status: 'ok' });  // 立刻回 200
    req.body.events.forEach((event) => {
      handleEvent(event).catch(err => console.error('[event error]', err));
    });
  }
);
```

改完後 **Ctrl+S 存檔** → 關閉記事本。

> **為什麼？** LINE webhook 預設 1 秒內要回應，AI 回答動不動 3-5 秒，會被 LINE 判定失敗並重試。改成「立即 200 + 事件 async 處理」就不會被重試。

---

## 3-5. 啟動 Bridge

```powershell
node line-bridge.js
```

看到以下輸出表示成功：

```
  ╔══════════════════════════════════════════════════════╗
  ║  🦞🪽  愛馬仕助理 LINE Bridge 啟動成功！            ║
  ╠══════════════════════════════════════════════════════╣
  ║  監聽 Port   : 3000                                  ║
  ║  Webhook 路徑: /webhook                              ║
  ║  Hermes API  : https://generativelanguage.googleapis.com/...   ║
  ╚══════════════════════════════════════════════════════╝
```

> [!NOTE]
> **這個 PowerShell 視窗不要關！** Bridge 就是靠它在跑。關了 Bot 就停了。

---

## 3-6. 測試 Bridge

**另外**開一個新 PowerShell（第一個繼續讓 Bridge 跑），執行：

```powershell
Invoke-RestMethod 'http://localhost:3000/'
```

預期：
```
service        : 愛馬仕助理 LINE Bridge
status         : running
port           : 3000
hermes_api     : https://generativelanguage.googleapis.com/...
webhook_path   : /webhook
active_users   : 0
```

然後測 AI 通不通：

```powershell
Invoke-RestMethod 'http://localhost:3000/test?msg=你好請自介'
```

應該看到 Gemini 回答的一段話。如果有回答 → **Bridge 完全正常！**

---

## 3-7. 常見錯誤

### `[錯誤] 缺少 LINE_CHANNEL_SECRET`

`.env` 沒放在 `bridge/` 目錄，或檔名打成 `.env.txt`（記事本默認行為）。

修：檢查 `Get-ChildItem -Force bridge\` 看有沒有 `.env`（不含副檔名）。

### `ECONNREFUSED`

Gemini 連不上。檢查網路，或 `HERMES_API_KEY` 錯了。

### `401 Incorrect API key`

`HERMES_API_KEY` 填錯了，回 Google AI Studio 重新複製。

---

## 🎉 Step 3 完成！

Bridge 已經跑在 `http://localhost:3000/`。但 LINE 伺服器從外網連不到你的電腦 — 所以要 Step 4 架 ngrok 隧道。
