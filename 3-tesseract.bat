@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: === Config ===
set "WANTED=5.5.0"
set "URL=https://github.com/tesseract-ocr/tesseract/releases/download/5.5.0/tesseract-ocr-w64-setup-5.5.0.20241111.exe"
set "INSTALLER=tesseract-installer.exe"
set "TESSDIR=C:\Program Files\Tesseract-OCR"

:: === Step 1: Detect Installed Version ===
set "INST="
for /f "tokens=2 delims= " %%V in ('tesseract --version 2^>nul') do (
  set "INST=%%V"
  goto :gotVersion
)
:gotVersion

if "!INST!"=="%WANTED%" (
  echo Tesseract %WANTED% is already installed.
  goto :ensurePath
)

echo Installing/updating Tesseract to version %WANTED%...
echo Downloading installer...
curl -L -o "%INSTALLER%" "%URL%"

echo Launching installer GUI (click through)...
start /wait "" "%INSTALLER%"

del "%INSTALLER%"

:: === Step 2: Ensure System PATH ===
:ensurePath
echo.
echo Ensuring "%TESSDIR%" is in the system PATH...

:: Read current system PATH into sysPath variable (REG_EXPAND_SZ)
for /f "skip=2 tokens=2,*" %%A in ('
  reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path
') do set "sysPath=%%B"

:: Check if TESSDIR is already in PATH
echo !sysPath! | find /I "%TESSDIR%" >nul
if ERRORLEVEL 1 (
    echo Adding "%TESSDIR%" to system PATH...
    set "newPath=!sysPath!;%TESSDIR%"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "!newPath!" /f >nul
    echo PATH updated. You may need to log off/on for it to take effect.
) else (
    echo "%TESSDIR%" is already in system PATH.
)

echo.
echo Done. Press any key to close.
pause >nul
exit /b 0
