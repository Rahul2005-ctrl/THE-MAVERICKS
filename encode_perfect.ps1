$files = Get-ChildItem "manual_assets\dive_*.mp4"
foreach ($file in $files) {
    $outName = $file.Name
    $outPath = "public\assets\vid\$outName"
    Write-Host "Encoding $outName for PERFECT frame-by-frame scrubbing (All-Intra)..."
    
    # Scale to 720p, -g 1 for perfect seek (every frame is a keyframe), -crf 23
    ffmpeg -i $file.FullName -an -vf "scale=1280:-2,unsharp=5:5:0.8:5:5:0.0" -c:v libx264 -preset fast -crf 23 -pix_fmt yuv420p -g 1 -keyint_min 1 -sc_threshold 0 -movflags +faststart $outPath -y
}
Write-Host "Done! All videos are now perfectly optimized for frame-by-frame scrubbing."
