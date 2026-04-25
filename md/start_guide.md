# 🚀 每次啟動愛馬仕龍蝦

> 安裝完成後，每次要使用愛馬仕龍蝦都要按這個流程啟動。

---

## 先確認你用哪種平台

| 我用... | 要開幾個視窗 |
|---------|------------|
| 只用 Telegram | **1 個**（最簡單）|
| 用 LINE Bot | **3 個**（Gateway + Bridge + ngrok）|
| Telegram + LINE 都用 | **3 個** |

---

## 🔵 Telegram 使用者（1 個視窗）

開啟 **PowerShell**，輸入：

```powershell
hermes gateway run
```

看到類似以下訊息就代表啟動成功：

```
[HermesAgent] Gateway started on port 8642
[HermesAgent] Telegram polling started
```

直接去 Telegram 找你的機器人傳訊息測試！

---

## 💚 LINE 使用者（3 個視窗，依序開）

### 視窗 1：啟動 HermesAgent Gateway

```powershell
hermes gateway run
```

等看到 `Gateway started` 後，**不要關這個視窗**，開新視窗繼續。

---

### 視窗 2：啟動 LINE Bridge

```powershell
cd C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge
node line-bridge.js
```

看到這樣就成功：
```
  ╔══════════════════════════════════════════════════════╗
  ║  🦞🪽  愛馬仕助理 LINE Bridge 啟動成功！            ║
  ║  監聽 Port   : 3000                                  ║
  ╚══════════════════════════════════════════════════════╝
```

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

不想記指令？用精靈選單一鍵啟動：

```powershell
cd C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式
.\go.bat
```

進入選單後選 **`[6] 啟動所有服務`**，精靈自動幫你開全部。

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
```

> [!WARNING]
> **重啟注意**：若想在 AI 對話中請它重啟，說「**Restart**」，不要說「Stop 再 Start」——Gateway 關掉後 AI 就無法自動重啟了！

---

## 每天使用的標準流程

```
開電腦
  ↓
開 PowerShell → hermes gateway run
  ↓（LINE 用戶還要）
開第二個視窗 → cd bridge → node line-bridge.js
  ↓
開第三個視窗 → ngrok http 3000
  ↓
更新 LINE Webhook URL（如果 ngrok URL 變了）
  ↓
開始使用！
```

---

> [!TIP]
> **想讓 HermesAgent 開機自動啟動？** 可以把啟動指令寫成 `.bat` 批次檔，放到 Windows 開機啟動資料夾，這樣開電腦就自動全部啟動！
