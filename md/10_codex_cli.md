# OpenAI Codex CLI 安裝教學

## 什麼是 Codex CLI？

**Codex CLI** 是 OpenAI 於 2025 年發布的開源終端機 AI 編程代理人，讓你用自然語言在命令列直接指揮 AI 完成程式撰寫、檔案修改、命令執行等任務。

> 官方 GitHub：[github.com/openai/codex](https://github.com/openai/codex)  
> 授權：Apache 2.0 開源

---

## 三種使用方案比較

| | Codex CLI（OpenAI Key）| Codex CLI + Ollama |
|--|----------------------|-------------------|
| **費用** | 需 OpenAI API Key（少量費用） | **完全免費** |
| **能力** | 夠用 | 取決於本機模型 |
| **網路需求** | 需要網路 | **可離線使用** |
| **推薦對象** | 沒有 Claude 訂閱 | 完全沒預算 |

> [!TIP]
> 沒有任何預算或訂閱？直接看下方「方案二：Codex CLI + Ollama 完全免費」！

---

## 方案一：Codex CLI（OpenAI API Key）

### 系統需求

| 項目 | 需求 |
|------|------|
| Node.js | 22 以上 |
| 作業系統 | Windows 10/11、macOS 12+、Linux |
| AI 大腦 | ChatGPT Plus/Pro 帳號（OAuth）或 OpenAI API Key |

### 安裝

開啟終端機（Windows 請用 PowerShell 或 CMD），執行：

```bash
npm install -g @openai/codex
```

驗證安裝成功：

```bash
codex --version
```

### 設定 AI 大腦

#### 方法 A：ChatGPT Plus / Pro 訂閱（推薦，免 API 費）

```bash
codex login
```

瀏覽器會自動開啟，用 ChatGPT 帳號登入並授權，**吃月費額度，不另外付費**。

#### 方法 B：OpenAI API Key

**Mac / Linux：**
```bash
export OPENAI_API_KEY=sk-...
```

**Windows PowerShell：**
```powershell
$env:OPENAI_API_KEY = "sk-..."
```

**永久設定（Windows）：**
```powershell
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'sk-...', 'User')
```

---

## 方案二：Codex CLI + Ollama（完全免費）

Ollama 在你電腦本機跑 AI 模型，搭配 Codex CLI 使用，**完全不需要訂閱或 API Key，也可以離線使用**。

> [!TIP]
> 給家裡沒預算的學員：Codex CLI + Ollama + qwen2.5-coder 完全足夠完成一般 Vibecoding 任務，完全不用花錢！

### Step 1：安裝 Ollama

前往 [ollama.com](https://ollama.com) 下載安裝（支援 Windows / Mac / Linux）

```bash
# 安裝後確認
ollama --version
```

### Step 2：下載 AI 模型

```bash
# 推薦：qwen2.5-coder（專為程式設計優化，完全免費）
ollama pull qwen2.5-coder:7b

# 電腦效能較強可用更大的模型
ollama pull qwen2.5-coder:14b

# 確認模型已下載
ollama list
```

> [!NOTE]
> 模型大小約 4～8 GB，第一次下載需要時間。下載後完全離線可用。

### Step 3：啟動 Ollama 伺服器

```bash
ollama serve
```

保持這個視窗開著不要關。

### Step 4：安裝 Codex CLI

```bash
npm install -g @openai/codex
```

### Step 5：設定 Codex CLI 指向 Ollama

**Windows PowerShell：**
```powershell
$env:OPENAI_API_KEY="ollama"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
```

**Mac / Linux：**
```bash
export OPENAI_API_KEY="ollama"
export OPENAI_BASE_URL="http://localhost:11434/v1"
```

### Step 6：啟動 Codex CLI 使用本機模型

```bash
codex --model qwen2.5-coder:7b
```

### 效能比較

```
Claude Code（訂閱版）：速度最快、能力最強、需付費
Codex CLI（OpenAI Key）：速度快、能力不錯、需少量費用
Codex CLI + Ollama：速度較慢、完全免費、可離線
```

---

## 基本使用

### 啟動互動模式

```bash
codex
```

進入後就像在 Terminal 裡和 AI 對話，AI 可以讀取你的程式檔案並直接修改。

### 直接下指令（單行模式）

```bash
codex "幫我寫一個讀取 CSV 的 Python 程式"
codex "分析這個目錄的結構"
codex "找出 index.js 裡的 bug"
```

### 指定工作目錄

```bash
cd 你的專案目錄
codex
```

Codex 會自動讀取當前目錄的程式碼作為上下文。

---

## 安全模式說明

Codex CLI 有三種執行模式，保護你的系統安全：

| 模式 | 說明 | 適合情境 |
|------|------|---------|
| `suggest`（預設）| 只顯示建議，不自動執行 | 初次使用、重要程式碼 |
| `auto-edit` | 自動修改檔案，但不執行 Shell 命令 | 日常開發 |
| `full-auto` | 完全自動（含執行命令）| 信任的隔離環境 |

切換模式：

```bash
codex --approval-mode auto-edit
codex --approval-mode full-auto
```

---

## 與 HermesAgent 的比較

| 功能 | Codex CLI | HermesAgent |
|------|-----------|-------------|
| 主要用途 | 程式開發助理 | 通用 AI 管家 |
| 介面 | 終端機 | Telegram / LINE |
| 長期記憶 | ❌ | ✅ |
| 工具整合（MCP）| 有限 | ✅ 完整 |
| 排程任務 | ❌ | ✅ |
| AI 大腦 | OpenAI | 多種可選 |

> [!TIP]
> Codex CLI 和 HermesAgent 可以**同時使用**、互補！開發時用 Codex CLI 協助寫程式，日常管理用 HermesAgent 透過 Telegram/LINE 指揮 AI。

---

## 常見問題

**Q：`codex` 指令找不到？**

確認 Node.js 版本 22+，並重新開啟終端機讓 PATH 生效：

```bash
node --version   # 需要 v22+
npm --version
```

**Q：登入後說 quota exceeded？**

ChatGPT Plus/Pro OAuth 有使用限制，可以改用 OpenAI API Key（pay-as-you-go）。

**Q：Ollama 方案跑起來速度很慢？**

本機跑 AI 受制於電腦硬體，速度比雲端慢是正常的。可以嘗試下載較小的模型（如 `qwen2.5-coder:7b`），或升級到付費方案。

**Q：可以用在非英文程式碼或繁體中文註解嗎？**

可以！直接用繁體中文下指令，Codex 完全支援。

---

> [!NOTE]
> Codex CLI 是**開發者工具**，主要用於程式撰寫場景。若需要日常對話助手、LINE/Telegram 機器人，請使用 **HermesAgent**！
