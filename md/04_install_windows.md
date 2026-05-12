# Windows 安裝教學

## 系統需求

| 項目 | 需求 |
|------|------|
| 作業系統 | Windows 10/11（64位元）|
| 記憶體 | 至少 8 GB RAM（建議 16 GB 才順）|
| 磁碟空間 | 至少 5 GB 可用空間 |
| 網路 | 需要網際網路連線 |
| 權限 | **不需要管理員權限**（官方安裝器新設計）|

> [!TIP]
> **推薦方法：用一鍵安裝精靈！** 下方的「方法二：手動安裝」僅供想了解原理的學員參考，一般使用者直接用精靈即可。

> [!IMPORTANT]
> **2026 年好消息**：HermesAgent 已正式支援 **Windows 原生（Native）Beta**，不必再走 WSL2 或 Docker。PowerShell 路徑與編碼都正常運作。詳見官方文件：<https://hermes-agent.nousresearch.com/docs/user-guide/windows-native>

---

## 一行指令背後的 10 步自動化

當你執行下面這一行 PowerShell 指令時：

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

官方腳本會自動跑完以下 **10 步流程**，使用者完全不必手動處理：

| # | 動作 | 說明 |
|---|------|------|
| 1 | 📦 安裝 **uv** 套件管理器 | 取代傳統 pip，速度快 10～100 倍 |
| 2 | 🐍 安裝 **Python 3.11** | 透過 uv 部署獨立 Python 環境 |
| 3 | 🟢 安裝 **Node.js 22** | 供 MCP 伺服器與 SDK 使用 |
| 4 | 🌳 安裝 **Git（可攜版）** | 用於複製 hermes-agent 倉庫 |
| 5 | 📥 **複製程式倉庫** | 從 GitHub 下載 hermes-agent 原始碼 |
| 6 | 🧱 **安裝相依套件** | 自動跑 `uv sync` 與 `npm install` |
| 7 | 💬 **訊息 SDK 自動配置** | Telegram、Discord、Slack、WhatsApp |
| 8 | 🐚 **Bash PATH 變數** | 設定 Bash 可存取 hermes 指令 |
| 9 | 🪟 **系統 PATH 更新** | 設定 Windows 全域 hermes 指令 |
| 10 | 🧙 **啟動設定精靈** | 進入 `hermes setup` 互動式問答 |

> [!NOTE]
> **過去要十多個指令、檢查一堆錯誤的安裝流程，現在全部濃縮成一行**。

---

### 可選旗標（進階使用者）

預設不加參數即可。需要客製時可加上：

| 旗標 | 用途 | 範例 |
|------|------|------|
| `-Branch <name>` | 指定 Git 分支（預設 main）| `-Branch dev` |
| `-NoVenv` | 不建立 Python 虛擬環境 | 已有自己的 venv 時用 |
| `-SkipSetup` | 跳過 `hermes setup` 設定精靈 | 想自己手動設定 |
| `-HermesHome <path>` | 自訂 `.hermes` 設定目錄 | `-HermesHome D:\hermes` |
| `-InstallDir <path>` | 自訂安裝目錄 | `-InstallDir D:\Apps\hermes` |

旗標用法（注意：要從 `irm | iex` 改成 scriptblock 形式）：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1))) -SkipSetup -InstallDir "D:\hermes"
```

---

## 方法一：一鍵安裝精靈（推薦）

### 步驟 1：下載安裝精靈

點選頂部「下載安裝精靈」按鈕，下載 `HermesAgent一鍵自動安裝程式.zip`

或直接從 GitHub 下載：
```
https://github.com/ChatGPT3a01/HermesAgent-Installer
```

### 步驟 2：解壓縮

將壓縮檔解壓縮到任意位置，例如：
```
C:\Users\你的名字\HermesAgent安裝程式\
```

### 步驟 3：執行安裝精靈

對 **`go.bat`** 按**右鍵** → **以系統管理員身分執行**

### 步驟 4：選擇安裝模式

精靈會問你：

```
請選擇安裝模式：
  [W] Windows 原生安裝（推薦，效能較好）
  [L] WSL2 安裝（Linux 環境）
