# ============================================================
#  ⚡ OpenAI Codex CLI 一鍵安裝精靈
#  作者：曾慶良（阿亮老師）
#  官方 GitHub：https://github.com/openai/codex
#  ⚠️ 請以系統管理員身分執行 PowerShell
# ============================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

function Write-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "  ║                                                      ║" -ForegroundColor Magenta
    Write-Host "  ║   ⚡  OpenAI Codex CLI  一鍵安裝精靈                 ║" -ForegroundColor Magenta
    Write-Host "  ║   由 OpenAI 開發  |  阿亮老師整理                    ║" -ForegroundColor Magenta
    Write-Host "  ║                                                      ║" -ForegroundColor Magenta
    Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
}

function Write-Step($text)  { Write-Host "  [步驟] $text" -ForegroundColor Yellow }
function Write-Ok($text)    { Write-Host "  [完成] ✅ $text" -ForegroundColor Green }
function Write-Err($text)   { Write-Host "  [錯誤] ❌ $text" -ForegroundColor Red }
function Write-Info($text)  { Write-Host "  [資訊] $text" -ForegroundColor Cyan }
function Write-Warn($text)  { Write-Host "  [注意] ⚠️  $text" -ForegroundColor DarkYellow }

function Pause-Script($msg = "  按 Enter 繼續...") {
    Write-Host ""
    Write-Host $msg -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Banner

# 確認管理員
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Err "請以【系統管理員身分】執行！對 go.bat 按右鍵 → 以系統管理員身分執行"
    Pause-Script "  按 Enter 離開..."
    exit 1
}
Write-Ok "系統管理員權限確認"

# ============================================================
#  Step 1：檢查 / 安裝 Node.js
# ============================================================
Write-Host ""
Write-Step "Step 1：檢查 Node.js（Codex CLI 需要 Node.js 22+）"

Refresh-Path
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
$nodeOk = $false

if ($nodeCmd) {
    $nodeVer = & node --version 2>&1
    $nodeMajor = [int]($nodeVer -replace 'v(\d+)\..*','$1')
    if ($nodeMajor -ge 22) {
        Write-Ok "Node.js $nodeVer 已安裝"
        $nodeOk = $true
    } else {
        Write-Warn "Node.js 版本太舊（$nodeVer），需要 v22 以上，準備升級..."
    }
}

if (-not $nodeOk) {
    Write-Step "下載並安裝 Node.js LTS（v22）..."
    $nodeUrl = "https://nodejs.org/dist/v22.13.1/node-v22.13.1-x64.msi"
    $nodeInstaller = Join-Path $env:TEMP "node-installer.msi"

    try {
        Write-Host "  下載中（約 30MB）..." -ForegroundColor DarkGray
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller -UseBasicParsing
        Write-Ok "下載完成，開始安裝..."
        Start-Process msiexec.exe -ArgumentList "/i `"$nodeInstaller`" /qn /norestart" -Wait
        Refresh-Path
        Write-Ok "Node.js 安裝完成"
    } catch {
        Write-Err "自動安裝失敗，請手動安裝 Node.js：https://nodejs.org/"
        Pause-Script "  按 Enter 離開..."
        exit 1
    }
}

# ============================================================
#  Step 2：安裝 Codex CLI
# ============================================================
Write-Host ""
Write-Step "Step 2：安裝 OpenAI Codex CLI"
Write-Info "執行：npm install -g @openai/codex"
Write-Host ""

try {
    & npm install -g @openai/codex
    Write-Ok "Codex CLI 安裝完成"
} catch {
    Write-Err "安裝失敗：$($_.Exception.Message)"
    Pause-Script
    exit 1
}

# ============================================================
#  Step 3：驗證
# ============================================================
Write-Host ""
Write-Step "Step 3：驗證安裝"
Refresh-Path

$codexCmd = Get-Command codex -ErrorAction SilentlyContinue
if ($codexCmd) {
    $ver = & codex --version 2>&1
    Write-Ok "Codex CLI 安裝成功！版本：$ver"
} else {
    Write-Warn "codex 指令尚未在此視窗生效，請重開終端機後再試"
}

# ============================================================
#  完成
# ============================================================
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  🎉 安裝完成！接下來：                               ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  1. 關閉此視窗，重開 PowerShell 或 CMD               ║" -ForegroundColor Green
Write-Host "  ║  2. 進入你的專案目錄：cd 你的專案路徑                ║" -ForegroundColor Green
Write-Host "  ║  3. 輸入：codex                                      ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  💡 設定 AI 大腦（擇一）：                           ║" -ForegroundColor Green
Write-Host "  ║   · ChatGPT Plus/Pro → codex login                  ║" -ForegroundColor Green
Write-Host "  ║   · OpenAI API Key →                                ║" -ForegroundColor Green
Write-Host "  ║     $env:OPENAI_API_KEY = `"sk-...`"                 ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  常用指令：                                          ║" -ForegroundColor Green
Write-Host "  ║   codex              啟動互動模式                    ║" -ForegroundColor Green
Write-Host "  ║   codex `"問題`"       直接下指令                      ║" -ForegroundColor Green
Write-Host "  ║   codex --version    確認版本                        ║" -ForegroundColor Green
Write-Host "  ║   codex login        登入 ChatGPT OAuth              ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  教學：https://hermes-lobster.netlify.app            ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Pause-Script "  按 Enter 離開安裝精靈..."
