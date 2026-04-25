# 🌐 Step 4：ngrok 隧道（讓 LINE 能戳到你的電腦）

> 預估時間：10 分鐘
> 目標：拿到 `https://xxxx.ngrok-free.dev/webhook` 這個公開 URL，並讓 LINE Webhook **Verify** 通過 ✅

---

## 4-0. 為什麼需要 ngrok？

```
LINE 平台（外網）  ──X──>  你的電腦 localhost:3000
                   ↑
               外網碰不到你家電腦
```

解方 — ngrok 建一條隧道把外網接到你的 localhost：

```
LINE 平台  ──>  https://xxxx.ngrok-free.dev  ──ngrok 隧道──>  localhost:3000
```

---

## 4-1. 註冊並下載 ngrok

### 4-1-1. 註冊

打開 <https://ngrok.com/> → 右上 **Sign up** → 用 Google 或 GitHub 帳號註冊（**免費**）。

### 4-1-2. 下載 Windows 版

登入後會進入 Dashboard。左邊選單：
```
Setup & Installation → Windows → Download ZIP
```

下載得到 `ngrok-v3-stable-windows-amd64.zip`。

### 4-1-3. 解壓縮並放到固定位置

**建議放在**：
```
C:\Users\<你的使用者名>\AppData\Local\ngrok\ngrok.exe
```

步驟：
1. 解壓縮 ZIP → 裡面有 `ngrok.exe` 一個檔案
2. 開檔案總管，**地址列輸入** `%LOCALAPPDATA%\ngrok` 按 Enter
3. 如果資料夾不存在，建立它
4. 把 `ngrok.exe` **剪下貼上**到這資料夾

### 4-1-4. 把 ngrok 加到系統 PATH

開 PowerShell，貼入：

```powershell
$ngrokDir = "$env:LOCALAPPDATA\ngrok"
$userPath = [System.Environment]::GetEnvironmentVariable('Path','User')
if ($userPath -notlike "*$ngrokDir*") {
  [System.Environment]::SetEnvironmentVariable('Path', "$userPath;$ngrokDir", 'User')
  Write-Host "✅ 已加入 PATH"
} else {
  Write-Host "已經在 PATH"
}
```

**⚠️ 然後關閉 PowerShell、重新開一個**（讓 PATH 生效）。

驗證：
```powershell
ngrok version
```
應該回 `ngrok version 3.x.x`。

---

## 4-2. 設定 Authtoken（讓 ngrok 認證你）

1. 回瀏覽器 ngrok Dashboard
2. 左邊選單 → **Your Authtoken**
3. 複製那串 token（格式：`2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_xxxxxxxxxxxxxxxxxxxxx`）

回 PowerShell：

```powershell
ngrok config add-authtoken 你的_ngrok_authtoken
```

看到：
```
Authtoken saved to configuration file: C:\Users\<你>\AppData\Local\ngrok\ngrok.yml
```
就成功了。

---

## 4-3. 啟動隧道

> [!WARNING]
> **先確認 Step 3 的 LINE Bridge 還在跑**（另一個 PowerShell 視窗應該顯示「Bridge 啟動成功」）。
> 如果不在，回 Step 3-5 重新 `node line-bridge.js`。

**另外開一個新 PowerShell**（不要關掉跑 Bridge 的那個），貼：

```powershell
ngrok http 3000
```

看到：
```
ngrok                                     (Ctrl+C to quit)

Session Status    online
Account           你的 email
Version           3.x.x
Region            Asia Pacific (ap)
Forwarding        https://engaged-gala-sliceable.ngrok-free.dev -> http://localhost:3000

Connections       ttl     opn     rt1     rt5     p50     p90
                  0       0       0.00    0.00    0.00    0.00
```

**關鍵**：**`Forwarding`** 那行的 `https://` URL（例如 `https://engaged-gala-sliceable.ngrok-free.dev`）— **複製它**。

每個人 URL 都不一樣，**每次重啟 ngrok URL 也會變**。

> [!WARNING]
> **這個 ngrok PowerShell 視窗不要關！** 關了隧道就斷，LINE 就戳不到你。

---

## 4-4. 填 LINE Webhook URL（關鍵步驟）

回到瀏覽器，**LINE Developers Console** 頁面。

### 4-4-1. 打開你的 Channel 管理頁

若你已關掉分頁：
- 打開 <https://developers.line.biz/console/>
- 點你的 Provider
- 點你的 Channel（就是 Step 2-3 建的那個）