```

**建議選 [W] Windows 原生安裝**

### 步驟 5：安裝 HermesAgent

精靈會自動執行官方安裝腳本（即上面那 10 步，約 3-10 分鐘）

安裝過程中會詢問你要使用哪個 AI 大腦：

| 選項 | 說明 | 適合對象 |
|------|------|---------|
| A - Claude Code OAuth | 使用 Claude Pro/Max 訂閱 | 有訂閱 Claude Pro |
| B - OpenAI OAuth | 使用 ChatGPT Plus/Pro 訂閱 | 有訂閱 ChatGPT Plus |
| C - Google AI Studio | Gemma 4 (31B)，**完全免費** | 沒有訂閱首選！[申請教學](https://www.koc.com.tw/archives/638001) |
| D - Nous Portal | 免費試用 MiMo 模型 | 想先試用 |
| E - 自訂 API Key | 輸入 OpenRouter 等 API Key | 有 API Key |

### 步驟 6：設定通訊平台

選擇 **Telegram** 或 **LINE**（或兩者都設定）

> [!TIP]
> **LINE Bridge 是阿亮老師獨家加值！** HermesAgent 官方原生只支援 Telegram、Discord、Slack、WhatsApp，**沒有 LINE**。本安裝精靈額外提供 Node.js Bridge + ngrok 串接，讓你能用 LINE Bot 對話。

---

## 方法二：手動安裝（進階／教學用）

> [!TIP]
> **完整逐步手動教學**請看 **📘 手動安裝教學** 章節的 **Step 1：手動安裝 HermesAgent 本體**。下面只是濃縮版。

### Step 1：開 PowerShell

按 <kbd>Win</kbd>+<kbd>R</kbd> 輸入 `powershell`（**不必管理員權限**）。

### Step 2：跑官方一行指令

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

跑 3-10 分鐘。最後跳出 `hermes setup` 互動精靈時，可以按 `Ctrl+C` 結束（之後手動設 `.env` 更彈性）。

### Step 3：關掉 PowerShell，重新開一個

> [!WARNING]
> **這一步一定要做**！PATH 環境變數要重開視窗才會生效。

### Step 4：驗證

```powershell
hermes --version
hermes doctor
```

看到版本號與一堆綠色 ✓ 就成功。

### Step 5：初始化設定（可選）

```powershell
hermes setup
```

按照提示選擇 AI 大腦並完成設定。**或者**直接編輯 `%USERPROFILE%\.hermes\.env` 自己填。

### Step 6：啟動 Gateway

```powershell
hermes gateway start            # 背景啟動
hermes gateway status           # 看狀態
hermes gateway install          # 設成開機自動啟動（用 Windows 排程工作）
```

Gateway 預設監聽 Port **8642**。

---

## 資料目錄差異（重要觀念）

> [!WARNING]
> HermesAgent 把資料放在**兩個不同位置**，搞混會導致設定遺失或備份不完整！

| 資料夾 | 路徑 | 性質 | 內容 |
|--------|------|------|------|
| 🗑️ **基礎設施（可丟棄）** | `%LOCALAPPDATA%\hermes\` | 重灌會重建 | hermes-agent repo、Python venv、Node modules |
| 💾 **使用者資料（持久保留）** | `%USERPROFILE%\.hermes\` | 升級/重灌**必備份** | `.env` 設定、API 憑證、技能、記憶 |

PowerShell 直接打開兩個資料夾：

```powershell
# 基礎設施（重灌會清掉）
explorer "$env:LOCALAPPDATA\hermes"

