git config http.postBuffer 524288000
git config user.name "Antigravity Agent"
git config user.email "agent@antigravity.dev"

$batchSizeLimit = 5MB
$currentBatchSize = 0
$batchNumber = 1

$files = Get-ChildItem -File -Recurse | Where-Object { $_.FullName -notmatch '\\\.git\\' }

# Ensure we're on a branch named main
git checkout -b main 2>$null
git branch -M main

foreach ($file in $files) {
    $relPath = $file.FullName.Substring((Get-Location).Path.Length + 1).Replace('\', '/')
    
    Write-Host "Adding $($relPath) (Size: $([math]::Round($file.Length / 1MB, 2)) MB)"
    git add "`"$relPath`""
    
    $currentBatchSize += $file.Length
    
    if ($currentBatchSize -ge $batchSizeLimit) {
        Write-Host "Batch $batchNumber reached limit, committing and pushing..."
        git commit -m "Incremental upload batch $batchNumber"
        git push -f origin main
        
        $currentBatchSize = 0
        $batchNumber++
    }
}

if ($currentBatchSize -gt 0) {
    Write-Host "Committing and pushing final batch..."
    git commit -m "Incremental upload final batch"
    git push -f origin main
}

Write-Host "All files pushed successfully!"
