@echo off
setlocal enabledelayedexpansion

echo ======================================================================
echo           MINIPROJECT KPI EWI - COMPREHENSIVE AUDIT SUITE
echo ======================================================================
echo.

set ROOT_DIR=%~dp0..
cd /d "%ROOT_DIR%"

echo [1/4] Running Static Application Security Testing (Bandit SAST)...
echo ----------------------------------------------------------------------
backend\venv\Scripts\bandit.exe -r backend\routes backend\services backend\models backend\utils -ll
if errorlevel 1 (
    echo [!] Bandit found security warnings ^(check output above^).
) else (
    echo [OK] Bandit SAST passed with 0 high/medium issues.
)
echo.

echo [2/4] Running Software Composition Analysis (pip-audit CVE Scan)...
echo ----------------------------------------------------------------------
backend\venv\Scripts\pip-audit.exe -r backend\requirements.txt
if errorlevel 1 (
    echo [!] pip-audit found known vulnerabilities in dependencies.
) else (
    echo [OK] All dependencies are secure according to PyPA database.
)
echo.

echo [3/4] Running Backend Logic & Financial Integrity Tests (pytest)...
echo ----------------------------------------------------------------------
backend\venv\Scripts\pytest.exe backend\tests -v
if errorlevel 1 (
    echo [ERROR] Pytest reported failures.
) else (
    echo [OK] All backend logic and math tests passed.
)
echo.

echo [4/4] Running End-to-End & Role-Based Access Control Tests (Playwright)...
echo ----------------------------------------------------------------------
call npx playwright test tests\authenticated_e2e_suite.spec.js
if errorlevel 1 (
    echo [ERROR] Playwright E2E suite encountered test failures.
) else (
    echo [OK] All Playwright E2E and RBAC scenarios passed.
)
echo.

echo ======================================================================
echo                      AUDIT SUITE COMPLETE
echo ======================================================================
pause
