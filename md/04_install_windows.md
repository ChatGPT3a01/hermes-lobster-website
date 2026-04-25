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

精靈自動執行官方安裝腳本（約 3-10 分鐘）

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

> [!NOTE]
> 安裝完成後，繼續閱讀「Telegram 設定」或「LINE 設定」，完成通訊平台串接！
