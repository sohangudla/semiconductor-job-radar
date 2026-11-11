@echo off
title Configure Daily Semiconductor Job Radar
color 0a
echo ==============================================================================
echo      ENABLING AUTOMATIC DAILY SCAN (WINDOWS TASK SCHEDULER)
echo ==============================================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Register_Daily_Task.ps1"
echo.
pause
