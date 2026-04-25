#!/bin/bash
# ============================================================
#  🦞🪽 愛馬仕龍蝦 HermesAgent 一鍵安裝腳本 (Mac / Linux)
#  作者：曾慶良（阿亮老師）
#  © 2026 曾慶良 版權所有｜僅供課程學員個人學習使用
# ============================================================

set -e

echo ""
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║  🦞🪽  愛馬仕龍蝦  HermesAgent 一鍵安裝精靈 (Mac)       ║"
echo "  ╠══════════════════════════════════════════════════════════╣"
echo "  ║  作者：曾慶良（阿亮老師）  |  3a01chatgpt@gmail.com      ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo ""

# --- 檢查 macOS ---
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "  ⚠️  此腳本專為 macOS 設計，Linux 請使用官方安裝腳本："
  echo "  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
  echo ""
fi

# --- 安裝 HermesAgent ---
echo "  [Step 1] 安裝 HermesAgent..."
echo "  執行官方安裝腳本（約 3-10 分鐘）..."
echo ""
# 官方新網址優先，失敗自動 fallback 到 GitHub raw
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash || \
  curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

echo ""
echo "  [Step 2] 設定環境..."

# 確認 PATH 包含 hermes
if ! command -v hermes &> /dev/null; then
  echo "  重新載入 shell 設定..."
  if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" 2>/dev/null || true
  elif [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc" 2>/dev/null || true
  fi
fi

echo ""
echo "  [Step 3] 驗證安裝..."
if command -v hermes &> /dev/null; then
  hermes --version
  echo "  ✅ HermesAgent 安裝成功！"
else
  echo "  ⚠️  hermes 指令尚未在此 shell 生效，請關閉並重新開啟終端機"
fi

echo ""
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║  安裝完成！接下來請執行：                                ║"
echo "  ║                                                          ║"
echo "  ║  hermes onboard        ← 選擇 AI 大腦（首次設定）       ║"
echo "  ║  hermes gateway start  ← 背景啟動 Gateway               ║"
echo "  ║  hermes doctor         ← 診斷環境                       ║"
echo "  ║                                                          ║"
echo "  ║  教學網站：https://hermes-lobster.netlify.app            ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo ""
