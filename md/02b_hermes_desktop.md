# 🖥️ Hermes Desktop GUI（新手首選）

> **Hermes Desktop** 是 Hermes Agent 的官方圖形化桌面版伴侶 App。
> 不必開命令列、不必裝 WSL2、不必右鍵以系統管理員身分執行，雙擊安裝後一路按「下一步」就能完成設定。
> 這一頁是**完全沒接觸過終端機**的新手最推薦的入門路徑。

---

## 為什麼新手首選 Desktop？

| 比較項目 | 🖥️ Hermes Desktop（GUI） | ⚡ 一鍵安裝精靈（CLI） |
|----------|--------------------------|-----------------------|
| 安裝方式 | 雙擊 `.exe` / `.dmg` | PowerShell 跑指令 |
| 需要 WSL2 | ❌ 完全不需要 | ⚠️ 部分功能需要 |
| 看終端機嗎 | ❌ 全程 GUI | ✅ 黑視窗 + 文字介面 |
| 換 LLM 廠商 | 圖形化選單，點一下 | 改 `.env` 設定檔 |
| 切換個人檔案 | 點 Profile 下拉式選單 | 改資料夾 + 改設定 |
| 看記憶內容 | 點 Memory 頁籤 | 用編輯器開 MD 檔 |
| 排程任務 | Cron 表達式產生器 | 寫 schtasks / crontab |
| 第一次踩雷率 | 低 | 中（要看錯誤訊息） |
| 進階自動化 | 圖形化做不到的事仍要靠 CLI | ✅ 最完整 |
| 適合誰 | **零基礎、長輩、老師、教學示範** | 開發者、想深度客製、要寫腳本 |

> [!TIP]
> **建議的學習順序**：
> 1. 先裝 Desktop，把 Hermes「能做什麼」走過一遍
> 2. 玩熟之後，再依需要回頭看「一鍵安裝精靈」做深度客製
> Desktop 和 CLI **底層共用同一個 Hermes**（都是 `~/.hermes`），不會打架。

---

## 版本與下載

| 平台 | 安裝檔 | 大小／格式 |
|------|--------|-----------|
| 🪟 Windows 10/11 | `hermes-desktop-0.4.3-setup.exe` | NSIS 安裝程式 |
| 🍎 macOS（Apple Silicon, M1/M2/M3/M4）| `hermes-desktop-0.4.3-arm64.dmg` | DMG |
| 🍎 macOS（Intel）| `hermes-desktop-0.4.3-x64.dmg` | DMG |
| 🐧 Linux（任何發行版）| `hermes-desktop-0.4.3.AppImage` | AppImage |
| 🐧 Linux（Debian/Ubuntu）| `hermes-desktop_0.4.3_amd64.deb` | DEB |
| 🐧 Linux（Fedora/RHEL）| `hermes-desktop-0.4.3.rpm` | RPM |

**最新版本：v0.4.3（2026-05-15 發布）**
**下載頁面：https://github.com/fathah/hermes-desktop/releases**

> [!NOTE]
> Hermes Desktop 採 **MIT 授權**，原始碼公開：`github.com/fathah/hermes-desktop`。
> 它是 Nous Research 官方在 README 中認可的桌面版，不是非官方第三方。

---

## 🪟 Windows 安裝步驟

### Step 1：下載安裝檔

