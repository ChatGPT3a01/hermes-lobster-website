#!/bin/bash
# ============================================================
#  🦞🪽 愛馬仕龍蝦 HermesAgent 一鍵安裝腳本 (Mac / Linux)  V6.53
#  作者：曾慶良（阿亮老師）
#  © 2026 曾慶良 版權所有｜僅供課程學員個人學習使用
#
#  V6.53（2026-05）：對齊官方 setup 指令、移除舊 onboard 用法
# ============================================================

set -e

echo ""
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║  🦞🪽  愛馬仕龍蝦  HermesAgent 一鍵安裝精靈 (Mac) V6.53 ║"
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
echo "  ║  hermes setup          ← 選擇 AI 大腦（首次設定）       ║"
echo "  ║  hermes gateway start  ← 背景啟動 Gateway               ║"
echo "  ║  hermes doctor         ← 診斷環境                       ║"
echo "  ║  hermes --tui          ← 啟動互動式 TUI 介面            ║"
echo "  ║                                                          ║"
echo "  ║  教學網站：https://hermes-lobster.netlify.app            ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo ""
