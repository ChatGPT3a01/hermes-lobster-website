# 🔄 從 OpenClaw 無痛轉移到 Hermes

> 你已經有一台跑得好好的 OpenClaw（龍蝦），想換新工具又怕「整套重來」？
> Hermes Agent 設計時就考慮到「同台電腦並存 + 部分遷移」，這一頁帶你**保留龍蝦不動，安全側裝 Hermes，再把有用的東西單獨搬過去**。

---

## 為什麼要轉移？兩邊各自的強弱

| 比較項目 | OpenClaw 龍蝦 | Hermes Agent |
|---------|--------------|--------------|
| 開發進度 | 穩定但更新偶爾出大 BUG | 新但社群熱絡（GitHub > 60k stars）|
| 長期記憶 | 偶有「突然全忘」狀況 | 真正持久化記憶（state.db）|
| 多步驟任務 | 黑盒、偶爾卡住停止 | 可視化進度條、卡住會自我修復 |
| Token 用量 | 較高 | **明顯較省**（同模型下） |
| Skill 生態 | 自家生態 + ClawHub | **完全相容 OpenClaw 的 Skill**，可從 ClawHub 直接下載 |
| 通訊網關 | LINE / Telegram / Discord | 16 種（**無 LINE**，要走 Bridge）|
| 桌面 GUI | 無原生 GUI | **Hermes Desktop**（v0.4.3） |
| SubAgent 多工 | 有限 | ✅ 完整支援 |

> [!TIP]
> 結論：**Hermes 不會取代龍蝦，但對 80% 場景更穩、更省 Token**。
> 推薦做法：**兩個並存幾週**，等你習慣 Hermes 再決定要不要把龍蝦關掉。

---

## 同台電腦並存：完全沒問題

OpenClaw 和 Hermes Agent **互相獨立**：

| 項目 | OpenClaw 路徑 | Hermes 路徑 |
|------|--------------|------------|
| 資料夾 | `~/.openclaw/` | `~/.hermes/` |
| Gateway port | `18789` | `8642` |
| Skills | `~/.openclaw/skills/` | `~/.hermes/skills/` |
| Workspace | `~/.openclaw/workspace/` | `~/.hermes/profiles/<name>/` |
| 程式本體 | `%LOCALAPPDATA%\openclaw\` | `%LOCALAPPDATA%\hermes\` |

> [!WARNING]
> **唯一會打架的就是通訊網關**——LINE 一次只能綁一個 Bot Token / 一個 webhook，Telegram / Discord 一次只能綁一組 Bot Token。
> **後面會教怎麼安全處理。**

---

## Step 1：先別動龍蝦，側裝 Hermes

不要做任何刪除或備份的危險動作。**保留龍蝦原樣**，直接：

- **CLI 路線**：跑「🪟 Windows 安裝教學」一鍵安裝精靈，**安裝過程跳過 LINE / Telegram 設定**
- **GUI 路線**（推薦新手）：跑「🖥️ Hermes Desktop」，本地模式安裝後**先不設網關**

裝完 Hermes 後，龍蝦完全沒有變化，照舊可用。

---

## Step 2：Hermes 偵測到 OpenClaw，要不要 Import？

Hermes 安裝精靈在最後一步會掃描你的電腦，如果偵測到 `~/.openclaw/` 存在，會問：

```
Detected existing OpenClaw installation. Import settings, memory, and skills? [Y/n]
```

### ⚠️ 阿亮老師的建議：**選 N（不要直接 Import）**

直接 Import 看起來最省事，但有兩個雷：

| 雷點 | 後果 |
|------|------|
| **記憶有毒** | 龍蝦累積的記憶很多是「使用者修理它」「BUG 過程」的對話，Import 進來會把 Hermes 也帶歪 |
| **模型設定常匯入失敗** | Import 時模型設定容易壞掉，跑出來會看到一堆 error |

### 正確做法：**先選 N，再單獨搬 Skill**

1. Hermes 安裝精靈問 Import 時 → 按 **N**
2. 從頭設定 Provider（OpenRouter / Gemini / Ollama 都行）
3. 進入 CLI 或 Desktop 後，**用人話請 Hermes 自己搬**：

```
請從 ~/.openclaw/skills/ 把我手動裝過的 Skill 複製到 ~/.hermes/skills/，
但不要動到記憶資料夾（memory）和 SOUL.md。
複製完後幫我跑 hermes gateway restart 重掃技能。
```

Hermes 會用 file tool 自己做。

---

## Step 3：Skill 手動搬法（不靠 Hermes 自己搬）

如果你比較放心自己搬：

### Windows PowerShell

```powershell
# 先看龍蝦有哪些 Skill
ls $env:USERPROFILE\.openclaw\skills

# 整個 skills 資料夾複製過去（保留原本的）
Copy-Item -Recurse "$env:USERPROFILE\.openclaw\skills\*" "$env:USERPROFILE\.hermes\skills\"

# 讓 Hermes 重新掃技能
hermes gateway restart
hermes doctor   # 確認新技能有掃到
```

### macOS / Linux

```bash
ls ~/.openclaw/skills

