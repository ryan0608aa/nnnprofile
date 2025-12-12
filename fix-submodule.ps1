# fix-submodule.ps1
# 用途：嘗試自動修復 "No url found for submodule path 'nnnprofile' in .gitmodules" 問題。
# 使用說明：在專案根目錄（本檔案與 .gitmodules 同目錄）以 PowerShell 執行此檔案：
# 1) 右鍵 -> 使用 PowerShell 執行，或
# 2) 在 PowerShell 中執行： .\fix-submodule.ps1

Write-Host "== fix-submodule.ps1 開始執行 =="

# 簡易檢查
Write-Host "Git version:"; git --version
Write-Host "git status:"; git status --porcelain --branch

# Step A: 如果 .gitmodules 存在，顯示內容
if (Test-Path .gitmodules) {
  Write-Host "Found .gitmodules:"; Get-Content .gitmodules
} else {
  Write-Host "No .gitmodules found. (This script expects .gitmodules to exist at repo root)"
}

# Step B: 嘗試 deinit 並從索引移除 submodule gitlink（如果存在）
Write-Host "\nAttempting to deinit and remove submodule from index..."
# 忽略 deinit 錯誤
git submodule deinit -f -- nnnprofile 2>&1 | Tee-Object -Variable _deinit || Write-Host "deinit returned non-zero"

# 從索引中移除 gitlink；如果是普通目錄會視為刪除檔案
git rm -f nnnprofile 2>&1 | Tee-Object -Variable _rm
if ($LASTEXITCODE -ne 0) {
  Write-Host "git rm failed (output below). If the index does not contain a gitlink, this may report failure:"; $_rm
} else {
  Write-Host "git rm succeeded (removed gitlink or files from index)."
}

# Step C: 清理 .git/modules
if (Test-Path ".git/modules/nnnprofile") {
  Write-Host "Removing .git/modules/nnnprofile ..."
  Remove-Item -Recurse -Force ".git/modules/nnnprofile"
} else {
  Write-Host "No .git/modules/nnnprofile found."
}

# Step D: 提交變更（若有）
Write-Host "\nAttempting to commit changes (if staged)..."
git commit -m "fix: remove or repair broken nnnprofile submodule" 2>&1 | Tee-Object -Variable _commitOut
if ($LASTEXITCODE -ne 0) { Write-Host "Commit may have failed or nothing to commit:"; $_commitOut } else { Write-Host "Commit succeeded." }

# Step E: 如果資料夾被移除，要把工作目錄當成普通資料加入
if (-not (Test-Path ".\\nnnprofile") -and (Test-Path ".\\nnnprofile_saved")) {
  Write-Host "Restoring backup folder nnnprofile_saved back to nnnprofile"
  Move-Item -Path ".\\nnnprofile_saved" -Destination ".\\nnnprofile"
  git add nnnprofile
  git commit -m "restore nnnprofile as normal folder" 2>&1 | Tee-Object -Variable _commitRestore
  if ($LASTEXITCODE -ne 0) { Write-Host "Commit restore failed:"; $_commitRestore } else { Write-Host "Restore committed." }
} else {
  Write-Host "nnnprofile folder exists or no backup present; skipping restore step."
}

Write-Host "\nYou can now try: git push -u origin main"
Write-Host "If push fails due to auth, use a GitHub PAT as password when prompted."
Write-Host "== 腳本結束 =="