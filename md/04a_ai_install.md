# 🤖 AI Agent 自動安裝（進階）

> 讓 AI 代理人幫你裝！把安裝精靈交給 Claude Code 或 Codex CLI 全自動執行，你只要看著就好。

---

## 什麼是 Agent-driven development 安裝模式？

傳統安裝：你自己一步一步跟著教學做
**Agent 安裝模式**：你把資料夾交給 AI，下一道指令，AI 自己讀腳本、執行、排錯、完成安裝 ✨

這是最接近「魔法」的安裝方式——特別適合已安裝 Claude Code 或 Codex CLI 的使用者。

---

## 前置條件

在使用此方式前，請確認已完成：

| 條件 | 說明 |
|------|------|
| ✅ 下載安裝精靈 | 點頁面頂部「⬇ Win 安裝精靈」下載並解壓縮 |
| ✅ 已安裝 Claude Code | 見左側「🔶 Claude Code」教學 |
| ✅ 或已安裝 Codex CLI | 見左側「⚡ Codex CLI」教學 |
| ✅ 開啟終端機 | PowerShell 或 CMD，cd 進安裝精靈資料夾 |

---

## 使用方法

### Step 1：cd 進安裝精靈資料夾

```powershell
cd C:\你解壓縮的路徑\HermesAgent一鍵自動安裝程式
```

### Step 2：啟動 AI（擇一）

**Claude Code（推薦）：**
```powershell
claude
```

**Codex CLI：**
```powershell
codex
```

### Step 3：貼上這段提示詞，送出

<div style="background:#1e1e2e;border-radius:12px;padding:24px 28px;margin:24px 0;border:2px solid #7c3aed;">
  <div style="color:#a78bfa;font-size:12px;font-weight:600;letter-spacing:1px;margin-bottom:12px;">📋 AI 自動安裝提示詞（點複製按鈕）</div>
  <div style="color:#e2e8f0;font-size:16px;line-height:1.8;font-family:monospace;">
    【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
  </div>
</div>

```
【依據資料夾中的腳本，以"Agent-driven development"模式協助我安裝】
```

> [!TIP]
> 上方程式碼區塊右上角有「複製」按鈕，點一下直接複製提示詞！

---

## AI 會幫你做什麼？

送出提示詞後，AI 會自動：

1. 📂 讀取資料夾中的所有安裝腳本（`install-hermes.ps1`、`go.bat` 等）
2. 🔍 分析你的系統環境（Windows 版本、已安裝的工具）
3. ⚙️ 依序執行安裝步驟
4. 🐛 遇到錯誤自動排除，繼續安裝
5. ✅ 完成後報告安裝結果

整個過程你只需要：
- 偶爾確認 AI 要執行的指令（按 Enter 或 y）
- 在需要輸入憑證時（LINE Token 等）提供資料

---

## 適合誰使用？

| 使用者類型 | 建議 |
|-----------|------|
| 完全新手 | ➡ 用「🪟 Windows 一鍵安裝精靈」更簡單 |
| 有 Claude Code / Codex CLI | ✅ **這個方式最省力** |
| 遇到安裝錯誤卡住 | ✅ AI 自動排錯，適合救援 |
| 想自訂安裝流程 | ✅ 可以跟 AI 對話調整 |

---

## 搭配 SKILL 知識庫（推薦）

下載愛馬仕龍蝦 SKILL 知識庫後，AI 會更了解整個安裝系統：

> ⬇️ **[愛馬仕龍蝦安裝 SKILL 與知識庫下載](HermesLobster-SKILL.zip)**

解壓縮到同一個資料夾後，AI 在分析時會讀取這些知識，回答更精準、排錯更快。

---

> [!NOTE]
> 如果 AI 問「請問您希望先安裝哪個部分？」——直接說「全部安裝」或根據需要告訴它。整個安裝過程可以跟 AI 對話，隨時問問題！
