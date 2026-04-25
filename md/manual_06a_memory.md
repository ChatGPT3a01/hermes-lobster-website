# 🧠 對話記憶持久化設置

> 目標：電腦重開後，AI 仍然記得你們的對話歷史

---

## 超簡單方法：下載完整包（推薦）

如果你不想手動改程式，直接看 **[6️⃣ 進階功能]** 頁面最上方「下載完整包」方案，一次搞定。

---

## 手動設置流程

### Step 1：建記憶資料夾

```powershell
New-Item -ItemType Directory -Path "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\memory" -Force
```

---

### Step 2：在 line-bridge.js 加記憶函式群

**打開檔案**：
```powershell
notepad "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\line-bridge.js"
```

**Ctrl+F 搜尋**：
```
const conversationHistory = new Map();
```

**在找到的這行下面**，整塊覆蓋為（等同在 `new Map();` 後面插入一大段）：

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

> [!TIP]
> 如果 `require('path')` 還沒 import，在檔案最上方加這兩行：
> ```javascript
> const fs = require('fs');
> const path = require('path');
> ```

**Ctrl+S 存檔**。

---

### Step 3：在 askHermes 結尾加寫檔呼叫

**Ctrl+F 搜尋**：
```
async function askHermes
```

找到該函式後，向下找**最後一個 `return reply;`**，在它的**前面**一行加：

```javascript
    saveMemory(persona.id, userId);
    return reply;
```

**Ctrl+S 存檔**。

---

### Step 4：檔案最末行加載入呼叫

**Ctrl+End 跳到檔案最底**，在最後一行加：

```javascript
loadAllMemory();
```

> [!NOTE]
> 如果你有做副人格，建議放在 `loadPersonas();` 之後。

**Ctrl+S 存檔**。

---

### Step 5：測試記憶

重啟 Bridge：
```powershell
Set-Location "C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge"
node line-bridge.js
```

LINE 傳「我叫阿亮」→ 對話，**重開電腦後**再問「你還記得我叫什麼嗎？」→ 應該記得！