# 使用者資料（千萬要備份）
explorer "$env:USERPROFILE\.hermes"
```

> [!CAUTION]
> 想重新安裝？只要刪 `%LOCALAPPDATA%\hermes\` 即可，**`%USERPROFILE%\.hermes\` 千萬別刪**，否則 API Key、記憶、技能全沒。

---

## 解除安裝

官方提供一鍵解除安裝指令：

```powershell
hermes uninstall
```

會清除：
- `%LOCALAPPDATA%\hermes\`（基礎設施）
- 排程工作（schtasks）
- 啟動資料夾快捷方式
- 使用者 PATH 中的 hermes 路徑

> [!NOTE]
> `hermes uninstall` **不會**刪除 `%USERPROFILE%\.hermes\`（你的設定與 API Key），重灌後資料還在。要徹底清乾淨請手動刪該資料夾。

---

## 支援平台與 Windows 限制速覽

HermesAgent 在 Windows Native 上的支援狀況：

| 介面 | Windows 原生 | 備註 |
|------|:---:|------|
| 🖥️ **CLI**（`hermes chat`） | ✓ | 完整支援 |
| 📺 **TUI** 終端介面 | ✓ | 完整支援 |
| ✈️ **Telegram** | ✓ | 官方原生 |
| 🐦 **Discord** | ✓ | 官方原生 |
| 💼 **Slack** | ✓ | 官方原生 |
| 📱 **WhatsApp** | ✓ | 官方原生 |
| 🌐 **瀏覽器自動化** | ✓ | 完整支援 |
| 🔌 **MCP 伺服器** | ✓ | **Windows 原生 MCP 工具直接無痛調用** |
| 🧠 **Ollama / 本地模型** | ✓ | 完整支援 |
| 📊 **Web 儀表板** | ✓（部分） | 主功能可用，**唯獨 `/chat` 嵌入式終端不能用** |
| 🔇 **語音聽說** | ✗ | 原生套件是 Linux 用，需自己改 Windows 版（見疑難排解附錄 C）|
| 💚 **LINE**（阿亮獨家加值）| ✓ | Node.js Bridge + ngrok 串接 |

> [!TIP]
> 教學情境（LINE/Telegram Bot 對話 + 副人格 + 自拍生圖）**完全用得到**。要等到你想做語音 Bot 或想用儀表板的內嵌終端，才會碰到限制。

---

## 常見錯誤速查

| 現象 | 速解 |
|------|------|
| `hermes: command not found` | 沒重開 PowerShell。關掉重開即可。 |
| `irm` 跑出 14+ 個紅字 `Unexpected token` | 你用 PowerShell 5.1。`winget install Microsoft.PowerShell` 升級到 PS7。 |
| `hermes gateway status` 報 OSError | v0.10 之前的舊版本 bug，跑 `hermes uninstall` 後重裝即可。 |
| 中文／Emoji 亂碼 | 用 Windows Terminal（Microsoft Store 免費裝）取代 cmd.exe |
| Gateway 開機沒自動跑 | 用 `$env:HERMES_GATEWAY_FORCE_STARTUP='1'` 後重新 `hermes gateway install` |

> 完整 20+ 條疑難排解請看 **📘 手動安裝教學 → 🐛 常見錯誤與排解**。

---

## Gateway 管理速查

```powershell
hermes gateway start             # 啟動（背景）
hermes gateway stop              # 停止
hermes gateway restart           # 重啟
hermes gateway status            # 看狀態
hermes gateway install           # 設定登入時自動啟動
hermes gateway uninstall         # 移除自動啟動

hermes doctor                    # 完整環境健診
```

---

## 設定檔位置

> [!WARNING]
> **常見錯誤**：`.env` 不在 `%LOCALAPPDATA%\hermes\`，請用下方正確路徑！

HermesAgent **runtime 讀取**的設定檔位於使用者目錄：

```
C:\Users\你的名字\.hermes\.env
```

PowerShell 快速開啟：
```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

（`%LOCALAPPDATA%\hermes\` 只是安裝 repo + venv 的位置，不是 runtime 設定）

---

> [!NOTE]
> 安裝完成後，繼續閱讀「Telegram 設定」或「LINE 設定」，完成通訊平台串接！
