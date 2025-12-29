@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Installing Dependencies via Chocolatey
echo ========================================
echo.

REM === Disable Chocolatey pause
set "CHOCO_FORCE=1"
set "ChocolateyAllowPauseScript=false"

REM === Install unpaper ===
echo Checking for unpaper...
where unpaper >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo unpaper is already installed.
) else (
    echo Installing unpaper via Chocolatey...
    choco install unpaper -y --no-progress
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install unpaper.
    ) else (
        echo unpaper installed successfully.
    )
)
echo.

REM === Install pngquant ===
echo Checking for pngquant...
where pngquant >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo pngquant is already installed.
) else (
    echo Installing pngquant via Chocolatey...
    choco install pngquant -y --no-progress --confirm
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install pngquant.
    ) else (
        echo pngquant installed successfully.
    )
)
echo.

REM === Install Ghostscript (last) ===
echo Checking for Ghostscript...
where gswin64c >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ghostscript is already installed.
) else (
    echo Installing Ghostscript via Chocolatey...
    choco install ghostscript -y --no-progress --confirm
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install Ghostscript.
    ) else (
        echo Ghostscript installed successfully.
    )
)
echo.

echo ========================================
echo All package installations complete.
echo ========================================
pause
exit /b 0
