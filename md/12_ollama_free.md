# 🦙 Ollama 免費方案完整教學

> **遇到「Quota exceeded」錯誤？沒有 OpenAI API Key？** 這頁就是為你準備的！
> 用 Ollama 在本機跑 AI，完全免費、可離線，不需要任何訂閱。

---

## 什麼是 Ollama？

**Ollama** 是一個讓你在自己電腦上跑 AI 語言模型的工具，完全免費、開源。
裝好之後，Codex CLI 可以連接它當作 AI 大腦，**不需要 OpenAI API Key**。

| 項目 | Ollama 方案 |
|------|------------|
| 費用 | **完全免費** |
| 網路需求 | 只需下載一次，之後**可完全離線** |
| 資料隱私 | AI 在本機運行，**資料不會上傳** |
| 速度 | 比雲端慢（無 GPU），但夠用 |
| 推薦對象 | 沒有訂閱、遇到 Quota 錯誤的使用者 |

---

## Step 1：安裝 Ollama

1. 開瀏覽器，前往 **https://ollama.com**
2. 點 **Download** → 選 **Windows**
3. 下載完成後執行 `OllamaSetup.exe`，一路按 **Install**
4. 安裝完成，Ollama 自動在背景啟動

**驗證安裝：**
```powershell
ollama --version
```
看到版本號（如 `ollama version is 0.x.x`）就代表安裝成功。

> [!TIP]
> 如果找不到 `ollama` 指令，**關掉 PowerShell 重開**，讓系統 PATH 生效。

---

## Step 2：下載 AI 模型

開啟 **PowerShell**，選一個模型下載：

### 推薦：qwen2.5-coder:7b（一般電腦）

```powershell
ollama pull qwen2.5-coder:7b
```

> 約 **4.7 GB**，第一次下載需要時間，請耐心等候。下載後完全離線可用。

### 電腦 RAM 16GB 以上：14b 更強

```powershell
ollama pull qwen2.5-coder:14b
```

### 電腦很舊或 RAM 8GB 以下：用 3b 更快

```powershell
ollama pull qwen2.5-coder:3b
```

**確認下載完成：**
```powershell
ollama list
```

看到模型名稱出現就 OK，例如：
```
NAME                    ID              SIZE    MODIFIED
qwen2.5-coder:7b        ...             4.7 GB  ...
```

---

## Step 3：啟動 Ollama 伺服器

```powershell
ollama serve
```

> [!WARNING]
> **這個 PowerShell 視窗不能關！** 讓它在背景持續執行。
> 之後的步驟請**開新的 PowerShell 視窗**操作。

如果出現 `address already in use`，代表 Ollama 已經在跑了，直接跳 Step 4。

---

## Step 4：設定 Codex CLI 連接 Ollama

開**新的 PowerShell 視窗**，執行：

```powershell
$env:OPENAI_API_KEY="ollama"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
```

> [!NOTE]
> 這個設定只在**目前這個視窗**有效。每次重開 PowerShell 都要重設一次。

**想讓設定永久生效？** 執行：

```powershell
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'ollama', 'User')
[System.Environment]::SetEnvironmentVariable('OPENAI_BASE_URL', 'http://localhost:11434/v1', 'User')
```

設完後重開 PowerShell 即永久生效，以後不用每次設定。

---

## Step 5：cd 進安裝精靈資料夾，啟動 Codex

```powershell
cd C:\OpenClaw_Auto\HermesAgent安裝精靈
codex --model qwen2.5-coder:7b
```

---

## Step 6：貼上 AI 自動安裝提示詞

Codex 啟動後，貼上這句話送出：

```
【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
```

AI 會自動讀取腳本開始安裝！

---

## 常見問題

### Q：回答速度很慢怎麼辦？

本機跑 AI 受限於電腦效能，沒有 GPU 的電腦速度較慢是正常的。解法：

1. 改用較小的模型：`codex --model qwen2.5-coder:3b`
2. 關掉其他佔記憶體的程式（Chrome、遊戲等）
3. 有 NVIDIA GPU → Ollama 會自動用 GPU 加速

### Q：`ollama serve` 說 port 被占用

代表 Ollama 已在背景執行，直接跳 Step 4 設定環境變數即可。

### Q：模型下載到一半斷了

重新執行 `ollama pull qwen2.5-coder:7b`，會從斷點續傳。

### Q：Codex 說「model not found」

確認 `ollama list` 裡有這個模型，且 `ollama serve` 正在執行。

### Q：想換回用 OpenAI API

```powershell
Remove-Item Env:OPENAI_API_KEY
Remove-Item Env:OPENAI_BASE_URL
$env:OPENAI_API_KEY="sk-你的Key"
```

---

## 模型效能比較

| 模型 | 大小 | RAM 需求 | 速度 | 適合 |
|------|------|---------|------|------|
| qwen2.5-coder:3b | 1.9 GB | 4 GB | ⚡⚡⚡ | 舊電腦 |
| qwen2.5-coder:7b | 4.7 GB | 8 GB | ⚡⚡ | 一般電腦（推薦）|
| qwen2.5-coder:14b | 9 GB | 16 GB | ⚡ | 高效能電腦 |

---

> [!TIP]
> 有 **Claude Pro** 訂閱嗎？改用 `claude` 指令，效果比 Ollama 更強，速度也更快！詳見左側「🔶 Claude Code」。
