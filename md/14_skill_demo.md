# 🎨 SKILL 安裝教學示範

## 為什麼挑這 3 個 SKILL？

上一節講的是 Skill 的觀念。
這一節直接做給你看：拿到一個 Skill 包、放進 HermesAgent、開始用。

挑 3 個 **生圖類 SKILL** 來示範，順序刻意安排成 **免費→付費**、**新手最容易→進階改寫**：

1. 第一個 `algorithmic-art`：**完全免費**，不用任何 API key
2. 第二個 `ai-media-generator`：**付費但便宜**，阿亮老師親寫，台灣使用者最常用
3. 第三個 `imagegen`：**進階**，原本是給 Claude Code 用的，搬到 HermesAgent 要小改

跟完這 3 個示範，你就會：

1. 知道 SKILL 怎麼放、放在哪個資料夾
2. 知道 Hermes 跟 Claude 的 SKILL 有什麼差別
3. 知道遇到 Claude 限定的 SKILL 要怎麼自己改成 Hermes 能用

---

## 共通觀念 1：SKILL 要放在哪？

愛馬仕龍蝦（HermesAgent）的技能資料夾統一在這裡：

```text
%USERPROFILE%\.hermes\skills\
```

PowerShell 一行打開：

```powershell
explorer "$env:USERPROFILE\.hermes\skills"
```

把下面三個 ZIP 任何一個解壓縮後，**整個資料夾**（含 `SKILL.md`）丟進去就好。
解開 `algorithmic-art.zip` 之後你會得到一個 `algorithmic-art\` 資料夾，整個丟進去後路徑長這樣：

```text
C:\Users\你的名字\.hermes\skills\algorithmic-art\
  ├── SKILL.md           ← 必備：技能說明檔
  ├── (其他附屬檔案)
  └── ...
