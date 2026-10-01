@echo off
chcp 65001 >nul
setlocal
pushd "%~dp0"

REM ------------------------------------------------------------
REM KONFIGURASI PATH
REM ------------------------------------------------------------
set "VENV_PY=..\venv\Scripts\python.exe"
set "SCRIPT=generate_hybrid_migration_v14.py"

REM Cek jika virtual environment tidak ada, gunakan python di PATH
if not exist "%VENV_PY%" (
    set "VENV_PY=python"
)

REM Cek apakah Script Python ada
if not exist "%SCRIPT%" (
    echo [ERROR] Script Python "%SCRIPT%" tidak ditemukan!
    echo Path dicari: %~dp0%SCRIPT%
    echo.
    pause
    exit /b 1
)

:menu
cls
echo ============================================================
echo === Migrasi Hybrid v14 (Visual State Machine ^& New IDs) ===
echo ============================================================
echo.
echo 1. MODE INTERAKTIF (Pilih File + Sheet)
echo 2. MODE QUICK (Otomatis)
echo 3. LIHAT DAFTAR SHEET
echo 4. KELUAR
echo.
set /p PIL="Pilih nomor [1-4]: "

if "%PIL%"=="1" goto interactive
if "%PIL%"=="2" goto quick
if "%PIL%"=="3" goto listsheets
if "%PIL%"=="4" goto end

echo Pilihan salah!
pause
goto menu

:interactive
echo.
echo [INFO] Memulai Mode Interaktif...
"%VENV_PY%" "%SCRIPT%"
echo.
echo [INFO] Selesai.
pause
goto menu

:quick
echo.
echo [INFO] Memulai Mode QUICK...
"%VENV_PY%" "%SCRIPT%" --quick
echo.
echo [INFO] Selesai.
pause
goto menu

:listsheets
echo.
set /p XLS="Path Excel (Kosongkan jika default): "
if "%XLS%"=="" (
    "%VENV_PY%" "%SCRIPT%" --list-sheets
) else (
    "%VENV_PY%" "%SCRIPT%" -x "%XLS%" --list-sheets
)
echo.
pause
goto menu

:end
popd
endlocal
exit /b 0
