[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null

function Get-PhotoDateTaken {
    param (
        $ImageFilepath
    )
    $thisFn = $MyInvocation.MyCommand.Name

    try {
        $image = New-Object System.Drawing.Bitmap($ImageFilepath)

    } catch {
        Write-Host "$($thisFn): Failed to load file as image file (no 'date taken' attribute read): $($ImageFilepath)"
        return $null
    }

    try {
        $bitearr = $image.GetPropertyItem(36867).Value 
        $string = [System.Text.Encoding]::ASCII.GetString($bitearr) 
        $DateTime = [datetime]::ParseExact($string,"yyyy:MM:dd HH:mm:ss`0",$Null)

        return $DateTime
    
    } catch {
        return $null
    
    } finally {
        $image.Dispose()
    } 
}

function Get-PhotoBestDate {
    param (
        $ImageFilepath
    )

    $file = Get-Item $ImageFilepath

    $fileDateCreated = $file.CreationTime
    $fileDateModified = $file.LastWriteTime
    $fileDateTaken = Get-PhotoDateTaken -ImageFilepath $ImageFilepath

    $allDates = @($fileDateCreated, $fileDateModified, $fileDateTaken)
    $oldestDate = $allDates | Sort-Object -Descending | Select-Object -Last 1
    
    return $oldestDate
}

function Remove-DuplicatePhotos {
    param (
        $ImageRootDir
    )

    $files = Get-ChildItem $ImageRootDir -Recurse
    Write-Host "Found $($files.Count) total photo files"

    $fileHashes = @()
    foreach ($file in $files) {
        $fileHashes += ($file | Get-FileHash -Algorithm 'SHA256')

        $percentDone = (($fileHashes.Count / $files.Count) * 100)
        Write-Progress -Activity "Finding duplicate photos" -Status "Calculating file hashes" -PercentComplete $percentDone
    }

    $groupedFileHashes = $fileHashes | Group-Object -Property Hash    
    $duplicateFileHashes = $groupedFileHashes | Where-Object -FilterScript { $_.Count -gt 1 }

    Write-Host "Comparing duplicate photo sets to determine which photos to keep"
    $filesToDelete = @()
    foreach ($duplicateFileHashGroup in $duplicateFileHashes) {
        $duplicateFiles = $duplicateFileHashGroup.Group
    
        $keepFile = $null
        foreach ($file in $duplicateFiles) {
            
            if (-not $keepFile) {
                $keepFile = $file
            
            } else {
                $currentFileDate = Get-PhotoBestDate -ImageFilepath $file.Path
                $currentKeepFileDate = Get-PhotoBestDate -ImageFilepath $keepFile.Path
    
                if ($currentFileDate -lt $currentKeepFileDate) {
                    $keepFile = $file
                
                # If the two timestamps are equal for the files, choose the one that is NOT in the form of "filename(number).ext"
                # Files that match this form are most likely copies, made from one of the other files in the duplicate group
                } elseif ($currentFileDate -eq $currentKeepFileDate) {
                    $fileName = (Get-Item $file.Path).Name
                    if ($fileName -notlike "*(*).*") {
                        $keepFile = $file
                    }
                }
            } 
        }
    
        $filesToDelete += ($duplicateFiles | Where-Object { $_.Path -ne $keepFile.Path } | Select-Object -ExpandProperty Path)
    }
    
    Write-Host "Removing the duplicate, non-desired photos found"
    $filesToDelete | Remove-Item -Force

    Write-Host "`nRemoved the following duplicates (only 1 copy of each of these image files was kept):"
    $filesToDelete
    Write-Host "`n$($filesToDelete.Count) duplicate image files deleted successfully"    
}

Remove-DuplicatePhotos -ImageRootDir "Z:\Image Library\Photos"
#Remove-DuplicatePhotos -ImageRootDir "D:\Temp\photos-test\2018"