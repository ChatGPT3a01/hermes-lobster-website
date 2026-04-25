#!/bin/bash
# ============================================================
#  🤖 Claude Code CLI 一鍵安裝腳本 (Mac / Linux)
#  作者：曾慶良（阿亮老師）
#  官方：https://claude.ai/code
# ============================================================

set -e

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║  🤖  Claude Code CLI  一鍵安裝精靈 (Mac/Linux)       ║"
echo "  ║  由 Anthropic 開發  |  阿亮老師整理                  ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""

# Step 1：安裝 Claude Code
echo "  [步驟 1] 安裝 Claude Code CLI（官方原生安裝）..."
echo ""
curl -fsSL https://claude.ai/install.sh | bash

echo ""
echo "  [步驟 2] 重新載入 PATH..."
export PATH="$HOME/.local/bin:$PATH"

# 嘗試 source shell 設定
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" 2>/dev/null || true
elif [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc" 2>/dev/null || true
fi

echo ""
echo "  [步驟 3] 驗證安裝..."
if command -v claude &> /dev/null; then
    claude --version
    echo ""
    echo "  ✅ Claude Code 安裝成功！"
else
    echo "  ⚠️  claude 指令尚未生效，請關閉並重新開啟終端機"
fi

echo ""
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║  🎉 安裝完成！接下來：                               ║"
echo "  ║                                                      ║"
echo "  ║  1. 關閉此終端機，重新開一個新的                     ║"
echo "  ║  2. 輸入：claude                                     ║"
echo "  ║  3. 首次使用引導登入 Claude.ai 帳號                  ║"
echo "  ║                                                      ║"
echo "  ║  💡 登入方式：                                        ║"
echo "  ║   · Claude Pro/Max → Login with Claude.ai           ║"
echo "  ║   · Anthropic API Key → 選 API Key                  ║"
echo "  ║                                                      ║"
echo "  ║  常用指令：                                          ║"
echo "  ║   claude            啟動互動模式                     ║"
echo "  ║   claude --version  確認版本                         ║"
echo "  ║   claude doctor     診斷環境                         ║"
echo "  ║   claude update     更新版本                         ║"
echo "  ║                                                      ║"
echo "  ║  教學：https://hermes-lobster.netlify.app            ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo ""
