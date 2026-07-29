@echo off
REM Local deploy helper for Heritage Atlas
REM Rebuilds the Hugo site and stages changes for commit.
REM Does NOT auto-commit or push.

echo Building Hugo site...
C:\Users\simon\bin\hugo.exe --minify --source C:\Users\simon\heritage-app-site

echo.
echo Staging all changes...
cd /d C:\Users\simon\heritage-app-site
git add -A

echo.
echo Current git status:
git status --short

echo.
echo ========================================
echo Next steps (run these manually):
echo   git commit -m "Update site"
echo   git push origin main
echo ========================================
echo.
echo Note: GitHub Actions will auto-deploy to gh-pages on push.