@echo off
setlocal EnableExtensions

title MD Reader Assistant Website - GitHub Sync
cd /d "%~dp0"

set "REPO_URL=https://github.com/liuhang798/liuhang798.github.io.git"
set "BRANCH=main"
set "COMMIT_MSG=Update MD Reader Assistant website"

echo.
echo ========================================
echo   MD Reader Assistant Website Sync
echo ========================================
echo   Folder : %CD%
echo   Remote : %REPO_URL%
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git was not found.
    echo Install Git for Windows: https://git-scm.com/download/win
    goto :failed
)

if not exist ".git" (
    echo [ERROR] This folder is not an independent Git repository.
    goto :failed
)

git remote set-url origin "%REPO_URL%"
if errorlevel 1 goto :failed

echo [1/4] Pulling the latest website code...
git pull --rebase --autostash origin "%BRANCH%"
if errorlevel 1 goto :failed

echo [2/4] Staging website changes...
git add -A
if errorlevel 1 goto :failed

git diff --cached --check
if errorlevel 1 (
    echo [ERROR] Git found whitespace errors or conflict markers.
    goto :failed
)

git diff --cached --quiet
if errorlevel 1 (
    echo [3/4] Creating commit...
    git commit -m "%COMMIT_MSG%"
    if errorlevel 1 goto :failed
) else (
    echo [3/4] No new changes to commit.
)

echo [4/4] Pushing website to GitHub...
git push -u origin "%BRANCH%"
if errorlevel 1 goto :failed

echo.
echo ========================================
echo   Website sync completed successfully.
echo   https://liuhang798.github.io/
echo ========================================
pause
exit /b 0

:failed
echo.
echo [ERROR] Website sync failed. Review the message above.
pause
exit /b 1
