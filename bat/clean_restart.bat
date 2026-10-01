@echo off
setlocal EnableDelayedExpansion
title Clean Restart Sesi Dev - EWIApps
color 0A

set "AITOOL_DIR=D:\Aplikasi\aitool"
set "PROJ_DIR=%~dp0.."
pushd "!PROJ_DIR!"
set "PROJ_DIR=%CD%"
popd

echo =======================================================
echo     MEMBERSIHKAN SESI DEVELOPMENT - KONDISI FRESH
echo =======================================================
echo.

if exist "!AITOOL_DIR!\clean_restart.py" (
    echo [INFO] Menjalankan modul clean_restart dari AI Tool...
    python "!AITOOL_DIR!\clean_restart.py" "!PROJ_DIR!"
) else (
    echo [INFO] Menjalankan fallback clean restart lokal...
    if exist "%~dp0side\clean_restart_debug.bat" (
        call "%~dp0side\clean_restart_debug.bat"
    )
)
pause
