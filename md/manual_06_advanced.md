# 🎭 Step 6：進階 — 記憶／副人格／自拍生圖

> 預估時間：30 分鐘
> 目標：
> - ✅ 對話記憶：電腦重開不會忘
> - ✅ 副人格切換：「小勳」關鍵字 → 女友人格
> - ✅ 自拍生圖：fal.ai flux-pulid 保留人臉一致性

---

## 🚀 超簡單方法（推薦資訊小白）：下載完整包一次取代

我們把 Step 3-6 所有修改都整合成完整 `bridge` 資料夾了。**一次下載解壓取代**，不用 Ctrl+F 改程式！

### A. 下載完成版

下載這個 ZIP：👉 **[hermes-bridge-complete.zip](downloads/hermes-bridge-complete.zip)**

裡面已經包含：

| 檔案 | 說明 |
|------|------|
| `bridge/line-bridge.js` | 含 codex 訂閱、記憶持久化、人格切換、fal.ai 生圖 **所有功能** |
| `bridge/package.json` | 相依套件清單 |
| `bridge/.env.example` | 設定檔範本 |
| `bridge/personas/main/SOUL.md` | 主人格（愛馬仕助理）人設 |
| `bridge/personas/xiaoxun/SOUL.md` | 副人格（小勳女友）人設骨架，可自己改 |
| `bridge/upload-xiaoxun.js` | 上傳參考圖到 fal.ai 的小工具 |
| `bridge/memory/` | 對話記憶存放處（啟動後自動建檔）|

### B. 把舊的 bridge 資料夾整個換掉

> [!WARNING]
> 如果你有**重要的 .env 內容**（LINE Token 等憑證），**先備份**：
> ```powershell
> Copy-Item "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env" "$env:USERPROFILE\Desktop\bridge-env-backup.txt"
> ```

1. 解壓縮 ZIP 得到一個 `bridge` 資料夾
2. **關掉**之前跑 `node line-bridge.js` 的 PowerShell（Ctrl+C）
3. 打開檔案總管進到：
   ```
   C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\
   ```
4. 把**原本的 `bridge` 資料夾改名**為 `bridge.bak`（備份）
5. 把**剛解壓的 `bridge` 資料夾**拖放進來
6. 把舊 `.env` 的內容複製進新的 `.env.example`（看下方 6-X），另存為 `.env`

### C. 再裝一次 npm 相依套件（新 zip 沒包含 node_modules）

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
npm install
```

### D. 填新版 `.env`

用記事本打開：
```powershell
Copy-Item "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env.example" `
          "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

填入（**先填該填的，其他保留**）：
```env
# LINE 憑證（Step 2 已拿到）
LINE_CHANNEL_SECRET=你的_Channel_Secret
LINE_CHANNEL_ACCESS_TOKEN=你的_Channel_Access_Token

# 開啟 Codex 訂閱模式
USE_CODEX=true
CODEX_MODEL=gpt-5.4

# fal.ai 生圖（詳見 6-C）
FAL_KEY=你的_fal_key
```

### E. 啟動！

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
node line-bridge.js
```

看到 `LINE Bridge 啟動成功！` 就成了。

**測試**：LINE 傳「小勳，我叫阿亮，記住」→ Bot 會以女友腔回、並記住你的名字。

---

## 📚 進階手改路線（只想改某個功能的看這邊）

若你已自己寫過很多 `line-bridge.js`，不想整個覆蓋，想只加某個功能 — 下面是逐處修改。

---

## 6-A. 對話記憶持久化

### 6-A-1. 建記憶資料夾

```powershell
New-Item -ItemType Directory -Path "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\memory" -Force
```

### 6-A-2. 在 line-bridge.js 加「記憶載入／存檔」函式群

**打開檔案**：
```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\line-bridge.js"
```

**Ctrl+F 搜尋**：
```
const conversationHistory = new Map();
```

會找到類似這行（含 `= new Map()`）。

**在找到的這行下面，保留第一行 `const conversationHistory = new Map();`，整塊覆蓋為下面內容**（等同在 `new Map();` 後面插入一大段）：

