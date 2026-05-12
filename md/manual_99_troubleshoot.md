# 🐛 常見錯誤與排解

## 彙整本教學常見的坑 + Windows 限制改寫指引

---

## 【安裝階段】

### Q1. `install.ps1` 報 14+ 個 `Unexpected token` 錯誤

**症狀**：跑官方 install.ps1 時滿屏紅字。

**原因**：你用的是 **PowerShell 5.1**（Windows 內建舊版），讀沒 BOM 的 UTF-8 檔把中文當 Big5。

> [!TIP]
> **2026 年大部分人不會踩到這坑**：因為新版 Hermes 安裝腳本與 PowerShell 7 都已自動處理編碼。如果你的 PowerShell 是 7+ 版本，請直接看 Q1-b。

**修法 A（推薦）：升級到 PowerShell 7**

```powershell
winget install Microsoft.PowerShell --silent --accept-package-agreements
```

裝完**關掉舊 PowerShell**，從**開始選單**搜尋「PowerShell 7」開啟，再跑：

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

**修法 B（懶得換版本）：手動補 BOM**

```powershell
$ProgressPreference='SilentlyContinue'
$tmp = "$env:TEMP\hermes-install.ps1"
Invoke-WebRequest `
  -Uri 'https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1' `
  -OutFile $tmp -UseBasicParsing

# 補上 UTF-8 BOM（3 個 byte：EF BB BF）
$b = [System.IO.File]::ReadAllBytes($tmp)
[System.IO.File]::WriteAllBytes($tmp, [byte[]](0xEF,0xBB,0xBF) + $b)

# 再執行
$env:PYTHONUTF8='1'
& powershell -NoProfile -ExecutionPolicy Bypass -File $tmp -SkipSetup
```

### Q1-b. 我怎麼知道 PowerShell 版本？

```powershell
$PSVersionTable.PSVersion
```

- `Major 5` → 舊版，建議升 7
- `Major 7` → 新版，沒這問題

---

### Q2. install 看起來成功但 `hermes.exe` 不存在

**症狀**：log 顯示 `✓ Main package installed`，但下面這指令回 `False`：

```powershell
Test-Path "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe"
```

**原因**：罕見情況下，系統已有 **Python 3.10 或更舊**，安裝器繞過 uv 直接用了舊 Python。HermesAgent v0.10 要求 Python **≥ 3.11**。

**修法（一次到位）：**

```powershell
# 1. 補裝 Python 3.11
winget install Python.Python.3.11 --silent --accept-package-agreements

# 2. 刪舊 venv
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\hermes\hermes-agent\venv"

# 3. 用 Python 3.11 重建 venv
Set-Location "$env:LOCALAPPDATA\hermes\hermes-agent"
uv venv --python 3.11 venv

# 4. 重新安裝 hermes-agent 套件到新 venv
uv pip install -e . --python venv\Scripts\python.exe

# 5. 驗證
Test-Path "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe"
```

最後一行回 `True` 就成功。

---

### Q3. `hermes gateway status` 報 OSError

**症狀**：Windows 上執行 status 指令跳 `OSError`。

**原因**：Windows 平台相容性 bug，**v0.10.0 之前的版本才有**。

**修法 A（推薦）：直接升級**

