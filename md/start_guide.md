# 🚀 每次啟動愛馬仕龍蝦

> 安裝完成後，每次要使用愛馬仕龍蝦都要按這個流程啟動。
> **V6.53（2026-05）改版**：對齊 Windows Native 後台模式、移除 go.bat 路徑。

---

## 先確認你用哪種平台

| 我用... | 要開幾個視窗 | 啟動方式 |
|---------|------------|---------|
| 只用 Telegram | **1 個**（最簡單）| 一行 `hermes gateway start` |
| 用 LINE Bot | **3 個**（Gateway + Bridge + ngrok）| 見下方完整流程 |
| Telegram + LINE 都用 | **3 個** | 同 LINE 流程 |

> [!TIP]
> 想完全免動手？跑一次 `hermes gateway install`，設成開機自動啟動，之後開電腦就自動跑（**僅限 Gateway，LINE Bridge + ngrok 仍要手動**）。

---

## 🔵 Telegram 使用者（最簡單，1 個視窗）

開啟 **PowerShell**（按 <kbd>Win</kbd>+<kbd>R</kbd> 輸入 `powershell`），輸入：

```powershell
hermes gateway start
```

看到類似以下訊息就代表啟動成功：

```
[HermesAgent] Gateway started on port 8642
[HermesAgent] Telegram polling started
```

> [!NOTE]
> `hermes gateway start` 是**背景模式**——啟動後它在背景跑，PowerShell 視窗你可以關掉，Bot 還會繼續工作。

直接去 Telegram 找你的機器人傳訊息測試！

### 查狀態 / 停止

```powershell
hermes gateway status     # 查看是否運行中
hermes gateway stop       # 停止
hermes gateway restart    # 重啟
```

---

## 💚 LINE 使用者（3 個視窗，依序開）

### 視窗 1：啟動 HermesAgent Gateway

```powershell
hermes gateway start
```

看到 `Gateway started on port 8642` 就成功。

> [!TIP]
> 想看即時 log？改用前景模式：`hermes gateway run`（這個版本要保留視窗別關）。

---

### 視窗 2：啟動 LINE Bridge

```powershell
cd $env:USERPROFILE\HermesAgent一鍵自動安裝程式\bridge
node line-bridge.js
```

> ⚠️ 上面路徑要改成你**實際解壓縮安裝精靈的位置**。
> 如果你忘記放哪了，PowerShell 跑 `where.exe install-hermes.exe` 找。

看到這樣就成功：

```
  ╔══════════════════════════════════════════════════════╗
  ║  🦞🪽  愛馬仕助理 LINE Bridge 啟動成功！            ║
  ║  監聽 Port   : 3000                                  ║
  ╚══════════════════════════════════════════════════════╝
```

**不要關這個視窗**，開新視窗繼續。

---

### 視窗 3：啟動 ngrok 隧道

```powershell
ngrok http 3000
```

看到 `https://xxxx.ngrok-free.app` 就成功了。

> [!WARNING]
> **免費版 ngrok 每次重啟 URL 會不一樣！**
> 需要回到 [LINE Developers Console](https://developers.line.biz/) → Messaging API → Webhook URL，更新成新的 ngrok URL + `/webhook`。

---

## ⚡ 快速啟動（用安裝精靈）

不想記指令？雙擊安裝精靈進選單一鍵啟動：

```powershell
# 找到你的安裝精靈資料夾，雙擊：
install-hermes.exe
```

進入選單後選 **`[6] 啟動所有服務`**，精靈自動幫你開全部。

> [!NOTE]
> V6.53 起 `go.bat` 已被 `install-hermes.exe` 取代。雙擊即執行、不會跳 cmd 黑視窗、中文不亂碼。
> 舊的 `go.bat` 仍保留相容性，不影響功能。

---

## 常用管理指令

```powershell
# 查看 Gateway 是否在執行
hermes gateway status

# 停止 Gateway
hermes gateway stop

# 重啟 Gateway（不要 Stop 再 Start，直接 restart）
hermes gateway restart

# 診斷環境
hermes doctor

# 設成開機自動啟動（Windows 排程工作）
hermes gateway install

# 移除自動啟動
hermes gateway uninstall
```

> [!WARNING]
> **重啟注意**：若想在 AI 對話中請它重啟，說「**Restart**」，不要說「Stop 再 Start」——Gateway 關掉後 AI 就無法自動重啟了！

---

## 每天使用的標準流程

### 沒設「開機自動啟動」的人

```
開電腦
  ↓
開 PowerShell → hermes gateway start
  ↓（LINE 用戶還要）
開第二個視窗 → cd bridge → node line-bridge.js
  ↓
開第三個視窗 → ngrok http 3000
  ↓
更新 LINE Webhook URL（如果 ngrok URL 變了）
  ↓
開始使用！
```

### 有設「開機自動啟動」的人

```
開電腦
  ↓
等 1 分鐘讓 Windows 排程工作把 Gateway 拉起來
  ↓
hermes gateway status 確認 Running
  ↓（LINE 用戶還要）
開 PowerShell → cd bridge → node line-bridge.js
  ↓
開第二個視窗 → ngrok http 3000
  ↓
更新 LINE Webhook URL（如果 ngrok URL 變了）
  ↓
開始使用！
```

---

## 想讓全部都自動化？

3 件事都要做：

1. **Gateway 自動啟動**：`hermes gateway install`（V6.53 內建）
2. **LINE Bridge 自動啟動**：寫一個 `start-bridge.bat`：
   ```batch
   @echo off
   cd /d "%USERPROFILE%\HermesAgent一鍵自動安裝程式\bridge"
   start "" cmd /c node line-bridge.js
   ```
   把它放到 <kbd>Win</kbd>+<kbd>R</kbd> → `shell:startup` 開啟的資料夾
3. **ngrok 自動啟動 + 固定網域**：
   - 改付費 ngrok（$8/月）拿到固定 subdomain
   - 或改 Cloudflare Tunnel（免費但設定較複雜）
   - 把 ngrok 啟動指令也寫成 .bat 丟到 `shell:startup`

設完之後，**開電腦 30 秒內 Bot 就自動可用**，完全免動手。

---

> [!TIP]
> 想看更詳細的指令說明？請看「💻 指令速查」章節。
> 第一次安裝？請看「📘 手動安裝教學 → Step 1：手動安裝 HermesAgent 本體」。
