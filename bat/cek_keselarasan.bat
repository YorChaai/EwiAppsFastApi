@echo off
chcp 65001 >nul
title Audit Keselarasan Excel vs Database vs Aplikasi

echo ========================================================================
echo    ALAT AUDIT KESELARASAN DATA: EXCEL vs DATABASE vs APLIKASI LIVE
echo ========================================================================
echo.

cd /d "%~dp0\.."

set PYTHON_EXE=backend\venv\Scripts\python.exe

if not exist "%PYTHON_EXE%" (
    set PYTHON_EXE=python
)

"%PYTHON_EXE%" backend\scripts\cek_keselarasan_excel_db.py %*

echo.
pause
