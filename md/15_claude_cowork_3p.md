# 🔶 Claude Cowork × 第三方 API／本地 LLM

> **Claude Desktop 桌面版**近期悄悄加入「Cowork on Third-Party Platforms」功能，可以改用 **OpenRouter / Ollama / LiteLLM** 等第三方推論服務，**免費版用戶**也能用。
> 對老是碰到 Anthropic 用量上限、想把次要任務丟給本地 LLM 的人，這是一條全新捷徑。

---

## 這個功能跟 Hermes 有什麼關係？

| 你目前的狀況 | 推薦做法 |
|--------------|---------|
| 已經有 Claude Pro / Max 訂閱，但常碰上限 | **保留訂閱**，把次要任務切到 Cowork 3P 走免費 / 本地 LLM |
| 只有 Claude 免費版 | **這是免費 Cowork 的唯一解法**——免費版直接走第三方 API，等於繞過官方上限 |
| 沒用 Claude Desktop，只用 Hermes Agent | **不需要這個功能**，Hermes 自己已經支援多 Provider 切換 |
| 同時用 Claude Desktop + Hermes | **可以**，兩個 App 各自走各自的 LLM 設定，不衝突 |

> [!TIP]
> 第三方 API 多一層呼叫，**速度會比直連 Claude 慢**，請有心理準備。但能省錢 / 無上限的甜頭非常值得。

---

## Step 1：開啟開發者模式

Cowork 3P 預設藏在開發者選單裡，要先解鎖。

### macOS

1. 打開 **Claude Desktop**
2. 螢幕最上方選單列：**Help → Troubleshooting**
3. 點 **Enable Developer Mode**

### Windows

1. 打開 **Claude Desktop**
2. 視窗左上角的 **☰**（漢堡選單）
3. **Help → Troubleshooting → Enable Developer Mode**

啟用後，最上方選單會多一個 **Developer** 選單。

---

## Step 2：開啟設定視窗

點 **Developer → Configure third-party inference**，跳出設定視窗。

左側欄有四種 Connection Provider：

| Provider | 適合對象 |
|----------|---------|
| **Gateway** | 多數人選這個（Ollama、OpenRouter、LiteLLM、自架 Proxy）|
| Bedrock | AWS Bedrock 企業客戶 |
| Vertex | Google Cloud Vertex AI 企業客戶 |
| Foundry | Microsoft Azure AI Foundry 企業客戶 |

**一般人都是選 Gateway。**

填兩個必填欄位：

| 欄位 | 說明 |
|------|------|
| **Gateway base URL**（必填）| 推論端點完整 URL，**一定要 `https://` 開頭** |
| **Gateway API key**（必填）| API 金鑰；本地 Gateway 不驗證的話隨便填一個字串也行 |
| Gateway auth scheme | 預設 `bearer` 就好 |
| Gateway extra headers | 通常用不到 |

---

## 路線 A：串 OpenRouter（最簡單）

OpenRouter 的端點本身就是 HTTPS，**不必架反向代理**。

### A-1：拿 OpenRouter Key

