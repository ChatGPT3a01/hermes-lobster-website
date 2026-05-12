# 🛠️ Step 1：手動安裝 HermesAgent 本體

> 預估時間：10 分鐘
> 目標：讓 PowerShell 可以執行 `hermes --version` 並回傳版本號

---

## 開場：為什麼選 Windows 原生路線

NousResearch 官方在 2026 年初已正式為 Windows 推出 **Native Beta** 支援，並寫了完整的 [Windows Native 文件](https://hermes-agent.nousresearch.com/docs/user-guide/windows-native)。本教學完全按官方文件走，不用 WSL2、不用 Docker。

**Windows 原生有什麼好？**

- ✅ Windows 上裝的 MCP 工具（如 Notion、Google Calendar、PowerShell 控制檯）**直接無痛調用**，不必再翻牆進 WSL
- ✅ 檔案路徑就是 `C:\Users\你\.hermes\`，記事本／檔案總管打開就能改
- ✅ 不必為一個 AI 開一座 Linux 虛擬機，少吃 4-8 GB RAM
- ✅ 阿亮老師實測：**Intel 6700 + RTX 3060 + 64 GB RAM 可同時養 3 隻 OpenClaw + 3 隻 Hermes**，沒卡

**Windows 原生的限制（先打預防針）：**

| 限制 | 影響 |
|------|------|
| 🔇 語音「聽」與「說」 | Hermes 的原生語音套件是 Linux 用的（espeak / piper），Windows 上要自己換成 Windows SAPI 或 PowerShell Speech |
| 📊 儀表板嵌入式終端 | 儀表板 Web UI 裡的「Terminal」分頁不能用（需要 POSIX PTY），但 Telegram/LINE/CLI 模式完全不受影響 |
| 🐚 部分 Skill 假設 Linux 環境 | 少數 Skill 內含 bash 腳本，Windows 上要用 Git Bash 跑（安裝器會自動裝便攜 Git Bash） |

> [!TIP]
> 上面這些限制 99% 用 LINE / Telegram 教學的場景**完全用不到**。要等到你想做語音 Bot 或想用儀表板裡的終端機，才會碰到。屆時請參考本章最後的「Windows 限制完整章節」。

**如果你真的想走 WSL2 官方路線（不推薦給新手）**：
1. PowerShell 跑 `wsl --install`（要重開機）
2. 進 Ubuntu 終端機跑：
   ```bash
   curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
   ```
3. 之後 Step 2-7 的概念相同，但路徑改成 Linux 格式（`~/.hermes/`）

---

## 1-0. 開工前 30 秒

**你只要有這個就能裝：**

- ✅ Windows 10/11 64-bit
- ✅ 穩定網路（要從 GitHub 抓 ~200 MB）
- ✅ 一個普通的 PowerShell 視窗（**不需要管理員權限**，這是官方安裝器的新設計）

**你不用先裝這些**（安裝器會自己處理）：

- ❌ 不用先裝 Python（安裝器用 uv 自動裝 3.11）
- ❌ 不用先裝 Node.js（安裝器自動裝 22）
- ❌ 不用先裝 Git（安裝器自動裝便攜版）

> [!NOTE]
> 如果你電腦**已經有** Node.js / Python / Git 也沒關係，安裝器會偵測並重用。不會重複裝。

按 <kbd>Win</kbd>+<kbd>R</kbd>，輸入 `powershell` 開啟 PowerShell。

---

## 1-1. 一行指令裝完 HermesAgent

把這一行整段複製、貼進 PowerShell、按 Enter：

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

> [!TIP]
> `irm` 是 `Invoke-RestMethod` 的短名，`iex` 是 `Invoke-Expression` 的短名。整句意思就是「從網址抓腳本→直接執行」。**這跟你 Google 搜「hermes-agent windows install」第一筆官方說法完全一樣**。

按下去之後會自動跑 3-10 分鐘，你不用做任何事。畫面大致長這樣：

```
┌─────────────────────────────────────────────────────────┐
│             ⚕ Hermes Agent Installer                    │
└─────────────────────────────────────────────────────────┘

→ Installing uv package manager...                  ✓
→ Installing Python 3.11 via uv...                  ✓
→ Installing Node.js 22...                          ✓
→ Installing portable Git...                        ✓
→ Cloning hermes-agent repository...                ✓
→ Creating Python virtual environment...            ✓
→ Installing dependencies (this may take a while)... ✓   ← 最久一步，2-5 分鐘
→ Installing messaging SDKs...                      ✓
→ Adding hermes to PATH...                          ✓
→ Running hermes setup wizard...

✓ Installation Complete!
```

最後會跳出 `hermes setup` 互動式精靈，要你選 AI 模型、選工具集等。**這裡你可以按 `Ctrl+C` 結束**，因為阿亮老師接下來 Step 5 會教你手動寫 `.env`，更彈性。

---

## 1-2. ⚠️ 一定要做：開新的 PowerShell

裝完之後，**關掉現在這個 PowerShell**，按 <kbd>Win</kbd>+<kbd>R</kbd> 重新開一個。

> [!WARNING]
> 為什麼要這樣？安裝器把 `hermes` 指令的路徑（`%LOCALAPPDATA%\hermes\bin`）加到使用者 PATH 環境變數裡，但「**正在開著的 PowerShell**」不會偵測到這個變化，所以一定要關掉、重開。

---

## 1-3. 驗證安裝成功

在**新開的** PowerShell 跑：

```powershell
hermes --version
```

預期看到類似這樣：

```
Hermes Agent v0.10.x
Python: 3.11.x
Project: C:\Users\你的名字\AppData\Local\hermes\hermes-agent
```

接著跑健診：

```powershell
hermes doctor
```

應該看到一堆 `✓` 綠色打勾。常見的 `⚠` 警告**可以先忽略**（多半是某些 optional skill 還沒設 API key）。

---

## 1-4. 認識「兩個資料夾」（重要觀念）

HermesAgent 把資料分散在**兩個位置**，搞混會在你重灌時哭出來：

| 資料夾 | 路徑 | 性質 | 內容 |
|--------|------|------|------|
| 🗑️ **基礎設施（可丟）** | `%LOCALAPPDATA%\hermes\` | 重灌會重建 | hermes-agent 程式碼、Python venv、Node modules、便攜 Git |
| 💾 **使用者資料（要備份）** | `%USERPROFILE%\.hermes\` | 重灌**會保留** | `.env` 設定、API 憑證、技能、對話記憶 |

**用 PowerShell 一行打開：**

```powershell
explorer "$env:LOCALAPPDATA\hermes"        # 基礎設施（可棄）
explorer "$env:USERPROFILE\.hermes"        # 使用者資料（持久）
```

> [!CAUTION]
> 想重新安裝？只要刪 `%LOCALAPPDATA%\hermes\` 即可，**`%USERPROFILE%\.hermes\` 千萬別刪**，否則 API Key、記憶、技能全沒。官方 `hermes uninstall` 指令也是這個邏輯。

---

## 1-5. Windows 與 Linux 的差異速覽

下面這份對照表是官方文件直接抄過來的。**先掃一眼即可**，等你之後真的踩到再回來看細節。

| 功能 | Windows 原生 | WSL2 | 備註 |
|------|:---:|:---:|------|
| CLI（`hermes chat`） | ✓ | ✓ | 完全一樣 |
| TUI 終端介面 | ✓ | ✓ | 完全一樣 |
| 訊息閘道（Telegram/Discord/LINE） | ✓ | ✓ | 完全一樣 |
| 排程器 / 工作排程 | ✓ | ✓ | Windows 用 schtasks，Linux 用 systemd |
| 瀏覽器自動化 | ✓ | ✓ | 完全一樣 |
| MCP 伺服器 | ✓ | ✓ | **Windows 原生 MCP 工具直接無痛調用** |
| Ollama / LM Studio 本機模型 | ✓ | ✓ | 完全一樣 |
| Web 儀表板（會話/作業/指標） | ✓ | ✓ | 完全一樣 |
| **儀表板嵌入式終端** | **✗** | ✓ | Windows 原生不支援（用其他模式取代） |
| **語音聽說（espeak/piper）** | **✗** | ✓ | 需自行改寫成 Windows SAPI（見下章） |
| 開機自動啟動 | ✓ | ✓ | Windows 用 schtasks |

→ 想看「語音改寫指引」？請看本教學最後的 **manual_99_troubleshoot.md → 附錄 C：Linux-only 功能 Windows 改寫指引**。

---

## 1-6. 進階：常用啟動指令

之後你會常用這些，先記在這裡，不用現在跑：

```powershell
# 啟動 CLI 對話
hermes chat

# 啟動互動式 TUI 介面
hermes --tui

# 啟動 / 停止 Gateway（訊息閘道）
hermes gateway start
hermes gateway stop
hermes gateway status
hermes gateway restart

# 設定登入時自動啟動 Gateway（用 Windows 排程工作）
hermes gateway install
```

---

## 🎉 Step 1 完成！

你現在有一個可運作的 HermesAgent 本體。**檢查清單**：

- [x] `hermes --version` 有版本號
- [x] `hermes doctor` 一堆綠色 ✓
- [x] `%USERPROFILE%\.hermes\` 資料夾存在
- [x] 知道兩個資料夾的差異

**下一步：[Step 2「申請 LINE Bot」](#manual-line)** — 取得 Channel Secret、Access Token 等 LINE 憑證。

---

## 📎 附錄：阿亮老師實測規格參考

學員常問：「我電腦跑得動嗎？」實測結論：

| 規格 | 阿亮老師主機 |
|------|----------|
| CPU | Intel Core i7-6700（**2015 年的老 U**） |
| GPU | NVIDIA RTX 3060（12 GB VRAM） |
| RAM | 64 GB |
| 同時跑 | **3 隻 OpenClaw + 3 隻 Hermes**，沒卡 |

> [!TIP]
> 結論：只要你電腦不比 i7-6700 更差，**16 GB RAM 起跳就能順順跑 1 隻 Hermes**。RAM 是關鍵，CPU 不用太新。

---

## 📎 附錄：常見錯誤快速指引

下面是學員真實踩過的 5 個坑。完整 15 條請見 [manual_99_troubleshoot.md](#manual-troubleshoot)。

| 現象 | 速解 |
|------|------|
| `hermes: command not found` | 沒重開 PowerShell。回到 1-2 重做。 |
| `irm` 跑一半中斷 | 網路問題。重跑那行 `irm \| iex` 即可，安裝器有續跑能力。 |
| 跑出 14+ 個 `Unexpected token` 紅字 | 你用了 PowerShell 5.1。升級到 PowerShell 7（`winget install Microsoft.PowerShell`），重開後再跑。 |
| `hermes --version` 出來但 `hermes doctor` 一堆紅 ✗ | 是 optional 工具沒裝（如 Playwright），跑 `npx playwright install chromium` 補上即可。 |
| 跑完出現「Python 3.11 not found」 | 罕見情況：uv 沒裝成功。手動補 `winget install --id=astral-sh.uv -e` 後重跑 `irm \| iex`。 |
