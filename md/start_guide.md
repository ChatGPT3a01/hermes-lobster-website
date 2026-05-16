# 🚀 每次啟動愛馬仕龍蝦

> 安裝完成後，每次要使用愛馬仕龍蝦都要按這個流程啟動。
> **2026/5 改版**：對齊 Hermes 官方 LINE 內建支援、加入 Cloudflare Tunnel 流程、修正 restart 指令、新增「全部砍掉重練」應急方案。

---

## 先確認你用哪種平台 / 路線

| 我用... | 要開幾個視窗 | 適合 |
|---------|------------|------|
| ✈️ 只用 Telegram | **1 個**（最簡單）| 大多數人 |
| 💚 LINE 官方原生 + Cloudflare Tunnel 固定 URL | **2 個**（Gateway + Tunnel）| 推薦新手 |
| 💚 LINE 官方原生 + Cloudflare Tunnel 快速模式 | **2 個**（每次重啟要更新 webhook）| 偶爾用 |
| 💚 LINE 官方原生 + ngrok | **2 個**（免費 ngrok URL 每次變）| 不推薦長期用 |
| 📜 LINE Bridge 方案 + ngrok | **3 個**（Gateway + Bridge + ngrok）| 進階／已有系統 |
| Telegram + LINE 都用 | 依 LINE 走哪條路線 | 進階 |

> [!TIP]
> 想完全免動手？跑一次 `hermes gateway install`（Gateway 開機自啟） + `cloudflared service install`（Tunnel 開機自啟）。**開電腦 30 秒內 Bot 自動可用**。

---

## ✈️ Telegram 使用者（最簡單，1 個視窗）

開啟 **PowerShell**（按 <kbd>Win</kbd>+<kbd>R</kbd> → `powershell`），輸入：

```powershell
hermes gateway
```

看到類似訊息就代表啟動成功：

```text
[Hermes] gateway started
Telegram: polling started (bot: @your_bot)
```

直接去 Telegram 找你的機器人傳訊息測試！

> [!NOTE]
> `hermes gateway` 是**前景模式**——這個視窗開著看 log。要背景跑改用：
> ```powershell
> hermes gateway start    # 背景啟動（視窗可關）
> ```
> Mac/Linux 兩個都通用。

### 查狀態 / 重啟 / 停止

```powershell
hermes gateway status     # 查看是否運行中
hermes gateway restart    # ⭐ 重啟（不要 stop 再 start，直接 restart）
hermes gateway stop       # 停止
```

> [!WARNING]
> **不要 Stop 再 Start！直接用 Restart！**
> Hermes 重啟 Gateway 時有個 bug——`stop` 之後它不會自動 `start`，視窗會卡住。直接 `hermes gateway restart` 一行解決。
> 在 CLI 對話模式裡叫 Bot 重啟也要說「Restart」不要說「Stop 再 Start」。

---

## 💚 LINE 官方原生使用者（推薦，2 個視窗）

### 視窗 1：啟動 HermesAgent Gateway（內建 LINE adapter）

```powershell
hermes gateway
```

看到 `LINE: webhook listening on 0.0.0.0:8646/line/webhook` 就成功。

### 視窗 2：啟動 Cloudflare Tunnel

#### A. 已經設好固定 URL（最爽）

```powershell
cloudflared tunnel run hermes-lobster
```

URL 不會變，**LINE webhook 從此不用再動**。

#### B. 還沒設固定 URL，用快速模式

```powershell
cloudflared tunnel --url http://localhost:8646
```

複製輸出的 `https://<random>.trycloudflare.com`，**接著要更新 LINE Webhook URL**：
- LINE Console → Messaging API → Webhook URL → 改為 `https://<random>.trycloudflare.com/line/webhook`

#### C. 想用 ngrok（不推薦）

```powershell
ngrok http 8646
```

免費版每次 URL 都變，每次都要更新 LINE Console。長期建議改 Cloudflare Tunnel。

### 健康檢查

```powershell
curl -i https://<你的 URL>/line/webhook/health
```

成功回 `{"status":"ok","platform":"line"}` 就代表通了。

---

## 📜 LINE Bridge 方案使用者（3 個視窗）