1. 到 [openrouter.ai](https://openrouter.ai) 註冊
2. **Keys** 頁面 → **Create Key** → 複製（格式 `sk-or-v1-...`）
3. 免費模型不必綁信用卡，付費模型才需要儲值

### A-2：在 Claude Desktop 填這些

| 欄位 | 值 |
|------|---|
| Gateway base URL | `https://openrouter.ai/api` |
| Gateway API key | `sk-or-v1-你的Key` |
| Gateway auth scheme | `bearer`（預設）|

按 **Apply locally** → Claude 自動重啟 → 啟動畫面選 **Continue with Gateway**。

### A-3（選用）：指定模型，避免清單太多

OpenRouter 有 200+ 模型，預設會全列出來。想只看自己愛用的幾個，要手動改設定檔。**設定檔位置**：

- macOS：`~/Library/Application Support/Claude-3p/claude_desktop_config.json`
- Windows：`%APPDATA%\Claude-3p\claude_desktop_config.json`

可以打開檔案直接編輯 `enterpriseConfig.inferenceModels`，例如只留兩個免費模型：

```json
{
  "enterpriseConfig": {
    "inferenceModels": [
      "nvidia/nemotron-3-super-120b-a12b:free",
      "google/gemma-4-26b-a4b-it:free"
    ]
  }
}
```

存檔後重啟 Claude Desktop，模型清單就只剩這兩個。

> [!NOTE]
> 免費模型有速率限制，高峰時段可能被排隊或限流。要穩定快速建議用付費模型，OpenRouter 不抽成（直連價）。

---

## 路線 B：串本地 Ollama（完全免費 + 離線）

### B-1：問題 — Ollama 預設沒 HTTPS

Claude Cowork 3P **強制要求 `https://` 端點**，但 Ollama 預設只開 HTTP（`http://localhost:11434`）。

**解法**：在 Ollama 前面加一層 HTTPS 反向代理。最省事的工具是 [Caddy](https://caddyserver.com)，會自動處理自簽憑證。

### B-2：安裝 Caddy 並啟動反向代理

**macOS**：

```bash
brew install caddy
caddy reverse-proxy --from localhost:8443 --to localhost:11434
```

**Windows（PowerShell）**：

```powershell
winget install CaddyServer.Caddy
caddy reverse-proxy --from localhost:8443 --to localhost:11434
```

啟動時會跳出視窗要求輸入系統密碼（安裝自簽憑證用）。輸入後，Ollama 的 HTTPS 端點就變成 `https://localhost:8443`。

> [!TIP]
> Caddy 視窗**不可以關掉**，反向代理才會持續運作。把它丟背景或開機自動啟動。

### B-3：Claude Desktop 設定

| 欄位 | 值 |
|------|---|
| Gateway base URL | `https://localhost:8443` |
| Gateway API key | `ollama`（隨便填，Ollama 不驗證）|
| Gateway auth scheme | `bearer` |

按 **Apply locally** 重啟 Claude。模型清單會自動讀 Ollama 已安裝的所有模型。

### B-4：本地模型太慢怎麼辦？

若本地電腦規格不夠（沒有獨顯、RAM < 16GB），本地模型會非常慢。可以改用 **Ollama 雲端模型**（網頁註冊後可拿免費額度，速度快很多），設定方式跟本地相同，差別是雲端模型清單。

---

## 路線 C：串 LiteLLM Gateway（進階）

如果你已經自架 [LiteLLM](https://github.com/BerriAI/litellm) 或 Portkey 統一閘道，把多個 LLM 廠商打包成單一 API，**直接填 Gateway URL 即可**。

| 欄位 | 值 |
|------|---|
| Gateway base URL | `https://你的LiteLLM網域` |
| Gateway API key | 你在 LiteLLM 設的 key |
| Gateway auth scheme | `bearer` 或 `x-api-key`（依 LiteLLM 設定） |

要求：LiteLLM 必須實作 **Anthropic Messages API**——
- `POST /v1/messages`（必須，支援 streaming + tool use）
- `GET /v1/models`（可選，有的話 Cowork 會自動列模型清單）

---

## Step 3：驗證設定有沒有套到

設定完按下 **Apply locally** 後，Claude Desktop **會自動重啟**。重啟後的啟動畫面會多出一個選項：

```
Continue with Gateway
```

點下去，就會用你剛設定的第三方 API 開始對話。

### 確認當前用的是 Cowork 3P

進入主畫面後，**Help → Troubleshooting → Copy Managed Configuration Report**，會把當前生效的設定複製到剪貼簿，貼到記事本看一下：

- `inferenceProvider` 應該是 `gateway`
- `inferenceGatewayBaseUrl` 應該是你填的 URL
- 金鑰會自動遮罩（顯示 `***`），不會洩漏

---

## 常見問題

### Q1：套用後 Claude 開啟還是要求登入 Anthropic 帳號？

代表設定沒生效。檢查：
- `inferenceProvider` 拼字、大小寫
- Claude Desktop 有沒有**完全關閉再開**（不是只關視窗）
- 設定檔有沒有寫到對的位置（local vs managed）

### Q2：本地 Ollama 連線超時？

- Caddy 視窗有沒有關掉？反向代理停了就連不上
- `https://localhost:8443` 改成 `https://127.0.0.1:8443` 試試
- 防火牆有沒有擋 port 8443

### Q3：免費版 Claude 真的能用？

可以。Cowork 3P 是 Claude Desktop 的功能，**不依賴 Anthropic 帳號的訂閱層級**——只要你在啟動畫面選 Gateway 模式，整個 App 就走你的第三方 API，跟 Anthropic 帳號完全脫鉤。

### Q4：對話資料還會傳到 Anthropic 嗎？

走 Gateway 模式時，**對話資料只會送到你設的 Gateway 端點**。資料怎麼處理由你的 Gateway 與下游 Provider 決定（OpenRouter / Ollama / LiteLLM 各自的隱私政策）。

> [!WARNING]
> Anthropic 官方文件明確標示：
> 「Vertex AI 和 Bedrock 走 Anthropic 不留資料的承諾**只適用那兩個 Provider**。Gateway 模式由你自己負責資料處理。」

---

## 跟 Hermes Agent 並用的最佳組合

| 任務類型 | 推薦工具 | 推薦 LLM |
|---------|---------|---------|
| 主要編程（複雜任務） | Claude Desktop（Cowork 原生 / 3P） | Claude Sonnet 4.6 / Opus |
| 副 task、外場跑 | Claude Cowork 3P | Gemma 4 / Llama 3.3 70B 免費 |
| 自動化、排程、整合外部 API | Hermes Agent | 視任務複雜度選 |
| 簡單對話、問答、文書 | Hermes Agent + Ollama 本地 | 完全免費離線 |

把兩個 App 角色分清楚，Token 預算可以省非常多。

---

## 延伸閱讀

- Anthropic 官方文件：[Install and configure Claude Cowork with third-party platforms](https://docs.claude.com/cowork/3p/installation)
- LLM Gateway 設定細節：[Using Cowork on 3P with an LLM Gateway](https://docs.claude.com/cowork/3p/gateway)
- 本站「🦙 Ollama 免費方案完整教學」——學會裝 Ollama 才能跑路線 B
- 本站「🪐 Google Antigravity」——拿免費 Gemini Key 串到 OpenRouter 路線
