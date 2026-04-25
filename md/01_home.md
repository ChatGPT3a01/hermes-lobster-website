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

## 快速開始

### 🪟 Windows 一鍵安裝精靈（推薦新手）

> ⬇️ **[點我下載 Windows 一鍵安裝精靈（ZIP）](HermesAgent-Installer.zip)**

1. 下載並解壓縮安裝精靈
2. 對 `go.bat` 按右鍵 → **以系統管理員身分執行**
3. 選擇 **[1] 全部安裝**，跟著精靈走！

### 🍎 Mac 一鍵安裝腳本

> ⬇️ **[點我下載 Mac 一鍵安裝腳本（Shell Script）](install-hermes-mac.sh)**

> 🧠 **[愛馬仕龍蝦安裝SKILL與知識庫下載](HermesLobster-SKILL.zip)**

```bash
# 下載後執行：
bash install-hermes-mac.sh
```

### 🤖 AI Agent 自動安裝（有 Claude Code / Codex CLI 的用這個！）

已安裝 Claude Code 或 Codex CLI？下載解壓縮後，進資料夾啟動 AI，貼上這句話：

```
【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
```

AI 會自己讀腳本、執行、排錯、完成安裝。詳細說明見左側「🤖 AI 自動安裝」。

---

## 學習路徑

```
Step 1  →  認識 HermesAgent
Step 2  →  了解使用情境
Step 3  →  選擇安裝方式（Windows 或 Mac）
Step 4  →  設定 Telegram 或 LINE
Step 5  →  熟悉常用指令
```

點選左側目錄，開始你的 AI 管家之旅！

---

> [!TIP]
> **建議從「使用情境」開始讀**，先了解 HermesAgent 能幫你做什麼，再決定要安裝哪些功能！