### 視窗 1：啟動 HermesAgent Gateway

```powershell
hermes gateway
```

### 視窗 2：啟動 LINE Bridge

```powershell
cd $env:USERPROFILE\HermesAgent一鍵自動安裝程式\bridge
node line-bridge.js
```

> ⚠️ 上面路徑要改成你**實際解壓縮安裝精靈的位置**。

看到啟動 banner 就成功，**不要關這個視窗**。

### 視窗 3：啟動隧道（ngrok 或 Cloudflare Tunnel）

```powershell
# 走 ngrok（port 3000 因為 Bridge 在 3000）
ngrok http 3000

# 或走 Cloudflare Tunnel（推薦）
cloudflared tunnel --url http://localhost:3000
```

> [!IMPORTANT]
> **Webhook URL 用 `/webhook`（單段，不是 /line/webhook）**——Bridge 路徑不同於官方原生。

---

## ⚡ 快速啟動（用安裝精靈）

不想記指令？雙擊安裝精靈進選單一鍵啟動：

```powershell
# 找到你的安裝精靈資料夾，雙擊：
install-hermes.exe
```

進入選單後選 **`[6] 啟動所有服務`**。

> [!NOTE]
> V6.53+ 起 `go.bat` 被 `install-hermes.exe` 取代。

---

## ▶️ Hermes Desktop GUI 使用者

如果你裝的是「Hermes Desktop」桌面版（V0.4.3+），啟動最簡單：

1. 雙擊桌面上的 **Hermes Agent** 圖示
2. 自動連到後台 Gateway，**不用開 PowerShell**
3. 想接 LINE 還是要照本頁設定 Cloudflare Tunnel

詳細見「🖥️ Hermes Desktop GUI」。

---

## 常用管理指令

```powershell
# 查看 Gateway 是否在執行
hermes gateway status

# 重啟 Gateway（⭐ 不要 Stop 再 Start）
hermes gateway restart

# 停止 Gateway
hermes gateway stop

# 診斷環境
hermes doctor

# 設成開機自動啟動（Windows 排程工作）
hermes gateway install

# 移除自動啟動
hermes gateway uninstall

# 設定通訊平台（互動式精靈）
hermes gateway setup
```

---

## 每天使用的標準流程

### 沒設「開機自動啟動」的人

```text
開電腦
  ↓
開 PowerShell → hermes gateway start
  ↓（LINE 用戶還要）
開第二個視窗 → cloudflared tunnel run hermes-lobster
              （或者 cloudflared tunnel --url http://localhost:8646）
  ↓（如果是快速模式 → 要更新 LINE Webhook URL）
  ↓（如果是固定 URL → 不用動）
開始使用！
```

### 有設「開機自動啟動」的人

```text
開電腦
  ↓
等 30 秒讓 Windows 排程把 Gateway + Cloudflare Tunnel 拉起來
  ↓
hermes gateway status 確認 Running
  ↓
開始使用！
```

---

## 想讓全部都自動化？

3 件事都要做：

### 1. Hermes Gateway 自動啟動

```powershell
hermes gateway install
```

### 2. Cloudflare Tunnel 自動啟動（已設好固定 URL）

```powershell
# 以系統管理員執行 PowerShell
cloudflared service install
```

完成後，下次開機 Cloudflare Tunnel 自動跑、不佔視窗。

詳細設定請看「🌩️ Cloudflare Tunnel」那一頁。

### 3.（Bridge 使用者才需要）LINE Bridge 自動啟動

寫一個 `start-bridge.bat`：

```batch
@echo off
cd /d "%USERPROFILE%\HermesAgent一鍵自動安裝程式\bridge"
start "" cmd /c node line-bridge.js
```

把它放到 <kbd>Win</kbd>+<kbd>R</kbd> → `shell:startup` 開啟的資料夾。

---

## 🆘 應急：全部砍掉重練

> [!WARNING]
> **這個流程會刪掉 session 歷史**！只有在「卡死完全救不回來」時才用。
> 操作前**先備份 `~/.hermes/state.db` 和 `~/.hermes/.env`** 到桌面。

### Step 1：停止所有服務

