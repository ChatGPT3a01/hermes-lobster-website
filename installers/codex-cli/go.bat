@echo off
chcp 65001 >nul 2>&1
echo.
echo  正在以系統管理員身分啟動 Codex CLI 安裝精靈...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0install-codex.ps1""' -Verb RunAs"
