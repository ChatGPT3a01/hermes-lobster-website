# 什麼是 HermesAgent？

## 官方介紹

**HermesAgent** 是由 [NousResearch](https://nousresearch.com) 開發的開源 AI Agent 框架，採用 MIT 授權。

> 官方 GitHub：[github.com/NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)

它的核心理念是：**一個可以持續自我改進、使用工具、執行長期任務的 AI 代理人平台。**

---

## 三層架構

```
┌─────────────────────────────────────┐
│         擴展生態層                   │
│   skills、MCP、插件、自訂工具        │
├─────────────────────────────────────┤
│         平台能力層                   │
│   CLI、Gateway、排程、設定、權限     │
├─────────────────────────────────────┤
│         Agent 執行層                 │
│   對話循環、工具調度、上下文壓縮     │
└─────────────────────────────────────┘
```

---

## HermesAgent vs 一般 AI 聊天機器人

| 功能 | 一般聊天機器人 | HermesAgent |
|------|--------------|-------------|
| 對話能力 | ✅ | ✅ |
| 長期記憶 | ❌ 通常無 | ✅ 持續累積 |
| 工具使用 | ❌ | ✅ 可呼叫外部工具 |
| 多步驟任務 | ❌ | ✅ 自動規劃執行 |
| 技能擴充 | ❌ | ✅ 支援 MCP、技能包 |
| 自我改進 | ❌ | ✅ RLHF 自我優化循環 |
| 排程任務 | ❌ | ✅ Cron 排程 |
| 本地部署 | 通常無 | ✅ 完全本地運行 |

---

## 支援的 AI 大腦

HermesAgent 使用 **OpenAI 相容 API**，可以接入多種 AI 模型：

| 方案 | 模型 | 費用 | 建議對象 |
|------|------|------|---------|
| **Claude Code OAuth** | Claude 3.5/4 系列 | 吃月費，不另付 | 有 Claude Pro/Max 訂閱 |
| **OpenAI OAuth** | GPT-4o 系列 | 吃月費，不另付 | 有 ChatGPT Plus/Pro 訂閱 |
| **Google AI Studio** | Gemma 4 (31B) | **完全免費** | 沒有訂閱、想免費用強模型 |
| **Nous Portal** | MiMo（免費） | 免費兩週 | 想先試用 |
| **OpenRouter** | 多種模型 | 按用量付費 | 有 API Key |
| **Ollama** | Llama、Gemma 等 | 免費（本地） | 想完全離線 |

> [!TIP]
> 有 **Claude Pro** 或 **ChatGPT Plus** 訂閱選 OAuth 方案最划算。沒有訂閱？**Google AI Studio + Gemma 4 (31B) 完全免費**，效果也很強！  
> 申請教學：[Google AI Studio 免費 API Key 申請](https://www.koc.com.tw/archives/638001)

---

## 核心功能介紹

### Gateway 模式

HermesAgent 以「Gateway」模式運行，提供：
- **OpenAI 相容 REST API**（Port 8642）
- 支援 Telegram Polling 自動接收訊息
- 支援 LINE Webhook（透過 Bridge 轉接）

### 技能系統（Skills）

可以用 Markdown 定義工具能力，讓 Agent 擁有各種技能：
- 查詢天氣、股票
- 搜尋網路
- 控制系統程式
- 整合 Google Calendar、Notion 等

### 長期記憶

每個使用者都有獨立的對話記憶，AI 會記住你的偏好、習慣和過去對話內容。

### 自我改進循環

HermesAgent 支援 **RLHF（人類反饋強化學習）**，可以根據你的反饋不斷優化表現。

---

## 適合與不適合的場景

| ✅ 適合 | ❌ 不適合 |
|---------|----------|
| 多步驟自動化工作流 | 需要毫秒級即時回應 |
| 長期持續使用（記憶積累） | 替代確定性核心商業邏輯 |
| 跨平台多入口（Telegram/LINE） | 無邊界高權限全自動執行 |
| 定期自動化任務（Cron） | |
| 整合多個外部系統（MCP） | |
| 教育、研究、個人助理 | |

---

## 版本資訊

- 目前穩定版：**v0.8.0**（2025年）
- 授權：MIT License
- 開發：NousResearch
- 官網：[hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com)