到 [Releases](https://github.com/fathah/hermes-desktop/releases) 抓最新的 `hermes-desktop-0.4.3-setup.exe`，存到 `下載` 資料夾。

### Step 2：跑安裝程式（處理 SmartScreen 警告）

雙擊 `setup.exe` 後，Windows 會跳出藍色警告：

```
Windows 已保護你的電腦
Microsoft Defender SmartScreen 已防止無法辨識的應用程式啟動。
```

這是因為 Hermes Desktop **沒有花錢買 Code Signing 憑證**（Electron 開源專案常態），不是真的有問題。

> [!WARNING]
> 解法：點藍色警告下方的 **「其他資訊」** → 接著會出現 **「仍要執行」** 按鈕 → 按下去。
> 安裝完成後，桌面會多一個 **Hermes Agent** 圖示。

### Step 3：首次啟動精靈

雙擊桌面圖示，會跳出歡迎畫面。一路 **Continue** 即可進入下一步「選擇模式」。

---

## 🍎 macOS 安裝步驟

### Step 1：選對 dmg

- M1／M2／M3／M4 晶片 → 抓 **arm64** 版（`hermes-desktop-0.4.3-arm64.dmg`）
- 舊款 Intel Mac → 抓 **x64** 版

### Step 2：拖進 Applications

打開 `.dmg`，把 **Hermes Agent.app** 拖到 Applications 資料夾。

### Step 3：解開 macOS 隔離（Gatekeeper）

App 沒有公證（notarization），第一次啟動 macOS 會擋。**開啟終端機**貼上：

```bash
xattr -cr "/Applications/Hermes Agent.app"
```

接著用 **滑鼠右鍵 → 開啟**，在跳出的對話框點「開啟」，這只要做一次。

---

## 🐧 Linux 安裝步驟

### AppImage（最簡單，任何發行版通用）

```bash
chmod +x hermes-desktop-0.4.3.AppImage
./hermes-desktop-0.4.3.AppImage
```

### Debian / Ubuntu

```bash
sudo dpkg -i hermes-desktop_0.4.3_amd64.deb
sudo apt-get install -f   # 補上缺失依賴
```

### Fedora / RHEL

```bash
sudo dnf install ./hermes-desktop-0.4.3.rpm
# 如果系統強制檢查 GPG 簽章而報錯：
sudo dnf install --nogpgcheck ./hermes-desktop-0.4.3.rpm
```

> [!NOTE]
> `.rpm` 版本目前**不支援自動更新**（electron-updater 限制），有新版要重新下載安裝。

---

## 首次啟動精靈：本地 vs 遠端模式

第一次打開 Hermes Desktop 會問你要怎麼跑：

### 🏠 本地模式（Local Mode）— 推薦新手

**選這個。** Desktop 會自動：

1. 檢查 `~/.hermes/` 有沒有裝過 Hermes Agent
2. 沒有的話，**自動跑官方安裝腳本**，依序處理 Git、uv、Python 3.11+ 依賴
3. 進度條會顯示安裝到哪一步
4. 完成後直接跳到 Provider 設定畫面

整個過程不用開終端機、不用打 `irm | iex`、不用調 PATH。

> [!WARNING]
> **Windows + WSL 使用者**：如果安裝卡在「Switching to root user to install dependencies...」，是 Playwright 在等 sudo 密碼但沒有 TTY 可以輸入。
> 暫時開放免密碼 sudo，裝完再關掉：
> ```bash
> echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/hermes-install
> # 重跑安裝精靈，完成後務必移除：
> sudo rm /etc/sudoers.d/hermes-install
> ```

### ☁️ 遠端模式（Remote Mode）— 進階

如果你已經有一台伺服器（VPS、家裡 Linux 主機）在跑 Hermes API，想用筆電當「遙控器」，選這個然後填：

- **Remote API URL**：`https://你的伺服器:8642`
- **API Key**：伺服器上設定的金鑰

桌面 App 變成純前端介面，所有運算在遠端機器跑。

---

## 設定 AI 大腦（Provider）

跳到 Provider 設定畫面後，新手最簡單的兩條路：

### 路線 A：OpenRouter（官方推薦，模型最多）

**OpenRouter 一把鑰匙吃下 200+ 模型**（Claude / GPT / Gemini / Qwen / DeepSeek 都在裡面）。

1. 到 [openrouter.ai](https://openrouter.ai) 註冊，去 **Keys** 頁面建立 API Key（`sk-or-v1-...`）
2. Desktop 選 **OpenRouter** → 貼上 Key → Next
3. 在模型清單挑你要的（推薦 `anthropic/claude-sonnet-4.6` 或 `google/gemini-3-flash-preview`）

**免費模型**：OpenRouter 有不少 `:free` 後綴的模型可選，不需綁卡。

### 路線 B：Google AI Studio Gemma 4（完全免費）

- 到 [aistudio.google.com](https://aistudio.google.com) 用 Google 帳號登入
- 左下 **Get API Key** → **Create API Key** → 取名「Free」
- 帳號**沒綁信用卡**就會顯示 `Free Tier`，額度用完只會冷卻幾小時，不會扣錢
- Desktop 選 **Google (Gemini)** → 貼上 Key → 模型挑 **Gemma 4 31B**

> [!TIP]
> Gemma 4 31B 是 Google 近期開源的模型，免費 Tier 額度充裕。但智力比 Claude / GPT 弱一些，純體驗夠用，要做進階任務建議升 OpenRouter。

### 路線 C：本地 Ollama / LM Studio（完全離線）

- 先在電腦裝好 [Ollama](https://ollama.com) 並下載模型（如 `ollama pull llama3.1`）
- Desktop 選 **Local / Custom** → 預設 base URL：`http://127.0.0.1:11434`
- 模型清單會自動讀 Ollama 已安裝的模型

> [!NOTE]
> 本地模型**速度與表現取決於電腦規格**。沒有 24GB+ 顯卡的話，預期會比雲端模型慢很多、智力也差一截。

---

## 主畫面 12 個面板

| 面板 | 中文 | 你能在這裡做什麼 |
|------|------|-----------------|
| **Chat** | 對話 | SSE 串流對話、工具進度條、Token 用量、即時成本 |
| **Sessions** | 工作階段 | 全文搜尋（SQLite FTS5）、按日期分組、恢復過去對話 |
| **Agents** | 個人檔案 | 切換不同 Hermes 環境，每個都有獨立設定 |
| **Skills** | 技能 | 瀏覽、安裝、管理 ClawHub / 自製 Skill |
| **Models** | 模型 | 跨 Provider 管理多組模型設定 |
| **Memory** | 記憶 | 檢視／編輯記憶條目、設定 Honcho / Mem0 / Supermemory |
| **Soul** | 人格 | 直接編輯 `SOUL.md`，調 Bot 個性 |
| **Tools** | 工具 | 開關 14 組工具集（網頁、瀏覽器、終端機、檔案、TTS…）|
| **Schedules** | 排程 | Cron 表達式產生器，按分／時／日／週 / 自訂 |
| **Gateway** | 通訊閘道 | 設定 16 種訊息平台（Telegram、Discord、LINE 走 webhook…）|
| **Office** | 辦公室 | Claw3d 視覺化 3D 介面 |
| **Settings** | 設定 | 備份／還原、log viewer、網路、佈景主題 |

---

## 22 個斜線指令速查

在 Chat 框輸入 `/` 會自動跳出選單。常用的幾個：

| 指令 | 用途 |
|------|------|
| `/new` | 開新對話 |
| `/clear` | 清空目前對話歷史 |
| `/fast` | 切到快速模式（成本壓低） |
| `/web` | 強制走網頁搜尋 |
| `/image` | 生圖 |
| `/browse` | 開啟瀏覽器控制 |
| `/code` | 進入程式碼模式 |
| `/shell` | 執行終端機指令 |
| `/usage` | 查看 Token 與成本 |
| `/help` | 列出所有指令 |
| `/tools` | 開關工具 |
| `/skills` | 列出已安裝 SKILL |
| `/model` | 切換模型 |
| `/memory` | 看／編輯記憶 |
| `/persona` | 編輯人格設定 |
| `/compact`、`/compress` | 壓縮上下文 |
| `/undo`、`/retry` | 復原／重試上一輪 |
| `/debug`、`/status` | 診斷 |

---

## 16 種訊息平台閘道

Desktop 在 **Gateway** 頁籤一鍵接通：

Telegram、Discord、Slack、WhatsApp、Signal、Matrix / Element、Mattermost、Email（IMAP/SMTP）、SMS（Twilio／Vonage）、iMessage（BlueBubbles）、釘釘、飛書 / Lark、企業微信、微信（iLink Bot）、Webhooks、Home Assistant。

> [!TIP]
> **LINE 沒在這個清單裡**——這就是為什麼阿亮老師另外寫了 **LINE Bridge**（Node.js + ngrok）來補。如果你需要 LINE，看左側「LINE 機器人設定」那一頁。

---

## 14 組工具集

Web 搜尋、瀏覽器控制、終端機、檔案操作、程式碼執行、視覺分析、圖片生成、TTS、Skills、Memory、Session 搜尋、Clarify、委派任務、MoA、Task planning。

每組都可以在 **Tools** 面板獨立開關，不想用某個工具直接關掉即可。

---

## 與 CLI 版本共存

Desktop 跟 CLI 版（`install-hermes.exe` / 一鍵安裝精靈）**用同一個 `~/.hermes` 資料夾**，所以：

- 你可以同時裝兩個，互不干擾
- CLI 模式裝過的 Skill，Desktop 打開就看得到
- Desktop 改的 `SOUL.md`，CLI 跑也吃得到

要把哪個當「日常使用」介面看個人喜好：

- **平常聊天、查資料、簡單任務** → Desktop 比較舒服
- **寫腳本自動化、深度整合、排程批次任務** → CLI 比較強

---

## 已知限制（v0.4.3）

| 平台 | 限制 |
|------|------|
| Windows | 安裝檔無程式碼簽章，SmartScreen 會跳警告（按「其他資訊→仍要執行」） |
| macOS | 未公證，第一次要 `xattr -cr` 解隔離 |
| Fedora `.rpm` | 不支援自動更新，要重新下載安裝新版 |
| Windows + WSL | 安裝卡 sudo TTY 問題，需暫時開 NOPASSWD |

這些都是 Electron 開源 App 的常見痛點，社群版本迭代中會逐步改善。

---

## 接下來要看哪一頁？

| 你的需求 | 看這一頁 |
|---------|---------|
| 想用 Desktop 接 LINE Bot | 「💚 LINE 機器人設定」（Desktop 內建沒 LINE，要走 Bridge）|
| 想接 Telegram 機器人 | 「✈️ Telegram 機器人設定」 |
| 想裝 Skill | 「🎨 SKILL 安裝教學示範」 |
| 想用免費 AI 大腦 | 「🪐 Google Antigravity」「🦙 Ollama 免費方案」 |
| 想從 OpenClaw 搬家過來 | 「🔄 從 OpenClaw 無痛轉移」 |
| 想要深度客製、寫腳本 | 「🪟 Windows 安裝教學」（一鍵安裝精靈 CLI 版） |