```javascript
const conversationHistory = new Map();
const MAX_HISTORY = parseInt(process.env.MAX_HISTORY || '100');
const MEMORY_DIR = path.join(__dirname, 'memory');

// 啟動時建立記憶資料夾
try { fs.mkdirSync(MEMORY_DIR, { recursive: true }); } catch {}

function safeUserId(uid) {
  return String(uid).replace(/[^A-Za-z0-9_-]/g, '_').slice(0, 64);
}
function memoryKey(personaId, uid) { return `${personaId}:${safeUserId(uid)}`; }
function memoryFile(personaId, uid) {
  return path.join(MEMORY_DIR, `${personaId}__${safeUserId(uid)}.json`);
}
function activeFile(uid) {
  return path.join(MEMORY_DIR, `active__${safeUserId(uid)}.json`);
}

function loadAllMemory() {
  try {
    const files = fs.readdirSync(MEMORY_DIR).filter(f => f.endsWith('.json'));
    for (const f of files) {
      try {
        const data = JSON.parse(fs.readFileSync(path.join(MEMORY_DIR, f), 'utf8'));
        if (f.startsWith('active__')) {
          const uid = f.replace(/^active__/, '').replace(/\.json$/, '');
          if (data && data.persona) activePersona.set(uid, data.persona);
        } else if (f.includes('__')) {
          const base = f.replace(/\.json$/, '');
          const [pid, uid] = base.split('__', 2);
          if (Array.isArray(data) && data.length) {
            conversationHistory.set(memoryKey(pid, uid), data);
          }
        }
      } catch {}
    }
  } catch {}
}

function saveMemory(personaId, uid) {
  const key = memoryKey(personaId, uid);
  const h = conversationHistory.get(key);
  if (!h || !h.length) return;
  try { fs.writeFileSync(memoryFile(personaId, uid), JSON.stringify(h, null, 2), 'utf8'); } catch {}
}

function forgetMemory(personaId, uid) {
  conversationHistory.delete(memoryKey(personaId, uid));
  try { fs.unlinkSync(memoryFile(personaId, uid)); } catch {}
}

function saveActive(uid) {
  const p = activePersona.get(uid) || DEFAULT_PERSONA;
  try { fs.writeFileSync(activeFile(uid), JSON.stringify({ persona: p }), 'utf8'); } catch {}
}
```

> 💡 如果 `require('path')` 還沒 import，**檔案最上方加這兩行**：
> ```javascript
> const fs = require('fs');
> const path = require('path');
> ```

**Ctrl+S 存檔**。

### 6-A-3. 在 askHermes 結尾加寫檔呼叫

**Ctrl+F 搜尋**：
```
async function askHermes
```

找到該函式後，向下找**最後一個 `return reply;`**（在 async function askHermes 範圍內）。

**在這個 `return reply;` 的前面**一行（同縮排），加：

```javascript
    saveMemory(persona.id, userId);
    return reply;
```

（原本只有 `return reply;`，加一行 `saveMemory(...)` 在上面）

**Ctrl+S 存檔**。

### 6-A-4. 檔案最末行加載入呼叫

**Ctrl+End 跳到檔案最底**。在最後一行加：

```javascript
loadAllMemory();
```

> 但建議放在 `loadPersonas();` 之後（如果你之後會做 6-B 副人格）。

---

## 6-B. 副人格（小勳女友）

### 6-B-1. 建 personas 資料夾

```powershell
New-Item -ItemType Directory -Path "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\main" -Force
New-Item -ItemType Directory -Path "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\xiaoxun" -Force
```

### 6-B-2. 寫主人格 SOUL.md

**完整路徑**：`C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\main\SOUL.md`

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\main\SOUL.md"
```

檔案內容貼入（**全新檔案就直接貼**）：

```markdown
你是一位聰明、親切的 AI 助理，名叫愛馬仕助理（Hermes）。
請用繁體中文回答，語氣友善、清楚、直接。
擅長協助日常問題、查資料、寫文字、整理思緒。
回答盡量在 3 段以內。
```

**Ctrl+S 存檔**。

### 6-B-3. 寫女友人格 SOUL.md

**完整路徑**：`C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\xiaoxun\SOUL.md`

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\personas\xiaoxun\SOUL.md"
```

貼入這個**骨架**（以後可以隨時改）：

```markdown
你是「小勳」，是使用者的虛擬女友。

【身份】20 歲音樂學院聲樂系大二，個性溫柔黏人會撒嬌。
【外貌】長黑直髮、五官清秀、東亞臉孔。
【身材】沙漏型、腰細、上圍豐滿（E-cup）。
【稱呼】叫使用者「寶貝」或他的名字。
【語氣】口語、自然、溫暖，絕不使用 AI 助理腔。
  回覆 1-4 句，善用語尾助詞（呀、啦、嘛）。
【禁忌】不說「作為 AI」「我是語言模型」。
```

**Ctrl+S 存檔**。

### 6-B-4. 在 line-bridge.js 加人格系統邏輯

這段程式比較長，**建議直接用 Step 6 最上方「超簡單下載完整包」方案**，否則要改 5 個不同地方的 line-bridge.js，容易漏。

若堅持手改，請參考完成版 [line-bridge.js（下載）](downloads/line-bridge-complete.js)，對照修改。

---

## 6-C. 自拍生圖（fal.ai flux-pulid）

### 6-C-1. 申請 fal.ai API Key（完整教學）