cp -R ~/.openclaw/skills/* ~/.hermes/skills/

hermes gateway restart
hermes doctor
```

> [!TIP]
> ClawHub 上的 Skill **絕大多數可以直接給 Hermes 用**，因為 SKILL.md 規格相容。
> 少數寫死 OpenClaw 路徑（`~/.openclaw/...`）的 Skill 要手動改成 `~/.hermes/...`。

---

## Step 4：通訊網關的安全切換

### 4-1：LINE Bot — 一次只能綁一個

LINE Bot 一支 Token 只能 webhook 到一個網址。要切到 Hermes：

1. **先把龍蝦的 LINE Bridge 停掉**（不要解除安裝）：
   ```powershell
   # PowerShell
   pm2 stop line-bridge
   # 或直接關掉跑 line-bridge 的視窗
   ```
2. 改用 Hermes 的 LINE Bridge（看「💚 LINE 機器人設定」那一頁）
3. 在 LINE Developers Console **更新 webhook URL** 到 Hermes 那條 ngrok
4. **測試 OK 後**才考慮要不要徹底拔掉龍蝦

### 4-2：Telegram Bot — 兩個並存有解

Telegram **可以分兩個 Bot**：

1. 龍蝦保留原本的 Bot（例如 `@your_lobster_bot`）
2. 在 BotFather **再開一支新 Bot**（例如 `@your_hermes_bot`）給 Hermes
3. 各自綁各自的 Token，**完全不衝突**

### 4-3：Discord — 同上

Discord 一樣可以開兩個 Application / Bot，各自綁各自的 Channel。

> [!WARNING]
> **Hermes 安裝精靈第一次設定 Telegram 時，不要勾「import from OpenClaw」**！
> 直接 import 龍蝦的 Telegram Token 會搶占 gateway，**龍蝦立刻斷線**，連 Discord 也會跟著掉。
> 用 BotFather 開新 Bot 是最安全做法。

---

## Step 5：兩個並存的「日常路線」分工

裝完後可以這樣分工，發揮兩個 Agent 各自強項：

| 任務類型 | 用哪個 | 理由 |
|---------|-------|------|
| 排程 / 邊角自動化 | OpenClaw | 阿亮老師實測：放排程任務時龍蝦最穩 |
| 多步驟複雜任務 | Hermes | 進度可視化、卡住會修 |
| 長期累積記憶的助理 | Hermes | 真正持久化，不會突然忘記 |
| 既有 LINE Bot 流量主力 | 看你要哪邊接 | 一次只能綁一邊 |
| 想串瀏覽器控制（Chrome MCP）| **Hermes**（Mac / Linux） | 龍蝦這部分一直搞不定 |
| 想用 ClawHub 新技能 | 都行 | 兩邊 SKILL 規格相容 |

---

## 重要：Hermes 兩個使用習慣要記住

從龍蝦過來的人最容易踩到的兩個雷：

### 雷 1：用一段時間要叫 Hermes「存記憶」

```
請把今天的工作重點寫進記憶裡。
```

不主動叫它存，**關掉 session 或重開新 session 後，可能沒持久化下來**。
這跟龍蝦不太一樣（龍蝦會自動存，但常出包；Hermes 是穩，但要你叫它存）。

### 雷 2：重啟用 Restart，**不要 Stop 再 Start**

```bash
# ✅ 正確
hermes gateway restart

# ❌ 錯誤（Hermes 有個 bug）
hermes gateway stop
hermes gateway start   # 經常不會真的起來
```

Hermes 重啟 Gateway 時偶爾會把自己關掉但不自動起回來。**直接用 restart**，遇到問題第一步也是 restart，不要 stop。

---

## 把龍蝦徹底退役（穩定運作幾週後再做）

確認 Hermes 完全頂上後，可以選擇：

### 軟退役（推薦）

- 龍蝦 Gateway 停止：`openclaw gateway stop`
- LINE Bridge 停掉、ngrok 關掉
- 但 **`~/.openclaw/` 資料夾保留**，有需要還能回頭

### 硬退役（確定不回頭再做）

- 移除 `npm uninstall -g openclaw`
- 刪 `~/.openclaw/`（先壓 zip 備份）
- 刪 `%LOCALAPPDATA%\openclaw\`

> [!WARNING]
> 硬退役**至少觀察 4 週後再做**。Hermes 還在快速迭代，遇到大坑你可能會想回頭。

---

## FAQ

### Q1：龍蝦的 USER.md / IDENTITY.md / SOUL.md 能搬嗎？

可以，但**對應到 Hermes 是不同檔名**：

| 龍蝦 | Hermes |
|------|--------|
| `IDENTITY.md`（身分）| 合併到 Hermes 的 `SOUL.md` |
| `SOUL.md`（行為準則）| `SOUL.md` |
| `USER.md`（使用者偏好）| 寫進記憶系統（Memory）|
| `HEARTBEAT.md`（排程）| 改用 `~/.hermes/cron/jobs.json` 或 Desktop 的 Schedules 介面 |

### Q2：龍蝦的 dashboard 網頁能繼續用嗎？

不能直接搬，因為龍蝦 dashboard 寫死 port 18789。但 Hermes Desktop 已經內建類似的圖形介面（Office / Settings / Memory 都有），體驗更好。

### Q3：兩個一起跑會吃很多 RAM 嗎？

不會。兩個都是 Python + Node 進程，閒置時各約 200-400MB。**真正吃資源的是 LLM 推理**——只要你不同時兩邊都狂打 API，總用量不會明顯增加。

### Q4：可以兩個都接同一個 Ollama 本地模型嗎？

可以！Ollama 是獨立 service，**兩個 Agent 同時打它**沒問題（會排隊處理）。本地模型省錢效應因此放大。

---

## 接下來要看哪一頁？

| 你的下一步 | 看這一頁 |
|----------|---------|
| 我要立刻裝 Hermes Desktop | 「🖥️ Hermes Desktop GUI」 |
| 我想走 CLI 一鍵安裝 | 「🪟 Windows 安裝教學」 |
| 我要設定 LINE 給 Hermes | 「💚 LINE 機器人設定」 |
| 我要設定 Telegram 給 Hermes（新 Bot）| 「✈️ Telegram 機器人設定」 |
| 我想用免費 AI 大腦 | 「🪐 Google Antigravity」 |
| 我想搬一些 SKILL 來試試看 | 「🎨 SKILL 安裝教學示範」 |
