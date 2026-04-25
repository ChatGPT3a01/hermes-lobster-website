# 💚 Step 2：申請 LINE Bot

> 預估時間：10 分鐘
> 目標：拿到 **Channel ID**、**Channel Secret**、**Channel Access Token**、你的 **User ID** 四樣東西

---

## 🗂️ 本步驟會取得的 4 樣資訊（先準備筆記本／記事本記下來）

| 項目 | 樣子 | 用在哪 |
|------|------|--------|
| Channel ID | 10 位數字，例 `2008123456` | 僅備存 |
| Channel Secret | 32 位英數 | Step 3 貼入 `bridge\.env` |
| Channel Access Token | 超長一大串（170+ 字）結尾有 `=` | Step 3 貼入 `bridge\.env` |
| 你的 LINE User ID | `U` 開頭 32 字 | 備存（之後可設白名單）|

> [!TIP]
> 建議把這 4 樣貼到：
> ```
> C:\OpenClaw_Auto\龍蝦資料.txt
> ```
> 沒有的話直接用記事本新建一個。Step 3 會從這裡複製到 `.env`。

---

## 2-1. 前往 LINE Developers Console

打開瀏覽器 → <https://developers.line.biz/console/>

用你的 **LINE 個人帳號**登入（就是手機 LINE 那個）。

首次登入要：
1. 同意開發者條款
2. 輸入 email（通知信用）
3. 勾兩個同意 → Continue

---

## 2-2. 建立 Provider（沒有的話）

**Provider ≈ 開發者／組織名義**，一個 Provider 底下可以放很多 Bot Channel。

**操作：**

1. 點畫面上方／左上角「**Create**」→「**Create a new provider**」
2. **Provider name** 填：`阿亮老師個人` 或你的名字（隨意）
3. **Create**

建好會自動進入該 Provider 頁面。

---

## 2-3. 建立 Messaging API Channel

在 Provider 頁面有幾個分頁，點 **Channels**（或直接看到「建立 Channel」按鈕）：

1. 點 **Create a Messaging API channel**
   - ⚠️ **不是** LINE Login、**不是** LIFF，**一定要** Messaging API
2. 填表格：

| 欄位 | 怎麼填 |
|------|--------|
| Channel type | Messaging API（預設已選）|
| Provider | 選你剛建的 Provider |
| Channel icon | 可跳過，之後再設 |
| **Channel name** | Bot 顯示名，例：`愛馬仕助理`（會是 LINE 好友列表上的名字）|
| Channel description | 簡短描述，例：`個人 AI 助理` |
| **Category** | 選 `Personal` |
| **Subcategory** | 選 `Personal` |
| Email address | 你的 email |

3. 同意 2 個條款勾選
4. **Create**

建好後會進入 Channel 的管理頁（裡面很多分頁）。

---

## 2-4. 取得憑證（3 個）

Channel 管理頁上方有幾個分頁：
```
[Basic settings]  [Messaging API]  [Security]  [Statistics]  [LIFF]
```

### 2-4-A：Channel ID（10 位數字）

1. 點 **Basic settings** 頁籤（通常預設就在這）
2. 畫面最上方第一項 **Channel ID**，底下顯示 10 位純數字
3. 點右邊**複製**按鈕

📝 記到「龍蝦資料.txt」：
```
Channel ID : 2008xxxxxx
```

---

### 2-4-B：Channel Secret（32 位英數）

1. 依然在 **Basic settings** 頁籤，**往下滑**
2. 找到 **Channel secret** 欄位
3. 點右邊**複製**按鈕

