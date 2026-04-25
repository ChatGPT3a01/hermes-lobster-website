# 🛠️ Step 1：手動安裝 HermesAgent 本體

> 預估時間：15 分鐘
> 目標：讓電腦上的 PowerShell 可以執行 `hermes --version` 並回傳版本號

---

---

## ⚠️ 0-0. 官方路線 vs 本教學路線

NousResearch 官方 README 說法：

> **Windows:** Native Windows is not supported. Please install WSL2 and run the command above.

但實際上 `scripts/install.ps1` 存在（35 KB）、社群廣泛使用，阿亮老師的一鍵精靈也用它。**本 Step 1 走 Windows 原生路線**（install.ps1），理由：
- 少一層 WSL2 虛擬化，效能較好
- 檔案直接在 `%LOCALAPPDATA%\hermes\`、`%USERPROFILE%\.hermes\`，好管理
- 實測：我們整套（含 LINE Bridge、Codex 訂閱、fal.ai 自拍）都跑得起來

**如果你想走官方 WSL2 路線**：
1. 先 `wsl --install`（要重開機）
2. 之後在 Ubuntu 終端機跑 `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash`
3. 之後 Step 2-7 的指令邏輯相同，但所有檔案路徑改為 Linux 格式（`~/.hermes/` 等）

---

## 1-0. 前置工具檢查

按 <kbd>Win</kbd>+<kbd>R</kbd>，輸入 `powershell` 開啟 PowerShell（**不要**用系統管理員身分）。

貼以下指令檢查工具是否已裝：

```powershell
node --version
npm --version
git --version
python --version
```

預期輸出：
```
v20.0.0 以上
10.0.0 以上
git version 2.x
Python 3.11.x     ← 這個關鍵！
```

### 1-0-1. 如果缺 Node.js

到 <https://nodejs.org> 下載 **LTS 版**（目前 20.x 或更新），安裝完畢後**關閉所有 PowerShell** 重開。

### 1-0-2. 如果缺 Git

```powershell
winget install Git.Git --silent --accept-package-agreements
```

### 1-0-3. ⚠️ 如果 Python 版本 < 3.11

**這是最常踩的坑！** HermesAgent v0.10 要求 Python **≥ 3.11**。

即使你有 Python 3.10，一樣會失敗。安裝 3.11：

```powershell
winget install Python.Python.3.11 --silent --accept-package-agreements
```

裝完後**關閉 PowerShell 重開**，再驗證：

```powershell
py -3.11 --version
```

應該看到 `Python 3.11.x`。

---

## 1-1. 下載官方安裝腳本

以系統管理員身分開 PowerShell（按 <kbd>Win</kbd>+<kbd>X</kbd> → Terminal (系統管理員)）。

```powershell
$ProgressPreference='SilentlyContinue'
$tmp = "$env:TEMP\hermes-install.ps1"
Invoke-WebRequest `
  -Uri 'https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1' `
  -OutFile $tmp -UseBasicParsing
```

---

## 1-2. ⚠️ 關鍵步驟：補上 UTF-8 BOM

> [!WARNING]
> 這步**一定要做**！否則 PowerShell 5.1 會把腳本裡的中文解成 Big5 亂碼，出現一連串 `Unexpected token` 錯誤。

```powershell
$b = [System.IO.File]::ReadAllBytes($tmp)
[System.IO.File]::WriteAllBytes($tmp, [byte[]](0xEF,0xBB,0xBF) + $b)
```

這指令把檔案最前面加上 3 個位元組 `EF BB BF`（UTF-8 BOM），PowerShell 就知道檔案是 UTF-8 編碼。

---

## 1-3. 執行安裝

```powershell
$env:PYTHONUTF8='1'
& powershell -NoProfile -ExecutionPolicy Bypass -File $tmp -SkipSetup
```

會看到類似這樣的輸出：

```
┌─────────────────────────────────────────────────────────┐
│             ⚕ Hermes Agent Installer                    │
└─────────────────────────────────────────────────────────┘

→ Checking for uv package manager...
✓ uv installed
→ Checking Python 3.11...
✓ Python found: Python 3.11.x
→ Checking Git...
✓ Git found
→ Cloning hermes-agent repository...
→ Creating virtual environment with Python 3.11...
→ Installing dependencies...    ← 這步最久，約 3-5 分鐘
✓ All dependencies installed
✓ hermes command ready
✓ Created ~/.hermes/.env from template
✓ Created ~/.hermes/config.yaml from template
✓ Installation Complete!
```

> [!TIP]
> `-SkipSetup` 旗標讓它**不跑**最後的互動設定精靈（因為精靈會卡住等使用者輸入）。後續我們會自己設定。

---

## 1-4. ⚠️ 如果你的 Python 是 3.10，這裡會偷跑失敗

**症狀**：log 看起來成功但其實套件沒裝進 venv。

**怎麼確認是否踩到**：
```powershell
Test-Path "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe"
```

如果回 `False` → **踩到了**！修復方式：

```powershell
# 刪掉舊 venv
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\hermes\hermes-agent\venv"

# 用 Python 3.11 重建 venv
Set-Location "$env:LOCALAPPDATA\hermes\hermes-agent"
uv venv --python 3.11 venv

# 重新安裝 hermes-agent 套件到新 venv
uv pip install -e . --python venv\Scripts\python.exe
```

完成後 `hermes.exe` 就會出現。

---

## 1-5. 驗證安裝

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" --version
```

預期：
```
Hermes Agent v0.10.0 (2026.x.x)
Project: C:\Users\<你>\AppData\Local\hermes\hermes-agent
Python: 3.11.9
OpenAI SDK: 2.x.x
```

---

## 1-6. 跑環境診斷

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" doctor
```

應該看到大量 `✓` 綠色打勾。常見的「⚠」警告可以先忽略（大多是某些 optional skill 需要 API key）。

如果看到：
- `✗ hermes command ready` → PATH 沒刷新，重開 PowerShell 再試
- `✗ Python 3.11` → Python 版本不對，回到 1-0-3

---

## 1-7. 建立 .env（如果沒有）

```powershell
# 檢查 .env 在不在
Test-Path "$env:USERPROFILE\.hermes\.env"

# 如果不在，從 template 複製
Copy-Item "$env:LOCALAPPDATA\hermes\hermes-agent\.env.example" `
          "$env:USERPROFILE\.hermes\.env"
```

之後的設定（Step 5 起）會編輯這個檔。

---

## 🎉 Step 1 完成！

你現在有一個可以運作的 HermesAgent 本體。

**下一步：Step 2「申請 LINE Bot」** — 取得 Channel Secret、Access Token 等 LINE 憑證。