```powershell
hermes uninstall
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

**修法 B（不想重灌）：手動 patch**

編輯 `%LOCALAPPDATA%\hermes\hermes-agent\venv\Lib\site-packages\hermes_agent\gateway\status.py`，找到：

```python
except (ProcessLookupError, PermissionError):
```

改成：

```python
except (ProcessLookupError, PermissionError, OSError):
```

---

### Q3-a. `hermes: command not found`（指令找不到）

**症狀**：明明跑了 install.ps1，但 `hermes --version` 說沒這指令。

**原因**：PATH 還沒刷新。

**修法**：
1. 關掉現在的 PowerShell
2. **重新開**一個（按 <kbd>Win</kbd>+<kbd>R</kbd> → `powershell`）
3. 再試 `hermes --version`

> [!TIP]
> 急用且不想重開：`& "$env:LOCALAPPDATA\hermes\bin\hermes.cmd" --version` 也能跑。

---

## 【LINE Bridge 階段】

### Q4. `[錯誤] 缺少 LINE_CHANNEL_SECRET`

**修**：確認 `.env` 在 `bridge/` 目錄、檔名不是 `.env.txt`（記事本會偷加副檔名）：

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

## 【Telegram / Discord 圖影傳送】

### Q15. 第一次 Bot 回傳圖片或影片時路徑錯誤

**症狀**：用 Telegram 或 Discord 對 Bot 說「拍張照給我」「給我看那個影片」，第一次 Bot 會找不到檔案，或回傳一個怪怪的相對路徑。

**原因**：HermesAgent 的記憶系統剛建立時，**還沒學會 Windows 的路徑格式**（例如該用 `%USERPROFILE%\.hermes\` 還是 POSIX 風格）。Agent 第一次嘗試送檔案時容易猜錯位置。

**修（其實不用修）**：

```
✅ 第一次失敗 → Agent 會記住正確路徑 → 第二次以後就自動對了
```

**這是 Early Beta 的已知行為，不是 bug，記憶更新後會自動解決**。要加速：

```
1. 第一次失敗時，明確告訴 Bot：「圖片要從 C:\Users\你\Pictures\ 抓」
2. 或執行一次 hermes doctor，確認 .hermes 路徑無誤
3. 之後再試，記憶就會把正確路徑寫進去
```

> [!TIP]
> 如果一直不會自動修正，到 `%USERPROFILE%\.hermes\` 找 memory 檔案，把錯誤的路徑記憶手動清掉就好。

---

## 【Skill 階段】

### Q16. `skill-vetter-v2 invalid YAML`

**原因**：該 skill 的 frontmatter 結尾是 `---------`（9 個 dash）。

**修**：改成 `---`（3 個）即可。用 PowerShell：

```powershell
$f = "$env:USERPROFILE\.hermes\skills\skill-vetter-v2\SKILL.md"
$c = Get-Content $f -Raw
Set-Content $f -Value ($c -replace '(?m)^---------+$','---') -Encoding UTF8 -NoNewline
```

---

## 【ngrok 階段】

### Q17. ngrok URL 每次重開都變

**修**：
- 付費 ngrok 固定 subdomain（$8/月）
- 改用 Cloudflare Tunnel（免費固定 URL，設定較複雜）
- 自建小 VPS（最穩，需要 Linux 基礎）

---

## 【其他】

### Q18. `/edit` 指令打開的是空白記事本

**原因**：`$env:EDITOR` 環境變數沒設好。

**修**：在 PowerShell 設定檔（`$PROFILE`）裡加一行：

```powershell
$env:EDITOR = "code --wait"        # VS Code
# 或
$env:EDITOR = "notepad++ -multiInst -nosession"     # Notepad++
```

存檔後重開 PowerShell。

---

### Q19. 中文/日文/Emoji 顯示成 `?` 或亂碼

**原因**：UTF-8 shim 沒啟動。

**檢查**：

```powershell
Get-ChildItem env:HERMES_DISABLE_WINDOWS_UTF8
```

如果有值且為 `1` → 把它移除（這變數是除錯用，平常不該設）：

```powershell
[System.Environment]::SetEnvironmentVariable('HERMES_DISABLE_WINDOWS_UTF8', $null, 'User')
```

或者**直接改用 Windows Terminal**（從 Microsoft Store 免費裝），UTF-8 支援好很多。

---

### Q20. 重開電腦後 Gateway 沒自動跑

**原因**：群組原則阻止了排程工作的 ONLOGON 觸發。

**修**：重新安裝 Gateway 並強制使用啟動資料夾方式：

```powershell
$env:HERMES_GATEWAY_FORCE_STARTUP = '1'
hermes gateway uninstall
hermes gateway install
```

---

## 還有問題？

1. 到阿亮老師的 **Facebook 社團**：[3A科技研究社](https://www.facebook.com/groups/2754139931432955)
2. **Email**：3a01chatgpt@gmail.com
3. **YouTube 頻道**：<https://youtube.com/@Liang-yt02>

---

> [!TIP]
> **90% 的錯誤都在前 5 分鐘就遇到，別慌！**
> 仔細看錯誤訊息，找這份排解清單，通常都能解決。

---

# 📎 附錄 A：徹底解除安裝

**保留資料的解除安裝**（重灌會帶回設定）：

```powershell
hermes uninstall
```

執行後會清掉：
- 排程工作（schtasks）
- 啟動資料夾快捷方式
- `%LOCALAPPDATA%\hermes\hermes-agent\`
- 使用者 PATH 中的 hermes 條目

**保留** `%USERPROFILE%\.hermes\`（你的 `.env`、技能、記憶、會話歷史）。

**完全清乾淨**（包含 API key 和記憶）：

```powershell
hermes uninstall
Remove-Item -Recurse -Force "$env:USERPROFILE\.hermes"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\hermes"
```

> [!CAUTION]
> 第二段指令會把你所有的人格、記憶、API key 全部清掉，**重要資料記得先備份 `%USERPROFILE%\.hermes\` 整個資料夾**。

---

# 📎 附錄 B：Windows 特定環境變數參考

| 變數 | 預設 | 用途 |
|------|------|------|
| `HERMES_GIT_BASH_PATH` | 自動偵測 | 覆寫 bash.exe 探索路徑（用於指向 WSL bash 或自訂 MSYS2） |
| `HERMES_DISABLE_WINDOWS_UTF8` | 未設定 | 設為 `1` 停用 UTF-8 shim（**僅除錯用**，不該長期設定） |
| `HERMES_GATEWAY_FORCE_STARTUP` | 未設定 | 設為 `1` 強制 Gateway 用啟動資料夾而非 schtasks（群組原則受限時用） |
| `EDITOR` / `VISUAL` | `notepad` | `/edit` 與 `Ctrl-X Ctrl-E` 用的編輯器 |
| `PYTHONUTF8` | `1`（自動） | 強制 Python 用 UTF-8 編碼 |
| `HERMES_HOME` | `%USERPROFILE%\.hermes` | 自訂使用者資料目錄（跨機同步時用） |

---

# 📎 附錄 C：Linux-only 功能 Windows 改寫指引

> 學員回饋：「**Hermes 很多原生套件是基於 Linux 環境設計，例如調用語音的聽與說功能，這些需要在自己弄成 Windows 版本~**」
>
> 這個附錄就是寫給想自己把這些功能改 Windows 版的人。

## C-1. 語音「說」（TTS，文字轉語音）

**Linux 原版用的**：`espeak-ng` 或 `piper`（Linux 套件）

**Windows 改寫方案 ①：Windows SAPI（系統內建）**

PowerShell 一行就能說：

```powershell
Add-Type -AssemblyName System.Speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak("你好，我是愛馬仕")
```

整合到 Hermes Skill 的範例（建一個 `~/.hermes/skills/tts-windows/SKILL.md` 並附 `tts.ps1`）：

```powershell
# tts.ps1
param([string]$Text)
Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
$s.SelectVoice("Microsoft Hanhan Desktop")   # 中文女聲
$s.Speak($Text)
```

**Windows 改寫方案 ②：用免費雲端 TTS**

- **edge-tts**（微軟 Edge 語音，免費、高品質）：
  ```powershell
  pip install edge-tts
  edge-tts --text "你好" --voice zh-TW-HsiaoChenNeural --write-media out.mp3
  ```
- **Google TTS**（`gTTS`，免費但要網路）

## C-2. 語音「聽」（STT，語音轉文字）

**Linux 原版用的**：`whisper.cpp` Linux build、`alsa` 錄音

**Windows 改寫方案 ①：OpenAI Whisper 本機版**

```powershell
pip install openai-whisper
whisper recording.wav --model base --language Chinese
```

**Windows 改寫方案 ②：WhisperX / Faster-Whisper（速度快 4 倍）**

```powershell
pip install faster-whisper
```

```python
from faster_whisper import WhisperModel
model = WhisperModel("base", device="cuda", compute_type="float16")   # 用 GPU
segments, _ = model.transcribe("recording.wav", language="zh")
for seg in segments:
    print(seg.text)
