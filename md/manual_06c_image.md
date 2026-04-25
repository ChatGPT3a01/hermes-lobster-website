# 📸 自拍生圖（fal.ai flux-pulid）

> 目標：在 LINE 傳「我想看看你」→ 小勳發來一張保留人臉一致性的自拍照

---

## 超簡單方法：下載完整包（推薦）

不想手動設置？直接看 **[6️⃣ 進階功能]** 頁最上方「下載完整包」，裡面已包含 fal.ai 生圖的所有程式碼。

---

## Step 1：申請 fal.ai API Key

### A. 註冊帳號

1. 打開瀏覽器 → <https://fal.ai/>
2. 右上角 **Sign up**
3. 推薦用 **GitHub** 或 **Google** 帳號登入（最快）
4. 進入 Dashboard

> [!TIP]
> fal.ai 新註冊送 **$1 USD** 免費額度。flux-pulid 一張圖約 $0.025，大約可拍 **40 張**免費嘗鮮。之後加信用卡儲值（最低 $5 USD）。

### B. 產生 API Key

1. 左邊選單 → **API Keys**（或開 <https://fal.ai/dashboard/keys>）
2. 點 **Create Key**
3. Name 隨便填（例：`hermes-lobster-bridge`）
4. 點 **Create**
5. 複製整串 Key（格式：`xxxxxxxx-xxxx:xxxxxxxxxxxxxxxx`）

> [!WARNING]
> **API Key 只顯示一次！** 關掉視窗就再也看不到，一定要先複製存到 `C:\OpenClaw_Auto\龍蝦資料.txt`

---

## Step 2：加 fal key 到 .env

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\.env"
```

**Ctrl+End** 跳到最底，加：

```env
FAL_KEY=貼入你的_fal_Key
FAL_PULID_MODEL=fal-ai/flux-pulid
```

**Ctrl+S 存檔**。

---

## Step 3：安裝 fal 套件

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
npm install @fal-ai/client
```

---

## Step 4：上傳小勳參考圖

### A. 準備 3-5 張參考圖

把你想要「小勳長這樣」的**參考人臉照**放到一個資料夾：
```
C:\Users\<你>\Downloads\小勳參考\
  ├── 1.jpg
  ├── 2.jpg
  └── 3.jpg
```

> 建議：正臉、半側臉、不同光線各 1 張，讓 pulid 抓到平均特徵。

### B. 建立上傳腳本

```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\upload-xiaoxun.js"
```

貼入（**把 refs 陣列改成你實際圖片路徑**）：

```javascript
require('dotenv').config();
const { fal } = require('@fal-ai/client');
const fs = require('fs');
const path = require('path');
fal.config({ credentials: process.env.FAL_KEY });

// ⬇️ 改成你的圖片路徑
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

### C. 執行上傳

```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
node upload-xiaoxun.js
```

成功看到：
```
uploaded C:\...\1.jpg → https://v3b.fal.media/files/...
✅ 寫入 C:\...\bridge\personas\xiaoxun\refs.json
```

---

## Step 5：line-bridge.js 加生圖邏輯

這部分手動修改比較複雜，**強烈推薦用「下載完整包」方案**。

---

## 測試生圖

重啟 Bridge 後，在 LINE 傳：
- `我想看看你` → 等 13-18 秒 → 收到小勳的 AI 自拍照！
- `拍一張你笑的樣子` → 同樣觸發生圖

---

> [!NOTE]
> 生圖速度約 13-18 秒，這是正常的，flux-pulid 需要時間處理人臉一致性。
