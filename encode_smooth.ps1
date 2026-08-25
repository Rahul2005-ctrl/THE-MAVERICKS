$files = Get-ChildItem "manual_assets\dive_*.mp4"
foreach ($file in $files) {
    $outName = $file.Name
    $outPath = "public\assets\vid\$outName"
    Write-Host "Encoding $outName for smooth scrubbing..."
    
    # Scale to 720p, -g 4 for faster seek, -crf 23 for smaller size
    ffmpeg -i $file.FullName -an -vf "scale=1280:-2,unsharp=5:5:0.8:5:5:0.0" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p -g 4 -keyint_min 4 -sc_threshold 0 -movflags +faststart $outPath -y
}
Write-Host "Done!"
