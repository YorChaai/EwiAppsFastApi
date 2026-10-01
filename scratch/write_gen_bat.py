from pathlib import Path

bat_content = '''@echo off
setlocal enabledelayedexpansion
title AI Tool - Generate & Compare Docs
color 0B

echo =======================================================
echo    AI TOOL: GENERATE & COMPARE DOKUMENTASI (.MD)
echo =======================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "TARGET_PROJ=%~1"

if "%TARGET_PROJ%"=="" (
    python -c "import json, os; cfg=os.path.join(r'%SCRIPT_DIR%..', 'config.json'); data=json.load(open(cfg)) if os.path.exists(cfg) else {}; print(data.get('last_project_path', ''))" > "%TEMP%\\last_proj.txt"
    set /p TARGET_PROJ=<"%TEMP%\\last_proj.txt"
)

if "%TARGET_PROJ%"=="" (
    echo [ERROR] Target project tidak ditemukan!
    echo Silakan jalankan dengan argumen: generate_and_compare_docs.bat "D:\\Path\\To\\Project"
    pause
    exit /b 1
)

echo [*] Target Project : %TARGET_PROJ%
echo.

python "%SCRIPT_DIR%auto_generate_and_compare_docs.py" "%TARGET_PROJ%"
if errorlevel 1 (
    echo.
    echo [ERROR] Terjadi kesalahan saat menjalankan proses Python.
    pause
    exit /b 1
)

echo.
echo Membuka folder hasil perbandingan...
if exist "%TARGET_PROJ%\\docs\\alldocument\\banding" (
    explorer "%TARGET_PROJ%\\docs\\alldocument\\banding"
)

echo.
echo =======================================================
echo   PROSES SELESAI
echo =======================================================
pause
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\generate_and_compare_docs.bat")
target.write_text(bat_content, encoding="utf-8")
print("generate_and_compare_docs.bat written successfully to", target)
