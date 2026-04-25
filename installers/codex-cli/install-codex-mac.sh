#!/bin/bash
# ============================================================
#  ⚡ OpenAI Codex CLI 一鍵安裝腳本 (Mac / Linux)
#  作者：曾慶良（阿亮老師）
#  官方 GitHub：https://github.com/openai/codex
# ============================================================

set -e

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║  ⚡  OpenAI Codex CLI  一鍵安裝精靈 (Mac/Linux)      ║"
echo "  ║  由 OpenAI 開發  |  阿亮老師整理                     ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""

# Step 1：檢查 Node.js
echo "  [步驟 1] 檢查 Node.js 版本（需要 v22+）..."
if command -v node &> /dev/null; then
    NODE_VER=$(node --version)
    NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v\([0-9]*\).*/\1/')
    if [ "$NODE_MAJOR" -ge 22 ]; then
        echo "  ✅ Node.js $NODE_VER 已安裝"
    else
        echo "  ⚠️  Node.js 版本太舊（$NODE_VER），需要 v22+"
        echo "  請先升級 Node.js：https://nodejs.org/"
        exit 1
    fi
else
    echo "  ❌ 未安裝 Node.js！請先安裝："
    echo ""
    echo "  Mac（使用 Homebrew）："
    echo "  brew install node@22"
    echo ""
    echo "  或從官網下載：https://nodejs.org/"
    exit 1
fi

# Step 2：安裝 Codex CLI
echo ""
echo "  [步驟 2] 安裝 OpenAI Codex CLI..."
npm install -g @openai/codex
echo "  ✅ 安裝完成"

# Step 3：驗證
echo ""
echo "  [步驟 3] 驗證安裝..."
if command -v codex &> /dev/null; then
    codex --version
    echo "  ✅ Codex CLI 安裝成功！"
else
    echo "  ⚠️  請重新開啟終端機後執行 codex"
fi

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║  🎉 安裝完成！接下來：                               ║"
echo "  ║                                                      ║"
echo "  ║  1. 進入你的專案目錄：cd 你的專案路徑                ║"
echo "  ║  2. 輸入：codex                                      ║"
echo "  ║                                                      ║"
echo "  ║  💡 設定 AI 大腦：                                    ║"
echo "  ║   · ChatGPT Plus → codex login                      ║"
echo "  ║   · API Key → export OPENAI_API_KEY=sk-...          ║"
echo "  ║                                                      ║"
echo "  ║  教學：https://hermes-lobster.netlify.app            ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""
