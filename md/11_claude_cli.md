# Claude Code CLI 安裝教學

## 什麼是 Claude Code？

**Claude Code** 是 Anthropic 開發的終端機 AI 助手 CLI 工具，讓你在命令列直接呼叫 Claude 協助分析程式碼、撰寫功能、執行多步驟任務，並可深度整合 Git 工作流程。

> 官方網站：[claude.ai/code](https://claude.ai/code)  
> 本書《養成你的 AI 龍蝦管家》CH20 有完整深度教學！

---

## ⚠️ 重要：Claude Code 不是用 npm 安裝

很多學員第一次找到這個舊指令：

```text
npm install -g @anthropic-ai/claude-code
```

**這個方法已被官方標示為淘汰（deprecated），請不要使用。**

Anthropic 在 2025 年改為提供**原生安裝程式**，有明顯優點：

| 比較 | 舊方法（npm） | 新方法（原生安裝） |
|------|--------------|-------------------|
| 需要 Node.js | ✅ 要先裝 | ❌ 不需要 |
| 安裝速度 | 慢（拉套件） | 快（直接下載執行檔） |
| PATH 設定 | 常常要手動 | WinGet 版自動處理 |
| 更新方式 | `npm update -g` | `claude update` |
| 官方推薦 | ❌ 已淘汰 | ✅ 現在的正確方式 |

---

## 系統需求

| 項目 | 需求 |
|------|------|
| 作業系統 | Windows 10/11、macOS 12+、Linux |
| AI 大腦 | Claude Pro/Max 帳號（OAuth）或 Anthropic API Key |
| Node.js | **不需要**（原生安裝版） |

> [!NOTE]
> 原生安裝版已內建所有依賴，不需要事先安裝 Node.js 或 npm。

---

## 安裝

### Windows

> [!WARNING]
> 安裝前必須先裝 **Git for Windows**，Claude Code 在 Windows 上需要 Git Bash 才能運作。
> 沒裝 Git 的話，安裝過程會出現紅色警告，而且 `claude` 指令跑不起來。
>
> 下載：[git-scm.com/downloads/win](https://git-scm.com/downloads/win)（全部按預設下一步，裝完**重開機**）

#### 方式 A：WinGet（最省事，推薦）

開啟 **PowerShell** 或 **CMD**，貼上：

```powershell
winget install Anthropic.ClaudeCode
```

WinGet 會自動處理 PATH 設定，通常不會卡在「找不到 claude 指令」的問題。

#### 方式 B：原生安裝腳本

用 **PowerShell**：

```powershell
irm https://claude.ai/install.ps1 | iex
```

用 **CMD**：

```cmd
powershell -Command "irm https://claude.ai/install.ps1 | iex"
```

安裝完後，**完全關掉視窗，重新開一個新的 PowerShell / CMD**，再執行：

```cmd
claude --version
```

### Mac / Linux

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

或用 Homebrew：

```bash
brew install --cask claude-code
```

驗證安裝成功（重開終端機後）：

```bash
claude --version
```

---

## 登入設定

### 方法 A：Claude Pro / Max 訂閱（推薦，免 API 費）

```bash
claude
```

首次執行會自動引導登入，選擇「**Login with Claude.ai**」，瀏覽器授權後即可使用，**吃訂閱月費，不另外計費**。

### 方法 B：Anthropic API Key

**Mac / Linux：**
```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

**Windows PowerShell：**
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-..."
```

**永久設定（Windows）：**
```powershell
[System.Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'sk-ant-...', 'User')
```

---

## 基本使用

### 在專案目錄啟動

```bash
cd 你的專案目錄
claude
```

Claude Code 會自動讀取當前目錄的程式碼，進入互動式對話模式。

### 直接執行單一任務

```bash
claude "這個專案的架構是什麼？"
claude "幫我找出所有 TODO 標記"
claude "寫一個單元測試給 utils.py"
```

### 列印版（非互動）

```bash
claude -p "解釋 index.js 第 50-80 行的邏輯"
```

---

## 常用 Slash 指令

在互動模式中輸入以下指令：

| 指令 | 功能 |
|------|------|
| `/help` | 顯示所有可用指令 |
| `/clear` | 清除當前對話記憶 |
| `/compact` | 壓縮上下文（節省 token）|
| `/cost` | 查看本次對話消耗費用 |
| `/model` | 切換 Claude 模型版本 |
| `/doctor` | 診斷環境設定 |
| `/init` | 在當前專案建立 CLAUDE.md |

---

## CLAUDE.md 專案設定

在專案根目錄建立 `CLAUDE.md`，讓 Claude Code 每次都記得你的偏好：

```bash
claude /init
```

或手動建立 `CLAUDE.md`，內容範例：

```markdown
# 專案說明
這是一個 Node.js Express API 專案。

## 語言偏好
- 所有回應請使用繁體中文
- 程式碼註解用英文

## 開發規範
- 使用 async/await，不用 callback
- 函式命名使用 camelCase
```

---

## 進階功能

### MCP 工具整合

Claude Code 支援 **MCP（Model Context Protocol）**，可以接入外部工具：

```bash
# 查看已安裝的 MCP 工具
claude mcp list

# 加入 MCP 伺服器
claude mcp add <名稱> <命令>
```

### Hooks 自動化

在 `.claude/settings.json` 設定 Hooks，讓特定事件自動觸發指令：

```json
{
  "hooks": {
    "PostToolUse": [
      { "matcher": "Write", "hooks": [{ "type": "command", "command": "npx prettier --write $FILE" }] }
    ]
  }
}
```

### 延伸思考模式（Extended Thinking）

```bash
claude --think "設計這個功能的最佳架構"
```

---

## Windows 常見問題排除

### 問題一：`claude` 指令找不到（最常見）

**原因：** 安裝腳本把執行檔放在 `%USERPROFILE%\.local\bin\`，但沒自動加進 PATH。

**確認方式：** 先確認檔案有沒有裝到：

```cmd
dir %USERPROFILE%\.local\bin\claude.exe
```

**解法（手動設定 PATH）：**

```cmd
setx PATH "%PATH%;%USERPROFILE%\.local\bin"
setx CLAUDE_CODE_GIT_BASH_PATH "C:\Program Files\Git\bin\bash.exe"
```

⚠️ 設完**一定要關掉 CMD，重新開一個新的視窗**，再測試 `claude --version`。

### 問題二：安裝時出現 Git Bash 警告

```text
Claude Code on Windows requires git-bash...
```

**解法：** 先裝 Git for Windows（[git-scm.com/downloads/win](https://git-scm.com/downloads/win)），裝完**重開機**，再重新執行安裝指令。

### 問題三：用完整路徑才能執行

如果這樣可以跑：
```cmd
%USERPROFILE%\.local\bin\claude.exe --version
```
但 `claude --version` 不行 → 純粹是 PATH 問題，用「問題一」解法處理。

### 問題四：不確定 Git Bash 位置

```cmd
where /r "C:\Program Files" bash.exe
```

如果 Git 裝在其他路徑，將「問題一」的 `CLAUDE_CODE_GIT_BASH_PATH` 換成實際路徑。

---

## 安裝完的基本指令

```cmd
claude              # 開始互動對話
claude --version    # 查版本
claude doctor       # 環境檢查
claude update       # 更新到最新版
```

---

## 與 HermesAgent 的比較

| 功能 | Claude Code CLI | HermesAgent |
|------|----------------|-------------|
| 主要用途 | 程式開發助理 | 通用 AI 管家 |
| 介面 | 終端機 | Telegram / LINE |
| 長期記憶 | 對話內（context）| ✅ 持久化記憶 |
| AI 大腦 | Claude | 多種可選 |
| 工具整合 | MCP | MCP + Skills |
| 排程任務 | ❌ | ✅ Cron |
| 行動裝置使用 | ❌ | ✅ 手機即可 |

> [!TIP]
> **最強組合**：用 Claude Code CLI 開發程式、調整 HermesAgent 設定，再用 HermesAgent 透過 Telegram/LINE 讓 Claude 幫你日常管理工作！三強 CLI（HermesAgent + Codex CLI + Claude Code）各有所長，可以同時並用。

---

## 延伸學習

- 📚 本書 **CH20：Claude Code 深度整合** — 完整進階教學
- 🌐 官方文件：[docs.anthropic.com](https://docs.anthropic.com)
- 💬 阿亮老師社群：[3A科技研究社](https://www.facebook.com/groups/2754139931432955)

---

> [!NOTE]
> Claude Code 是**開發者工具**，適合寫程式、分析專案。若需要行動裝置使用、LINE/Telegram 機器人、長期記憶管家，請搭配 **HermesAgent** 一起使用！
