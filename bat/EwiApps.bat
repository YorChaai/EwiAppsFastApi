@echo off
setlocal
title EWIApps - Quick Start (Backend + Windows Desktop)

REM Resolve project root from this script's location.
set "PROJECT_DIR=%~dp0.."
for %%I in ("%PROJECT_DIR%") do set "PROJECT_DIR=%%~fI"

REM --- FLUTTER PATH DETECTION ---
where flutter >nul 2>&1
if errorlevel 1 (
    if exist "C:\flutter\bin\flutter.bat" (
        set "PATH=%PATH%;C:\flutter\bin"
    ) else if exist "D:\flutter\bin\flutter.bat" (
        set "PATH=%PATH%;D:\flutter\bin"
    ) else if exist "C:\src\flutter\bin\flutter.bat" (
        set "PATH=%PATH%;C:\src\flutter\bin"
    )
)
where flutter >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter tidak ditemukan. Periksa PATH instalasi Flutter.
    pause
    exit /b 1
)

echo ========================================================
echo   EWIApps: Backend FastAPI + Flutter Windows
echo ========================================================
echo.

REM Avoid starting a second Uvicorn process when this FastAPI API is already healthy.
curl.exe --silent --show-error --fail http://127.0.0.1:8000/api/health 2>nul | findstr /i /c:"FastAPI" >nul
if not errorlevel 1 (
    echo [INFO] FastAPI sudah aktif di http://127.0.0.1:8000. Backend baru tidak dijalankan.
) else (
    echo [INFO] Menjalankan backend FastAPI pada port 8000...
    start "EWIApps FastAPI Backend" "%ComSpec%" /k "cd /d ""%PROJECT_DIR%\backend"" && if exist venv\Scripts\activate.bat call venv\Scripts\activate.bat && python -m uvicorn main:app --host 0.0.0.0 --port 8000"
    timeout /t 3 /nobreak >nul
    curl.exe --silent --show-error --fail http://127.0.0.1:8000/api/health 2>nul | findstr /i /c:"FastAPI" >nul
    if errorlevel 1 echo [WARNING] FastAPI belum merespons. Cek jendela backend dan pastikan port 8000 tersedia.
)

echo [INFO] Menjalankan Flutter Windows...
start "EWIApps Flutter Windows" "%ComSpec%" /k "cd /d ""%PROJECT_DIR%\frontend"" && flutter run -d windows"
echo.
echo [INFO] Startup selesai. Tutup jendela ini jika tidak diperlukan.
exit /b 0
