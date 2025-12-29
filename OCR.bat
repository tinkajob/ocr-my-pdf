@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"

echo ✅ Scanning folder: %CD%

:: Get all PDF files, newest first
set "newest="
set "newestTime="

dir /b /a:-d /o:-d *.pdf > __pdflist.txt

for /f "usebackq delims=" %%F in ("__pdflist.txt") do (
    if not defined newest (
        set "newest=%%F"
        for %%T in ("%%F") do set "newestTime=%%~tT"
    )
)

if not defined newest (
    echo ❌ No PDF files were found
    del __pdflist.txt
    pause
    exit /b
)

echo ✅ Newest file was found: "%newest%"
echo Do you want to continue with this file?
echo   - Y/y/empty:  ✅ Yes (newest file)
echo   - N/n:        ❌ No (manual selection)
echo   - A/a:        🔁 OCR all PDF files
echo.
set /p "choice=Your choice: "

set "selected="
set "doAll="

if /i "%choice%"=="y" (
    set "selected=%newest%"
) else if /i "%choice%"=="a" (
    set "doAll=true"
) else if "%choice%"=="" (
    set "selected=%newest%"
)

:: If user wants to choose
if not defined selected if not defined doAll (
    echo.
    echo CHOOSE A FILE:
    set /a count=0
    > __pdfindex.txt (
        for /f "usebackq delims=" %%F in ("__pdflist.txt") do (
            set /a count+=1
            echo !count!^) %%F
        )
    )
    type __pdfindex.txt | findstr /r "^[0-9]*\)"

    set /p "fileChoice=Vnesite številko datoteke (ali pustite prazno za najnovejšo): "

    if not defined fileChoice (
        set "selected=%newest%"
    ) else (
        set "line=0"
        for /f "usebackq delims=" %%F in ("__pdflist.txt") do (
            set /a line+=1
            if "!line!"=="!fileChoice!" (
                set "selected=%%F"
            )
        )
    )
)

:: Clean up temp files
del __pdflist.txt >nul 2>&1
del __pdfindex.txt >nul 2>&1

:: Create output directory
set "outputDir=Results"
if not exist "%outputDir%" mkdir "%outputDir%"

:: OCR all PDFs
if defined doAll (
    echo.
    echo ✅ Starting OCR of all PDF files in folder...

    for %%F in (*.pdf) do (
        echo.
        echo ✅ Processing: "%%F"
        set "filename=%%~nxF"
        set "basename=%%~nF"
        set "cleanName=!basename!"
        set "cleanName=!cleanName:(=!"
        set "cleanName=!cleanName:)=!"
        set "cleanName=!cleanName: =_!"
        set "cleanName=!cleanName:,=!"
        set "cleanName=!cleanName::=!"
        set "cleanName=!cleanName:&=!"
        set "cleanName=!cleanName:`=!"
        set "cleanName=!cleanName:^=!"
        set "cleanName=!cleanName:_= !"
        set "outputFile=%outputDir%\!cleanName! - OCR.pdf"

        python -m ocrmypdf --deskew --clean --rotate-pages --optimize 3 --force-ocr -l eng+slv "%%F" "!outputFile!" 2>&1

        if errorlevel 1 (
            echo ❌ Error with file "%%F"
        ) else (
            echo ✅ OCR completed for "%%F"
        )
    )
    goto :done
)

:: OCR one selected file
if not exist "%selected%" (
    echo ❌ File was not found: "%selected%"
    pause
    exit /b
)

:: Prepare names
for %%A in ("%selected%") do (
    set "filename=%%~nxA"
    set "basename=%%~nA"
)
set "cleanName=%basename%"
set "cleanName=%cleanName:(=%"
set "cleanName=%cleanName:)=%"
set "cleanName=%cleanName: =_%"
set "cleanName=%cleanName:,=%"
set "cleanName=%cleanName::=%"
set "cleanName=%cleanName:&=%"
set "cleanName=%cleanName:`=%"
set "cleanName=%cleanName:^=%"
set "cleanName=%cleanName:_= %"

set "outputFile=%outputDir%\%cleanName% - OCR.pdf"

echo.
echo ✅ Processing file: "%filename%"
echo ✅ Output file will be: "%outputFile%"
python -m ocrmypdf --deskew --clean --rotate-pages --optimize 3 --force-ocr -l eng+slv "%filename%" "%outputFile%" 2>&1

if errorlevel 1 (
    echo.
    echo ❌ ERROR: There was an error with ocrmypdf!
) else (
    echo.
    echo ✅ OCR FINISHED SUCCESSFULLY
)

:done
echo.
echo Done. Result(s) are saved in folder "%outputDir%"
echo Press any key to close...
pause >nul
exit /b
