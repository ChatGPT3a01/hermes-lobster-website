# Windows 安裝教學

## 系統需求

| 項目 | 需求 |
|------|------|
| 作業系統 | Windows 10/11（64位元）|
| 記憶體 | 至少 8 GB RAM（建議 16 GB）|
| 磁碟空間 | 至少 5 GB 可用空間 |
| 網路 | 需要網際網路連線 |
| 權限 | 需要系統管理員權限 |

> [!TIP]
> **推薦方法：使用一鍵安裝精靈！** 下方的手動安裝說明僅供參考，一般使用者直接用精靈即可。

> [!IMPORTANT]
> **好消息**：HermesAgent 已支援 **Windows 原生（Native）Beta**，從此不必再走 WSL2 或 Docker！PowerShell 路徑與編碼都正常運作，爽度超越 WSL。

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
| 10 | 🧙 **啟動設定精靈** | 進入 `hermes onboard` 互動式問答 |

> [!NOTE]
> **過去要十多個指令、檢查一堆錯誤的安裝流程，現在全部濃縮成一行**。中國網友戲稱「WSL 跟 Docker 又去再就業了」，意思是 Windows 原生終於不再委屈了。

---

### 可選旗標（進階使用者）

預設不加參數即可。需要客製時可加上：

| 旗標 | 用途 | 範例 |
|------|------|------|
| `-Branch <name>` | 指定 Git 分支（預設 main）| `-Branch dev` |
| `-NoVenv` | 不建立 Python 虛擬環境 | 已有自己的 venv 時用 |
| `-SkipSetup` | 跳過 `hermes onboard` 設定精靈 | 想自己手動設定 |
| `-HermesHome <path>` | 自訂 `.hermes` 設定目錄 | `-HermesHome D:\hermes` |
| `-InstallDir <path>` | 自訂安裝目錄 | `-InstallDir D:\Apps\hermes` |

旗標用法（記得 `iex` 改成括號 + 引數）：

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

## 方法二：手動安裝（進階）

如果你想自己動手安裝，請按以下步驟：

### 安裝 HermesAgent

以系統管理員身分開啟 **PowerShell**，執行：

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

安裝完成後，關閉 PowerShell，重新開啟新的 PowerShell 視窗（讓 PATH 生效）。

### 設定環境變數

```powershell
[System.Environment]::SetEnvironmentVariable('PYTHONUTF8', '1', 'User')
```

### 驗證安裝

```powershell
hermes --version
hermes doctor
```

### 初始化設定

```powershell
hermes onboard
```

按照提示選擇 AI 大腦並完成設定。

### 啟動 Gateway

```powershell
hermes gateway run
```

這會在前景啟動 Gateway，監聽 Port **8642**。

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
- 系統 PATH 中的 hermes 路徑

> [!NOTE]
> `hermes uninstall` **不會**刪除 `%USERPROFILE%\.hermes\`（你的設定與 API Key），重灌後資料還在。要徹底清乾淨請手動刪該資料夾。

---

## Windows 已知問題與修復

### 問題：`hermes gateway status` 報錯

**症狀：** 執行 `hermes gateway status` 時出現 `OSError` 錯誤

**原因：** HermesAgent 的 `status.py` 在 Windows 上缺少 `OSError` 例外處理

**修復方法（自動）：** 安裝精靈會自動修復此問題

**修復方法（手動）：**

找到並編輯以下檔案：
```
%LOCALAPPDATA%\hermes\hermes-agent\venv\Lib\site-packages\hermes_agent\gateway\status.py
```

找到這行：
```python
except (ProcessLookupError, PermissionError):
```

改為：
```python
except (ProcessLookupError, PermissionError, OSError):
```

---

### 問題：中文顯示亂碼

**解決：** 設定環境變數 `PYTHONUTF8=1`

```powershell
[System.Environment]::SetEnvironmentVariable('PYTHONUTF8', '1', 'User')
```

---

## ⚠️ Early Beta 注意事項

> [!CAUTION]
> Windows Native 目前是 **Early Beta**，使用前請知悉以下限制：

| 限制 | 影響 | 應對方式 |
|------|------|---------|
| 🔄 **子程序處理可能不穩** | Gateway 偶爾被中斷 | 使用 `hermes gateway run` 前景模式較穩定 |
| 📁 **路徑差異需注意** | 反斜線 `\` 與正斜線 `/` 混用會出錯 | 設定檔路徑統一用反斜線 |
| 🔤 **非 ASCII 主控台輸出有問題** | 中文/Emoji 可能亂碼 | 設定 `PYTHONUTF8=1`、`chcp 65001` |
| 🌐 **Web 終端面板需 WSL2** | 純 Windows 原生環境無法使用 Web Dashboard | 需要 Web 介面請另外裝 WSL2 |

> [!TIP]
> 上述問題在 Telegram/LINE/CLI/TUI 模式下都不影響日常使用，主要受影響的是 Web Dashboard。教學用途完全夠用。

---

## Gateway 管理

```powershell
# 啟動（前景，Windows 原生）
hermes gateway run

# 查看狀態
hermes gateway status

# 停止
hermes gateway stop

# 診斷
hermes doctor
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

## 支援平台一覽

HermesAgent 官方原生支援以下介面：

| 介面 | 用途 | 是否需要 WSL2 |
|------|------|--------------|
| 🖥️ **CLI** | 終端機指令 | ❌ |
| 📺 **TUI** | 終端機 UI 模式 | ❌ |
| ✈️ **Telegram** | 官方原生支援 | ❌ |
| 🐦 **Discord** | 官方原生支援 | ❌ |
| 💼 **Slack** | 官方原生支援 | ❌ |
| 📱 **WhatsApp** | 官方原生支援 | ❌ |
| 🌐 **瀏覽器工具** | MCP 控制瀏覽器 | ❌ |
| 🔌 **MCP 伺服器** | 工具擴充 | ❌ |
| 🧠 **本地模型** | Ollama / Gemma | ❌ |
| 📊 **Web 儀表板** | Web 終端面板 | ⚠️ **需要** |
| 💚 **LINE**（阿亮獨家加值）| Bridge + ngrok 串接 | ❌ |

> [!NOTE]
> 本安裝精靈額外提供 **LINE Bridge**（Node.js + ngrok），讓 HermesAgent 能對接 LINE Bot — 這是台灣使用者的剛需，但官方原生不支援。

---

> [!NOTE]
> 安裝完成後，繼續閱讀「Telegram 設定」或「LINE 設定」，完成通訊平台串接！
