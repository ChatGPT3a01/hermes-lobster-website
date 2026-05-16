# 🦞🪽 愛馬仕龍蝦 HermesAgent<br>一鍵安裝與手動安裝教學

> 將 NousResearch 開源 AI Agent 平台串接 **Telegram** 或 **LINE Bot**，透過一鍵安裝精靈，五分鐘內完成部署！

---

## 什麼是愛馬仕龍蝦？

**愛馬仕龍蝦** = **HermesAgent**（愛馬仕）+ **龍蝦**（阿亮老師的龍蝦教學系列）

HermesAgent 是 [NousResearch](https://nousresearch.com) 開發的通用型 AI Agent 平台，採用 MIT 開源授權。它不只是聊天機器人，而是一個具備**工具調用、長期記憶、技能擴充**的完整 AI 代理人框架。

阿亮老師為 HermesAgent 開發了**一鍵安裝精靈**，讓零基礎的使用者也能輕鬆完成安裝與設定，快速擁有自己的 AI 管家！

---

## 核心特色

| 特色 | 說明 |
|------|------|
| 🤖 通用型 Agent | 不只聊天，可以使用工具、執行多步驟任務 |
| 🧠 長期記憶 | 對話記憶持續累積，越用越聰明 |
| 🔌 技能擴充 | 支援 MCP、自訂工具、技能包 |
| 📱 多平台接入 | 同時支援 Telegram（輪詢模式）和 LINE（Webhook 模式）|
| 🆓 多種 AI 大腦 | 支援 Claude、OpenAI、Gemini、Ollama（本地）等 |
| 🪟 跨平台安裝 | Windows（原生）/ Mac / WSL2 皆可使用 |

---

## 架構總覽

```
📱 Telegram  ←──→  HermesAgent（Port 8642）
                      ↕（Polling 模式，免 ngrok）

📱 LINE Bot  ──→  ngrok（Port 3000）
                      ↕
              LINE Bridge（Node.js, Port 3000）
                      ↕
              HermesAgent（Port 8642）
```

---

## 快速開始：先選你的路線

> [!IMPORTANT]
> Hermes Agent 在 2026/5 後**有兩條安裝路線**：圖形化的 **Desktop GUI**（新手首選）和原本的 **CLI 一鍵安裝精靈**（進階／開發者）。
> 兩條路線**底層共用同一個 `~/.hermes`**，沒有衝突，挑你舒服的那條開始。

| 路線 | 適合 | 安裝時間 | 學習曲線 |
|------|------|---------|---------|
| 🖥️ **Hermes Desktop GUI** | 零基礎、長輩、老師、教學示範 | 5 分鐘 | ⭐ |
| ⚡ **CLI 一鍵安裝精靈** | 想接 LINE / 想深度客製 / 寫腳本自動化 | 30 分鐘 | ⭐⭐⭐ |

---

### 🖥️ 路線 1：Hermes Desktop GUI（新手首選，2026-05 新增）

最新版 **v0.4.3**（2026-05-15 發布），雙擊安裝、零終端機。

> ⬇️ **[到官方 Releases 下載](https://github.com/fathah/hermes-desktop/releases)**：Windows `.exe` / Mac `.dmg` / Linux `.AppImage`
> 📖 **詳細教學請看左側「🖥️ Hermes Desktop GUI」那一頁**

| 平台 | 直接下載連結 |
|------|-------------|
| 🪟 Windows 10/11 | [hermes-desktop-0.4.3-setup.exe](https://github.com/fathah/hermes-desktop/releases/download/v0.4.3/hermes-desktop-0.4.3-setup.exe) |
| 🍎 Mac (M1/M2/M3/M4) | [hermes-desktop-0.4.3-arm64.dmg](https://github.com/fathah/hermes-desktop/releases/download/v0.4.3/hermes-desktop-0.4.3-arm64.dmg) |
| 🍎 Mac (Intel) | [hermes-desktop-0.4.3-x64.dmg](https://github.com/fathah/hermes-desktop/releases/download/v0.4.3/hermes-desktop-0.4.3-x64.dmg) |
| 🐧 Linux | [hermes-desktop-0.4.3.AppImage](https://github.com/fathah/hermes-desktop/releases/download/v0.4.3/hermes-desktop-0.4.3.AppImage) |

- ✅ 免 WSL2、免命令列、免右鍵以管理員身分執行
- ✅ 內建：聊天、Profile、記憶、Skills、Tools、16 種訊息網關、Cron 排程
- ✅ MIT 授權開源，Nous Research 在官方 README 認可
- ⚠️ **不支援 LINE Bot**（要 LINE → 用下面路線 2 或看「💚 LINE 機器人設定」）

---

### ⚡ 路線 2：CLI 一鍵安裝精靈（進階／開發者）

#### 一行指令背後的 10 步自動化

過去要打十多個指令、檢查一堆錯誤的繁瑣安裝流程，現在被官方濃縮成**一行 PowerShell 指令**：

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

這一行背後會自動跑完 **10 步**：
**uv → Python 3.11 → Node.js 22 → Git → 複製倉庫 → 相依套件 → 訊息 SDK → Bash PATH → 系統 PATH → 設定精靈**

> [!TIP]
> 詳細 10 步流程說明、可選旗標、資料目錄差異請見「Windows 安裝教學」頁。

#### 🪟 Windows 一鍵安裝精靈（阿亮老師加值版）

> ⬇️ **[點我下載 Windows 一鍵安裝精靈（ZIP）](HermesAgent-Installer.zip)**

阿亮老師的安裝精靈在官方 10 步基礎上，**額外加上 LINE Bridge（官方原生不支援）+ Telegram 引導 + ngrok 自動設定 + Windows 已知 bug 修復**。

1. 下載並解壓縮安裝精靈
2. 雙擊 `install-hermes.exe`（V6.53 起取代 `go.bat`，不會跳黑視窗）
3. 選擇 **[1] 全部安裝**，跟著精靈走！

#### 🍎 Mac 一鍵安裝腳本

> ⬇️ **[點我下載 Mac 一鍵安裝腳本（Shell Script）](install-hermes-mac.sh)**

> 🧠 **[愛馬仕龍蝦安裝SKILL與知識庫下載](HermesLobster-SKILL.zip)**

```bash
# 下載後執行：
bash install-hermes-mac.sh
```

#### 🤖 AI Agent 自動安裝（有 Claude Code / Codex CLI 的用這個！）

已安裝 Claude Code 或 Codex CLI？下載解壓縮後，進資料夾啟動 AI，貼上這句話：

```
【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
```

AI 會自己讀腳本、執行、排錯、完成安裝。詳細說明見左側「🤖 AI 自動安裝」。

---

### 💚 想接 LINE Bot？兩條路線選一條

2026/5 起 Hermes 已官方支援 LINE，**新手請走官方原生**（功能多、穩定、URL 可固定）：

| 我的情況 | 看這一頁 |
|---------|---------|
| 第一次裝 LINE Bot | **「💚 LINE 官方原生方案」**（推薦）|
| 已經跑 Bridge 跑得好的 | 「💚 LINE Bridge 進階方案」（保留）|
| 想用 URL 永遠不變的隧道 | **「🌩️ Cloudflare Tunnel」**（取代 ngrok，免費）|

### ✈️ 想接 Telegram？最簡單

Telegram **不需要任何隧道**（Polling 模式），架構最單純。看「✈️ Telegram 機器人設定」。

### 🔄 已經有 OpenClaw 龍蝦？想無痛轉移？

兩個工具**可以同時跑在同一台電腦**互不衝突。看左側「🔄 從 OpenClaw 無痛轉移」那一頁。

### 🔶 已經用 Claude Desktop？想串免費 / 本地 LLM？

Claude Desktop 2026/4 起新增 **Cowork on Third-Party Platforms**，能改走 OpenRouter / Ollama。看左側「🔶 Claude Cowork 第三方 API」那一頁。

---

## 學習路徑

```
Step 1  →  認識 HermesAgent
Step 2  →  了解使用情境
Step 3  →  挑路線：Desktop GUI（新手）or CLI 一鍵安裝（進階）
Step 4  →  設定 AI 大腦（OpenRouter / Gemma 4 / Ollama 三選一）
Step 5  →  設定 Telegram 或 LINE
Step 6  →  熟悉常用指令、進階功能
```

點選左側目錄，開始你的 AI 管家之旅！

---

> [!TIP]
> **建議從「使用情境」開始讀**，先了解 HermesAgent 能幫你做什麼，再決定要安裝哪些功能！
> **完全零基礎的人**請直接看「🖥️ Hermes Desktop GUI」那一頁，雙擊安裝就能用。