### 4-4-2. 切到 Messaging API 頁籤

畫面上方分頁列：
```
[Basic settings]  [Messaging API]  ← 點這個
```

### 4-4-3. 找 Webhook URL 欄位

**往下滑**，會看到「**Webhook settings**」區塊，底下有個欄位：

```
Webhook URL
┌──────────────────────────────────────────────┐
│  （空白）                                    │  [Edit]
└──────────────────────────────────────────────┘
                                     [Verify]  [Update]
```

### 4-4-4. 點 Edit → 貼入完整 URL

1. 點右邊 **Edit** 按鈕（或如果可以直接點輸入框也行）
2. 欄位變成可輸入
3. **貼入你剛剛的 ngrok URL**，**最後要加 `/webhook`**：

```
https://engaged-gala-sliceable.ngrok-free.dev/webhook
                                              ^^^^^^^
                                              ⚠️ 一定要有 /webhook
```

4. 點 **Update** 按鈕儲存

### 4-4-5. 點 Verify 測試

儲存後同一區會出現 **Verify** 按鈕（或在 URL 旁邊）：

1. 點 **Verify**
2. 等 2-5 秒
3. 應該跳出綠色 **Success** 勾勾 ✅

### 4-4-6. 確認 "Use webhook" 開關

Webhook URL 欄位**下方**有個開關：

```
Use webhook   [ ⚪────🟢]  ← 要是綠色（開啟）
```

如果是灰色就**點它變綠色**。

---

## 4-5. 🎉 第一次對話測試

**打開手機 LINE app**，找到 Step 2-8 加的 Bot，傳訊息：

```
你好
```

等 **3-5 秒**，應該會收到 Gemini 回的繁體中文回覆！

---

## 4-6. 觀察即時 log（確認訊息有流過）

回到**跑 Bridge 的第一個** PowerShell，會看到類似：
```
[收到] userId=Uxxxx... | 訊息：你好
[回覆] (main) 你好！很高興認識你...
```

這確認訊息真的流過整個鏈路了。

---

## 4-7. Verify 失敗怎麼辦？排錯清單

Verify 按下去顯示錯誤，照這順序檢查：

### ❶ URL 格式
- 結尾 **一定要** `/webhook`
- `https://` 不能寫成 `http://`
- 中間不能多空白

### ❷ 3 個視窗都要開
確認以下 3 個 PowerShell 視窗都還在跑：
1. 跑 Bridge 的視窗（顯示「Bridge 啟動成功」的那個）
2. 跑 ngrok 的視窗（顯示 Forwarding 那個）
3. （這個視窗可以是新的，用來下指令）

### ❸ ngrok URL 是最新的
關掉後重開 ngrok，URL 會變。檢查你貼的 URL 和目前 ngrok 畫面上的 `Forwarding https://...` **是一樣的**。

### ❹ 本機 Bridge 有回應
開新 PowerShell：
```powershell
Invoke-RestMethod 'http://localhost:3000/'
```
有 JSON 輸出代表 Bridge 正常。

### ❺ .env 裡的 LINE_CHANNEL_SECRET 沒填錯
Bridge 用這個驗 LINE 的簽名，填錯的話 Verify 會被 Bridge 拒絕。

開 .env 再對一次：
```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

改完要**回 Bridge 視窗 Ctrl+C 停掉、重新 `node line-bridge.js` 啟動**。

---

## 4-8. ⚠️ ngrok 免費版陷阱（你必須知道）

**每次你重啟 ngrok（關視窗、電腦重開），ngrok URL 都會變！**

所以**每一次** Bridge 要重新對外：
1. 重新 `ngrok http 3000` 取得新 URL
2. 回 LINE Console 把新 URL + `/webhook` 重貼到 Webhook URL 欄位
3. 再按 Verify、Update

**永久解法：**
- 升級 ngrok **付費版**（$8/月，固定 subdomain）
- 或改用 **Cloudflare Tunnel**（免費、固定 URL，但設定較複雜）
- 或買便宜 **VPS**（最穩）

---

## 🎉 Step 4 完成！

LINE → ngrok → Bridge → Gemini 鏈路通了。

**下一步：Step 5「切換到 ChatGPT Plus 訂閱模式」** — 改用你已付費的 ChatGPT 訂閱，跑 gpt-5.4 更聰明，且**不扣 OpenAI API 餘額**。
