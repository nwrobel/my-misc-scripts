[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null

function Get-ImageDateTaken {
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

function Remove-DuplicateImages {
    param (
        $ImageRootDir
    )

    $fileHashes = Get-ChildItem $ImageRootDir -Recurse | Get-FileHash -Algorithm 'SHA256'
    $groupedFileHashes = $fileHashes | Group-Object -Property Hash
    
    $duplicateFileHashes = $groupedFileHashes | Where-Object -FilterScript { $_.Count -gt 1 }
    $duplicatesToDeleteFilepaths = @()
    
    foreach ($duplicateFileHashGroup in $duplicateFileHashes) {
        $duplicateFiles = $duplicateFileHashGroup.Group
    
        $keepFile = $null
        foreach ($file in $duplicateFiles) {
            
            if (-not $keepFile) {
                $keepFile = $file
            
            } else {
                $currentFileDate = Get-ImageBestDate -ImageFilepath $file.Path
                $currentKeepFileDate = Get-ImageBestDate -ImageFilepath $keepFile.Path
    
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
    
        $duplicatesToDeleteFilepaths += ($duplicateFiles | Where-Object { $_.Path -ne $keepFile.Path } | Select-Object -ExpandProperty Path)
    }
    
    $duplicatesToDeleteFilepaths | Remove-Item -Force

    Write-Host "`nRemoved the following duplicates (only 1 copy of each of these image files was kept):"
    $duplicatesToDeleteFilepaths
    Write-Host "`n$($duplicatesToDeleteFilepaths.Count) duplicate image files deleted successfully"    
}

Remove-DuplicateImages -ImageRootDir "D:\Temp\photos-test\t"