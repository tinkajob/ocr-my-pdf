@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM === Config ===
set "LATEST_VERSION=3.13.5"
set "INSTALLER_URL=https://www.python.org/ftp/python/%LATEST_VERSION%/python-%LATEST_VERSION%-amd64.exe"
set "INSTALLER_FILE=python-installer.exe"

REM === Check installed Python ===
echo ========================================
echo        Python Installation Check
echo ========================================
echo Checking for installed Python...

set "INSTALLED_VERSION="

where python >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=2 delims= " %%V in ('python --version 2^>nul') do (
        set "INSTALLED_VERSION=%%V"
    )
)

if "!INSTALLED_VERSION!"=="%LATEST_VERSION%" (
    echo Python %LATEST_VERSION% is already installed.
    echo Upgrading pip...
    python -m pip install --upgrade pip
    echo Done.
    pause
    exit /b 0
)

echo Python not found or outdated (installed: !INSTALLED_VERSION!). Proceeding with installation.

if exist "%INSTALLER_FILE%" del /f /q "%INSTALLER_FILE%"

REM === Download installer ===
echo Downloading Python %LATEST_VERSION%...
curl -L -o "%INSTALLER_FILE%" "%INSTALLER_URL%"
if not exist "%INSTALLER_FILE%" (
    echo ERROR: Failed to download installer.
    pause
    exit /b 1
)

REM === Run GUI installer ===
echo Launching Python installer (GUI). Please ensure "Add Python to PATH" is checked.
start /wait "" "%INSTALLER_FILE%" /passive InstallAllUsers=1 PrependPath=1 Include_test=0

REM === Cleanup ===
del /f /q "%INSTALLER_FILE%"

REM === Verify installation ===
echo Verifying Python installation...
where python >nul 2>&1
if %errorlevel% NEQ 0 (
    echo ERROR: Python %LATEST_VERSION% not found in PATH.
    echo Please install manually and ensure PATH is updated.
    pause
    exit /b 1
)

for /f "tokens=2 delims= " %%V in ('python --version 2^>nul') do (
    set "NEW_VER=%%V"
)

echo Detected Python version: !NEW_VER!
if not "!NEW_VER!"=="%LATEST_VERSION%" (
    echo WARNING: Installed version !NEW_VER! does not match expected %LATEST_VERSION%.
)

echo Python %LATEST_VERSION% is now installed.
echo Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Installation complete.
pause
exit /b 0
