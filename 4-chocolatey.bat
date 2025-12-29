@echo off
chcp 65001 >nul
setlocal

:: Check for admin privileges
openfiles >nul 2>&1
if ERRORLEVEL 1 (
    echo ERROR: This script requires Administrator privileges.
    echo Please run this script as Administrator.
    pause
    exit /b 1
)

:: Check if choco is already installed
where choco >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Chocolatey is already installed.
    choco --version
    pause
    exit /b 0
)

echo Installing Chocolatey...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Set-ExecutionPolicy Bypass -Scope Process -Force; ^
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; ^
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

if ERRORLEVEL 1 (
    echo ERROR: Chocolatey installation failed.
    pause
    exit /b 1
)

echo Chocolatey installed successfully!
choco --version

pause
exit /b 0
