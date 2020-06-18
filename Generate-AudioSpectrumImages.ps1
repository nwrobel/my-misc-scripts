$ffmpegProgramDir = 'C:\Program Files\ffmpeg-20200610-9dfb19b-win64-static\bin'
$ffmpegFilepath = Join-Path $ffmpegProgramDir -ChildPath 'ffmpeg.exe'

# Must add \\?\ prefix to the directory path if any filepaths may be longer than 260 characters
$audioFilesDir = '\\?\Z:\Music Library\!new-additions-wip-stage-temp\!quality-fix-redownloads-wip-temp'
$outputDir = 'D:\Temp\spectrums-quality-fix'

$audioFiles = Get-ChildItem -Path $audioFilesDir -Recurse -Include ('*.flac')

# For each audio file, generate and output a spectrum image file into same directory that contains that audio file
foreach ($audioFile in $audioFiles) {
    $imageOutputFilename = "$($audioFile.Name)-SPEKIMG.png" 
    $imageOutputFilepath = Join-Path $outputDir -ChildPath $imageOutputFilename

    if (Test-Path $imageOutputFilepath) {
        Write-Host "Audio spectrum image file already exists for this audio file: $($imageOutputFilename)"
    
    } else {
        Start-Process $ffmpegFilepath -ArgumentList ('-i', "`"$($audioFile.FullName)`"", '-lavfi', 'showspectrumpic=mode=combined:color=rainbow:s=1920x1024', "`"$($imageOutputFilepath)`"") -Wait -NoNewWindow
    }
}


# foreach ($audioFile in $audioFiles) {
#     $imageOutputFilename = "$($audioFile.Name)-SPEKIMG.png" 
#     $imageOutputFilepath = "$($audioFile.DirectoryName)\$($imageOutputFilename)"

#     if (Test-Path $imageOutputFilepath) {
#         Write-Host "Audio spectrum image file already exists for this audio file: $($imageOutputFilename)"
    
#     } else {
#         Start-Process $ffmpegFilepath -ArgumentList ('-i', "`"$($audioFile.FullName)`"", '-lavfi', 'showspectrumpic=mode=combined:color=rainbow:s=1920x1024', "`"$($imageOutputFilepath)`"") -Wait -NoNewWindow
#     }
# }