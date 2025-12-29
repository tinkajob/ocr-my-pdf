@echo off
setlocal EnableDelayedExpansion

set "LANG=slv"
set "FILENAME=%LANG%.traineddata"
set "URL=https://github.com/tesseract-ocr/tessdata_best/raw/main/%FILENAME%"

:: Define both possible Tesseract paths
set "TESSDATA1=C:\Program Files\Tesseract-OCR\tessdata"
set "TESSDATA2=%LOCALAPPDATA%\Programs\Tesseract-OCR\tessdata"

echo Downloading language file: %FILENAME%

:: Function to download into a specific folder if it exists
call :DownloadLang "%TESSDATA1%"
call :DownloadLang "%TESSDATA2%"

echo.
echo Done installing language file in available locations.
pause
exit /b

:DownloadLang
set "TARGET=%~1"

if exist "!TARGET!" (
    echo Installing to: !TARGET!
    curl -L -o "!TARGET!\%FILENAME%" "%URL%"
    echo Installed: !TARGET!\%FILENAME%
) else (
    echo Skipping: !TARGET% (not found)
)
exit /b
