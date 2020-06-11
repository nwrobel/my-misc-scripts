$ffmpegProgramDir = 'C:\Program Files\ffmpeg-20200610-9dfb19b-win64-static\bin'
$ffmpegFilepath = Join-Path $ffmpegProgramDir -ChildPath 'ffmpeg.exe'

# Must add \\?\ prefix to the directory path if any filepaths may be longer than 260 characters
$audioFilesDir = '\\?\Z:\Music Library\!new-additions-wip-stage-temp'
$imageOutputDir = 'D:\Temp\audio-spectrum-images-out'

if (-not (Test-Path $imageOutputDir)) {
    New-Item $imageOutputDir -ItemType Directory | Out-Null
}

$audioFiles = Get-ChildItem -Path $audioFilesDir -Recurse -Include ('*.flac', '*.mp3', '*.m4a')

foreach ($audioFile in $audioFiles) {
    $imageOutputFilename = "$($audioFile.Name)-SPEKIMG.jpg" 
    $imageOutputFilepath = Join-Path $imageOutputDir -ChildPath $imageOutputFilename 

    Start-Process $ffmpegFilepath -ArgumentList ('-i', "`"$($audioFile.FullName)`"", '-lavfi', 'showspectrumpic=mode=combined:color=rainbow:s=1920x1024', "`"$($imageOutputFilepath)`"") -Wait -NoNewWindow
}