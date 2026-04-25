# Mac 安裝教學

## 系統需求

| 項目 | 需求 |
|------|------|
| 作業系統 | macOS 12 Monterey 以上（建議 macOS 14 Sonoma）|
| 晶片 | Apple Silicon (M1/M2/M3/M4) 或 Intel |
| 記憶體 | 至少 8 GB RAM |
| 磁碟空間 | 至少 5 GB 可用空間 |
| 網路 | 需要網際網路連線 |

---

## 方法一：官方安裝腳本（推薦）

開啟 **終端機（Terminal）**，執行：

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

腳本會自動：
1. 檢查並安裝 Python 3.10+（若未安裝）
2. 建立虛擬環境
3. 安裝 HermesAgent 及所有相依套件
4. 設定 PATH 環境變數

安裝完成後，**重新開啟終端機**讓 PATH 生效。

---

## 方法二：Homebrew 安裝（進階）

如果你已安裝 Homebrew：

```bash
# 確認 Python 版本
python3 --version  # 需要 3.10+

# 若需要安裝 Python
brew install python@3.11

# 下載並安裝 HermesAgent
pip3 install hermes-agent
```

> [!WARNING]
> Homebrew 方法可能因為套件版本衝突導致問題，建議使用官方安裝腳本。

---

## 驗證安裝

```bash
hermes --version
hermes doctor
```

如果看到版本號和 `All checks passed`，表示安裝成功！

---

## 初始化設定

```bash
hermes gateway setup
```

按照互動式提示完成設定：

**選擇 AI 大腦：**

| 選項 | 說明 | 費用 |
|------|------|------|
| Claude Code OAuth | 使用 Claude Pro/Max | 吃月費 |
| OpenAI OAuth | 使用 ChatGPT Plus/Pro | 吃月費 |
| Google AI Studio | Gemma 4 (31B)，**完全免費** | 免費！[申請教學](https://www.koc.com.tw/archives/638001) |
| Nous Portal | MiMo 免費試用 | 免費兩週 |
| 自訂 API Key | OpenRouter 等 | 按用量 |

---

## 啟動 Gateway

```bash
# 前景啟動（可看到日誌）
hermes gateway run

# 背景啟動
hermes gateway start

# 查看狀態
hermes gateway status

# 停止
hermes gateway stop
```

> [!NOTE]
> 在 Mac 上，`hermes gateway start` 會以**背景服務**方式運行，關閉終端機後仍會繼續執行。

---

## Telegram 整合

Mac 上設定 Telegram 最簡單：

**編輯設定檔：**

```bash
# 找到設定檔
nano ~/.hermes/.env
```

**加入以下內容：**

```bash
TELEGRAM_BOT_TOKEN=你的_Bot_Token
TELEGRAM_ALLOWED_USERS=你的_User_ID
```

**儲存後重啟 Gateway：**

```bash
hermes gateway stop
hermes gateway start
```

---

## LINE 整合

LINE 需要 ngrok + Node.js Bridge：

### 安裝 Node.js

```bash
# 使用 Homebrew
brew install node

# 或從官網下載
# https://nodejs.org/
```

### 安裝 ngrok

```bash
brew install ngrok/ngrok/ngrok
```

### 設定 LINE Bridge

```bash
# 複製 .env 範本
cd bridge
cp .env.example .env
nano .env
```

填入你的 LINE 金鑰，然後：

```bash
npm install
npm start
```

### 啟動 ngrok

```bash
ngrok http 3000
```

複製 ngrok 提供的 HTTPS URL（如 `https://xxxx.ngrok-free.app`）

在 LINE Developers Console 設定 Webhook URL：
```
https://xxxx.ngrok-free.app/webhook
```

---

## 設定自動啟動（可選）

讓 HermesAgent 隨 Mac 開機自動啟動：

```bash
# 建立 launchd 設定
cat > ~/Library/LaunchAgents/com.hermes.gateway.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes.gateway</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/hermes</string>
        <string>gateway</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# 載入服務
launchctl load ~/Library/LaunchAgents/com.hermes.gateway.plist
```

---

## 常用指令

```bash
hermes gateway run      # 前景啟動 Gateway
hermes gateway start    # 背景啟動 Gateway
hermes gateway stop     # 停止 Gateway
hermes gateway status   # 查看狀態
hermes chat             # 終端機對話模式
hermes doctor           # 診斷環境
hermes update           # 更新到最新版本
hermes --version        # 查看版本
```

---

> [!TIP]
> Mac 使用者不需要 WSL2，安裝流程比 Windows 更簡單。若你同時有 Mac 和 Windows，建議優先用 Mac 架設！
