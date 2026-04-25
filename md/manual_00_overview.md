# 📘 手動安裝完整教學（無 AI 協助版）

> 本章節專為**完全不使用 AI 協助**的學員設計。
> 每個指令都給你抄、每個欄位都告訴你填什麼，跟著做一定會成功。

---

## 為什麼要學手動安裝？

很多同學用 AI 幫忙安裝，遇到問題 AI 幫忙修復，結果**自己完全不知道做了什麼**。離開 AI 就動不了。

這套教學反過來：**每一步你都親手做一次**，理解原理、記住指令、踩過坑。以後遇到類似狀況自己就能解。

---

## 你會學到什麼？

跟完整個流程，你會擁有一個**完整運作的 LINE Bot**，功能包含：

| 功能 | 說明 |
|------|------|
| ✅ ChatGPT Plus 訂閱對話 | 在 LINE 聊天，吃你的訂閱額度，**不額外付 API 費** |
| ✅ 對話記憶 | 每個使用者獨立記憶，電腦重開也不會忘 |
| ✅ 副人格（例：虛擬女友小勳） | 關鍵字觸發切換，獨立記憶不混淆 |
| ✅ 自拍生圖 | fal.ai Flux PuLID 生成保留人物一致性的照片 |
| ✅ 75 個技能 Skill | Google、OpenAI 官方 + 阿亮老師舊 OpenClaw 累積 |

---

## 時間估計

| 階段 | 時間 |
|------|------|
| 前置工具安裝（Node、Git、Python、ngrok）| 20 分 |
| Step 1：HermesAgent 本體 | 15 分 |
| Step 2：申請 LINE Bot | 10 分 |
| Step 3：部署 LINE Bridge | 10 分 |
| Step 4：ngrok 隧道 | 10 分 |
| Step 5：啟用 ChatGPT Plus 訂閱模式 | 10 分 |
| Step 6：記憶／副人格／自拍 | 30 分 |
| Step 7：安裝 75 個 Skill | 15 分 |
| **總計** | **約 2 小時** |

> [!TIP]
> 建議分 2 天做：第一天 Step 1-4（能在 LINE 跟 Bot 對話），第二天 Step 5-7（加值功能）。

---

## 整體架構圖

```
你的手機 LINE app
    ↓ 訊息
LINE Platform 伺服器
    ↓ Webhook
ngrok 公開 HTTPS URL
    ↓ 隧道
你電腦的 LINE Bridge（Port 3000，Node.js）
    ↓
codex exec（ChatGPT Plus 訂閱）
    ↓ 回覆文字
    ↓ 或 fal.ai flux-pulid 生圖
LINE Bridge 打包成 LINE 訊息
    ↓ Reply API
LINE Platform
    ↓
你的手機收到 Bot 回覆
```

---

## 開始前的準備清單

請確認你有：

- [ ] Windows 10/11 64-bit 電腦（建議 16GB RAM、50GB 可用磁碟）
- [ ] 系統管理員權限
- [ ] 穩定網路
- [ ] LINE 個人帳號（加 Bot 為好友用）
- [ ] **ChatGPT Plus 或 Pro 訂閱**（Step 5 必備；若沒有，最後會教你改用 OpenAI API Key 或免費 Gemini）

> [!WARNING]
> 本教學針對 **Windows 11** 撰寫。Mac 使用者請參考「Mac 安裝教學」章節，指令語法略有不同。

---

## 安裝後的檔案分布

```
C:\Users\<你的使用者名>\
├── AppData\Local\hermes\
│   └── hermes-agent\              ← HermesAgent 本體（venv + 程式碼）
├── .hermes\                       ← 你的個人設定
│   ├── .env                       ← API Key、環境變數
│   ├── SOUL.md                    ← 主人格人設
│   └── skills\                    ← 75 個 Skill
├── .codex\                        ← Codex CLI 設定
│   ├── auth.json                  ← ChatGPT Plus OAuth token
│   └── skills\                    ← Codex 用的 Skill
└── AppData\Roaming\npm\           ← npm global CLI
    ├── codex.ps1
    ├── agent-browser.ps1
    └── netlify.ps1

C:\OpenClaw_Auto\                  ← 整個專案放在這裡
├── HermesAgent一鍵自動安裝程式\
│   └── bridge\                    ← LINE Bridge（Node.js）
│       ├── line-bridge.js         ← 主程式
│       ├── .env                   ← LINE 憑證、AI 模式
│       ├── personas\              ← 人格資料夾
│       │   ├── main\SOUL.md
│       │   └── xiaoxun\
│       │       ├── SOUL.md
│       │       └── refs.json      ← 小勳參考圖 URL
│       └── memory\                ← 對話歷史（每人格＋每人獨立）
│           ├── main__Uxxx.json
│           └── xiaoxun__Uxxx.json
└── 龍蝦資料.txt                   ← 個人憑證備忘錄
```

---

## 遇到問題怎麼辦？

1. **先看「常見錯誤與排解」章節** — 90% 的錯誤都列在那裡
2. Google 搜尋錯誤訊息前幾行
3. 問阿亮老師的 Facebook 社團（看首頁連結）

> [!NOTE]
> 接下來從「Step 1」開始做。**不要跳章節**！每一步都會用到前一步的東西。
