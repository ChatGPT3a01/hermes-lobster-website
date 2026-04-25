# -*- coding: utf-8 -*-
"""
HermesAgent Teaching Website - Build Script
Reads all MD files -> generates data/units.js
Run: py -3 build.py
"""
import os
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MD_DIR   = os.path.join(BASE_DIR, 'md')
OUT_FILE = os.path.join(BASE_DIR, 'data', 'units.js')

UNITS = [
    # ── 首頁 / 介紹 ──────────────────────────────────────────────
    {
        'id':         'home',
        'folder':     'md',
        'file':       '01_home.md',
        'title':      '🦞🪽 愛馬仕龍蝦 HermesAgent 一鍵安裝與手動安裝教學',
        'shortTitle': '🏠 首頁',
        'parent':     None,
        'isGroup':    False,
    },
    {
        'id':         'what-is-hermes',
        'folder':     'md',
        'file':       '02_what_is_hermes.md',
        'title':      '什麼是 HermesAgent？',
        'shortTitle': '🤖 認識 Hermes',
        'parent':     None,
        'isGroup':    False,
    },
    {
        'id':         'use-cases',
        'folder':     'md',
        'file':       '03_use_cases.md',
        'title':      '使用情境與應用場景',
        'shortTitle': '💡 使用情境',
        'parent':     None,
        'isGroup':    False,
    },
    {
        'id':         'generators',
        'folder':     'md',
        'file':       '04b_generators.md',
        'title':      '🛠 生成器工具',
        'shortTitle': '🛠 生成器工具',
        'parent':     None,
        'isGroup':    False,
    },

    # ── 一鍵安裝教學 ────────────────────────────────────────────
    {
        'id':         'install-group',
        'folder':     None,
        'file':       None,
        'title':      '一鍵安裝教學',
        'shortTitle': '🚀 一鍵安裝教學',
        'parent':     None,
        'isGroup':    True,
    },
    {
        'id':         'ai-install',
        'folder':     'md',
        'file':       '04a_ai_install.md',
        'title':      'AI Agent 自動安裝（進階）',
        'shortTitle': '🤖 AI 自動安裝',
        'parent':     'install-group',
        'isGroup':    False,
    },
    {
        'id':         'install-windows',
        'folder':     'md',
        'file':       '04_install_windows.md',
        'title':      'Windows 安裝教學',
        'shortTitle': '🪟 Windows',
        'parent':     'install-group',
        'isGroup':    False,
    },
    {
        'id':         'install-mac',
        'folder':     'md',
        'file':       '05_install_mac.md',
        'title':      'Mac 安裝教學',
        'shortTitle': '🍎 Mac / Linux',
        'parent':     'install-group',
        'isGroup':    False,
    },

    # ── 手動安裝教學 ────────────────────────────────────────────
    {
        'id':         'manual-group',
        'folder':     None,
        'file':       None,
        'title':      '手動安裝教學',
        'shortTitle': '📘 手動安裝教學',
        'parent':     None,
        'isGroup':    True,
    },
    {
        'id':         'manual-overview',
        'folder':     'md',
        'file':       'manual_00_overview.md',
        'title':      '手動安裝總覽',
        'shortTitle': '📘 總覽',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step1-hermes',
        'folder':     'md',
        'file':       'manual_01_hermes.md',
        'title':      'Step 1：安裝 HermesAgent',
        'shortTitle': '1️⃣ 裝 Hermes',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step2-line',
        'folder':     'md',
        'file':       'manual_02_line.md',
        'title':      'Step 2：申請 LINE Messaging API',
        'shortTitle': '2️⃣ 申請 LINE',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step3-bridge',
        'folder':     'md',
        'file':       'manual_03_bridge.md',
        'title':      'Step 3：部署 LINE Bridge',
        'shortTitle': '3️⃣ 部署 Bridge',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step4-ngrok',
        'folder':     'md',
        'file':       'manual_04_ngrok.md',
        'title':      'Step 4：設定 ngrok',
        'shortTitle': '4️⃣ ngrok',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step5-codex',
        'folder':     'md',
        'file':       'manual_05_codex.md',
        'title':      'Step 5：Codex 訂閱設定',
        'shortTitle': '5️⃣ Codex 訂閱',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step6-advanced',
        'folder':     'md',
        'file':       'manual_06_advanced.md',
        'title':      'Step 6：進階功能設定',
        'shortTitle': '6️⃣ 進階功能',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-memory',
        'folder':     'md',
        'file':       'manual_06a_memory.md',
        'title':      '對話記憶持久化設置',
        'shortTitle': '🧠 記憶設置',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-soul',
        'folder':     'md',
        'file':       'manual_06b_soul.md',
        'title':      '靈魂與人格設置（SOUL.md）',
        'shortTitle': '🎭 靈魂人格設置',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-image',
        'folder':     'md',
        'file':       'manual_06c_image.md',
        'title':      '自拍生圖（fal.ai flux-pulid）',
        'shortTitle': '📸 自拍生圖',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-step7-skills',
        'folder':     'md',
        'file':       'manual_07_skills.md',
        'title':      'Step 7：安裝 Skills 技能包',
        'shortTitle': '7️⃣ 裝 Skill',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-telegram',
        'folder':     'md',
        'file':       'manual_98_telegram.md',
        'title':      'Telegram 手動設定版',
        'shortTitle': '✈️ Telegram 手動版',
        'parent':     'manual-group',
        'isGroup':    False,
    },
    {
        'id':         'manual-troubleshoot',
        'folder':     'md',
        'file':       'manual_99_troubleshoot.md',
        'title':      '排錯清單',
        'shortTitle': '🐛 排錯清單',
        'parent':     'manual-group',
        'isGroup':    False,
    },

    # ── 通訊平台整合 ────────────────────────────────────────────
    {
        'id':         'platform-group',
        'folder':     None,
        'file':       None,
        'title':      '通訊平台整合',
        'shortTitle': '💬 平台整合',
        'parent':     None,
        'isGroup':    True,
    },
    {
        'id':         'telegram',
        'folder':     'md',
        'file':       '06_telegram.md',
        'title':      'Telegram 機器人設定',
        'shortTitle': '✈️ Telegram 速查',
        'parent':     'platform-group',
        'isGroup':    False,
    },
    {
        'id':         'line',
        'folder':     'md',
        'file':       '07_line.md',
        'title':      'LINE 機器人設定',
        'shortTitle': '💚 LINE Bot',
        'parent':     'platform-group',
        'isGroup':    False,
    },

    # ── 三強 AI CLI 工具 ────────────────────────────────────────
    {
        'id':         'ai-cli-group',
        'folder':     None,
        'file':       None,
        'title':      '三強 AI CLI 工具',
        'shortTitle': '🤖 三強 CLI',
        'parent':     None,
        'isGroup':    True,
    },
    {
        'id':         'codex-cli',
        'folder':     'md',
        'file':       '10_codex_cli.md',
        'title':      'OpenAI Codex CLI 安裝教學',
        'shortTitle': '⚡ Codex CLI',
        'parent':     'ai-cli-group',
        'isGroup':    False,
    },
    {
        'id':         'claude-cli',
        'folder':     'md',
        'file':       '11_claude_cli.md',
        'title':      'Claude Code CLI 安裝教學',
        'shortTitle': '🔶 Claude Code',
        'parent':     'ai-cli-group',
        'isGroup':    False,
    },
    {
        'id':         'ollama-free',
        'folder':     'md',
        'file':       '12_ollama_free.md',
        'title':      'Ollama 免費方案完整教學',
        'shortTitle': '🦙 Ollama 免費方案',
        'parent':     'ai-cli-group',
        'isGroup':    False,
    },

    # ── 啟動指南 / 指令速查 / 好書 ────────────────────────────────
    {
        'id':         'start-guide',
        'folder':     'md',
        'file':       'start_guide.md',
        'title':      '每次啟動愛馬仕龍蝦',
        'shortTitle': '▶️ 啟動指南',
        'parent':     None,
        'isGroup':    False,
    },
    {
        'id':         'commands',
        'folder':     'md',
        'file':       '08_commands.md',
        'title':      '常用指令參考',
        'shortTitle': '⌨️ 指令速查',
        'parent':     None,
        'isGroup':    False,
    },
    {
        'id':         'book',
        'folder':     'md',
        'file':       '09_book.md',
        'title':      '推薦好書：AI 龍蝦管家',
        'shortTitle': '📚 推薦好書',
        'parent':     None,
        'isGroup':    False,
    },
]


def build():
    os.makedirs(os.path.join(BASE_DIR, 'data'), exist_ok=True)

    result = []
    for u in UNITS:
        entry = dict(u)
        if u.get('isGroup') or not u.get('file'):
            entry['content'] = ''
        else:
            md_path = os.path.join(BASE_DIR, u['folder'], u['file'])
            if os.path.exists(md_path):
                with open(md_path, 'r', encoding='utf-8') as f:
                    entry['content'] = f.read()
                print('OK  ' + u['file'])
            else:
                print('MISS ' + md_path)
                entry['content'] = '# 內容尚未建立'
        result.append(entry)

    js = 'const UNITS_DATA = ' + json.dumps(result, ensure_ascii=False, indent=2) + ';\n'
    with open(OUT_FILE, 'w', encoding='utf-8') as f:
        f.write(js)
    print('\nDone -> ' + OUT_FILE)
    content_units = [u for u in UNITS if not u.get('isGroup')]
    print('Units: ' + str(len(content_units)) + ' pages')


if __name__ == '__main__':
    build()
