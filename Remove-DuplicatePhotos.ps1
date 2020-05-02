$photosFilepath = "D:\Temp\photo-utils-test"

#$fileHashes = Get-ChildItem $photosFilepath -Recurse | Get-FileHash -Algorithm 'SHA256'
$groupedFileHashes = $fileHashes | Group-Object -Property Hash

$duplicateFileHashes = $groupedFileHashes | Where-Object -FilterScript { $_.Count -gt 1 }

foreach ($duplicateFileHashGroup in $duplicateFileHashes) {
    $duplicateFiles = $duplicateFileHashGroup.Group

    $oldestFile = $null
    foreach ($file in $duplicateFiles) {
        
        if (-not $oldestFile) {
            $oldestFile = $file
        
        } else {
            $currentFileDate = Get-ImageBestDate -ImageFilepath $file.Path
            $oldestFileDate = Get-ImageBestDate -ImageFilepath $oldestFile.Path

            if ($currentFileDate -lt $oldestFileDate) {
                $oldestFile = $file
            }
        } 
    }

    Write-Host "Selected file to keep among duplicates: $($oldestFile.Path)"
    $duplicatesToDelete = $duplicateFiles | Where-Object { $_.Path -ne $oldestFile.Path }

    $duplicatesToDelete | Remove-Item -Force
}

function Get-ImageDateTaken {
    param (
        $ImageFilepath
    )

    [reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
    $pic = New-Object System.Drawing.Bitmap($ImageFilepath)

    try {
        $bitearr = $pic.GetPropertyItem(36867).Value 
        $string = [System.Text.Encoding]::ASCII.GetString($bitearr) 
        $DateTime = [datetime]::ParseExact($string,"yyyy:MM:dd HH:mm:ss`0",$Null)

        return $DateTime
    
    } catch {
        $x = 2
        return $null
    
    } finally {
        $pic.Dispose()
    } 
}

function Get-ImageBestDate {
    param (
        $ImageFilepath
    )

    $file = Get-Item $ImageFilepath

    $fileDateCreated = $file.CreationTime
    $fileDateModified = $file.LastWriteTime
    $fileDateTaken = Get-ImageDateTaken -ImageFilepath $ImageFilepath

    $allDates = @($fileDateCreated, $fileDateModified, $fileDateTaken)
    $oldestDate = $allDates | Sort-Object -Descending | Select-Object -Last 1
    
    return $oldestDate
}