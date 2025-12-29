@echo off
chcp 65001 >nul

:: Check if python is available
where python >nul 2>&1
if errorlevel 1 (
    echo Python is not installed or not in PATH. Please install Python first.
    pause
    exit /b 1
)

echo Upgrading pip...
python -m pip install --upgrade pip

echo Installing or upgrading ocrmypdf...
python -m pip install --upgrade ocrmypdf

:: Get Python Scripts path (usually where ocrmypdf.exe is installed)
for /f "delims=" %%S in ('python -c "import sysconfig; print(sysconfig.get_path('scripts'))"') do set "SCRIPTS_PATH=%%S"

:: Check if it's already in the user PATH
echo Checking if Scripts path is in user PATH...
echo Current Scripts path: %SCRIPTS_PATH%

:: Get current user PATH
for /f "tokens=3*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%A %%B"

echo Current user PATH:
echo %USER_PATH%

echo %USER_PATH% | find /I "%SCRIPTS_PATH%" >nul
if errorlevel 1 (
    echo Adding Scripts path to user PATH...
    setx PATH "%USER_PATH%;%SCRIPTS_PATH%"
) else (
    echo Scripts path already in PATH.
)

echo.
echo Installed versions:
python --version
python -m ocrmypdf --version

echo.
echo Done. 
pause