```

為什麼路徑這麼重要？
因為 Hermes 啟動時會掃這個資料夾抓 SKILL。
放錯位置（例如放在 `%LOCALAPPDATA%\hermes\` 下）會被當作基礎設施目錄忽略掉。

> [!WARNING]
> **不是 `%LOCALAPPDATA%\hermes\`**！
> 那個是程式本體與 Python venv 所在，重灌會被清掉。
> 技能要放 `%USERPROFILE%\.hermes\skills\`，這個資料夾在重灌時會保留。

---

## 共通觀念 2：裝完要重新啟動才會生效

複製進去之後，跑這一行讓 Hermes 重新掃技能：

```powershell
hermes gateway restart
```

或乾脆執行健診：

```powershell
hermes doctor
```

`hermes doctor` 會列出目前掃到哪些 SKILL，如果你新放的技能名字有出現，就代表掛上去了。

---

## 共通觀念 3：Claude 的 SKILL 不一定能直接搬到 Hermes

這 3 個示範 SKILL 原本是寫給 Claude Code（Anthropic 的官方 CLI）用的。
Hermes 跟 Claude 共用 `SKILL.md` 格式，**大多數情況都能直接搬**，但有兩個眉角要小心：

1. **某些 SKILL 預設用 Claude 內建工具**（例如 `image_gen`、`view_image`），Hermes 沒這些工具，要走 SKILL 內提供的「CLI fallback 模式」（通常是呼叫一支 Python 或 Bash 腳本）。
2. **某些 SKILL 假設 Linux 環境**（用 bash、espeak、systemd），Hermes 在 Windows 上要用對應的替代品（Git Bash、Windows SAPI、schtasks）。

下面 3 個示範會逐一告訴你哪些要改、改在哪。

---

## 第 1 個：algorithmic-art（演算法藝術）

### 是什麼

`algorithmic-art` 是一個讓 AI **用程式碼**畫圖的 SKILL。
不是去呼叫雲端模型生圖，而是用 `p5.js` 寫一支會跑動畫的演算法，產出像「流場藝術」「粒子系統」「碎形」「噪聲圖案」這類**生成式藝術作品**。

成果可以直接在瀏覽器互動：拖滑桿改參數、按按鈕換種子、即時看演算法跑出新的構圖。

### 功能與特色

1. `完全免費` — 不需要任何 API key、不打雲端、不會產生費用
2. `離線可用` — 解壓後就能用，斷網也照跑
3. `輸出可玩` — 產生 `.html` + `.js`，瀏覽器打開就是互動藝術
4. `風格多元` — 內建 50+ 種演算法哲學（流場、量子諧波、自然湍流、有機混沌…）
5. `教學意義高` — 學員可以順便看 AI 寫的 p5.js 程式怎麼運作

### Hermes 適切性

> [!TIP]
> **完全可用，無需任何修改。**

這個 SKILL 不依賴 Claude 任何內建工具，只是教 AI「寫一支 p5.js 程式」。
Hermes 用什麼主 LLM 都行（OpenAI、Gemini、Claude、Ollama 都可以）。

### 下載

⬇️ **[algorithmic-art.zip](installers/skills/algorithmic-art.zip)**

ZIP 約 3 MB（含 54 種字體與 77 份哲學定義檔）。

### 安裝 4 步驟

1. 點上方連結下載 `algorithmic-art.zip`
2. 解壓縮，會得到 `algorithmic-art\` 資料夾
3. 整個資料夾丟進 `%USERPROFILE%\.hermes\skills\`
4. `hermes gateway restart`

### 試試看

對 Hermes 說：

```text
用 algorithmic-art 技能，畫一張「流場藝術」風格的動態作品給我，
配色用龍蝦橙紅。
```

Hermes 會：
1. 讀取 SKILL.md 知道步驟
2. 寫一段 p5.js 演算法
3. 產出 `.html` + `.js` 給你
4. 你瀏覽器打開就能看動畫

---

## 第 2 個：ai-media-generator（FAL.AI 多媒體生成器）

### 是什麼

`ai-media-generator` 是**阿亮老師親自寫的** SKILL，整合 [FAL.AI](https://fal.ai) 平台上的多個生圖／生影片模型。
特色是 **按量計費、無月費**——畫多少付多少，最便宜的模型一張圖 $0.003 美元（約台幣 0.1 元）。

### 功能與特色

#### 生圖

| 模型 | 用途 | 價格 |
|:---|:---|:---:|
| FLUX.1 Dev | 通用、高品質（推薦） | ~$0.025/張 |
| FLUX.1 Pro | 最高品質 | ~$0.05/張 |
| FLUX.1 Schnell | 快速草稿、最便宜 | ~$0.003/張 |
| Ideogram V3 | 文字渲染強 | $0.03~0.09/張 |
| Recraft V3 | 設計風格 | ~$0.04/張 |

#### 生影片

| 模型 | 特色 | 價格 |
|:---|:---|:---:|
| Kling V2.1 | 人臉表情最強 | ~$0.07/秒 |
| Hailuo 2.3 | 電影感 | ~$0.28/6 秒 |
| FAL Seedance 2.0 | 原生音頻、多鏡頭、鏡頭控制 | ~$0.30/秒 |

#### 其他

1. `image-to-video` 圖轉影片
2. `Gemini Vision` 免費讀圖／OCR（用既有 Gemini API key）
3. 全部用 `curl` 同步呼叫，**不需 Python 套件**

### Hermes 適切性

> [!TIP]
> **完全可用，無需修改。**

整個 SKILL 都是 `curl` HTTP API 呼叫，跟主 LLM 完全解耦。
Hermes 在 Windows 上用內建便攜 Git Bash 跑 `curl`，完全沒問題。

### 環境設定（重要）

要先到 [fal.ai/dashboard/keys](https://fal.ai/dashboard/keys) 申請 `FAL_KEY`（要綁信用卡，但會送 $10 美元試用額度）。

設環境變數：

```powershell
[System.Environment]::SetEnvironmentVariable('FAL_KEY', '你申請到的 key', 'User')
```

設好後**關掉所有 PowerShell 重開**讓變數生效。

### 下載

⬇️ **[ai-media-generator.zip](installers/skills/ai-media-generator.zip)**

ZIP 約 14 KB（純 Markdown 文件 + 1 支 Python 腳本）。

### 安裝 4 步驟

1. 申請 FAL.AI 帳號並設好 `FAL_KEY` 環境變數
2. 下載 `ai-media-generator.zip` 解壓縮
3. 整個 `ai-media-generator\` 資料夾丟進 `%USERPROFILE%\.hermes\skills\`
4. `hermes gateway restart`

### 試試看

對 Hermes 說：

```text
用 ai-media-generator 技能，
用 FLUX.1 Schnell 模型畫一張「在台北 101 旁邊喝珍珠奶茶的紅色龍蝦」，
1:1 正方形，存成 lobster-bubble-tea.jpg。
```

Hermes 會：
1. 看 SKILL.md 知道怎麼組 `curl` 指令
2. 呼叫 `https://fal.run/fal-ai/flux/schnell`
3. 拿到回傳的圖片網址
4. `curl -o` 下載到本機
5. 給你一張 1024×1024 的圖（這張花你 $0.003 美元）

