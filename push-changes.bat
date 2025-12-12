@echo off
REM push-changes.bat — 將目前變更 commit 並推送到 origin main
cd /d "%~dp0"
echo Running git add and commit (if there are changes)...
git status --porcelain --branch




















pauseecho Push succeeded.)  exit /b 1  pause  echo If prompted for username/password, enter your GitHub username and use a Personal Access Token (PAT) as password.  echo Push failed. Please check the output above for authentication errors or conflicts.git branch -M main
ngit push -u origin main
nif %ERRORLEVEL% neq 0 (echo Pushing to origin main...echo.)  echo No changes to commit.) else (  )    echo Commit failed. See output above. Pausing... & pause & exit /b 1  git commit -m "fix: update site and remove submodule issues" || (  git add .if defined HAS_CHANGES (for /f "delims=" %%i in ('git status --porcelain') do set HAS_CHANGES=1n
nREM Stage and commit if there are changes