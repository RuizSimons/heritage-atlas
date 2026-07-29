@echo off
REM Deploy script for Heritage Atlas Hugo site
REM This script rebuilds the site and stages changes, but does NOT auto-commit or push

echo Building Hugo site...
C:/Users/simon/bin/hugo.exe --minify

echo.
echo Staging all changes...
git add -A

echo.
echo Current git status:
git status

echo.
echo ========================================
echo Next steps (run these manually):
echo   git commit -m "Update site" ^&^& git push origin main
echo ========================================
