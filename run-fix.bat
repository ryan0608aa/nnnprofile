@echo off
REM run-fix.bat — 以系統管理員權限執行 fix-submodule.ps1
cd /d "%~dp0"
echo Running fix-submodule.ps1 with elevated PowerShell...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File "%~dp0fix-submodule.ps1"' -Verb RunAs"
echo.
echo If the script ran, check the PowerShell window for output and copy it here.
echo Press any key to exit...
pause >nul