```

**Windows 改寫方案 ③：Windows 內建語音辨識**

按 <kbd>Win</kbd>+<kbd>H</kbd> 即可叫出 Windows 語音輸入（Win 11 中文支援不錯）。

## C-3. 儀表板嵌入式終端（`/chat` 分頁）

**為什麼不能用**：儀表板的 Web 終端用 `ptyprocess`（POSIX PTY），Windows 的 ConPTY 介面不同。

**Windows 替代方案**：
- 用 `hermes chat` CLI（功能完全相同）
- 用 `hermes --tui`（互動式介面，最接近儀表板體驗）
- 開兩個視窗：一個 Web 儀表板看會話／指標／配置，一個 PowerShell 跑 `hermes chat`

> [!NOTE]
> 儀表板**其他分頁**（會話、作業、指標、配置、技能管理）**全部正常運作**，只有 `/chat` 分頁不能用。

## C-4. systemd 自動啟動（Linux 原版用）

**Linux 原版**：`systemctl --user enable hermes-gateway`

**Windows 等效**：

```powershell
hermes gateway install     # 用 Windows 排程工作（schtasks）
hermes gateway uninstall   # 移除
```

底層機制：建一個 ONLOGON 觸發的排程工作。**不需要管理員權限**。

## C-5. Linux 路徑 vs Windows 路徑

Hermes 內部統一用 POSIX 風格（`/`），Windows 上偶爾會看到路徑混用。

**如果你寫 Skill 要處理路徑**：

```python
from pathlib import Path
# 用 pathlib，自動處理跨平台
p = Path.home() / ".hermes" / "skills"
print(p)   # Linux: /home/u/.hermes/skills    Windows: C:\Users\u\.hermes\skills
```

**PowerShell 同理**：

```powershell
Join-Path $env:USERPROFILE ".hermes\skills"   # 永遠正確
```

---

## C-6. 想貢獻 Windows 版回上游？

學員回饋：「**好希望有 Windows Skill 專門討論區**」。

阿亮老師的建議：
1. 把你寫的 Windows Skill 包成獨立 repo，遵循 [SKILL.md 規範](https://hermes-agent.nousresearch.com/docs/skills)
2. 命名加 `-windows` 後綴（如 `tts-windows`、`stt-windows`）
3. 開 issue 到 [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent/issues) 標 `[Windows]`，社群會看到
4. 阿亮老師會在 **3A科技研究社** Facebook 開「Windows Skill 改寫」討論串，貢獻者直接 tag 阿亮老師