### 進階：生影片

對 Hermes 說：

```text
用 FAL Seedance 2.0 標準 720p，做一個 5 秒鐘的影片，
場景是「夕陽下的海邊，海浪輕拍沙灘，遠處有一艘小船」，
要原生音頻。
```

費用約 $1.50 美元（720p ~$0.30/秒 × 5 秒）。

---

## 第 3 個：imagegen（Claude → Hermes 轉換示範）

### 是什麼

`imagegen` 是 Anthropic / Codex 官方推的生圖 SKILL，**原本給 Claude Code 用**。
特色是「**寫得很正式很結構化**」——把 prompt 分類成 photorealistic / product-mockup / ui-mockup 等 8 大用途，內建專業 prompt 模板。

如果你要的是「**用 AI 模型畫商業可用、品質高的圖**」，這個 SKILL 的提示詞工程做得很好。

### 功能與特色

1. `prompt 結構化` — 內建 8 種 use-case 分類（photorealistic / logo-brand / illustration-story 等）
2. `編輯模式` — 不只生新圖，還能改既有圖（背景去除、物件替換、光線氛圍轉換）
3. `批次生成` — 一個 prompt 出多張變體
4. `重輸入策略` — 處理「保留人物臉孔、改背景」這種精確需求
5. `Codex 原廠正規寫法` — 適合學員看怎麼寫專業的 SKILL.md

### Hermes 適切性

> [!WARNING]
> **部分可用，需小改。**

原版 `imagegen` 預設模式是用 **Claude Code 內建的 `image_gen` 工具**——這個工具 Hermes **沒有**。

好消息：原 SKILL 內附 `scripts/image_gen.py`（CLI fallback 模式），這支腳本 Hermes 可以直接跑。
壞消息：CLI fallback 模式要 `OPENAI_API_KEY`（OpenAI 的圖像 API，比 FAL.AI 貴一點）。

### 兩種改寫方式（任選）

#### 方式 A（簡單）：用既有 SKILL，講話時明確指定 CLI 模式

對 Hermes 講話時加一句：

```text
用 imagegen 技能（CLI fallback 模式，因為我是 Hermes 不是 Claude），
畫一張高解析的台灣阿里山日出。
```

Hermes 看到指示後就會跳過 built-in 工具，直接跑 `scripts/image_gen.py`。

#### 方式 B（一勞永逸）：改 SKILL.md 把預設模式翻過來

打開 `%USERPROFILE%\.hermes\skills\imagegen\SKILL.md`，找到這段：

```text
- Use the built-in `image_gen` tool by default for all normal image generation and editing requests.
- Never switch to CLI fallback automatically.
```

改成：

```text
- Hermes environment: ALWAYS use the CLI fallback (`scripts/image_gen.py`) since the built-in `image_gen` tool is Claude-only.
- Set OPENAI_API_KEY environment variable before use.
```

之後就不用每次提醒 Hermes 走 CLI 模式。

### 環境設定（重要）

