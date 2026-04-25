# 🧠 Step 7：安裝 75 個 Skill

> 預估時間：15 分鐘
> 目標：讓 Hermes、Codex、Claude Code 三個 AI 都能呼叫 75 個技能

---

## 7-1. 什麼是 Skill？

Skill 是一個 `SKILL.md` 檔案，用 YAML frontmatter 定義：
```markdown
---
name: excel-xlsx
description: Create, inspect, edit Excel files...
---
# 詳細指令內容
```

AI 讀到描述後，根據情境自動呼叫對應的 skill。

---

## 7-2. 三個官方來源

| 來源 | 說明 | 數量 |
|------|------|------|
| Google 官方 | [github.com/google/skills](https://github.com/google/skills) | 13 個 GCP 相關 |
| OpenAI 官方 | [github.com/openai/skills](https://github.com/openai/skills) | 38 個通用（Figma/Notion/Linear/Playwright...）|
| 阿亮老師舊 OpenClaw | `~/.openclaw/workspace/skills/` | 23 個（Excel/Word/PDF/Email...）|

> [!TIP]
> 直接點上方連結可以在 GitHub 上預覽每個 skill 的 `SKILL.md` 內容：
> - **Google Skills**：<https://github.com/google/skills>
> - **OpenAI Skills**：<https://github.com/openai/skills>

---

## 7-3. 下載官方 skills

```powershell
# 建暫存資料夾
Remove-Item -Recurse -Force "$env:TEMP\google-skills","$env:TEMP\openai-skills" -ErrorAction SilentlyContinue

git clone --depth 1 https://github.com/google/skills "$env:TEMP\google-skills"
git clone --depth 1 https://github.com/openai/skills "$env:TEMP\openai-skills"
```

---

## 7-4. 複製到三處 skill 資料夾

```powershell
$hermesDir = "$env:USERPROFILE\.hermes\skills"
$codexDir  = "$env:USERPROFILE\.codex\skills"
$claudeDir = "$env:USERPROFILE\.claude\skills"

# 確保資料夾存在
foreach ($d in @($hermesDir, $codexDir, $claudeDir)) {
  New-Item -ItemType Directory -Path $d -Force | Out-Null
}

# 複製 Google skills（來源：google/skills/cloud）
foreach ($d in @($hermesDir, $codexDir, $claudeDir)) {
  Get-ChildItem "$env:TEMP\google-skills\skills\cloud" -Directory | ForEach-Object {
    Copy-Item -Recurse -Force $_.FullName (Join-Path $d $_.Name)
  }
}

# 複製 OpenAI skills（來源：openai/skills/.curated）
foreach ($d in @($hermesDir, $codexDir, $claudeDir)) {
  Get-ChildItem "$env:TEMP\openai-skills\skills\.curated" -Directory | ForEach-Object {
    Copy-Item -Recurse -Force $_.FullName (Join-Path $d $_.Name)
  }
}
```

---

## 7-5. 遷移舊 OpenClaw skills（如果你以前裝過）

```powershell
$src = "$env:USERPROFILE\.openclaw\workspace\skills"
if (Test-Path $src) {
  foreach ($d in @($hermesDir, $codexDir, $claudeDir)) {
    Get-ChildItem $src -Directory | ForEach-Object {
      $skillMd = Join-Path $_.FullName 'SKILL.md'
      if (Test-Path $skillMd) {
        $dst = Join-Path $d $_.Name
        if (-not (Test-Path $dst)) {
          Copy-Item -Recurse -Force $_.FullName $dst
        }
      }
    }
  }
}
```

---

## 7-6. ⚠️ 修正一個已知 YAML bug

有一個 skill `skill-vetter-v2` frontmatter 格式錯（`---------` 9 個 dash）。要全部修掉：

```powershell
foreach ($d in @($hermesDir, $codexDir, $claudeDir)) {
  $f = Join-Path $d 'skill-vetter-v2\SKILL.md'
  if (Test-Path $f) {
    $c = Get-Content $f -Raw
    $fixed = $c -replace '(?m)^---------+$','---'
    if ($c -ne $fixed) {
      Set-Content $f -Value $fixed -Encoding UTF8 -NoNewline
    }
  }
}
```

---

## 7-7. 驗證 Hermes 看到 skills

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" skills list
```

應該列出 **75 個** skill：
```
0 hub-installed, 0 builtin, 75 local
```

---

## 7-8. 裝部分 Skill 需要的 CLI 工具

許多 skill 呼叫外部 CLI，先裝這幾個：

```powershell
npm install -g agent-browser                  # Browser 自動化
npm install -g @playwright/cli                # Playwright CLI
npm install -g clawhub                        # ClawHub skill 管理
pip install ultralytics                       # YOLO 物件偵測

# Agent-browser 的 Chrome binary（約 182MB）
agent-browser install --with-deps
```

---

## 7-9. 需要申請 API Key 的 Skill（逐個教學）

以下 5 個 skill 需要對應平台的 API Key。**用不到可跳過**，有需要再回來看這段。

---

### 7-9-A：Firecrawl（網頁爬蟲 + 搜尋）

**能做什麼**：爬取含 JavaScript 的網頁、搜索整個網站、把網頁轉成 markdown。

**申請步驟：**

1. <https://firecrawl.dev> → **Sign up**（GitHub / Google 登入）
2. 進 Dashboard → 左邊 **API Keys**
3. 複製 **Default API Key**（格式：`fc-xxxxxxxxxxxxxxxx`）
4. 額度：免費方案每月 500 次請求

**填入 Hermes .env：**

```powershell
notepad "$env:USERPROFILE\.hermes\.env"
```

搜尋 `FIRECRAWL_API_KEY`（Ctrl+F），若不存在就**在檔案最底部新增一行**：
```env
FIRECRAWL_API_KEY=fc-貼入你的_Key
```

---

### 7-9-B：Tavily（AI 搜尋引擎）

**能做什麼**：AI 優化的網路搜尋，比一般 Google 搜尋更適合餵給 LLM。

**申請步驟：**

1. <https://tavily.com> → **Get API Key** 或 **Sign up**
2. GitHub / Google 登入
3. 進 Dashboard → **API Keys**
4. 複製（格式：`tvly-xxxxxxxxxxxxxxxxxxxx`）
5. 額度：免費每月 1000 次

**填入：**

```env
TAVILY_API_KEY=tvly-貼入你的_Key
```

---

### 7-9-C：Linear（專案管理 Issue 追蹤）

**能做什麼**：管理 Linear 上的 issue、sprint、專案。適合軟體團隊。

**申請步驟：**

1. 登入 <https://linear.app>（沒帳號要先註冊）
2. 進 Settings → Account → **API** 或直接打開 <https://linear.app/settings/api>
3. 找 **Personal API keys** → **Create key**
4. 填名稱（例 `hermes-bot`）→ 複製產生的 Key
   - 格式：`lin_api_xxxxxxxxxxxxxxxxxxxxxx`

**填入：**

```env
LINEAR_API_KEY=lin_api_貼入你的_Key
```

---

### 7-9-D：Sentry（錯誤監控）

**能做什麼**：查 production 應用的 error log、issue、效能。

**申請步驟：**

1. <https://sentry.io> → **Sign up**（GitHub 最快）
2. 建立 Organization + Project
3. 左下 Settings → Account → **API** → **Auth Tokens**
4. 直接連結：<https://sentry.io/settings/account/api/auth-tokens/>
5. **Create New Token** → 勾選 scope（一般 `project:read`、`event:read`）
6. 複製 Token（格式：`sntrys_xxxxxxx`）

**填入：**

```env
SENTRY_AUTH_TOKEN=sntrys_貼入你的_Token
SENTRY_ORG=你的_organization_slug
```

---

### 7-9-E：Maton（連 100+ 外部服務的 API Gateway）

**能做什麼**：一個 Key 打通 Google Workspace、Microsoft 365、GitHub、Slack、Airtable、HubSpot 等 100+ 服務的整合。

**申請步驟：**

1. <https://maton.ai> → **Sign up**
2. 進 Dashboard → **Settings** → **API Keys**
3. **Generate new key** → 複製
   - 格式：`maton_xxxxxxxxxxxxxxxxxxxxx`
4. **接下來要為每個外部服務做 OAuth 授權**：
   - Dashboard → **Connections** → 選一個服務（例如 Gmail）→ **Connect**
   - 會跳 OAuth 授權頁 → 同意
   - 回 Dashboard 該服務變成 ✅ Connected

**填入：**

```env
MATON_API_KEY=maton_貼入你的_Key
```

> [!WARNING]
> Maton 的 `MATON_API_KEY` 本身**不授權**任何第三方服務，還要在 Maton 的 Dashboard 對每個服務做 OAuth。Key 只是讓 Hermes 能呼叫 Maton。

---

## 7-10. 全部填入後重啟 Hermes

改完 `~/.hermes/.env` 後，讓 Hermes 重載環境：

```powershell
# 關掉 hermes chat（Ctrl+C）
# 重新啟動
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" doctor
```

在 `◆ Tool Skills` 段落，之前顯示 `⚠ ... (missing XXX_API_KEY)` 的 skill 應該都變 `✓`。

## 7-10. 測試 Skill 在 Hermes 終端能用

```powershell
& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe" chat
```

進入對話後試：
```
> 幫我用 excel-xlsx 做一個測試 xlsx，A1 = Hello World
```

Hermes 會自動呼叫 excel-xlsx skill 做事。

---

## 7-11. LINE 上能用嗎？

**目前 LINE Bridge 透過 `codex exec --ephemeral` 跑，默認會讀 `~/.codex/skills/`。** 但因為 ephemeral 模式 sandbox 層級不同，部分 skill 可能無法呼叫外部 CLI。

最穩的做法：進 Hermes 終端跑 skill，LINE 只做對話。

---

## 🎉 Step 7 完成！

Hermes、Codex、Claude Code 現在都有 75 個 skill 可用。

**全部 Step 都完成了！** 恭喜，你已擁有一個完整運作的愛馬仕龍蝦系統。

接下來遇到問題參考「常見錯誤與排解」章節。
