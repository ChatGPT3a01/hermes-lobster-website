# 🔓 Step 5：切換到 ChatGPT Plus 訂閱模式（Codex）

> 預估時間：10 分鐘
> 目標：LINE Bot 改用你的 ChatGPT Plus/Pro 訂閱回答，**不另扣 OpenAI API 餘額**

---

## 5-0. 原理說明

普通 API key 模式：
```
LINE Bridge ──→ https://api.openai.com/v1/chat/completions
                （要付 API Key 的錢，每個 token 都計費）
```

Codex 訂閱模式：
```
LINE Bridge ──spawn子進程──→ codex exec
                              ↓（吃 ChatGPT OAuth token）
                           ChatGPT 後端伺服器
                              ↓（吃月訂閱額度，不另收錢）
                           回傳答案
```

---

## 5-1. 安裝 Codex CLI

```powershell
npm install -g @openai/codex
```

看到 `added 1 package` → OK。

驗證：

```powershell
codex --version
```

應該回 `OpenAI Codex v0.x.x (research preview)`。

---

## 5-2. 用 ChatGPT Plus 帳號登入

```powershell
codex login
```

會有兩種可能：

**A. 自動開瀏覽器**：跳出 OAuth 登入頁 → 選「**Continue with ChatGPT**」→ 登入你的 ChatGPT Plus 帳號 → 授權 → 回終端會看到 `Logged in using ChatGPT`。

**B. 終端顯示網址**：手動複製網址到瀏覽器完成上述流程。

完成後驗證：

```powershell
codex login status
```

應該回 `Logged in using ChatGPT`。

---

## 5-3. 測試 codex exec 可用

```powershell
codex exec --skip-git-repo-check --ephemeral "用一句話自介"
```

會跑 3-5 秒，最後看到一行回覆，類似：
```
你好，我是 Codex，OpenAI 的 AI 助手，樂於幫你寫程式與回答問題。
```

確認是走訂閱：上面輸出會顯示：
```
model: gpt-5.3-codex
provider: openai
```

---

## 5-4. 改造 LINE Bridge 支援 Codex

### 5-4-1. 修改 `bridge/line-bridge.js`

先關掉正在跑的 Bridge（Ctrl+C）。

用記事本開 `line-bridge.js`，找到檔案頂部（約第 30 行前後）：

```javascript
require('dotenv').config();
const express = require('express');
const line = require('@line/bot-sdk');
const { OpenAI } = require('openai');
```

**底下加**：

```javascript
const { spawn } = require('child_process');
const os = require('os');
const fs = require('fs');
const path = require('path');
```

### 5-4-2. 加 Codex 設定常數

在上面 require 之後，找「設定」區塊加入：

```javascript
// Codex 訂閱模式
const USE_CODEX = String(process.env.USE_CODEX || '').toLowerCase() === 'true';
const CODEX_MODEL = process.env.CODEX_MODEL || 'gpt-5.4';
const CODEX_JS_PATH = process.env.CODEX_JS_PATH ||
  path.join(process.env.APPDATA || '', 'npm', 'node_modules',
            '@openai', 'codex', 'bin', 'codex.js');
```

### 5-4-3. 加 `askViaCodex` 函式

找到檔案裡的 `async function askHermes(...)` 之前，**加一個新函式**：

```javascript
function askViaCodex(prompt) {
  return new Promise((resolve) => {
    const tmpFile = path.join(os.tmpdir(),
      `codex-${Date.now()}-${Math.random().toString(36).slice(2,8)}.txt`);
    const args = [CODEX_JS_PATH, 'exec',
      '--skip-git-repo-check', '--ephemeral',
      '--dangerously-bypass-approvals-and-sandbox',
      '--color', 'never',
      '-m', CODEX_MODEL,
      '-o', tmpFile, prompt];
    const proc = spawn(process.execPath, args, { shell: false });
    let err = '';
    proc.stderr.on('data', d => err += d);
    const timer = setTimeout(() => { try { proc.kill('SIGKILL'); } catch {} }, 55000);
    proc.on('close', () => {
      clearTimeout(timer);
      try {
        if (fs.existsSync(tmpFile)) {
          const reply = fs.readFileSync(tmpFile, 'utf8').trim();
          try { fs.unlinkSync(tmpFile); } catch {}
          return resolve(reply || '（codex 無回應）');
        }
        resolve(`⚠️ codex exit 無輸出\n${err.slice(0,300)}`);
      } catch (e) { resolve(`讀取錯誤：${e.message}`); }
    });
    proc.on('error', e => {
      clearTimeout(timer);
      resolve(`codex 啟動失敗：${e.message}`);
    });
  });
}
```

### 5-4-4. 在 askHermes 裡接入

找到 `async function askHermes(...)` 內部，`history.push({ role: 'user', ... })` 之後、呼叫 OpenAI API 之前，插入：

```javascript
  if (USE_CODEX) {
    const prompt = history.map(m =>
      (m.role === 'user' ? '使用者' : '助理') + '：' + m.content
    ).join('\n') + '\n助理：';
    const reply = await askViaCodex(prompt);
    history.push({ role: 'assistant', content: reply });
    if (history.length > MAX_HISTORY * 2) history.splice(0, 2);
    return reply;
  }
```

存檔。

---

## 5-5. 修改 `bridge/.env` 開啟 Codex

```env
# 加到 .env 最上方
USE_CODEX=true
CODEX_MODEL=gpt-5.4
```

其他 Gemini 設定**先保留**（當 codex 有問題時可回 fallback）。

---

## 5-6. 重啟 Bridge 並測試

```powershell
# 回到跑 bridge 的 PowerShell，按 Ctrl+C 停掉
# 然後重新啟動：
node line-bridge.js
```

再測：

```powershell
Invoke-RestMethod 'http://localhost:3000/test?msg=你用什麼模型？'
```

應該回類似：
```
我是 Codex，基於 GPT-5 的編碼代理模型。
```

**看到回答提到 GPT-5 → Codex 訂閱模式已生效！**

---

## 5-7. ⚠️ Windows 常見踩坑

### 坑 1：`spawn codex.cmd ENOENT`

**原因**：Windows 上 npm 裝的 codex 是 `codex.ps1`，沒有 `.cmd`。
**修**：我們的 code 已經用 `node + codex.js 絕對路徑` 解決了。

### 坑 2：`Permission denied` 或 sandbox 擋外網

**修**：我們加的 `--dangerously-bypass-approvals-and-sandbox` 已經解鎖，能寫檔連外網。

### 坑 3：回覆變慢（3-5 秒變 10+ 秒）

**原因**：對話歷史過長，每次都要 codex 重新讀。
**修**：傳 `/clear` 清除記憶（Step 6 實作後才有這指令）。

---

## 5-8. 成本確認

- **ChatGPT Plus 月費**：USD 20/月（約 NTD 600）
- **LINE Bot 一天 100 則訊息的消耗**：約佔訂閱額度的 1-2%
- **結論**：一個月基本上用不完

---

## 🎉 Step 5 完成！

你的 LINE Bot 現在吃 ChatGPT Plus 訂閱，聰明的 gpt-5.4 模型，不另付 API 費。

**下一步：Step 6「進階功能」** — 加記憶持久化、副人格、自拍生圖。