📝 記到「龍蝦資料.txt」：
```
Channel Secret : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

### 2-4-C：Channel Access Token（超長那個，最容易出錯）

1. 切到頂部頁籤 **Messaging API**（不是 Basic settings）
2. **往下滑**到底，有個「**Channel access token**」段落
3. 子區塊叫「**Long-lived channel access token**」（或 "Channel access token (long-lived)"）
4. 第一次進來是**空白**的，有一個藍色 **Issue** 按鈕 → **點它**
5. 幾秒後會產生一大串英數字（約 170+ 字元，結尾有 1 個或 2 個 `=`）
6. 點右側 **Copy** 按鈕

⚠️ **最常見的坑**：
- Token 結尾的 `=` **一定要複製到**，有幾個 `=` 就帶幾個
- Token 是**單行**，不能中間斷開
- 前面不能多空白字元

📝 記到「龍蝦資料.txt」：
```
Channel Access Token :
XXX...超長一大段...XXX=
```

---

## 2-5. 取得你自己的 LINE User ID

Bot 回訊息需要知道你的 ID。未來也可能把你 ID 設白名單（只有你能用）。

**操作：**

1. 打開手機 **LINE app**
2. 加好友 → 搜尋 **`@userinfobot`**
   - 或直接點這連結（手機點會跳 LINE）：<https://line.me/R/ti/p/%40userinfobot>
3. 加為好友
4. 傳任何訊息（例如 `hi`）
5. 它立刻回一段訊息，裡面有 **User ID**：`U` 開頭 + 32 位英數

📝 記到「龍蝦資料.txt」：
```
LINE User ID (我) : Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 2-6. ⚠️ 關掉 Auto-reply（必做，不做 Bot 會亂回話！）

**不做的後果**：LINE 會用預設「感謝您的訊息」自動回，跟你的 AI 同時回 → 使用者收到兩則訊息。

**操作：**

1. 回 Channel 管理頁，切 **Messaging API** 頁籤
2. **往下滑到最底**，找「**LINE Official Account features**」區塊
3. 這裡有兩個 Edit 按鈕：
   - **Auto-reply messages** ← 這個要關
   - **Greeting messages** ← 歡迎訊息，可留可關
4. 點 **Auto-reply messages** 的 **Edit**
5. 會**跳轉到另一個網站**叫「**LINE Official Account Manager**」
6. 可能要重新登入（用同一個 LINE 帳號即可）
7. 進去後左邊選單點：**回應設定**（Response settings）
8. 調整這 3 項：

| 設定 | 要改成 |
|------|--------|
| **自動回應訊息** | ❌ **停用** |
| **歡迎訊息** | ⭕ 可留可停 |
| **Webhook** | ✅ **啟用** |

9. 畫面底部點 **儲存**

---

## 2-7. ⚠️ Webhook URL 欄位（現在先留空！Step 4 才填）

在 **Messaging API** 頁籤找「**Webhook settings**」區塊，有個 **Webhook URL** 欄位。

> [!WARNING]
> **現在還不要填！**
> 這個 URL 要等 Step 4 架好 ngrok 之後才有內容可填。
> 如果現在亂填，LINE 會一直嘗試戳不通的伺服器。

**目前確認：**
- **Webhook URL**：**空白**（或保留空）
- 下面還有兩個開關：
  - **Use webhook**：先預設開（若是關的先不動）
  - 先**不要按 Verify**
- **記住這個頁面怎麼開的**，Step 4 會回來這裡填 URL

---

## 2-8. 加 Bot 為好友（可以掃 QR 了）

1. 回 **Messaging API** 頁籤
2. **往上滑**到頁面上方
3. 會看到一個 **QR code** 區塊（你的 Bot 專屬 QR）
4. 用**手機 LINE app** 掃它 → 把 Bot 加為好友

加好之後**先不要傳訊息**（Bridge 還沒架，傳了沒人接）。

---

## 2-9. 驗證 Channel Access Token（確認沒複製錯）

打開 PowerShell，貼下面指令，把 `你的_Channel_Access_Token` **整段取代**成你的 Token：

```powershell
$token = '你的_Channel_Access_Token'
Invoke-RestMethod -Uri 'https://api.line.me/v2/bot/info' -Headers @{Authorization="Bearer $token"}
```

**成功會看到：**
```
userId         : Uxxxxx...    ← Bot 自己的 userId（不是你）
basicId        : @088xxxx     ← Bot 的 basic id
displayName    : 愛馬仕助理    ← 你設的 Bot 名字
chatMode       : bot
markAsReadMode : auto
```

**失敗是 401 Unauthorized** → Token 複製錯了：
- 最常見：結尾 `=` 漏掉 → 回 Console 重新複製
- 次常見：前面多複製了空白 → 檢查 `$token = '...'` 引號內開頭結尾是否乾淨

---

## 🎉 Step 2 完成！

4 樣資訊記在 `C:\OpenClaw_Auto\龍蝦資料.txt`：

```
【LINE Bot】
Channel ID           : 2008xxxxxx
Channel Secret       : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Channel Access Token : XXXX...超長...=
LINE User ID (我)    : Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**下一步：Step 3「部署 LINE Bridge」** — 會用到其中 2 個 `LINE_*` 憑證。