```powershell
hermes gateway stop
# 然後手動關掉所有 PowerShell 視窗（Bridge / ngrok / cloudflared）
```

### Step 2：備份重要資料

```powershell
# Windows
copy "$env:USERPROFILE\.hermes\.env" "$env:USERPROFILE\Desktop\hermes-env-backup.txt"
copy "$env:USERPROFILE\.hermes\state.db" "$env:USERPROFILE\Desktop\hermes-state-backup.db"
copy "$env:USERPROFILE\.hermes\config.yaml" "$env:USERPROFILE\Desktop\hermes-config-backup.yaml"
```

```bash
# Mac / Linux
cp ~/.hermes/.env ~/Desktop/hermes-env-backup.txt
cp ~/.hermes/state.db ~/Desktop/hermes-state-backup.db
cp ~/.hermes/config.yaml ~/Desktop/hermes-config-backup.yaml
```

### Step 3：清掉 session 資料庫

```powershell
# Windows
del "$env:USERPROFILE\.hermes\state.db"
```

```bash
# Mac / Linux
rm ~/.hermes/state.db
```

> [!NOTE]
> 只刪 `state.db`（session 歷史），**不刪整個 `.hermes/` 資料夾**——這樣 Skills、profiles、設定都保留，只是對話歷史清空。

### Step 4：診斷一次環境

```powershell
hermes doctor
```

確認所有依賴項目都顯示 ✅。如果有 ❌：

- Python 依賴壞了 → `uv pip install --force-reinstall hermes-agent`
- Bot Token 認不過 → 重新從 `.env-backup.txt` 貼回 `.env`
- WSL 出問題 → 重啟電腦

### Step 5：重新啟動

```powershell
hermes gateway restart
```

### Step 6：重新綁 webhook（LINE 使用者）

如果你重灌或者 webhook URL 變了，去 LINE Developers Console 重新貼一次 URL。

### Step 7：跑健康檢查

```powershell
# LINE 官方原生
curl -i https://<隧道網址>/line/webhook/health

# Telegram
hermes gateway status
```

---

## 🆘 應急：徹底重灌 Hermes（最後手段）

> [!WARNING]
> **這會清掉所有 Skills、profiles、記憶**。請非常確定才做。

### Windows

```powershell
# 1. 停 Gateway
hermes gateway stop

# 2. 移除自動啟動
hermes gateway uninstall

# 3. 備份整個 .hermes（資料 + 設定 + Skill 全保留）
Compress-Archive -Path "$env:USERPROFILE\.hermes" -DestinationPath "$env:USERPROFILE\Desktop\hermes-full-backup-$(Get-Date -Format yyyyMMdd).zip"

# 4. 刪掉整個 .hermes
Remove-Item -Recurse -Force "$env:USERPROFILE\.hermes"

# 5. 重灌 Hermes（一行）
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex

# 6. 重新設定 Provider、Telegram、LINE
hermes gateway setup
```

### Mac / Linux

```bash
# 1. 停 Gateway
hermes gateway stop
hermes gateway uninstall

# 2. 備份
tar czf ~/Desktop/hermes-full-backup-$(date +%Y%m%d).tgz ~/.hermes

# 3. 刪
rm -rf ~/.hermes

# 4. 重灌
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 5. 重新設定
hermes gateway setup
```

備份 ZIP 留著，未來想救回特定 Skill 或記憶可以解壓縮挑檔案。

---

## 進階：把舊備份的 Skill / 記憶塞回新環境

```powershell
# Skill 搬回去（保留新環境的 setup）
Expand-Archive "$env:USERPROFILE\Desktop\hermes-full-backup-2026XXXX.zip" "$env:USERPROFILE\Desktop\hermes-restore"
Copy-Item -Recurse "$env:USERPROFILE\Desktop\hermes-restore\.hermes\skills\*" "$env:USERPROFILE\.hermes\skills\"

# 重啟讓 Hermes 掃到
hermes gateway restart
hermes doctor
```

---

> [!TIP]
> 想看更詳細的指令說明？請看「⌨️ 指令速查」章節。
> 第一次安裝？請看「🖥️ Hermes Desktop GUI」（新手首選）或「⚡ CLI 一鍵安裝教學」（進階）。
