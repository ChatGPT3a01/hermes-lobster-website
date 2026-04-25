# 常用指令參考

## HermesAgent 指令總覽

### Gateway 管理

| 指令 | 說明 | 平台 |
|------|------|------|
| `hermes gateway run` | 前景啟動 Gateway（可看日誌）| Windows（推薦）|
| `hermes gateway start` | 背景啟動 Gateway | Mac / Linux |
| `hermes gateway &` | 背景啟動（bash 語法）| Mac / Linux |
| `hermes gateway stop` | 停止 Gateway | 所有 |
| `hermes gateway status` | 查看 Gateway 狀態 | 所有 |
| `hermes gateway restart` | 重啟 Gateway | 所有 |
| `hermes gateway setup` | 設定傳訊平台（首次）| 所有 |

> [!WARNING]
> **重啟 Gateway 注意**：在 Hermes 對話介面中重啟時，請告訴 AI 使用「**Restart**」指令，**不要說 Stop 再 Start**——Gateway 關掉後就無法自動重啟了！

### 診斷與維護

| 指令 | 說明 |
|------|------|
| `hermes doctor` | 診斷環境設定 |
| `hermes --version` | 查看版本號 |
| `hermes update` | 更新到最新版本 |
| `hermes chat` | 終端機直接對話模式 |

### 設定管理

| 指令 | 說明 |
|------|------|
| `hermes config show` | 顯示目前設定 |
| `hermes config set KEY VALUE` | 設定某個設定值 |
| `hermes config get KEY` | 取得某個設定值 |
| `hermes onboard` | 重新執行初始化精靈 |

### 技能管理

| 指令 | 說明 |
|------|------|
| `hermes skills list` | 列出已安裝技能 |
| `hermes skills install <name>` | 安裝技能 |
| `hermes skills remove <name>` | 移除技能 |

---

## 常用設定項目

| 設定 Key | 說明 | 範例值 |
|---------|------|-------|
| `TELEGRAM_BOT_TOKEN` | Telegram Bot Token | `1234567890:ABC...` |
| `TELEGRAM_ALLOWED_USERS` | 允許的 Telegram User ID | `987654321` |
| `API_SERVER_PORT` | Gateway 監聽 Port | `8642` |
| `LLM_PROVIDER` | AI 大腦提供商 | `anthropic` |

---

## API 直接呼叫

HermesAgent Gateway 提供 OpenAI 相容 API，可以用任何支援 OpenAI API 的工具直接呼叫：

### 基本資訊

```
Base URL：http://localhost:8642/v1
API Key：change-me-local-dev（預設）
Model：hermes
```

### 使用 curl 測試

```bash
curl http://localhost:8642/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer change-me-local-dev" \
  -d '{
    "model": "hermes",
    "messages": [{"role": "user", "content": "你好！"}]
  }'
```

### Python 呼叫範例

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8642/v1",
    api_key="change-me-local-dev"
)

response = client.chat.completions.create(
    model="hermes",
    messages=[{"role": "user", "content": "你好！"}]
)

print(response.choices[0].message.content)
```

### JavaScript / Node.js 呼叫範例

```javascript
const { OpenAI } = require('openai');

const hermes = new OpenAI({
  baseURL: 'http://localhost:8642/v1',
  apiKey: 'change-me-local-dev',
});

const response = await hermes.chat.completions.create({
  model: 'hermes',
  messages: [{ role: 'user', content: '你好！' }],
});

console.log(response.choices[0].message.content);
```

---

## LINE Bridge 操作

```bash
# 進入 bridge 目錄
cd bridge

# 安裝相依套件（首次）
npm install

# 啟動 LINE Bridge
npm start

# 測試 API 連線
# 瀏覽器開啟：
http://localhost:3000/test?msg=你好

# 查看服務狀態
http://localhost:3000/
```

---

## ngrok 操作

```bash
# 啟動 LINE Bridge 隧道
ngrok http 3000

# 啟動 HermesAgent Gateway 隧道（Telegram Webhook 模式）
ngrok http 8642

# 查看 ngrok 狀態
# 瀏覽器開啟：
http://localhost:4040
```

---

## Windows 安裝精靈選單

啟動 `go.bat` 後，精靈主選單：

| 選項 | 功能 |
|------|------|
| `1` | 全部安裝（新手推薦）|
| `2` | 僅安裝 HermesAgent |
| `3A` | 設定 Telegram |
| `3B` | 設定 LINE |
| `4` | 設定 ngrok |
| `5` | 安裝 LINE Bridge 套件 |
| `6` | 啟動所有服務 |
| `R` | 重啟 HermesAgent Gateway |
| `S` | 停止 HermesAgent Gateway |
| `N` | 啟動 ngrok |
| `D` | 執行 hermes doctor |
| `W` | 開啟 WSL2 終端機 |
| `Q` | 離開精靈 |

---

## 設定檔位置

| 平台 | 設定檔路徑 |
|------|-----------|
| Windows | `C:\Users\你的名字\.hermes\.env`（⚠️ 不是 LOCALAPPDATA！）|
| Mac / Linux | `~/.hermes/.env` |
| LINE Bridge | `bridge/.env` |

```powershell
# Windows 快速開啟 .env
notepad "$env:USERPROFILE\.hermes\.env"
```

---

## 常見診斷指令

```powershell
# Windows：完整診斷
hermes doctor

# 查看 Gateway 是否在執行
hermes gateway status

# 測試 API 連線
curl http://localhost:8642/v1/models

# 查看 LINE Bridge 狀態
curl http://localhost:3000/
```

---

> [!NOTE]
> 若遇到任何問題，第一步先執行 `hermes doctor`，它會告訴你哪個環節出了問題！
