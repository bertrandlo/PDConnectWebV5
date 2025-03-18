@echo off
setlocal enabledelayedexpansion

REM read frontend_config.txt, get newFaviconMime / newTitle / newFavicon
set newTitle=
set newFavicon=

FOR /F "usebackq tokens=* delims=" %%A IN ("frontend_config.txt") DO (
    for /F "tokens=1* delims== " %%i IN ("%%A") DO (
        if "%%i"=="title" (
            set newTitle=%%j
            set newTitle=!newTitle:'=!
        )
        if "%%i"=="favicon" (
            set newFavicon=%%j
            set newFavicon=!newFavicon:'=!
        )
    )
)

REM 依檔名副檔名判斷 mime
set newFaviconMime=
for %%F in (%newFavicon%) do set newFaviconType=%%~xF

if "%newFaviconType%"==".svg" set newFaviconMime=image/svg+xml
if "%newFaviconType%"==".png" set newFaviconMime=image/png
if "%newFaviconType%"==".ico" set newFaviconMime=image/x-icon

if "%newFaviconMime%"=="" (
    echo [Warning] Unrecognized favicon file type. Defaulting to image/x-icon.
    set newFaviconMime=image/x-icon
)

echo [INFO] Detected favicon MIME type: %newFaviconMime%
echo [INFO] Title=%newTitle%, Favicon=%newFavicon%

REM 用三個參數呼叫 update_html_title_favi.ps1
powershell -ExecutionPolicy Bypass -File update_html_title_favi.ps1 ^
  -Mime "%newFaviconMime%" ^
  -Title "%newTitle%" ^
  -FaviconFile "%newFavicon%"

REM =========================================
REM 6. Copy updated index.html & newFavicon to Docker container
REM =========================================
echo ---
echo [INFO] Copying index.html to container: /usr/share/nginx/index.html
docker cp .\frontend\dist\index.html pds-connected-client:/usr/share/nginx/index.html

if NOT "%newFavicon%"=="" (
    if EXIST ".\%newFavicon%" (
        echo [INFO] Copying %newFavicon% to container: /usr/share/nginx/
        docker cp ".\%newFavicon%" pds-connected-client:/usr/share/nginx/
    )
)

REM =========================================
REM 7. Restart Docker container
REM =========================================
echo ---
echo [INFO] Restarting Docker container pds-connected-client ...
docker restart pds-connected-client

echo [INFO] Deployment and update completed!
pause
