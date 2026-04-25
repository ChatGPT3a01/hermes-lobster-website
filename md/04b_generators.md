# 🛠 生成器工具

> ⚠️ **關於路徑**：本頁所有路徑範例預設是 `C:\OpenClaw_Auto\HermesAgent一鍵自動安裝程式\bridge\`。
> 如果你的電腦不是這樣放，**開啟生成器頁後最上方有「📂 你的 bridge 資料夾路徑」欄位**，填一次自動套用到所有工具。

> **省時必看！** 我們把所有常用設定檔都做成了「填表 → 一鍵生成 → 下載／複製」的網頁工具，你不用打開記事本、不用 Ctrl+F 改程式。

---

## 🚀 打開生成器工具頁

<div style="text-align:center;margin:30px 0;">

### [→ 點我進生成器工具頁](generators.html)

</div>

或直接網址：<https://hermes-lobster.netlify.app/generators.html>

---

## 📋 有哪些工具？

### 🔗 官方進階生成器（外部連結）

| 工具 | 用途 |
|------|------|
| 🦞✨ [龍蝦 AI 世界觀 × 人格生成器](https://chatgpt3a01.github.io/lobster-workspace-generator/) | 阿亮老師版，6 Tab 完整架構（IDENTITY/SOUL/USER/AGENTS/TOOLS/HEARTBEAT），輸出 6 個 .md 檔 |
| 👥 [Claude-Claw-YC 團隊員工生成器](https://claude-claw-yc.netlify.app) | YC 風格 5 步流程，23 個預設角色（CTO/PM/UI/全端…），輸出 CLAUDE.md + 員工 .md |

### 🛠 本站內建 5 個生成器

| 工具 | 填入 | 輸出 → 貼到哪 |
|------|------|------------|
| ⚙️ **bridge/.env 生成器** | LINE Secret/Token、AI 模式（Codex/Gemini/OpenAI）、fal.ai key | `bridge\.env` |
| 👧 **小勳 SOUL.md 生成器** | 名字、年齡、個性、外貌、身材、稱呼、語氣… | `bridge\personas\xiaoxun\SOUL.md` |
| 🤖 **主人格 SOUL.md 生成器** | 助理名、風格、擅長領域、回答長度 | `bridge\personas\main\SOUL.md` 或 `~/.hermes/SOUL.md` |
| 📸 **upload-xiaoxun.js 生成器** | 參考圖路徑（3-5 張） | `bridge\upload-xiaoxun.js`，然後 `node upload-xiaoxun.js` |
| 🦞 **~/.hermes/.env 生成器** | Gemini/OpenRouter/Telegram/skill API keys | `%USERPROFILE%\.hermes\.env` |

---

## 💡 建議使用順序

如果你剛安裝完 Hermes 和 Bridge：

1. **先用 ⚙️ bridge/.env 生成器** — 填 LINE 憑證、選 AI 模式 → 下載 `.env`
2. **用 🤖 主人格生成器** → 下載 `SOUL.md` 放 `bridge\personas\main\`
3. **想要副人格？用 👧 小勳生成器**（或阿亮老師的完整版）→ 下載 `SOUL.md` 放 `bridge\personas\xiaoxun\`
4. **要生小勳自拍？**
   - a. 先用 🎨 生成器填 fal.ai key 到 `bridge/.env`
   - b. 用 📸 upload 生成器 + 跑 `node upload-xiaoxun.js`
5. **給 Hermes 本體用？** → 🦞 `~/.hermes/.env` 生成器

---

## 📌 共通操作提醒

- **複製**：點「📋 複製」按鈕 → 貼到記事本 → 另存為對應檔名
- **下載**：點「⬇️ 下載」按鈕 → 瀏覽器下載到 `Downloads` 資料夾 → 剪下貼到目標路徑
- **小心副檔名**：Windows 記事本「另存」容易加 `.txt`，確認存出來的是 `.env` 不是 `.env.txt`
- **中文支援**：生成器輸出已含 UTF-8 BOM，Windows 記事本打開不會亂碼

改完任何檔案後，**重啟對應服務**：
- 改 `bridge/.env` 或 `bridge/personas/**/SOUL.md` → 重啟 `node line-bridge.js`
- 改 `~/.hermes/.env` 或 `~/.hermes/SOUL.md` → `hermes gateway restart`

---

## 🎯 快捷入口

> [→ 直接去 generators.html](generators.html)
