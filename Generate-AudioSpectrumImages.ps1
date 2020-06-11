$ffmpegProgramDir = 'C:\Program Files\ffmpeg-20200610-9dfb19b-win64-static\bin'
$ffmpegFilepath = Join-Path $ffmpegProgramDir -ChildPath 'ffmpeg.exe'

# Must add \\?\ prefix to the directory path if any filepaths may be longer than 260 characters
$audioFilesDir = '\\?\Z:\Music Library\!new-additions-wip-stage-temp'

# $imageOutputDir = 'D:\Temp\audio-spectrum-images-out'
# if (-not (Test-Path $imageOutputDir)) {
#     New-Item $imageOutputDir -ItemType Directory | Out-Null
# }

$audioFiles = Get-ChildItem -Path $audioFilesDir -Recurse -Include ('*.flac', '*.mp3', '*.m4a')

# For each audio file, generate and output a spectrum image file into same directory that contains that audio file
foreach ($audioFile in $audioFiles) {
    #$audioFileDir = (Get-Item $audioFile.PSParentPath).FullName
    $imageOutputFilename = "$($audioFile.Name)-SPEKIMG.png" 
    $imageOutputFilepath = "$($audioFile.DirectoryName)\$($imageOutputFilename)"

    Start-Process $ffmpegFilepath -ArgumentList ('-i', "`"$($audioFile.FullName)`"", '-lavfi', 'showspectrumpic=mode=combined:color=rainbow:s=1920x1024', "`"$($imageOutputFilepath)`"") -Wait -NoNewWindow
}