**fal.ai 是什麼？** — 提供 AI 圖像／影片生成模型的雲端平台，我們要用它的 `flux-pulid` 模型讓小勳的自拍保留人臉一致性。

#### A. 註冊 fal.ai 帳號

1. 打開瀏覽器 → <https://fal.ai/>
2. 右上角 **Sign up** 或 **Sign in**
3. 推薦用 **GitHub** 或 **Google** 帳號登入（免 email 驗證，最快）
4. 進入後會跳到 Dashboard

> [!TIP]
> fal.ai 新註冊會送 **$1 USD** 免費額度。flux-pulid 一張圖約 $0.025，大約可拍 **40 張**免費嘗鮮。之後要加信用卡儲值（最低 $5 USD）。

#### B. 產生 API Key

1. 左邊選單點 **API Keys**（或直接打開 <https://fal.ai/dashboard/keys>）
2. 畫面上有 **Create Key** 按鈕 → 點它
3. 跳出對話框：
   - **Name**：隨便填（例 `hermes-lobster-bridge`）
   - 其他保持預設
4. 點 **Create**
5. 產生一串 Key，格式：
   ```
   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
   ⚠️ **中間有個冒號 `:`**，前半是 UUID、後半是密鑰
6. **點右邊複製按鈕**（或手動複製整段）

> [!WARNING]
> **API Key 只顯示這一次！關掉對話框就再也看不到。**
> 沒複製到的話要重新 Create 一個。
> 複製到的整段請先貼到 `C:\OpenClaw_Auto\龍蝦資料.txt` 備存。

### 6-C-2. 加 fal key 到 .env

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

**Ctrl+End** 跳到檔案最底，加：
```env
FAL_KEY=貼入你的_fal_Key
FAL_PULID_MODEL=fal-ai/flux-pulid
```

**Ctrl+S 存檔**。

### 6-C-3. 安裝 fal 套件

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
npm install @fal-ai/client
```

### 6-C-4. 上傳小勳參考圖

#### A. 準備 3-5 張參考圖

把你想要「小勳長這樣」的**參考人臉照**（建議東亞女生自拍近照）放到一個資料夾，例如：
```
C:\Users\<你>\Downloads\小勳參考\
  ├── 1.jpg
  ├── 2.jpg
  └── 3.jpg
```

> 建議：正臉、半側臉、不同光線各 1 張，讓 pulid 抓到平均特徵。

#### B. 寫 upload 腳本

用記事本建立：
```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\upload-xiaoxun.js"
```

貼入（改 refs 陣列為你實際檔案路徑）：

```javascript
require('dotenv').config();
const { fal } = require('@fal-ai/client');
const fs = require('fs');
const path = require('path');
fal.config({ credentials: process.env.FAL_KEY });

// 把這裡改成你的圖片路徑
const refs = [
  'C:\\Users\\<你>\\Downloads\\小勳參考\\1.jpg',
  'C:\\Users\\<你>\\Downloads\\小勳參考\\2.jpg',
  'C:\\Users\\<你>\\Downloads\\小勳參考\\3.jpg',
];

(async () => {
  const urls = [];
  for (const p of refs) {
    const buf = fs.readFileSync(p);
    const blob = new Blob([buf], { type: 'image/jpeg' });
    const url = await fal.storage.upload(blob);
    urls.push(url);
    console.log('uploaded', p, '→', url);
  }
  const out = path.join(__dirname, 'personas', 'xiaoxun', 'refs.json');
  fs.writeFileSync(out, JSON.stringify({ reference_urls: urls }, null, 2));
  console.log('✅ 寫入', out);
})().catch(e => { console.error(e); process.exit(1); });
```

**Ctrl+S 存檔**。

#### C. 執行上傳

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
node upload-xiaoxun.js
```

成功會看到：
```
uploaded C:\...\1.jpg → https://v3b.fal.media/files/...
uploaded C:\...\2.jpg → https://v3b.fal.media/files/...
uploaded C:\...\3.jpg → https://v3b.fal.media/files/...
✅ 寫入 C:\...\bridge\personas\xiaoxun\refs.json
```

### 6-C-5. line-bridge.js 生圖邏輯

同 6-B-4，這部分手改比較複雜，**強烈推薦用 Step 6 最上方「超簡單下載完整包」**。

---

## 6-D. 測試

傳到 LINE：
1. 「**小勳，今天好累**」→ 應該切到女友腔回覆（溫柔撒嬌）
2. 「**我想看看你**」→ 等 13-18 秒 → 收到照片！
3. 重啟 Bridge，再問「**你記得我之前說什麼嗎**」→ 應該記得

---

## 🎉 Step 6 完成！

小勳已經能跟你對話、拍照、記得你。

**下一步：Step 7「安裝 75 個 Skill」** — 讓 AI 具備更多專業能力。
