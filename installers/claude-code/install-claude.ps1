# ============================================================
#  🤖 Claude Code CLI 一鍵安裝精靈
#  作者：曾慶良（阿亮老師）
#  官方安裝頁：https://claude.ai/code
#  ⚠️ 請以系統管理員身分執行 PowerShell
# ============================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

function Write-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                                                      ║" -ForegroundColor Cyan
    Write-Host "  ║   🤖  Claude Code CLI  一鍵安裝精靈                  ║" -ForegroundColor Cyan
    Write-Host "  ║   由 Anthropic 開發  |  阿亮老師整理                 ║" -ForegroundColor Cyan
    Write-Host "  ║                                                      ║" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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

# ============================================================
#  Step 0：確認系統管理員
# ============================================================
Write-Banner

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Err "請以【系統管理員身分】執行此腳本！"
    Write-Info "對 go.bat 按右鍵 → 以系統管理員身分執行"
    Pause-Script "  按 Enter 離開..."
    exit 1
}
Write-Ok "系統管理員權限確認"

# ============================================================
#  Step 1：安裝 Git for Windows（Claude Code 必要前置）
# ============================================================
Write-Host ""
Write-Step "Step 1：檢查 Git for Windows（Claude Code 的必要前置）"
Write-Host ""

$gitPath = "C:\Program Files\Git\bin\bash.exe"
$gitInstalled = (Get-Command git -ErrorAction SilentlyContinue) -or (Test-Path $gitPath)

if ($gitInstalled) {
    Write-Ok "Git 已安裝，略過此步驟"
} else {
    Write-Warn "Git 尚未安裝！Claude Code 在 Windows 上需要 Git Bash 才能運作。"
    Write-Info "正在下載 Git for Windows 安裝程式..."
    Write-Host ""

    $gitInstaller = Join-Path $env:TEMP "git-installer.exe"
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/Git-2.47.1.2-64-bit.exe"

    try {
        Write-Host "  下載中（約 60MB）..." -ForegroundColor DarkGray
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing
        Write-Ok "下載完成"
        Write-Step "啟動 Git 安裝程式（全部按預設「Next」即可）..."
        Start-Process $gitInstaller -ArgumentList "/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS=`"icons,ext\reg\shellhere,assoc,assoc_sh`"" -Wait
        Write-Ok "Git 安裝完成"
        Refresh-Path
    } catch {
        Write-Err "自動下載失敗，請手動安裝 Git："
        Write-Host "  → https://git-scm.com/downloads/win" -ForegroundColor White
        Write-Host "  → 安裝完成後重新執行此腳本" -ForegroundColor White
        Pause-Script "  按 Enter 離開..."
        exit 1
    }
}

# ============================================================
#  Step 2：安裝 Claude Code CLI
# ============================================================
Write-Host ""
Write-Step "Step 2：安裝 Claude Code CLI"
Write-Info "使用官方原生安裝方式（不需要 Node.js）"
Write-Host ""

try {
    $installScript = Invoke-RestMethod "https://claude.ai/install.ps1"
    Invoke-Expression $installScript
    Write-Ok "Claude Code 安裝完成"
} catch {
    Write-Err "安裝失敗：$($_.Exception.Message)"
    Write-Info "請手動執行：irm https://claude.ai/install.ps1 | iex"
    Pause-Script
    exit 1
}

# ============================================================
#  Step 3：修復 PATH
# ============================================================
Write-Host ""
Write-Step "Step 3：更新 PATH 環境變數"

Refresh-Path

# 常見安裝路徑列表
$possiblePaths = @(
    "$env:LOCALAPPDATA\Programs\claude-code",
    "$env:LOCALAPPDATA\claude-code",
    "$env:APPDATA\claude-code",
    "$env:USERPROFILE\.claude\bin",
    "$env:USERPROFILE\AppData\Local\Programs\claude-code"
)

$claudeExe = $null
foreach ($p in $possiblePaths) {
    $candidate = Join-Path $p "claude.exe"
    if (Test-Path $candidate) {
        $claudeExe = $candidate
        Write-Ok "找到 claude.exe：$candidate"

        # 確保路徑在 PATH 中
        $userPath = [System.Environment]::GetEnvironmentVariable("Path","User")
        if ($userPath -notlike "*$p*") {
            [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$p", "User")
            Write-Ok "已將安裝路徑加入 PATH"
        }
        Refresh-Path
        break
    }
}

if (-not $claudeExe) {
    # 全系統搜尋
    Write-Info "在常見路徑找不到，進行全域搜尋..."
    $found = Get-ChildItem -Path $env:LOCALAPPDATA -Recurse -Filter "claude.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $claudeExe = $found.FullName
        $dirPath = $found.DirectoryName
        Write-Ok "找到 claude.exe：$claudeExe"
        $userPath = [System.Environment]::GetEnvironmentVariable("Path","User")
        if ($userPath -notlike "*$dirPath*") {
            [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$dirPath", "User")
            Write-Ok "已將安裝路徑加入 PATH"
        }
        Refresh-Path
    }
}

# ============================================================
#  Step 4：設定 Git Bash 路徑（Claude Code 需要）
# ============================================================
Write-Host ""
Write-Step "Step 4：設定 Git Bash 路徑"

$gitBashPaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe"
)

foreach ($gbp in $gitBashPaths) {
    if (Test-Path $gbp) {
        [System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", $gbp, "User")
        Write-Ok "Git Bash 路徑已設定：$gbp"
        break
    }
}

# ============================================================
#  Step 5：驗證安裝
# ============================================================
Write-Host ""
Write-Step "Step 5：驗證安裝"
Refresh-Path

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeCmd) {
    $version = & claude --version 2>&1
    Write-Ok "Claude Code 安裝成功！版本：$version"
} elseif ($claudeExe) {
    $version = & "$claudeExe" --version 2>&1
    Write-Ok "Claude Code 安裝成功！版本：$version"
    Write-Warn "PATH 需要重開終端機才會生效"
} else {
    Write-Warn "claude 指令尚未在此視窗生效，請重開終端機後再試"
}

# ============================================================
#  完成
# ============================================================
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  🎉 安裝完成！接下來的步驟：                         ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  1. 關掉此視窗，重新開一個 PowerShell 或 CMD         ║" -ForegroundColor Green
Write-Host "  ║  2. 在新視窗輸入：claude                             ║" -ForegroundColor Green
Write-Host "  ║  3. 首次使用會引導你登入 Claude.ai 帳號              ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  💡 登入方式：                                        ║" -ForegroundColor Green
Write-Host "  ║   · 有 Claude Pro/Max → 選 Login with Claude.ai     ║" -ForegroundColor Green
Write-Host "  ║   · 有 Anthropic API Key → 選 API Key               ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  常用指令：                                          ║" -ForegroundColor Green
Write-Host "  ║   claude            啟動互動模式                     ║" -ForegroundColor Green
Write-Host "  ║   claude --version  確認版本                         ║" -ForegroundColor Green
Write-Host "  ║   claude doctor     診斷環境                         ║" -ForegroundColor Green
Write-Host "  ║   claude update     更新版本                         ║" -ForegroundColor Green
Write-Host "  ║                                                      ║" -ForegroundColor Green
Write-Host "  ║  教學網站：https://hermes-lobster.netlify.app        ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Pause-Script "  按 Enter 離開安裝精靈..."
