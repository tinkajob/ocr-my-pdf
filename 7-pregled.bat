@echo off
setlocal enabledelayedexpansion

echo ========================================
echo     OCR Toolchain Environment Check
echo ========================================
echo.
echo Name              ^| Status     ^| Hint
echo ------------------^|------------^|------------------------------

set "all_ok=1"
set "missing_packages="

rem Check Python
python --version >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=2 delims= " %%a in ('python --version 2^>^&1') do (
        set "python_ver=%%a"
    )
    echo Python            ^| OK         ^| Python !python_ver!
) else (
    echo Python            ^| Missing    ^| Run: 1-python.bat
    set all_ok=0
    set "missing_packages=!missing_packages!Python, "
)

rem Check OCRmyPDF
python -m ocrmypdf --version >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=1" %%a in ('python -m ocrmypdf --version') do set "ocrmypdf_ver=%%a"
    echo OCRmyPDF          ^| OK         ^| !ocrmypdf_ver!
) else (
    echo OCRmyPDF          ^| Missing    ^| Run: 2-ocrmypdf.bat
    set all_ok=0
    set "missing_packages=!missing_packages!OCRmyPDF, "
)

rem Check Tesseract OCR
tesseract --version >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=1" %%a in ('tesseract --version') do set "tess_ver=%%a"
    echo Tesseract OCR     ^| OK         ^| !tess_ver!
) else (
    echo Tesseract OCR     ^| Missing    ^| Run: 3-tesseract.bat
    set all_ok=0
    set "missing_packages=!missing_packages!Tesseract OCR, "
)

rem Check Chocolatey
choco --version >nul 2>&1
if %errorlevel%==0 (
    for /f %%a in ('choco --version') do set "choco_ver=%%a"
    echo Chocolatey        ^| OK         ^| !choco_ver!
) else (
    echo Chocolatey        ^| Missing    ^| Run: 5-chocolatey.bat
    set all_ok=0
    set "missing_packages=!missing_packages!Chocolatey, "
)

rem Check Unpaper
unpaper --version >nul 2>&1
if %errorlevel%==0 (
    for /f %%a in ('unpaper --version') do set "unpaper_ver=%%a"
    echo Unpaper           ^| OK         ^| !unpaper_ver!
) else (
    echo Unpaper           ^| Missing    ^| Run: 6-unpaper.bat
    set all_ok=0
    set "missing_packages=!missing_packages!Unpaper, "
)

rem Check pngquant
pngquant --version >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=1*" %%a in ('pngquant --version') do set "pngquant_ver=%%a %%b"
    echo pngquant          ^| OK         ^| !pngquant_ver!
) else (
    echo pngquant          ^| Missing    ^| Run: 7-pngquant.bat
    set all_ok=0
    set "missing_packages=!missing_packages!pngquant, "
)

rem Check Ghostscript
gswin64c --version >nul 2>&1
if %errorlevel%==0 (
    for /f %%a in ('gswin64c --version') do set "gs_ver=%%a"
    echo Ghostscript       ^| OK         ^| !gs_ver!
) else (
    echo Ghostscript       ^| Missing    ^| Run: 8-ghostscript.bat
    set all_ok=0
    set "missing_packages=!missing_packages!Ghostscript, "
)

echo.

if !all_ok! EQU 1 (
    echo ALL PACKAGES INSTALLED SUCCESSFULLY
) else (
    rem Trim trailing comma and space from missing_packages string
    set "missing_packages=!missing_packages:~, -2!"
    echo The following packages are missing:
    echo !missing_packages!
)

echo.
pause
exit /b