要先到 [platform.openai.com/api-keys](https://platform.openai.com/api-keys) 申請 OpenAI API key。

設環境變數：

```powershell
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'sk-...你的key', 'User')
```

> [!TIP]
> **省錢提示**：如果只要做圖，OpenAI 的 `gpt-image-1` 比 FAL.AI 貴；但如果你已經有 ChatGPT Plus 訂閱、想拿訂閱額度生圖，這條路才划算。新手建議直接用第 2 個 `ai-media-generator` 比較省。

### 下載

⬇️ **[imagegen.zip](installers/skills/imagegen.zip)**

ZIP 約 31 KB（含 6 份 Markdown 文件 + 1 支 Python CLI）。

### 安裝 5 步驟

1. 申請 OpenAI API key 並設好 `OPENAI_API_KEY` 環境變數
2. 下載 `imagegen.zip` 解壓縮
3. 整個 `imagegen\` 資料夾丟進 `%USERPROFILE%\.hermes\skills\`
4. **建議：用方式 B 改 SKILL.md** 把預設模式翻過來
5. `hermes gateway restart`

### 試試看

對 Hermes 說：

```text
用 imagegen 技能（CLI fallback 模式），
畫一張「photorealistic-natural」風格的圖：
一隻紅色龍蝦坐在台北 101 觀景台上看夕陽，
背景台北市景燈火通明，光線溫暖柔和。
```

Hermes 會：
1. 從 SKILL.md 找到 CLI 用法
2. 跑 `python scripts/image_gen.py generate ...`
3. 透過 OpenAI API 產圖
4. 存到本機指定路徑

---

## 三個 SKILL 一張表看完

| 比較項 | algorithmic-art | ai-media-generator | imagegen |
|:---|:---:|:---:|:---:|
| **費用** | 免費 | 按量付費（便宜）| 按量付費（中等）|
| **要 API key？** | 不用 | 要 `FAL_KEY` | 要 `OPENAI_API_KEY` |
| **Hermes 適切性** | ✅ 直接可用 | ✅ 直接可用 | ⚠️ 要小改 |
| **作者** | Anthropic 官方 | 阿亮老師 | OpenAI / Codex 官方 |
| **產出類型** | 演算法藝術（HTML+JS）| 真實圖片／影片 | 真實圖片 |
| **適合對象** | 學程式藝術、做封面 | 一般生圖、做素材、影片 | 商業級高品質、企業用途 |
| **建議學員學習順序** | 1（最容易）| 2（最常用）| 3（最進階）|

---

## 學員常見問題

### Q1. 三個 SKILL 可以同時裝嗎？

可以，**三個都裝**也不會衝突。Hermes 會根據你下指令時用的關鍵字決定該調哪個。

### Q2. 我家小孩沒信用卡，只能用免費的，要選哪個？

只用 `algorithmic-art`。它完全離線，產出是會動的程式藝術，很適合給孩子當入門。

### Q3. 我已經有 ChatGPT Plus 訂閱，為什麼還要付 OpenAI API 錢？

ChatGPT Plus 是「網頁版聊天額度」，**不含 API 額度**。要用 API 就要另外綁信用卡儲值。
這也是為什麼 Hermes 上推薦先用 `ai-media-generator`（FAL.AI 比 OpenAI 便宜）。

### Q4. 為什麼 imagegen 在 Hermes 上要改？Claude Code 上不用改嗎？

是的。`imagegen` 預設用 Claude Code 的 **內建** `image_gen` 工具——Claude Code 才有這個工具。Hermes 沒有，所以要走 SKILL 自帶的 CLI fallback 模式（呼叫 Python 腳本）。

這個觀念以後遇到其他 Claude SKILL 都用得到：

1. 先看 SKILL.md 有沒有提到 `built-in tool` 或 `Claude tool`
2. 如果有，找有沒有 CLI / Python / Bash 的 fallback
3. 如果沒有 fallback，這個 SKILL 就**無法在 Hermes 上直接用**，要自己重寫

### Q5. 我以後從別的地方下載 SKILL 要怎麼判斷能不能用？

跟著本頁第 3 個 `imagegen` 的判斷邏輯走：

1. 解開 ZIP，先看 `SKILL.md`
2. 找 "tool"、"built-in"、"Claude-specific"、"requires" 等關鍵字
3. 看附屬目錄有沒有 `scripts/` 資料夾（通常裡面就是 CLI fallback）
4. 看 `pyproject.toml`、`package.json` 確認需要哪些套件

---

> [!NOTE]
> 看完三個 SKILL 示範你會發現：SKILL 並不神秘，就是「**一份說明 + 幾支腳本**」。
> 以後在 ClawHub、GitHub 看到別人寫的 SKILL，按本頁邏輯判斷一下，能搬就搬，要改就改。
