# 🐛 常見錯誤與排解

## 彙整本教學常見的 15 個坑

---

## 【安裝階段】

### Q1. `install.ps1` 報 14+ 個 `Unexpected token` 錯誤

**症狀**：跑官方 install.ps1 時滿屏語法錯誤。

**原因**：PowerShell 5.1 讀沒 BOM 的 UTF-8 檔把中文當 Big5。

**修**：下載後先加 BOM 再跑：
```powershell
$b = [System.IO.File]::ReadAllBytes($tmp)
[System.IO.File]::WriteAllBytes($tmp, [byte[]](0xEF,0xBB,0xBF) + $b)
```

---

### Q2. install 看起來成功但 `hermes.exe` 不存在

**症狀**：log 顯示 `✓ Main package installed` 但 `$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe` 不存在。

**原因**：Python 3.10 < hermes-agent 0.10 要求的 3.11。

**修**：winget 補裝 3.11 → 刪 venv → `uv venv --python 3.11` → `uv pip install -e .`（Step 1-4 完整指令）

---

### Q3. `hermes gateway status` 報 OSError

**症狀**：Windows 上執行 status 指令跳 `OSError`。

**原因**：Windows 平台相容性 bug（已由上游修復，舊版本才有）。

**修**：升級到 v0.10.0+（目前最新），或手動編輯 `gateway\status.py` 把 `except (ProcessLookupError, PermissionError):` 改成 `except (ProcessLookupError, PermissionError, OSError):`。

---

## 【LINE Bridge 階段】

### Q4. `[錯誤] 缺少 LINE_CHANNEL_SECRET`

**修**：確認 `.env` 在 `bridge/` 目錄、檔名不是 `.env.txt`（記事本會加副檔名）：
```powershell
Get-ChildItem -Force bridge\ | Where-Object { $_.Name -eq '.env' }
```

---

### Q5. LINE webhook Verify 失敗

**逐項檢查**：
1. URL 是否 `https://xxx.ngrok-free.dev/webhook`（結尾 `/webhook` 不能漏）
2. Bridge 是否在跑（`Invoke-RestMethod http://localhost:3000/`）
3. ngrok 是否在跑
4. ngrok URL 和 LINE Console 貼的 URL 是否一致

---

### Q6. Bot 同一則訊息回兩次

**原因**：LINE 的 Auto-reply 沒關。

**修**：LINE Official Account Manager → 回應設定 → **關閉自動回應訊息**。

---

### Q7. LINE 訊息傳出後 Bot 遲遲不回

**原因**：Bridge 的 webhook handler 等 AI 回完才 `res.status(200)`，LINE 1 秒 timeout 重試。

**修**：用 Step 3-4 Bug 2 改過的寫法（立即回 200，async 處理事件）。

---

## 【Codex 訂閱階段】

### Q8. `codex` 指令找不到

**修**：裝完 `npm install -g @openai/codex` 要**重開 PowerShell** 讓 PATH 刷新。

---

### Q9. `spawn codex.cmd ENOENT`

**原因**：Windows 上 npm 裝的 codex 只有 `codex.ps1`，沒 `codex.cmd`。

**修**：在 `line-bridge.js` 用 `spawn(process.execPath, [CODEX_JS_PATH, ...])`（Step 5-4 完整 code）。

---

### Q10. `codex exec` 被 sandbox 擋住

**症狀**：`codex: failed to access ...` 或 `network access denied`。

**修**：spawn args 加 `--dangerously-bypass-approvals-and-sandbox`。

---

## 【副人格與生圖階段】

### Q11. 小勳回話像 AI 助理（不像女友）

**原因**：codex / GPT 預設偏助理語氣，SOUL 指令沒強壓。

**修**：在 prompt system 最前面加：
```
【角色扮演模式】你不是 AI 助理，你就是下面的角色本人。
禁用這些腔：「我可以幫你」「如果你願意」「我是 AI」
```

---

### Q12. 自拍都是側面、構圖單一

**修**：
1. 降 `id_weight` 從 1.2 到 1.0
2. 寫「隨機構圖池」給 codex 每次隨機指派一個角度（正面／鏡子／回眸等）

---

### Q13. 圖片 AI 感太重（塑膠感、假）

**修**：
1. `num_inference_steps` 提到 32
2. Prompt 必加：`raw photo, shot on iPhone 15 Pro, natural skin texture with visible pores, soft film grain`
3. Prompt 尾加：`avoiding cgi, digital art, plastic skin, airbrushed, anime`

---

### Q14. 拍不出第二張（連續拍照失敗）

**原因**：觸發詞 regex 太窄，只配 `^` 開頭。

**修**：
1. 拿掉 `^`，訊息任意位置含就觸發
2. 加「連續模式」：上一則是圖時，含「再／換／性感／緊身」也觸發

---

## 【Skill 階段】

### Q15. `skill-vetter-v2 invalid YAML`

**原因**：該 skill 的 frontmatter 結尾是 `---------`（9 個 dash）。

**修**：改成 `---`（3 個）即可。用 PowerShell：
```powershell
$f = "$env:USERPROFILE\.hermes\skills\skill-vetter-v2\SKILL.md"
$c = Get-Content $f -Raw
Set-Content $f -Value ($c -replace '(?m)^---------+$','---') -Encoding UTF8 -NoNewline
```

---

## 【ngrok 階段】

### ngrok URL 每次重開都變

**修**：
- 付費 ngrok 固定 subdomain（$8/月）
- 改用 Cloudflare Tunnel（免費固定 URL，設定較複雜）
- 自建小 VPS（最穩，需要 Linux 基礎）

---

## 還有問題？

1. 到阿亮老師的 **Facebook 社團**：[3A科技研究社](https://www.facebook.com/groups/2754139931432955)
2. **Email**：3a01chatgpt@gmail.com
3. **YouTube 頻道**：<https://youtube.com/@Liang-yt02>

---

> [!TIP]
> **90% 的錯誤都在前 5 分鐘就遇到，別慌！**
> 仔細看錯誤訊息，找這份排解清單，通常都能解決。
