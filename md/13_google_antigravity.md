# Google Antigravity 完整教學

> **Google Antigravity** = 用 Google AI Studio 的免費 Gemini API，作為愛馬仕龍蝦的 AI 大腦。
> 不需要任何訂閱，不需要信用卡，完全免費！

---

## 什麼是 Google Antigravity？

**Google Antigravity** 是阿亮老師課程的獨家命名——象徵 Google AI 生態圈的力量「突破重力」，讓人人都能免費使用強大 AI。

| 方案 | 費用 | 速度 | 能力 |
|------|------|------|------|
| Claude Code | 需 Claude Pro/Max 訂閱 | 最快 | 最強 |
| Codex CLI | 需 ChatGPT Plus 訂閱 | 快 | 強 |
| **Google Antigravity** | **完全免費** | 快 | **非常強（Gemini 2.5）** |
| Ollama | 免費（本機）| 慢 | 依電腦效能 |

> [!TIP]
> **沒有任何訂閱？Google Antigravity 是你的首選！**
> Gemini 2.5 Flash 免費版效果相當好，完全能應付日常使用。

---

## Step 1：申請 Google AI Studio 免費 API Key

### A. 開啟 Google AI Studio

前往：**https://aistudio.google.com/**

用你的 **Google 帳號**登入（一般 Gmail 帳號就可以）。

### B. 產生 API Key

1. 左側選單點 **「Get API key」**
2. 點 **「Create API key」**
3. 選擇一個 Google Cloud 專案（或建立新的）
4. 複製產生的 API Key（格式：`AIzaSy...`，約 39 個字元）

> [!WARNING]
> API Key 請妥善保管，貼到 `C:\OpenClaw_Auto\龍蝦資料.txt` 備存。

### C. 確認免費額度

登入後點右上角 → **「配額」（Quota）**，可以看到免費使用量：

| 模型 | 免費額度（每分鐘）|
|------|----------------|
| gemini-3-flash-preview | 15 次請求 / 分鐘 |
| gemini-3-pro-preview | 2 次請求 / 分鐘 |

> 一般個人使用完全夠用！

---

## Step 2：設定 HermesAgent 使用 Google Antigravity

### 方法 A：LINE Bridge 使用 Gemini（最常用）

打開 LINE Bridge 的設定檔：

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

找到 AI 大腦設定的部分，改成：

```env
# ── Google Antigravity（Gemini 免費）──────────────────────
HERMES_API_URL=https://generativelanguage.googleapis.com/v1beta/openai/chat/completions
HERMES_API_KEY=AIzaSy你的_Google_AI_Studio_Key
HERMES_MODEL=gemini-3-flash-preview

# 其他 AI 大腦選項（先用 # 註解掉）
# HERMES_API_KEY=sk-proj-...   ← OpenAI
# HERMES_MODEL=gpt-5.4
```

**Ctrl+S 存檔**，重啟 Bridge：

```powershell
cd C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge
node line-bridge.js
```

LINE 傳訊息測試，AI 就用 Gemini 免費回覆了！

---

### 方法 B：HermesAgent Gateway 使用 Gemini

打開 HermesAgent 設定：

```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

加入或修改：

```env
LLM_PROVIDER=google
GOOGLE_API_KEY=AIzaSy你的_Google_AI_Studio_Key
LLM_MODEL=gemini-3-flash-preview
```

**Ctrl+S 存檔**，重啟 Gateway：

```powershell
hermes gateway restart
```

---

## Step 3：選擇 Gemini 模型

| 模型 | 免費 | 速度 | 能力 | 建議用途 |
|------|------|------|------|---------|
| `gemini-3-flash-preview` | ✅ | ⚡⚡⚡ | 強 | **日常使用推薦（2026 最新）** |
| `gemini-3-pro-preview` | ✅ (限量) | ⚡⚡ | 最強 | 複雜推理/旗艦任務 |

> [!TIP]
> 建議先用 `gemini-3-flash-preview`，速度快又免費。有需要更強的推理再換 pro。

---

## Step 4：用 Gemini 當終端機 AI 助理

### 安裝 Gemini CLI（Google 官方工具）

```powershell
npm install -g @google/gemini-cli
```

驗證安裝：

```powershell
gemini --version
```

### 設定 API Key

```powershell
# Windows 永久設定
[System.Environment]::SetEnvironmentVariable('GEMINI_API_KEY', 'AIzaSy你的Key', 'User')
```

設完後**重開 PowerShell**。

### 啟動 Gemini CLI

```powershell
cd 你的專案資料夾
gemini
```

進入互動模式後，就可以用自然語言操作檔案和程式：

```
> 幫我分析這個資料夾的腳本結構
> 找出 line-bridge.js 中負責轉發訊息的函式
> 【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
```

---

## Google Antigravity vs 其他工具比較

| 功能 | Google Antigravity | Claude Code | Codex CLI |
|------|-------------------|-------------|-----------|
| 費用 | **免費** | 需訂閱 | 需訂閱或 API |
| 終端機 AI | ✅ Gemini CLI | ✅ claude | ✅ codex |
| LINE Bot 大腦 | ✅ 最佳免費選擇 | ✅ | ✅ |
| 程式碼能力 | 強 | 最強 | 強 |
| 中文能力 | ✅ 優秀 | ✅ 優秀 | ✅ 良好 |
| Agent 自動安裝 | ✅ | ✅ | ✅ |

---

## 常見問題

### Q：API Key 用完了怎麼辦？

免費額度是**每分鐘**限制，不是每天用光就沒了。等一分鐘就自動重置。如果真的超量，有兩個選法：
1. 加入付費方案（Google Cloud Billing）
2. 換 `gemini-3-flash-preview` 模型（額度更高）

### Q：Gemini 回覆的語言不對？

在 LINE Bridge 的 `.env` 加入：

```env
SYSTEM_PROMPT=你是一位聰明、親切的 AI 助理。請用繁體中文回答。
```

### Q：可以同時用 Google Antigravity 和 Claude Code 嗎？

可以！LINE Bot 用 Google Antigravity（免費），Claude Code 用於終端機開發，互相不衝突，各司其職。

---

## 完整 .env 設定範本（Google Antigravity 版）

```env
# LINE 憑證
LINE_CHANNEL_SECRET=你的_Channel_Secret
LINE_CHANNEL_ACCESS_TOKEN=你的_Channel_Access_Token

# ── Google Antigravity ──
HERMES_API_URL=https://generativelanguage.googleapis.com/v1beta/openai/chat/completions
HERMES_API_KEY=AIzaSy你的_Google_AI_Studio_Key
HERMES_MODEL=gemini-3-flash-preview

# 基本設定
BRIDGE_PORT=3000
BOT_NAME=愛馬仕助理
SYSTEM_PROMPT=你是一位聰明、親切的 AI 助理，名叫愛馬仕助理。請用繁體中文回答，語氣友善、清楚、直接。
```

---

> [!NOTE]
> 本教學對應書籍《養成你的 AI 龍蝦管家》**第 21 章：Google Antigravity 架構**，更深入的架構說明請參閱書籍！
