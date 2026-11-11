@echo off
title Daily Semiconductor Career Scanner - Gudla Sohan
color 0b
echo ==============================================================================
echo           RUNNING DAILY SEMICONDUCTOR CAREER SCANNER FOR GUDLA SOHAN
echo ==============================================================================
echo Target Roles : RTL Design, Design Verification (DV), FPGA, Embedded Firmware
echo Companies    : 200+ Companies (Tier 1 MNC Giants, Tier 2 VLSI Services, Tier 3 Startups)
echo Candidate    : B.Tech ECE (CGPA: 8.8 / 10), Amrita Vishwa Vidyapeetham | Hyderabad
echo ==============================================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Daily_Job_Hunter.ps1"

echo.
echo ==============================================================================
echo Opening Daily Career Dashboard in your browser...
echo ==============================================================================
start "" "%~dp0Daily_Career_Report.html"
exit /b 0
